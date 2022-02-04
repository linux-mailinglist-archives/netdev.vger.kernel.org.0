Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD9D4AA35A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352136AbiBDWms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352185AbiBDWmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:42:47 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28107D8778ED
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 14:42:47 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id h14so6368566plf.1
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 14:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ob7P/giOPp4kUaR7JDqub8nbfwsF5B2fJS25JZWrb7g=;
        b=KYU9HuyBFnGHhstZRpmtBRPMvpN+SqkD/KTbTCDV45YTIs1hdMQc1YBjPPHSdH7khz
         XN/pDpfe9UAQbQRhCYKhxto3QkZaP//4l2UcrJF9qQJFKBXaA1Y98mLJK/d8ScdXHLSP
         mNEIsMku3lxT6+mkZXP74q5vTLoMEbBZi9hojwVyI0ohR4cbuKD0YyJ8QC/nRgvyKkNI
         Tj5u0yPAl22H1w8Bysyd+6nVQSe0o+Deg8sDuPFeyjIt3e2SeReMLOH2yDJk/8S++2kk
         blJBNH2ZbGrZxWYJWMXOxjE1SoZWmVtCZfNd0xNtCMpyY2vLbF/mrltk/8y8jycnv6Gj
         ewSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ob7P/giOPp4kUaR7JDqub8nbfwsF5B2fJS25JZWrb7g=;
        b=54WNn9s1gbF8DIOsiAOgc2A98P3c5w/6yySYP28z+j0iKQJF5lufstTjdQN2gdrGED
         HnKTKTXmUhkqriFAGSLL/pmsnH2DZKAgcKD3hiovGvRw3qKCdXXub9IlgOQCIUZPzrgF
         UBKNrxUWkzaKBsih5Wyy4i3tgvBLxPW2yRn5Zzn8dmrbdPd3/c8MwwWMMa1OKiOonfN+
         JJX43Hm7JHU21NoZNBHmecrqBLt0I+O8fR4S8j16SNAsr1Fzs1WvPF/toUXo4ASaLAks
         uzmKPny1iT0gEXAfFG3Sx1WS9iY79dCQMzhpzj52HKMsTXq0RYemepYdYjOR+IrGVsRd
         DlTw==
X-Gm-Message-State: AOAM531Mi2+fqn/70OPQdW7OrEKT3P98egJcE1Tq8PjbyFS1RRhfVrUz
        oGvkTEPaBXTi3jVb/uxl/H77Sjqm7Gg=
X-Google-Smtp-Source: ABdhPJzlvqFfalRICCoAUglq+esnPBevgQWxdWeSOChCyA9kGf6tDgea8cAF9qIKnTur6PSDQfO2Pw==
X-Received: by 2002:a17:90b:4c0c:: with SMTP id na12mr5603016pjb.140.1644014566602;
        Fri, 04 Feb 2022 14:42:46 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id s2sm2410060pgl.21.2022.02.04.14.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 14:42:46 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 3/3] net: refine dev_put()/dev_hold() debugging
Date:   Fri,  4 Feb 2022 14:42:37 -0800
Message-Id: <20220204224237.2932026-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220204224237.2932026-1-eric.dumazet@gmail.com>
References: <20220204224237.2932026-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 dev_put(dev); // Should complain loudly here.
dev_put_track(dev, tracker_1); // instead of here

Add clarification about netdev_tracker_alloc() role.

v2: I replaced the dev_put() in linkwatch_do_dev()
    with __dev_put() because callers called netdev_tracker_free().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 69 ++++++++++++++++++++++++++-------------
 net/core/dev.c            |  2 +-
 net/core/link_watch.c     |  6 ++--
 3 files changed, 50 insertions(+), 27 deletions(-)

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
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index b0f5344d1185be66d05cd1dc50cffc5ccfe883ef..95098d1a49bdf4cbc3ddeb4d345e4276f974a208 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -166,10 +166,10 @@ static void linkwatch_do_dev(struct net_device *dev)
 
 		netdev_state_change(dev);
 	}
-	/* Note: our callers are responsible for
-	 * calling netdev_tracker_free().
+	/* Note: our callers are responsible for calling netdev_tracker_free().
+	 * This is the reason we use __dev_put() instead of dev_put().
 	 */
-	dev_put(dev);
+	__dev_put(dev);
 }
 
 static void __linkwatch_run_queue(int urgent_only)
-- 
2.35.0.263.gb82422642f-goog

