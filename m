Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3C145E4DC
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357653AbhKZCh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357599AbhKZCfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930DB611C1;
        Fri, 26 Nov 2021 02:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893933;
        bh=QicVnk/+pFxODno7VX0+Jxi1DZazIg02Of6LWM1Cch0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEK0JwsN1NL+rukPXmzX1xSdU3jDk08OrGKWyb7Gi+GPJh7qvG94vJA0YdrYnXuR1
         bNggFqG2ntD+f9bgHLOcyBcEBGTb7J8JOlLYnS4Y4L5qJv3T7XO0WnyxRMSnyXqC69
         8XfzBHyujMAg4yUjxuX7QcMVqk2UorMD0dXiizfkfRuF1mQIbKbzV3e+qJp6OEZ574
         +Gxg3VqTIRxhbJp4tZJaqd4F4Bp4V+qNM2mev8trrUAjXHnNT2T9Du69OttiYc7DD4
         JuwaeSNPMo41xRke+W/EAKFWi210EMN+ogGqs7bXsPs6JDR50IrWCrnjHN0k+2FYqi
         qZXTPYe4B9Y+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/39] tun: fix bonding active backup with arp monitoring
Date:   Thu, 25 Nov 2021 21:31:26 -0500
Message-Id: <20211126023156.441292-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
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
index fecc9a1d293ae..1572878c34031 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1010,6 +1010,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	int txq = skb->queue_mapping;
+	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
 
@@ -1054,6 +1055,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
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

