Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 332F2D6B82
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbfJNWLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:11:04 -0400
Received: from correo.us.es ([193.147.175.20]:35606 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730989AbfJNWLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 18:11:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6CEB41694A9
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:10:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51E52A7E1F
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:10:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3F8CEA7E19; Tue, 15 Oct 2019 00:10:59 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3A71A7EC0;
        Tue, 15 Oct 2019 00:10:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 00:10:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8A2B7426CCBA;
        Tue, 15 Oct 2019 00:10:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: [PATCH net-next,v5 2/4] net: flow_offload: bitwise AND on mangle action value field
Date:   Tue, 15 Oct 2019 00:10:49 +0200
Message-Id: <20191014221051.8084-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191014221051.8084-1-pablo@netfilter.org>
References: <20191014221051.8084-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers perform a bitwise AND on the value and the mask. Update
tc_setup_flow_action() to perform this operation so drivers do not need
to do this.

Remove sanity check for sane value and mask values from the nfp driver,
the front-end already guarantees this after this patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: remove exact and mask sanity checks from nfp driver, front-end already
    validates this in patch 3/4.

 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/action.c | 29 +++-------------------
 net/sched/cls_api.c                                |  3 ++-
 4 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 2d26dbca701d..5afc15a60199 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -275,7 +275,6 @@ static int cxgb4_validate_flow_match(struct net_device *dev,
 static void offload_pedit(struct ch_filter_specification *fs, u32 val, u32 mask,
 			  u8 field)
 {
-	u32 set_val = val & mask;
 	u32 offset = 0;
 	u8 size = 1;
 	int i;
@@ -287,7 +286,7 @@ static void offload_pedit(struct ch_filter_specification *fs, u32 val, u32 mask,
 			break;
 		}
 	}
-	memcpy((u8 *)fs + offset, &set_val, size);
+	memcpy((u8 *)fs + offset, &val, size);
 }
 
 static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 80e02b88ed77..be25b1eae9c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2228,7 +2228,7 @@ static int set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
 		goto out_err;
 
 	*curr_pmask |= mask;
-	*curr_pval  |= (val & mask);
+	*curr_pval  |= val;
 
 	return 0;
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index ee0066a7ba87..07db0a7ba0d5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -477,7 +477,6 @@ static void nfp_fl_set_helper32(u32 value, u32 mask, u8 *p_exact, u8 *p_mask)
 	u32 oldvalue = get_unaligned((u32 *)p_exact);
 	u32 oldmask = get_unaligned((u32 *)p_mask);
 
-	value &= mask;
 	value |= oldvalue & ~mask;
 
 	put_unaligned(oldmask | mask, (u32 *)p_mask);
@@ -498,11 +497,6 @@ nfp_fl_set_eth(const struct flow_action_entry *act, u32 off,
 	mask = act->mangle.mask;
 	exact = act->mangle.val;
 
-	if (exact & ~mask) {
-		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit ethernet action");
-		return -EOPNOTSUPP;
-	}
-
 	nfp_fl_set_helper32(exact, mask, &set_eth->eth_addr_val[off],
 			    &set_eth->eth_addr_mask[off]);
 
@@ -535,16 +529,11 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 	mask = (__force __be32)act->mangle.mask;
 	exact = (__force __be32)act->mangle.val;
 
-	if (exact & ~mask) {
-		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv4 action");
-		return -EOPNOTSUPP;
-	}
-
 	switch (off) {
 	case offsetof(struct iphdr, daddr):
 		set_ip_addr->ipv4_dst_mask |= mask;
 		set_ip_addr->ipv4_dst &= ~mask;
-		set_ip_addr->ipv4_dst |= exact & mask;
+		set_ip_addr->ipv4_dst |= exact;
 		set_ip_addr->head.jump_id = NFP_FL_ACTION_OPCODE_SET_IPV4_ADDRS;
 		set_ip_addr->head.len_lw = sizeof(*set_ip_addr) >>
 					   NFP_FL_LW_SIZ;
@@ -552,7 +541,7 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 	case offsetof(struct iphdr, saddr):
 		set_ip_addr->ipv4_src_mask |= mask;
 		set_ip_addr->ipv4_src &= ~mask;
-		set_ip_addr->ipv4_src |= exact & mask;
+		set_ip_addr->ipv4_src |= exact;
 		set_ip_addr->head.jump_id = NFP_FL_ACTION_OPCODE_SET_IPV4_ADDRS;
 		set_ip_addr->head.len_lw = sizeof(*set_ip_addr) >>
 					   NFP_FL_LW_SIZ;
@@ -606,7 +595,7 @@ nfp_fl_set_ip6_helper(int opcode_tag, u8 word, __be32 exact, __be32 mask,
 {
 	ip6->ipv6[word].mask |= mask;
 	ip6->ipv6[word].exact &= ~mask;
-	ip6->ipv6[word].exact |= exact & mask;
+	ip6->ipv6[word].exact |= exact;
 
 	ip6->reserved = cpu_to_be16(0);
 	ip6->head.jump_id = opcode_tag;
@@ -651,7 +640,7 @@ nfp_fl_set_ip6_hop_limit_flow_label(u32 off, __be32 exact, __be32 mask,
 
 		ip_hl_fl->ipv6_label_mask |= mask;
 		ip_hl_fl->ipv6_label &= ~mask;
-		ip_hl_fl->ipv6_label |= exact & mask;
+		ip_hl_fl->ipv6_label |= exact;
 		break;
 	}
 
@@ -676,11 +665,6 @@ nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
 	mask = (__force __be32)act->mangle.mask;
 	exact = (__force __be32)act->mangle.val;
 
-	if (exact & ~mask) {
-		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 action");
-		return -EOPNOTSUPP;
-	}
-
 	if (off < offsetof(struct ipv6hdr, saddr)) {
 		err = nfp_fl_set_ip6_hop_limit_flow_label(off, exact, mask,
 							  ip_hl_fl, extack);
@@ -716,11 +700,6 @@ nfp_fl_set_tport(const struct flow_action_entry *act, u32 off,
 	mask = act->mangle.mask;
 	exact = act->mangle.val;
 
-	if (exact & ~mask) {
-		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit L4 action");
-		return -EOPNOTSUPP;
-	}
-
 	nfp_fl_set_helper32(exact, mask, set_tport->tp_port_val,
 			    set_tport->tp_port_mask);
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 55a5556328a2..2656203eaaf1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3410,7 +3410,8 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				}
 				entry->mangle.htype = tcf_pedit_htype(act, k);
 				entry->mangle.mask = ~tcf_pedit_mask(act, k);
-				entry->mangle.val = tcf_pedit_val(act, k);
+				entry->mangle.val = tcf_pedit_val(act, k) &
+							entry->mangle.mask;
 				entry->mangle.offset = tcf_pedit_offset(act, k);
 				entry = &flow_action->entries[++j];
 			}
-- 
2.11.0

