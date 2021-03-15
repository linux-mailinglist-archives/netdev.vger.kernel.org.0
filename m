Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E82833C024
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhCOPjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCOPil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:38:41 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E14C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:38:41 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ox4so51374560ejb.11
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pSnoj4e/ExDdUTJVarAFVjEzOpsYS4SYmIolgEK8kPA=;
        b=btzVLGD0JsiuQOFZ1RApGKE+BiAn7GxufYnvaHzTVZ8bxMdYffd/TF17HWmYQFyP4a
         9W3pX5AZiJ3JEHMK1t3TxPoQixS6VQN55vSA7GGelBUToazQk2LmJi1bsRBYGTzVCKBF
         jfn2zhqe7z3L2MxtHGQoBCXNRB9X/aQc7FzJipDCnEG/K5nUhrQU9wH/P9Xov66tVvls
         MzqPCq0QtezbTFPdVjg5Zn7qY2mKDFVHmJe4zb1wdfegCY3DMm0zIfngI+838MFdyarl
         jA8AbyHN5zVbFevyFm1tj0BwSUkzFvtW95184PZwa7dJb8fq/5ZSun2pLRYXw3/iLANi
         dZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pSnoj4e/ExDdUTJVarAFVjEzOpsYS4SYmIolgEK8kPA=;
        b=rEYm+0wkNEw2Db2cajRknMKFgZOoY3Go+b5xdtY/3KywS737yqaq4AX17CuLKknawq
         p4g1eco7uIvkpeZQE16Z/yfLHrhaSs7vVmcWHB8GsV80nkem8L2j8upPL0TxQp5SUvuy
         5aWY9kOGsI5GHKZ2OSlO+VS7Q8qUEVexMTdbNqN+sIL9ioGFnkHzDjZSGUuc4PtAxs31
         w55Ui9JLZW4GC7We/afXkX5jwBorwnYL0BJoyH/0hXPn7KISBV2/4g7wmbQOe6NJWcrH
         IhTpB3Qc8o4S1e1o92feOa/njOUuCB148a+OhpDAQJYkr1q1MxvA9Lm+BBBYsdyVDfT/
         gycQ==
X-Gm-Message-State: AOAM530V7171485rJ3Vym9DYVS8xnnwqsXVJv5cE/1UjSxmGebldbnij
        TsGdsMPMok39mOanhVtMpKfchnPnVQNBGQn8
X-Google-Smtp-Source: ABdhPJzr+BbCGjtjL1DScostU4Y5Bs6ZGhPEUyzHVEGeWSZECleKWXrUaYo3owBfZU1XBeA8bgFTTQ==
X-Received: by 2002:a17:906:aed6:: with SMTP id me22mr24496935ejb.146.1615822719474;
        Mon, 15 Mar 2021 08:38:39 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id gj26sm7500174ejb.67.2021.03.15.08.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:38:39 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next] net: bridge: mcast: remove unreachable EHT code
Date:   Mon, 15 Mar 2021 17:38:35 +0200
Message-Id: <20210315153835.190174-1-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
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
 net/bridge/br_multicast_eht.c | 54 ++++++++++-------------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index fea38b9a7268..7a72567377ba 100644
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
@@ -602,42 +595,25 @@ static bool __eht_block_incl(struct net_bridge_port_group *pg,
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
 	struct br_ip src_ip;
 	u32 src_idx;
 
-	host_excl = !!(br_multicast_eht_host_filter_mode(pg, h_addr) == MCAST_EXCLUDE);
 	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
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
@@ -653,7 +629,7 @@ static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
 		changed = __eht_block_incl(pg, h_addr, srcs, nsrcs, addr_size);
 		break;
 	case MCAST_EXCLUDE:
-		changed = __eht_block_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		__eht_block_excl(pg, h_addr, srcs, nsrcs, addr_size);
 		break;
 	}
 
-- 
2.29.2

