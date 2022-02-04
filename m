Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511BC4A9F3E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377588AbiBDSgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243054AbiBDSgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:36:42 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8ADC061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:36:42 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z5so5865062plg.8
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CHdSO/DuryrBkYeH5Fb7CmRIJsy0lIkMMra7/bWLPjM=;
        b=FdrRbRBFAG2cbnyjeGXFYSrDWEUNcXQPtJ9hS/YyAUgRisoazf8Q4c1ift9+vYJqOv
         IELEdpu/ZR6B2PRuuMIUniIBUb7/NwTKKqZcGoAcu43FQ+PfuZx/CoVE2idxf/jEbfxj
         +Gwt3Qm80UMUn8Wl1bciaruQ+fIpVoVp/sGPuBwaW4Zm/upe5/m9ZrxkJoVbfnVSfK+v
         5f5tp3mQbbP8b7IWYJpqnoS374PSMShu+IqJaaztjZnWPKDzhb8rbWMH6yorgyPapgaH
         uNvcO/JWpI2BaoLTx72d/tJiXAo7wd6b8IldPtcwjjC8U7nWuOE+GKP1s2p7x98dVfgB
         /zFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CHdSO/DuryrBkYeH5Fb7CmRIJsy0lIkMMra7/bWLPjM=;
        b=XWnzCG+ks3eequ6r9LGD7VQDExrSCHbOAhKbpuHkIYuHAB17NpagM3ZNJ73HJyAA0a
         fyHTGjEgfsbyNy1xX0Ew4SWk273mWW9dRl7j0Xkle7mmTLuBt3jEjSbt/TGF0x15Vcv9
         yHLnaMPR0sGacxvtqsGgUVVh9/26u/B0pukLojivC5iypXMyJE8u6HzQQJDYeVcJyHbu
         f901hA03oCdugbbmvGg8rDTBNACGpVZ1sSKpivkfa4PnITXIIe8LJQgN9PImRVvC06i2
         SKnqx7UOjc79lL0Cu8jQcUK8sxISPDOHKETFq7tinpFU7BAsFMAOq/Yy0goY2m7YRxAJ
         0IeQ==
X-Gm-Message-State: AOAM530xRrKRyaOUk2au/E3U/ez+eSLVXvIiq+EN/s0RGYbrlm0uI2kf
        JmkZNX5deS7nQMkkfVbPDdE=
X-Google-Smtp-Source: ABdhPJxNxIcGeQqU0CRetX/aLWIDUXhpfOjEjkpbFOsoBNMMR3z7OoTRLNkrSuapxqcdAeaNwDbM1Q==
X-Received: by 2002:a17:90b:19d5:: with SMTP id nm21mr1814043pjb.56.1643999801628;
        Fri, 04 Feb 2022 10:36:41 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id f15sm3483142pfv.189.2022.02.04.10.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:36:41 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/3] net: refine dev_put()/dev_hold() debugging
Date:   Fri,  4 Feb 2022 10:36:30 -0800
Message-Id: <20220204183630.2376998-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220204183630.2376998-1-eric.dumazet@gmail.com>
References: <20220204183630.2376998-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We are still chasing some syzbot reports where we think a rogue dev_put()
is called with no corresponding prior dev_hold().
Unfortunately it eats a reference on dev->dev_refcnt taken by innocent
dev_hold_track(), meaning that the refcount saturation splat comes
too late to be useful.

Make sure that 'not tracked' dev_put() and dev_hold() better use
CONFIG_NET_DEV_REFCNT_TRACKER=y debug infrastructure:

Prior patch in the series allowed ref_tracker_alloc() and ref_tracker_free()
to be called with a NULL @trackerp parameter, and to use a separate refcount
only to detect too many put() even in the following case:

dev_hold_track(dev, tracker_1, GFP_ATOMIC);
 dev_hold(dev);
 dev_put(dev);
 dev_put(dev);                 // Should complain loudly here.
dev_put_track(dev, tracker_1); // instead of here

Add clarification about netdev_tracker_alloc() role.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 69 ++++++++++++++++++++++++++-------------
 net/core/dev.c            |  2 +-
 2 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e490b84732d1654bf067b30f2bb0b0825f88dea9..3fb6fb67ed77e70314a699c9bdf8f4b26acfcc19 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3817,14 +3817,7 @@ extern unsigned int	netdev_budget_usecs;
 /* Called by rtnetlink.c:rtnl_unlock() */
 void netdev_run_todo(void);
 
