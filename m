Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA7724C0C4
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgHTOke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbgHTOj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:39:57 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB9AC061387
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 07:39:57 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a26so2828211ejc.2
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 07:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rJDIPRuXq5zOybs6nVQi+sgWZbh3y+F1QQVYsaIR2Cw=;
        b=U0VPTWK9Aosas3kikm+7As1XhTDblzrFHNmujLqfJTniHWCIgHexjRhlvFDGHXq4yU
         JwpRZ9a+9omVl856TS5fAGuiKituP7DI3z83VMxl+Lxf/wB/4Bu5XsOGo73z9aRW/XAs
         HHX/SGpJ2WxYUL/J1ScCPMUeVw9rBoIMpeJfwI1QGb7LZQGVA0sIQD8ed3+RvGE+IjBi
         pbFdZMplkMNStplTdK9lQXaGp/JfrSgY0hJGopNWpYtUuk2x0kYJ2CXK7kYpvzrzV3Wx
         LgR5c6frrBwRi4s0B2thi22Ax08ayPwpzsg8MgdRUS0zgypeDOwHbYGiSONz3SiKtt33
         jHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJDIPRuXq5zOybs6nVQi+sgWZbh3y+F1QQVYsaIR2Cw=;
        b=uP+UrVgDq468rXERGG4YjdbU+eQl3ayOjzR9+gt4KUh9/KcCJCUbQ2EuhTUA8pWeuL
         HYdcBCWY97JIa19QBFHo+NpIFq1G6m8YTAgenL9F7N56E8E8W2rWdLNPpFTJxF2Hd1Ml
         d42rE7MEqcA1zrJMCkR+n1dzUXYA5tfkL/Lu4Xm7l9XvDOA72EmBUitl5YeeEtVcF1u3
         hj5fV6QUYM/XpTh1HyUYLH0z0pMBcO0YQh4TL2ibi+mgi5JGvTCecnUZXP1Fs2AnTzno
         0djyOb8t413KuR68XxOH7Ulc/ChAy4n3+gQIhE2tri1LJp596ipudc+MO96JW7y6gz6y
         KEYg==
X-Gm-Message-State: AOAM5305CFPAgjXShxTpx2XkQAM0Ruxed5SSqN13/zeHV2QcAhTmVe5f
        AO7tQGBab+CyvYOogn1IwSvYcw==
X-Google-Smtp-Source: ABdhPJzYgaDGhVYaVP5fpUL+kNkoq/gcbr8Zu83vtE8fqwqnoCCigES6x2fLyo/kkVmO9ShxFQSSkQ==
X-Received: by 2002:a17:906:3c02:: with SMTP id h2mr3698376ejg.437.1597934395682;
        Thu, 20 Aug 2020 07:39:55 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id m24sm1542511eje.80.2020.08.20.07.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 07:39:54 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 2/2] nfp: flower: add support to offload QinQ match
Date:   Thu, 20 Aug 2020 16:39:38 +0200
Message-Id: <20200820143938.21199-3-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200820143938.21199-1-simon.horman@netronome.com>
References: <20200820143938.21199-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@netronome.com>

When both the driver and the firmware supports QinQ the flow key
structure that is send to the firmware is updated as the old
method of matching on VLAN did not allow for space to add another
VLAN tag. VLAN flows can now also match on the tpid field, not
constrained to just 0x8100 as before.

Signed-off-by: Louis Peens <louis.peens@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/cmsg.h  | 17 ++++
 .../net/ethernet/netronome/nfp/flower/main.h  |  4 +-
 .../net/ethernet/netronome/nfp/flower/match.c | 62 +++++++++++++-
 .../ethernet/netronome/nfp/flower/offload.c   | 85 ++++++++++++++++---
 4 files changed, 152 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index bf516285510f..a2926b1b3cff 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -24,6 +24,7 @@
 #define NFP_FLOWER_LAYER_VXLAN		BIT(7)
 
 #define NFP_FLOWER_LAYER2_GRE		BIT(0)
+#define NFP_FLOWER_LAYER2_QINQ		BIT(4)
 #define NFP_FLOWER_LAYER2_GENEVE	BIT(5)
 #define NFP_FLOWER_LAYER2_GENEVE_OP	BIT(6)
 #define NFP_FLOWER_LAYER2_TUN_IPV6	BIT(7)
@@ -319,6 +320,22 @@ struct nfp_flower_mac_mpls {
 	__be32 mpls_lse;
 };
 
