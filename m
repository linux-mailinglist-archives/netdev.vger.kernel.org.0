Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B520D6B88
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbfJNWLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:11:09 -0400
Received: from correo.us.es ([193.147.175.20]:35636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbfJNWLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 18:11:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 232641694AC
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:11:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10FEBA7E18
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:11:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 05F6AA7E0F; Tue, 15 Oct 2019 00:11:01 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8DF9A7E98;
        Tue, 15 Oct 2019 00:10:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 00:10:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5CF1C426CCBA;
        Tue, 15 Oct 2019 00:10:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at byte level
Date:   Tue, 15 Oct 2019 00:10:50 +0200
Message-Id: <20191014221051.8084-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191014221051.8084-1-pablo@netfilter.org>
References: <20191014221051.8084-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flow mangle action is originally modeled after the tc pedit action,
this has a number of shortcomings:

1) The tc pedit offset must be set on the 32-bits boundaries. Many
   protocol header field offsets are not aligned to 32-bits, eg. port
   destination, port source and ethernet destination. This patch adjusts
   the offset accordingly and trim off length in these case, so drivers get
   an exact offset and length to the header fields.

2) The maximum mangle length is one word of 32-bits, hence you need to
   up to four actions to mangle an IPv6 address. This patch coalesces
   consecutive tc pedit actions into one single action so drivers can
   configure the IPv6 mangling in one go. Ethernet address fields now
   require one single action instead of two too.

This patch finds the header field from the 32-bit offset and mask. If
there is no matching header field, fall back to passing the original
list of mangle actions to the driver.

The following drivers have been updated accordingly to use this new
mangle action layout:

1) The cxgb4 driver does not need to split protocol field matching
   larger than one 32-bit words into multiple definitions. Instead one
   single definition per protocol field is enough. Checking for
   transport protocol ports is also simplified.

2) The mlx5 driver logic to disallow IPv4 ttl and IPv6 hoplimit fields
   becomes more simple too.

3) The nfp driver uses the nfp_fl_set_helper() function to configure the
   payload mangling. The memchr_inv() function is used to check for
   proper initialization of the value and mask. The driver has been
   updated to refer to the exact protocol header offsets too.

As a result, this patch reduces code complexity on the driver side at
the cost of adding code to the core to perform offset and length
adjustment; and to coalesce consecutive actions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: add header field definitions to calculate header field from offset
    and mask.

 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 162 ++++----------
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h   |  40 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  80 +++----
 drivers/net/ethernet/netronome/nfp/flower/action.c | 191 +++++++---------
 include/net/flow_offload.h                         |   7 +-
 net/sched/cls_api.c                                | 244 +++++++++++++++++++--
 6 files changed, 396 insertions(+), 328 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 5afc15a60199..ba1ced08e41c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -44,20 +44,12 @@
 #define STATS_CHECK_PERIOD (HZ / 2)
 
 static struct ch_tc_pedit_fields pedits[] = {
-	PEDIT_FIELDS(ETH_, DMAC_31_0, 4, dmac, 0),
-	PEDIT_FIELDS(ETH_, DMAC_47_32, 2, dmac, 4),
-	PEDIT_FIELDS(ETH_, SMAC_15_0, 2, smac, 0),
-	PEDIT_FIELDS(ETH_, SMAC_47_16, 4, smac, 2),
+	PEDIT_FIELDS(ETH_, DMAC, 6, dmac, 0),
+	PEDIT_FIELDS(ETH_, SMAC, 6, smac, 0),
 	PEDIT_FIELDS(IP4_, SRC, 4, nat_fip, 0),
 	PEDIT_FIELDS(IP4_, DST, 4, nat_lip, 0),
-	PEDIT_FIELDS(IP6_, SRC_31_0, 4, nat_fip, 0),
-	PEDIT_FIELDS(IP6_, SRC_63_32, 4, nat_fip, 4),
-	PEDIT_FIELDS(IP6_, SRC_95_64, 4, nat_fip, 8),
-	PEDIT_FIELDS(IP6_, SRC_127_96, 4, nat_fip, 12),
-	PEDIT_FIELDS(IP6_, DST_31_0, 4, nat_lip, 0),
-	PEDIT_FIELDS(IP6_, DST_63_32, 4, nat_lip, 4),
-	PEDIT_FIELDS(IP6_, DST_95_64, 4, nat_lip, 8),
-	PEDIT_FIELDS(IP6_, DST_127_96, 4, nat_lip, 12),
+	PEDIT_FIELDS(IP6_, SRC, 16, nat_fip, 0),
+	PEDIT_FIELDS(IP6_, DST, 16, nat_lip, 0),
 	PEDIT_FIELDS(TCP_, SPORT, 2, nat_fport, 0),
 	PEDIT_FIELDS(TCP_, DPORT, 2, nat_lport, 0),
 	PEDIT_FIELDS(UDP_, SPORT, 2, nat_fport, 0),
@@ -272,8 +264,8 @@ static int cxgb4_validate_flow_match(struct net_device *dev,
 	return 0;
 }
 
-static void offload_pedit(struct ch_filter_specification *fs, u32 val, u32 mask,
-			  u8 field)
+static void offload_pedit(struct ch_filter_specification *fs,
+			  struct flow_action_entry *act, u8 field)
 {
 	u32 offset = 0;
 	u8 size = 1;
@@ -286,92 +278,68 @@ static void offload_pedit(struct ch_filter_specification *fs, u32 val, u32 mask,
 			break;
 		}
 	}
-	memcpy((u8 *)fs + offset, &val, size);
+	memcpy((u8 *)fs + offset, act->mangle.val, size);
 }
 
