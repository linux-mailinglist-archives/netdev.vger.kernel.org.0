Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024EB46AFCA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhLGBeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhLGBej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:39 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF92C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:09 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u11so8302574plf.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GzhZ/fGH2RAlWayhRGzZ0dPR1g0dvGblYFvD22Lbl/U=;
        b=qGzsf/ZKI60LV3A8/zyiTwCtYJUk5AlY75z15BQPScnwTKhOCsnCy16vTePjnAsAY9
         UsEPrfSKsZW7qC5/owZyQrodVkhHvRw25ZF+YZPwwhoJZAOiG3z9AGu18jafGeZSP2vL
         JmX6pqNWyOmY6QvCskYg8DIQGePeksOIzwTK5Uxtyu78qtxNT5UjppU3rdelHsXG13Ie
         qee/sgiW1xrpOUcHZhNhwUz0fGPNaOwQekQzENXYtuFcef4Gk1Y5q67R1PxfonvzcqSA
         EnQzIGdToKnqop0D3fMGnqxIVk+i+L9hzfFEakFAcJcpRjMw57NqnbFEyyxxVx/Q2N7v
         4GaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GzhZ/fGH2RAlWayhRGzZ0dPR1g0dvGblYFvD22Lbl/U=;
        b=sNZGsWiPdCckcGzkqsMgvS2fb9NCj6/MbBtOzexXlScnaKD4sepvVikppVSSP6+lP/
         6FY+Ypm1HXtTveHpQX89Q026/IJsGl94NyFqL2sdeQqGsPTldMaAhsCQaWyhxq92KtZL
         57FvfOZVvJhw199hYYCWsHX3DeSUZbBWSi77vt/SLCRYYqkdPH11BOldbhBFdojr0Uml
         BKNlAmkoPaO71DQ2ObyvO9NYDeu2y/A7V9msSz6e7L141hVOSQI1Vc3JaJEcz3yEIuE0
         COZtnNsO93wrF0D9J5CH369T27yEBTEOWi638yvY7QK/p+4EZewXpyu3jMLG9MTj0GXU
         4H7w==
X-Gm-Message-State: AOAM531KAva1joGmjypsFUWmGlHx6NW9Q3nhte3B7lIQcGvh7/VmvS/N
        PNDOurWq/ncg/4qdbrCt16U=
X-Google-Smtp-Source: ABdhPJwszoQJ1zP/3kWJ+w56PiRb5NXlmXmfvqHFHvLt6Bz10ztPGnbuUt/9B+1AGZDZrY4hm1XNEg==
X-Received: by 2002:a17:90a:b382:: with SMTP id e2mr2727133pjr.181.1638840669509;
        Mon, 06 Dec 2021 17:31:09 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 06/13] inet: add net device refcount tracker to struct fib_nh_common
Date:   Mon,  6 Dec 2021 17:30:32 -0800
Message-Id: <20211207013039.1868645-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip_fib.h     |  2 ++
 net/ipv4/fib_semantics.c | 12 +++++++-----
 net/ipv6/route.c         |  2 ++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 3417ba2d27ad6a1b5612a8855d2788f10d9fdf25..c4297704bbcbaac0ad5da1675ae47dee1e133df4 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -79,6 +79,7 @@ struct fnhe_hash_bucket {
 
 struct fib_nh_common {
 	struct net_device	*nhc_dev;
+	netdevice_tracker	nhc_dev_tracker;
 	int			nhc_oif;
 	unsigned char		nhc_scope;
 	u8			nhc_family;
@@ -111,6 +112,7 @@ struct fib_nh {
 	int			nh_saddr_genid;
 #define fib_nh_family		nh_common.nhc_family
 #define fib_nh_dev		nh_common.nhc_dev
+#define fib_nh_dev_tracker	nh_common.nhc_dev_tracker
 #define fib_nh_oif		nh_common.nhc_oif
 #define fib_nh_flags		nh_common.nhc_flags
 #define fib_nh_lws		nh_common.nhc_lwtstate
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index fde7797b580694bb3924c5c6e9560cf04fd67387..3cad543dc7477aa94140d240ecd2014093befddd 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -208,7 +208,7 @@ static void rt_fibinfo_free_cpus(struct rtable __rcu * __percpu *rtp)
 
 void fib_nh_common_release(struct fib_nh_common *nhc)
 {
-	dev_put(nhc->nhc_dev);
+	dev_put_track(nhc->nhc_dev, &nhc->nhc_dev_tracker);
 	lwtstate_put(nhc->nhc_lwtstate);
 	rt_fibinfo_free_cpus(nhc->nhc_pcpu_rth_output);
 	rt_fibinfo_free(&nhc->nhc_rth_input);
@@ -1006,7 +1006,7 @@ static int fib_check_nh_v6_gw(struct net *net, struct fib_nh *nh,
 	err = ipv6_stub->fib6_nh_init(net, &fib6_nh, &cfg, GFP_KERNEL, extack);
 	if (!err) {
 		nh->fib_nh_dev = fib6_nh.fib_nh_dev;
-		dev_hold(nh->fib_nh_dev);
+		dev_hold_track(nh->fib_nh_dev, &nh->fib_nh_dev_tracker, GFP_KERNEL);
 		nh->fib_nh_oif = nh->fib_nh_dev->ifindex;
 		nh->fib_nh_scope = RT_SCOPE_LINK;
 
@@ -1090,7 +1090,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
 		if (!netif_carrier_ok(dev))
 			nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 		nh->fib_nh_dev = dev;
-		dev_hold(dev);
+		dev_hold_track(dev, &nh->fib_nh_dev_tracker, GFP_ATOMIC);
 		nh->fib_nh_scope = RT_SCOPE_LINK;
 		return 0;
 	}
@@ -1144,7 +1144,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
 			       "No egress device for nexthop gateway");
 		goto out;
 	}
-	dev_hold(dev);
+	dev_hold_track(dev, &nh->fib_nh_dev_tracker, GFP_ATOMIC);
 	if (!netif_carrier_ok(dev))
 		nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 	err = (dev->flags & IFF_UP) ? 0 : -ENETDOWN;
@@ -1178,7 +1178,7 @@ static int fib_check_nh_nongw(struct net *net, struct fib_nh *nh,
 	}
 
 	nh->fib_nh_dev = in_dev->dev;
-	dev_hold(nh->fib_nh_dev);
+	dev_hold_track(nh->fib_nh_dev, &nh->fib_nh_dev_tracker, GFP_ATOMIC);
 	nh->fib_nh_scope = RT_SCOPE_HOST;
 	if (!netif_carrier_ok(nh->fib_nh_dev))
 		nh->fib_nh_flags |= RTNH_F_LINKDOWN;
@@ -1508,6 +1508,8 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		err = -ENODEV;
 		if (!nh->fib_nh_dev)
 			goto failure;
+		netdev_tracker_alloc(nh->fib_nh_dev, &nh->fib_nh_dev_tracker,
+				     GFP_KERNEL);
 	} else {
 		int linkdown = 0;
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 8d834f901b483edf75c493620d38f979a4bcbf69..4d02a329ab6004169ebd31c5474ce8be5553d569 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3628,6 +3628,8 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	}
 
 	fib6_nh->fib_nh_dev = dev;
+	netdev_tracker_alloc(dev, &fib6_nh->fib_nh_dev_tracker, gfp_flags);
+
 	fib6_nh->fib_nh_oif = dev->ifindex;
 	err = 0;
 out:
-- 
2.34.1.400.ga245620fadb-goog

