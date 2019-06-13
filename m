Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650F044E3C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfFMVRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:17:31 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43450 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfFMVR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:17:28 -0400
Received: by mail-qt1-f194.google.com with SMTP id z24so81592qtj.10
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 14:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gEmeSZ8ZzdB4ydH58exHVYGNRS2j3/RANg3V2CbE4IY=;
        b=oBgaS+T2pwL0PDHz/QX4CDpOCZSS9uuSi9lKxb6f2+A4UyzoMAszNtasJaqPbM5H8i
         C0ddaCcS1su/H3YVQut/+yrIYo0f8npNUtAUOmsYljYJsRMouYGTcBcKpNouV1zhFwYe
         F8pwSSHWavtRiwkSBnKJsmcQdPgkEWxh/4tJTY5wPFZoFN0N4EdG/wV39Lv5NgGsspYl
         aspaExD2hV9WG0ZxFDaonfZ556NrF1CV7NPVVw181q0eNio/w0fwodDzH/YAwUBBTOx5
         o9hmao4DoRDwUZdtPc40UbSHWdEc5aBD7I0cNzqRZ3FTAb0lmLr86MMDEvh5Sb6O84dB
         uDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gEmeSZ8ZzdB4ydH58exHVYGNRS2j3/RANg3V2CbE4IY=;
        b=fC7pY/b+KWmgTnz9z8j25fLvQy7i8/e7MakwvAzhJkOSXHoJOUqlga318eS1ah9jXG
         8fjRlb/TzQteG9Uw7WXUMcw0EDFsQaPsERl8l7v0IJP958Arl9gE8/LJKXLF9KzWyYq9
         XrWJdMVrW4dmxfI00+Ff5dSox/DcVE0qgUHUPfRklWrR5F0IenoyouhXyHGGOoiaN/lH
         1JnKyH2++6B9uirTIsXtwGhs40IUK0EaZv6jeQj5cqX2S+Mf/Xc/mru3cifeAXuolwkO
         8m6TfGnKBJb1A3FANtTpz1oz5JlSZ6qWG9qKgrm9F1Zync5FHu6TL5cV4pTSRMHtUnG5
         vYRw==
X-Gm-Message-State: APjAAAVD28GH2vOYSbwdzrwVT1C4UbxlJpZmymJRCx7H+NKFTgw4awMU
        b0ftP46Ft8fcOEQjMdx1uBhW6QM7o9w=
X-Google-Smtp-Source: APXvYqzZxCqFT+bEjbIkcyTjHWi2flGtGmwgkDABVois6ZQMEq+LbllOTMfb5t/CMQHd8v/4W3hKZQ==
X-Received: by 2002:ac8:6c59:: with SMTP id z25mr416480qtu.43.1560460646660;
        Thu, 13 Jun 2019 14:17:26 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x7sm497322qth.37.2019.06.13.14.17.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 14:17:26 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 2/3] nfp: flower: use extack messages in flower offload
Date:   Thu, 13 Jun 2019 14:17:10 -0700
Message-Id: <20190613211711.5505-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613211711.5505-1-jakub.kicinski@netronome.com>
References: <20190613211711.5505-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Use extack messages in flower offload, specifically focusing on
the extack use in add offload, remove offload and get stats paths.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../ethernet/netronome/nfp/flower/offload.c   | 105 +++++++++++++-----
 1 file changed, 80 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 3cccd0911e31..26d24b103317 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -142,10 +142,13 @@ static bool nfp_flower_check_higher_than_l3(struct tc_cls_flower_offload *f)
 
 static int
 nfp_flower_calc_opt_layer(struct flow_match_enc_opts *enc_opts,
-			  u32 *key_layer_two, int *key_size)
+			  u32 *key_layer_two, int *key_size,
+			  struct netlink_ext_ack *extack)
 {
-	if (enc_opts->key->len > NFP_FL_MAX_GENEVE_OPT_KEY)
+	if (enc_opts->key->len > NFP_FL_MAX_GENEVE_OPT_KEY) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: geneve options exceed maximum length");
 		return -EOPNOTSUPP;
+	}
 
 	if (enc_opts->key->len > 0) {
 		*key_layer_two |= NFP_FLOWER_LAYER2_GENEVE_OP;
@@ -160,7 +163,8 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 				struct net_device *netdev,
 				struct nfp_fl_key_ls *ret_key_ls,
 				struct tc_cls_flower_offload *flow,
-				enum nfp_flower_tun_type *tun_type)
+				enum nfp_flower_tun_type *tun_type,
+				struct netlink_ext_ack *extack)
 {
 	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
 	struct flow_dissector *dissector = rule->match.dissector;
@@ -171,14 +175,18 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 	int key_size;
 	int err;
 
-	if (dissector->used_keys & ~NFP_FLOWER_WHITELIST_DISSECTOR)
+	if (dissector->used_keys & ~NFP_FLOWER_WHITELIST_DISSECTOR) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: match not supported");
 		return -EOPNOTSUPP;
+	}
 
 	/* If any tun dissector is used then the required set must be used. */
 	if (dissector->used_keys & NFP_FLOWER_WHITELIST_TUN_DISSECTOR &&
 	    (dissector->used_keys & NFP_FLOWER_WHITELIST_TUN_DISSECTOR_R)
-	    != NFP_FLOWER_WHITELIST_TUN_DISSECTOR_R)
+	    != NFP_FLOWER_WHITELIST_TUN_DISSECTOR_R) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: tunnel match not supported");
 		return -EOPNOTSUPP;
