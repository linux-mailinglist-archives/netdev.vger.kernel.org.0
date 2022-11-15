Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCED66293A2
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbiKOIyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiKOIyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:54:04 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0221DDF1F
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:03 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h67-20020a252146000000b006ccc4702068so12794678ybh.12
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uyUf71Shwhrz8sqxKiMFjDrXVGXI/uHIGmLCNeJPnws=;
        b=O9Rns9r511xsPguMxVMNf95evP868pKa46EeytlWqw+wDe/r9HvSAMI7Z4NBVyqjum
         hglDnvCPE+zF8OZvCjx4UvbpMB0qLa0ebg2Ujn5gxR/x/fCqTvghxOBwKrJmObJqewmR
         J9zjuxmmfdqP4OrRwnZtBMjY1mvjlXXW4iDykf5Kv+YCyCv28EnRtHTCcxhftNLxeW1p
         jcjc618aPFiCew1v92NC1IGiec608+EDoCH0rcoN+AuJje/RjdtFx8R712dTZrAZyO9t
         0i9kU7tlaPhr9xh0zSM6I/Vc1IEIPJjm79NAcd8ekKibFahewapL+9JNtBhCy9a/tVnY
         Zm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uyUf71Shwhrz8sqxKiMFjDrXVGXI/uHIGmLCNeJPnws=;
        b=mol4fa8QO+VXadaWxeydg1g07TOYm76UxSYEKRO4Q1WYinAG88HO2gqZZgA/BiLSzm
         qs5eQrfS+DfT+3mIZgCcAM/vFoz86+EzBEQIdMkP/IuZrh8TVexCgdy/HE7Q6g8oQiyb
         6mI7zSFoGZYevxGvfjNos37LKZBJmG6/rt4cPq+PWTOFUM6kXFYE6KkHPKy+t55GfjVC
         rJ0U9Exxvg069rmxhoyQct2kmv2jjZcBN49vRyk+BO0j9DYALTRYxcuAfuDpr035IluZ
         hPLiXw8P6g0uSPf3nUcGlyBTym4JvdLvOYTJP2nXe4UG4yKO6jxrmaSrfL8ZQM60sORP
         k83A==
X-Gm-Message-State: ACrzQf3qbf1vrL5ZOejgSoBQohlmYkHY27AhCAWtj8+xqaQhXOAPo6cJ
        osLrwS9ueWoJg7evl9CV/d9omBEuwPteyA==
X-Google-Smtp-Source: AMsMyM4RnwwnFCGknxgqK/IeaO7kyr0j959tGRadotg7l+Yh7tWnkmH9tCdcL47x0yyS++NW44hwpYdmq/VqKg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:6143:0:b0:335:3076:168e with SMTP id
 v64-20020a816143000000b003353076168emr63997603ywb.460.1668502441771; Tue, 15
 Nov 2022 00:54:01 -0800 (PST)
Date:   Tue, 15 Nov 2022 08:53:55 +0000
In-Reply-To: <20221115085358.2230729-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115085358.2230729-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115085358.2230729-2-edumazet@google.com>
Subject: [PATCH net-next 1/4] net: add atomic_long_t to net_device_stats fields
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 include/linux/netdevice.h | 58 +++++++++++++++++++++++----------------
 include/net/dst.h         |  5 ++--
 net/core/dev.c            | 14 ++--------
 3 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 02a2318da7c7059ff2479479f4b9777a414fa591..23b3903b067840248dec7a75515125ff1ff577f5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -171,31 +171,38 @@ static inline bool dev_xmit_complete(int rc)
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
 
 /* per-cpu stats, allocated on demand.
  * Try to fit them in a single cache line, for dev_get_stats() sake.
@@ -5171,4 +5178,9 @@ extern struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 
 extern struct net_device *blackhole_netdev;
 
+/* Note: Avoid these macros in fast path, prefer per-cpu or per-queue counters. */
+#define DEV_STATS_INC(DEV, FIELD) atomic_long_inc(&(DEV)->stats.__##FIELD)
+#define DEV_STATS_ADD(DEV, FIELD, VAL) 	\
+		atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
+
 #endif	/* _LINUX_NETDEVICE_H */
diff --git a/include/net/dst.h b/include/net/dst.h
index 00b479ce6b99c9b329a30f8201882a51c9a135a9..d67fda89cd0fabb887c8f95222f531b7fb470a59 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -356,9 +356,8 @@ static inline void __skb_tunnel_rx(struct sk_buff *skb, struct net_device *dev,
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
index 117e830cabb0787ecd3da13bd88f8818fddaddc1..664fe4fcb1cb18fc25db2dc3e280e5575c6552ed 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10381,24 +10381,16 @@ void netdev_run_todo(void)
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
2.38.1.431.g37b22c650d-goog

