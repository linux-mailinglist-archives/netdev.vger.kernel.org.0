Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613E045E5DB
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358689AbhKZCpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358693AbhKZCn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:43:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40FF861268;
        Fri, 26 Nov 2021 02:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894137;
        bh=snKzOfYzg5rGBdcC9iHEAIqQO6YtlCGw0huCLqTu+ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNz2CqKKFUHD3lhk+m1p/gz5vhsUHsUMW7VQQFw7O5dwSUZdsn93AyCYVdrn0dR3S
         vKsvXWa4VVydUucQSM+shmtyfik2lib70NB7Y0E2fVAT6LvqGqOWR+nq8fTX1EDEHC
         hiDOY5tFMLQTTgCzpC1GeFO11pPojUYTySy8N0mRCecI87v5ylasg2tQanBkvc/nhI
         0Z7RavenOK03Z8qJc76/hDpN4A/MaSU2CHn4098lG9VttfT8/Nnf5kaJAenaY9aSny
         Et6LhRUk5DcPDmoBzRKuqIyjRSleo6TwE6jJcrG1wwJna9Q+Ox3yOeDnqPWaBLOaHj
         DeWzyTVnDvnbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/15] tun: fix bonding active backup with arp monitoring
Date:   Thu, 25 Nov 2021 21:35:20 -0500
Message-Id: <20211126023533.442895-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023533.442895-1-sashal@kernel.org>
References: <20211126023533.442895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit a31d27fbed5d518734cb60956303eb15089a7634 ]

As stated in the bonding doc, trans_start must be set manually for drivers
using NETIF_F_LLTX:
 Drivers that use NETIF_F_LLTX flag must also update
 netdev_queue->trans_start. If they do not, then the ARP monitor will
 immediately fail any slaves using that driver, and those slaves will stay
 down.

Link: https://www.kernel.org/doc/html/v5.15/networking/bonding.html#arp-monitor-operation
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8ee2c519c9bf0..d5bb972cbc9a6 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1085,6 +1085,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	int txq = skb->queue_mapping;
+	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
 
@@ -1131,6 +1132,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (ptr_ring_produce(&tfile->tx_ring, skb))
 		goto drop;
 
+	/* NETIF_F_LLTX requires to do our own update of trans_start */
+	queue = netdev_get_tx_queue(dev, txq);
+	queue->trans_start = jiffies;
+
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
 		kill_fasync(&tfile->fasync, SIGIO, POLL_IN);
-- 
2.33.0

