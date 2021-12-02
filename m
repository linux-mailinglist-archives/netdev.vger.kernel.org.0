Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E627465CA6
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355172AbhLBDZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355177AbhLBDZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:25:24 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3809BC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:22:02 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r5so25595496pgi.6
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rq5RcFgLaQiCcb/mMtHlYjRYf8HJlaucDsU2hzr3g04=;
        b=p27UkZSO9xDngdO+DgvoWKRkH2qf06tpyQSPbs0pzyRXMfAF0GDfx0OQkqUmc1FvuG
         mqo3+ma0+31QB5xmNywoCMk705A9+LZm90SWxXGv4aXzohn5ICZJv6hPFno6OBT2uxkn
         cgVV7VFKd8/1XAajQN3BAiwoYqhAH2bJMqMChtFOOfTbnsMS+QD021ZfGNb+YfZrBXx4
         NVVCd+6s9xemTVsYPqrin4yJazoqg7+LTTUSLslaxa3enNcc0NENYr9BILfoPth2ty8H
         Hl8fkv/49bkO4Qyd8iidWI/RPo3NsjxbtgVQlzamYXX3OTmrlZeig+DD9IP0H8Zk8xwD
         ZIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rq5RcFgLaQiCcb/mMtHlYjRYf8HJlaucDsU2hzr3g04=;
        b=qMa5Gnb+gG7pct5h1wixBm6iq6JtT+ZGzeTQUXLbtzABrkvgEKW2ucWFl9NWXMnopu
         q8pGaDDCeQm9NcQdbBMsnZB/M7RwSAwo5Rj5vUj2Rr/70pYETvjNWWRfTSxM/rpTqCqP
         v3Xg7LmneuxFNBgKrVakI0VXqJ928zzueXiM35NC8/IJi3hHB6m3pWCE5rTDyCRTprZs
         DGSG9Tl3J0+faky2lsmdbRjMYqFK3AjDCPoMXBKyUWbrnDIGXRT2JqNThKOdGdJQqAqk
         vcafoVY8XTPuhO+QXluOrkQhgSql9OACf4ujLUuoOKGqN738MdZEQSGoVrPAgLPPmBaq
         b+4Q==
X-Gm-Message-State: AOAM531rex7RbxaUYIcc9CKW7MNEjISS6VL2cpjOlfWTZO71YOkXUAPH
        aA89SGej/rK6lu9Y55J2XPs=
X-Google-Smtp-Source: ABdhPJxmuWJ4YPNo7rSxkRtJGRo4KrUvmZVPDVoLPRkzOAakzITvgXUx88ILcT/iR0AjDZBcxIR7DA==
X-Received: by 2002:a05:6a00:1944:b0:438:d002:6e35 with SMTP id s4-20020a056a00194400b00438d0026e35mr10154100pfk.20.1638415321784;
        Wed, 01 Dec 2021 19:22:01 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:22:01 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 03/19] net: add dev_hold_track() and dev_put_track() helpers
Date:   Wed,  1 Dec 2021 19:21:23 -0800
Message-Id: <20211202032139.3156411-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
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
 include/linux/netdevice.h | 32 ++++++++++++++++++++++++++++++++
 net/Kconfig               |  8 ++++++++
 net/core/dev.c            |  3 +++
 3 files changed, 43 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index db3bff1ae7fdf5ff0b0546cbd0102b86f04fa144..3ddced0fa20f5c7a4548c340788214ea909a265f 100644
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
@@ -3834,6 +3844,28 @@ static inline void dev_hold(struct net_device *dev)
 	}
 }
 
+static inline void dev_hold_track(struct net_device *dev,
+				  netdevice_tracker *tracker, gfp_t gfp)
+{
+	if (dev) {
+		dev_hold(dev);
+#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+		ref_tracker_alloc(&dev->refcnt_tracker, tracker, gfp);
+#endif
+	}
+}
+
+static inline void dev_put_track(struct net_device *dev,
+				 netdevice_tracker *tracker)
+{
+	if (dev) {
+#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+		ref_tracker_free(&dev->refcnt_tracker, tracker);
+#endif
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
index d30adecc2bb2b744b283dbda89d9488b8eb6d47e..bdfbfa4e291858f990f5e2c99c4ce0ee9ed687cd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9861,6 +9861,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 			       netdev_unregister_timeout_secs * HZ)) {
 			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 				 dev->name, refcnt);
+			ref_tracker_dir_print(&dev->refcnt_tracker, 10);
 			warning_time = jiffies;
 		}
 	}
@@ -10151,6 +10152,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev = PTR_ALIGN(p, NETDEV_ALIGN);
 	dev->padded = (char *)dev - (char *)p;
 
+	ref_tracker_dir_init(&dev->refcnt_tracker, 128);
 #ifdef CONFIG_PCPU_DEV_REFCNT
 	dev->pcpu_refcnt = alloc_percpu(int);
 	if (!dev->pcpu_refcnt)
@@ -10267,6 +10269,7 @@ void free_netdev(struct net_device *dev)
 	list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
 		netif_napi_del(p);
 
+	ref_tracker_dir_exit(&dev->refcnt_tracker);
 #ifdef CONFIG_PCPU_DEV_REFCNT
 	free_percpu(dev->pcpu_refcnt);
 	dev->pcpu_refcnt = NULL;
-- 
2.34.0.rc2.393.gf8c9666880-goog

