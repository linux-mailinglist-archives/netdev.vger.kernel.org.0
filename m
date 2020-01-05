Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E0D1309F7
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 22:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgAEVRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 16:17:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:50002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbgAEVRB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 16:17:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 89988AE07;
        Sun,  5 Jan 2020 21:16:58 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DBDB4E048B; Sun,  5 Jan 2020 22:16:56 +0100 (CET)
Message-Id: <cover.1578257976.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 0/3] ethtool: allow nesting of begin() and complete()
 callbacks
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Francois Romieu <romieu@fr.zoreil.com>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Sun,  5 Jan 2020 22:16:56 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool ioctl interface used to guarantee that ethtool_ops callbacks
were always called in a block between calls to ->begin() and ->complete()
(if these are defined) and that this whole block was executed with RTNL
lock held:

	rtnl_lock();
	ops->begin();
	/* other ethtool_ops calls */
	ops->complete();
	rtnl_unlock();

This prevented any nesting or crossing of the begin-complete blocks.
However, this is no longer guaranteed even for ioctl interface as at least
ethtool_phys_id() releases RTNL lock while waiting for a timer. With the
introduction of netlink ethtool interface, the begin-complete pairs are
naturally nested e.g. when a request triggers a netlink notification.

Fortunately, only minority of networking drivers implements begin() and
complete() callbacks and most of those that do, fall into three groups:

  - wrappers for pm_runtime_get_sync() and pm_runtime_put()
  - wrappers for clk_prepare_enable() and clk_disable_unprepare()
  - begin() checks netif_running() (fails if false), no complete()

First two have their own refcounting, third is safe w.r.t. nesting of the
blocks.

Only three in-tree networking drivers need an update to deal with nesting
of begin() and complete() calls: via-velocity and epic100 perform resume
and suspend on their own and wil6210 completely serializes the calls using
its own mutex (which would lead to a deadlock if a request request
triggered a netlink notification). The series addresses these problems.


Michal Kubecek (3):
  wil6210: get rid of begin() and complete() ethtool_ops
  via-velocity: allow nesting of ethtool_ops begin() and complete()
  epic100: allow nesting of ethtool_ops begin() and complete()

 drivers/net/ethernet/smsc/epic100.c        |  7 +++-
 drivers/net/ethernet/via/via-velocity.c    | 14 +++++--
 drivers/net/ethernet/via/via-velocity.h    |  1 +
 drivers/net/wireless/ath/wil6210/ethtool.c | 43 ++++++++--------------
 4 files changed, 32 insertions(+), 33 deletions(-)

-- 
2.24.1

