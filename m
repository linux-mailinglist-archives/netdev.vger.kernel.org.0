Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107ADEAA09
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 06:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfJaFIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 01:08:19 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44741 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfJaFIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 01:08:19 -0400
Received: by mail-pl1-f193.google.com with SMTP id q16so2114668pll.11
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 22:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2iru6XoI4xeODM9JAxXP8TVhLmjwSqP5rj0kOsFNUMA=;
        b=U7Ek95znYhFN7+NM8PO6KwJU0uBBsfB0TfJ8zd/cjnLHdPrAnaWCpv5u15NLbQwI8c
         WtV+ImCQZCHZOkkW4d156/d1hVvWtuHhI9tHius0fNP1XMfRX603ybeIx4dNOVktWXEn
         ZVl6XBZNyW3yqAHSiyKWCr4iSTmud+zu3CFu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2iru6XoI4xeODM9JAxXP8TVhLmjwSqP5rj0kOsFNUMA=;
        b=swL27FxqpzDYridtIbMPUIpr4hvDazK3Qz5TcfCZM/g47wJ55ZU8Q0unRBS7a+EQAN
         m8VUfnQN28Tqn7qIDHw8z3pCGEQ1YcscUmQ1mIeaNucqlaxaqXKTSxAci/7JB/bl4HLN
         s3GQKbcVT7Bw72DvAIzffnJbdFLPexQgQ4yzLtTmHMADq0RXUntsKS80SVkm2Vm5k0u9
         Z52CnFDEDR/p5R2nCNXYeBPgbF7qGiVdC02NTlNY6CyG+RyhYC05sotzwjdY4phprSxp
         UaTfoz9E7M6wEOIWjjjjSJyGCBe2ZeyagCDzIDoYggqQr2bK2YutMu3pvIWiwMGP3qWL
         td6w==
X-Gm-Message-State: APjAAAWZ6J2g0JXm2ivJtuBz0/M5x9kDw2Lnfz0rhyQ2gkmpyX1aCYu1
        AeyyAgYKStbRHi+rNoT/ulB2wQ==
X-Google-Smtp-Source: APXvYqwGRPs+zCJPsid5cAtgMiAJ8p6E0kSdb4iRiPzI5uZE3ye7Oe8XZ1VImE9cRwKgZDhNaDMJ8A==
X-Received: by 2002:a17:902:9305:: with SMTP id bc5mr4238126plb.238.1572498497314;
        Wed, 30 Oct 2019 22:08:17 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a8sm1690899pff.5.2019.10.30.22.08.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 22:08:16 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>
Subject: [PATCH net-next v2 3/7] bnxt_en: Add support for NAT(L3/L4 rewrite)
Date:   Thu, 31 Oct 2019 01:07:47 -0400
Message-Id: <1572498471-31550-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
References: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

Provides support for modifying L3/L4 Header parameters to support NAT.
Sets the appropriate fields/bits in cfa_flow_alloc cmd.

Sample cmd for offloading an IPv4 flow with SNAT:

ovs-ofctl add-flow ovsbr0 "ip,nw_src=192.168.201.44 \
actions=mod_nw_src:203.31.220.144,output:p7p1"

Replace 'nw_src' with 'nw_dst' in above cmd for DNAT with IPv4

Sample cmd for offloading an IPv4 flow with SNAPT:

ovs-ofctl add-flow ovsbr0 "ip,nw_src=192.168.201.44 \
actions=mod_nw_src:203.31.220.144, mod_tp_src:6789,output:p7p1"

Similar to DNAT, replace 'tp_src' with 'tp_dst' for offloading flow
with DNAPT

Sample cmd for offloading an IPv6 flow with SNAT:

ovs-ofctl add-flow ovsbr0 "ipv6, ipv6_src=2001:5c0:9168::2/64 \
actions=load:0x1->NXM_NX_IPV6_SRC[0..63], \
load:0x20010db801920000->NXM_NX_IPV6_SRC[64..127],output:p7p1"

Replace 'SRC' with DST' above for IPv6 DNAT

Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 140 +++++++++++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h |  11 ++-
 2 files changed, 144 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index c35cde8..c801666 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -114,7 +114,8 @@ static int bnxt_tc_parse_tunnel_set(struct bnxt *bp,
 	return 0;
 }
 
