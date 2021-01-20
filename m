Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B8F2FD45A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733111AbhATPk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390085AbhATOzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:55:22 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77667C06179F
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:17 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id r12so22536106ejb.9
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qa2CnxrmfdpWhxwQfNcz/QRx0LAMcqvtJo3oWicVNSc=;
        b=zXXHq7R/yS26GFBFwlhLMCwY2QJ6QfAT6vp6c8h2+sA2NkO70FVxe2VxT/KvT2isvj
         xt5l/rUzNzrkKVk2HYgFBCuvJtQBc4LDSrClvDckfvV4yoYSctMTYDdIieyJFMOQT3Su
         4wK/6NQUapdz4d4tnn6aS7B5CdnJqIiDJzT4x4Y7Y7UDAabstt2pI4pNXF0/kqZOF6d4
         mpdFcAS6dIgX/twCCcqUX0jTQGMbJmQXQU1AbySYTjJGutXLgzffldqQLJffQiPYUIX1
         FK9CD5YMEJuZMIrBCtysDcHxhN5rGV4m1NRexk63viIvBj4OMVN9bh2lPl8vYzxyBbBP
         mE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qa2CnxrmfdpWhxwQfNcz/QRx0LAMcqvtJo3oWicVNSc=;
        b=bZuR5LXd+EdV/AUjKYPSKOX9zf/jX5BgqQ20AxFCLbaa5aHMLuTIYVQXlHWg08QHBw
         RQRcykjUnPtizAk5yBz5TRsSNvmU1GKOhx2OnHJhmr2DHjAaunJc6htXTgrFvWGx7J7w
         6gFVBxoeuPl1rzSaexOrebMHoXGRTrvkOEqJ7vpWX52lO74Mw/SJeZQmMxeIOLKaSusZ
         dSJPtqlUut7pY6nE/Px5JeidCe5X6xTVjsL0vGyCG5CTMYy6QNQ0tgImjfN2oYjqnBB5
         5IBq6yfl7mXJqI3Zm/P6fZgAYjizwjUghnCdycn4hC79BjnyMsEhPX5npgvHJRVDTSAq
         yBCA==
X-Gm-Message-State: AOAM530FksE+Hekn2/huZTfKiIZltmN/QXY0ZwVfoafKnJHO1yhY8c4z
        bUfjTeSC8zxPqGcyEenby9+elKPvQIrwOEns6KI=
X-Google-Smtp-Source: ABdhPJxmT9ZM1e1S1IYSplPXmd+BQLBx7gybs5NRVmo4HVJ+nYOnaVqmzhxnzTBMFduMMwOvD9GCVQ==
X-Received: by 2002:a17:906:6b91:: with SMTP id l17mr6029683ejr.171.1611154395907;
        Wed, 20 Jan 2021 06:53:15 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:15 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 11/14] net: bridge: multicast: optimize TO_INCLUDE EHT timeouts
Date:   Wed, 20 Jan 2021 16:52:00 +0200
Message-Id: <20210120145203.1109140-12-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

This is an optimization specifically for TO_INCLUDE which sends queries
for the older entries and thus lowers the S,G timers to LMQT. If we have
the following situation for a group in either include or exclude mode:
 - host A was interested in srcs X and Y, but is timing out
 - host B sends TO_INCLUDE src Z, the bridge lowers X and Y's timeouts
   to LMQT
 - host B sends BLOCK src Z after LMQT time has passed
 => since host B is the last host we can delete the group, but if we
    still have host A's EHT entries for X and Y (i.e. if they weren't
    lowered to LMQT previously) then we'll have to wait another LMQT
    time before deleting the group, with this optimization we can
    directly remove it regardless of the group mode as there are no more
    interested hosts

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast_eht.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index 861ae63f4a1c..fee3060d0495 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -656,6 +656,8 @@ static bool __eht_inc_exc(struct net_bridge_port_group *pg,
 	}
 	/* we can be missing sets only if we've deleted some entries */
 	if (flush_entries) {
+		struct net_bridge *br = pg->key.port->br;
+		struct net_bridge_group_eht_set *eht_set;
 		struct net_bridge_group_src *src_ent;
 		struct hlist_node *tmp;
 
@@ -667,6 +669,25 @@ static bool __eht_inc_exc(struct net_bridge_port_group *pg,
 				changed = true;
 				continue;
 			}
+			/* this is an optimization for TO_INCLUDE where we lower
+			 * the set's timeout to LMQT to catch timeout hosts:
+			 * - host A (timing out): set entries X, Y
+			 * - host B: set entry Z (new from current TO_INCLUDE)
+			 *           sends BLOCK Z after LMQT but host A's EHT
+			 *           entries still exist (unless lowered to LMQT
+			 *           so they can timeout with the S,Gs)
+			 * => we wait another LMQT, when we can just delete the
+			 *    group immediately
+			 */
+			if (!(src_ent->flags & BR_SGRP_F_SEND) ||
+			    filter_mode != MCAST_INCLUDE ||
+			    !to_report)
+				continue;
+			eht_set = br_multicast_eht_set_lookup(pg,
+							      &eht_src_addr);
+			if (!eht_set)
+				continue;
+			mod_timer(&eht_set->timer, jiffies + br_multicast_lmqt(br));
 		}
 	}
 
-- 
2.29.2

