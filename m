Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC559F3CD5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfKHA1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:31 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:37060 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfKHA1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:31 -0500
Received: by mail-pl1-f201.google.com with SMTP id w17so2933523plp.4
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nZMEjjcnKACqdplzwDpCNbTo8+LaUR5kWADZkVNAhvI=;
        b=HWKUwd93PuNAw7Cxjcg52+3e9tFpjjQsDLJnLm+IAZ6uj6PEv7dmkdLx7mRTRtZVJE
         sC/MqtXl12mct7mX9sb49lKyMax9y5pyPeROLjf6S7Tz6hSZd+LsgwAzk1hL2WiQmQ8E
         jvcu3Vn5Cp86g6bu8ei6SI9Dw+i5Ti2c5q9DYL9DpoApmAj1LLFbVTTJwdKkX/XaXUhE
         pAZ602LnIZcpDoVvF5rpVH9MDwp66Yy6ZuDVKDZixDLL+agAPlTArlyr7CgptCfi35WP
         stcOmncJLLL1IPxDryHoDIbF+72JxqXFn8bg+QvftCqtngDiRUuXrL88c+AwtCjx5K0X
         5eEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nZMEjjcnKACqdplzwDpCNbTo8+LaUR5kWADZkVNAhvI=;
        b=JblF6WhrUZ5frKOQr5E49tNydyeJRma0hCjIZVi57/JCrgGuHYrb2Cu0oGkvv2m8X/
         BFDy2WF6/LQg1KCxi7pwn9oHJF2+POUdkJ6mdGcHZ3R/Z5Ax7sG4D2iZ1zkQ345F4Wy6
         GfIxhbuadw9YtIgpCJEH/ERzBvRSaEyZ4i+9HS71XAEwS4tHXfM/LjFkTnG9CTtUZAnq
         iQoiNHQ0Af1qHlwlsLYjZ2WhwpSsqsSVNVhe0cklCeTza07Vu3aKZ/zlz0jcf6BcNzB2
         Tv1YDR9fQGeg9E3606YsVGEEa49LbTSYrcFknP3CXTHxxIQHjv6A2Rl86VOqGAk9RgVQ
         qRcQ==
X-Gm-Message-State: APjAAAWTov9OMJYzp9T4arnm93lX6YeX+N2ATOsIOPIHOz9u9YR/eT6y
        OqGrQDkzdvs+mSrrb04koF1pw2vCAP/3Gg==
X-Google-Smtp-Source: APXvYqz55iuqG5TmG7GT4tbw5MGMKpgr2SXpzuuBOm8J2F8zJlYyHaLCmI9N/uQKkNQ7b5IQCcLprnqXiGWWAA==
X-Received: by 2002:a63:fe50:: with SMTP id x16mr8407548pgj.37.1573172850064;
 Thu, 07 Nov 2019 16:27:30 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:14 -0800
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
Message-Id: <20191108002722.129055-2-edumazet@google.com>
Mime-Version: 1.0
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 1/9] net: provide dev_lstats_read() helper
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

Many network drivers use hand-coded implementation of the same thing,
let's factorize things so that u64_stats_t adoption is done once.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/loopback.c    | 24 +++++++++++++++++-------
 include/linux/netdevice.h |  2 ++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 14545a8797a8a2c9b61abc96cbdb1a3542481745..92336ac4c5e68f63b814d6a70e7361b8954a91cf 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -99,13 +99,13 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-static void loopback_get_stats64(struct net_device *dev,
-				 struct rtnl_link_stats64 *stats)
+void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes)
 {
-	u64 bytes = 0;
-	u64 packets = 0;
 	int i;
 
+	*packets = 0;
+	*bytes = 0;
+
 	for_each_possible_cpu(i) {
 		const struct pcpu_lstats *lb_stats;
 		u64 tbytes, tpackets;
@@ -114,12 +114,22 @@ static void loopback_get_stats64(struct net_device *dev,
 		lb_stats = per_cpu_ptr(dev->lstats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&lb_stats->syncp);
-			tbytes = lb_stats->bytes;
 			tpackets = lb_stats->packets;
+			tbytes = lb_stats->bytes;
 		} while (u64_stats_fetch_retry_irq(&lb_stats->syncp, start));
-		bytes   += tbytes;
-		packets += tpackets;
+		*bytes   += tbytes;
+		*packets += tpackets;
 	}
+}
+EXPORT_SYMBOL(dev_lstats_read);
+
+static void loopback_get_stats64(struct net_device *dev,
+				 struct rtnl_link_stats64 *stats)
+{
+	u64 packets, bytes;
+
+	dev_lstats_read(dev, &packets, &bytes);
+
 	stats->rx_packets = packets;
 	stats->tx_packets = packets;
 	stats->rx_bytes   = bytes;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1f140a6b66dfbd1dd86d2d6b0e0adb812de4b243..75561992c31f7c32f5a50e3879bafb5a54bc5fa3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2401,6 +2401,8 @@ struct pcpu_lstats {
 	struct u64_stats_sync syncp;
 } __aligned(2 * sizeof(u64));
 
+void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes);
+
 #define __netdev_alloc_pcpu_stats(type, gfp)				\
 ({									\
 	typeof(type) __percpu *pcpu_stats = alloc_percpu_gfp(type, gfp);\
-- 
2.24.0.432.g9d3f5f5b63-goog

