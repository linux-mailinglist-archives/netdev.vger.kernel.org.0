Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5498E130C
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 09:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389849AbfJWHZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 03:25:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40910 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389835AbfJWHZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 03:25:20 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so12348366pfb.7;
        Wed, 23 Oct 2019 00:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3ED0+h6gAQw+Yq1D40Ef4ktI1oPwDQrbBfgGUVBxZ24=;
        b=ZgCVaCH5uO4HTNSVIkTIdba60a6aazGUV68Y0JUn288vDgHNX9noslSF8ezFCX7/de
         9Nomh6dQSUFnGm+49tJGt9MRSe6oTw6bSjPgCTDApYr/B1NZhe9NC3WhlBelKLvPXTR9
         u5VP5vRU7OwpkZxC1L6+mTVJzaAE6XBXV1fLjMsamZjnlYqNxK7lls6u46+txYYbP+sk
         GmXQVIemRhxxTbhLByxIimmD1iJn/ln48nrGUKxPf2Q8ejxDvsCcHjMNoUqYf9z1LiNX
         DhfklsNFzSrxyMZDxZiGNdmmEwwnFwBEY6PLiEn5NY/APPfUSChQWEyKnzZyozyz1Yuh
         zh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3ED0+h6gAQw+Yq1D40Ef4ktI1oPwDQrbBfgGUVBxZ24=;
        b=RL5DyTstrWolrHmB9olqBFl6IP++cKcg26kfPvFBE7F4KmltThfsZjsWaI9E8k86Ny
         yPbWviymf+5c7YKp/LZJKJeDpqPO79X95O5E8ss8gxX4AlhtWyWbx5ZPeKdzHZAiVMLc
         oQ5stBO0Jw3Nc5vuHkpkDvHR7a4kmbc0YG6dt4ediZmHbhVeXM66HJaWm+5w2dHeL7/m
         RH+BxfG3Z+d3jf/yrDM7F0twpJvNEntSvcyQZwz3ZdYIaYLcbJVTUbT+aQ8Gaz58F6iM
         AjCCqkUf8sA/KQ6zBpWbe1Rq4jnZANoN7P9Scub6W2hNOacDCX3nqvILLRKVogWPzUuG
         JdkQ==
X-Gm-Message-State: APjAAAUyHDybPs9YlHnTF2C/bKMohkJOoXeB/ekJu8ta3K4IEOVSiK+B
        i4UDrBOZWjINkASqBticuu4=
X-Google-Smtp-Source: APXvYqyLDFrxZjdwFcBxl1ypqAtAPKvW3nZpMrI7hNcuiFBuXxPPa7JP9BcFtGVg2NfccC5PhMXMTw==
X-Received: by 2002:a17:90a:1701:: with SMTP id z1mr9585733pjd.63.1571815520091;
        Wed, 23 Oct 2019 00:25:20 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d20sm23123603pfq.88.2019.10.23.00.25.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 00:25:19 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next] netfilter: nf_conntrack: introduce conntrack limit per-zone
Date:   Thu, 17 Oct 2019 13:03:04 +0800
Message-Id: <1571288584-46449-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

nf_conntrack_max is used to limit the maximum number of
conntrack entries in the conntrack table for every network
namespace. For the containers that reside in the same namespace,
they share the same conntrack table, and the total # of conntrack
entries for all containers are limited by nf_conntrack_max.
In this case, if one of the container abuses the usage the
conntrack entries, it blocks the others from committing valid
conntrack entries into the conntrack table.

To address the issue, this patch adds conntrack counter for zones
and max count which zone wanted, So that any zone can't consume
all conntrack entries in the conntrack table.

This feature can be used for openvswitch or iptables.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 .../linux/netfilter/nf_conntrack_zones_common.h    |  2 ++
 include/net/netfilter/nf_conntrack_zones.h         | 36 ++++++++++++++++++++++
 include/net/netns/conntrack.h                      |  5 +++
 net/netfilter/nf_conntrack_core.c                  | 15 +++++++--
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_zones_common.h b/include/linux/netfilter/nf_conntrack_zones_common.h
index 8f3905e1..0d50880 100644
--- a/include/linux/netfilter/nf_conntrack_zones_common.h
+++ b/include/linux/netfilter/nf_conntrack_zones_common.h
@@ -12,11 +12,13 @@
 #define NF_CT_DEFAULT_ZONE_DIR	(NF_CT_ZONE_DIR_ORIG | NF_CT_ZONE_DIR_REPL)
 
 #define NF_CT_FLAG_MARK		1
