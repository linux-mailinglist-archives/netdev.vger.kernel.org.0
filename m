Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ECA45E54B
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358474AbhKZClV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:41:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358266AbhKZCjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:39:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0876121D;
        Fri, 26 Nov 2021 02:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894034;
        bh=QKHMaEia/GpEty3AWKF4r7oPrNAGBgAdiI1U0JuDfrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovgQdci2AysvhpgVpfFdOrsD/1sU5KWugzYtYQv9+abybqxbiQ6UT43eWdYcYDR7J
         0UAFcEv0d9YhAl1kkir/fjv4Inu5waDyV6+AsS9+UQjjSldOxYSHtDYIYHmj3vKNKt
         7+97vYNfqx0glpLl/4BVrEOYh+VnF2NxEzI4ZE/NdM2KhMWDyMXHkWch08zT6AHqzw
         nY9NDp3aVd1Vv1QwHFz4xplCJFm39/f5ds+9LWgR14F06LM4hiNPaLkYqB93wARM4n
         Ny5IwCRhD76+SwaBNlJCiEGBk4TW4z8FIbOELS7Q5LgxSx6qAXNx7JxNozA+G28Nx2
         ynh1DuGR5Sekw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/28] tun: fix bonding active backup with arp monitoring
Date:   Thu, 25 Nov 2021 21:33:21 -0500
Message-Id: <20211126023343.442045-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
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
index c671d8e257741..ffbc7eda95eed 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1021,6 +1021,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	int txq = skb->queue_mapping;
+	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
 
@@ -1065,6 +1066,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
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