-/* Key & Mask from the stack comes unaligned in multiple iterations.
+/* Key & Mask from the stack comes unaligned in multiple iterations of 4 bytes
+ * each(u32).
  * This routine consolidates such multiple unaligned values into one
  * field each for Key & Mask (for src and dst macs separately)
  * For example,
@@ -178,14 +179,19 @@ bnxt_fill_l2_rewrite_fields(struct bnxt_tc_actions *actions,
 
 static int
 bnxt_tc_parse_pedit(struct bnxt *bp, struct bnxt_tc_actions *actions,
-		    struct flow_action_entry *act, u8 *eth_addr,
+		    struct flow_action_entry *act, int act_idx, u8 *eth_addr,
 		    u8 *eth_addr_mask)
 {
-	u32 mask, val, offset;
+	size_t offset_of_ip6_daddr = offsetof(struct ipv6hdr, daddr);
+	size_t offset_of_ip6_saddr = offsetof(struct ipv6hdr, saddr);
+	u32 mask, val, offset, idx;
 	u8 htype;
 
 	offset = act->mangle.offset;
 	htype = act->mangle.htype;
+	mask = ~act->mangle.mask;
+	val = act->mangle.val;
+
 	switch (htype) {
 	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
 		if (offset > PEDIT_OFFSET_SMAC_LAST_4_BYTES) {
@@ -195,12 +201,73 @@ bnxt_tc_parse_pedit(struct bnxt *bp, struct bnxt_tc_actions *actions,
 			return -EINVAL;
 		}
 		actions->flags |= BNXT_TC_ACTION_FLAG_L2_REWRITE;
-		mask = ~act->mangle.mask;
-		val = act->mangle.val;
 
 		bnxt_set_l2_key_mask(val, mask, &eth_addr[offset],
 				     &eth_addr_mask[offset]);
 		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
+		actions->flags |= BNXT_TC_ACTION_FLAG_NAT_XLATE;
+		actions->nat.l3_is_ipv4 = true;
+		if (offset ==  offsetof(struct iphdr, saddr)) {
+			actions->nat.src_xlate = true;
+			actions->nat.l3.ipv4.saddr.s_addr = htonl(val);
+		} else if (offset ==  offsetof(struct iphdr, daddr)) {
+			actions->nat.src_xlate = false;
+			actions->nat.l3.ipv4.daddr.s_addr = htonl(val);
+		} else {
+			netdev_err(bp->dev,
+				   "%s: IPv4_hdr: Invalid pedit field\n",
+				   __func__);
+			return -EINVAL;
+		}
+
+		netdev_dbg(bp->dev, "nat.src_xlate = %d src IP: %pI4 dst ip : %pI4\n",
+			   actions->nat.src_xlate, &actions->nat.l3.ipv4.saddr,
+			   &actions->nat.l3.ipv4.daddr);
+		break;
+
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
+		actions->flags |= BNXT_TC_ACTION_FLAG_NAT_XLATE;
+		actions->nat.l3_is_ipv4 = false;
+		if (offset >= offsetof(struct ipv6hdr, saddr) &&
+		    offset < offset_of_ip6_daddr) {
+			/* 16 byte IPv6 address comes in 4 iterations of
+			 * 4byte chunks each
+			 */
+			actions->nat.src_xlate = true;
+			idx = (offset - offset_of_ip6_saddr) / 4;
+			/* First 4bytes will be copied to idx 0 and so on */
+			actions->nat.l3.ipv6.saddr.s6_addr32[idx] = htonl(val);
+		} else if (offset >= offset_of_ip6_daddr &&
+			   offset < offset_of_ip6_daddr + 16) {
+			actions->nat.src_xlate = false;
+			idx = (offset - offset_of_ip6_daddr) / 4;
+			actions->nat.l3.ipv6.saddr.s6_addr32[idx] = htonl(val);
+		} else {
+			netdev_err(bp->dev,
+				   "%s: IPv6_hdr: Invalid pedit field\n",
+				   __func__);
+			return -EINVAL;
+		}
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
+	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
+		/* HW does not support L4 rewrite alone without L3
+		 * rewrite
+		 */
+		if (!(actions->flags & BNXT_TC_ACTION_FLAG_NAT_XLATE)) {
+			netdev_err(bp->dev,
+				   "Need to specify L3 rewrite as well\n");
+			return -EINVAL;
+		}
+		if (actions->nat.src_xlate)
+			actions->nat.l4.ports.sport = htons(val);
+		else
+			actions->nat.l4.ports.dport = htons(val);
+		netdev_dbg(bp->dev, "actions->nat.sport = %d dport = %d\n",
+			   actions->nat.l4.ports.sport,
+			   actions->nat.l4.ports.dport);
+		break;
 	default:
 		netdev_err(bp->dev, "%s: Unsupported pedit hdr type\n",
 			   __func__);
