Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0547465CAE
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355177AbhLBD0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355179AbhLBDZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:25:56 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D663C06174A
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:22:34 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p18so19215209plf.13
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7250yZGq0GXwSYTzvQqtJYpIvKlJXs9zw1bN31JtSgY=;
        b=N5RpV3YEzqUZHVjeXMp3/6igGPXcXpfrGAyybzt2OuLn1yTnVO4yCMpyTkXkjQ6MM6
         2iYBur7tie27sj1PIQMMyYqYHp9eMkF3iPbZyl+JAkMl/kNcZE85vd9hK/J5VYZnxndN
         WpeKRs4Pzd0Hul1/ZMEe/ZXBn1wtwx9EtnNIq1lnJCMdPg0tjUwAwOwMSeGP3XFJ9X+2
         JwpURIXyDCH9XrwXkLZwEyvo3PMPMPx9LBrjlvwmz/xxo6LOPEMwC/BiNE/2/HpHSh5h
         EmbH0u7k3pLzoHUg2HR5ZA8Lrno5oAR9Qd3G1DMvqBTeerX25aMDmAlhkNx+ye/qKKIH
         +NUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7250yZGq0GXwSYTzvQqtJYpIvKlJXs9zw1bN31JtSgY=;
        b=kc9GhhNbSxzBPmpwyuCF6YfPgsIkEvUVLkmkMsgz2sRFgVmY0IVnR4VKGKALz0U5Gy
         vIh20qecwVMyfyyWxI+rkZ0fMCHsObs4UeZkeWSy+g5dr+MDdXdsRuNIQvCwd4634f28
         92x9xaFu83l1qGycquD3lzsmvwg4IXSKflOXzPrF43kRabqR4vcaPAqbKw1GSwy6IBBq
         Hg52wCaQocEMST42OmsT0YLZQNEMS+E9RVDwPgI6of+m/4U/nzQR8maxi9EgZaIAdQjD
         1nGRpSsKgzJHzsZvWJL09kMurnpeSnHzBdvYbe5lQh2cl6I2l0KeGDl5RVr69pFDdtAj
         yvBw==
X-Gm-Message-State: AOAM5327oXPhhg/fw87sV3V8LD0ewh8F+TTMwL2LUFw5KC/P0ro2q51G
        rJIBgRSwkZMDYBeNiqF4IZc=
X-Google-Smtp-Source: ABdhPJyfMAcRhaXLwDbT436IL1xppsBjtn6TBZUiISUS5pA+jLChjQiZOW47ADwLVtbPMMaoC+fYJw==
X-Received: by 2002:a17:903:285:b0:142:7a83:6dd2 with SMTP id j5-20020a170903028500b001427a836dd2mr12271666plr.59.1638415353707;
        Wed, 01 Dec 2021 19:22:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:22:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 09/19] net: dst: add net device refcount tracking to dst_entry
Date:   Wed,  1 Dec 2021 19:21:29 -0800
Message-Id: <20211202032139.3156411-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We want to track all dev_hold()/dev_put() to ease leak hunting.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 17 +++++++++++++++++
 include/net/dst.h         |  1 +
 net/core/dst.c            |  8 ++++----
 net/ipv4/route.c          |  7 ++++---
 net/ipv6/route.c          |  5 +++--
 5 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b43102614696a97c919f601d1337746443d79557..bfbf7c52688396093740c16aeb2e6947eaa9ac9c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3870,6 +3870,23 @@ static inline void dev_put_track(struct net_device *dev,
 	}
 }
 
+static inline void dev_replace_track(struct net_device *odev,
+				     struct net_device *ndev,
+				     netdevice_tracker *tracker,
+				     gfp_t gfp)
+{
+#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+	if (odev)
+		ref_tracker_free(&odev->refcnt_tracker, tracker);
+#endif
+	dev_hold(ndev);
+	dev_put(odev);
+#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+	if (ndev)
+		ref_tracker_alloc(&ndev->refcnt_tracker, tracker, gfp);
+#endif
+}
+
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
  * and _off may be called from IRQ context, but it is caller
  * who is responsible for serialization of these calls.
