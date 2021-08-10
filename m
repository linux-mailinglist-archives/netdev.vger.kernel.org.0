Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EF13E7C4C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243259AbhHJPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243091AbhHJPaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:20 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867B2C06179E
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:57 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n11so13341476wmd.2
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8QwqQleoGxCM0RtBR5+pJ1/nVkcUoQV4qf01skg7xRo=;
        b=vJdgSvHwBiANNhd65pdgBC6j5ySWEnDsF1VM5x1cWF7dwvbhOjDqQH7UY9n9thW8m5
         nHadsKPqBjFkVfke5OgXGg7vpkcstkZp+3KlYbjn1viyXU6EaIj15BqdEt3NO6AE3VC4
         TUe++h1+0BSlqqfN3J7yIAq8Di4qKoVKycLYtfwXdfY2S8hMYgTsX9a91PFjR9e+mX4f
         9N4BWGQIitrpbFsJj+b+UtOI5uumGTaFdOPw9inijm0CHCzSj49iY5qvKS/JcH6L0i2n
         01mSqDr04cwoWMh1PK8W+xZD0R6tWWPEvt7sd6TcpXiITSh03PdIoC+M9ye7UBQNc2Ri
         EDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8QwqQleoGxCM0RtBR5+pJ1/nVkcUoQV4qf01skg7xRo=;
        b=p5u5biiP9XxRPvZvkfvAdHsp2ol/gMT57ixGigIo/BadrD5xp2VK+fUcwsAi2iEeRD
         BzCzaxVJ6RjFFjZzdgnmv/dNwlSiMTCEibLuakn0vjwmFbOTam1XJP8Ah1Csx7Cp6TdW
         MwFYWGrLFJLwKXwb5kgxiss8LhJQPZRkLzhmZ7uB9l7decj/bxDLTOOfnPAcL5JKCpPw
         AO5RHfpKMU9oN+DQAja2GRwq66tyPec+rC47DQU8YZdyZ02YLEtrBAMKvblaQlQqHQE6
         9b5JAyP1+EychJu5yvShslH+US+Gw/3d34/rR6mpFSMZdnld1NWoLYyhtXJyK5AVsgfR
         xhaw==
X-Gm-Message-State: AOAM5319oLM+0iAEcQ2oAke7Gwry2/lCTNcfWFSCoLECClugI59crP5N
        Rab5UUIN5zrs7EPlK895jP5B1x8gglwaeVRe
X-Google-Smtp-Source: ABdhPJz/PcyT3sy+RM6YjnW5MhmEj0w+zbXRqCSLP6ZjLF8qUIvQ2VMEvd/6s29yUwo840XgXbmhLw==
X-Received: by 2002:a05:600c:3b91:: with SMTP id n17mr5246420wms.72.1628609395810;
        Tue, 10 Aug 2021 08:29:55 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:55 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 11/15] net: bridge: mcast: querier and query state affect only current context type
Date:   Tue, 10 Aug 2021 18:29:29 +0300
Message-Id: <20210810152933.178325-12-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810152933.178325-1-razor@blackwall.org>
References: <20210810152933.178325-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

It is a minor optimization and better behaviour to make sure querier and
query sending routines affect only the matching multicast context
depending if vlan snooping is enabled (vlan ctx vs bridge ctx).
It also avoids sending unnecessary extra query packets.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 14 +++++++++-----
 net/bridge/br_private.h   | 11 +++++++++++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index fe1482efd59c..f30c2e5d3142 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1628,7 +1628,8 @@ static void __br_multicast_send_query(struct net_bridge_mcast *brmctx,
 	struct sk_buff *skb;
 	u8 igmp_type;
 
-	if (!br_multicast_ctx_should_use(brmctx, pmctx))
+	if (!br_multicast_ctx_should_use(brmctx, pmctx) ||
+	    !br_multicast_ctx_matches_vlan_snooping(brmctx))
 		return;
 
 again_under_lmqt:
@@ -3875,9 +3876,9 @@ void br_multicast_open(struct net_bridge *br)
 					__br_multicast_open(&vlan->br_mcast_ctx);
 			}
 		}
+	} else {
+		__br_multicast_open(&br->multicast_ctx);
 	}
-
-	__br_multicast_open(&br->multicast_ctx);
 }
 
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx)
@@ -4028,9 +4029,9 @@ void br_multicast_stop(struct net_bridge *br)
 					__br_multicast_stop(&vlan->br_mcast_ctx);
 			}
 		}
+	} else {
+		__br_multicast_stop(&br->multicast_ctx);
 	}
-
-	__br_multicast_stop(&br->multicast_ctx);
 }
 
 void br_multicast_dev_del(struct net_bridge *br)
@@ -4175,6 +4176,9 @@ static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
 {
 	struct net_bridge_port *port;
 
+	if (!br_multicast_ctx_matches_vlan_snooping(brmctx))
+		return;
+
 	__br_multicast_open_query(brmctx->br, query);
 
 	rcu_read_lock();
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 50f38d6f586d..25db6b02b042 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1209,6 +1209,17 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 #endif
 	       true;
 }
+
+static inline bool
+br_multicast_ctx_matches_vlan_snooping(const struct net_bridge_mcast *brmctx)
+{
+	bool vlan_snooping_enabled;
+
+	vlan_snooping_enabled = !!br_opt_get(brmctx->br,
+					     BROPT_MCAST_VLAN_SNOOPING_ENABLED);
+
+	return !!(vlan_snooping_enabled == br_multicast_ctx_is_vlan(brmctx));
+}
 #else
 static inline int br_multicast_rcv(struct net_bridge_mcast **brmctx,
 				   struct net_bridge_mcast_port **pmctx,
-- 
2.31.1

