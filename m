Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01430EAA07
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 06:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfJaFIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 01:08:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40182 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfJaFIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 01:08:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id r4so3407518pfl.7
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 22:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+kZShBjm2NpOlXVD0Yz/xL8JFj7lnpXhtfwRC8fOG0A=;
        b=CIlpPNGDmtd0O6Yu4IlqoZGh+pIgf6hEXVQR4Q328Lphn0/EbWrFKEFuANUthrhM1o
         c11EspV2UkBGFGtM/jFsO4oxiuPnQCOXuA2I4pWwdUM/8c60C+rpnvrm5LtIyXKISgfL
         Xoa0GkFtubUWlO0DW4YroeYgUDrtvpeqpi8D4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+kZShBjm2NpOlXVD0Yz/xL8JFj7lnpXhtfwRC8fOG0A=;
        b=Ytly3FvO/5VguveNxqQJHSDURuCF5xz6yLFicrF11WKyAhfE2kpK1iGt8BZQr30SA1
         k4kCXLjhN2WL21oGoUJys9qlGAqlMANL+YA1reg1NNtqmmMTEzOKpd4Xfs+3o4cKTRpc
         C5bfr0j69BjnOuZqsdSciliOJqWNFvE1Wsqc94k02uTA1mfYRlp6GwGZfFuhpm0mbuu3
         y3ZE7cy3dBRBQqIq9gf2IRzTylHFRYM4FhsrhpqTTQL1dg2NBWs2TvPfkhG3cSXSlsaW
         vFqFClztVRwWz81mTctiPTz8e8e7DG+FhJs5eg3bVsdM/c9k/9tcyoCcPVEEhkzR46cr
         3OfQ==
X-Gm-Message-State: APjAAAUGC3QHLi0x8tw+cXRrWdjP7q6k08MJMR8yfONHZnQMQ9lEfSbR
        3GwW8SU8fsc0OBsk1fPnoEPUUw==
X-Google-Smtp-Source: APXvYqwXjrFUOAceeonVu59y8a0ds6LE6hWVr91S0wvm+I9GBD76gGcfaW9iCmAK93HQ5MPgrCjP3g==
X-Received: by 2002:a63:e750:: with SMTP id j16mr4113263pgk.30.1572498492907;
        Wed, 30 Oct 2019 22:08:12 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a8sm1690899pff.5.2019.10.30.22.08.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 22:08:12 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
Subject: [PATCH net-next v2 1/7] bnxt_en: Add support for L2 rewrite
Date:   Thu, 31 Oct 2019 01:07:45 -0400
Message-Id: <1572498471-31550-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
References: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>

This patch adds support for packet edit offload of L2 fields (src mac &
dst mac, also referred as L2 rewrite). Only when the mask is fully exact
match for a field, the command is sent down to the adapter to offload
such a flow. Otherwise, an error is returned.

v2: Fix pointer alignment issue in bnxt_fill_l2_rewrite_fields() [MChan]

Signed-off-by: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 132 +++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h |  11 +++
 2 files changed, 143 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index c8062d0..80b39ff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -16,6 +16,7 @@
 #include <net/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_vlan.h>
+#include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_tunnel_key.h>
 
 #include "bnxt_hsi.h"
@@ -36,6 +37,8 @@
 #define is_vid_exactmatch(vlan_tci_mask)	\
 	((ntohs(vlan_tci_mask) & VLAN_VID_MASK) == VLAN_VID_MASK)
 
