Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9BF56A6E2
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 17:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbiGGP3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 11:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiGGP3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 11:29:49 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D784B240AD;
        Thu,  7 Jul 2022 08:29:47 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 85C011886E4E;
        Thu,  7 Jul 2022 15:29:46 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 6F14125032B7;
        Thu,  7 Jul 2022 15:29:46 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 65F9FA1E00B8; Thu,  7 Jul 2022 15:29:46 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from wse-c0127.vestervang (unknown [208.127.141.28])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id EF2E99120FED;
        Thu,  7 Jul 2022 15:29:44 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v4 net-next 1/6] net: bridge: add locked entry fdb flag to extend locked port feature
Date:   Thu,  7 Jul 2022 17:29:25 +0200
Message-Id: <20220707152930.1789437-2-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220707152930.1789437-1-netdev@kapio-technology.com>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an intermediate state for clients behind a locked port to allow for
possible opening of the port for said clients. The clients mac address
will be added with the locked flag set, denying access through the port
for the mac address, but also creating a new FDB add event giving
userspace daemons the ability to unlock the mac address. This feature
corresponds to the Mac-Auth and MAC Authentication Bypass (MAB) named
features. The latter defined by Cisco.

Only the kernel can set this FDB entry flag, while userspace can read
the flag and remove it by replacing or deleting the FDB entry.

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
---
 include/uapi/linux/neighbour.h |  1 +
 net/bridge/br_fdb.c            | 12 ++++++++++++
 net/bridge/br_input.c          | 10 +++++++++-
 net/bridge/br_private.h        |  3 ++-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 39c565e460c7..76d65b481086 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -53,6 +53,7 @@ enum {
 #define NTF_ROUTER	(1 << 7)
 /* Extended flags under NDA_FLAGS_EXT: */
 #define NTF_EXT_MANAGED	(1 << 0)
+#define NTF_EXT_LOCKED	(1 << 1)
 
 /*
  *	Neighbor Cache Entry States.
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e7f4fccb6adb..ee9064a536ae 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 	struct nda_cacheinfo ci;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
+	u32 ext_flags = 0;
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
 	if (nlh == NULL)
@@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
 	if (test_bit(BR_FDB_STICKY, &fdb->flags))
 		ndm->ndm_flags |= NTF_STICKY;
+	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
+		ext_flags |= NTF_EXT_LOCKED;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
 		goto nla_put_failure;
 	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
 		goto nla_put_failure;
+	if (nla_put_u32(skb, NDA_FLAGS_EXT, ext_flags))
+		goto nla_put_failure;
+
 	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
 	ci.ndm_confirmed = 0;
 	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
@@ -171,6 +177,7 @@ static inline size_t fdb_nlmsg_size(void)
 	return NLMSG_ALIGN(sizeof(struct ndmsg))
 		+ nla_total_size(ETH_ALEN) /* NDA_LLADDR */
 		+ nla_total_size(sizeof(u32)) /* NDA_MASTER */
+		+ nla_total_size(sizeof(u32)) /* NDA_FLAGS_EXT */
 		+ nla_total_size(sizeof(u16)) /* NDA_VLAN */
 		+ nla_total_size(sizeof(struct nda_cacheinfo))
 		+ nla_total_size(0) /* NDA_FDB_EXT_ATTRS */
@@ -1082,6 +1089,11 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		modified = true;
 	}
 
+	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags)) {
+		clear_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags);
+		modified = true;
+	}
+
 	if (fdb_handle_notify(fdb, notify))
 		modified = true;
 
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 68b3e850bcb9..3d15548cfda6 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -110,8 +110,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
 
 		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
-		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
+		    test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
+		    test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags)) {
+			if (!fdb_src) {
+				unsigned long flags = 0;
+
+				__set_bit(BR_FDB_ENTRY_LOCKED, &flags);
+				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
+			}
 			goto drop;
+		}
 	}
 
 	nbp_switchdev_frame_mark(p, skb);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06e5f6faa431..47a3598d25c8 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -251,7 +251,8 @@ enum {
 	BR_FDB_ADDED_BY_EXT_LEARN,
 	BR_FDB_OFFLOADED,
 	BR_FDB_NOTIFY,
-	BR_FDB_NOTIFY_INACTIVE
+	BR_FDB_NOTIFY_INACTIVE,
+	BR_FDB_ENTRY_LOCKED,
 };
 
 struct net_bridge_fdb_key {
-- 
2.30.2

