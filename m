Return-Path: <netdev+bounces-11839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6EB1734C33
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D5ED280A09
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981DB63DA;
	Mon, 19 Jun 2023 07:15:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870B079C6
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:15:28 +0000 (UTC)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE0F1AA
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 00:15:25 -0700 (PDT)
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Mon, 19 Jun 2023 09:15:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1687158917; bh=dThE2OIuloEGIgsJQedxGb7lyFjkM1k5iDc5bftTHj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otWmqdiHfhy/2sr/7ZQ25VhXH6B46lFsf6IXGp4pjHdGNC2XEpAD5A2dcHrWwIeu5
	 uGGXruqUNwUloOnjAUgHkroWTAV4etxk6xa70oNfTcY9NmWmqjK/QxcTxVsx20rdUK
	 ufuaQQgD5P+X0k97Sb4IQbksuwiMOQ779GtyW/2w=
Received: from u-jnixdorf.avm.de (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPA id 2627681ED5;
	Mon, 19 Jun 2023 09:15:16 +0200 (CEST)
From: Johannes Nixdorf <jnixdorf-oss@avm.de>
To: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org,
	David Ahern <dsahern@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Johannes Nixdorf <jnixdorf-oss@avm.de>
Subject: [PATCH net-next v2 2/3] bridge: Add a limit on learned FDB entries
Date: Mon, 19 Jun 2023 09:14:42 +0200
Message-Id: <20230619071444.14625-3-jnixdorf-oss@avm.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230619071444.14625-1-jnixdorf-oss@avm.de>
References: <20230619071444.14625-1-jnixdorf-oss@avm.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-purgate-ID: 149429::1687158916-23DE7029-73808C55/0/0
X-purgate-type: clean
X-purgate-size: 11955
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A malicious actor behind one bridge port may spam the kernel with packets
with a random source MAC address, each of which will create an FDB entry,
each of which is a dynamic allocation in the kernel.

There are roughly 2^48 different MAC addresses, further limited by the
rhashtable they are stored in to 2^31. Each entry is of the type struct
net_bridge_fdb_entry, which is currently 128 bytes big. This means the
maximum amount of memory allocated for FDB entries is 2^31 * 128B =
256GiB, which is too much for most computers.

Mitigate this by adding a bridge netlink setting
IFLA_BR_FDB_MAX_LEARNED_ENTRIES, which, if nonzero, limits the amount
of learned entries to a user specified maximum.

For backwards compatibility the default setting of 0 disables the limit.

User-added entries by netlink or from bridge or bridge port addresses
are never blocked and do not count towards that limit.

All changes to fdb_n_entries are under br->hash_lock, which means we do
not need additional locking. The call paths are (✓ denotes that
br->hash_lock is taken around the next call):

 - fdb_delete <-+- fdb_delete_local <-+- br_fdb_changeaddr ✓
                |                     +- br_fdb_change_mac_address ✓
                |                     +- br_fdb_delete_by_port ✓
                +- br_fdb_find_delete_local ✓
                +- fdb_add_local <-+- br_fdb_changeaddr ✓
                |                  +- br_fdb_change_mac_address ✓
                |                  +- br_fdb_add_local ✓
                +- br_fdb_cleanup ✓
                +- br_fdb_flush ✓
                +- br_fdb_delete_by_port ✓
                +- fdb_delete_by_addr_and_port <--- __br_fdb_delete ✓
                +- br_fdb_external_learn_del ✓
 - fdb_create <-+- fdb_add_local <-+- br_fdb_changeaddr ✓
                |                  +- br_fdb_change_mac_address ✓
                |                  +- br_fdb_add_local ✓
                +- br_fdb_update ✓
                +- fdb_add_entry <--- __br_fdb_add ✓
                +- br_fdb_external_learn_add ✓

The flags that imply an entry does not come from learning
(BR_FDB_NOT_LEARNED_MASK) are now only set or cleared under br->hash_lock
as well, and when the boolean value of (fdb->flags &
BR_FDB_NOT_LEARNED_MASK) changes the accounting is updated.

This introduces one additional locked update in br_fdb_update if
BR_FDB_ADDED_BY_USER was set. This is only the case when creating a new
entry via netlink, and never in the packet handling fast path.

Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>

---

Changes since v1:
 - Do not initialize fdb_*_entries to 0. (from review)
 - Do not skip decrementing on 0. (from review)
 - Moved the counters to a conditional hole in struct net_bridge to
   avoid growing the struct. (from review, it still grows the struct as
   there are 2 32-bit values)
 - Add IFLA_BR_FDB_CUR_LEARNED_ENTRIES (from review)
 - Fix br_get_size()
 - Only limit learned entries, rename to
   *_(CUR|MAX)_LEARNED_ENTRIES. (from review)

Obsolete v1 review comments:
 - Return better errors to users: Due to limiting the limit to
   automatically created entries, netlink fdb add requests and changing
   bridge ports are never rejected, so they do not yet need a more
   friendly error returned.

 include/uapi/linux/if_link.h |  2 ++
 net/bridge/br_fdb.c          | 67 +++++++++++++++++++++++++++++++++---
 net/bridge/br_netlink.c      | 13 ++++++-
 net/bridge/br_private.h      |  6 ++++
 4 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4ac1000b0ef2..165b9014379b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -510,6 +510,8 @@ enum {
 	IFLA_BR_VLAN_STATS_PER_PORT,
 	IFLA_BR_MULTI_BOOLOPT,
 	IFLA_BR_MCAST_QUERIER_STATE,
+	IFLA_BR_FDB_CUR_LEARNED_ENTRIES,
+	IFLA_BR_FDB_MAX_LEARNED_ENTRIES,
 	__IFLA_BR_MAX,
 };
 
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index ac1dc8723b9c..bc61d1fd5fcf 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -301,6 +301,38 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
 	}
 }
 
