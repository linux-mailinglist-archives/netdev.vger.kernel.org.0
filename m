Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9A8454DCD
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbhKQTXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbhKQTXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 14:23:38 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F151C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:20:39 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r5so3132373pgi.6
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W7vCecyRZQC0zF+8D4yWbOmb3Fl32zqV6l3NsN+7lfg=;
        b=pfZiIfCoAqZqwQ228e7GuKM7w4bRdSL5R1v8XUuYNg98wMIcghdlh6EwawFggNjaE9
         XG/DjBfE5hdpCX/34fPPgMeH01eHjO6oGxqgwhtxsmgmdlpWDCJgC8mpipRExLjIAUP7
         zUzifI7/dA2gyug9UzDVFA+3fT9+S3xaITKsgLkjdQmfCvuwCXDVOdNj/2UzdVHxUflu
         X7tfiNZsZszxE75IttX+WfcZU6+LNiRViJ3V2wSLK+lD5NmUWVLXNPzA+jDQhy+T7qDx
         q+NzCdS74YfFRJ5AgPszaG8EdObISQUNj3wo/jHbFZHX4mcZe+vS2fzjZBhtsAkBU6Pe
         iNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W7vCecyRZQC0zF+8D4yWbOmb3Fl32zqV6l3NsN+7lfg=;
        b=J5GrSSOYNGOIdc/UZyrZK+/SZkv8ti1S+oHfilckv3RTQ1RX6nA74d6RH1NliXLHsH
         986tYww61uuK/nm+d5cqisNP0qFUB7ne6P6Ilfy67AUifkJdjg1gXsYAHe2DmHkxZiqm
         7wpH4DWBylttDdem9CXDFQ8t3eWw+cD1WJqYODfcGIsieRHwv30vYZMm3Ra48suq4xdj
         P7gahzsRVB++OddymY+ThSOX0yBAwQgv/5Rlw4L09j5CsvNQGnMx/jO51nxyiHLYkhEF
         FwLuy1NxLNm9LwrvMs4HEwqwXTr7IdLypuhiTX3MVW14Y/vc46Cr6h8KZHNXKKJbOSgD
         CayQ==
X-Gm-Message-State: AOAM533zf+gUf21RvumUfFNIjflj09/bUFAF3mlyxqC9ktwK1VeCJZJd
        4Vu6r0N9Gcs2ozj2W0o+v7bFUdN9yqA=
X-Google-Smtp-Source: ABdhPJyKOIxKMV4HxBB6M9XrqzL/Q/Bphlr7tZ4dxhyt2vgIbF8dCaNGXaBIAtBEgBZmtTyRKcqrrg==
X-Received: by 2002:a05:6a00:986:b0:4a2:c1fa:8899 with SMTP id u6-20020a056a00098600b004a2c1fa8899mr25152221pfg.61.1637176839120;
        Wed, 17 Nov 2021 11:20:39 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bea:143e:3360:c708])
        by smtp.gmail.com with ESMTPSA id e15sm376698pfc.134.2021.11.17.11.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 11:20:38 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC -next 2/2] net: add dev_hold_track() and dev_put_track() helpers
Date:   Wed, 17 Nov 2021 11:20:31 -0800
Message-Id: <20211117192031.3906502-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211117192031.3906502-1-eric.dumazet@gmail.com>
References: <20211117192031.3906502-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

They should replace dev_hold() and dev_put().

To use these helpers, each data structure owning a refcount
should also use a "struct ref_tracker" to pair the hold and put.

Whenever a leak happens, we will get precise stack traces
of the point dev_hold_track() happened, at device dismantle phase.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 23 +++++++++++++++++++++++
 net/Kconfig               |  8 ++++++++
 net/core/dev.c            |  3 +++
 3 files changed, 34 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4f4a299e92de7ba9f61507ad4df7e334775c07a6..91957aa0779195a962ec95f491d826bdd536808e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -48,6 +48,7 @@
 #include <uapi/linux/pkt_cls.h>
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
+#include <linux/ref_tracker.h>
 
 struct netpoll_info;
 struct device;
@@ -2181,6 +2182,7 @@ struct net_device {
 #else
 	refcount_t		dev_refcnt;
 #endif
+	struct ref_tracker_dir	refcnt_tracker;
 
 	struct list_head	link_watch_list;
 
@@ -3807,6 +3809,7 @@ void netdev_run_todo(void);
  *	@dev: network device
  *
  * Release reference to device to allow it to be freed.
+ * Try using dev_put_track() instead.
  */
 static inline void dev_put(struct net_device *dev)
 {
@@ -3824,6 +3827,7 @@ static inline void dev_put(struct net_device *dev)
  *	@dev: network device
  *
  * Hold reference to device to keep it from being freed.
+ * Try using dev_hold_track() instead.
  */
 static inline void dev_hold(struct net_device *dev)
 {
@@ -3836,6 +3840,25 @@ static inline void dev_hold(struct net_device *dev)
 	}
 }
 
+static inline void dev_hold_track(struct net_device *dev,
+				  struct ref_tracker **tracker,
+				  gfp_t gfp)
+{
+	if (dev) {
+		dev_hold(dev);
+		ref_tracker_alloc(&dev->refcnt_tracker, tracker, gfp);
+	}
+}
+
+static inline void dev_put_track(struct net_device *dev,
+				 struct ref_tracker **tracker)
+{
+	if (dev) {
+		ref_tracker_free(&dev->refcnt_tracker, tracker);
+		dev_put(dev);
+	}
+}
+
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
  * and _off may be called from IRQ context, but it is caller
  * who is responsible for serialization of these calls.
diff --git a/net/Kconfig b/net/Kconfig
index 074472dfa94ae78081b7391b8ca4a73b9d0be7b7..a4743e59a35c2978ecc6d704b388ca07efe3e95c 100644
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
index 92c9258cbf28556e68f9112343f5ebc98b2c163b..90ee2ba8717bf74bd3a1f72f7034744773ef69c4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9878,6 +9878,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 			       netdev_unregister_timeout_secs * HZ)) {
 			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 				 dev->name, refcnt);
+			ref_tracker_dir_print(&dev->refcnt_tracker, 10);
 			warning_time = jiffies;
 		}
 	}
@@ -10168,6 +10169,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev = PTR_ALIGN(p, NETDEV_ALIGN);
 	dev->padded = (char *)dev - (char *)p;
 
+	ref_tracker_dir_init(&dev->refcnt_tracker, 128);
 #ifdef CONFIG_PCPU_DEV_REFCNT
 	dev->pcpu_refcnt = alloc_percpu(int);
 	if (!dev->pcpu_refcnt)
@@ -10284,6 +10286,7 @@ void free_netdev(struct net_device *dev)
 	list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
 		netif_napi_del(p);
 
+	ref_tracker_dir_exit(&dev->refcnt_tracker);
 #ifdef CONFIG_PCPU_DEV_REFCNT
 	free_percpu(dev->pcpu_refcnt);
 	dev->pcpu_refcnt = NULL;
-- 
2.34.0.rc1.387.gb447b232ab-goog

