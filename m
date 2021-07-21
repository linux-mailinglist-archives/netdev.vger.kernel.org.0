Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BE83D0D81
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238884AbhGUKnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238676AbhGUJ2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:28:52 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1635C061762
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:06:43 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id l1so1656775edr.11
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tiDqtvDIj2EXQJ5ZftNYScBwQwdfeCCd/jJFB9+5Koo=;
        b=GCsI8xwpr1JYSd2W/gl9tq0qQL/KDJcwbzy07Jih+gTWTIk1ysaG5rLfr6l0p+x+Hi
         ZnJ6Q0prf/ErgUTNaJv7aNO06g+3k4yfHx7cDZpD4vjVwwtKHVgLi2r3BOxxBM/i6CA+
         w8lLK6Ngi2ntX0D6yrKtuzaoTt4cC2sWumelZOcKau9ZoLcHq/+SBZMIfrmDZP6mE0By
         MBk0WrDe6U+Sc/W+2ZLNBkvspu+lk0Ov1ndR1oo/ZLGEchA0fcfx2jq4cw7NPzl/33ww
         M8HMXiiheRvRFHUdXyyDItwWZtL3pCZuCH8DQtvDmmxJdifRXFjhNYrBQuNBc8KoOK8q
         kX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tiDqtvDIj2EXQJ5ZftNYScBwQwdfeCCd/jJFB9+5Koo=;
        b=JkTFRGeNhVGfx5X3nfMe9lhZIJhCfNZIn5iy68Ph+mh1L1AaXc2MMdzciYv6r+8Mr9
         DemHevTjKZa3exqu8zx8tXm8Wci+8kYNNunGuB9EtM/wjgZ1wdooN29FeJ6QsUBstvDw
         XLRz6SVMrE/S/KeP8QlCN9pVLfx+o8In5raJ8MhCIEen3yR7N9NewNEjbMQjEqy3u3dV
         WXYdjjZhxySDmCH19ZUK9Hab3NtlMJzZYs33wQHhwofL7ZmIYhsVG0aGS1GQKYiXRnDe
         fu5Y92NlgHi1ANOID8a65MNK6dNGrz85DesonXzQcPC88/Psc/2NOKL56hPjZfSn5jxE
         Sg0w==
X-Gm-Message-State: AOAM532wDl3MmfUqMrHQ32UJiGkJqNPpUUmPNRAWHJjs9/LNOzoW0hkR
        0FkTilt/X8dO6b0ctTNnlPEKZ+cGE3q31kAba94=
X-Google-Smtp-Source: ABdhPJymQuR4zz3qnQfDXxD6mKz/euxlyUtX9I+7h9pF3zBqYVt3wj0dGTdTYEMmLDcRdRGJEf+UmQ==
X-Received: by 2002:a05:6402:22bb:: with SMTP id cx27mr46205792edb.96.1626862002217;
        Wed, 21 Jul 2021 03:06:42 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id op26sm8339706ejb.27.2021.07.21.03.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 03:06:41 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next] net: bridge: multicast: fix igmp/mld port context null pointer dereferences
Date:   Wed, 21 Jul 2021 13:06:24 +0300
Message-Id: <20210721100624.704110-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

With the recent change to use bridge/port multicast context pointers
instead of bridge/port I missed to convert two locations which pass the
port pointer as-is, but with the new model we need to verify the port
context is non-NULL first and retrieve the port from it. The first
location is when doing querier selection when a query is received, the
second location is when leaving a group. The port context will be null
if the packets originated from the bridge device (i.e. from the host).
The fix is simple just check if the port context exists and retrieve
the port pointer from it.

Fixes: adc47037a7d5 ("net: bridge: multicast: use multicast contexts instead of bridge or port")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
note: the != NULL checks are in line with the rest of the code style of
      br_multicast_leave_group()

 net/bridge/br_multicast.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 976491951c82..214d1bf854ad 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2827,9 +2827,11 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 #endif
 
 static bool br_ip4_multicast_select_querier(struct net_bridge_mcast *brmctx,
-					    struct net_bridge_port *port,
+					    struct net_bridge_mcast_port *pmctx,
 					    __be32 saddr)
 {
+	struct net_bridge_port *port = pmctx ? pmctx->port : NULL;
+
 	if (!timer_pending(&brmctx->ip4_own_query.timer) &&
 	    !timer_pending(&brmctx->ip4_other_query.timer))
 		goto update;
@@ -2853,9 +2855,11 @@ static bool br_ip4_multicast_select_querier(struct net_bridge_mcast *brmctx,
 
 #if IS_ENABLED(CONFIG_IPV6)
 static bool br_ip6_multicast_select_querier(struct net_bridge_mcast *brmctx,
-					    struct net_bridge_port *port,
+					    struct net_bridge_mcast_port *pmctx,
 					    struct in6_addr *saddr)
 {
+	struct net_bridge_port *port = pmctx ? pmctx->port : NULL;
+
 	if (!timer_pending(&brmctx->ip6_own_query.timer) &&
 	    !timer_pending(&brmctx->ip6_other_query.timer))
 		goto update;
@@ -3076,7 +3080,7 @@ br_ip4_multicast_query_received(struct net_bridge_mcast *brmctx,
 				struct br_ip *saddr,
 				unsigned long max_delay)
 {
-	if (!br_ip4_multicast_select_querier(brmctx, pmctx->port, saddr->src.ip4))
+	if (!br_ip4_multicast_select_querier(brmctx, pmctx, saddr->src.ip4))
 		return;
 
 	br_multicast_update_query_timer(brmctx, query, max_delay);
@@ -3091,7 +3095,7 @@ br_ip6_multicast_query_received(struct net_bridge_mcast *brmctx,
 				struct br_ip *saddr,
 				unsigned long max_delay)
 {
-	if (!br_ip6_multicast_select_querier(brmctx, pmctx->port, &saddr->src.ip6))
+	if (!br_ip6_multicast_select_querier(brmctx, pmctx, &saddr->src.ip6))
 		return;
 
 	br_multicast_update_query_timer(brmctx, query, max_delay);
@@ -3322,7 +3326,7 @@ br_multicast_leave_group(struct net_bridge_mcast *brmctx,
 		mod_timer(&own_query->timer, time);
 
 		for (p = mlock_dereference(mp->ports, brmctx->br);
-		     p != NULL;
+		     p != NULL && pmctx != NULL;
 		     p = mlock_dereference(p->next, brmctx->br)) {
 			if (!br_port_group_equal(p, pmctx->port, src))
 				continue;
-- 
2.31.1