-/**
- *	dev_put - release reference to device
- *	@dev: network device
- *
- * Release reference to device to allow it to be freed.
- * Try using dev_put_track() instead.
- */
-static inline void dev_put(struct net_device *dev)
+static inline void __dev_put(struct net_device *dev)
 {
 	if (dev) {
 #ifdef CONFIG_PCPU_DEV_REFCNT
@@ -3835,14 +3828,7 @@ static inline void dev_put(struct net_device *dev)
 	}
 }
 
-/**
- *	dev_hold - get reference to device
- *	@dev: network device
- *
- * Hold reference to device to keep it from being freed.
- * Try using dev_hold_track() instead.
- */
-static inline void dev_hold(struct net_device *dev)
+static inline void __dev_hold(struct net_device *dev)
 {
 	if (dev) {
 #ifdef CONFIG_PCPU_DEV_REFCNT
@@ -3853,11 +3839,24 @@ static inline void dev_hold(struct net_device *dev)
 	}
 }
 
+static inline void __netdev_tracker_alloc(struct net_device *dev,
+					  netdevice_tracker *tracker,
+					  gfp_t gfp)
+{
+#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+	ref_tracker_alloc(&dev->refcnt_tracker, tracker, gfp);
+#endif
+}
+
+/* netdev_tracker_alloc() can upgrade a prior untracked reference
+ * taken by dev_get_by_name()/dev_get_by_index() to a tracked one.
+ */
 static inline void netdev_tracker_alloc(struct net_device *dev,
 					netdevice_tracker *tracker, gfp_t gfp)
 {
 #ifdef CONFIG_NET_DEV_REFCNT_TRACKER
-	ref_tracker_alloc(&dev->refcnt_tracker, tracker, gfp);
+	refcount_dec(&dev->refcnt_tracker.no_tracker);
+	__netdev_tracker_alloc(dev, tracker, gfp);
 #endif
 }
 
@@ -3873,8 +3872,8 @@ static inline void dev_hold_track(struct net_device *dev,
 				  netdevice_tracker *tracker, gfp_t gfp)
 {
 	if (dev) {
-		dev_hold(dev);
-		netdev_tracker_alloc(dev, tracker, gfp);
+		__dev_hold(dev);
+		__netdev_tracker_alloc(dev, tracker, gfp);
 	}
 }
 
@@ -3883,10 +3882,34 @@ static inline void dev_put_track(struct net_device *dev,
 {
 	if (dev) {
 		netdev_tracker_free(dev, tracker);
-		dev_put(dev);
+		__dev_put(dev);
 	}
 }
 
+/**
+ *	dev_hold - get reference to device
+ *	@dev: network device
+ *
+ * Hold reference to device to keep it from being freed.
+ * Try using dev_hold_track() instead.
+ */
+static inline void dev_hold(struct net_device *dev)
+{
+	dev_hold_track(dev, NULL, GFP_ATOMIC);
+}
+
+/**
+ *	dev_put - release reference to device
+ *	@dev: network device
+ *
+ * Release reference to device to allow it to be freed.
+ * Try using dev_put_track() instead.
+ */
+static inline void dev_put(struct net_device *dev)
+{
+	dev_put_track(dev, NULL);
+}
+
 static inline void dev_replace_track(struct net_device *odev,
 				     struct net_device *ndev,
 				     netdevice_tracker *tracker,
@@ -3895,11 +3918,11 @@ static inline void dev_replace_track(struct net_device *odev,
 	if (odev)
 		netdev_tracker_free(odev, tracker);
 
-	dev_hold(ndev);
-	dev_put(odev);
+	__dev_hold(ndev);
+	__dev_put(odev);
 
 	if (ndev)
-		netdev_tracker_alloc(ndev, tracker, gfp);
+		__netdev_tracker_alloc(ndev, tracker, gfp);
 }
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
diff --git a/net/core/dev.c b/net/core/dev.c
index f79744d99413434ad28b26dee9aeeb2893a0e3ae..1eaa0b88e3ba5d800484656f2c3420af57050294 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10172,7 +10172,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->pcpu_refcnt = alloc_percpu(int);
 	if (!dev->pcpu_refcnt)
 		goto free_dev;
-	dev_hold(dev);
+	__dev_hold(dev);
 #else
 	refcount_set(&dev->dev_refcnt, 1);
 #endif
-- 
2.35.0.263.gb82422642f-goog

