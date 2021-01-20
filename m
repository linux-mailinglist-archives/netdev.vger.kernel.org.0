Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003A52FD45F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390518AbhATPly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390115AbhATOzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:55:22 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5910FC0617A2
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:20 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hs11so31578182ejc.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+STi29hPfYbEluynEPrqxJhUnb3kYXkKj59XvyzIrkI=;
        b=gw9hqq9f8UYLKQ3/frZqRj4yGcT5JoTx8h+qZZcPdKSkwV7UG1blZ6v6s95U31wjMD
         D3nvR0HHMk10aDQU4O1uGCPPnraNsucZKBazqdIM0p/eIo102Qs/KB8BbrVyXLTZGXYS
         sl2H9hjhFRSD/qA1AZpsseHL70luzmKwG46sfASteXAx0jxfOgymGpBXJP45uTi1BOWr
         LkMxckcqkWAEB9+8dtbRoGN0q/v+/9oCG889oic+n3rtCaLXBVYkTN5b2Qyw1bQLU1vI
         e86r6ca6F8g6z3GV/yLX+pvF/sTMT0daUvY6Q/LDTcRLJXrZxemw0fiKYU9NbkRO64Zg
         BtQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+STi29hPfYbEluynEPrqxJhUnb3kYXkKj59XvyzIrkI=;
        b=e/DLc8jFHd6rOP6gocDS49uq8YO1Vxu0ExngHLO6UK/oniA9mxBIDLthX4dWYfOZ0u
         9AXlMKQzQNg0rf2zb9Nk9g4T7vPuMz2dPsvoqY9kW5ad77Re6PMonp04XTr2mgAQAxxP
         8wzQSGiUuZpPZRjQcX2CKBWTCUJKy2iT4Y021A5K1pn5PoyTq2ORQ7Wt/6W0IrXFhR8h
         wTUfxWYwP5UeQjwChOwyqu7IHF5Wn9y+BVUUu0tF+p/E55HznKFeNXPZ/gjxHEwYS5nT
         vtU1zQYTcrPn+OCr+8hCywvxn0/AhzN4AkkpBDxmZycsURmTILF56HnZgM6Fgotvw2RZ
         UWKg==
X-Gm-Message-State: AOAM530aI4URI1mvhLkpNLh9wg+2oIPdiTmTqNxTYqqU9lgxOJD5bi9c
        yHK84yqg2qbNS0TypyFjCmahNIusetkT1Ms8thM=
X-Google-Smtp-Source: ABdhPJwNtyWiw0FL1Y1kbo0rl7cQJUgOb0Q+BLoXSJ5tnW4c0HGzLS7VkLST5WGs2BfvAb9ETwgqKA==
X-Received: by 2002:a17:906:52c1:: with SMTP id w1mr6617040ejn.214.1611154398809;
        Wed, 20 Jan 2021 06:53:18 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:18 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 13/14] net: bridge: multicast: handle block pg delete for all cases
Date:   Wed, 20 Jan 2021 16:52:02 +0200
Message-Id: <20210120145203.1109140-14-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

A block report can result in empty source and host sets for both include
and exclude groups so if there are no hosts left we can safely remove
the group. Pull the block group handling so it can cover both cases and
add a check if EHT requires the delete.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9cfc004312ab..47afb1e11daf 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2210,14 +2210,6 @@ static bool __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
 	if (to_send)
 		__grp_src_query_marked_and_rexmit(pg);
 
-	if (pg->filter_mode == MCAST_INCLUDE && hlist_empty(&pg->src_list)) {
-		br_multicast_find_del_pg(pg->key.port->br, pg);
-		/* a notification has already been sent and we shouldn't access
-		 * pg after the delete thus we have to return false
-		 */
-		changed = false;
-	}
-
 	return changed;
 }
 
@@ -2279,6 +2271,15 @@ static bool br_multicast_block(struct net_bridge_port_group *pg, void *h_addr,
 		break;
 	}
 
+	if ((pg->filter_mode == MCAST_INCLUDE && hlist_empty(&pg->src_list)) ||
+	    br_multicast_eht_should_del_pg(pg)) {
+		br_multicast_find_del_pg(pg->key.port->br, pg);
+		/* a notification has already been sent and we shouldn't
+		 * access pg after the delete so we have to return false
+		 */
+		changed = false;
+	}
+
 	return changed;
 }
 
-- 
2.29.2

