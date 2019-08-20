Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB6595C9E
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfHTKwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:52:36 -0400
Received: from correo.us.es ([193.147.175.20]:39258 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbfHTKwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 06:52:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D20EF2783
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 12:52:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D5CDDA4CA
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 12:52:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5301CDA7B6; Tue, 20 Aug 2019 12:52:32 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 071EADA4D0;
        Tue, 20 Aug 2019 12:52:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Aug 2019 12:52:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.43.0])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 49D514265A2F;
        Tue, 20 Aug 2019 12:52:28 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us, vladbu@mellanox.com
Subject: [PATCH net-next 1/2] net: flow_offload: mangle 128-bit packet field with one action
Date:   Tue, 20 Aug 2019 12:52:24 +0200
Message-Id: <20190820105225.13943-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing infrastructure needs the front-end to generate up to four
actions (one for each 32-bit word) to mangle an IPv6 address. This patch
allows you to mangle fields than are longer than 4-bytes with one single
action. Drivers have been adapted to this new representation following a
simple approach, that is, iterate over the array of words and configure
the hardware IR to make the packet mangling. FLOW_ACTION_MANGLE_MAX_WORDS
defines the maximum number of words from one given offset (currently 4
words).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 44 ++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 50 +++++++++++-----
 drivers/net/ethernet/netronome/nfp/flower/action.c | 69 ++++++++++++++--------
 include/net/flow_offload.h                         |  9 ++-
 net/sched/cls_api.c                                |  7 ++-
 5 files changed, 125 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index e447976bdd3e..6a961e29a904 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -428,13 +428,17 @@ static void cxgb4_process_flow_actions(struct net_device *in,
 		case FLOW_ACTION_MANGLE: {
 			u32 mask, val, offset;
 			u8 htype;
+			int i;
 
 			htype = act->mangle.htype;
-			mask = act->mangle.mask;
-			val = act->mangle.val;
 			offset = act->mangle.offset;
 
-			process_pedit_field(fs, val, mask, offset, htype);
+			for (i = 0; i < act->mangle.words; i++) {
+				mask = act->mangle.data[i].mask;
+				val = act->mangle.data[i].val;
+				process_pedit_field(fs, val, mask, offset, htype);
+				offset += sizeof(u32);
+			}
 			}
 			break;
 		default:
@@ -456,16 +460,9 @@ static bool valid_l4_mask(u32 mask)
 	return hi && lo ? false : true;
 }
 
