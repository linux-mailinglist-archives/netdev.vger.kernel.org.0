Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3722C4FE277
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351207AbiDLN30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356746AbiDLN2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:28:08 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F9E2DD46
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:15 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id k23so37294482ejd.3
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lZcp4/d3284rwKpd9JqIxtdzLugh7b7HIXdHYmU+Bvs=;
        b=CQYgqrzX8eiCJluaqwbmSgQty7HrA0RwPRVhfaLesiSx6AvxzE6eK+8E38Nv4FKy+c
         2d2DH9/pCwaGVPzBxUOipagka130UhY0dtSJ7yGAVrgBOkckwh7sPu4/DZT7oq0Hzzlj
         vrR641bggBr2Q820+2W6vPyEYH/x1WDcE2RD/c/2Ci2FbBQobkcnSpFYdCOJTBu4Bvca
         h5Caygw/0oDZsvzZG/NgR/DyVUgBQ1Jx00vN1vEqjxGNt52sQ17m/fjgXa36ftrDFRsq
         ycjeq25nD18NRyKDmTFPy86o4w2+Q5BzfdP9INJEWYMGgdk6Cv8Y+pTF9q6cGvuqCYOU
         ZXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lZcp4/d3284rwKpd9JqIxtdzLugh7b7HIXdHYmU+Bvs=;
        b=AMYOTeKGm8UrAIrE8J8Go1CnUVZTnC/c3GWje825AsxjmkzQWjPwo1fNEPbcH8fohv
         0c7qsjZKO6zviKjnw1CGDcLPmPYthPsqZDjfb6TNPNverzcmfgCQJn508ZJCFHp9czNS
         qbxgz8oqKpcuk7Emkbf8GuWFxO0zUATXUw/mUnoZCt1nC3DXxQdp+SzliUmJ/yqMGTuU
         v47jM5MD1h/P7o/3cg/DBTmaerBlna7QxmrJTKJ52ZDlz/xRgg5JLz+ctesoiIITify3
         KK8dp5DOHAR/LQkfAh00mYn/OFNipcYgithf8ztMOy7Q2ZjlcVOihisZ1JJDPpk7fBNW
         OIMQ==
X-Gm-Message-State: AOAM533EWUuwNN4qH/aPURPhSznUGRjyhlUiJCPnIMcRuUsiE7+Eu18J
        9YfyhA9wkfZ9/4X5DX7hzuxdSA9W0BmpY6RN
X-Google-Smtp-Source: ABdhPJzet/sB6/udstJi5dtbeD7jfKE0Fyo8+JVOtz4Zj0/Skne8JnQSwBWii9ordkW/EAvZRrWkfw==
X-Received: by 2002:a17:907:980d:b0:6d6:f910:513a with SMTP id ji13-20020a170907980d00b006d6f910513amr32953311ejc.643.1649769793897;
        Tue, 12 Apr 2022 06:23:13 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3771301ejn.204.2022.04.12.06.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:23:13 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v3 5/8] net: bridge: fdb: add support for fine-grained flushing
Date:   Tue, 12 Apr 2022 16:22:42 +0300
Message-Id: <20220412132245.2148794-6-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412132245.2148794-1-razor@blackwall.org>
References: <20220412132245.2148794-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to specify exactly which fdbs to be flushed. They are
described by a new structure - net_bridge_fdb_flush_desc. Currently it
can match on port/bridge ifindex, vlan id and fdb flags. It is used to
describe the existing dynamic fdb flush operation. Note that this flush
operation doesn't treat permanent entries in a special way (fdb_delete vs
fdb_delete_local), it will delete them regardless if any port is using
them, so currently it can't directly replace deletes which need to handle
that case, although we can extend it later for that too.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v2: changed the flush matches func for better readability (Ido)
v3: no change

 net/bridge/br_fdb.c      | 41 ++++++++++++++++++++++++++++++++--------
 net/bridge/br_netlink.c  |  9 +++++++--
 net/bridge/br_private.h  | 10 +++++++++-
 net/bridge/br_sysfs_br.c |  6 +++++-
 4 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index fd7012c32cd5..f1deac42bc0d 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -558,24 +558,49 @@ void br_fdb_cleanup(struct work_struct *work)
 	mod_delayed_work(system_long_wq, &br->gc_work, work_delay);
 }
 