diff --git a/include/net/dst.h b/include/net/dst.h
index a057319aabefac52075edb038358439ceec23a60..6aa252c3fc55ccaee58faebf265510469e91d780 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -77,6 +77,7 @@ struct dst_entry {
 #ifndef CONFIG_64BIT
 	atomic_t		__refcnt;	/* 32-bit offset 64 */
 #endif
+	netdevice_tracker	dev_tracker;
 };
 
 struct dst_metrics {
diff --git a/net/core/dst.c b/net/core/dst.c
index 497ef9b3fc6abb5fd9c74e5730c3aedc3277f850..d16c2c9bfebd3dadd4c8dbc4f14836574bb52bbe 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -49,7 +49,7 @@ void dst_init(struct dst_entry *dst, struct dst_ops *ops,
 	      unsigned short flags)
 {
 	dst->dev = dev;
-	dev_hold(dev);
+	dev_hold_track(dev, &dst->dev_tracker, GFP_ATOMIC);
 	dst->ops = ops;
 	dst_init_metrics(dst, dst_default_metrics.metrics, true);
 	dst->expires = 0UL;
@@ -117,7 +117,7 @@ struct dst_entry *dst_destroy(struct dst_entry * dst)
 
 	if (dst->ops->destroy)
 		dst->ops->destroy(dst);
-	dev_put(dst->dev);
+	dev_put_track(dst->dev, &dst->dev_tracker);
 
 	lwtstate_put(dst->lwtstate);
 
@@ -159,8 +159,8 @@ void dst_dev_put(struct dst_entry *dst)
 	dst->input = dst_discard;
 	dst->output = dst_discard_out;
 	dst->dev = blackhole_netdev;
-	dev_hold(dst->dev);
-	dev_put(dev);
+	dev_replace_track(dev, blackhole_netdev, &dst->dev_tracker,
+			  GFP_ATOMIC);
 }
 EXPORT_SYMBOL(dst_dev_put);
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 243a0c52be42b60226a38dce980956b33e583d80..843a7a3699feeb24f3b9af5efaff87724214cbce 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1531,8 +1531,9 @@ void rt_flush_dev(struct net_device *dev)
 			if (rt->dst.dev != dev)
 				continue;
 			rt->dst.dev = blackhole_netdev;
-			dev_hold(rt->dst.dev);
-			dev_put(dev);
+			dev_replace_track(dev, blackhole_netdev,
+					  &rt->dst.dev_tracker,
+					  GFP_ATOMIC);
 		}
 		spin_unlock_bh(&ul->lock);
 	}
@@ -2819,7 +2820,7 @@ struct dst_entry *ipv4_blackhole_route(struct net *net, struct dst_entry *dst_or
 		new->output = dst_discard_out;
 
 		new->dev = net->loopback_dev;
-		dev_hold(new->dev);
+		dev_hold_track(new->dev, &new->dev_tracker, GFP_ATOMIC);
 
 		rt->rt_is_input = ort->rt_is_input;
 		rt->rt_iif = ort->rt_iif;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f0d29fcb20945b5a48097c89dc57daedeed9d177..ba4dc94d76d63c98ff49c41b712231f81eb8af40 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -182,8 +182,9 @@ static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
 
 			if (rt_dev == dev) {
 				rt->dst.dev = blackhole_netdev;
-				dev_hold(rt->dst.dev);
-				dev_put(rt_dev);
+				dev_replace_track(rt_dev, blackhole_netdev,
+						  &rt->dst.dev_tracker,
+						  GFP_ATOMIC);
 			}
 		}
 		spin_unlock_bh(&ul->lock);
-- 
2.34.0.rc2.393.gf8c9666880-goog

