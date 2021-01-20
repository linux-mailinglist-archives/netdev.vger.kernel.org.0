Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E922FD42F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbhATPgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389352AbhATOxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:53:48 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38971C061796
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:07 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ke15so26213158ejc.12
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=grXUCar2XJM0EhIEo7HicVui+NQZU/ry4BRH3wt7hj0=;
        b=bwTiWJCkTV8X0YYr6p1yygOiDoXZVkQLuSTXyZFyBRL4YwR51pnNLQYKJQMP9xzaD+
         OkLelqhLxfctW7DqIWzgQlNZ1CWcv79oyUtC4FwNpcmsOrDoiilyYCId1LIYXQkymJMW
         DRmOwzmyKpb5guLdm7rF/JIwxH01M32RPzBOTCuFQg+sHcq5E8Usm7wRzgPRjBPEZxSg
         BwZ1wusFpwyZ8HUq5RPIRZ4Xtg1C4GLB6G10b0HxIXupkikwswLLzSIc+Utgz4bL11gt
         A2v/DYWZTQTS0SEZ4Jut0TYhKX0/TQMWuPr/3UCHhxvFCZin3XkYd0uELPAUp2lLzwGi
         TuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=grXUCar2XJM0EhIEo7HicVui+NQZU/ry4BRH3wt7hj0=;
        b=X3SxIr2nQ87QVI/QxNFePMIheZt1b6N9/umgclw0EUgkqj0kweBSG021TPwl+xLebx
         iQs6152KPiiR+LfOAF8hTNWll1cVgm8j0Xjow4qf5z6YY5qiYgrNpF/0NiGXrP1SY4FC
         /WwdY5rfCYiMqCSbMfRM7oqIkzihlVtBK4b+pWhFEEeS90zjvRcYndofCASw88ostRCH
         FFmbelvwDzWnrH4Az1Tvq36WxsyvKxLLwYsAAxwTdiehlUmHXVAYBSOgqV/6rFjdhC9s
         rqY0pHvnu8rKueS1V1UDZ0EsxaK4L6SWpFgYIpau3WcfhxPXNOxUetBvRR4QTJQapZlH
         bqdQ==
X-Gm-Message-State: AOAM533BvhZwzAaXVCmubqBilAoPHwab8UA2wAtBgDXeaTjJniU/vMqL
        boyT2l0LsyqgFm7T+eib/CTYNNimdCPcMMURHoY=
X-Google-Smtp-Source: ABdhPJxa33gUVVUIUZzDRHNiILV/WtGhpVCodbfyLOywxxObnEHvdQ7oXkQBF/MckjYDxgEdn7yu8A==
X-Received: by 2002:a17:906:5495:: with SMTP id r21mr6379742ejo.59.1611154385674;
        Wed, 20 Jan 2021 06:53:05 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:05 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 03/14] net: bridge: multicast: __grp_src_block_incl can modify pg
Date:   Wed, 20 Jan 2021 16:51:52 +0200
Message-Id: <20210120145203.1109140-4-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Prepare __grp_src_block_incl() for being able to cause a notification
due to changes. Currently it cannot happen, but EHT would change that
since we'll be deleting sources immediately. Make sure that if the pg is
deleted we don't return true as that would cause the caller to access
freed pg. This patch shouldn't cause any functional change.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 861545094d67..79569a398669 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2142,11 +2142,12 @@ static bool br_multicast_toex(struct net_bridge_port_group *pg, void *h_addr,
 /* State          Msg type      New state                Actions
  * INCLUDE (A)    BLOCK (B)     INCLUDE (A)              Send Q(G,A*B)
  */
-static void __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
+static bool __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
 				 void *srcs, u32 nsrcs, size_t addr_size)
 {
 	struct net_bridge_group_src *ent;
 	u32 src_idx, to_send = 0;
+	bool changed = false;
 	struct br_ip src_ip;
 
 	hlist_for_each_entry(ent, &pg->src_list, node)
@@ -2167,8 +2168,15 @@ static void __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
 	if (to_send)
 		__grp_src_query_marked_and_rexmit(pg);
 
-	if (pg->filter_mode == MCAST_INCLUDE && hlist_empty(&pg->src_list))
+	if (pg->filter_mode == MCAST_INCLUDE && hlist_empty(&pg->src_list)) {
 		br_multicast_find_del_pg(pg->key.port->br, pg);
+		/* a notification has already been sent and we shouldn't access
+		 * pg after the delete thus we have to return false
+		 */
+		changed = false;
+	}
+
+	return changed;
 }
 
 /* State          Msg type      New state                Actions
@@ -2218,7 +2226,7 @@ static bool br_multicast_block(struct net_bridge_port_group *pg, void *h_addr,
 
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
-		__grp_src_block_incl(pg, h_addr, srcs, nsrcs, addr_size);
+		changed = __grp_src_block_incl(pg, h_addr, srcs, nsrcs, addr_size);
 		break;
 	case MCAST_EXCLUDE:
 		changed = __grp_src_block_excl(pg, h_addr, srcs, nsrcs, addr_size);
-- 
2.29.2

