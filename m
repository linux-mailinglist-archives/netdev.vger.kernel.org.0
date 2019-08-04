Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0851680B60
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfHDPKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38538 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfHDPKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so81900922wrr.5
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6WfVzvr+z1cFmG2/oKx8s520jC63LbTyVpNuLYSU9f0=;
        b=qoW7rmtg7KoUDFeo2NioujCfPTOFWkeYAr96fW2nRZtnlGo4JpEZdyEc12+Ao0EH6U
         P6bboKfwHkGvlHdEnmOfOOVXpB5WWgYYn3cX8FTbOjYHavmlxCZDktD0BEOvGs/zsT5N
         D7p9BQ+1BQSLknFuiB0WLEd6clWrSvOBKtU0nrhrb1Blk4bqm/eUOA5ROimd6iixmeHl
         jaJfE8TfixArWAN+53zt/kCp1OLInZRvFaP/PkQBlB4+I7o8WU6uoosWG955oroLpFGp
         7sIEJTc5ghzf2Gpg7+Ml8Hq/x7ggJU/rq3JuOUonbEoUlveYtksN2pi1a2epiTEba8qM
         Cd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6WfVzvr+z1cFmG2/oKx8s520jC63LbTyVpNuLYSU9f0=;
        b=dCrrM196r5PR1HORca4nffkFj1j1Mom0uMLTSiHaAuyMzs5nSwnUvr6sh2jTzUlzcE
         tfVQkGqqni6UBRSLDvejSYsxCuMmhpx3uTfA7yxNgajRfrLFPwAn1Pe/F1yC72wHAvrf
         De7Bpn9W9bE34QMe3aH1fZdGHlMjenp9eFZ3kGo/KOS+QFr5Qif0D7GzygeGtlnntDMF
         gn2l7VN+RQs8xm6hy8I3j483MR5KSgLdUAMxAUbncedtB8LCnaa0D1o+09O1bo06vBsk
         99bDKxSHwfq/wGpE0QPR3Ceo+LEHYQNST46I2cpbu4xHgK2X4sYfYhed27CyDTzfQqyQ
         Cc8Q==
X-Gm-Message-State: APjAAAV4q6YUBxvlm/YUBEjPeYMBSjj+6FmmBT5T4v4KLzmahYGk0Dd9
        BCCgoojGRZmUV4X8f6XX+wd+kFSU9lQ=
X-Google-Smtp-Source: APXvYqyvglc1qPvtJn29l6zVlnwYgfC+qFzqXt9FgpG7t7vBTsth5Sn/W3AUg5s3B/EEDqDDZMKMLQ==
X-Received: by 2002:adf:fc52:: with SMTP id e18mr35095280wrs.14.1564931430757;
        Sun, 04 Aug 2019 08:10:30 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:30 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 07/10] nfp: flower: verify pre-tunnel rules
Date:   Sun,  4 Aug 2019 16:09:09 +0100
Message-Id: <1564931351-1036-8-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pre-tunnel rules must direct packets to an internal port based on L2
information. Rules that egress to an internal port are already indicated
by a non-NULL device in its nfp_fl_payload struct. Verfiy the rest of the
match fields indicate that the rule is a pre-tunnel rule. This requires a
full match on the destination MAC address, an option VLAN field, and no
specific matches on other lower layer fields (with the exception of L4
proto and flags).

If a rule is identified as a pre-tunnel rule then mark it for offload to
the pre-tunnel table. Similarly, remove it from the pre-tunnel table on
rule deletion. The actual offloading of these commands is left to a
following patch.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   5 +
 .../net/ethernet/netronome/nfp/flower/offload.c    | 103 ++++++++++++++++++++-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  12 +++
 3 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 6e9de4e..c3aa415 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -283,6 +283,7 @@ struct nfp_fl_payload {
 	bool in_hw;
 	struct {
 		struct net_device *dev;
+		__be16 vlan_tci;
 	} pre_tun_rule;
 };
 
@@ -419,4 +420,8 @@ void
 nfp_flower_non_repr_priv_put(struct nfp_app *app, struct net_device *netdev);
 u32 nfp_flower_get_port_id_from_netdev(struct nfp_app *app,
 				       struct net_device *netdev);
+int nfp_flower_xmit_pre_tun_flow(struct nfp_app *app,
+				 struct nfp_fl_payload *flow);
+int nfp_flower_xmit_pre_tun_del_flow(struct nfp_app *app,
+				     struct nfp_fl_payload *flow);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index fba802a..ff8a9f1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -61,6 +61,11 @@
 	 NFP_FLOWER_LAYER_IPV4 | \
 	 NFP_FLOWER_LAYER_IPV6)
 
