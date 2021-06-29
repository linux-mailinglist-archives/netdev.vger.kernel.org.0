Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE263B73CF
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhF2OJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbhF2OJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:09:46 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE33DC061766
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:18 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id s15so31409082edt.13
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NY7qzr4+ODdZwNJ0icARG2dgnvlvsTsSa6d2ppNaLUc=;
        b=HiJmQn14jzS8KrvgMv6YCxwLsV5FXpfTPTsvlMiRL31GbrxGYmkX36At/+M0eYgjpX
         dDo8aos/U1NWdhbe4nJ6vp/8FunZP/OoQ55ewj68LpnvWOUsxiIwNmw3YcANBRm9SUln
         GTmQFN+GqcOqiIU9rsePrBTnV/EenxRI3G/fhMzEZnyO3k8+a5zvRTsZFR5WEQHjDpfy
         9CX+jJAoZbjTzTSGKLXPoy9UzUdfQEPgWhHXxdb93ZGnIzrF9SSwKEq1yBakK2gowDUS
         T2NRRMT8bmi7uf2XOfe2dIOopRdjuJaiQaWWhnKtGdr1becOxoe/nIFklgPCW+leSHJK
         4bwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NY7qzr4+ODdZwNJ0icARG2dgnvlvsTsSa6d2ppNaLUc=;
        b=sZHiMsCM/c1ca+QuTgdXQgAQg42k2HXLjQ9kQBXTWl+4sE7sMWFRJGep8u+Zzoq8B/
         9LUB6z61eoVzwBbMBgM+cwNpoWwcCQz9IS24jWGoDwjkJ+3RwAW1rWLRGdhifxk9wZZS
         W7tnJYMeA2k1VgKnwm8HzrEwZda3MJEji9f7dOvJLLLDmPSY8hGY/GXhNkQeb7X2eMza
         lpxi8gWIKYyVqLL7VWypB1OHJCbJqciH8pbZex35rOSDkWOVIwdIQ4ApiDwfkDTjmit0
         G5ewpF/nB2nQkCSjD/vZHrleBnyNZ3JiRmlPGWn8repVutqMyE5TJ2YpocBqHatP6sYe
         R5Wg==
X-Gm-Message-State: AOAM532wsYp3LhwcFitQqfWUXsmHILrOWnZhr1v6oZNjHoK3igKYvlKg
        GAT6Bqw7wLg9kM2ti6qS1jHd4DFpz2I=
X-Google-Smtp-Source: ABdhPJzgPwoA2ETtWf4BhPtSac0El3QgFZheRtpJ6HIV6mnvN50Lt1j3VWCLDbsGr8BHpeuSomLmnw==
X-Received: by 2002:a05:6402:848:: with SMTP id b8mr40269455edz.44.1624975637141;
        Tue, 29 Jun 2021 07:07:17 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 01/15] net: bridge: use READ_ONCE() and WRITE_ONCE() compiler barriers for fdb->dst
Date:   Tue, 29 Jun 2021 17:06:44 +0300
Message-Id: <20210629140658.2510288-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Annotate the writer side of fdb->dst:

- fdb_create()
- br_fdb_update()
- fdb_add_entry()
- br_fdb_external_learn_add()

with WRITE_ONCE() and the reader side:

- br_fdb_test_addr()
- br_fdb_update()
- fdb_fill_info()
- fdb_add_entry()
- fdb_delete_by_addr_and_port()
- br_fdb_external_learn_add()
- br_switchdev_fdb_notify()

with compiler barriers such that the readers do not attempt to reload
fdb->dst multiple times, leading to potentially different destination
ports when the fdb entry is updated concurrently.

This is especially important in read-side sections where fdb->dst is
used more than once, but let's convert all accesses for the sake of
uniformity.

