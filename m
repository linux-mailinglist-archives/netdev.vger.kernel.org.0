Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87C745E59E
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358092AbhKZCns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:43:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358538AbhKZClp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:41:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A8BD61261;
        Fri, 26 Nov 2021 02:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894095;
        bh=JrM9zj3hONhXelj0jtA/coI2x9bRFO+tktCeS7hzepc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMU+OJ9SxE6p1bEtnm9cEUxtJXmlx5Gbwjmjo/j9z5t7M1O+YCsNK0LEaRNiGOxvL
         8Zy2ouD9XrbsAAp2oyAOTX60nIo34CSFN05jf5XpjR1XdK4xSJJCn/kYcoSamAxbvA
         WIkNHRvXknbAwlcrfQitZW3jQ0dQzvZ4Cik+Y3+QkHTlKUs1C/UZEHfC1Ol1CtiOZm
         hNnQ3ujpkUKkVVVM2BXFiWxxjQCh3lkz3FPEBN8yAZjGdJ0/DD5hRrjdufvCEhQMY/
         jeJMKWhP9zvOCMQtQL9QHI+oZJVxjyLs0sOkI6+57a5o0hZKxqg1ZVzA0QyADO9ZvN
         ir1NeDgSohdHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/19] tun: fix bonding active backup with arp monitoring
Date:   Thu, 25 Nov 2021 21:34:33 -0500
Message-Id: <20211126023448.442529-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
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
index 7c40ae058e6d1..10211ea605140 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1071,6 +1071,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	int txq = skb->queue_mapping;
+	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
 
@@ -1117,6 +1118,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
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

