Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BAB650221
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbiLRQmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiLRQlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:41:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE9DEE1C;
        Sun, 18 Dec 2022 08:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2D7560C99;
        Sun, 18 Dec 2022 16:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A31BC433D2;
        Sun, 18 Dec 2022 16:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380082;
        bh=qp7B+F3bAXjUgqB7rewPe3vD9GL/v8171nFNDWQ4BOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWHCXQo/PX5zqazvl9wCgMIM8xuHAuhHOipjqXON/xwTsV2mjwk2mFM9eHR99qDy5
         bq6r5sOw6uAWsLoAiAmHrQc02z9r6Jj8iMs6iLAMuYB6YRxyaE1feb33g1NDixtIqC
         4p6aqXR02q6GDhNitDVq88fAp5Ih70KJCopz9FoCMRHOj9x2UjggTSUpoNL+nMC4Y/
         n0Qv5DFD1zYIUhtgWa0N0jgD8cLPJiAsznE4tjWO6QVchtjp49Aug7u1UpOMoJF85o
         TDRUG5U2Wl/AQo9r8hiidnWR1+RDf1PCb5X0SDj1XTZSzcftYf8gHaRyY5U1mVVmGU
         j2F5aiel/nfgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, bigeasy@linutronix.de, imagedong@tencent.com,
        kuniyu@amazon.com, petrm@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 28/46] net: add atomic_long_t to net_device_stats fields
Date:   Sun, 18 Dec 2022 11:12:26 -0500
Message-Id: <20221218161244.930785-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6c1c5097781f563b70a81683ea6fdac21637573b ]

Long standing KCSAN issues are caused by data-race around
some dev->stats changes.

Most performance critical paths already use per-cpu
variables, or per-queue ones.

It is reasonable (and more correct) to use atomic operations
for the slow paths.

This patch adds an union for each field of net_device_stats,
so that we can convert paths that are not yet protected
by a spinlock or a mutex.

netdev_stats_to_stats64() no longer has an #if BITS_PER_LONG==64

Note that the memcpy() we were using on 64bit arches
had no provision to avoid load-tearing,
while atomic_long_read() is providing the needed protection
at no cost.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 58 +++++++++++++++++++++++----------------
 include/net/dst.h         |  5 ++--
 net/core/dev.c            | 14 ++--------
 3 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3b97438afe3e..3a75d644a120 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -167,31 +167,38 @@ static inline bool dev_xmit_complete(int rc)
  *	(unsigned long) so they can be read and written atomically.
  */
 
+#define NET_DEV_STAT(FIELD)			\
+	union {					\
+		unsigned long FIELD;		\
+		atomic_long_t __##FIELD;	\
+	}
+
 struct net_device_stats {
-	unsigned long	rx_packets;
-	unsigned long	tx_packets;
-	unsigned long	rx_bytes;
-	unsigned long	tx_bytes;
-	unsigned long	rx_errors;
-	unsigned long	tx_errors;
-	unsigned long	rx_dropped;
-	unsigned long	tx_dropped;
-	unsigned long	multicast;
-	unsigned long	collisions;
-	unsigned long	rx_length_errors;
-	unsigned long	rx_over_errors;
-	unsigned long	rx_crc_errors;
-	unsigned long	rx_frame_errors;
-	unsigned long	rx_fifo_errors;
-	unsigned long	rx_missed_errors;
-	unsigned long	tx_aborted_errors;
-	unsigned long	tx_carrier_errors;
-	unsigned long	tx_fifo_errors;
-	unsigned long	tx_heartbeat_errors;
-	unsigned long	tx_window_errors;
-	unsigned long	rx_compressed;
-	unsigned long	tx_compressed;
+	NET_DEV_STAT(rx_packets);
+	NET_DEV_STAT(tx_packets);
+	NET_DEV_STAT(rx_bytes);
+	NET_DEV_STAT(tx_bytes);
+	NET_DEV_STAT(rx_errors);
+	NET_DEV_STAT(tx_errors);
+	NET_DEV_STAT(rx_dropped);
+	NET_DEV_STAT(tx_dropped);
+	NET_DEV_STAT(multicast);
+	NET_DEV_STAT(collisions);
+	NET_DEV_STAT(rx_length_errors);
+	NET_DEV_STAT(rx_over_errors);
+	NET_DEV_STAT(rx_crc_errors);
+	NET_DEV_STAT(rx_frame_errors);
+	NET_DEV_STAT(rx_fifo_errors);
+	NET_DEV_STAT(rx_missed_errors);
+	NET_DEV_STAT(tx_aborted_errors);
+	NET_DEV_STAT(tx_carrier_errors);
+	NET_DEV_STAT(tx_fifo_errors);
+	NET_DEV_STAT(tx_heartbeat_errors);
+	NET_DEV_STAT(tx_window_errors);
+	NET_DEV_STAT(rx_compressed);
+	NET_DEV_STAT(tx_compressed);
 };
+#undef NET_DEV_STAT
 
 
 #include <linux/cache.h>
@@ -5477,4 +5484,9 @@ extern struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 
 extern struct net_device *blackhole_netdev;
 
+/* Note: Avoid these macros in fast path, prefer per-cpu or per-queue counters. */
+#define DEV_STATS_INC(DEV, FIELD) atomic_long_inc(&(DEV)->stats.__##FIELD)
+#define DEV_STATS_ADD(DEV, FIELD, VAL) 	\
+		atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
+
 #endif	/* _LINUX_NETDEVICE_H */
diff --git a/include/net/dst.h b/include/net/dst.h
index a057319aabef..17697ec79949 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -361,9 +361,8 @@ static inline void __skb_tunnel_rx(struct sk_buff *skb, struct net_device *dev,
 static inline void skb_tunnel_rx(struct sk_buff *skb, struct net_device *dev,
 				 struct net *net)
 {
-	/* TODO : stats should be SMP safe */
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += skb->len;
+	DEV_STATS_INC(dev, rx_packets);
+	DEV_STATS_ADD(dev, rx_bytes, skb->len);
 	__skb_tunnel_rx(skb, dev, net);
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index be51644e95da..33d6b691e15e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10640,24 +10640,16 @@ void netdev_run_todo(void)
 void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats)
 {
-#if BITS_PER_LONG == 64
-	BUILD_BUG_ON(sizeof(*stats64) < sizeof(*netdev_stats));
-	memcpy(stats64, netdev_stats, sizeof(*netdev_stats));
-	/* zero out counters that only exist in rtnl_link_stats64 */
-	memset((char *)stats64 + sizeof(*netdev_stats), 0,
-	       sizeof(*stats64) - sizeof(*netdev_stats));
-#else
-	size_t i, n = sizeof(*netdev_stats) / sizeof(unsigned long);
-	const unsigned long *src = (const unsigned long *)netdev_stats;
+	size_t i, n = sizeof(*netdev_stats) / sizeof(atomic_long_t);
+	const atomic_long_t *src = (atomic_long_t *)netdev_stats;
 	u64 *dst = (u64 *)stats64;
 
 	BUILD_BUG_ON(n > sizeof(*stats64) / sizeof(u64));
 	for (i = 0; i < n; i++)
-		dst[i] = src[i];
+		dst[i] = atomic_long_read(&src[i]);
 	/* zero out counters that only exist in rtnl_link_stats64 */
 	memset((char *)stats64 + n * sizeof(u64), 0,
 	       sizeof(*stats64) - n * sizeof(u64));
-#endif
 }
 EXPORT_SYMBOL(netdev_stats_to_stats64);
 
-- 
2.35.1

