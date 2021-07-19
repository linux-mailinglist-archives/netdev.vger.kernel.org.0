Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDC13CE842
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355715AbhGSQjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355664AbhGSQgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:33 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D69C078800
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id hr1so29953260ejc.1
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fZz7pbaMFBXMMthY41Q8WXcS+BZF9NZr318RJ38DIsk=;
        b=yhsXLFla7f+RYUqMuSi67fHFv/I/NIox181f3t4PaOeMA4hR2IjEUrCjfyqH+WJT5M
         sllGYxNIOCqfaoB7fIO5dpmFHq/xrYip6StSRwUOtHXpBT7Q19ltG1H30GoU/QvgG7No
         xVtjXvMltMkxnyno9Tz3nuHHoA6tY7bJXGC0KLuxSVKvTL39DF8qFf4YOraieqIAqfez
         SAPhkbl/j4hKfhl/Zy3Px74M2pp6csBi35ShRGS40tveH9BXkkzS2rjNF5I8I2Jj853D
         0It0t90cFpvnlJX53YNLoWZIrFJw0m4TKax4IlHV/AKhtyl1kteizoNdnqjj9e91m2un
         CxXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fZz7pbaMFBXMMthY41Q8WXcS+BZF9NZr318RJ38DIsk=;
        b=VPqq4D+qubYT71+zDvoWvNuVlcy7F033EItAHmDpM4bF2rH9d7EbmaUGaDK4hejc0i
         nZMswc0tJy4Xdzq8GoGcGWnUwQkkWasAdVtZFCz2qugPrf5WfWrP/q15NKpLjBE8dfcX
         myuh2pWa6KYusQjO670gT09bNrPbIUNG/Z3mGRYtBqG/TwzFUxPCZcAL237Jy35KYH35
         5RcQlTV+HRlaYnagSD7FCHQUHb0wGxYelchTc80HP2+vmDPMZaVsEluaVBOIDddG4bj/
         5xU9FXfqNIXQ8G9SEVwheAiy6QSMoA57Z+UuVhdLR8psrv+csR+Fcr1u1HM7+3DPsJft
         vapw==
X-Gm-Message-State: AOAM533qr4dbI3BjyAn3sHZm6oWBQ/WH9cePGxczR0NpZW7N9bpqguNJ
        5RsGRrkAstmQ+gbXpfVL4iWZ9CIhjIyk3S8jFGM=
X-Google-Smtp-Source: ABdhPJwlPD9prqAhy84rIzgV4ClGf/UkQez1Xn5Ho2M/obGixL/BaeOQG2pyEYpj1y2PIK2FVZXiFw==
X-Received: by 2002:a17:906:6814:: with SMTP id k20mr28028206ejr.381.1626714604410;
        Mon, 19 Jul 2021 10:10:04 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:03 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 08/15] net: bridge: multicast: use the port group to port context helper
Date:   Mon, 19 Jul 2021 20:06:30 +0300
Message-Id: <20210719170637.435541-9-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need to use the new port group to port context helper in places where
we cannot pass down the proper context (i.e. functions that can be
called by timers or outside the packet snooping paths).

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 353406f2971a..e61e23c0ce17 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -309,7 +309,9 @@ void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 	mp = br_mdb_ip_get(br, &pg->key.addr);
 	if (!mp)
 		return;
-	pmctx = &pg->key.port->multicast_ctx;
+	pmctx = br_multicast_pg_to_port_ctx(pg);
+	if (!pmctx)
+		return;
 
 	memset(&sg_ip, 0, sizeof(sg_ip));
 	sg_ip = pg->key.addr;
@@ -435,7 +437,6 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 	br_multicast_sg_host_state(star_mp, sg);
 	memset(&sg_key, 0, sizeof(sg_key));
 	sg_key.addr = sg->key.addr;
-	brmctx = &br->multicast_ctx;
 	/* we need to add all exclude ports to the S,G */
 	for (pg = mlock_dereference(star_mp->ports, br);
 	     pg;
@@ -449,7 +450,11 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 		if (br_sg_port_find(br, &sg_key))
 			continue;
 
-		pmctx = &pg->key.port->multicast_ctx;
+		pmctx = br_multicast_pg_to_port_ctx(pg);
+		if (!pmctx)
+			continue;
+		brmctx = br_multicast_port_ctx_get_global(pmctx);
+
 		src_pg = __br_multicast_add_group(brmctx, pmctx,
 						  &sg->key.addr,
 						  sg->eth_addr,
@@ -473,7 +478,9 @@ static void br_multicast_fwd_src_add(struct net_bridge_group_src *src)
 		return;
 
 	memset(&sg_ip, 0, sizeof(sg_ip));
-	pmctx = &src->pg->key.port->multicast_ctx;
+	pmctx = br_multicast_pg_to_port_ctx(src->pg);
+	if (!pmctx)
+		return;
 	brmctx = br_multicast_port_ctx_get_global(pmctx);
 	sg_ip = src->pg->key.addr;
 	sg_ip.src = src->addr.src;
@@ -1696,8 +1703,10 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
 		goto out;
 
-	brmctx = &br->multicast_ctx;
-	pmctx = &pg->key.port->multicast_ctx;
+	pmctx = br_multicast_pg_to_port_ctx(pg);
+	if (!pmctx)
+		goto out;
+	brmctx = br_multicast_port_ctx_get_global(pmctx);
 	if (pg->key.addr.proto == htons(ETH_P_IP))
 		other_query = &brmctx->ip4_other_query;
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.31.1