-static bool valid_pedit_action(struct net_device *dev,
-			       const struct flow_action_entry *act)
+static bool __valid_pedit_action(struct net_device *dev, u8 htype,
+				 __be32 mask, __be32 offset)
 {
-	u32 mask, offset;
-	u8 htype;
-
-	htype = act->mangle.htype;
-	mask = act->mangle.mask;
-	offset = act->mangle.offset;
-
 	switch (htype) {
 	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
 		switch (offset) {
@@ -541,6 +538,29 @@ static bool valid_pedit_action(struct net_device *dev,
 		netdev_err(dev, "%s: Unsupported pedit type\n", __func__);
 		return false;
 	}
+
+	return true;
+}
+
+static bool valid_pedit_action(struct net_device *dev,
+			       const struct flow_action_entry *act)
+{
+	u32 mask, offset;
+	u8 htype;
+	int i;
+
+	htype = act->mangle.htype;
+	offset = act->mangle.offset;
+
+	for (i = 0; i < act->mangle.words; i++) {
+		mask = act->mangle.data[i].mask;
+
+		if (!__valid_pedit_action(dev, htype, mask, offset))
+			return false;
+
+		offset += sizeof(u32);
+	}
+
 	return true;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c57f7533a6d0..bb24616ee27f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2411,6 +2411,7 @@ static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 	int err = -EOPNOTSUPP;
 	u32 mask, val, offset;
 	u8 htype;
+	int i;
 
 	htype = act->mangle.htype;
 	err = -EOPNOTSUPP; /* can't be all optimistic */
@@ -2426,15 +2427,19 @@ static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 		goto out_err;
 	}
 
-	mask = act->mangle.mask;
-	val = act->mangle.val;
 	offset = act->mangle.offset;
 
-	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
-	if (err)
-		goto out_err;
+	for (i = 0; i < act->mangle.words; i++) {
+		val = act->mangle.data[i].val;
+		mask = act->mangle.data[i].mask;
 
-	hdrs[cmd].pedits++;
+		err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
+		if (err)
+			goto out_err;
+
+		offset += sizeof(u32);
+		hdrs[cmd].pedits++;
+	}
 
 	return 0;
 out_err:
@@ -2523,14 +2528,8 @@ struct ipv6_hoplimit_word {
 	__u8	hop_limit;
 };
 
-static bool is_action_keys_supported(const struct flow_action_entry *act)
+static bool __is_action_keys_supported(u8 htype, u32 offset, u32 mask)
 {
-	u32 mask, offset;
-	u8 htype;
-
-	htype = act->mangle.htype;
-	offset = act->mangle.offset;
-	mask = ~act->mangle.mask;
 	/* For IPv4 & IPv6 header check 4 byte word,
 	 * to determine that modified fields
 	 * are NOT ttl & hop_limit only.
@@ -2557,6 +2556,26 @@ static bool is_action_keys_supported(const struct flow_action_entry *act)
 	return false;
 }
 
+static bool is_action_keys_supported(const struct flow_action_entry *act)
+{
+	u32 mask, offset;
+	u8 htype;
+	int i;
+
+	htype = act->mangle.htype;
+	offset = act->mangle.offset;
+
+	for (i = 0; i < act->mangle.words; i++) {
+		mask = ~act->mangle.data[i].mask;
+		if (!__is_action_keys_supported(htype, offset, mask))
+			return false;
+
+		offset += sizeof(u32);
+	}
+
+	return true;
+}
+
 static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
 					  struct flow_action *flow_action,
 					  u32 actions,
@@ -2654,8 +2673,9 @@ static int add_vlan_rewrite_action(struct mlx5e_priv *priv, int namespace,
 		.id = FLOW_ACTION_MANGLE,
 		.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH,
 		.mangle.offset = offsetof(struct vlan_ethhdr, h_vlan_TCI),
-		.mangle.mask = ~(u32)be16_to_cpu(*(__be16 *)&mask16),
-		.mangle.val = (u32)be16_to_cpu(*(__be16 *)&val16),
+		.mangle.data[0].mask = ~(u32)be16_to_cpu(*(__be16 *)&mask16),
+		.mangle.data[0].val = (u32)be16_to_cpu(*(__be16 *)&val16),
+		.mangle.words = 1,
 	};
 	u8 match_prio_mask, match_prio_val;
 	void *headers_c, *headers_v;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 1b019fdfcd97..15bace2354dc 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -485,7 +485,7 @@ static void nfp_fl_set_helper32(u32 value, u32 mask, u8 *p_exact, u8 *p_mask)
 }
 
 static int
-nfp_fl_set_eth(const struct flow_action_entry *act, u32 off,
+nfp_fl_set_eth(const struct flow_action_entry *act, u32 idx, u32 off,
 	       struct nfp_fl_set_eth *set_eth, struct netlink_ext_ack *extack)
 {
 	u32 exact, mask;
@@ -495,8 +495,8 @@ nfp_fl_set_eth(const struct flow_action_entry *act, u32 off,
 		return -EOPNOTSUPP;
 	}
 
-	mask = ~act->mangle.mask;
-	exact = act->mangle.val;
+	mask = ~act->mangle.data[idx].mask;
+	exact = act->mangle.data[idx].val;
 
 	if (exact & ~mask) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit ethernet action");
@@ -520,7 +520,7 @@ struct ipv4_ttl_word {
 };
 
 static int
-nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
+nfp_fl_set_ip4(const struct flow_action_entry *act, u32 idx, u32 off,
 	       struct nfp_fl_set_ip4_addrs *set_ip_addr,
 	       struct nfp_fl_set_ip4_ttl_tos *set_ip_ttl_tos,
 	       struct netlink_ext_ack *extack)
@@ -532,8 +532,8 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 	__be32 exact, mask;
 
 	/* We are expecting tcf_pedit to return a big endian value */
-	mask = (__force __be32)~act->mangle.mask;
-	exact = (__force __be32)act->mangle.val;
+	mask = (__force __be32)~act->mangle.data[idx].mask;
+	exact = (__force __be32)act->mangle.data[idx].val;
 
 	if (exact & ~mask) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv4 action");
@@ -662,7 +662,7 @@ nfp_fl_set_ip6_hop_limit_flow_label(u32 off, __be32 exact, __be32 mask,
 }
 
 static int
-nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
+nfp_fl_set_ip6(const struct flow_action_entry *act, u32 idx, u32 off,
 	       struct nfp_fl_set_ipv6_addr *ip_dst,
 	       struct nfp_fl_set_ipv6_addr *ip_src,
 	       struct nfp_fl_set_ipv6_tc_hl_fl *ip_hl_fl,
@@ -673,8 +673,8 @@ nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
 	u8 word;
 
 	/* We are expecting tcf_pedit to return a big endian value */
-	mask = (__force __be32)~act->mangle.mask;
-	exact = (__force __be32)act->mangle.val;
+	mask = (__force __be32)~act->mangle.data[idx].mask;
+	exact = (__force __be32)act->mangle.data[idx].val;
 
 	if (exact & ~mask) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 action");
@@ -702,7 +702,7 @@ nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
 }
 
 static int
-nfp_fl_set_tport(const struct flow_action_entry *act, u32 off,
+nfp_fl_set_tport(const struct flow_action_entry *act, u32 idx, u32 off,
 		 struct nfp_fl_set_tport *set_tport, int opcode,
 		 struct netlink_ext_ack *extack)
 {
@@ -713,8 +713,8 @@ nfp_fl_set_tport(const struct flow_action_entry *act, u32 off,
 		return -EOPNOTSUPP;
 	}
 
-	mask = ~act->mangle.mask;
-	exact = act->mangle.val;
+	mask = ~act->mangle.data[idx].mask;
+	exact = act->mangle.data[idx].val;
 
 	if (exact & ~mask) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit L4 action");
@@ -860,32 +860,31 @@ nfp_fl_commit_mangle(struct flow_cls_offload *flow, char *nfp_action,
 }
 
 static int
-nfp_fl_pedit(const struct flow_action_entry *act,
-	     struct flow_cls_offload *flow, char *nfp_action, int *a_len,
-	     u32 *csum_updated, struct nfp_flower_pedit_acts *set_act,
-	     struct netlink_ext_ack *extack)
+__nfp_fl_pedit(const struct flow_action_entry *act, u32 idx, u32 offset,
+	       struct flow_cls_offload *flow, char *nfp_action, int *a_len,
+	       u32 *csum_updated, struct nfp_flower_pedit_acts *set_act,
+	       struct netlink_ext_ack *extack)
 {
 	enum flow_action_mangle_base htype;
-	u32 offset;
 
 	htype = act->mangle.htype;
-	offset = act->mangle.offset;
 
 	switch (htype) {
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
-		return nfp_fl_set_eth(act, offset, &set_act->set_eth, extack);
+		return nfp_fl_set_eth(act, idx, offset, &set_act->set_eth,
+				      extack);
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
-		return nfp_fl_set_ip4(act, offset, &set_act->set_ip_addr,
+		return nfp_fl_set_ip4(act, idx, offset, &set_act->set_ip_addr,
 				      &set_act->set_ip_ttl_tos, extack);
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
-		return nfp_fl_set_ip6(act, offset, &set_act->set_ip6_dst,
+		return nfp_fl_set_ip6(act, idx, offset, &set_act->set_ip6_dst,
 				      &set_act->set_ip6_src,
 				      &set_act->set_ip6_tc_hl_fl, extack);
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
-		return nfp_fl_set_tport(act, offset, &set_act->set_tport,
+		return nfp_fl_set_tport(act, idx, offset, &set_act->set_tport,
 					NFP_FL_ACTION_OPCODE_SET_TCP, extack);
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
-		return nfp_fl_set_tport(act, offset, &set_act->set_tport,
+		return nfp_fl_set_tport(act, idx, offset, &set_act->set_tport,
 					NFP_FL_ACTION_OPCODE_SET_UDP, extack);
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pedit on unsupported header");
@@ -894,6 +893,30 @@ nfp_fl_pedit(const struct flow_action_entry *act,
 }
 
 static int
+nfp_fl_pedit(const struct flow_action_entry *act,
+	     struct flow_cls_offload *flow, char *nfp_action, int *a_len,
+	     u32 *csum_updated, struct nfp_flower_pedit_acts *set_act,
+	     struct netlink_ext_ack *extack)
+{
+	u32 offset, idx;
+	int err;
+
+	offset = act->mangle.offset;
+
+	for (idx = 0; idx < act->mangle.words; idx++) {
+		err = __nfp_fl_pedit(act, idx, offset, flow,
+				     nfp_action, a_len, csum_updated, set_act,
+				     extack);
+		if (err < 0)
+			return err;
+
+		offset += sizeof(u32);
+	}
+
+	return 0;
+}
+
+static int
 nfp_flower_output_action(struct nfp_app *app,
 			 const struct flow_action_entry *act,
 			 struct nfp_fl_payload *nfp_fl, int *a_len,
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index e8069b6c474c..d3fc6b7dcd6a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -153,6 +153,8 @@ enum flow_action_mangle_base {
 	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 };
 
+#define FLOW_ACTION_MANGLE_MAX_WORDS	4
+
 struct flow_action_entry {
 	enum flow_action_id		id;
 	union {
@@ -166,8 +168,11 @@ struct flow_action_entry {
 		struct {				/* FLOW_ACTION_PACKET_EDIT */
 			enum flow_action_mangle_base htype;
 			u32		offset;
-			u32		mask;
-			u32		val;
+			struct {
+				u32	mask;
+				u32	val;
+			} data[FLOW_ACTION_MANGLE_MAX_WORDS];
+			u32		words;
 		} mangle;
 		const struct ip_tunnel_info *tunnel;	/* FLOW_ACTION_TUNNEL_ENCAP */
 		u32			csum_flags;	/* FLOW_ACTION_CSUM */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e0d8b456e9f5..041cd4000389 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3077,9 +3077,12 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 					goto err_out;
 				}
 				entry->mangle.htype = tcf_pedit_htype(act, k);
-				entry->mangle.mask = tcf_pedit_mask(act, k);
-				entry->mangle.val = tcf_pedit_val(act, k);
+				entry->mangle.data[0].mask =
+					tcf_pedit_mask(act, k);
+				entry->mangle.data[0].val =
+					tcf_pedit_val(act, k);
 				entry->mangle.offset = tcf_pedit_offset(act, k);
+				entry->mangle.words = 1;
 				entry = &flow_action->entries[++j];
 			}
 		} else if (is_tcf_csum(act)) {
-- 
2.11.0


