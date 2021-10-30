Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC8D440A83
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 19:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhJ3RVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 13:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhJ3RVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 13:21:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0232860F9B;
        Sat, 30 Oct 2021 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635614333;
        bh=X/Tbhef28c3oP2IqHXHd7XWv/buEq3Vl96Nv8qEmo44=;
        h=From:To:Cc:Subject:Date:From;
        b=j72eU+qfoZJAUFdOEr0SicXNwlpgYGVjFNCQ9HuhFR0G/qQr55CETEZ22exsl6t+y
         +3CALSbETlAlYLt7F8dS7RgUiqYuOwaareGkRLBExnngChSFF3xFZqbIi7CmY4LtjL
         LDkZN3aCFHv9D9EZba1BeoNHHVS6o5TiwwfcjmNuFjB7E8hkFGKzRKbX93eT7kL9t2
         cda8nrrIFIQAJSkeR22QvDTCatvfE01/aVc/I5Dbyfq3tpEYz6P5WqmOhqYkLwqsHM
         iUibH3XGpGvpI0fQ/8OQd3kCTWpkuMZiH44krmrGCc/4Fxafy2b5J+P8aDHZW/ZG5e
         3ogJhRte/dD7g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leon@kernel.org,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/4] improve ethtool/rtnl vs devlink locking
Date:   Sat, 30 Oct 2021 10:18:47 -0700
Message-Id: <20211030171851.1822583-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During ethtool netlink development we decided to move some of
the commmands to devlink. Since we don't want drivers to implement
both devlink and ethtool version of the commands ethtool ioctl
falls back to calling devlink. Unfortunately devlink locks must
be taken before rtnl_lock. This results in a questionable
dev_hold() / rtnl_unlock() / devlink / rtnl_lock() / dev_put()
pattern.

This method "works" but it working depends on drivers in question
not doing much in ethtool_ops->begin / complete, and on the netdev
not having needs_free_netdev set.

Since commit 437ebfd90a25 ("devlink: Count struct devlink consumers")
we can hold a reference on a devlink instance and prevent it from
going away (sort of like netdev with dev_hold()). We can use this
to create a more natural reference nesting where we get a ref on
the devlink instance and make the devlink call entirely outside
of the rtnl_lock section.

v2: remember to update the static inline stubs as well (kbuild bot)

Jakub Kicinski (4):
  ethtool: push the rtnl_lock into dev_ethtool()
  ethtool: handle info/flash data copying outside rtnl_lock
  devlink: expose get/put functions
  ethtool: don't drop the rtnl_lock half way thru the ioctl

 include/net/devlink.h |  20 ++++--
 net/core/dev_ioctl.c  |   2 -
 net/core/devlink.c    |  53 ++++-----------
 net/ethtool/ioctl.c   | 148 ++++++++++++++++++++++++++++++------------
 4 files changed, 136 insertions(+), 87 deletions(-)


base-commit: ae0393500e3b0139210749d52d22b29002c20e16
-- 
2.31.1