+	}
 
 	key_layer_two = 0;
 	key_layer = NFP_FLOWER_LAYER_PORT;
@@ -196,8 +204,10 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 
 		flow_rule_match_vlan(rule, &vlan);
 		if (!(priv->flower_ext_feats & NFP_FL_FEATS_VLAN_PCP) &&
-		    vlan.key->vlan_priority)
+		    vlan.key->vlan_priority) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support VLAN PCP offload");
 			return -EOPNOTSUPP;
+		}
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
@@ -208,18 +218,27 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 
 		flow_rule_match_enc_control(rule, &enc_ctl);
 
-		if (enc_ctl.mask->addr_type != 0xffff ||
-		    enc_ctl.key->addr_type != FLOW_DISSECTOR_KEY_IPV4_ADDRS)
+		if (enc_ctl.mask->addr_type != 0xffff) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: wildcarded protocols on tunnels are not supported");
+			return -EOPNOTSUPP;
+		}
+		if (enc_ctl.key->addr_type != FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: only IPv4 tunnels are supported");
 			return -EOPNOTSUPP;
+		}
 
 		/* These fields are already verified as used. */
 		flow_rule_match_enc_ipv4_addrs(rule, &ipv4_addrs);
-		if (ipv4_addrs.mask->dst != cpu_to_be32(~0))
+		if (ipv4_addrs.mask->dst != cpu_to_be32(~0)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: only an exact match IPv4 destination address is supported");
 			return -EOPNOTSUPP;
+		}
 
 		flow_rule_match_enc_ports(rule, &enc_ports);
-		if (enc_ports.mask->dst != cpu_to_be16(~0))
+		if (enc_ports.mask->dst != cpu_to_be16(~0)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: only an exact match L4 destination port is supported");
 			return -EOPNOTSUPP;
+		}
 
 		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS))
 			flow_rule_match_enc_opts(rule, &enc_op);
@@ -230,12 +249,16 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			key_layer |= NFP_FLOWER_LAYER_VXLAN;
 			key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
 
-			if (enc_op.key)
+			if (enc_op.key) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: encap options not supported on vxlan tunnels");
 				return -EOPNOTSUPP;
+			}
 			break;
 		case htons(GENEVE_UDP_PORT):
-			if (!(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE))
+			if (!(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE)) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support geneve offload");
 				return -EOPNOTSUPP;
+			}
 			*tun_type = NFP_FL_TUNNEL_GENEVE;
 			key_layer |= NFP_FLOWER_LAYER_EXT_META;
 			key_size += sizeof(struct nfp_flower_ext_meta);
@@ -244,20 +267,26 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 
 			if (!enc_op.key)
 				break;
-			if (!(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE_OPT))
+			if (!(priv->flower_ext_feats &
+			      NFP_FL_FEATS_GENEVE_OPT)) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support geneve option offload");
 				return -EOPNOTSUPP;
+			}
 			err = nfp_flower_calc_opt_layer(&enc_op, &key_layer_two,
-							&key_size);
+							&key_size, extack);
 			if (err)
 				return err;
 			break;
 		default:
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: tunnel type unknown");
 			return -EOPNOTSUPP;
 		}
 
 		/* Ensure the ingress netdev matches the expected tun type. */
-		if (!nfp_fl_netdev_is_tunnel_type(netdev, *tun_type))
+		if (!nfp_fl_netdev_is_tunnel_type(netdev, *tun_type)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: ingress netdev does not match the expected tunnel type");
 			return -EOPNOTSUPP;
+		}
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC))
@@ -280,6 +309,7 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 		 * because we rely on it to get to the host.
 		 */
 		case cpu_to_be16(ETH_P_ARP):
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: ARP not supported");
 			return -EOPNOTSUPP;
 
 		case cpu_to_be16(ETH_P_MPLS_UC):
@@ -298,8 +328,10 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			/* Other ethtype - we need check the masks for the
 			 * remainder of the key to ensure we can offload.
 			 */
-			if (nfp_flower_check_higher_than_mac(flow))
+			if (nfp_flower_check_higher_than_mac(flow)) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: non IPv4/IPv6 offload with L3/L4 matches not supported");
 				return -EOPNOTSUPP;
+			}
 			break;
 		}
 	}
@@ -318,8 +350,10 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			/* Other ip proto - we need check the masks for the
 			 * remainder of the key to ensure we can offload.
 			 */
-			if (nfp_flower_check_higher_than_l3(flow))
+			if (nfp_flower_check_higher_than_l3(flow)) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unknown IP protocol with L4 matches not supported");
 				return -EOPNOTSUPP;
