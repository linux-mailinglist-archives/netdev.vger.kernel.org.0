Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E246846FC02
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhLJHsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhLJHsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:48:10 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4870C0617A1
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 23:44:35 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id m15so7331427pgu.11
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 23:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EyiZShlNa9HiYHV04ij1CyrCPpyTRIlbowveSAsCv4s=;
        b=qckN8bhoNYkVL7vO4e2cT3Uz5jW+TIbpyKG8WxwFfPWuM5Af09HlMouYiX8ZeJYY6S
         l91XBpal4rb9pFJ3iiCOYy0ugWkLNL9MIFkgjoijIOrIk2G9GU1O35dXXvblqOJb5lyQ
         vI+mb21TirEs06a1obgjN2X8IyP9J/gXsC2G4J1NhZR8q7XB8nWL92Z3EH3Ok4TOSaG8
         ev+DlgW2GMX83dIVq3c1LV3iwm000qI4sIEy834/yCRIQY0xmzSRG56A6IpA5sHQdJAS
         ruc5bdh7iDxxADl9pppSONIUfDcZRu9GT8FHmIoWbeiN6V1tjE4nuCEAneyDSwy/G/Fd
         L80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EyiZShlNa9HiYHV04ij1CyrCPpyTRIlbowveSAsCv4s=;
        b=g/LzwrY6vcHpdoX3k+9hLmccsdg7PYeZoKcw8htrLWO5YBvYWklQaO5iO81lXr10Wr
         bGXwUNvzoY7eSxoAYH1pewWjqpSeWGT/Yo8o919k72FYJ7gOp4eQAgtlpV6uyQp6OKPC
         CgjnqVEWGeT+riEF+m+foNi0UvkoRVz+bDz5EXIw516vlKqZzxx+3SOKe8LgcrzqFoqA
         3OWKVc4a8VSPmlOq20QtPd/ikUWJnGBAeeTdaC/JkOTEWWcRic8lXCH/5vwsaaYkp80l
         oKpRNvC3QXO4hAyKDj3v8KL85QO5j+nLwdUxR/AsvV/BzF60NdHIN3ilMOmfOHNzuzuy
         AbJw==
X-Gm-Message-State: AOAM530Xk+A3cl6w4oZtn3NLY76Cx9A7p0Wsaa9zwtt94PRUZFEf/7Dh
        9Rpat6rK4r6mcA8pth21cQc=
X-Google-Smtp-Source: ABdhPJxp/T06IGNrsXkrAi2HOaMOjDcviKWy8Pnk93ZRj6q6HNwXn6kFqUCWM+rJ4UQCO7EHA1uF+A==
X-Received: by 2002:a63:8541:: with SMTP id u62mr37598307pgd.130.1639122275362;
        Thu, 09 Dec 2021 23:44:35 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4f5:a6b4:3889:ebe5])
        by smtp.gmail.com with ESMTPSA id y12sm2001346pfe.140.2021.12.09.23.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 23:44:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH V2 net-next 1/6] net: add networking namespace refcount tracker
Date:   Thu,  9 Dec 2021 23:44:21 -0800
Message-Id: <20211210074426.279563-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211210074426.279563-1-eric.dumazet@gmail.com>
References: <20211210074426.279563-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We have 100+ syzbot reports about netns being dismantled too soon,
still unresolved as of today.

We think a missing get_net() or an extra put_net() is the root cause.

In order to find the bug(s), and be able to spot future ones,
this patch adds CONFIG_NET_NS_REFCNT_TRACKER and new helpers
to precisely pair all put_net() with corresponding get_net().

To use these helpers, each data structure owning a refcount
should also use a "netns_tracker" to pair the get and put.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h   |  9 +--------
 include/net/net_namespace.h | 34 ++++++++++++++++++++++++++++++++++
 include/net/net_trackers.h  | 18 ++++++++++++++++++
 net/Kconfig.debug           |  9 +++++++++
 net/core/net_namespace.c    |  3 +++
 5 files changed, 65 insertions(+), 8 deletions(-)
 create mode 100644 include/net/net_trackers.h

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a748ee9a421a7dee49f2b78a04976d6a5c80925..235d5d082f1a446c8d898ffcc5b1983df7c04f35 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -48,7 +48,7 @@
 #include <uapi/linux/pkt_cls.h>
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
-#include <linux/ref_tracker.h>
+#include <net/net_trackers.h>
 
 struct netpoll_info;
 struct device;
@@ -300,13 +300,6 @@ enum netdev_state_t {
 	__LINK_STATE_TESTING,
 };
 
