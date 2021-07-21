Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9120E3D106D
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237806AbhGUNWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237641AbhGUNWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:22:03 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0669DC061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:02:40 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ee25so2532117edb.5
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LfptcPBAYX0XhZdNHSy9bCep6fygv+/dGc7yUbbpivY=;
        b=tPzfUROJpfPxtn5NDGuRsLr0LgX/7zCT7p3xJLZyn3uh+3WOwUSpPJJ/q1B6jKZ2ih
         vNOUeLRiLOUfVBaUjvw8fMtJDXgDfUyaT+DBst12kTsRkoFioi8BiBH0LSpYkVNBclW1
         ZJ0ZpdbUdv0cSHZHvHgs1C9WJnj4MBWREsneHrPFg4F4bYBxsUnfYg95JXAfrq67nKE1
         Ek/VPnGlT2T5TK6/zUFeT+WZZ2cHqiuNjOFsTtC0vo6Mo5YjywW0Z3UqPV1+SrFBuMHL
         4J6epLZZRO5+PQ/saO9eeQiS2f25Y7EM+ub5LStvSsQnVbGMhySMQFtiev50zRVR8E0h
         YNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LfptcPBAYX0XhZdNHSy9bCep6fygv+/dGc7yUbbpivY=;
        b=fcXIllgDvHP0dKzL/5ZxCI+kOLBHbP20z8ETu6eYNgez//h1Hv5qKdmAD45Jrdx56l
         BW9+WVmKP8E6a2K5udhWfhXulV0TLo+66cfapPetdOgl8c5tWXX790FOavUwgQTn/oB0
         Ywo+56+bt+Lu4iw8vF4US5KagFhuJM4w6RO9bCoaMmgpz0UWDFcv8xLnnfQOrahm7FP8
         wg4FLvb7ZA4Ti1buXSq+om8gaEPg3zS0iTjMZlVvyqAPdkNLSo99Y/khmYpkP1CcWVdN
         cuexx5+32mgI+pFYspUmBAO1NBIqO7/rRXLhobG0sro8cenTgGG93B+MsvYFGUNKfWeM
         WKtQ==
X-Gm-Message-State: AOAM531ZUD1WhRVTvqb00pAQKxqe7Vzp99kYHURpudMDZHjSghd4R45n
        VkpoZyXQc7GCJNqWu3xi9AifGpvr2dZTz51c1WU=
X-Google-Smtp-Source: ABdhPJxZXQrVmrNF5JExcv2srRYuC902Expj95CbBopvl0rNECDdB2m65ran5yLzVh3POG6EROrD1g==
X-Received: by 2002:a05:6402:1bc6:: with SMTP id ch6mr49123596edb.267.1626876158376;
        Wed, 21 Jul 2021 07:02:38 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm8362925ejc.61.2021.07.21.07.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 07:02:38 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 2/2] net: bridge: multicast: add context support for host-joined groups
Date:   Wed, 21 Jul 2021 17:01:27 +0300
Message-Id: <20210721140127.773194-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721140127.773194-1-razor@blackwall.org>
References: <20210721140127.773194-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Adding bridge multicast context support for host-joined groups is easy
because we only need the proper timer value. We pass the already chosen
context and use its timer value.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_mdb.c       | 2 +-
 net/bridge/br_multicast.c | 8 ++++----
 net/bridge/br_private.h   | 3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 7b6c3b91d272..25d690b96cec 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1105,7 +1105,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			return -EEXIST;
 		}
 
-		br_multicast_host_join(mp, false);
+		br_multicast_host_join(brmctx, mp, false);
 		br_mdb_notify(br->dev, mp, NULL, RTM_NEWMDB);
 
 		return 0;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 214d1bf854ad..470f1ec3b579 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1312,7 +1312,8 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	return p;
 }
 
-void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
+void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
+			    struct net_bridge_mdb_entry *mp, bool notify)
 {
 	if (!mp->host_joined) {
 		mp->host_joined = true;
@@ -1325,8 +1326,7 @@ void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
 	if (br_group_is_l2(&mp->addr))
 		return;
 
-	mod_timer(&mp->timer,
-		  jiffies + mp->br->multicast_ctx.multicast_membership_interval);
+	mod_timer(&mp->timer, jiffies + brmctx->multicast_membership_interval);
 }
 
 void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
@@ -1363,7 +1363,7 @@ __br_multicast_add_group(struct net_bridge_mcast *brmctx,
 		return ERR_CAST(mp);
 
 	if (!pmctx) {
-		br_multicast_host_join(mp, true);
+		br_multicast_host_join(brmctx, mp, true);
 		goto out;
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index af1f5c1c6b88..30fb56637049 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -900,7 +900,8 @@ void br_multicast_get_stats(const struct net_bridge *br,
 			    struct br_mcast_stats *dest);
 void br_mdb_init(void);
 void br_mdb_uninit(void);
-void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify);
+void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
+			    struct net_bridge_mdb_entry *mp, bool notify);
 void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify);
 void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 				     u8 filter_mode);
-- 
2.31.1

