Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EB8273BE2
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgIVHas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729988AbgIVHar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:30:47 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F345AC0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id m6so15882932wrn.0
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HukKeZEePLGYcfWW3UN/WsRcjshJ3r821tIfQZy/ZXg=;
        b=Jbqg/TzeW6oZ+xYGQtPbwLgQGMhh0EGojkRkGTbDxy5sSezp8mWN4Sm1QuOA1nVTCM
         JWtmLXeostYtNuxCX6VT5E7PVGuqw+K9bmATarGTzQrAgUiEQ27lQqat0FefjrhRb+uw
         WXtQPnPuVP79PHwD15gffT8ah0ji8zECaQx0Gt6Naw2IdLiqgG80URDeyRLdIsYuef9U
         wSm7FNo6Hff6tHR0yB46n78K7doQPapRyhoL+41nAx1kUd7o31yOz13Tg+ZlaT9PmOSS
         T+E5YRBwkr5qZipqb4ru93413QIb9NRewlGBzbEZUn3UGgMWxih3ULBwclNOIixG4Rwd
         JB9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HukKeZEePLGYcfWW3UN/WsRcjshJ3r821tIfQZy/ZXg=;
        b=HC1BBF1mP7ym118PgWCtgi/LLu8fuSp1dn/Bbqh2MreTbLSn/bQ774npCLdzHFwis+
         BYXLY+NNAVOWBESXp0fQfH7szuhd+urVMYPDXRYB9c5WZCgW9dPlgP01PWArfhez4orI
         SCqCwPm9h3uQZFAs9q5vck9hjRoDnnC5O8u56Ox472/UwDfH1c2X/LRTB3VNjugsv74H
         5+jHTUCyJCJLFN/sVpX+k2h7xnLZLZG09CteZ7MU7kUA8fBOlYfMa2XUQxJS24t+Y7Jh
         dY5G3IVFV7e5mlLFp/yPAEvvO161biFxPLcD7+Uv9ul//F/EkjLvztWU8URA6fC0px9/
         tBNA==
X-Gm-Message-State: AOAM531MqooNKOiZwfMV7OubpvVec4PClzRRiAp+lmyGhcoBLiAJ1DB0
        8JSskMYN8rodfD4TVm67ZUuH1GuRdc1HEn+CD0Rihw==
X-Google-Smtp-Source: ABdhPJxyMatLB50WF+Rl3C5Oj4OVbyMfYn3liqw/bnCH1IbLO7IwpgO7ximUBMcirMa7SoE9IwD4RQ==
X-Received: by 2002:adf:e407:: with SMTP id g7mr3663164wrm.349.1600759845406;
        Tue, 22 Sep 2020 00:30:45 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s26sm3258287wmh.44.2020.09.22.00.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 00:30:44 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 02/16] net: bridge: mdb: move all port and bridge checks to br_mdb_add
Date:   Tue, 22 Sep 2020 10:30:13 +0300
Message-Id: <20200922073027.1196992-3-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200922073027.1196992-1-razor@blackwall.org>
References: <20200922073027.1196992-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

To avoid doing duplicate device checks and searches (the same were done
in br_mdb_add and __br_mdb_add) pass the already found port to __br_mdb_add
and pull the bridge's netif_running and enabled multicast checks to
br_mdb_add. This would also simplify the future extack errors.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_mdb.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index d4031f5554f7..92ab7369fee0 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -775,31 +775,18 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 }
 
 static int __br_mdb_add(struct net *net, struct net_bridge *br,
+			struct net_bridge_port *p,
 			struct br_mdb_entry *entry)
 {
 	struct br_ip ip;
-	struct net_device *dev;
-	struct net_bridge_port *p = NULL;
 	int ret;
 
-	if (!netif_running(br->dev) || !br_opt_get(br, BROPT_MULTICAST_ENABLED))
-		return -EINVAL;
-
-	if (entry->ifindex != br->dev->ifindex) {
-		dev = __dev_get_by_index(net, entry->ifindex);
-		if (!dev)
-			return -ENODEV;
-
-		p = br_port_get_rtnl(dev);
-		if (!p || p->br != br || p->state == BR_STATE_DISABLED)
-			return -EINVAL;
-	}
-
 	__mdb_entry_to_br_ip(entry, &ip);
 
 	spin_lock_bh(&br->multicast_lock);
 	ret = br_mdb_add_group(br, p, &ip, entry);
 	spin_unlock_bh(&br->multicast_lock);
+
 	return ret;
 }
 
@@ -821,6 +808,9 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	br = netdev_priv(dev);
 
+	if (!netif_running(br->dev) || !br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		return -EINVAL;
+
 	if (entry->ifindex != br->dev->ifindex) {
 		pdev = __dev_get_by_index(net, entry->ifindex);
 		if (!pdev)
@@ -840,12 +830,12 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			entry->vid = v->vid;
-			err = __br_mdb_add(net, br, entry);
+			err = __br_mdb_add(net, br, p, entry);
 			if (err)
 				break;
 		}
 	} else {
-		err = __br_mdb_add(net, br, entry);
+		err = __br_mdb_add(net, br, p, entry);
 	}
 
 	return err;
-- 
2.25.4