+/* VLAN details (2W/8B)
+ *    3                   2                   1
+ *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |           outer_tpid          |           outer_tci           |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |           inner_tpid          |           inner_tci           |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ */
+struct nfp_flower_vlan {
+	__be16 outer_tpid;
+	__be16 outer_tci;
+	__be16 inner_tpid;
+	__be16 inner_tci;
+};
+
 /* L4 ports (for UDP, TCP, SCTP) (1W/4B)
  *    3                   2                   1
  *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 4924a217f5ba..caf12eec9945 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -46,6 +46,7 @@ struct nfp_app;
 #define NFP_FL_FEATS_FLOW_MOD		BIT(5)
 #define NFP_FL_FEATS_PRE_TUN_RULES	BIT(6)
 #define NFP_FL_FEATS_IPV6_TUN		BIT(7)
+#define NFP_FL_FEATS_VLAN_QINQ		BIT(8)
 #define NFP_FL_FEATS_HOST_ACK		BIT(31)
 
 #define NFP_FL_ENABLE_FLOW_MERGE	BIT(0)
@@ -59,7 +60,8 @@ struct nfp_app;
 	NFP_FL_FEATS_VF_RLIM | \
 	NFP_FL_FEATS_FLOW_MOD | \
 	NFP_FL_FEATS_PRE_TUN_RULES | \
-	NFP_FL_FEATS_IPV6_TUN)
+	NFP_FL_FEATS_IPV6_TUN | \
+	NFP_FL_FEATS_VLAN_QINQ)
 
 struct nfp_fl_mask_id {
 	struct circ_buf mask_id_free_list;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 64690511e47b..255a4dff6288 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -10,7 +10,7 @@
 static void
 nfp_flower_compile_meta_tci(struct nfp_flower_meta_tci *ext,
 			    struct nfp_flower_meta_tci *msk,
-			    struct flow_rule *rule, u8 key_type)
+			    struct flow_rule *rule, u8 key_type, bool qinq_sup)
 {
 	u16 tmp_tci;
 
@@ -24,7 +24,7 @@ nfp_flower_compile_meta_tci(struct nfp_flower_meta_tci *ext,
 	msk->nfp_flow_key_layer = key_type;
 	msk->mask_id = ~0;
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+	if (!qinq_sup && flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
 		struct flow_match_vlan match;
 
 		flow_rule_match_vlan(rule, &match);
@@ -230,6 +230,50 @@ nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *ext,
 	}
 }
 
+static void
+nfp_flower_fill_vlan(struct flow_dissector_key_vlan *key,
+		     struct nfp_flower_vlan *frame,
+		     bool outer_vlan)
+{
+	u16 tci;
+
+	tci = NFP_FLOWER_MASK_VLAN_PRESENT;
+	tci |= FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
+			  key->vlan_priority) |
+	       FIELD_PREP(NFP_FLOWER_MASK_VLAN_VID,
+			  key->vlan_id);
+
+	if (outer_vlan) {
+		frame->outer_tci = cpu_to_be16(tci);
+		frame->outer_tpid = key->vlan_tpid;
+	} else {
+		frame->inner_tci = cpu_to_be16(tci);
+		frame->inner_tpid = key->vlan_tpid;
+	}
+}
+
+static void
+nfp_flower_compile_vlan(struct nfp_flower_vlan *ext,
+			struct nfp_flower_vlan *msk,
+			struct flow_rule *rule)
+{
+	struct flow_match_vlan match;
+
+	memset(ext, 0, sizeof(struct nfp_flower_vlan));
+	memset(msk, 0, sizeof(struct nfp_flower_vlan));
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		flow_rule_match_vlan(rule, &match);
+		nfp_flower_fill_vlan(match.key, ext, true);
+		nfp_flower_fill_vlan(match.mask, msk, true);
+	}
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
+		flow_rule_match_cvlan(rule, &match);
+		nfp_flower_fill_vlan(match.key, ext, false);
+		nfp_flower_fill_vlan(match.mask, msk, false);
+	}
+}
+
 static void
 nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *ext,
 			struct nfp_flower_ipv4 *msk, struct flow_rule *rule)
@@ -433,6 +477,8 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 				  struct netlink_ext_ack *extack)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
+	struct nfp_flower_priv *priv = app->priv;
+	bool qinq_sup;
 	u32 port_id;
 	int ext_len;
 	int err;
@@ -447,9 +493,11 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	ext = nfp_flow->unmasked_data;
 	msk = nfp_flow->mask_data;
 
+	qinq_sup = !!(priv->flower_ext_feats & NFP_FL_FEATS_VLAN_QINQ);
+
 	nfp_flower_compile_meta_tci((struct nfp_flower_meta_tci *)ext,
 				    (struct nfp_flower_meta_tci *)msk,
-				    rule, key_ls->key_layer);
+				    rule, key_ls->key_layer, qinq_sup);
 	ext += sizeof(struct nfp_flower_meta_tci);
 	msk += sizeof(struct nfp_flower_meta_tci);
 
@@ -548,6 +596,14 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		}
 	}
 
+	if (NFP_FLOWER_LAYER2_QINQ & key_ls->key_layer_two) {
+		nfp_flower_compile_vlan((struct nfp_flower_vlan *)ext,
+					(struct nfp_flower_vlan *)msk,
+					rule);
+		ext += sizeof(struct nfp_flower_vlan);
+		msk += sizeof(struct nfp_flower_vlan);
+	}
+
 	if (key_ls->key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 4651fe417b7f..44cf738636ef 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -31,6 +31,7 @@
 	 BIT(FLOW_DISSECTOR_KEY_PORTS) | \
 	 BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) | \
 	 BIT(FLOW_DISSECTOR_KEY_VLAN) | \
+	 BIT(FLOW_DISSECTOR_KEY_CVLAN) | \
 	 BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) | \
 	 BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) | \
 	 BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) | \
@@ -66,7 +67,8 @@
 	 NFP_FLOWER_LAYER_IPV6)
 
 #define NFP_FLOWER_PRE_TUN_RULE_FIELDS \
-	(NFP_FLOWER_LAYER_PORT | \
+	(NFP_FLOWER_LAYER_EXT_META | \
+	 NFP_FLOWER_LAYER_PORT | \
 	 NFP_FLOWER_LAYER_MAC | \
 	 NFP_FLOWER_LAYER_IPV4 | \
 	 NFP_FLOWER_LAYER_IPV6)
@@ -285,6 +287,30 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support VLAN PCP offload");
 			return -EOPNOTSUPP;
 		}
+		if (priv->flower_ext_feats & NFP_FL_FEATS_VLAN_QINQ &&
+		    !(key_layer_two & NFP_FLOWER_LAYER2_QINQ)) {
+			key_layer |= NFP_FLOWER_LAYER_EXT_META;
+			key_size += sizeof(struct nfp_flower_ext_meta);
+			key_size += sizeof(struct nfp_flower_vlan);
+			key_layer_two |= NFP_FLOWER_LAYER2_QINQ;
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
+		struct flow_match_vlan cvlan;
+
+		if (!(priv->flower_ext_feats & NFP_FL_FEATS_VLAN_QINQ)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support VLAN QinQ offload");
+			return -EOPNOTSUPP;
+		}
+
+		flow_rule_match_vlan(rule, &cvlan);
+		if (!(key_layer_two & NFP_FLOWER_LAYER2_QINQ)) {
+			key_layer |= NFP_FLOWER_LAYER_EXT_META;
+			key_size += sizeof(struct nfp_flower_ext_meta);
+			key_size += sizeof(struct nfp_flower_vlan);
+			key_layer_two |= NFP_FLOWER_LAYER2_QINQ;
+		}
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
@@ -1066,6 +1092,7 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
  * nfp_flower_validate_pre_tun_rule()
  * @app:	Pointer to the APP handle
  * @flow:	Pointer to NFP flow representation of rule
+ * @key_ls:	Pointer to NFP key layers structure
  * @extack:	Netlink extended ACK report
  *
  * Verifies the flow as a pre-tunnel rule.
@@ -1075,10 +1102,13 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 static int
 nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 				 struct nfp_fl_payload *flow,
+				 struct nfp_fl_key_ls *key_ls,
 				 struct netlink_ext_ack *extack)
 {
+	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_flower_meta_tci *meta_tci;
 	struct nfp_flower_mac_mpls *mac;
+	u8 *ext = flow->unmasked_data;
 	struct nfp_fl_act_head *act;
 	u8 *mask = flow->mask_data;
 	bool vlan = false;
@@ -1086,20 +1116,25 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 	u8 key_layer;
 
 	meta_tci = (struct nfp_flower_meta_tci *)flow->unmasked_data;
-	if (meta_tci->tci & cpu_to_be16(NFP_FLOWER_MASK_VLAN_PRESENT)) {
-		u16 vlan_tci = be16_to_cpu(meta_tci->tci);
-
-		vlan_tci &= ~NFP_FLOWER_MASK_VLAN_PRESENT;
-		flow->pre_tun_rule.vlan_tci = cpu_to_be16(vlan_tci);
-		vlan = true;
-	} else {
-		flow->pre_tun_rule.vlan_tci = cpu_to_be16(0xffff);
+	key_layer = key_ls->key_layer;
+	if (!(priv->flower_ext_feats & NFP_FL_FEATS_VLAN_QINQ)) {
+		if (meta_tci->tci & cpu_to_be16(NFP_FLOWER_MASK_VLAN_PRESENT)) {
+			u16 vlan_tci = be16_to_cpu(meta_tci->tci);
+
+			vlan_tci &= ~NFP_FLOWER_MASK_VLAN_PRESENT;
+			flow->pre_tun_rule.vlan_tci = cpu_to_be16(vlan_tci);
+			vlan = true;
+		} else {
+			flow->pre_tun_rule.vlan_tci = cpu_to_be16(0xffff);
+		}
 	}
 
-	key_layer = meta_tci->nfp_flow_key_layer;
 	if (key_layer & ~NFP_FLOWER_PRE_TUN_RULE_FIELDS) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: too many match fields");
 		return -EOPNOTSUPP;
+	} else if (key_ls->key_layer_two & ~NFP_FLOWER_LAYER2_QINQ) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: non-vlan in extended match fields");
+		return -EOPNOTSUPP;
 	}
 
 	if (!(key_layer & NFP_FLOWER_LAYER_MAC)) {
@@ -1109,7 +1144,13 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 
 	/* Skip fields known to exist. */
 	mask += sizeof(struct nfp_flower_meta_tci);
