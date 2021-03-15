Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC61833C3EE
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbhCORPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbhCORPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:15:36 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAA7C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 10:15:36 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id p7so56242136eju.6
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 10:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/2Hp6zM1W+LZN6PtbeaytmNBZutIvxwrSMkcgkNRVFc=;
        b=y7/FYlZX0XlIs2bnp//8qtDAYl+ORuCg5XJWBd3TkwDtffTeiKnTvX9uf2FOjqP+wy
         6gnm9OvgBIlgcV0xVMl2tEwXsDyI78CDBhdyt0VAjt3UQIBcniYbpZKjaRF1DQR4xoZq
         PAfsPHYxM7PFkt9sNJRBm3+XiKIH3jGd9ag7z2qi8K++CHjBm/StoutTqEdsE4lZPoPy
         L62oxACq+mLhN4fQ00hQSXNNRxZMPQc6mTIWZyYUS11Ae7vaMsjMJOHOWkufm2JUBkyK
         WI1AloadLRrCNulh2DwwyEYd5twa4gN95TEWv8JtHULA0WtnFcIP+NSZEgWzdJP2BPhD
         SHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/2Hp6zM1W+LZN6PtbeaytmNBZutIvxwrSMkcgkNRVFc=;
        b=JwduNfbUvpG4cHxb/hoP7+IPlxaxFUaT14LsnTlsOBg77dCe4cNwD9w9UhAJ4j/R/S
         lf0Y7rZmAzsGtTobQzgesBsU21QnPBgKqG1jryi5GFWXCmbQM2FHgl91JRZUhE9mZZML
         SIW01wV9V74XH7YYSug3CmpBeoqrvNH1PZLPlH1ZL3GvkR0pdO3UwLa4Z7Sy1eQuKpka
         ooGBQotg7bk1sklvWfCYYzRFuCFe7Yz4LtYysvgAIZQkXZ7r0wmf284fUPjCe7StIVYD
         vwW4KRwqX9ja88y6aZBBZFJJ08QyI292Rf1x4U69BZPEAYrHnBd/HSQ4ZG9gQP/4QI6Y
         8OeQ==
X-Gm-Message-State: AOAM531+S3I4LOgcFqyVfnbSHAptHN/Yl/xuNi4j5sJmqicxnqPrfjwK
        bMiUS3vP1/SSLWHBaQWEV9Foej+IHs6PYhYN
X-Google-Smtp-Source: ABdhPJx2l0KqSx1w+S0TOdHg2bqxoN6O0tne4O3EuAYPJLCiKK4dbnFqmIDgWkYos9FjiQ+iRLh+/A==
X-Received: by 2002:a17:906:a3d1:: with SMTP id ca17mr25040975ejb.92.1615828534280;
        Mon, 15 Mar 2021 10:15:34 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b12sm8297369eds.94.2021.03.15.10.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 10:15:33 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 1/2] net: bridge: mcast: remove unreachable EHT code
Date:   Mon, 15 Mar 2021 19:13:41 +0200
Message-Id: <20210315171342.232809-2-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315171342.232809-1-razor@blackwall.org>
References: <20210315171342.232809-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

In the initial EHT versions there were common functions which handled
allow/block messages for both INCLUDE and EXCLUDE modes, but later they
were separated. It seems I've left some common code which cannot be
reached because the filter mode is checked before calling the respective
functions, i.e. the host filter is always in EXCLUDE mode when using
__eht_allow_excl() and __eht_block_excl() thus we can drop the host_excl
checks inside and simplify the code a bit.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast_eht.c | 57 +++++++++--------------------------
 1 file changed, 15 insertions(+), 42 deletions(-)

diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index fea38b9a7268..982398e44658 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -522,31 +522,24 @@ static bool __eht_allow_excl(struct net_bridge_port_group *pg,
 			     u32 nsrcs,
 			     size_t addr_size)
 {
-	bool changed = false, host_excl = false;
 	union net_bridge_eht_addr eht_src_addr;
 	struct net_bridge_group_src *src_ent;
+	bool changed = false;
 	struct br_ip src_ip;
 	u32 src_idx;
 
-	host_excl = !!(br_multicast_eht_host_filter_mode(pg, h_addr) == MCAST_EXCLUDE);
 	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
-		if (!host_excl) {
-			br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
-							  MCAST_INCLUDE,
-							  false);
-		} else {
-			if (!br_multicast_del_eht_set_entry(pg, &eht_src_addr,
-							    h_addr))
-				continue;
-			memcpy(&src_ip, srcs + (src_idx * addr_size), addr_size);
-			src_ent = br_multicast_find_group_src(pg, &src_ip);
-			if (!src_ent)
-				continue;
-			br_multicast_del_group_src(src_ent, true);
-			changed = true;
-		}
+		if (!br_multicast_del_eht_set_entry(pg, &eht_src_addr,
+						    h_addr))
+			continue;
+		memcpy(&src_ip, srcs + (src_idx * addr_size), addr_size);
+		src_ent = br_multicast_find_group_src(pg, &src_ip);
+		if (!src_ent)
+			continue;
+		br_multicast_del_group_src(src_ent, true);
+		changed = true;
 	}
 
 	return changed;
@@ -602,42 +595,22 @@ static bool __eht_block_incl(struct net_bridge_port_group *pg,
 	return changed;
 }
 
-static bool __eht_block_excl(struct net_bridge_port_group *pg,
+static void __eht_block_excl(struct net_bridge_port_group *pg,
 			     union net_bridge_eht_addr *h_addr,
 			     void *srcs,
 			     u32 nsrcs,
 			     size_t addr_size)
 {
-	bool changed = false, host_excl = false;
 	union net_bridge_eht_addr eht_src_addr;
-	struct net_bridge_group_src *src_ent;
-	struct br_ip src_ip;
 	u32 src_idx;
 
-	host_excl = !!(br_multicast_eht_host_filter_mode(pg, h_addr) == MCAST_EXCLUDE);
 	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
-	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
-		if (host_excl) {
-			br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
-							  MCAST_EXCLUDE,
-							  false);
-		} else {
-			if (!br_multicast_del_eht_set_entry(pg, &eht_src_addr,
-							    h_addr))
-				continue;
-			memcpy(&src_ip, srcs + (src_idx * addr_size), addr_size);
-			src_ent = br_multicast_find_group_src(pg, &src_ip);
-			if (!src_ent)
-				continue;
-			br_multicast_del_group_src(src_ent, true);
-			changed = true;
-		}
+		br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
+						  MCAST_EXCLUDE,
+						  false);
 	}
-
-	return changed;
 }
 
 static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
@@ -653,7 +626,7 @@ static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
 		changed = __eht_block_incl(pg, h_addr, srcs, nsrcs, addr_size);
 		break;
 	case MCAST_EXCLUDE:
-		changed = __eht_block_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		__eht_block_excl(pg, h_addr, srcs, nsrcs, addr_size);
 		break;
 	}
 
-- 
2.29.2

