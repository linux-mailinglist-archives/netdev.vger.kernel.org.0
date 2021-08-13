Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FD63EB73A
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbhHMPAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241030AbhHMPAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:00:39 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BD6C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:13 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id b10so10317367eju.9
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HORlVdyGh2lGDd3y5BvuyOpIor1UFiV3pM2jOqAVHlI=;
        b=ksU1XqL/LKuIEER0eJhayiZ2Q5QVQXyH29qOAt3vJapvy+/IyFX78qljJI6SHRkeyC
         bihqJGu0JKIwYjsUH6RWnELkjmFJ7FBy7TBmLkrCiQ+WHlQmcjnOeYNDvi8AkCyHCVw7
         FhY0ofS9k+jRIQK7zhSRhEfsLci1xs8urECJS21oezGPUlknLrdBip0m7nLJnB5XgLu/
         2gBeH70jGu1orHF707eadV8E0omYKddbBY4vykZQ/mXGh3mBF4zy9gs88i/Ou5MoWLP0
         JRcIMDnbGmu6L0qlmbCWbdmrwsLjuPigA/giB1kW8WDnJv3dRMBCTNmbx+9VEDSEQFeg
         kX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HORlVdyGh2lGDd3y5BvuyOpIor1UFiV3pM2jOqAVHlI=;
        b=uVliGhnW9sK5WK3Og+M0jmV884i5g2eXFmpCdbHncuw+36sR8jRaaGCKsnQFpUMwx6
         1p3VGylDkyfR9RyuohDRbyUDkOSRnlLgGL9dsQwhPIMEFcXYh7vvgOljYWmTl+VDvpkZ
         oyHom13GTE6lhKBSlBsmGPWSHAS3k+sxTqa3lv5uBmJX5MitG/Ra4hCv6v3kNhU29qko
         +2hBryWacDa7BxtoMMpZ3vrCJ4hIdXOhaFq9IxxyuXalmwN2g9rVgvIaDO1RrgaftmVa
         CX/jayCgIIxcX0g/UWvhDAhzUzr8g6zrAzB2v7QVKREYh2T4cUN2iL48Q/baptJ0IPDM
         xtYg==
X-Gm-Message-State: AOAM530G/C7lya3NulAihpJHxbWfi1hNLqMiBZSmgHPm3JRaAP5xgNIX
        M2fhO7bPqjwrmvqoc3sXBhG6yqEMgJq0hazL
X-Google-Smtp-Source: ABdhPJyRhd5dzFey98uTkLqdTkH5XTXSPZBcWj7l2JiQYU2lH8Pqnsq7ywvwlBLroaPpvStXaah21A==
X-Received: by 2002:a17:906:81c8:: with SMTP id e8mr2917900ejx.401.1628866811348;
        Fri, 13 Aug 2021 08:00:11 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d26sm1015711edp.90.2021.08.13.08.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 08:00:10 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 3/6] net: bridge: mcast: consolidate querier selection for ipv4 and ipv6
Date:   Fri, 13 Aug 2021 17:59:59 +0300
Message-Id: <20210813150002.673579-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813150002.673579-1-razor@blackwall.org>
References: <20210813150002.673579-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We can consolidate both functions as they share almost the same logic.
This is easier to maintain and we have a single querier update function.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 67 +++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 38 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 701cf46b89de..3705b7ace62d 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2864,55 +2864,46 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 }
 #endif
 
-static bool br_ip4_multicast_select_querier(struct net_bridge_mcast *brmctx,
-					    struct net_bridge_mcast_port *pmctx,
-					    struct br_ip *saddr)
+static bool br_multicast_select_querier(struct net_bridge_mcast *brmctx,
+					struct net_bridge_mcast_port *pmctx,
+					struct br_ip *saddr)
 {
 	int port_ifidx = pmctx ? pmctx->port->dev->ifindex : 0;
+	struct timer_list *own_timer, *other_timer;
+	struct bridge_mcast_querier *querier;
 
-	if (!timer_pending(&brmctx->ip4_own_query.timer) &&
-	    !timer_pending(&brmctx->ip4_other_query.timer))
-		goto update;
-
-	if (!brmctx->ip4_querier.addr.src.ip4)
-		goto update;
-
-	if (ntohl(saddr->src.ip4) <= ntohl(brmctx->ip4_querier.addr.src.ip4))
-		goto update;
-
-	return false;
-
-update:
-	br_multicast_update_querier(brmctx, &brmctx->ip4_querier, port_ifidx,
-				    saddr);
-
-	return true;
-}
-
+	switch (saddr->proto) {
+	case htons(ETH_P_IP):
+		querier = &brmctx->ip4_querier;
+		own_timer = &brmctx->ip4_own_query.timer;
+		other_timer = &brmctx->ip4_other_query.timer;
+		if (!querier->addr.src.ip4 ||
+		    ntohl(saddr->src.ip4) <= ntohl(querier->addr.src.ip4))
+			goto update;
+		break;
 #if IS_ENABLED(CONFIG_IPV6)
-static bool br_ip6_multicast_select_querier(struct net_bridge_mcast *brmctx,
-					    struct net_bridge_mcast_port *pmctx,
-					    struct br_ip *saddr)
-{
-	int port_ifidx = pmctx ? pmctx->port->dev->ifindex : 0;
-
-	if (!timer_pending(&brmctx->ip6_own_query.timer) &&
-	    !timer_pending(&brmctx->ip6_other_query.timer))
-		goto update;
+	case htons(ETH_P_IPV6):
+		querier = &brmctx->ip6_querier;
+		own_timer = &brmctx->ip6_own_query.timer;
+		other_timer = &brmctx->ip6_other_query.timer;
+		if (ipv6_addr_cmp(&saddr->src.ip6, &querier->addr.src.ip6) <= 0)
+			goto update;
+		break;
+#endif
+	default:
+		return false;
+	}
 
-	if (ipv6_addr_cmp(&saddr->src.ip6,
-			  &brmctx->ip6_querier.addr.src.ip6) <= 0)
+	if (!timer_pending(own_timer) && !timer_pending(other_timer))
 		goto update;
 
 	return false;
 
 update:
-	br_multicast_update_querier(brmctx, &brmctx->ip6_querier, port_ifidx,
-				    saddr);
+	br_multicast_update_querier(brmctx, querier, port_ifidx, saddr);
 
 	return true;
 }
-#endif
 
 static void
 br_multicast_update_query_timer(struct net_bridge_mcast *brmctx,
@@ -3115,7 +3106,7 @@ br_ip4_multicast_query_received(struct net_bridge_mcast *brmctx,
 				struct br_ip *saddr,
 				unsigned long max_delay)
 {
-	if (!br_ip4_multicast_select_querier(brmctx, pmctx, saddr))
+	if (!br_multicast_select_querier(brmctx, pmctx, saddr))
 		return;
 
 	br_multicast_update_query_timer(brmctx, query, max_delay);
@@ -3130,7 +3121,7 @@ br_ip6_multicast_query_received(struct net_bridge_mcast *brmctx,
 				struct br_ip *saddr,
 				unsigned long max_delay)
 {
-	if (!br_ip6_multicast_select_querier(brmctx, pmctx, saddr))
+	if (!br_multicast_select_querier(brmctx, pmctx, saddr))
 		return;
 
 	br_multicast_update_query_timer(brmctx, query, max_delay);
-- 
2.31.1

