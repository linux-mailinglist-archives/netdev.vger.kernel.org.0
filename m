Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092CC467033
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378267AbhLCCur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378255AbhLCCup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:50:45 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7283EC061758
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:22 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id q17so1088132plr.11
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iYXgR/ok4gbZqsXu7m8s8c7A+21ufwrO9AwNNSuqCvs=;
        b=YRZzqdAQ/8AgYjRTg2tOO3c+4UFc3Xx9AWHxOIzxd8DwiH90vWz6yo2LtJl4DEbMIi
         ovZSER8lyV0Ie0QkBCXOcRT9lh4ye0yNX8Kr5TNNyZuP4qDP86OOQVv+So+rkhEd1zBz
         d7piyDM1GiqbnXnX6x7MkW6vQ9Nah6RjlfGeSlPEl03iA1jrNdkI5aebemvu9lg9KvFb
         9+c4BY0mqkdnT72Y9VrtTFbFWaDCWW6+PCEIueV5UUj+ZYAC+XgrKQex5CKYiwPa+zqJ
         e6w3rUtGVsOnDRcv21JSzbeXwUC/SXYOxwPm/5CZrWQsyYOpAUJuUnsVWUf1g02JzEmK
         ne7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iYXgR/ok4gbZqsXu7m8s8c7A+21ufwrO9AwNNSuqCvs=;
        b=7DJ2ybUvx2F3ODonoDsTqzQwUkLuCQUexUVYWuj3e8PUGJV1AsiDiwf55kQl1DIUae
         qbVMvwIgHW49lkuu9h6fcpdZ+2MkFlz4lBQ58H8pqBiWG4MNEe2L/LTa0NBBqdiGP44Q
         w+LNRs9zGZJvMJLwAbs7hvUwwDTswyMjJA2MpAkLftuQNkjSAWwHS+nBLirPfngOitFb
         dIW8voLQwwQ0HKA3Pv4l9tjl31yMDHjKbrJzukyxmDvCyKOLPIvvQI0tQEIp6w0pOJ9Z
         aVxVDas4M1d0XdsDnf55AjTdtCvoqzamLWl4MRw6c0HaF6Ed6G5SE8shJPkRJqh2Nvia
         5S5g==
X-Gm-Message-State: AOAM531vWIclFltKM2wGmqSzT7INiRB4/fRxvUAXX0c5eTuYCguUnydV
        mRNn6M3rfA/qsUxWpffxDao=
X-Google-Smtp-Source: ABdhPJw3KzhaPXDHN5WTk04IP+RqLLZNm5Im18Cs2HAvowZ5CIHOAqag3WEFGzDKGhX4xrSH8eCvdA==
X-Received: by 2002:a17:90a:d684:: with SMTP id x4mr10682975pju.244.1638499641926;
        Thu, 02 Dec 2021 18:47:21 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:21 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 03/23] net: add dev_hold_track() and dev_put_track() helpers
Date:   Thu,  2 Dec 2021 18:46:20 -0800
Message-Id: <20211203024640.1180745-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

They should replace dev_hold() and dev_put().

To use these helpers, each data structure owning a refcount
should also use a "netdevice_tracker" to pair the hold and put.

Whenever a leak happens, we will get precise stack traces
of the point dev_hold_track() happened, at device dismantle phase.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 44 +++++++++++++++++++++++++++++++++++++++
 net/Kconfig               |  8 +++++++
 net/core/dev.c            |  3 +++
 3 files changed, 55 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 65117f01d5f2a9c9e815b6c967d5e9e4c94af0ae..daeda6ae8d6520c38ff0ce18bac2dc957940de5d 100644
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
@@ -2178,6 +2185,7 @@ struct net_device {
 #else
 	refcount_t		dev_refcnt;
 #endif
+	struct ref_tracker_dir	refcnt_tracker;
 
 	struct list_head	link_watch_list;
 
@@ -3805,6 +3813,7 @@ void netdev_run_todo(void);
  *	@dev: network device
  *
  * Release reference to device to allow it to be freed.
+ * Try using dev_put_track() instead.
  */
 static inline void dev_put(struct net_device *dev)
 {
@@ -3822,6 +3831,7 @@ static inline void dev_put(struct net_device *dev)
  *	@dev: network device
  *
  * Hold reference to device to keep it from being freed.
+ * Try using dev_hold_track() instead.
  */
 static inline void dev_hold(struct net_device *dev)
 {
@@ -3834,6 +3844,40 @@ static inline void dev_hold(struct net_device *dev)
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
diff --git a/net/Kconfig b/net/Kconfig
index 8a1f9d0287de3c32040eee03b60114c6e6d150bc..0b665e60b53490f44eeda1e5506d4e125ef4c53a 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -253,6 +253,14 @@ config PCPU_DEV_REFCNT
 	  network device refcount are using per cpu variables if this option is set.
 	  This can be forced to N to detect underflows (with a performance drop).
 
+config NET_DEV_REFCNT_TRACKER
+	bool "Enable tracking in dev_put_track() and dev_hold_track()"
+	select REF_TRACKER
+	default n
+	help
+	  Enable debugging feature to track leaked device references.
+	  This adds memory and cpu costs.
+
 config RPS
 	bool
 	depends on SMP && SYSFS
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

