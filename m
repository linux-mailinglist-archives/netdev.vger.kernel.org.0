Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A6546890F
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhLEE0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhLEE0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:02 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184F3C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:22:36 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id np3so5258204pjb.4
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bYzAipWROA+AcebJbtrB31MReiZwS6nzh/y/yf0jbMQ=;
        b=P8Muk312jT45TmKvqGVvLEXUzGewSo1EHCSvN8pSZxYJBgSsB5TFTyVrLEu7IRhG/K
         ZON9WWLMeq4sM3fj1LpsDcyi84uQ/I6x0gHEXlTlyW88zUHl0f1gMsTaWEOYqduo4Zu2
         +owul30aaIYfxbiuDleuGSiu3eVGiha30gL3cMvT2tCV81J5YBWIpFY5Uaap5Twf/bRd
         Ac4tmoI16lTbztV9OlwwriMKvBuDdp8s/pAb1y/Ce3tahINSs6+NdU3YLV+lSuxtxJ1U
         IbY2EKPvWJkgByoSj3cSvWmgGkrp+/Y6E2us6co5jE0Y/pVyCnk4rk+6ikDTFC9IUA7K
         UEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bYzAipWROA+AcebJbtrB31MReiZwS6nzh/y/yf0jbMQ=;
        b=D7uU/cuBPmKGqfgSiQiqoMIR63o8STgYlXf9Svm8lTp8zuoZpnS45783OBN+7TR6jy
         iU0A2TdsEvHMkHnxbLOXA1rrYUhvqMme2xQyqX9fZmNstiRlcwDuYaokX6DXm3En/n1S
         1IN2uIIHw0dAyI7sRnhhzskdqPxth2gJbEU8YEAeius+4d74x7CylRTkB9UzOg6v5QbF
         eKAmglmXrbYfvxaMbHxWSZ/3hGu3xBKIy9zEA9R+As/Pfu2eam1rmfMEuqU7ITkCL16L
         crnMSkgVgsJkumQFmQAvy+LUtTRttp0HzjNZAbIOsy6r9hJDPpR9jlpAPVVb50sGF/FP
         IP1w==
X-Gm-Message-State: AOAM5333BxC5XVsKP8vh6/m3PB3ZhccjAb+wMWzR1ZqjOoBT4hQHjkYq
        cUS/CZY6o5D/lWDWj7otUz1uk3QzT48=
X-Google-Smtp-Source: ABdhPJzoqNOIFIXWv948FUdGZ0NHAn/TUZZHkfmY08MymIIkK48LkV3f3Zn28gRlyoUFarYQsqIUBg==
X-Received: by 2002:a17:902:7d8b:b0:144:e29b:4f2b with SMTP id a11-20020a1709027d8b00b00144e29b4f2bmr34210710plm.57.1638678155556;
        Sat, 04 Dec 2021 20:22:35 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:22:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 03/23] net: add net device refcount tracker infrastructure
Date:   Sat,  4 Dec 2021 20:21:57 -0800
Message-Id: <20211205042217.982127-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

net device are refcounted. Over the years we had numerous bugs
caused by imbalanced dev_hold() and dev_put() calls.

The general idea is to be able to precisely pair each decrement with
a corresponding prior increment. Both share a cookie, basically
a pointer to private data storing stack traces.

This patch adds dev_hold_track() and dev_put_track().

To use these helpers, each data structure owning a refcount
should also use a "netdevice_tracker" to pair the hold and put.

netdevice_tracker dev_tracker;
...
dev_hold_track(dev, &dev_tracker, GFP_ATOMIC);
...
dev_put_track(dev, &dev_tracker);

Whenever a leak happens, we will get precise stack traces
of the point dev_hold_track() happened, at device dismantle phase.

We will also get a stack trace if too many dev_put_track() for the same
netdevice_tracker are attempted.

This is guarded by CONFIG_NET_DEV_REFCNT_TRACKER option.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 45 +++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug         |  5 +++++
 net/Kconfig.debug         | 11 ++++++++++
 net/core/dev.c            |  3 +++
 4 files changed, 64 insertions(+)
 create mode 100644 net/Kconfig.debug

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 65117f01d5f2a9c9e815b6c967d5e9e4c94af0ae..143d60ed004732e4a086e66fdcf7b3d362c1dc20 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -48,6 +48,7 @@
 #include <uapi/linux/pkt_cls.h>
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
+#include <linux/ref_tracker.h>
 
 struct netpoll_info;
 struct device;
@@ -300,6 +301,12 @@ enum netdev_state_t {
 };
 
 
