Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E8C2FD43B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbhATPgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389371AbhATOxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:53:53 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D07FC061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:08 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id l9so28201797ejx.3
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tmDUabnqk1Pty9P4k0A64Em1MebogJSVfDgcn6fzSUI=;
        b=SO6ZvCIn9S8u1uv792Ep9fk19Ucb4M5W59iyd6dVwKqWs4iumavWFIJAb3t2miittn
         SsbJwBzgzzHT6p6d62RFNuGx7I0SVaxbqCwwnlWFYJnhBbMAvBVNhFxVluobQKjg7g7p
         CxqJdDRgiCCm1ZHa4vpXrPHDOWc6rLWx8GF21z29a8SxGBNtLn2UCdkGnP4T85bnWgkP
         jAa8iNrx9ubDft/rwnz6W1ik1HQy1tFidNAXmkpLpTBf4BeOShEgb/+Pms/bfDBHyJZL
         XNYcRxb5LaYRQ/YBryIxIzagge2j8WA4R01w19Ve7U041p07xsOLSLFwgvAJq7gzYJ+Q
         1Tpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tmDUabnqk1Pty9P4k0A64Em1MebogJSVfDgcn6fzSUI=;
        b=fwqFyDoLLqfwDDeMD7tiHWLFbnqlu/eA+An3rvU1x1JMxHFznoR1p+txaYwuVkH6aO
         bgGW5GyFTahqY88kMKWGIVW/3NZc+CP+tvKqdyNvPb5cAf39WUCBAEEHDz3r41sxQfqh
         YQ0SNSX31BplaIT7slm4a4nyhD8846l2C+IVyusRyBV1vl0aPnHgHzgW6kbZIRpUjj+a
         WH4w/z7O3u8nlkUtwaX3HeWFVLHtRQPW3KLLKRvjGcxMAgT2x1z2LT+yG1NDuSQdL5Bd
         46dImKLOgph8DkkyobKgqJ7eU0OHDFDflpF2iaxt6jpv6SqHBiacsZKIP7OscO2GeCug
         Rkaw==
X-Gm-Message-State: AOAM530RWdSBHl1ljmv/JgiGMl7HuTg1h3B9HBLnplEzBevWfAX9T/p2
        pJS+MgiVSFAM3aIhtDnEsPuu8WxcQyXjdkvMVRs=
X-Google-Smtp-Source: ABdhPJxy0vBsbJDT1Mg/ShgGVB/dLIqXZxh45hnxRmlGTJp7NDf7gI2Qn5yuX0U1zU9atMnLZG6taA==
X-Received: by 2002:a17:906:fa85:: with SMTP id lt5mr6465403ejb.344.1611154386913;
        Wed, 20 Jan 2021 06:53:06 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:06 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 04/14] net: bridge: multicast: calculate idx position without changing ptr
Date:   Wed, 20 Jan 2021 16:51:53 +0200
Message-Id: <20210120145203.1109140-5-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need to preserve the srcs pointer since we'll be passing it for EHT
handling later.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 79569a398669..f8b685ae56d4 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1812,7 +1812,7 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg, void *h_a
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.src, srcs, addr_size);
+		memcpy(&src_ip.src, srcs + (src_idx * addr_size), addr_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (!ent) {
 			ent = br_multicast_new_group_src(pg, &src_ip);
@@ -1822,7 +1822,6 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg, void *h_a
 
 		if (ent)
 			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
-		srcs += addr_size;
 	}
 
 	return changed;
@@ -1846,7 +1845,7 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg, void *h_addr,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.src, srcs, addr_size);
+		memcpy(&src_ip.src, srcs + (src_idx * addr_size), addr_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent)
 			ent->flags &= ~BR_SGRP_F_DELETE;
@@ -1854,7 +1853,6 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg, void *h_addr,
 			ent = br_multicast_new_group_src(pg, &src_ip);
 		if (ent)
 			br_multicast_fwd_src_handle(ent);
-		srcs += addr_size;
 	}
 
 	__grp_src_delete_marked(pg);
@@ -1882,7 +1880,7 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg, void *h_addr,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.src, srcs, addr_size);
+		memcpy(&src_ip.src, srcs + (src_idx * addr_size), addr_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags &= ~BR_SGRP_F_DELETE;
@@ -1894,7 +1892,6 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg, void *h_addr,
 				changed = true;
 			}
 		}
-		srcs += addr_size;
 	}
 
 	if (__grp_src_delete_marked(pg))
@@ -1946,7 +1943,7 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg, void *h_addr,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.src, srcs, addr_size);
+		memcpy(&src_ip.src, srcs + (src_idx * addr_size), addr_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags &= ~BR_SGRP_F_SEND;
@@ -1958,7 +1955,6 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 		if (ent)
 			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
-		srcs += addr_size;
 	}
 
 	if (to_send)
@@ -1989,7 +1985,7 @@ static bool __grp_src_toin_excl(struct net_bridge_port_group *pg, void *h_addr,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.src, srcs, addr_size);
+		memcpy(&src_ip.src, srcs + (src_idx * addr_size), addr_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			if (timer_pending(&ent->timer)) {
@@ -2003,7 +1999,6 @@ static bool __grp_src_toin_excl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 		if (ent)
 			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
-		srcs += addr_size;
 	}
 
 	if (to_send)
@@ -2050,7 +2045,7 @@ static void __grp_src_toex_incl(struct net_bridge_port_group *pg, void *h_addr,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.src, srcs, addr_size);
+		memcpy(&src_ip.src, srcs + (src_idx * addr_size), addr_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags = (ent->flags & ~BR_SGRP_F_DELETE) |
@@ -2061,7 +2056,6 @@ static void __grp_src_toex_incl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 		if (ent)
 			br_multicast_fwd_src_handle(ent);
-		srcs += addr_size;
 	}
 
 	__grp_src_delete_marked(pg);
@@ -2090,7 +2084,7 @@ static bool __grp_src_toex_excl(struct net_bridge_port_group *pg, void *h_addr,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.src, srcs, addr_size);
+		memcpy(&src_ip.src, srcs + (src_idx * addr_size), addr_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags &= ~BR_SGRP_F_DELETE;
@@ -2105,7 +2099,6 @@ static bool __grp_src_toex_excl(struct net_bridge_port_group *pg, void *h_addr,
 			ent->flags |= BR_SGRP_F_SEND;
 			to_send++;
 		}
-		srcs += addr_size;
 	}
 
 	if (__grp_src_delete_marked(pg))
@@ -2156,13 +2149,12 @@ static bool __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.src, srcs, addr_size);
+		memcpy(&src_ip.src, srcs + (src_idx * addr_size), addr_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags |= BR_SGRP_F_SEND;
 			to_send++;
 		}
-		srcs += addr_size;
 	}
 
 	if (to_send)
@@ -2197,7 +2189,7 @@ static bool __grp_src_block_excl(struct net_bridge_port_group *pg, void *h_addr,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.src, srcs, addr_size);
+		memcpy(&src_ip.src, srcs + (src_idx * addr_size), addr_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (!ent) {
 			ent = br_multicast_new_group_src(pg, &src_ip);
@@ -2210,7 +2202,6 @@ static bool __grp_src_block_excl(struct net_bridge_port_group *pg, void *h_addr,
 			ent->flags |= BR_SGRP_F_SEND;
 			to_send++;
 		}
-		srcs += addr_size;
 	}
 
 	if (to_send)
-- 
2.29.2

