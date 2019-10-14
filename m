Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0143DD6B87
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731515AbfJNWLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:11:05 -0400
Received: from correo.us.es ([193.147.175.20]:35602 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731349AbfJNWLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 18:11:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EB2DB1694B7
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:10:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4531A7E1F
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:10:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 71541A7E11; Tue, 15 Oct 2019 00:10:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AE7ADA72F;
        Tue, 15 Oct 2019 00:10:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 00:10:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B6EC7426CCBA;
        Tue, 15 Oct 2019 00:10:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: [PATCH net-next,v5 1/4] net: flow_offload: flip mangle action mask
Date:   Tue, 15 Oct 2019 00:10:48 +0200
Message-Id: <20191014221051.8084-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191014221051.8084-1-pablo@netfilter.org>
References: <20191014221051.8084-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Userspace tc pedit action performs a bitwise NOT operation on the mask.
All of the existing drivers in the tree undo this operation. Prepare the
mangle mask in the way the drivers expect from the
tc_setup_flow_action() function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: no changes.

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |  6 +++---
 drivers/net/ethernet/netronome/nfp/flower/action.c   |  8 ++++----
 net/sched/cls_api.c                                  |  2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index e447976bdd3e..2d26dbca701d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -275,7 +275,7 @@ static int cxgb4_validate_flow_match(struct net_device *dev,
 static void offload_pedit(struct ch_filter_specification *fs, u32 val, u32 mask,
 			  u8 field)
 {
-	u32 set_val = val & ~mask;
+	u32 set_val = val & mask;
 	u32 offset = 0;
 	u8 size = 1;
 	int i;
@@ -301,7 +301,7 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 			offload_pedit(fs, val, mask, ETH_DMAC_31_0);
 			break;
 		case PEDIT_ETH_DMAC_47_32_SMAC_15_0:
-			if (~mask & PEDIT_ETH_DMAC_MASK)
+			if (mask & PEDIT_ETH_DMAC_MASK)
 				offload_pedit(fs, val, mask, ETH_DMAC_47_32);
 			else
 				offload_pedit(fs, val >> 16, mask >> 16,
@@ -353,7 +353,7 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
 		switch (offset) {
 		case PEDIT_TCP_SPORT_DPORT:
-			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+			if (mask & PEDIT_TCP_UDP_SPORT_MASK)
 				offload_pedit(fs, cpu_to_be32(val) >> 16,
 					      cpu_to_be32(mask) >> 16,
 					      TCP_SPORT);
@@ -366,7 +366,7 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
 		switch (offset) {
 		case PEDIT_UDP_SPORT_DPORT:
-			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+			if (mask & PEDIT_TCP_UDP_SPORT_MASK)
 				offload_pedit(fs, cpu_to_be32(val) >> 16,
 					      cpu_to_be32(mask) >> 16,
 					      UDP_SPORT);
@@ -510,7 +510,7 @@ static bool valid_pedit_action(struct net_device *dev,
 	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
 		switch (offset) {
 		case PEDIT_TCP_SPORT_DPORT:
-			if (!valid_l4_mask(~mask)) {
+			if (!valid_l4_mask(mask)) {
 				netdev_err(dev, "%s: Unsupported mask for TCP L4 ports\n",
 					   __func__);
 				return false;
@@ -525,7 +525,7 @@ static bool valid_pedit_action(struct net_device *dev,
 	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
 		switch (offset) {
 		case PEDIT_UDP_SPORT_DPORT:
-			if (!valid_l4_mask(~mask)) {
+			if (!valid_l4_mask(mask)) {
 				netdev_err(dev, "%s: Unsupported mask for UDP L4 ports\n",
 					   __func__);
 				return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3e78a727f3e6..80e02b88ed77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2523,7 +2523,7 @@ static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 	val = act->mangle.val;
 	offset = act->mangle.offset;
 
-	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
+	err = set_pedit_val(htype, mask, val, offset, &hdrs[cmd]);
 	if (err)
 		goto out_err;
 
@@ -2623,7 +2623,7 @@ static bool is_action_keys_supported(const struct flow_action_entry *act)
 
 	htype = act->mangle.htype;
 	offset = act->mangle.offset;
-	mask = ~act->mangle.mask;
+	mask = act->mangle.mask;
 	/* For IPv4 & IPv6 header check 4 byte word,
 	 * to determine that modified fields
 	 * are NOT ttl & hop_limit only.
@@ -2747,7 +2747,7 @@ static int add_vlan_rewrite_action(struct mlx5e_priv *priv, int namespace,
 		.id = FLOW_ACTION_MANGLE,
 		.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH,
 		.mangle.offset = offsetof(struct vlan_ethhdr, h_vlan_TCI),
-		.mangle.mask = ~(u32)be16_to_cpu(*(__be16 *)&mask16),
+		.mangle.mask = (u32)be16_to_cpu(*(__be16 *)&mask16),
 		.mangle.val = (u32)be16_to_cpu(*(__be16 *)&val16),
 	};
 	u8 match_prio_mask, match_prio_val;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 1b019fdfcd97..ee0066a7ba87 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -495,7 +495,7 @@ nfp_fl_set_eth(const struct flow_action_entry *act, u32 off,
 		return -EOPNOTSUPP;
 	}
 
-	mask = ~act->mangle.mask;
+	mask = act->mangle.mask;
 	exact = act->mangle.val;
 
 	if (exact & ~mask) {
@@ -532,7 +532,7 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 	__be32 exact, mask;
 
 	/* We are expecting tcf_pedit to return a big endian value */
-	mask = (__force __be32)~act->mangle.mask;
+	mask = (__force __be32)act->mangle.mask;
 	exact = (__force __be32)act->mangle.val;
 
 	if (exact & ~mask) {
@@ -673,7 +673,7 @@ nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
 	u8 word;
 
 	/* We are expecting tcf_pedit to return a big endian value */
-	mask = (__force __be32)~act->mangle.mask;
+	mask = (__force __be32)act->mangle.mask;
 	exact = (__force __be32)act->mangle.val;
 
 	if (exact & ~mask) {
@@ -713,7 +713,7 @@ nfp_fl_set_tport(const struct flow_action_entry *act, u32 off,
 		return -EOPNOTSUPP;
 	}
 
-	mask = ~act->mangle.mask;
+	mask = act->mangle.mask;
 	exact = act->mangle.val;
 
 	if (exact & ~mask) {
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 64584a1df425..55a5556328a2 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3409,7 +3409,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 					goto err_out;
 				}
 				entry->mangle.htype = tcf_pedit_htype(act, k);
-				entry->mangle.mask = tcf_pedit_mask(act, k);
+				entry->mangle.mask = ~tcf_pedit_mask(act, k);
 				entry->mangle.val = tcf_pedit_val(act, k);
 				entry->mangle.offset = tcf_pedit_offset(act, k);
 				entry = &flow_action->entries[++j];
-- 
2.11.0