+			}
 			break;
 		}
 	}
@@ -331,22 +365,28 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 		flow_rule_match_tcp(rule, &tcp);
 		tcp_flags = be16_to_cpu(tcp.key->flags);
 
-		if (tcp_flags & ~NFP_FLOWER_SUPPORTED_TCPFLAGS)
+		if (tcp_flags & ~NFP_FLOWER_SUPPORTED_TCPFLAGS) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: no match support for selected TCP flags");
 			return -EOPNOTSUPP;
+		}
 
 		/* We only support PSH and URG flags when either
 		 * FIN, SYN or RST is present as well.
 		 */
 		if ((tcp_flags & (TCPHDR_PSH | TCPHDR_URG)) &&
-		    !(tcp_flags & (TCPHDR_FIN | TCPHDR_SYN | TCPHDR_RST)))
+		    !(tcp_flags & (TCPHDR_FIN | TCPHDR_SYN | TCPHDR_RST))) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: PSH and URG is only supported when used with FIN, SYN or RST");
 			return -EOPNOTSUPP;
+		}
 
 		/* We need to store TCP flags in the either the IPv4 or IPv6 key
 		 * space, thus we need to ensure we include a IPv4/IPv6 key
 		 * layer if we have not done so already.
 		 */
-		if (!basic.key)
+		if (!basic.key) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: match on TCP flags requires a match on L3 protocol");
 			return -EOPNOTSUPP;
+		}
 
 		if (!(key_layer & NFP_FLOWER_LAYER_IPV4) &&
 		    !(key_layer & NFP_FLOWER_LAYER_IPV6)) {
@@ -362,6 +402,7 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 				break;
 
 			default:
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: match on TCP flags requires a match on IPv4/IPv6");
 				return -EOPNOTSUPP;
 			}
 		}
@@ -371,8 +412,10 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 		struct flow_match_control ctl;
 
 		flow_rule_match_control(rule, &ctl);
-		if (ctl.key->flags & ~NFP_FLOWER_SUPPORTED_CTLFLAGS)
+		if (ctl.key->flags & ~NFP_FLOWER_SUPPORTED_CTLFLAGS) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: match on unknown control flag");
 			return -EOPNOTSUPP;
+		}
 	}
 
 	ret_key_ls->key_layer = key_layer;
@@ -878,11 +921,13 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 {
 	enum nfp_flower_tun_type tun_type = NFP_FL_TUNNEL_NONE;
 	struct nfp_flower_priv *priv = app->priv;
+	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *flow_pay;
 	struct nfp_fl_key_ls *key_layer;
 	struct nfp_port *port = NULL;
 	int err;
 
+	extack = flow->common.extack;
 	if (nfp_netdev_is_nfp_repr(netdev))
 		port = nfp_port_from_netdev(netdev);
 
@@ -891,7 +936,7 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 		return -ENOMEM;
 
 	err = nfp_flower_calculate_key_layers(app, netdev, key_layer, flow,
-					      &tun_type);
+					      &tun_type, extack);
 	if (err)
 		goto err_free_key_ls;
 
@@ -917,8 +962,10 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 	flow_pay->tc_flower_cookie = flow->cookie;
 	err = rhashtable_insert_fast(&priv->flow_table, &flow_pay->fl_node,
 				     nfp_flower_table_params);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot insert flow into tables for offloads");
 		goto err_release_metadata;
+	}
 
 	err = nfp_flower_xmit_flow(app, flow_pay,
 				   NFP_FLOWER_CMSG_TYPE_FLOW_ADD);
@@ -1036,16 +1083,20 @@ nfp_flower_del_offload(struct nfp_app *app, struct net_device *netdev,
 		       struct tc_cls_flower_offload *flow)
 {
 	struct nfp_flower_priv *priv = app->priv;
+	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *nfp_flow;
 	struct nfp_port *port = NULL;
 	int err;
 
+	extack = flow->common.extack;
 	if (nfp_netdev_is_nfp_repr(netdev))
 		port = nfp_port_from_netdev(netdev);
 
 	nfp_flow = nfp_flower_search_fl_table(app, flow->cookie, netdev);
-	if (!nfp_flow)
+	if (!nfp_flow) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot remove flow that does not exist");
 		return -ENOENT;
+	}
 
 	err = nfp_modify_flow_metadata(app, nfp_flow);
 	if (err)
@@ -1139,12 +1190,16 @@ nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
 		     struct tc_cls_flower_offload *flow)
 {
 	struct nfp_flower_priv *priv = app->priv;
+	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *nfp_flow;
 	u32 ctx_id;
 
+	extack = flow->common.extack;
 	nfp_flow = nfp_flower_search_fl_table(app, flow->cookie, netdev);
-	if (!nfp_flow)
+	if (!nfp_flow) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot dump stats for flow that does not exist");
 		return -EINVAL;
+	}
 
 	ctx_id = be32_to_cpu(nfp_flow->meta.host_ctx_id);
 
-- 
2.21.0

