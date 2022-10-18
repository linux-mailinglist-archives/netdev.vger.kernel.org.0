Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3458603121
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 18:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiJRQ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 12:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiJRQ5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 12:57:00 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C054EA374;
        Tue, 18 Oct 2022 09:56:57 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id AFC371884960;
        Tue, 18 Oct 2022 16:56:55 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 956DA25001FA;
        Tue, 18 Oct 2022 16:56:55 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 8C0CA9EC000A; Tue, 18 Oct 2022 16:56:55 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id BC6719EC0001;
        Tue, 18 Oct 2022 16:56:54 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v8 net-next 02/12] net: bridge: add blackhole fdb entry flag
Date:   Tue, 18 Oct 2022 18:56:09 +0200
Message-Id: <20221018165619.134535-3-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018165619.134535-1-netdev@kapio-technology.com>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a 'blackhole' fdb flag, ensuring that no forwarding from any port
to a destination MAC that has a FDB entry with this flag on will occur.
The packets will thus be dropped.

When the blackhole fdb flag is set, the 'local' flag will also be enabled
as blackhole entries are not associated with any port.

Thus the command will be alike to:
bridge fdb add MAC dev br0 local blackhole

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 include/uapi/linux/neighbour.h |  4 ++++
 net/bridge/br_fdb.c            | 37 ++++++++++++++++++++++++++++------
 net/bridge/br_input.c          |  5 ++++-
 net/bridge/br_private.h        |  1 +
 4 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 4dda051b0ba8..cc7d540eb734 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -54,6 +54,7 @@ enum {
 /* Extended flags under NDA_FLAGS_EXT: */
 #define NTF_EXT_MANAGED		(1 << 0)
 #define NTF_EXT_LOCKED		(1 << 1)
+#define NTF_EXT_BLACKHOLE	(1 << 2)
 
 /*
  *	Neighbor Cache Entry States.
@@ -91,6 +92,9 @@ enum {
  * NTF_EXT_LOCKED flagged FDB entries are placeholder entries used with the
  * locked port feature, that ensures that an entry exists while at the same
  * time dropping packets on ingress with src MAC and VID matching the entry.
+ *
+ * NTF_EXT_BLACKHOLE flagged FDB entries ensure that no forwarding is allowed
+ * from any port to the destination MAC, VID pair associated with it.
  */
 
 struct nda_cacheinfo {
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2cf695ee61c5..15ead4dc6190 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -128,6 +128,8 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 		ndm->ndm_flags |= NTF_STICKY;
 	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
 		ext_flags |= NTF_EXT_LOCKED;
+	if (test_bit(BR_FDB_BLACKHOLE, &fdb->flags))
+		ext_flags |= NTF_EXT_BLACKHOLE;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
 		goto nla_put_failure;
@@ -1018,8 +1020,9 @@ static bool fdb_handle_notify(struct net_bridge_fdb_entry *fdb, u8 notify)
 /* Update (create or replace) forwarding database entry */
 static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			 const u8 *addr, struct ndmsg *ndm, u16 flags, u16 vid,
-			 struct nlattr *nfea_tb[])
+			 u32 ext_flags, struct nlattr *nfea_tb[])
 {
+	bool blackhole = !!(ext_flags & NTF_EXT_BLACKHOLE);
 	bool is_sticky = !!(ndm->ndm_flags & NTF_STICKY);
 	bool refresh = !nfea_tb[NFEA_DONT_REFRESH];
 	struct net_bridge_fdb_entry *fdb;
@@ -1092,6 +1095,11 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		modified = true;
 	}
 
+	if (blackhole != test_bit(BR_FDB_BLACKHOLE, &fdb->flags)) {
+		change_bit(BR_FDB_BLACKHOLE, &fdb->flags);
+		modified = true;
+	}
+
 	if (test_and_clear_bit(BR_FDB_LOCKED, &fdb->flags))
 		modified = true;
 
@@ -1113,7 +1121,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 			struct net_bridge_port *p, const unsigned char *addr,
 			u16 nlh_flags, u16 vid, struct nlattr *nfea_tb[],
-			struct netlink_ext_ack *extack)
+			u32 ext_flags, struct netlink_ext_ack *extack)
 {
 	int err = 0;
 
@@ -1140,7 +1148,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 		err = br_fdb_external_learn_add(br, p, addr, vid, true);
 	} else {
 		spin_lock_bh(&br->hash_lock);
-		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
+		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, ext_flags, nfea_tb);
 		spin_unlock_bh(&br->hash_lock);
 	}
 
@@ -1200,6 +1208,23 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		return -EINVAL;
 	}
 
+	if (ext_flags & NTF_EXT_BLACKHOLE) {
+		if (!(ndm->ndm_state & NUD_PERMANENT)) {
+			NL_SET_ERR_MSG_MOD(extack, "Blackhole FDB entry must be permanent");
+			return -EINVAL;
+		}
+		if (p) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Blackhole FDB entry cannot be applied on a port");
+			return -EINVAL;
+		}
+		if (ndm->ndm_flags & NTF_EXT_LEARNED) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Blackhole FDB entry cannot be added as ext. learned");
+			return -EINVAL;
+		}
+	}
+
 	if (tb[NDA_FDB_EXT_ATTRS]) {
 		attr = tb[NDA_FDB_EXT_ATTRS];
 		err = nla_parse_nested(nfea_tb, NFEA_MAX, attr,
@@ -1219,10 +1244,10 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 
 		/* VID was specified, so use it. */
 		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, vid, nfea_tb,
-				   extack);
+				   ext_flags, extack);
 	} else {
 		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, 0, nfea_tb,
-				   extack);
+				   ext_flags, extack);
 		if (err || !vg || !vg->num_vlans)
 			goto out;
 
@@ -1234,7 +1259,7 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			if (!br_vlan_should_use(v))
 				continue;
 			err = __br_fdb_add(ndm, br, p, addr, nlh_flags, v->vid,
-					   nfea_tb, extack);
+					   nfea_tb, ext_flags, extack);
 			if (err)
 				goto out;
 		}
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 068fced7693c..665d1d6bdc75 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -193,8 +193,11 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	if (dst) {
 		unsigned long now = jiffies;
 
-		if (test_bit(BR_FDB_LOCAL, &dst->flags))
+		if (test_bit(BR_FDB_LOCAL, &dst->flags)) {
+			if (unlikely(test_bit(BR_FDB_BLACKHOLE, &dst->flags)))
+				goto drop;
 			return br_pass_frame_up(skb);
+		}
 
 		if (now != dst->used)
 			dst->used = now;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4ce8b8e5ae0b..e7a08657c7ed 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -253,6 +253,7 @@ enum {
 	BR_FDB_NOTIFY,
 	BR_FDB_NOTIFY_INACTIVE,
 	BR_FDB_LOCKED,
+	BR_FDB_BLACKHOLE,
 };
 
 struct net_bridge_fdb_key {
-- 
2.34.1