+static bool is_wildcard(void *mask, int len);
+static bool is_exactmatch(void *mask, int len);
 /* Return the dst fid of the func for flow forwarding
  * For PFs: src_fid is the fid of the PF
  * For VF-reps: src_fid the fid of the VF
@@ -111,10 +114,115 @@ static int bnxt_tc_parse_tunnel_set(struct bnxt *bp,
 	return 0;
 }
 
+/* Key & Mask from the stack comes unaligned in multiple iterations.
+ * This routine consolidates such multiple unaligned values into one
+ * field each for Key & Mask (for src and dst macs separately)
+ * For example,
+ *			Mask/Key	Offset	Iteration
+ *			==========	======	=========
+ *	dst mac		0xffffffff	0	1
+ *	dst mac		0x0000ffff	4	2
+ *
+ *	src mac		0xffff0000	4	1
+ *	src mac		0xffffffff	8	2
+ *
+ * The above combination coming from the stack will be consolidated as
+ *			Mask/Key
+ *			==============
+ *	src mac:	0xffffffffffff
+ *	dst mac:	0xffffffffffff
+ */
+static void bnxt_set_l2_key_mask(u32 part_key, u32 part_mask,
+				 u8 *actual_key, u8 *actual_mask)
+{
+	u32 key = get_unaligned((u32 *)actual_key);
+	u32 mask = get_unaligned((u32 *)actual_mask);
+
+	part_key &= part_mask;
+	part_key |= key & ~part_mask;
+
+	put_unaligned(mask | part_mask, (u32 *)actual_mask);
+	put_unaligned(part_key, (u32 *)actual_key);
+}
+
+static int
+bnxt_fill_l2_rewrite_fields(struct bnxt_tc_actions *actions,
+			    u16 *eth_addr, u16 *eth_addr_mask)
+{
+	u16 *p;
+	int j;
+
+	if (unlikely(bnxt_eth_addr_key_mask_invalid(eth_addr, eth_addr_mask)))
+		return -EINVAL;
+
+	if (!is_wildcard(&eth_addr_mask[0], ETH_ALEN)) {
+		if (!is_exactmatch(&eth_addr_mask[0], ETH_ALEN))
+			return -EINVAL;
+		/* FW expects dmac to be in u16 array format */
+		p = eth_addr;
+		for (j = 0; j < 3; j++)
+			actions->l2_rewrite_dmac[j] = cpu_to_be16(*(p + j));
+	}
+
+	if (!is_wildcard(&eth_addr_mask[ETH_ALEN], ETH_ALEN)) {
+		if (!is_exactmatch(&eth_addr_mask[ETH_ALEN], ETH_ALEN))
+			return -EINVAL;
+		/* FW expects smac to be in u16 array format */
+		p = &eth_addr[ETH_ALEN / 2];
+		for (j = 0; j < 3; j++)
+			actions->l2_rewrite_smac[j] = cpu_to_be16(*(p + j));
+	}
+
+	return 0;
+}
+
+static int
+bnxt_tc_parse_pedit(struct bnxt *bp, struct bnxt_tc_actions *actions,
+		    struct flow_action_entry *act, u8 *eth_addr,
+		    u8 *eth_addr_mask)
+{
+	u32 mask, val, offset;
+	u8 htype;
+
+	offset = act->mangle.offset;
+	htype = act->mangle.htype;
+	switch (htype) {
+	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
+		if (offset > PEDIT_OFFSET_SMAC_LAST_4_BYTES) {
+			netdev_err(bp->dev,
+				   "%s: eth_hdr: Invalid pedit field\n",
+				   __func__);
+			return -EINVAL;
+		}
+		actions->flags |= BNXT_TC_ACTION_FLAG_L2_REWRITE;
+		mask = ~act->mangle.mask;
+		val = act->mangle.val;
+
+		bnxt_set_l2_key_mask(val, mask, &eth_addr[offset],
+				     &eth_addr_mask[offset]);
+		break;
+	default:
+		netdev_err(bp->dev, "%s: Unsupported pedit hdr type\n",
+			   __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int bnxt_tc_parse_actions(struct bnxt *bp,
 				 struct bnxt_tc_actions *actions,
 				 struct flow_action *flow_action)
 {
+	/* Used to store the L2 rewrite mask for dmac (6 bytes) followed by
+	 * smac (6 bytes) if rewrite of both is specified, otherwise either
+	 * dmac or smac
+	 */
+	u16 eth_addr_mask[ETH_ALEN] = { 0 };
+	/* Used to store the L2 rewrite key for dmac (6 bytes) followed by
+	 * smac (6 bytes) if rewrite of both is specified, otherwise either
+	 * dmac or smac
+	 */
+	u16 eth_addr[ETH_ALEN] = { 0 };
 	struct flow_action_entry *act;
 	int i, rc;
 
@@ -148,11 +256,26 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
 		case FLOW_ACTION_TUNNEL_DECAP:
 			actions->flags |= BNXT_TC_ACTION_FLAG_TUNNEL_DECAP;
 			break;
+		/* Packet edit: L2 rewrite, NAT, NAPT */
+		case FLOW_ACTION_MANGLE:
+			rc = bnxt_tc_parse_pedit(bp, actions, act,
+						 (u8 *)eth_addr,
+						 (u8 *)eth_addr_mask);
+			if (rc)
+				return rc;
+			break;
 		default:
 			break;
 		}
 	}
 
+	if (actions->flags & BNXT_TC_ACTION_FLAG_L2_REWRITE) {
+		rc = bnxt_fill_l2_rewrite_fields(actions, eth_addr,
+						 eth_addr_mask);
+		if (rc)
+			return rc;
+	}
+
 	if (actions->flags & BNXT_TC_ACTION_FLAG_FWD) {
 		if (actions->flags & BNXT_TC_ACTION_FLAG_TUNNEL_ENCAP) {
 			/* dst_fid is PF's fid */
@@ -401,6 +524,15 @@ static int bnxt_hwrm_cfa_flow_alloc(struct bnxt *bp, struct bnxt_tc_flow *flow,
 	req.src_fid = cpu_to_le16(flow->src_fid);
 	req.ref_flow_handle = ref_flow_handle;
 
+	if (actions->flags & BNXT_TC_ACTION_FLAG_L2_REWRITE) {
+		memcpy(req.l2_rewrite_dmac, actions->l2_rewrite_dmac,
+		       ETH_ALEN);
+		memcpy(req.l2_rewrite_smac, actions->l2_rewrite_smac,
+		       ETH_ALEN);
+		action_flags |=
+			CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_L2_HEADER_REWRITE;
+	}
+
 	if (actions->flags & BNXT_TC_ACTION_FLAG_TUNNEL_DECAP ||
 	    actions->flags & BNXT_TC_ACTION_FLAG_TUNNEL_ENCAP) {
 		req.tunnel_handle = tunnel_handle;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
index 4f05305..6d0d485 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
@@ -62,6 +62,12 @@ struct bnxt_tc_tunnel_key {
 	__be32			id;
 };
 
+#define bnxt_eth_addr_key_mask_invalid(eth_addr, eth_addr_mask)		\
+	((is_wildcard(&(eth_addr)[0], ETH_ALEN) &&			\
+	 is_wildcard(&(eth_addr)[ETH_ALEN], ETH_ALEN)) ||		\
+	(is_wildcard(&(eth_addr_mask)[0], ETH_ALEN) &&			\
+	 is_wildcard(&(eth_addr_mask)[ETH_ALEN], ETH_ALEN)))
+
 struct bnxt_tc_actions {
 	u32				flags;
 #define BNXT_TC_ACTION_FLAG_FWD			BIT(0)
@@ -71,6 +77,7 @@ struct bnxt_tc_actions {
 #define BNXT_TC_ACTION_FLAG_DROP		BIT(5)
 #define BNXT_TC_ACTION_FLAG_TUNNEL_ENCAP	BIT(6)
 #define BNXT_TC_ACTION_FLAG_TUNNEL_DECAP	BIT(7)
+#define BNXT_TC_ACTION_FLAG_L2_REWRITE		BIT(8)
 
 	u16				dst_fid;
 	struct net_device		*dst_dev;
@@ -79,6 +86,10 @@ struct bnxt_tc_actions {
 
 	/* tunnel encap */
 	struct ip_tunnel_key		tun_encap_key;
+#define	PEDIT_OFFSET_SMAC_LAST_4_BYTES		0x8
+	__be16				l2_rewrite_dmac[3];
+	__be16				l2_rewrite_smac[3];
+
 };
 
 struct bnxt_tc_flow {
-- 
2.5.1