+/* Set a FDB flag that implies the entry was not learned, and account
+ * for changes in the learned status.
+ */
+static void __fdb_set_flag_not_learned(struct net_bridge *br,
+				       struct net_bridge_fdb_entry *fdb,
+				       long nr)
+{
+	WARN_ON_ONCE(!(BIT(nr) & BR_FDB_NOT_LEARNED_MASK));
+
+	/* learned before, but we set a flag that implies it's manually added */
+	if (!(fdb->flags & BR_FDB_NOT_LEARNED_MASK))
+		br->fdb_cur_learned_entries--;
+	set_bit(nr, &fdb->flags);
+}
+
+/* Set a FDB flag that implies the entry was not learned, and account
+ * for changes in the learned status.
+ *
+ * This function takes a lock, so ensure it is not called in the fast
+ * path.
+ */
+static void fdb_set_flag_not_learned(struct net_bridge *br,
+				     struct net_bridge_fdb_entry *fdb,
+				     long nr)
+{
+	spin_lock_bh(&br->hash_lock);
+
+	__fdb_set_flag_not_learned(br, fdb, nr);
+
+	spin_unlock_bh(&br->hash_lock);
+}
+
 /* When a static FDB entry is deleted, the HW address from that entry is
  * also removed from the bridge private HW address list and updates all
  * the ports with needed information.
@@ -321,6 +353,8 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
 static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
 		       bool swdev_notify)
 {
+	bool learned = !(f->flags & BR_FDB_NOT_LEARNED_MASK);
+
 	trace_fdb_delete(br, f);
 
 	if (test_bit(BR_FDB_STATIC, &f->flags))
@@ -329,11 +363,16 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
 	hlist_del_init_rcu(&f->fdb_node);
 	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
 			       br_fdb_rht_params);
+	br->fdb_cur_learned_entries -= learned;
 	fdb_notify(br, f, RTM_DELNEIGH, swdev_notify);
 	call_rcu(&f->rcu, fdb_rcu_free);
 }
 
-/* Delete a local entry if no other port had the same address. */
+/* Delete a local entry if no other port had the same address.
+ *
+ * This function should only be called on entries with BR_FDB_LOCAL set,
+ * so clear_bit never removes the last bit in BR_FDB_NOT_LEARNED_MASK.
+ */
 static void fdb_delete_local(struct net_bridge *br,
 			     const struct net_bridge_port *p,
 			     struct net_bridge_fdb_entry *f)
@@ -390,6 +429,11 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 {
 	struct net_bridge_fdb_entry *fdb;
 	int err;
+	bool learned = !(flags & BR_FDB_NOT_LEARNED_MASK);
+
+	if (unlikely(learned && br->fdb_max_learned_entries &&
+		     br->fdb_cur_learned_entries >= br->fdb_max_learned_entries))
+		return NULL;
 
 	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
 	if (!fdb)
@@ -409,6 +453,8 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 
 	hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
 
+	br->fdb_cur_learned_entries += learned;
+
 	return fdb;
 }
 
@@ -894,7 +940,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			}
 
 			if (unlikely(test_bit(BR_FDB_ADDED_BY_USER, &flags)))
-				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+				fdb_set_flag_not_learned(br, fdb, BR_FDB_ADDED_BY_USER);
 			if (unlikely(fdb_modified)) {
 				trace_br_fdb_update(br, source, addr, vid, flags);
 				fdb_notify(br, fdb, RTM_NEWNEIGH, true);
@@ -1070,6 +1116,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			modified = true;
 		}
 