-static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
-				u32 mask, u32 offset, u8 htype)
+static void process_pedit_field(struct ch_filter_specification *fs,
+				struct flow_action_entry *act)
 {
+	u32 offset = act->mangle.offset;
+	u8 htype = act->mangle.htype;
+
 	switch (htype) {
 	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
 		switch (offset) {
-		case PEDIT_ETH_DMAC_31_0:
+		case PEDIT_ETH_DMAC:
 			fs->newdmac = 1;
-			offload_pedit(fs, val, mask, ETH_DMAC_31_0);
-			break;
-		case PEDIT_ETH_DMAC_47_32_SMAC_15_0:
-			if (mask & PEDIT_ETH_DMAC_MASK)
-				offload_pedit(fs, val, mask, ETH_DMAC_47_32);
-			else
-				offload_pedit(fs, val >> 16, mask >> 16,
-					      ETH_SMAC_15_0);
+			offload_pedit(fs, act, ETH_DMAC);
 			break;
-		case PEDIT_ETH_SMAC_47_16:
+		case PEDIT_ETH_SMAC:
 			fs->newsmac = 1;
-			offload_pedit(fs, val, mask, ETH_SMAC_47_16);
+			offload_pedit(fs, act, ETH_SMAC);
+			break;
 		}
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
 		switch (offset) {
 		case PEDIT_IP4_SRC:
-			offload_pedit(fs, val, mask, IP4_SRC);
+			offload_pedit(fs, act, IP4_SRC);
 			break;
 		case PEDIT_IP4_DST:
-			offload_pedit(fs, val, mask, IP4_DST);
+			offload_pedit(fs, act, IP4_DST);
 		}
 		fs->nat_mode = NAT_MODE_ALL;
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
 		switch (offset) {
-		case PEDIT_IP6_SRC_31_0:
-			offload_pedit(fs, val, mask, IP6_SRC_31_0);
-			break;
-		case PEDIT_IP6_SRC_63_32:
-			offload_pedit(fs, val, mask, IP6_SRC_63_32);
-			break;
-		case PEDIT_IP6_SRC_95_64:
-			offload_pedit(fs, val, mask, IP6_SRC_95_64);
-			break;
-		case PEDIT_IP6_SRC_127_96:
-			offload_pedit(fs, val, mask, IP6_SRC_127_96);
-			break;
-		case PEDIT_IP6_DST_31_0:
-			offload_pedit(fs, val, mask, IP6_DST_31_0);
+		case PEDIT_IP6_SRC:
+			offload_pedit(fs, act, IP6_SRC);
 			break;
-		case PEDIT_IP6_DST_63_32:
-			offload_pedit(fs, val, mask, IP6_DST_63_32);
+		case PEDIT_IP6_DST:
+			offload_pedit(fs, act, IP6_DST);
 			break;
-		case PEDIT_IP6_DST_95_64:
-			offload_pedit(fs, val, mask, IP6_DST_95_64);
-			break;
-		case PEDIT_IP6_DST_127_96:
-			offload_pedit(fs, val, mask, IP6_DST_127_96);
 		}
 		fs->nat_mode = NAT_MODE_ALL;
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
 		switch (offset) {
-		case PEDIT_TCP_SPORT_DPORT:
-			if (mask & PEDIT_TCP_UDP_SPORT_MASK)
-				offload_pedit(fs, cpu_to_be32(val) >> 16,
-					      cpu_to_be32(mask) >> 16,
-					      TCP_SPORT);
-			else
-				offload_pedit(fs, cpu_to_be32(val),
-					      cpu_to_be32(mask), TCP_DPORT);
+		case PEDIT_TCP_SPORT:
+			offload_pedit(fs, act, TCP_SPORT);
+			break;
+		case PEDIT_TCP_DPORT:
+			offload_pedit(fs, act, TCP_DPORT);
+			break;
 		}
 		fs->nat_mode = NAT_MODE_ALL;
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
 		switch (offset) {
-		case PEDIT_UDP_SPORT_DPORT:
-			if (mask & PEDIT_TCP_UDP_SPORT_MASK)
-				offload_pedit(fs, cpu_to_be32(val) >> 16,
-					      cpu_to_be32(mask) >> 16,
-					      UDP_SPORT);
-			else
-				offload_pedit(fs, cpu_to_be32(val),
-					      cpu_to_be32(mask), UDP_DPORT);
+		case PEDIT_UDP_SPORT:
+			offload_pedit(fs, act, UDP_SPORT);
+			break;
+		case PEDIT_UDP_DPORT:
+			offload_pedit(fs, act, UDP_DPORT);
+			break;
 		}
 		fs->nat_mode = NAT_MODE_ALL;
 	}
@@ -424,17 +392,8 @@ static void cxgb4_process_flow_actions(struct net_device *in,
 			}
 			}
 			break;
-		case FLOW_ACTION_MANGLE: {
-			u32 mask, val, offset;
-			u8 htype;
-
-			htype = act->mangle.htype;
-			mask = act->mangle.mask;
-			val = act->mangle.val;
-			offset = act->mangle.offset;
-
-			process_pedit_field(fs, val, mask, offset, htype);
-			}
+		case FLOW_ACTION_MANGLE:
+			process_pedit_field(fs, act);
 			break;
 		default:
 			break;
@@ -442,35 +401,20 @@ static void cxgb4_process_flow_actions(struct net_device *in,
 	}
 }
 
