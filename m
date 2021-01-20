Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8B82FD460
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390847AbhATPl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390089AbhATOzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:55:22 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C21C0617A0
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:19 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id d22so15073454edy.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5jQkPW1oWI+QtE/SUX8LB8Nxke3Xa1Ja5TR15s8XBM=;
        b=VSto+BBrYtccrmzfvgYqjDw9lTCwY0paFkZ1TEzTvkPzpIYFTGfGGX5zTXZUuApSg4
         yaEdm+2EOjXox5cfKTbZH8v6dCmVtBeKFcwjNHnerEdXmCWOfSMd/t6jNo/g67fJ3MSI
         L0J1xJVOPZX5qrQ3YPCq8aTGyfoMdSj/6WwbFm0kPbq7hKm3VqOamo5R7GN9fQX/GGCX
         qYyoM7cD1zWlkZvnClNbT32r1mv7eG+UOBjsKtLAtuozUl6+RAor8tGMFYqLFRs9DnnR
         DzRPjBH0sZqVwUN7soCQfZORcd4ga/h7G4ZXabOM47ExgHKiI7lBVKq+xd9jiI2kV8Zh
         OGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5jQkPW1oWI+QtE/SUX8LB8Nxke3Xa1Ja5TR15s8XBM=;
        b=ato4jK93a18nAfyyYXrCSRWiydg8OCFaw+0nnL+ez5l+nUcPkDpxw0XL6jaXBr0y0B
         /dC/gRhpVSZfe9OmU+Pob6+nCCfHu4q3f1LtIWSyOYVIb9g9nB3N5YQN+sCZr5czRRj+
         BklrvJ/SiGZYi1lLTAa9FYYSDAgwOCSuzEkw5wy0K1YjBjnCAtXWCq4BuczucWLXioGR
         wKMCXpHcZArhlChjnPHaiIepHHqFCmSQYOP2r19K6derlv1Oqu6iB6JjQLht4TGIF2HV
         NTB9LBFl4sIbRCVKrHN3rZoKZggj82zZygvqdqjKAOGxlqWScuQcTNH6zjrXMekn/4ng
         UJXA==
X-Gm-Message-State: AOAM531fMh/TAjl7YXUQ31iC/D4dxP9W/GWewOZW2VobGhMsMes2Rbnj
        9SeUTKyyxApSemlKkcCvlFj1vqZNaKNjxgKWRSo=
X-Google-Smtp-Source: ABdhPJwWYuSkeufkkxgl3OhlY6Gt0lgqtw4di+Me457/QoYJ1pAAyH1apGh4YZzbbhk4V9H2LBlMEA==
X-Received: by 2002:a50:c94c:: with SMTP id p12mr1607780edh.154.1611154397707;
        Wed, 20 Jan 2021 06:53:17 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:16 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 12/14] net: bridge: multicast: add EHT host filter_mode handling
Date:   Wed, 20 Jan 2021 16:52:01 +0200
Message-Id: <20210120145203.1109140-13-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We should be able to handle host filter mode changing. For exclude mode
we must create a zero-src entry so the group will be kept even without
any S,G entries (non-zero source sets). That entry doesn't count to the
entry limit and can always be created, its timer is refreshed on new
exclude reports and if we change the host filter mode to include then it
gets removed and we rely only on the non-zero source sets.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast_eht.c | 42 +++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index fee3060d0495..64ccbd4ae9d9 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -381,6 +381,30 @@ static void br_multicast_ip_src_to_eht_addr(const struct br_ip *src,
 	}
 }
 
+static void br_eht_convert_host_filter_mode(struct net_bridge_port_group *pg,
+					    union net_bridge_eht_addr *h_addr,
+					    int filter_mode)
+{
+	struct net_bridge_group_eht_host *eht_host;
+	union net_bridge_eht_addr zero_addr;
+
+	eht_host = br_multicast_eht_host_lookup(pg, h_addr);
+	if (eht_host)
+		eht_host->filter_mode = filter_mode;
+
+	memset(&zero_addr, 0, sizeof(zero_addr));
+	switch (filter_mode) {
+	case MCAST_INCLUDE:
+		br_multicast_del_eht_set_entry(pg, &zero_addr, h_addr);
+		break;
+	case MCAST_EXCLUDE:
+		br_multicast_create_eht_set_entry(pg, &zero_addr, h_addr,
+						  MCAST_EXCLUDE,
+						  true);
+		break;
+	}
+}
+
 static void br_multicast_create_eht_set_entry(struct net_bridge_port_group *pg,
 					      union net_bridge_eht_addr *src_addr,
 					      union net_bridge_eht_addr *h_addr,
@@ -701,8 +725,13 @@ static bool br_multicast_eht_inc(struct net_bridge_port_group *pg,
 				 size_t addr_size,
 				 bool to_report)
 {
-	return __eht_inc_exc(pg, h_addr, srcs, nsrcs, addr_size, MCAST_INCLUDE,
-			     to_report);
+	bool changed;
+
+	changed = __eht_inc_exc(pg, h_addr, srcs, nsrcs, addr_size,
+				MCAST_INCLUDE, to_report);
+	br_eht_convert_host_filter_mode(pg, h_addr, MCAST_INCLUDE);
+
+	return changed;
 }
 
 static bool br_multicast_eht_exc(struct net_bridge_port_group *pg,
@@ -712,8 +741,13 @@ static bool br_multicast_eht_exc(struct net_bridge_port_group *pg,
 				 size_t addr_size,
 				 bool to_report)
 {
-	return __eht_inc_exc(pg, h_addr, srcs, nsrcs, addr_size, MCAST_EXCLUDE,
-			     to_report);
+	bool changed;
+
+	changed = __eht_inc_exc(pg, h_addr, srcs, nsrcs, addr_size,
+				MCAST_EXCLUDE, to_report);
+	br_eht_convert_host_filter_mode(pg, h_addr, MCAST_EXCLUDE);
+
+	return changed;
 }
 
 static bool __eht_ip4_handle(struct net_bridge_port_group *pg,
-- 
2.29.2

