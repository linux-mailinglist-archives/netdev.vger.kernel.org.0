Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF179468915
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhLEE0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbhLEE0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:34 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BBAC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:23:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id x7so5299160pjn.0
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pU7livOUOYnFM3wFrj8hRk22T/NHOfWYupw4Rj/u0W4=;
        b=HaXVSfUIaH2wBftzMFIC/HY/N1YurhXiUBhdbrdLZI9yqiPiKbphfkMPT8tHrxLYql
         dbGSbWdBuFsSUqu7uCGl/U5yQIPrU25a+WfSMsoIxD3NfPRTUHHhtIfDJEnsoO/RzPFx
         m6E3nMRvhUZ5I26M4A/dXudxvlPFZQmzjpi1xHGQbKSuLBR/LY0bFlL2x+J/R63305m+
         R4ClbvcdhaKmh9iGMxLZa5ClH1Ai40+6ecvsjKO//0SyHi3dI5R+cutWROpQVV8S0+zI
         6MeOL+oQOaJdVv2XayTdjKau0ZK6qVH62YIwfekc+dpYQ8P6xDsIOyhCsR8dX0+AozcL
         F06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pU7livOUOYnFM3wFrj8hRk22T/NHOfWYupw4Rj/u0W4=;
        b=qsuR4WZL3NY7Q7tW1qojbwdVW4k3kUMNmJwu11bIvGJSKGFPqsVQGBDVkJJ4yJY7zv
         iaOlmaa5dD+kBW9zuCyZENwNXkG/Vgc2YguPQoZf073PF2owEIX8BL0vjCJRv35kp40G
         CBXsaKpltuLQgjUH2yZ07WrCsiUMcwWBCiqNBjgWlEZhWGmkVAD65L76UlhMYX/9qRGN
         8GjFNNrcUMjOsu7/m2mXH1UlMNJHDAQ2TzB9jMHUL4blGY5tS7NZf7uivGzwRkHYOIa6
         HOU7jYHkc739LDWHpZMIeC4tC9uykv3c8ytP2cFR8J+T92Y0HoRjnlP6RJnyC+2CFdeB
         QFNQ==
X-Gm-Message-State: AOAM531ahGjLQa8BT/pFglSs3G5M4o+yuC1y+O4tjnmUbPDB6GlTGS6C
        0zjRqE9Gxj1AQ50qGdpDvsk=
X-Google-Smtp-Source: ABdhPJzHRkvrIUGnijuhCkAcZlufdzcreh50HwdnB8gNqBal18jGXnmHN6Y8EZKVFVZxkDqoz3dEJQ==
X-Received: by 2002:a17:902:b712:b0:143:72b7:4096 with SMTP id d18-20020a170902b71200b0014372b74096mr34382100pls.25.1638678187275;
        Sat, 04 Dec 2021 20:23:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:23:07 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 09/23] net: dst: add net device refcount tracking to dst_entry
Date:   Sat,  4 Dec 2021 20:22:03 -0800
Message-Id: <20211205042217.982127-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
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
index b4f704337f657ebc46e02c9e5e7f5d2c2c64685e..afed3b10491b92da880a8cd13181ff041cc54673 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3883,6 +3883,23 @@ static inline void dev_put_track(struct net_device *dev,
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
2.34.1.400.ga245620fadb-goog

