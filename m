Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60D64FF53F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiDMKzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbiDMKyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:53 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0925A09C
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:32 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id p15so3094901ejc.7
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ilT4zUFtGaXgHtp2GJK2mepDZI/75DcJ6DrFnHIKpBs=;
        b=f5BuQoEEwTUVM51o3eEk6VO4Zk4tlK5Kw1wH/VgdHtzNTYnp1N/VYYymg6RiP+0A8N
         +QXGv0bnK7xKQH/A1+fSaIsgRA7bwwZQkbvRLsz4okmWcDyRAZxBTs2HjVN3Ok1Tmk53
         8gE4DClTL+FNydXdcqRuB4Qg1q8y4cAzDFbLIBJf034e25gI05SJ9AAeHQ9iQW2MFjTg
         A4aD48sU5ovlU1rX/Hc66q7JXx6wt9t1cqm5nO3wHTvbCnQ4zwoS1k+VLJ7BBfecegKR
         QRa5N522QTcNmjFn1TN80h1R3ztjigBIFLLpmOYDTZK0JDeKIEpCKcjnc5jN2oEpUE2T
         Fy7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ilT4zUFtGaXgHtp2GJK2mepDZI/75DcJ6DrFnHIKpBs=;
        b=1fRrcze/8xfCuU/8T73RkM6W+JlVJsatDKw82Zpuq+WkO5XPP9hH1imNvTOgfErzfS
         8UeT19tFdmPIdfbPA7FdsW5twl6t8VDrkYeCjoQZqniN+PaYdnlf/hqpfR8TrpEPNVbq
         Y1o/HNQERwLLRgIukzgLGEy/D+suGWOSMaKjHxw3Y4YKFNY/iwluv8+fBKHIsWwQut9o
         TXEsXuy7CJxW2LdOwbqRAe2TtddYjXGrb4mOH4VPvxjd38qGK/necyzeEw8UbYmo2SLG
         9J7as7qISmEoH58oqHmv8I6p0UQrVCu+aTUV9SYVb5AihhZyzCiQfXYfDKi2K/JbzSjh
         GhjQ==
X-Gm-Message-State: AOAM533HESPW0XszKWCEVrP0phx8VxTyNqb7QBzr+TfUlcaw11zCvVDp
        YFiNFMRvJRL7qixh9Ex2mVi2Sd/IxpZeDC2j
X-Google-Smtp-Source: ABdhPJyP2F83jM1zrMYoqF3DaIY2wkF0titK07wLfVauNRzddIimJlqQse8Y5TQwhx5t0iEgiGTi1g==
X-Received: by 2002:a17:907:728e:b0:6e8:9863:558a with SMTP id dt14-20020a170907728e00b006e89863558amr11127174ejc.205.1649847150571;
        Wed, 13 Apr 2022 03:52:30 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:30 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 09/12] net: bridge: fdb: add support for fine-grained flushing
Date:   Wed, 13 Apr 2022 13:51:59 +0300
Message-Id: <20220413105202.2616106-10-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
References: <20220413105202.2616106-1-razor@blackwall.org>
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

 net/bridge/br_fdb.c      | 41 ++++++++++++++++++++++++++++++++--------
 net/bridge/br_netlink.c  |  9 +++++++--
 net/bridge/br_private.h  | 10 +++++++++-
 net/bridge/br_sysfs_br.c |  6 +++++-
 4 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 363985f1a540..45d02f2264db 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -558,24 +558,49 @@ void br_fdb_cleanup(struct work_struct *work)
 	mod_delayed_work(system_long_wq, &br->gc_work, work_delay);
 }
 
-/* Completely flush all dynamic entries in forwarding database.*/
-void br_fdb_flush(struct net_bridge *br)
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
 
 int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 		       struct net_device *dev, u16 vid,
 		       struct netlink_ext_ack *extack)
 {
+	struct net_bridge_fdb_flush_desc desc = {
+		.flags_mask = BR_FDB_STATIC
+	};
 	struct net_bridge_port *p = NULL;
 	struct net_bridge *br;
 
@@ -590,7 +615,7 @@ int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 		br = p->br;
 	}
 
-	br_fdb_flush(br);
+	br_fdb_flush(br, &desc);
 
 	return 0;
 }
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 200ad05b296f..bb01776d2d88 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1326,8 +1326,13 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
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
index f37d49bf5637..4d2a809546fb 100644
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

