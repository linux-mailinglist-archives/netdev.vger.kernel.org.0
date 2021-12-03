Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E3846703A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378258AbhLCCvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378242AbhLCCvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:08 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AFEC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:45 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id m15so1610189pgu.11
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xW5ouGZq4ABNETkcCBjnJear5A4Z2uZYh2WCONXgZTQ=;
        b=d+B0yu8GGdFUPmr9J3tI2/HBr1SqlyEmKgsFJHLqBPdOFbg5kKfQRLi4latAj7darW
         n9kh4YEO7c5W+qbkeD+ZB66EQ7CFl2zeIB8GVKd9pamfbAXOqbKSgTK/4EnBtIcyIzPs
         /j4dyD9m4+qG/OuSuT5easYiYDUWEX2yrFfLCiKBYUgoPS9HOYyxXyunMJolt/onWcpr
         I+k0XtTwgD9B+10RGf5rTGh4zzRA+YSpp5Rz1VxPdhDBpfjaOll537fbxQ7ENQvJ9026
         RY/AblQFjUYYYFbv40hGkimkq6KvNe/DacgKG03KVyHMnl79IaPjsvwLwHHTmdYRZ9ca
         L3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xW5ouGZq4ABNETkcCBjnJear5A4Z2uZYh2WCONXgZTQ=;
        b=cq+BWz3f6Fg9L32q+1CGH4Pl5O5Z94j+jkGs+la9HSrA1Lb9/x0/TpKl46zaY/3p5o
         8/XcstOJEe12xiJnKrhwCnnBd4JEgrbvC4OgiCz+ba+7umnaHXAT+GJF/RzJWaa5ENya
         kLULtmH//Q7UFn+l1prbuApyOfqYkoTwAVrjdMBT6+I+EQErBZc5DhlAlE4ZgUqqQ2yE
         bLQHe6KjeO9jsy7M0ifBYkRLlUY34JRtTxOdcPt5wgB9A6q5OjJOqCy9oyQL5boTkDDD
         k4MBG7NF/Ol70vsdVXX68qQLpiaK2cHDPIy5j2zASxtLBmeduhAZ+q97/4dTNRbs1VaT
         rCtA==
X-Gm-Message-State: AOAM533hW5agQ4DQEk4xZVWyy+YujWy2rlqrhbiATTSBHpxgOCZm5Bhc
        FK7TbOT5MRPqMw/RsES976w1CQ05DMc=
X-Google-Smtp-Source: ABdhPJzxwKaLymNljWrUT0LU1s2BHEvqYpLlPzMay80ygNtxcrqJgwnBXIQ6Vo4cUkJN82276RlwgQ==
X-Received: by 2002:a05:6a00:21c3:b0:4a7:ffeb:ec1f with SMTP id t3-20020a056a0021c300b004a7ffebec1fmr16661419pfj.60.1638499664672;
        Thu, 02 Dec 2021 18:47:44 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:44 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 09/23] net: dst: add net device refcount tracking to dst_entry
Date:   Thu,  2 Dec 2021 18:46:26 -0800
Message-Id: <20211203024640.1180745-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
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
index 3223f7db128de3a7353e6d50255c01ccf6c90ba7..d2bbae8464fc9a2367ee063bdbcba4caa994fa5c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3882,6 +3882,23 @@ static inline void dev_put_track(struct net_device *dev,
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

