Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388C6283BC6
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgJEP6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgJEP6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 11:58:06 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A3820663;
        Mon,  5 Oct 2020 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601913485;
        bh=mkC/f5SXv7O23F7vfAgn0hXHuP+NrwNgARZVltQ43QU=;
        h=From:To:Cc:Subject:Date:From;
        b=k/ioDT+NPmxfz6aV7rGED/qghEqxepcvu4TKSRiEJz+N7JpJXwtn/b669him7wWjY
         lleGiyYTujDSiiAPT2Ap2h8c1KqpVBGfTIoFBKb58Ob5iukK0j0erL/7QYHSJn7MLn
         hFF0ObM5m4anQ5PH7/2GKGt+oxavzRE4iisa9Txk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] ethtool: allow dumping policies to user space
Date:   Mon,  5 Oct 2020 08:57:47 -0700
Message-Id: <20201005155753.2333882-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series wires up ethtool policies to ops, so they can be
dumped to user space for feature discovery.

First two patches wire up GET, third patch wires up SET.

Next - take care of linking up nested policies for the header
(which is what we actually care about right now). And once header
policy is linked make sure that attribute range validation is
done by policy, not code conditions for flags. New type of
policy is needed to validate masks (patch 5).

Netlink as always staying a step ahead of all the other kernel
API interfaces :)

Jakub Kicinski (6):
  ethtool: wire up get policies to ops
  ethtool: use the attributes parsed by the core in get commands
  ethtool: wire up set policies to ops
  ethtool: link up ethnl_header_policy as a nested policy
  netlink: add mask validation
  ethtool: specify which header flags are supported per command

 include/net/netlink.h        |  11 ++++
 include/uapi/linux/netlink.h |   2 +
 lib/nlattr.c                 |  36 ++++++++++
 net/ethtool/cabletest.c      |  30 +++------
 net/ethtool/channels.c       |  22 +++----
 net/ethtool/coalesce.c       |  22 +++----
 net/ethtool/debug.c          |  20 ++----
 net/ethtool/eee.c            |  21 +++---
 net/ethtool/features.c       |  22 +++----
 net/ethtool/linkinfo.c       |  22 +++----
 net/ethtool/linkmodes.c      |  22 +++----
 net/ethtool/linkstate.c      |   8 +--
 net/ethtool/netlink.c        | 123 +++++++++++++++++++++++++----------
 net/ethtool/netlink.h        |  33 +++++++++-
 net/ethtool/pause.c          |  19 ++----
 net/ethtool/privflags.c      |  22 +++----
 net/ethtool/rings.c          |  20 ++----
 net/ethtool/strset.c         |   6 +-
 net/ethtool/tsinfo.c         |   7 +-
 net/ethtool/tunnels.c        |  42 +++++-------
 net/ethtool/wol.c            |  19 ++----
 net/netlink/policy.c         |   8 +++
 22 files changed, 303 insertions(+), 234 deletions(-)

-- 
2.26.2

