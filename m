Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF0144072E
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 06:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhJ3EIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 00:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhJ3EIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 00:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A6B60187;
        Sat, 30 Oct 2021 04:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635566777;
        bh=63Sww3kyz2psfkmpu02ZAIufTQzGJvko/2vSo4ng9aM=;
        h=From:To:Cc:Subject:Date:From;
        b=N0R9o5Ao1OOYpqB8AM/XqbSF7hfGm4SzaWWw4WoDuxnGKkkuvmsVO4z1/btNmMJNG
         krbm4dOJ2XqbKZwfCsw92h82xhHHJsKH2BHcB3b6IrXaSYvlSfSRUL5OyhV2cZzCni
         ct4GjRxNx5VQ76wL7XC90ylta56d+4RRGCkLgpLdI6Kn4IbXNdD/AdvfNI9yMFK612
         nAhDkSqj+IhQRnTfRFHiVWRZsvB+HHwLZWHsHW14TyNE/A0hfaI+SkmKA+Pn+cxc5m
         e2N7ULsuwbng7I8zBHHQPp6Hq1TLb/9atRbGO+5wFtLODH588d0yQqblzaFc2c/Zpg
         ofBerSm5PM9Pw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leon@kernel.org,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] improve ethtool/rtnl vs devlink locking
Date:   Fri, 29 Oct 2021 21:06:07 -0700
Message-Id: <20211030040611.1751638-1-kuba@kernel.org>
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

Jakub Kicinski (4):
  ethtool: push the rtnl_lock into dev_ethtool()
  ethtool: handle info/flash data copying outside rtnl_lock
  devlink: expose get/put functions
  ethtool: don't drop the rtnl_lock half way thru the ioctl

 include/net/devlink.h |  16 ++++-
 net/core/dev_ioctl.c  |   2 -
 net/core/devlink.c    |  53 ++++-----------
 net/ethtool/ioctl.c   | 148 ++++++++++++++++++++++++++++++------------
 4 files changed, 134 insertions(+), 85 deletions(-)

-- 
2.31.1

