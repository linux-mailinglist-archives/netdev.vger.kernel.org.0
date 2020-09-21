Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFE527218B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgIUK4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgIUK4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:13 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7B5C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id w5so12230878wrp.8
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HukKeZEePLGYcfWW3UN/WsRcjshJ3r821tIfQZy/ZXg=;
        b=zBzNWb7VdE9Q36qyv7OwhfmFqotkR2aY5W7WVgs+kaLvTlgIHTkL3yIzSdhix26eXK
         N14rE7Juhg5xYmRliNHv+HRGD9HG7jMjR8+iEKAWLhdWoa1kck/5UI6roONW7mGhEEt4
         v6jPHNV3RB4HZ1c6LQDjY/SWlkbXgdfk4f9qMFME/aV2C94DtnckPz5F0MJ5xE1+LiBR
         qFfsdVbz3xDgB9evtN1bC9N8ujlEpF7olz3hfkGsrsYte95xOkcJxWtrWHOboURLBG+P
         VltAISB7auya4dUR9tlRNAafzyW/c/gH8HMNx6ntb6aGX7F7GsJG+hF6brWJnXJhvgzo
         fZxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HukKeZEePLGYcfWW3UN/WsRcjshJ3r821tIfQZy/ZXg=;
        b=I435rwnYb9FMtLV/wizb7Orfg8LFxkIHM7G1ruhgjOO+h9CCceOVExpDbRkHt0TObf
         kqABjr8HNGw02z4wfAKlefcb99BiIm26umLhiNizTt+/wyOGwi3suU0Mzxcm1dfu98If
         47S1qOTEKSCWjqAAuETOpk4NMFXbADnwTZ1FdOuzEqqDRS3J+tq5djlkr9nPcQIaovfo
         1xNv3s+F3xS4+oo7v+gEykDOJbqS+x+xjI2JvL0JBEgh7+T+u5cWYK9lszetnKpwGye4
         NysizfWh7iBgJDUYR6FFYOxg+MnL2HqS6e/W9bL1ThAbH04HWl6EfsFvaAFC+g13kG0j
         7CjQ==
X-Gm-Message-State: AOAM532Zic3/6Acsv7WCDD8GbUomU9kynSRT6+WpEOsN8S1vtpmtqxpJ
        pMw7kw8Zkmu2GVb0sdY6XTn7QiOEpyUB+XP+774=
X-Google-Smtp-Source: ABdhPJyMsHr2H8QAJEKGoAm1iP0xUuCideYBH3Cc/NTldklnevdWpO2QqGn5je9v0fqOu6Yu/N7bPA==
X-Received: by 2002:adf:912b:: with SMTP id j40mr51850322wrj.42.1600685771267;
        Mon, 21 Sep 2020 03:56:11 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:10 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 02/16] net: bridge: mdb: move all port and bridge checks to br_mdb_add
Date:   Mon, 21 Sep 2020 13:55:12 +0300
Message-Id: <20200921105526.1056983-3-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
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