-/* Completely flush all dynamic entries in forwarding database.*/
-void __br_fdb_flush(struct net_bridge *br)
+static bool __fdb_flush_matches(const struct net_bridge *br,
+				const struct net_bridge_fdb_entry *f,
+				const struct net_bridge_fdb_flush_desc *desc)
+{
+	const struct net_bridge_port *dst = READ_ONCE(f->dst);
+	int port_ifidx = dst ? dst->dev->ifindex : br->dev->ifindex;
+
+	if (desc->vlan_id && desc->vlan_id != f->key.vlan_id)
+		return false;
+	if (desc->port_ifindex && desc->port_ifindex != port_ifidx)
+		return false;
+	if (desc->flags_mask && (f->flags & desc->flags_mask) != desc->flags)
+		return false;
+
+	return true;
+}
+
+/* Flush forwarding database entries matching the description */
+void __br_fdb_flush(struct net_bridge *br,
+		    const struct net_bridge_fdb_flush_desc *desc)
 {
 	struct net_bridge_fdb_entry *f;
-	struct hlist_node *tmp;
 
-	spin_lock_bh(&br->hash_lock);
-	hlist_for_each_entry_safe(f, tmp, &br->fdb_list, fdb_node) {
-		if (!test_bit(BR_FDB_STATIC, &f->flags))
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
+		if (!__fdb_flush_matches(br, f, desc))
+			continue;
+
+		spin_lock_bh(&br->hash_lock);
+		if (!hlist_unhashed(&f->fdb_node))
 			fdb_delete(br, f, true);
+		spin_unlock_bh(&br->hash_lock);
 	}
-	spin_unlock_bh(&br->hash_lock);
+	rcu_read_unlock();
 }
 
 int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 		       struct net_device *dev, u16 vid,
 		       struct netlink_ext_ack *extack)
 {
+	struct net_bridge_fdb_flush_desc desc = {
+		.flags_mask = BR_FDB_STATIC
+	};
 	struct net_bridge *br;
 
 	if (netif_is_bridge_master(dev)) {
@@ -590,7 +615,7 @@ int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 		br = p->br;
 	}
 
-	__br_fdb_flush(br);
+	__br_fdb_flush(br, &desc);
 
 	return 0;
 }
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index c59c775730bb..accab38b0b6a 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1326,8 +1326,13 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 		br_recalculate_fwd_mask(br);
 	}
 
-	if (data[IFLA_BR_FDB_FLUSH])
-		__br_fdb_flush(br);
+	if (data[IFLA_BR_FDB_FLUSH]) {
+		struct net_bridge_fdb_flush_desc desc = {
+			.flags_mask = BR_FDB_STATIC
+		};
+
+		__br_fdb_flush(br, &desc);
+	}
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	if (data[IFLA_BR_MCAST_ROUTER]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 3ba50e41aa4f..dd186ac29737 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -274,6 +274,13 @@ struct net_bridge_fdb_entry {
 	struct rcu_head			rcu;
 };
 
+struct net_bridge_fdb_flush_desc {
+	unsigned long			flags;
+	unsigned long			flags_mask;
+	int				port_ifindex;
+	u16				vlan_id;
+};
+
 #define MDB_PG_FLAGS_PERMANENT	BIT(0)
 #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
 #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
@@ -759,7 +766,8 @@ int br_fdb_init(void);
 void br_fdb_fini(void);
 int br_fdb_hash_init(struct net_bridge *br);
 void br_fdb_hash_fini(struct net_bridge *br);
-void __br_fdb_flush(struct net_bridge *br);
+void __br_fdb_flush(struct net_bridge *br,
+		    const struct net_bridge_fdb_flush_desc *desc);
 
 void br_fdb_find_delete_local(struct net_bridge *br,
 			      const struct net_bridge_port *p,
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 7a2cf3aebc84..c863151f1cde 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -344,7 +344,11 @@ static DEVICE_ATTR_RW(group_addr);
 static int set_flush(struct net_bridge *br, unsigned long val,
 		     struct netlink_ext_ack *extack)
 {
-	__br_fdb_flush(br);
+	struct net_bridge_fdb_flush_desc desc = {
+		.flags_mask = BR_FDB_STATIC
+	};
+
+	__br_fdb_flush(br, &desc);
 	return 0;
 }
 
-- 
2.35.1