+	ext += sizeof(struct nfp_flower_meta_tci);
+	if (key_ls->key_layer_two) {
+		mask += sizeof(struct nfp_flower_ext_meta);
+		ext += sizeof(struct nfp_flower_ext_meta);
+	}
 	mask += sizeof(struct nfp_flower_in_port);
+	ext += sizeof(struct nfp_flower_in_port);
 
 	/* Ensure destination MAC address is fully matched. */
 	mac = (struct nfp_flower_mac_mpls *)mask;
@@ -1118,6 +1159,8 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 		return -EOPNOTSUPP;
 	}
 
+	mask += sizeof(struct nfp_flower_mac_mpls);
+	ext += sizeof(struct nfp_flower_mac_mpls);
 	if (key_layer & NFP_FLOWER_LAYER_IPV4 ||
 	    key_layer & NFP_FLOWER_LAYER_IPV6) {
 		/* Flags and proto fields have same offset in IPv4 and IPv6. */
@@ -1130,7 +1173,6 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 			sizeof(struct nfp_flower_ipv4) :
 			sizeof(struct nfp_flower_ipv6);
 
-		mask += sizeof(struct nfp_flower_mac_mpls);
 
 		/* Ensure proto and flags are the only IP layer fields. */
 		for (i = 0; i < size; i++)
@@ -1138,6 +1180,25 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 				NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: only flags and proto can be matched in ip header");
 				return -EOPNOTSUPP;
 			}
+		ext += size;
+		mask += size;
+	}
+
+	if ((priv->flower_ext_feats & NFP_FL_FEATS_VLAN_QINQ)) {
+		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_QINQ) {
+			struct nfp_flower_vlan *vlan_tags;
+			u16 vlan_tci;
+
+			vlan_tags = (struct nfp_flower_vlan *)ext;
+
+			vlan_tci = be16_to_cpu(vlan_tags->outer_tci);
+
+			vlan_tci &= ~NFP_FLOWER_MASK_VLAN_PRESENT;
+			flow->pre_tun_rule.vlan_tci = cpu_to_be16(vlan_tci);
+			vlan = true;
+		} else {
+			flow->pre_tun_rule.vlan_tci = cpu_to_be16(0xffff);
+		}
 	}
 
 	/* Action must be a single egress or pop_vlan and egress. */
@@ -1220,7 +1281,7 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 		goto err_destroy_flow;
 
 	if (flow_pay->pre_tun_rule.dev) {
-		err = nfp_flower_validate_pre_tun_rule(app, flow_pay, extack);
+		err = nfp_flower_validate_pre_tun_rule(app, flow_pay, key_layer, extack);
 		if (err)
 			goto err_destroy_flow;
 	}
-- 
2.20.1

