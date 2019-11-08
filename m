Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFA9F3CD6
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfKHA1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:36 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:39767 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfKHA1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:36 -0500
Received: by mail-pf1-f202.google.com with SMTP id l20so3302745pff.6
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i6lrO4RCQJoJb5MZpV9TLnE9dGHWjdDUX3k7hmorzYs=;
        b=KhnldxRie71fKficiKOaHDDkVbhuUV5HSx2SPhUmoWebUTxaEldAHPCZ8l+tRBbgdx
         LfCMy53gYN6cMXVjYNlEVMBk8gN/KxyPo2e6XJPGW1FMRMWvJD0I3qnxdDZWkFB9uvMO
         21BW2+R+LCMpYAvAETvIWnu5KlpeW8XoYO7gaK/T6mOJBUP163RWEX8hwpGNtBflCVCu
         VVWuzhksjzGX2d9Lzby1p7ytMXzW+KL5CDQs9gbhoQj67g0i9jtnY0YEOmGuOsLB9xIA
         rT8Ppsc/iR+aS4k2ajKXCyUYDyyHLA0YQC1ATBBKIuC3DzDBtAvsX8Jm9rhbmJbUkoyn
         JLYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i6lrO4RCQJoJb5MZpV9TLnE9dGHWjdDUX3k7hmorzYs=;
        b=U1A2X0hvgarvVqq9fjTbKFKXyyq8sbJyrmJrOUipMxNsBXmwlcj9/VgOHHaL92RYz1
         QBN3z708wVv9Ku2hnmHf+gYlk/HgS0oyJGxynGSwa1SN+TKY+7ly4AqoF9ijy3WYm6fZ
         grGAnP6Y20UagUrc8HojO7CB8bmqBen+UfsXrSdhjKNG81I6jH1QoRjDlKE5G5TiDW9I
         Ya/nF4pFXs8iaqzeK4s5LAeftQaX65gILHtAmH0kFZ/CeLIM2tTlb7Ab36CNLgUa3ScN
         xrIokkxTJQmDz1pnfNn45Q8tLLFQ3sBmN8TboWU67oRQANlTo7bR1hXFmQ8Lrq7flHtv
         NK6Q==
X-Gm-Message-State: APjAAAWnaaMqFm3S6FGwQvM8kDkq2Ps4eIgIg8BbMIBmKspodYMso1Gy
        yJNhHz7kMJdMEGfe34TWB5IiLgveTv6gNw==
X-Google-Smtp-Source: APXvYqyZbDw+I9IOA1PYZEfuiP5d/iYPW+E3Lqx22i/rzR8laUk3vmb22M86L0OBn+Q3NtWvLDLZvBtcegKi2w==
X-Received: by 2002:a65:678a:: with SMTP id e10mr8186411pgr.258.1573172853555;
 Thu, 07 Nov 2019 16:27:33 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:15 -0800
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
Message-Id: <20191108002722.129055-3-edumazet@google.com>
Mime-Version: 1.0
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 2/9] net: provide dev_lstats_add() helper
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many network drivers need it and hand-coded the same function.

In order to ease u64_stats_t adoption, it is time to factorize.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/loopback.c    | 12 ++----------
 include/linux/netdevice.h | 10 ++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 92336ac4c5e68f63b814d6a70e7361b8954a91cf..47ad2478b9f350f8bf3b103bd2a9a956379c75fa 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -68,7 +68,6 @@ EXPORT_SYMBOL(blackhole_netdev);
 static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 				 struct net_device *dev)
 {
-	struct pcpu_lstats *lb_stats;
 	int len;
 
 	skb_tx_timestamp(skb);
@@ -85,16 +84,9 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 
 	skb->protocol = eth_type_trans(skb, dev);
 
-	/* it's OK to use per_cpu_ptr() because BHs are off */
-	lb_stats = this_cpu_ptr(dev->lstats);
-
 	len = skb->len;
-	if (likely(netif_rx(skb) == NET_RX_SUCCESS)) {
-		u64_stats_update_begin(&lb_stats->syncp);
-		lb_stats->bytes += len;
-		lb_stats->packets++;
-		u64_stats_update_end(&lb_stats->syncp);
-	}
+	if (likely(netif_rx(skb) == NET_RX_SUCCESS))
+		dev_lstats_add(dev, len);
 
 	return NETDEV_TX_OK;
 }
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 75561992c31f7c32f5a50e3879bafb5a54bc5fa3..461a36220cf46d62114efac0c4fb2b7b9a2ee386 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2403,6 +2403,16 @@ struct pcpu_lstats {
 
 void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes);
 
+static inline void dev_lstats_add(struct net_device *dev, unsigned int len)
+{
+	struct pcpu_lstats *lstats = this_cpu_ptr(dev->lstats);
+
+	u64_stats_update_begin(&lstats->syncp);
+	lstats->bytes += len;
+	lstats->packets++;
+	u64_stats_update_end(&lstats->syncp);
+}
+
 #define __netdev_alloc_pcpu_stats(type, gfp)				\
 ({									\
 	typeof(type) __percpu *pcpu_stats = alloc_percpu_gfp(type, gfp);\
-- 
2.24.0.432.g9d3f5f5b63-goog

