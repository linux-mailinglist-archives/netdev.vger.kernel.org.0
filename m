Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D464FA6F9
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241502AbiDILHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241316AbiDILHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:07:01 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EC823F3AC
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:04:53 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t25so23177edt.9
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 04:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fbnlf8kTog0ziFAwrjyK4x7U8wwDsSsFVdwcSgNLjgs=;
        b=AfKOr2kRuukfU0wH1SNJb1vCUdfKMEfMlLVYZ4RpMMTaZvfg1fcnr5POTI06kAX56X
         EDVKZfXiA9nSiuda7IvHYk3ETzZI718onZohFDGcImrrYLAsW42V/QcMeprq8MfCc5el
         eU+QrkJOthZINMcjUc1PPwugEQ0+vCUdBrs5XZRxhNQW7YKCulRfJ/D0mF0Pz7lVDpYS
         UWc4jpBTaPFSM4HO4A++p5x1Z1Cwt9yL/Q1gFJ5OGGvwWe42ZEkzDvZLv1lzyWpf58Hg
         5L0MplmZ75bJzL5OxHaOUdIt+UCiZMJegFUwJsSvG3VvChKSuffgG6p5e75eA4XPT8ys
         VDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fbnlf8kTog0ziFAwrjyK4x7U8wwDsSsFVdwcSgNLjgs=;
        b=u+us0UP0JJoDr0BtfqG/TFr4Gypcd2fpIDuTmwLc+VBxaL/p2zawYDTOv0H9QiyI/7
         P2W5R2h2ERC9gmLZd0GmGBHwT4XfJqGvYsQrwaHyQybvtmizkuMlbKdv9bvHSIEVvHdO
         Mngr556IO61C/Y00b5Pe3x+QJqnZFxjf9KBUgO+1RwHLnEeUgmJ/JHGJ5tOMTHlO21Am
         sw1nfLIPFPNJSycut/wS03WJALGGwKybVn/VON6ThHU3MDYMhNsEU8tWW68xSf6HMk/s
         sOG/zXuXYfCTwb0jwltnqCipayX9T8zvKWjGPCkYQCR5NJITnEQM5cQZH7b7LGZhG0Vw
         8ufQ==
X-Gm-Message-State: AOAM5323l89wYQDDk/zVTEub8+Z6YRPXJ1I8rnJfxZH8HNIPbseZh0ey
        CIpqkmbJQG68c4pU52gbU12FzX+5NlViVYlZDsM=
X-Google-Smtp-Source: ABdhPJxO6m0ucbuZJevVTCM5WUCN24OtKQMo/EiL3Yxax5yCp/D6tdsYWHiwxzAthVaqE1vt+ZfDxQ==
X-Received: by 2002:a05:6402:449:b0:41c:9096:44f7 with SMTP id p9-20020a056402044900b0041c909644f7mr23739906edw.43.1649502291288;
        Sat, 09 Apr 2022 04:04:51 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r11-20020a1709064d0b00b006e87938318dsm179574eju.39.2022.04.09.04.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 04:04:50 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next 2/6] net: bridge: fdb: add support for fine-grained flushing
Date:   Sat,  9 Apr 2022 13:58:53 +0300
Message-Id: <20220409105857.803667-3-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409105857.803667-1-razor@blackwall.org>
References: <20220409105857.803667-1-razor@blackwall.org>
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
describe the existing dynamic fdb flush operation.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_fdb.c      | 36 +++++++++++++++++++++++++++++-------
 net/bridge/br_netlink.c  |  9 +++++++--
 net/bridge/br_private.h  | 10 +++++++++-
 net/bridge/br_sysfs_br.c |  6 +++++-
 4 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..4b0bf88c4121 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -558,18 +558,40 @@ void br_fdb_cleanup(struct work_struct *work)
 	mod_delayed_work(system_long_wq, &br->gc_work, work_delay);
 }
 
-/* Completely flush all dynamic entries in forwarding database.*/
-void br_fdb_flush(struct net_bridge *br)
+static bool __fdb_flush_matches(const struct net_bridge *br,
+				const struct net_bridge_fdb_entry *f,
+				const struct net_bridge_fdb_flush_desc *desc)
+{
+	const struct net_bridge_port *dst = READ_ONCE(f->dst);
+	int port_ifidx, br_ifidx = br->dev->ifindex;
+
+	port_ifidx = dst ? dst->dev->ifindex : 0;
+
+	return (!desc->vlan_id || desc->vlan_id == f->key.vlan_id) &&
+	       (!desc->port_ifindex ||
+		(desc->port_ifindex == port_ifidx ||
+		 (!dst && desc->port_ifindex == br_ifidx))) &&
+	       (!desc->flags_mask ||
+		((f->flags & desc->flags_mask) == desc->flags));
+}
+
+/* Flush forwarding database entries matching the description */
+void br_fdb_flush(struct net_bridge *br,
+		  const struct net_bridge_fdb_flush_desc *desc)
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
 
 /* Flush all entries referring to a specific port.
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index fe2211d4c0c7..6e6dce6880c9 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1366,8 +1366,13 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 		br_recalculate_fwd_mask(br);
 	}
 
-	if (data[IFLA_BR_FDB_FLUSH])
-		br_fdb_flush(br);
+	if (data[IFLA_BR_FDB_FLUSH]) {
+		struct net_bridge_fdb_flush_desc desc = {
+			.flags_mask = BR_FDB_STATIC
+		};
+
+		br_fdb_flush(br, &desc);
+	}
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	if (data[IFLA_BR_MCAST_ROUTER]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 6e62af2e07e9..e6930e9ee69d 100644
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
-void br_fdb_flush(struct net_bridge *br);
+void br_fdb_flush(struct net_bridge *br,
+		  const struct net_bridge_fdb_flush_desc *desc);
 void br_fdb_find_delete_local(struct net_bridge *br,
 			      const struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid);
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 3f7ca88c2aa3..612e367fff20 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -344,7 +344,11 @@ static DEVICE_ATTR_RW(group_addr);
 static int set_flush(struct net_bridge *br, unsigned long val,
 		     struct netlink_ext_ack *extack)
 {
-	br_fdb_flush(br);
+	struct net_bridge_fdb_flush_desc desc = {
+		.flags_mask = BR_FDB_STATIC
+	};
+
+	br_fdb_flush(br, &desc);
 	return 0;
 }
 
-- 
2.35.1