-
-#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
-typedef struct ref_tracker *netdevice_tracker;
-#else
-typedef struct {} netdevice_tracker;
-#endif
-
 struct gro_list {
 	struct list_head	list;
 	int			count;
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index bb5fa59140321ba7c1826f5f4492e5cb607fd99f..5b61c462e534be468c81d2b0f4ef586b209dd4b8 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -34,6 +34,7 @@
 #include <net/netns/smc.h>
 #include <net/netns/bpf.h>
 #include <net/netns/mctp.h>
+#include <net/net_trackers.h>
 #include <linux/ns_common.h>
 #include <linux/idr.h>
 #include <linux/skbuff.h>
@@ -87,6 +88,7 @@ struct net {
 	struct idr		netns_ids;
 
 	struct ns_common	ns;
+	struct ref_tracker_dir  refcnt_tracker;
 
 	struct list_head 	dev_base_head;
 	struct proc_dir_entry 	*proc_net;
@@ -240,6 +242,7 @@ void ipx_unregister_sysctl(void);
 #ifdef CONFIG_NET_NS
 void __put_net(struct net *net);
 
+/* Try using get_net_track() instead */
 static inline struct net *get_net(struct net *net)
 {
 	refcount_inc(&net->ns.count);
@@ -258,6 +261,7 @@ static inline struct net *maybe_get_net(struct net *net)
 	return net;
 }
 
+/* Try using put_net_track() instead */
 static inline void put_net(struct net *net)
 {
 	if (refcount_dec_and_test(&net->ns.count))
@@ -308,6 +312,36 @@ static inline int check_net(const struct net *net)
 #endif
 
 
+static inline void netns_tracker_alloc(struct net *net,
+				       netns_tracker *tracker, gfp_t gfp)
+{
+#ifdef CONFIG_NET_NS_REFCNT_TRACKER
+	ref_tracker_alloc(&net->refcnt_tracker, tracker, gfp);
+#endif
+}
+
+static inline void netns_tracker_free(struct net *net,
+				      netns_tracker *tracker)
+{
+#ifdef CONFIG_NET_NS_REFCNT_TRACKER
+       ref_tracker_free(&net->refcnt_tracker, tracker);
+#endif
+}
+
+static inline struct net *get_net_track(struct net *net,
+					netns_tracker *tracker, gfp_t gfp)
+{
+	get_net(net);
+	netns_tracker_alloc(net, tracker, gfp);
+	return net;
+}
+
+static inline void put_net_track(struct net *net, netns_tracker *tracker)
+{
+	netns_tracker_free(net, tracker);
+	put_net(net);
+}
+
 typedef struct {
 #ifdef CONFIG_NET_NS
 	struct net *net;
diff --git a/include/net/net_trackers.h b/include/net/net_trackers.h
new file mode 100644
index 0000000000000000000000000000000000000000..d94c76cf15a9df918441b8ab4ed20422059f7ed9
--- /dev/null
+++ b/include/net/net_trackers.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_NET_TRACKERS_H
+#define __NET_NET_TRACKERS_H
+#include <linux/ref_tracker.h>
+
+#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+typedef struct ref_tracker *netdevice_tracker;
+#else
+typedef struct {} netdevice_tracker;
+#endif
+
+#ifdef CONFIG_NET_NS_REFCNT_TRACKER
+typedef struct ref_tracker *netns_tracker;
+#else
+typedef struct {} netns_tracker;
+#endif
+
+#endif /* __NET_NET_TRACKERS_H */
diff --git a/net/Kconfig.debug b/net/Kconfig.debug
index fb5c70e01cb3b6f86afce9a9f0aa8f8d7468e1fe..2f50611df858911cf5190a361e4e9316e543ed3a 100644
--- a/net/Kconfig.debug
+++ b/net/Kconfig.debug
@@ -8,3 +8,12 @@ config NET_DEV_REFCNT_TRACKER
 	help
 	  Enable debugging feature to track device references.
 	  This adds memory and cpu costs.
+
+config NET_NS_REFCNT_TRACKER
+	bool "Enable networking namespace refcount tracking"
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
+	select REF_TRACKER
+	default n
+	help
+	  Enable debugging feature to track netns references.
+	  This adds memory and cpu costs.
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 202fa5eacd0f9bc74fc3246e9cebcd3419759ad5..9b7171c40434985b869c1477975fc75447d78c3b 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -311,6 +311,8 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	LIST_HEAD(net_exit_list);
 
 	refcount_set(&net->ns.count, 1);
+	ref_tracker_dir_init(&net->refcnt_tracker, 128);
+
 	refcount_set(&net->passive, 1);
 	get_random_bytes(&net->hash_mix, sizeof(u32));
 	preempt_disable();
@@ -635,6 +637,7 @@ static DECLARE_WORK(net_cleanup_work, cleanup_net);
 
 void __put_net(struct net *net)
 {
+	ref_tracker_dir_exit(&net->refcnt_tracker);
 	/* Cleanup the network namespace in process context */
 	if (llist_add(&net->cleanup_list, &cleanup_list))
 		queue_work(netns_wq, &net_cleanup_work);
-- 
2.34.1.173.g76aa8bc2d0-goog

