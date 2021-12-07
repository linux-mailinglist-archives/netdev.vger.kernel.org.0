Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674DC46AF67
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378736AbhLGAzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245599AbhLGAzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:19 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2257C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:51:49 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so613360pjb.5
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rs7L2atBWuphTJ3YV3N4pXmYujle3iQ048X1U78BZYg=;
        b=TI61lv/RCd8weQ4DxIzlaUFsE0+puFr9kGSWwi1sPd1zAFDiIRzhecurmDGkUGmTtC
         e0R8vh6S/m/z2TeUxWcMx01NH8AWmybBaN78fBT1DDyEdBg3CzI3OszU1pGUE9TVyVvB
         FRKsT5vUXgVgi06WcSxFGYiyrcWsqCe5zDe7WfQlYUORvQFSNM0+SvJ6dZK9Hcm45+jJ
         vXjzRb6glIiKQ5yPEeF9XPf/6zlM+PX4nDGZDcm65GcHtILo12XBA5WiVihJvlOWu3YK
         Cf+IIeA+b7G+7UQgfik/qpW3uTluXtFiI/aHwKeUidGCvrJMxify+7dH1fDirEKP5mAT
         DiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rs7L2atBWuphTJ3YV3N4pXmYujle3iQ048X1U78BZYg=;
        b=DUh6c90ExDBg1CYbftAwphsXD0sN0vIMO0hHl2pziYmg5dnDaijHHOAg0kSn5MNz6Z
         2HJDl7B5dykIy41HJO7ZytzRrtogSZTiLxIGzpPFZz4jejJ2msdTLSddu+vUF+zDZXbS
         TqhL7bN0GOTLCEBMASmrBccJSDi2tYvQKsHytSbxcv9QmVNrlvAIiIoq2UyWUZ0aIyiC
         oAP/UcQJWXCqcvPO4/PHcBy2+LpS/bK2/b8Z5m0IYnBts/f8ekkThsexcCQv5HmoUPJL
         nZzwIF0kT07ddT4JHkxngXMS3H0Psxx4BZWez2M1ZnSzBZuv9dzwKADRjLt7vfRXR7NJ
         CuhQ==
X-Gm-Message-State: AOAM530ccnmc9BzPsbIZ7K+eHOiyl0rrWdN4veLtLvU7D3jW3K77ojlw
        DuE5KuLGoV/slpnHAxJ3Xy8=
X-Google-Smtp-Source: ABdhPJyIO+fWBnGNZvwGvAupoKWQ0BlxPNK2/lh0KscNelMnoA1nsCXHCH6XrQnSQ2pGkxmMslS2VQ==
X-Received: by 2002:a17:90a:5901:: with SMTP id k1mr2581836pji.76.1638838309386;
        Mon, 06 Dec 2021 16:51:49 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:51:49 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 01/17] net: add networking namespace refcount tracker
Date:   Mon,  6 Dec 2021 16:51:26 -0800
Message-Id: <20211207005142.1688204-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
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
index 69dca1edd5a60f4b9df79fbf8dcbc878440ab4b8..201d8c5be80685f89d7fdba4b61f83194beb9b13 100644
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
2.34.1.400.ga245620fadb-goog