+#define NF_CT_ZONE_CONN_MAX	65535
 
 struct nf_conntrack_zone {
 	u16	id;
 	u8	flags;
 	u8	dir;
+	unsigned int max_wanted;
 };
 
 extern const struct nf_conntrack_zone nf_ct_zone_dflt;
diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index 48dbadb..f072374 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -5,6 +5,42 @@
 #include <linux/netfilter/nf_conntrack_zones_common.h>
 #include <net/netfilter/nf_conntrack.h>
 
+static inline void nf_ct_zone_count_init(struct net *net)
+{
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	int i;
+	for (i = 0; i < NF_CT_ZONE_CONN_MAX; i ++)
+		atomic_set(&net->ct.zone_conn_max[i], 0);
+#endif
+}
+
+static inline void nf_ct_zone_count_inc(struct net *net,
+					const struct nf_conntrack_zone *zone)
+{
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	atomic_inc(&net->ct.zone_conn_max[zone->id]);
+#endif
+}
+
+static inline void nf_ct_zone_count_dec(struct net *net,
+					const struct nf_conntrack_zone *zone)
+{
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	atomic_dec(&net->ct.zone_conn_max[zone->id]);
+#endif
+}
+
+static inline unsigned int
+nf_ct_zone_count_read(struct net *net,
+		      const struct nf_conntrack_zone *zone)
+{
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	return atomic_read(&net->ct.zone_conn_max[zone->id]);
+#else
+	return 0;
+#endif
+}
+
 static inline const struct nf_conntrack_zone *
 nf_ct_zone(const struct nf_conn *ct)
 {
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 806454e..da50d1e 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -6,6 +6,7 @@
 #include <linux/list_nulls.h>
 #include <linux/atomic.h>
 #include <linux/workqueue.h>
+#include <linux/netfilter/nf_conntrack_zones_common.h>
 #include <linux/netfilter/nf_conntrack_tcp.h>
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 #include <linux/netfilter/nf_conntrack_dccp.h>
@@ -118,5 +119,9 @@ struct netns_ct {
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
 	unsigned int		labels_used;
 #endif
+
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	atomic_t zone_conn_max[NF_CT_ZONE_CONN_MAX];
+#endif
 };
 #endif
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c63120..a2f7c27d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1352,14 +1352,20 @@ static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 
 	/* We don't want any race condition at early drop stage */
 	atomic_inc(&net->ct.count);
+	nf_ct_zone_count_inc(net, zone);
+
+	if ((nf_conntrack_max &&
+	     unlikely(atomic_read(&net->ct.count) > nf_conntrack_max)) ||
+	    (zone->max_wanted &&
+	     unlikely(nf_ct_zone_count_read(net, zone) > zone->max_wanted))) {
 
-	if (nf_conntrack_max &&
-	    unlikely(atomic_read(&net->ct.count) > nf_conntrack_max)) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
+
 			atomic_dec(&net->ct.count);
-			net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
+			nf_ct_zone_count_dec(net, zone);
+			net_warn_ratelimited("nf_conntrack: table or zone full, dropping packet\n");
 			return ERR_PTR(-ENOMEM);
 		}
 	}
@@ -1394,6 +1400,7 @@ static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 	return ct;
 out:
 	atomic_dec(&net->ct.count);
+	nf_ct_zone_count_dec(net, zone);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -1421,6 +1428,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 	kmem_cache_free(nf_conntrack_cachep, ct);
 	smp_mb__before_atomic();
 	atomic_dec(&net->ct.count);
+	nf_ct_zone_count_dec(net, nf_ct_zone(ct));
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_free);
 
@@ -2510,6 +2518,7 @@ int nf_conntrack_init_net(struct net *net)
 	BUILD_BUG_ON(IP_CT_UNTRACKED == IP_CT_NUMBER);
 	BUILD_BUG_ON_NOT_POWER_OF_2(CONNTRACK_LOCKS);
 	atomic_set(&net->ct.count, 0);
+	nf_ct_zone_count_init(net);
 
 	net->ct.pcpu_lists = alloc_percpu(struct ct_pcpu);
 	if (!net->ct.pcpu_lists)
-- 
1.8.3.1