@@ -258,7 +325,7 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
 			break;
 		/* Packet edit: L2 rewrite, NAT, NAPT */
 		case FLOW_ACTION_MANGLE:
-			rc = bnxt_tc_parse_pedit(bp, actions, act,
+			rc = bnxt_tc_parse_pedit(bp, actions, act, i,
 						 (u8 *)eth_addr,
 						 (u8 *)eth_addr_mask);
 			if (rc)
@@ -533,6 +600,67 @@ static int bnxt_hwrm_cfa_flow_alloc(struct bnxt *bp, struct bnxt_tc_flow *flow,
 			CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_L2_HEADER_REWRITE;
 	}
 
+	if (actions->flags & BNXT_TC_ACTION_FLAG_NAT_XLATE) {
+		if (actions->nat.l3_is_ipv4) {
+			action_flags |=
+				CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_IPV4_ADDRESS;
+
+			if (actions->nat.src_xlate) {
+				action_flags |=
+					CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_SRC;
+				/* L3 source rewrite */
+				req.nat_ip_address[0] =
+					actions->nat.l3.ipv4.saddr.s_addr;
+				/* L4 source port */
+				if (actions->nat.l4.ports.sport)
+					req.nat_port =
+						actions->nat.l4.ports.sport;
+			} else {
+				action_flags |=
+					CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_DEST;
+				/* L3 destination rewrite */
+				req.nat_ip_address[0] =
+					actions->nat.l3.ipv4.daddr.s_addr;
+				/* L4 destination port */
+				if (actions->nat.l4.ports.dport)
+					req.nat_port =
+						actions->nat.l4.ports.dport;
+			}
+			netdev_dbg(bp->dev,
+				   "req.nat_ip_address: %pI4 src_xlate: %d req.nat_port: %x\n",
+				   req.nat_ip_address, actions->nat.src_xlate,
+				   req.nat_port);
+		} else {
+			if (actions->nat.src_xlate) {
+				action_flags |=
+					CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_SRC;
+				/* L3 source rewrite */
+				memcpy(req.nat_ip_address,
+				       actions->nat.l3.ipv6.saddr.s6_addr32,
+				       sizeof(req.nat_ip_address));
+				/* L4 source port */
+				if (actions->nat.l4.ports.sport)
+					req.nat_port =
+						actions->nat.l4.ports.sport;
+			} else {
+				action_flags |=
+					CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_DEST;
+				/* L3 destination rewrite */
+				memcpy(req.nat_ip_address,
+				       actions->nat.l3.ipv6.daddr.s6_addr32,
+				       sizeof(req.nat_ip_address));
+				/* L4 destination port */
+				if (actions->nat.l4.ports.dport)
+					req.nat_port =
+						actions->nat.l4.ports.dport;
+			}
+			netdev_dbg(bp->dev,
+				   "req.nat_ip_address: %pI6 src_xlate: %d req.nat_port: %x\n",
+				   req.nat_ip_address, actions->nat.src_xlate,
+				   req.nat_port);
+		}
+	}
+
 	if (actions->flags & BNXT_TC_ACTION_FLAG_TUNNEL_DECAP ||
 	    actions->flags & BNXT_TC_ACTION_FLAG_TUNNEL_ENCAP) {
 		req.tunnel_handle = tunnel_handle;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
index 6d0d485..2867549 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
@@ -78,6 +78,7 @@ struct bnxt_tc_actions {
 #define BNXT_TC_ACTION_FLAG_TUNNEL_ENCAP	BIT(6)
 #define BNXT_TC_ACTION_FLAG_TUNNEL_DECAP	BIT(7)
 #define BNXT_TC_ACTION_FLAG_L2_REWRITE		BIT(8)
+#define BNXT_TC_ACTION_FLAG_NAT_XLATE		BIT(9)
 
 	u16				dst_fid;
 	struct net_device		*dst_dev;
@@ -89,7 +90,15 @@ struct bnxt_tc_actions {
 #define	PEDIT_OFFSET_SMAC_LAST_4_BYTES		0x8
 	__be16				l2_rewrite_dmac[3];
 	__be16				l2_rewrite_smac[3];
-
+	struct {
+		bool src_xlate;  /* true => translate src,
+				  * false => translate dst
+				  * Mutually exclusive, i.e cannot set both
+				  */
+		bool l3_is_ipv4; /* false means L3 is ipv6 */
+		struct bnxt_tc_l3_key l3;
+		struct bnxt_tc_l4_key l4;
+	} nat;
 };
 
 struct bnxt_tc_flow {
-- 
2.5.1