Suggested-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: patch is new

 net/bridge/br_fdb.c       | 28 +++++++++++++++++-----------
 net/bridge/br_switchdev.c |  7 ++++---
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 16f9434fdb5d..dc3ecf2d5637 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -440,9 +440,14 @@ int br_fdb_test_addr(struct net_device *dev, unsigned char *addr)
 	if (!port)
 		ret = 0;
 	else {
+		const struct net_bridge_port *dst = NULL;
+
 		fdb = br_fdb_find_rcu(port->br, addr, 0);
-		ret = fdb && fdb->dst && fdb->dst->dev != dev &&
-			fdb->dst->state == BR_STATE_FORWARDING;
+		if (fdb)
+			dst = READ_ONCE(fdb->dst);
+
+		ret = dst && dst->dev != dev &&
+		      dst->state == BR_STATE_FORWARDING;
 	}
 	rcu_read_unlock();
 
@@ -509,7 +514,7 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
 	if (fdb) {
 		memcpy(fdb->key.addr.addr, addr, ETH_ALEN);
-		fdb->dst = source;
+		WRITE_ONCE(fdb->dst, source);
 		fdb->key.vlan_id = vid;
 		fdb->flags = flags;
 		fdb->updated = fdb->used = jiffies;
@@ -600,10 +605,10 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			}
 
 			/* fastpath: update of existing entry */
-			if (unlikely(source != fdb->dst &&
+			if (unlikely(source != READ_ONCE(fdb->dst) &&
 				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
 				br_switchdev_fdb_notify(fdb, RTM_DELNEIGH);
-				fdb->dst = source;
+				WRITE_ONCE(fdb->dst, source);
 				fdb_modified = true;
 				/* Take over HW learned entry */
 				if (unlikely(test_bit(BR_FDB_ADDED_BY_EXT_LEARN,
@@ -650,6 +655,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 			 const struct net_bridge_fdb_entry *fdb,
 			 u32 portid, u32 seq, int type, unsigned int flags)
 {
+	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
 	unsigned long now = jiffies;
 	struct nda_cacheinfo ci;
 	struct nlmsghdr *nlh;
@@ -665,7 +671,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 	ndm->ndm_pad2    = 0;
 	ndm->ndm_flags	 = 0;
 	ndm->ndm_type	 = 0;
-	ndm->ndm_ifindex = fdb->dst ? fdb->dst->dev->ifindex : br->dev->ifindex;
+	ndm->ndm_ifindex = dst ? dst->dev->ifindex : br->dev->ifindex;
 	ndm->ndm_state   = fdb_to_nud(br, fdb);
 
 	if (test_bit(BR_FDB_OFFLOADED, &fdb->flags))
@@ -964,8 +970,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		if (flags & NLM_F_EXCL)
 			return -EEXIST;
 
-		if (fdb->dst != source) {
-			fdb->dst = source;
+		if (READ_ONCE(fdb->dst) != source) {
+			WRITE_ONCE(fdb->dst, source);
 			modified = true;
 		}
 	}
@@ -1132,7 +1138,7 @@ static int fdb_delete_by_addr_and_port(struct net_bridge *br,
 	struct net_bridge_fdb_entry *fdb;
 
 	fdb = br_fdb_find(br, addr, vlan);
-	if (!fdb || fdb->dst != p)
+	if (!fdb || READ_ONCE(fdb->dst) != p)
 		return -ENOENT;
 
 	fdb_delete(br, fdb, true);
@@ -1281,8 +1287,8 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 	} else {
 		fdb->updated = jiffies;
 
-		if (fdb->dst != p) {
-			fdb->dst = p;
+		if (READ_ONCE(fdb->dst) != p) {
+			WRITE_ONCE(fdb->dst, p);
 			modified = true;
 		}
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a5e601e41cb9..192293fe37fd 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -110,6 +110,7 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 void
 br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 {
+	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
 	struct switchdev_notifier_fdb_info info = {
 		.addr = fdb->key.addr.addr,
 		.vid = fdb->key.vlan_id,
@@ -118,17 +119,17 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
 	};
 
-	if (!fdb->dst)
+	if (!dst)
 		return;
 
 	switch (type) {
 	case RTM_DELNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
-					 fdb->dst->dev, &info.info, NULL);
+					 dst->dev, &info.info, NULL);
 		break;
 	case RTM_NEWNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
-					 fdb->dst->dev, &info.info, NULL);
+					 dst->dev, &info.info, NULL);
 		break;
 	}
 }
-- 
2.25.1