-static bool valid_l4_mask(u32 mask)
-{
-	u16 hi, lo;
-
-	/* Either the upper 16-bits (SPORT) OR the lower
-	 * 16-bits (DPORT) can be set, but NOT BOTH.
-	 */
-	hi = (mask >> 16) & 0xFFFF;
-	lo = mask & 0xFFFF;
-
-	return hi && lo ? false : true;
-}
-
 static bool valid_pedit_action(struct net_device *dev,
 			       const struct flow_action_entry *act)
 {
-	u32 mask, offset;
+	u32 offset;
 	u8 htype;
 
 	htype = act->mangle.htype;
-	mask = act->mangle.mask;
 	offset = act->mangle.offset;
 
 	switch (htype) {
 	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
 		switch (offset) {
-		case PEDIT_ETH_DMAC_31_0:
-		case PEDIT_ETH_DMAC_47_32_SMAC_15_0:
-		case PEDIT_ETH_SMAC_47_16:
+		case PEDIT_ETH_DMAC:
+		case PEDIT_ETH_SMAC:
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -491,14 +435,8 @@ static bool valid_pedit_action(struct net_device *dev,
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
 		switch (offset) {
-		case PEDIT_IP6_SRC_31_0:
-		case PEDIT_IP6_SRC_63_32:
-		case PEDIT_IP6_SRC_95_64:
-		case PEDIT_IP6_SRC_127_96:
-		case PEDIT_IP6_DST_31_0:
-		case PEDIT_IP6_DST_63_32:
-		case PEDIT_IP6_DST_95_64:
-		case PEDIT_IP6_DST_127_96:
+		case PEDIT_IP6_SRC:
+		case PEDIT_IP6_DST:
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -508,12 +446,8 @@ static bool valid_pedit_action(struct net_device *dev,
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
 		switch (offset) {
-		case PEDIT_TCP_SPORT_DPORT:
-			if (!valid_l4_mask(mask)) {
-				netdev_err(dev, "%s: Unsupported mask for TCP L4 ports\n",
-					   __func__);
-				return false;
-			}
+		case PEDIT_TCP_SPORT:
+		case PEDIT_TCP_DPORT:
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -523,12 +457,8 @@ static bool valid_pedit_action(struct net_device *dev,
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
 		switch (offset) {
-		case PEDIT_UDP_SPORT_DPORT:
-			if (!valid_l4_mask(mask)) {
-				netdev_err(dev, "%s: Unsupported mask for UDP L4 ports\n",
-					   __func__);
-				return false;
-			}
+		case PEDIT_UDP_SPORT:
+		case PEDIT_UDP_DPORT:
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
index eb4c95248baf..03892755a18f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
@@ -55,23 +55,14 @@ struct ch_tc_flower_entry {
 };
 
 enum {
-	ETH_DMAC_31_0,	/* dmac bits 0.. 31 */
-	ETH_DMAC_47_32,	/* dmac bits 32..47 */
-	ETH_SMAC_15_0,	/* smac bits 0.. 15 */
-	ETH_SMAC_47_16,	/* smac bits 16..47 */
+	ETH_DMAC,	/* 48-bits dmac bits */
+	ETH_SMAC,	/* 48-bits smac bits */
 
 	IP4_SRC,	/* 32-bit IPv4 src  */
 	IP4_DST,	/* 32-bit IPv4 dst  */
 
-	IP6_SRC_31_0,	/* src bits 0..  31 */
-	IP6_SRC_63_32,	/* src bits 63.. 32 */
-	IP6_SRC_95_64,	/* src bits 95.. 64 */
-	IP6_SRC_127_96,	/* src bits 127..96 */
-
-	IP6_DST_31_0,	/* dst bits 0..  31 */
-	IP6_DST_63_32,	/* dst bits 63.. 32 */
-	IP6_DST_95_64,	/* dst bits 95.. 64 */
-	IP6_DST_127_96,	/* dst bits 127..96 */
+	IP6_SRC,	/* 128-bit IPv6 src */
+	IP6_DST,	/* 128-bit IPv6 dst */
 
 	TCP_SPORT,	/* 16-bit TCP sport */
 	TCP_DPORT,	/* 16-bit TCP dport */
@@ -90,23 +81,16 @@ struct ch_tc_pedit_fields {
 	{ type## field, size, \
 		offsetof(struct ch_filter_specification, fs_field) + (offset) }
 
-#define PEDIT_ETH_DMAC_MASK		0xffff
-#define PEDIT_TCP_UDP_SPORT_MASK	0xffff
-#define PEDIT_ETH_DMAC_31_0		0x0
-#define PEDIT_ETH_DMAC_47_32_SMAC_15_0	0x4
-#define PEDIT_ETH_SMAC_47_16		0x8
+#define PEDIT_ETH_DMAC			0x0
+#define PEDIT_ETH_SMAC			0x6
+#define PEDIT_IP6_SRC			0x8
+#define PEDIT_IP6_DST			0x18
 #define PEDIT_IP4_SRC			0xC
 #define PEDIT_IP4_DST			0x10
-#define PEDIT_IP6_SRC_31_0		0x8
-#define PEDIT_IP6_SRC_63_32		0xC
-#define PEDIT_IP6_SRC_95_64		0x10
-#define PEDIT_IP6_SRC_127_96		0x14
-#define PEDIT_IP6_DST_31_0		0x18
-#define PEDIT_IP6_DST_63_32		0x1C
-#define PEDIT_IP6_DST_95_64		0x20
-#define PEDIT_IP6_DST_127_96		0x24
-#define PEDIT_TCP_SPORT_DPORT		0x0
-#define PEDIT_UDP_SPORT_DPORT		0x0
+#define PEDIT_TCP_SPORT			0x0
+#define PEDIT_TCP_DPORT			0x2
+#define PEDIT_UDP_SPORT			0x0
+#define PEDIT_UDP_DPORT			0x2
 
 int cxgb4_tc_flower_replace(struct net_device *dev,
 			    struct flow_cls_offload *cls);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index be25b1eae9c3..895c669746f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2216,19 +2216,24 @@ static int pedit_header_offsets[] = {
 
 #define pedit_header(_ph, _htype) ((void *)(_ph) + pedit_header_offsets[_htype])
 
-static int set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
+static int set_pedit_val(u8 hdr_type, const struct flow_action_entry *act,
 			 struct pedit_headers_action *hdrs)
 {
-	u32 *curr_pmask, *curr_pval;
+	u32 offset = act->mangle.offset;
+	u8 *curr_pmask, *curr_pval;
+	int i;
 
-	curr_pmask = (u32 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
-	curr_pval  = (u32 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
+	curr_pmask = (u8 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
+	curr_pval  = (u8 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
 
-	if (*curr_pmask & mask)  /* disallow acting twice on the same location */
-		goto out_err;
+	for (i = 0; i < act->mangle.len; i++) {
+		/* disallow acting twice on the same location */
+		if (curr_pmask[i] & act->mangle.mask[i])
+			goto out_err;
 
-	*curr_pmask |= mask;
-	*curr_pval  |= val;
+		curr_pmask[i] |= act->mangle.mask[i];
+		curr_pval[i] |= act->mangle.val[i];
+	}
 
 	return 0;
 
@@ -2502,7 +2507,6 @@ static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 {
 	u8 cmd = (act->id == FLOW_ACTION_MANGLE) ? 0 : 1;
 	int err = -EOPNOTSUPP;
-	u32 mask, val, offset;
 	u8 htype;
 
 	htype = act->mangle.htype;
@@ -2519,11 +2523,7 @@ static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 		goto out_err;
 	}
 
-	mask = act->mangle.mask;
-	val = act->mangle.val;
-	offset = act->mangle.offset;
-
-	err = set_pedit_val(htype, mask, val, offset, &hdrs[cmd]);
+	err = set_pedit_val(htype, act, &hdrs[cmd]);
 	if (err)
 		goto out_err;
 
@@ -2604,49 +2604,19 @@ static bool csum_offload_supported(struct mlx5e_priv *priv,
 	return true;
 }
 
-struct ip_ttl_word {
-	__u8	ttl;
-	__u8	protocol;
-	__sum16	check;
-};
-
-struct ipv6_hoplimit_word {
-	__be16	payload_len;
-	__u8	nexthdr;
-	__u8	hop_limit;
-};
-
 static bool is_action_keys_supported(const struct flow_action_entry *act)
 {
-	u32 mask, offset;
-	u8 htype;
+	u32 offset = act->mangle.offset;
+	u8 htype = act->mangle.htype;
 
-	htype = act->mangle.htype;
-	offset = act->mangle.offset;
-	mask = act->mangle.mask;
-	/* For IPv4 & IPv6 header check 4 byte word,
-	 * to determine that modified fields
-	 * are NOT ttl & hop_limit only.
-	 */
 	if (htype == FLOW_ACT_MANGLE_HDR_TYPE_IP4) {
-		struct ip_ttl_word *ttl_word =
-			(struct ip_ttl_word *)&mask;
-
-		if (offset != offsetof(struct iphdr, ttl) ||
-		    ttl_word->protocol ||
-		    ttl_word->check) {
+		if (offset != offsetof(struct iphdr, ttl))
 			return true;
-		}
 	} else if (htype == FLOW_ACT_MANGLE_HDR_TYPE_IP6) {
-		struct ipv6_hoplimit_word *hoplimit_word =
-			(struct ipv6_hoplimit_word *)&mask;
-
-		if (offset != offsetof(struct ipv6hdr, payload_len) ||
-		    hoplimit_word->payload_len ||
-		    hoplimit_word->nexthdr) {
+		if (offset != offsetof(struct ipv6hdr, hop_limit))
 			return true;
-		}
 	}
+
 	return false;
 }
 
@@ -2741,19 +2711,21 @@ static int add_vlan_rewrite_action(struct mlx5e_priv *priv, int namespace,
 				   struct pedit_headers_action *hdrs,
 				   u32 *action, struct netlink_ext_ack *extack)
 {
-	u16 mask16 = VLAN_VID_MASK;
-	u16 val16 = act->vlan.vid & VLAN_VID_MASK;
-	const struct flow_action_entry pedit_act = {
+	__be16 mask16 = htons(VLAN_VID_MASK);
+	__be16 val16 = htons(act->vlan.vid & VLAN_VID_MASK);
+	struct flow_action_entry pedit_act = {
 		.id = FLOW_ACTION_MANGLE,
 		.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH,
 		.mangle.offset = offsetof(struct vlan_ethhdr, h_vlan_TCI),
-		.mangle.mask = (u32)be16_to_cpu(*(__be16 *)&mask16),
-		.mangle.val = (u32)be16_to_cpu(*(__be16 *)&val16),
+		.mangle.len = 2,
 	};
 	u8 match_prio_mask, match_prio_val;
 	void *headers_c, *headers_v;
 	int err;
 
+	memcpy(pedit_act.mangle.mask, &mask16, sizeof(__be16));
+	memcpy(pedit_act.mangle.val, &val16, sizeof(__be16));
+
 	headers_c = get_match_headers_criteria(*action, &parse_attr->spec);
 	headers_v = get_match_headers_value(*action, &parse_attr->spec);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 07db0a7ba0d5..289f2eebd885 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -472,33 +472,38 @@ nfp_fl_set_ipv4_tun(struct nfp_app *app, struct nfp_fl_set_ipv4_tun *set_tun,
 	return 0;
 }
 
-static void nfp_fl_set_helper32(u32 value, u32 mask, u8 *p_exact, u8 *p_mask)
+static void nfp_fl_set_helper(const u8 *value, const u8 *mask,
+			      u8 *p_exact, u8 *p_mask, int len)
 {
-	u32 oldvalue = get_unaligned((u32 *)p_exact);
-	u32 oldmask = get_unaligned((u32 *)p_mask);
+	int i;
 
-	value |= oldvalue & ~mask;
-
-	put_unaligned(oldmask | mask, (u32 *)p_mask);
-	put_unaligned(value, (u32 *)p_exact);
+	for (i = 0; i < len; i++) {
+		p_exact[i] = (p_exact[i] & ~mask[i]) | value[i];
+		p_mask[i] |= mask[i];
+	}
 }
 
 static int
 nfp_fl_set_eth(const struct flow_action_entry *act, u32 off,
 	       struct nfp_fl_set_eth *set_eth, struct netlink_ext_ack *extack)
 {
-	u32 exact, mask;
+	int i;
 
-	if (off + 4 > ETH_ALEN * 2) {
+	switch (off) {
+	case offsetof(struct ethhdr, h_dest):
+		i = 0;
+		break;
+	case offsetof(struct ethhdr, h_source):
+		i = ETH_ALEN;
+		break;
+	default:
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit ethernet action");
 		return -EOPNOTSUPP;
 	}
 
-	mask = act->mangle.mask;
-	exact = act->mangle.val;
-
-	nfp_fl_set_helper32(exact, mask, &set_eth->eth_addr_val[off],
-			    &set_eth->eth_addr_mask[off]);
+	nfp_fl_set_helper(act->mangle.val, act->mangle.mask,
+			  &set_eth->eth_addr_val[i],
+			  &set_eth->eth_addr_mask[i], act->mangle.len);
 
 	set_eth->reserved = cpu_to_be16(0);
 	set_eth->head.jump_id = NFP_FL_ACTION_OPCODE_SET_ETHERNET;
@@ -519,63 +524,40 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 	       struct nfp_fl_set_ip4_ttl_tos *set_ip_ttl_tos,
 	       struct netlink_ext_ack *extack)
 {
-	struct ipv4_ttl_word *ttl_word_mask;
-	struct ipv4_ttl_word *ttl_word;
-	struct iphdr *tos_word_mask;
-	struct iphdr *tos_word;
-	__be32 exact, mask;
-
-	/* We are expecting tcf_pedit to return a big endian value */
-	mask = (__force __be32)act->mangle.mask;
-	exact = (__force __be32)act->mangle.val;
-
 	switch (off) {
 	case offsetof(struct iphdr, daddr):
-		set_ip_addr->ipv4_dst_mask |= mask;
-		set_ip_addr->ipv4_dst &= ~mask;
-		set_ip_addr->ipv4_dst |= exact;
+		nfp_fl_set_helper(act->mangle.val, act->mangle.mask,
+				  (u8 *)&set_ip_addr->ipv4_dst,
+				  (u8 *)&set_ip_addr->ipv4_dst_mask,
+				  act->mangle.len);
 		set_ip_addr->head.jump_id = NFP_FL_ACTION_OPCODE_SET_IPV4_ADDRS;
 		set_ip_addr->head.len_lw = sizeof(*set_ip_addr) >>
 					   NFP_FL_LW_SIZ;
 		break;
 	case offsetof(struct iphdr, saddr):
-		set_ip_addr->ipv4_src_mask |= mask;
-		set_ip_addr->ipv4_src &= ~mask;
-		set_ip_addr->ipv4_src |= exact;
+		nfp_fl_set_helper(act->mangle.val, act->mangle.mask,
+				  (u8 *)&set_ip_addr->ipv4_src,
+				  (u8 *)&set_ip_addr->ipv4_src_mask,
+				  act->mangle.len);
 		set_ip_addr->head.jump_id = NFP_FL_ACTION_OPCODE_SET_IPV4_ADDRS;
 		set_ip_addr->head.len_lw = sizeof(*set_ip_addr) >>
 					   NFP_FL_LW_SIZ;
 		break;
 	case offsetof(struct iphdr, ttl):
-		ttl_word_mask = (struct ipv4_ttl_word *)&mask;
-		ttl_word = (struct ipv4_ttl_word *)&exact;
-
-		if (ttl_word_mask->protocol || ttl_word_mask->check) {
-			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv4 ttl action");
-			return -EOPNOTSUPP;
-		}
-
-		set_ip_ttl_tos->ipv4_ttl_mask |= ttl_word_mask->ttl;
-		set_ip_ttl_tos->ipv4_ttl &= ~ttl_word_mask->ttl;
-		set_ip_ttl_tos->ipv4_ttl |= ttl_word->ttl & ttl_word_mask->ttl;
+		nfp_fl_set_helper(act->mangle.val, act->mangle.mask,
+				  (u8 *)&set_ip_ttl_tos->ipv4_ttl,
+				  (u8 *)&set_ip_ttl_tos->ipv4_ttl_mask,
+				  act->mangle.len);
 		set_ip_ttl_tos->head.jump_id =
 			NFP_FL_ACTION_OPCODE_SET_IPV4_TTL_TOS;
 		set_ip_ttl_tos->head.len_lw = sizeof(*set_ip_ttl_tos) >>
 					      NFP_FL_LW_SIZ;
 		break;
-	case round_down(offsetof(struct iphdr, tos), 4):
-		tos_word_mask = (struct iphdr *)&mask;
-		tos_word = (struct iphdr *)&exact;
-
-		if (tos_word_mask->version || tos_word_mask->ihl ||
-		    tos_word_mask->tot_len) {
-			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv4 tos action");
-			return -EOPNOTSUPP;
-		}
-
-		set_ip_ttl_tos->ipv4_tos_mask |= tos_word_mask->tos;
-		set_ip_ttl_tos->ipv4_tos &= ~tos_word_mask->tos;
-		set_ip_ttl_tos->ipv4_tos |= tos_word->tos & tos_word_mask->tos;
+	case offsetof(struct iphdr, tos):
+		nfp_fl_set_helper(act->mangle.val, act->mangle.mask,
+				  (u8 *)&set_ip_ttl_tos->ipv4_tos,
+				  (u8 *)&set_ip_ttl_tos->ipv4_tos_mask,
+				  act->mangle.len);
 		set_ip_ttl_tos->head.jump_id =
 			NFP_FL_ACTION_OPCODE_SET_IPV4_TTL_TOS;
 		set_ip_ttl_tos->head.len_lw = sizeof(*set_ip_ttl_tos) >>
@@ -590,12 +572,17 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 }
 
 static void
-nfp_fl_set_ip6_helper(int opcode_tag, u8 word, __be32 exact, __be32 mask,
-		      struct nfp_fl_set_ipv6_addr *ip6)
+nfp_fl_set_ip6_helper(int opcode_tag, const struct flow_action_entry *act,
+		      struct nfp_fl_set_ipv6_addr *ip6,
+		      struct netlink_ext_ack *extack)
 {
-	ip6->ipv6[word].mask |= mask;
-	ip6->ipv6[word].exact &= ~mask;
-	ip6->ipv6[word].exact |= exact;
+	int i, j;
+
+	for (i = 0, j = 0; i < sizeof(struct in6_addr); i++, j += sizeof(u32)) {
+		nfp_fl_set_helper(&act->mangle.val[j], &act->mangle.mask[j],
+				  (u8 *)&ip6->ipv6[i].exact,
+				  (u8 *)&ip6->ipv6[i].mask, sizeof(u32));
+	}
 
 	ip6->reserved = cpu_to_be16(0);
 	ip6->head.jump_id = opcode_tag;
@@ -609,39 +596,34 @@ struct ipv6_hop_limit_word {
 };
 
 static int
-nfp_fl_set_ip6_hop_limit_flow_label(u32 off, __be32 exact, __be32 mask,
+nfp_fl_set_ip6_hop_limit_flow_label(u32 off,
+				    const struct flow_action_entry *act,
 				    struct nfp_fl_set_ipv6_tc_hl_fl *ip_hl_fl,
 				    struct netlink_ext_ack *extack)
 {
-	struct ipv6_hop_limit_word *fl_hl_mask;
-	struct ipv6_hop_limit_word *fl_hl;
-
 	switch (off) {
-	case offsetof(struct ipv6hdr, payload_len):
-		fl_hl_mask = (struct ipv6_hop_limit_word *)&mask;
-		fl_hl = (struct ipv6_hop_limit_word *)&exact;
-
-		if (fl_hl_mask->nexthdr || fl_hl_mask->payload_len) {
-			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 hop limit action");
-			return -EOPNOTSUPP;
-		}
-
-		ip_hl_fl->ipv6_hop_limit_mask |= fl_hl_mask->hop_limit;
-		ip_hl_fl->ipv6_hop_limit &= ~fl_hl_mask->hop_limit;
-		ip_hl_fl->ipv6_hop_limit |= fl_hl->hop_limit &
-					    fl_hl_mask->hop_limit;
+	case offsetof(struct ipv6hdr, hop_limit):
+		nfp_fl_set_helper(act->mangle.val, act->mangle.mask,
+				  &ip_hl_fl->ipv6_hop_limit,
+				  &ip_hl_fl->ipv6_hop_limit_mask,
+				  act->mangle.len);
 		break;
-	case round_down(offsetof(struct ipv6hdr, flow_lbl), 4):
-		if (mask & ~IPV6_FLOW_LABEL_MASK ||
-		    exact & ~IPV6_FLOW_LABEL_MASK) {
+	case 1: /* offsetof(struct ipv6hdr, flow_lbl) */
+		/* The initial 4-bits are part of the traffic class field. */
+		if (act->mangle.val[0] & 0xf0 ||
+		    act->mangle.mask[0] & 0xf0) {
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 flow label action");
 			return -EOPNOTSUPP;
 		}
 
-		ip_hl_fl->ipv6_label_mask |= mask;
-		ip_hl_fl->ipv6_label &= ~mask;
-		ip_hl_fl->ipv6_label |= exact;
+		nfp_fl_set_helper(act->mangle.val, act->mangle.mask,
+				  (u8 *)&ip_hl_fl->ipv6_label,
+				  (u8 *)&ip_hl_fl->ipv6_label_mask,
+				  act->mangle.len);
 		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 action");
+		return -EOPNOTSUPP;
 	}
 
 	ip_hl_fl->head.jump_id = NFP_FL_ACTION_OPCODE_SET_IPV6_TC_HL_FL;
@@ -657,26 +639,17 @@ nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
 	       struct nfp_fl_set_ipv6_tc_hl_fl *ip_hl_fl,
 	       struct netlink_ext_ack *extack)
 {
-	__be32 exact, mask;
 	int err = 0;
-	u8 word;
-
-	/* We are expecting tcf_pedit to return a big endian value */
-	mask = (__force __be32)act->mangle.mask;
-	exact = (__force __be32)act->mangle.val;
 
 	if (off < offsetof(struct ipv6hdr, saddr)) {
-		err = nfp_fl_set_ip6_hop_limit_flow_label(off, exact, mask,
-							  ip_hl_fl, extack);
-	} else if (off < offsetof(struct ipv6hdr, daddr)) {
-		word = (off - offsetof(struct ipv6hdr, saddr)) / sizeof(exact);
-		nfp_fl_set_ip6_helper(NFP_FL_ACTION_OPCODE_SET_IPV6_SRC, word,
-				      exact, mask, ip_src);
-	} else if (off < offsetof(struct ipv6hdr, daddr) +
-		       sizeof(struct in6_addr)) {
-		word = (off - offsetof(struct ipv6hdr, daddr)) / sizeof(exact);
-		nfp_fl_set_ip6_helper(NFP_FL_ACTION_OPCODE_SET_IPV6_DST, word,
-				      exact, mask, ip_dst);
+		err = nfp_fl_set_ip6_hop_limit_flow_label(off, act, ip_hl_fl,
+							  extack);
+	} else if (off == offsetof(struct ipv6hdr, saddr)) {
+		nfp_fl_set_ip6_helper(NFP_FL_ACTION_OPCODE_SET_IPV6_SRC,
+				      act, ip_src, extack);
+	} else if (off == offsetof(struct ipv6hdr, daddr)) {
+		nfp_fl_set_ip6_helper(NFP_FL_ACTION_OPCODE_SET_IPV6_DST,
+				      act, ip_dst, extack);
 	} else {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pedit on unsupported section of IPv6 header");
 		return -EOPNOTSUPP;
@@ -690,18 +663,24 @@ nfp_fl_set_tport(const struct flow_action_entry *act, u32 off,
 		 struct nfp_fl_set_tport *set_tport, int opcode,
 		 struct netlink_ext_ack *extack)
 {
-	u32 exact, mask;
+	int i;
 
-	if (off) {
+	switch (off) {
+	case offsetof(struct tcphdr, source):
+		i = 0;
+		break;
+	case offsetof(struct tcphdr, dest):
+		i = sizeof(u16);
+		break;
+	default:
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pedit on unsupported section of L4 header");
 		return -EOPNOTSUPP;
 	}
 
-	mask = act->mangle.mask;
-	exact = act->mangle.val;
-
-	nfp_fl_set_helper32(exact, mask, set_tport->tp_port_val,
-			    set_tport->tp_port_mask);
+	nfp_fl_set_helper(act->mangle.val, act->mangle.mask,
+			  &set_tport->tp_port_val[i],
+			  &set_tport->tp_port_mask[i],
+			  act->mangle.len);
 
 	set_tport->reserved = cpu_to_be16(0);
 	set_tport->head.jump_id = opcode;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 86c567f531f3..78a462d4bfbb 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -154,6 +154,8 @@ enum flow_action_mangle_base {
 	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 };
 
+#define FLOW_ACTION_MANGLE_MAXLEN	16
+
 typedef void (*action_destr)(void *priv);
 
 struct flow_action_entry {
@@ -171,8 +173,9 @@ struct flow_action_entry {
 		struct {				/* FLOW_ACTION_PACKET_EDIT */
 			enum flow_action_mangle_base htype;
 			u32		offset;
-			u32		mask;
-			u32		val;
+			u8		mask[FLOW_ACTION_MANGLE_MAXLEN];
+			u8		val[FLOW_ACTION_MANGLE_MAXLEN];
+			u8		len;
 		} mangle;
 		struct ip_tunnel_info	*tunnel;	/* FLOW_ACTION_TUNNEL_ENCAP */
 		u32			csum_flags;	/* FLOW_ACTION_CSUM */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2656203eaaf1..1898ce3ce5ec 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3329,11 +3329,227 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
 #endif
 }
 
+static int flow_action_mangle_type(enum pedit_cmd cmd)
+{
+	switch (cmd) {
+	case TCA_PEDIT_KEY_EX_CMD_SET:
+		return FLOW_ACTION_MANGLE;
+	case TCA_PEDIT_KEY_EX_CMD_ADD:
+		return FLOW_ACTION_ADD;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+struct tc_proto_hdr_field {
+	uint8_t		offset;
+	int8_t		len;
+};
+
+#define TC_PROTO_HDR_FIELD_END	{},
+
+static struct tc_proto_hdr_field tc_proto_ether_hdr[] = {
+	{ .offset = offsetof(struct ethhdr, h_dest),	.len = ETH_ALEN, },
+	{ .offset = offsetof(struct ethhdr, h_source),	.len = ETH_ALEN, },
+	{ .offset = offsetof(struct ethhdr, h_proto),	.len = 2, },
+	TC_PROTO_HDR_FIELD_END
+};
+
+static struct tc_proto_hdr_field tc_proto_ip_hdr[] = {
+	{ .offset = 0, /* version, ihl */		.len = 1, },
+	{ .offset = offsetof(struct iphdr, tos),	.len = 1, },
+	{ .offset = offsetof(struct iphdr, tot_len),	.len = 2, },
+	{ .offset = offsetof(struct iphdr, id),		.len = 2, },
+	{ .offset = offsetof(struct iphdr, frag_off),	.len = 2, },
+	{ .offset = offsetof(struct iphdr, ttl),	.len = 1, },
+	{ .offset = offsetof(struct iphdr, protocol),	.len = 1, },
+	{ .offset = offsetof(struct iphdr, check),	.len = 2, },
+	{ .offset = offsetof(struct iphdr, saddr),	.len = 4, },
+	{ .offset = offsetof(struct iphdr, daddr),	.len = 4, },
+	TC_PROTO_HDR_FIELD_END
+};
+
+static struct tc_proto_hdr_field tc_proto_ipv6_hdr[] = {
+	{ .offset = 0, /* version, priority */		.len = 1, },
+	{ .offset = offsetof(struct ipv6hdr, flow_lbl),	.len = 3, },
+	{ .offset = offsetof(struct ipv6hdr, payload_len), .len = 2 },
+	{ .offset = offsetof(struct ipv6hdr, nexthdr),	.len = 1, },
+	{ .offset = offsetof(struct ipv6hdr, hop_limit), .len = 1, },
+	{ .offset = offsetof(struct ipv6hdr, saddr),	.len = 16, },
+	{ .offset = offsetof(struct ipv6hdr, daddr),	.len = 16, },
+	TC_PROTO_HDR_FIELD_END
+};
+
+static struct tc_proto_hdr_field tc_proto_tcp_hdr[] = {
+	{ .offset = offsetof(struct tcphdr, source),	.len = 2, },
+	{ .offset = offsetof(struct tcphdr, dest),	.len = 2, },
+	{ .offset = offsetof(struct tcphdr, seq),	.len = 4, },
+	{ .offset = offsetof(struct tcphdr, ack_seq),	.len = 4, },
+	{ .offset = 12 /* doff + flags */,		.len = 2, },
+	{ .offset = offsetof(struct tcphdr, window),	.len = 2, },
+	{ .offset = offsetof(struct tcphdr, check),	.len = 2, },
+	{ .offset = offsetof(struct tcphdr, urg_ptr),	.len = 2, },
+	TC_PROTO_HDR_FIELD_END
+};
+
+struct tc_proto_hdr_field tc_proto_udp_hdr[] = {
+	{ .offset = offsetof(struct udphdr, source),    .len = 2, },
+	{ .offset = offsetof(struct udphdr, dest),      .len = 2, },
+	{ .offset = offsetof(struct udphdr, len),       .len = 2, },
+	{ .offset = offsetof(struct udphdr, check),     .len = 2, },
+	TC_PROTO_HDR_FIELD_END
+};
+
+static const struct tc_proto_hdr_field *tc_proto_hdr[] = {
+	[FLOW_ACT_MANGLE_HDR_TYPE_ETH]	= tc_proto_ether_hdr,
+	[FLOW_ACT_MANGLE_HDR_TYPE_IP4]	= tc_proto_ip_hdr,
+	[FLOW_ACT_MANGLE_HDR_TYPE_IP6]	= tc_proto_ipv6_hdr,
+	[FLOW_ACT_MANGLE_HDR_TYPE_TCP]	= tc_proto_tcp_hdr,
+	[FLOW_ACT_MANGLE_HDR_TYPE_UDP]	= tc_proto_udp_hdr,
+};
+
+static const struct tc_proto_hdr_field *
+tc_proto_hdr_field_find(u8 htype, u32 offset, u32 len)
+{
+	const struct tc_proto_hdr_field *fields, *field;
+
+	fields = tc_proto_hdr[htype];
+	for (field = &fields[0]; field->len > 0; field++) {
+		if (offset >= field->offset &&
+		    offset + len <= field->offset + field->len)
+			return field;
+	}
+	return NULL;
+}
+
+struct flow_action_mangle_ctx {
+	u8	cmd;
+	u8	offset;
+	u8	htype;
+	u8	len;
+	u8	val[FLOW_ACTION_MANGLE_MAXLEN];
+	u8	mask[FLOW_ACTION_MANGLE_MAXLEN];
+	u32	first_word;
+	u32	last_word;
+};
+
+static bool flow_action_mangle_entry(struct flow_action_entry *entry,
+				     const struct flow_action_mangle_ctx *ctx)
+{
+	const struct tc_proto_hdr_field *field;
+	u32 delta, offset, len;
+
+	/* Estimate field offset. */
+	delta = sizeof(u32) - (fls(ctx->first_word) / BITS_PER_BYTE);
+	offset = ctx->offset + delta;
+
+	/* Estimate field length. */
+	len = ctx->len;
+	len -= ((ffs(ctx->last_word) / BITS_PER_BYTE) + delta);
+
+	/* Find exact field matching. */
+	field = tc_proto_hdr_field_find(ctx->htype, offset, len);
+	if (!field || field->len > ctx->len)
+		return false;
+
+	entry->id = ctx->cmd;
+	entry->mangle.htype = ctx->htype;
+	entry->mangle.offset = field->offset;
+	entry->mangle.len = field->len;
+
+	delta = field->offset - ctx->offset;
+	memcpy(entry->mangle.val, &ctx->val[delta], entry->mangle.len);
+	memcpy(entry->mangle.mask, &ctx->mask[delta], entry->mangle.len);
+
+	return true;
+}
+
+static void flow_action_mangle_ctx_update(struct flow_action_mangle_ctx *ctx,
+					  const struct tc_action *act, int k)
+{
+	u32 val, mask;
+
+	val = tcf_pedit_val(act, k);
+	mask = ~tcf_pedit_mask(act, k);
+
+	memcpy(&ctx->val[ctx->len], &val, sizeof(u32));
+	memcpy(&ctx->mask[ctx->len], &mask, sizeof(u32));
+	ctx->len += sizeof(u32);
+}
+
+static bool flow_action_mangle_ctx_init(struct flow_action_mangle_ctx *ctx,
+					const struct tc_action *act, int k)
+{
+	int cmd, htype;
+
+	cmd = flow_action_mangle_type(tcf_pedit_cmd(act, k));
+	if (cmd < 0)
+		return false;
+
+	htype = tcf_pedit_htype(act, k);
+	if (htype == FLOW_ACT_MANGLE_UNSPEC)
+		return false;
+
+	ctx->cmd = cmd;
+	ctx->offset = tcf_pedit_offset(act, k);
+	ctx->htype = htype;
+	ctx->len = 0;
+
+	ctx->first_word = ntohl(~tcf_pedit_mask(act, k));
+	ctx->last_word = ctx->first_word;
+
+	flow_action_mangle_ctx_update(ctx, act, k);
+
+	return true;
+}
+
+static int flow_action_mangle(struct flow_action *flow_action,
+			      const struct tc_action *act, int j)
+{
+	struct flow_action_entry *entry = &flow_action->entries[j];
+	struct flow_action_mangle_ctx ctx;
+	int k;
+
+	if (!flow_action_mangle_ctx_init(&ctx, act, 0))
+		return -1;
+
+	/* Special case: one single 32-bits word. */
+	if (tcf_pedit_nkeys(act) == 1)
+		return flow_action_mangle_entry(entry, &ctx) ? j : -1;
+
+	for (k = 1; k < tcf_pedit_nkeys(act); k++) {
+		/* Offset is contiguous, type and base are the same, collect
+		 * 32-bit unsigned int words.
+		 */
+		if (ctx.len < FLOW_ACTION_MANGLE_MAXLEN &&
+		    ctx.offset + ctx.len == tcf_pedit_offset(act, k) &&
+		    ctx.htype == tcf_pedit_htype(act, k) &&
+		    ctx.cmd == flow_action_mangle_type(tcf_pedit_cmd(act, k))) {
+			flow_action_mangle_ctx_update(&ctx, act, k);
+			continue;
+		}
+
+		ctx.last_word = ntohl(~tcf_pedit_mask(act, k - 1));
+		if (!flow_action_mangle_entry(entry, &ctx))
+			return -1;
+
+		if (!flow_action_mangle_ctx_init(&ctx, act, k))
+			return -1;
+
+		entry = &flow_action->entries[++j];
+	}
+
+	ctx.last_word = ntohl(~tcf_pedit_mask(act, k - 1));
+
+	return flow_action_mangle_entry(entry, &ctx) ? j : -1;
+}
+
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts, bool rtnl_held)
 {
 	const struct tc_action *act;
-	int i, j, k, err = 0;
+	int i, j, err = 0;
 
 	if (!exts)
 		return 0;
@@ -3396,25 +3612,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		} else if (is_tcf_tunnel_release(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_DECAP;
 		} else if (is_tcf_pedit(act)) {
-			for (k = 0; k < tcf_pedit_nkeys(act); k++) {
-				switch (tcf_pedit_cmd(act, k)) {
-				case TCA_PEDIT_KEY_EX_CMD_SET:
-					entry->id = FLOW_ACTION_MANGLE;
-					break;
-				case TCA_PEDIT_KEY_EX_CMD_ADD:
-					entry->id = FLOW_ACTION_ADD;
-					break;
-				default:
-					err = -EOPNOTSUPP;
-					goto err_out;
-				}
-				entry->mangle.htype = tcf_pedit_htype(act, k);
-				entry->mangle.mask = ~tcf_pedit_mask(act, k);
-				entry->mangle.val = tcf_pedit_val(act, k) &
-							entry->mangle.mask;
-				entry->mangle.offset = tcf_pedit_offset(act, k);
-				entry = &flow_action->entries[++j];
-			}
+			j = flow_action_mangle(flow_action, act, j);
+			if (j < 0)
+				goto err_out;
 		} else if (is_tcf_csum(act)) {
 			entry->id = FLOW_ACTION_CSUM;
 			entry->csum_flags = tcf_csum_update_flags(act);
@@ -3468,9 +3668,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			goto err_out;
 		}
 
-		if (!is_tcf_pedit(act))
-			j++;
+		j++;
 	}
+	flow_action->num_entries = j;
 
 err_out:
 	if (!rtnl_held)
-- 
2.11.0

