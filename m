Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF63273BE3
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgIVHas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729985AbgIVHaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:30:46 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A9FC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so15879735wrm.2
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hUlbZThuj5etaf+babxSJzhQjwbLaOi/wOfX/kpZKzg=;
        b=sXqAL1VPVXSd8E62OpeZO+39n+bjtGih31vcfFNElGnYR86bWHAdxoIuKc/edMBRN+
         G4qvUyG0PmNXYiw+b6m29FfmShaDflGTlovFS+i2njyHz9eA0EgrtM25pDFpcpgBPkJq
         /w74rpH2CC5X185AjxuZYXbo4eOBQAU+b6Deyq6EjkeEL2H5Xpxs2LG7hWtBHrhX1Kb7
         wLV8mmZvC2Yjb4jZpIkMaj1ysEUSLjj8JHIwy05N5jm3nqlWhZ6NLgjtMnB31tDjghkv
         5h4P5REgWG9oSGvfDCAyHpQKeo7AfhI+O17Hq5t070EvXaRL1LaYN+AoMCq3a/QiSOj2
         kLUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hUlbZThuj5etaf+babxSJzhQjwbLaOi/wOfX/kpZKzg=;
        b=eY4V09tolh/bV+yiF+AHi7noNUtiMLinBSG+6NcolgZj9inVKifVmctqKxOHuAG00+
         8yrhNF8nOxeMczdCP/lhdY/xwot55WyL9vyycD61AfoxGLTKmpGaedhg3Kbtzo5QjcI1
         kig5O+HxkireRvJabI414/aznmbWLy2uET9xMgeM/I+cMLYRf6LxyGggFpN0PB6jckl6
         jAMg5wQx/9d+XtjsRKLGMzkWbA5vetBfoG+q0ARSALQdJgBLBNX3gBM2yHG4UQVPlXp5
         K2baCxAFA0AFaa/HAqnBjxpKKCKAvZmgYouSaAMYVd/ZjDXcyuP0bI534N0LmY7rL0+A
         IfhA==
X-Gm-Message-State: AOAM530kTV3lvyI8KAy+cND3/7NdfuMmSULI1JvXPdG4XfVcNLzs2KuO
        bz8tKMZxW1GARRqaWpYcG+P/yyJuUdIOq0HaMax/rg==
X-Google-Smtp-Source: ABdhPJxeoE/ykmZFUu76mKlOd65+t4QOciHLyHJzkmJkm7368FuV9BpkIew0BG/3qFHFM3MoGoYz/Q==
X-Received: by 2002:adf:e289:: with SMTP id v9mr3786703wri.14.1600759844166;
        Tue, 22 Sep 2020 00:30:44 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s26sm3258287wmh.44.2020.09.22.00.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 00:30:43 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 01/16] net: bridge: mdb: use extack in br_mdb_parse()
Date:   Tue, 22 Sep 2020 10:30:12 +0300
Message-Id: <20200922073027.1196992-2-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200922073027.1196992-1-razor@blackwall.org>
References: <20200922073027.1196992-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We can drop the pr_info() calls and just use extack to return a
meaningful error to user-space when br_mdb_parse() fails.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_mdb.c | 60 +++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 00f1651a6aba..d4031f5554f7 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -629,33 +629,50 @@ void br_rtr_notify(struct net_device *dev, struct net_bridge_port *port,
 	rtnl_set_sk_err(net, RTNLGRP_MDB, err);
 }
 
-static bool is_valid_mdb_entry(struct br_mdb_entry *entry)
+static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
+			       struct netlink_ext_ack *extack)
 {
-	if (entry->ifindex == 0)
+	if (entry->ifindex == 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Zero entry ifindex is not allowed");
 		return false;
+	}
 
 	if (entry->addr.proto == htons(ETH_P_IP)) {
-		if (!ipv4_is_multicast(entry->addr.u.ip4))
+		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
+			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is not multicast");
 			return false;
-		if (ipv4_is_local_multicast(entry->addr.u.ip4))
+		}
+		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
+			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is local multicast");
 			return false;
+		}
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (entry->addr.proto == htons(ETH_P_IPV6)) {
-		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6))
+		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6)) {
+			NL_SET_ERR_MSG_MOD(extack, "IPv6 entry group address is link-local all nodes");
 			return false;
+		}
 #endif
-	} else
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown entry protocol");
 		return false;
-	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY)
+	}
+
+	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown entry state");
 		return false;
-	if (entry->vid >= VLAN_VID_MASK)
+	}
+	if (entry->vid >= VLAN_VID_MASK) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid entry VLAN id");
 		return false;
+	}
 
 	return true;
 }
 
 static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
-			struct net_device **pdev, struct br_mdb_entry **pentry)
+			struct net_device **pdev, struct br_mdb_entry **pentry,
+			struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct br_mdb_entry *entry;
@@ -671,36 +688,37 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	bpm = nlmsg_data(nlh);
 	if (bpm->ifindex == 0) {
-		pr_info("PF_BRIDGE: br_mdb_parse() with invalid ifindex\n");
+		NL_SET_ERR_MSG_MOD(extack, "Invalid bridge ifindex");
 		return -EINVAL;
 	}
 
 	dev = __dev_get_by_index(net, bpm->ifindex);
 	if (dev == NULL) {
-		pr_info("PF_BRIDGE: br_mdb_parse() with unknown ifindex\n");
+		NL_SET_ERR_MSG_MOD(extack, "Bridge device doesn't exist");
 		return -ENODEV;
 	}
 
 	if (!(dev->priv_flags & IFF_EBRIDGE)) {
-		pr_info("PF_BRIDGE: br_mdb_parse() with non-bridge\n");
+		NL_SET_ERR_MSG_MOD(extack, "Device is not a bridge");
 		return -EOPNOTSUPP;
 	}
 
 	*pdev = dev;
 
-	if (!tb[MDBA_SET_ENTRY] ||
-	    nla_len(tb[MDBA_SET_ENTRY]) != sizeof(struct br_mdb_entry)) {
-		pr_info("PF_BRIDGE: br_mdb_parse() with invalid attr\n");
+	if (!tb[MDBA_SET_ENTRY]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing MDBA_SET_ENTRY attribute");
 		return -EINVAL;
 	}
-
-	entry = nla_data(tb[MDBA_SET_ENTRY]);
-	if (!is_valid_mdb_entry(entry)) {
-		pr_info("PF_BRIDGE: br_mdb_parse() with invalid entry\n");
+	if (nla_len(tb[MDBA_SET_ENTRY]) != sizeof(struct br_mdb_entry)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
 		return -EINVAL;
 	}
 
+	entry = nla_data(tb[MDBA_SET_ENTRY]);
+	if (!is_valid_mdb_entry(entry, extack))
+		return -EINVAL;
 	*pentry = entry;
+
 	return 0;
 }
 
@@ -797,7 +815,7 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge *br;
 	int err;
 
-	err = br_mdb_parse(skb, nlh, &dev, &entry);
+	err = br_mdb_parse(skb, nlh, &dev, &entry, extack);
 	if (err < 0)
 		return err;
 
@@ -892,7 +910,7 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge *br;
 	int err;
 
-	err = br_mdb_parse(skb, nlh, &dev, &entry);
+	err = br_mdb_parse(skb, nlh, &dev, &entry, extack);
 	if (err < 0)
 		return err;
 
-- 
2.25.4