+#define NFP_FLOWER_PRE_TUN_RULE_FIELDS \
+	(NFP_FLOWER_LAYER_PORT | \
+	 NFP_FLOWER_LAYER_MAC | \
+	 NFP_FLOWER_LAYER_IPV4)
+
 struct nfp_flower_merge_check {
 	union {
 		struct {
@@ -1012,7 +1017,89 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 				 struct nfp_fl_payload *flow,
 				 struct netlink_ext_ack *extack)
 {
-	return -EOPNOTSUPP;
+	struct nfp_flower_meta_tci *meta_tci;
+	struct nfp_flower_mac_mpls *mac;
+	struct nfp_fl_act_head *act;
+	u8 *mask = flow->mask_data;
+	bool vlan = false;
+	int act_offset;
+	u8 key_layer;
+
+	meta_tci = (struct nfp_flower_meta_tci *)flow->unmasked_data;
+	if (meta_tci->tci & cpu_to_be16(NFP_FLOWER_MASK_VLAN_PRESENT)) {
+		u16 vlan_tci = be16_to_cpu(meta_tci->tci);
+
+		vlan_tci &= ~NFP_FLOWER_MASK_VLAN_PRESENT;
+		flow->pre_tun_rule.vlan_tci = cpu_to_be16(vlan_tci);
+		vlan = true;
+	} else {
+		flow->pre_tun_rule.vlan_tci = cpu_to_be16(0xffff);
+	}
+
+	key_layer = meta_tci->nfp_flow_key_layer;
+	if (key_layer & ~NFP_FLOWER_PRE_TUN_RULE_FIELDS) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: too many match fields");
+		return -EOPNOTSUPP;
+	}
+
+	if (!(key_layer & NFP_FLOWER_LAYER_MAC)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: MAC fields match required");
+		return -EOPNOTSUPP;
+	}
+
+	/* Skip fields known to exist. */
+	mask += sizeof(struct nfp_flower_meta_tci);
+	mask += sizeof(struct nfp_flower_in_port);
+
+	/* Ensure destination MAC address is fully matched. */
+	mac = (struct nfp_flower_mac_mpls *)mask;
+	if (!is_broadcast_ether_addr(&mac->mac_dst[0])) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: dest MAC field must not be masked");
+		return -EOPNOTSUPP;
+	}
+
+	if (key_layer & NFP_FLOWER_LAYER_IPV4) {
+		int ip_flags = offsetof(struct nfp_flower_ipv4, ip_ext.flags);
+		int ip_proto = offsetof(struct nfp_flower_ipv4, ip_ext.proto);
+		int i;
+
+		mask += sizeof(struct nfp_flower_mac_mpls);
+
+		/* Ensure proto and flags are the only IP layer fields. */
+		for (i = 0; i < sizeof(struct nfp_flower_ipv4); i++)
+			if (mask[i] && i != ip_flags && i != ip_proto) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: only flags and proto can be matched in ip header");
+				return -EOPNOTSUPP;
+			}
+	}
+
+	/* Action must be a single egress or pop_vlan and egress. */
+	act_offset = 0;
+	act = (struct nfp_fl_act_head *)&flow->action_data[act_offset];
+	if (vlan) {
+		if (act->jump_id != NFP_FL_ACTION_OPCODE_POP_VLAN) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: match on VLAN must have VLAN pop as first action");
+			return -EOPNOTSUPP;
+		}
+
+		act_offset += act->len_lw << NFP_FL_LW_SIZ;
+		act = (struct nfp_fl_act_head *)&flow->action_data[act_offset];
+	}
+
+	if (act->jump_id != NFP_FL_ACTION_OPCODE_OUTPUT) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: non egress action detected where egress was expected");
+		return -EOPNOTSUPP;
+	}
+
+	act_offset += act->len_lw << NFP_FL_LW_SIZ;
+
+	/* Ensure there are no more actions after egress. */
+	if (act_offset != flow->meta.act_len) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: egress is not the last action");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
 }
 
 /**
@@ -1083,8 +1170,11 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 		goto err_release_metadata;
 	}
 
-	err = nfp_flower_xmit_flow(app, flow_pay,
-				   NFP_FLOWER_CMSG_TYPE_FLOW_ADD);
+	if (flow_pay->pre_tun_rule.dev)
+		err = nfp_flower_xmit_pre_tun_flow(app, flow_pay);
+	else
+		err = nfp_flower_xmit_flow(app, flow_pay,
+					   NFP_FLOWER_CMSG_TYPE_FLOW_ADD);
 	if (err)
 		goto err_remove_rhash;
 
@@ -1226,8 +1316,11 @@ nfp_flower_del_offload(struct nfp_app *app, struct net_device *netdev,
 		goto err_free_merge_flow;
 	}
 
-	err = nfp_flower_xmit_flow(app, nfp_flow,
-				   NFP_FLOWER_CMSG_TYPE_FLOW_DEL);
+	if (nfp_flow->pre_tun_rule.dev)
+		err = nfp_flower_xmit_pre_tun_del_flow(app, nfp_flow);
+	else
+		err = nfp_flower_xmit_flow(app, nfp_flow,
+					   NFP_FLOWER_CMSG_TYPE_FLOW_DEL);
 	/* Fall through on error. */
 
 err_free_merge_flow:
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index a7a80f4..ef59481 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -832,6 +832,18 @@ int nfp_tunnel_mac_event_handler(struct nfp_app *app,
 	return NOTIFY_OK;
 }
 
+int nfp_flower_xmit_pre_tun_flow(struct nfp_app *app,
+				 struct nfp_fl_payload *flow)
+{
+	return -EOPNOTSUPP;
+}
+
+int nfp_flower_xmit_pre_tun_del_flow(struct nfp_app *app,
+				     struct nfp_fl_payload *flow)
+{
+	return -EOPNOTSUPP;
+}
+
 int nfp_tunnel_config_start(struct nfp_app *app)
 {
 	struct nfp_flower_priv *priv = app->priv;
-- 
2.7.4