+#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+typedef struct ref_tracker *netdevice_tracker;
+#else
+typedef struct {} netdevice_tracker;
+#endif
+
 struct gro_list {
 	struct list_head	list;
 	int			count;
@@ -1865,6 +1872,7 @@ enum netdev_ml_priv_type {
  *	@proto_down_reason:	reason a netdev interface is held down
  *	@pcpu_refcnt:		Number of references to this device
  *	@dev_refcnt:		Number of references to this device
+ *	@refcnt_tracker:	Tracker directory for tracked references to this device
  *	@todo_list:		Delayed register/unregister
  *	@link_watch_list:	XXX: need comments on this one
  *
@@ -2178,6 +2186,7 @@ struct net_device {
 #else
 	refcount_t		dev_refcnt;
 #endif
+	struct ref_tracker_dir	refcnt_tracker;
 
 	struct list_head	link_watch_list;
 
@@ -3805,6 +3814,7 @@ void netdev_run_todo(void);
  *	@dev: network device
  *
  * Release reference to device to allow it to be freed.
+ * Try using dev_put_track() instead.
  */
 static inline void dev_put(struct net_device *dev)
 {
@@ -3822,6 +3832,7 @@ static inline void dev_put(struct net_device *dev)
  *	@dev: network device
  *
  * Hold reference to device to keep it from being freed.
+ * Try using dev_hold_track() instead.
  */
 static inline void dev_hold(struct net_device *dev)
 {
@@ -3834,6 +3845,40 @@ static inline void dev_hold(struct net_device *dev)
 	}
 }
 
+static inline void netdev_tracker_alloc(struct net_device *dev,
+					netdevice_tracker *tracker, gfp_t gfp)
+{
+#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+	ref_tracker_alloc(&dev->refcnt_tracker, tracker, gfp);
+#endif
+}
+
+static inline void netdev_tracker_free(struct net_device *dev,
+				       netdevice_tracker *tracker)
+{
+#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+	ref_tracker_free(&dev->refcnt_tracker, tracker);
+#endif
+}
+
+static inline void dev_hold_track(struct net_device *dev,
+				  netdevice_tracker *tracker, gfp_t gfp)
+{
+	if (dev) {
+		dev_hold(dev);
+		netdev_tracker_alloc(dev, tracker, gfp);
+	}
+}
+
+static inline void dev_put_track(struct net_device *dev,
+				 netdevice_tracker *tracker)
+{
+	if (dev) {
+		netdev_tracker_free(dev, tracker);
+		dev_put(dev);
+	}
+}
+
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
  * and _off may be called from IRQ context, but it is caller
  * who is responsible for serialization of these calls.
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 633c2c5cb45bd435a7684dbe2f2eca477c871463..6504b97f8dfd786b6a7b9cdb2c2eda5aaa2c2b03 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -598,6 +598,11 @@ config DEBUG_MISC
 	  Say Y here if you need to enable miscellaneous debug code that should
 	  be under a more specific debug option but isn't.
 
+menu "Networking Debugging"
+
+source "net/Kconfig.debug"
+
+endmenu # "Networking Debugging"
 
 menu "Memory Debugging"
 
diff --git a/net/Kconfig.debug b/net/Kconfig.debug
new file mode 100644
index 0000000000000000000000000000000000000000..ee8d67a784291fb126d95324db05183b5a78ab70
--- /dev/null
+++ b/net/Kconfig.debug
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config NET_DEV_REFCNT_TRACKER
+	bool "Enable net device refcount tracking"
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
+	select REF_TRACKER
+	default n
+	help
+	  Enable debugging feature to track device references.
+	  This adds memory and cpu costs.
+
diff --git a/net/core/dev.c b/net/core/dev.c
index aba8acc1238c2213b9fc0c47c93568f731f375e5..1740d6cfe86b58359cceaec7ee9cc015a3843723 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9864,6 +9864,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 			       netdev_unregister_timeout_secs * HZ)) {
 			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 				 dev->name, refcnt);
+			ref_tracker_dir_print(&dev->refcnt_tracker, 10);
 			warning_time = jiffies;
 		}
 	}
@@ -10154,6 +10155,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev = PTR_ALIGN(p, NETDEV_ALIGN);
 	dev->padded = (char *)dev - (char *)p;
 
+	ref_tracker_dir_init(&dev->refcnt_tracker, 128);
 #ifdef CONFIG_PCPU_DEV_REFCNT
 	dev->pcpu_refcnt = alloc_percpu(int);
 	if (!dev->pcpu_refcnt)
@@ -10270,6 +10272,7 @@ void free_netdev(struct net_device *dev)
 	list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
 		netif_napi_del(p);
 
+	ref_tracker_dir_exit(&dev->refcnt_tracker);
 #ifdef CONFIG_PCPU_DEV_REFCNT
 	free_percpu(dev->pcpu_refcnt);
 	dev->pcpu_refcnt = NULL;
-- 
2.34.1.400.ga245620fadb-goog