+		if (!(fdb->flags & BR_FDB_NOT_LEARNED_MASK))
+			br->fdb_cur_learned_entries--;
 		set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	}
 
@@ -1440,10 +1488,10 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		}
 
 		if (swdev_notify)
-			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+			__fdb_set_flag_not_learned(br, fdb, BR_FDB_ADDED_BY_USER);
 
 		if (!p)
-			set_bit(BR_FDB_LOCAL, &fdb->flags);
+			__fdb_set_flag_not_learned(br, fdb, BR_FDB_LOCAL);
 
 		if (modified)
 			fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
@@ -1508,3 +1556,14 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
 	spin_unlock_bh(&p->br->hash_lock);
 }
 EXPORT_SYMBOL_GPL(br_fdb_clear_offload);
+
+u32 br_fdb_get_cur_learned_entries(struct net_bridge *br)
+{
+	u32 ret;
+
+	spin_lock_bh(&br->hash_lock);
+	ret = br->fdb_cur_learned_entries;
+	spin_unlock_bh(&br->hash_lock);
+
+	return ret;
+}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 05c5863d2e20..954c468d52ec 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1527,6 +1527,12 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 			return err;
 	}
 
+	if (data[IFLA_BR_FDB_MAX_LEARNED_ENTRIES]) {
+		u32 val = nla_get_u32(data[IFLA_BR_FDB_MAX_LEARNED_ENTRIES]);
+
+		br->fdb_max_learned_entries = val;
+	}
+
 	return 0;
 }
 
@@ -1581,6 +1587,8 @@ static size_t br_get_size(const struct net_device *brdev)
 	       nla_total_size_64bit(sizeof(u64)) + /* IFLA_BR_TOPOLOGY_CHANGE_TIMER */
 	       nla_total_size_64bit(sizeof(u64)) + /* IFLA_BR_GC_TIMER */
 	       nla_total_size(ETH_ALEN) +       /* IFLA_BR_GROUP_ADDR */
+	       nla_total_size(sizeof(u32)) +    /* IFLA_BR_FDB_CUR_LEARNED_ENTRIES */
+	       nla_total_size(sizeof(u32)) +    /* IFLA_BR_FDB_MAX_LEARNED_ENTRIES */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_MCAST_ROUTER */
 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_MCAST_SNOOPING */
@@ -1620,6 +1628,7 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 	u32 stp_enabled = br->stp_enabled;
 	u16 priority = (br->bridge_id.prio[0] << 8) | br->bridge_id.prio[1];
 	u8 vlan_enabled = br_vlan_enabled(br->dev);
+	u32 fdb_cur_learned_entries = br_fdb_get_cur_learned_entries(br);
 	struct br_boolopt_multi bm;
 	u64 clockval;
 
@@ -1656,7 +1665,9 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 	    nla_put_u8(skb, IFLA_BR_TOPOLOGY_CHANGE_DETECTED,
 		       br->topology_change_detected) ||
 	    nla_put(skb, IFLA_BR_GROUP_ADDR, ETH_ALEN, br->group_addr) ||
-	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm))
+	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm) ||
+	    nla_put_u32(skb, IFLA_BR_FDB_CUR_LEARNED_ENTRIES, fdb_cur_learned_entries) ||
+	    nla_put_u32(skb, IFLA_BR_FDB_MAX_LEARNED_ENTRIES, br->fdb_max_learned_entries))
 		return -EMSGSIZE;
 
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2119729ded2b..df079191479e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -275,6 +275,8 @@ enum {
 	BR_FDB_LOCKED,
 };
 
+#define BR_FDB_NOT_LEARNED_MASK (BIT(BR_FDB_LOCAL) | BIT(BR_FDB_ADDED_BY_USER))
+
 struct net_bridge_fdb_key {
 	mac_addr addr;
 	u16 vlan_id;
@@ -553,6 +555,9 @@ struct net_bridge {
 	struct kobject			*ifobj;
 	u32				auto_cnt;
 
+	u32				fdb_max_learned_entries;
+	u32				fdb_cur_learned_entries;
+
 #ifdef CONFIG_NET_SWITCHDEV
 	/* Counter used to make sure that hardware domains get unique
 	 * identifiers in case a bridge spans multiple switchdev instances.
@@ -838,6 +843,7 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      bool swdev_notify);
 void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 			  const unsigned char *addr, u16 vid, bool offloaded);
+u32 br_fdb_get_cur_learned_entries(struct net_bridge *br);
 
 /* br_forward.c */
 enum br_pkt_type {
-- 
2.40.1


