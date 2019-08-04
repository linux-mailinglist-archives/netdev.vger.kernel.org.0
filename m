Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F7C80B63
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfHDPKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:35 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53070 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfHDPKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so72428218wms.2
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iqTAWKI1TeAWoyJKc/nzvguqrW1cq2SFQUAQM4Dl6A8=;
        b=0pDgzobeXuaraRyMQLyCfbLgAfNOmOoNrDABJcK9DrpKtwTwmjXmF2lQLW0uvqJt1Z
         txV5l+2WlKBOn8E6chJxuH3EEUIe2PU4X2OJO6SI4/jSSlllkC5NVwPzNlJbxdl2+63t
         BQuzu/Aad0whpud+JjEcRGAgO9C24Z0XJ1bcLyYMPdIPpIke2eA16l3YEF4z+xNA9LkK
         zh6RTRQcnNnCSqAezzuiveJYEXeUPb6GptQ+IQnRTkYJx65MhBnOl95Ico64qKLHf+25
         vp5kJ7itUzGreq1U/LCYFZuF2riywLPv9LI95+vBsu5nY/bPrnl3K7YgTi+ER1deVmcj
         L3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iqTAWKI1TeAWoyJKc/nzvguqrW1cq2SFQUAQM4Dl6A8=;
        b=sUm+xggG0JqyoLf2AIqDS6zr2Jzu5qmwJib/zqym//8OEqmCcwy1KMnnwHCjNVroZa
         KrpxLL3YjjIO5FfYP6A9+k4SqU2YqipxILABx9WcMj9QBLY6MRudrPWUD9+7SE5Ou0PC
         iilsLOs5FjH9wbuIwUM+f3N8OuTcl8+XBTC+1XXVLinvllYl2aR2ASkIwdlo7nxfk4WT
         cbc4qfQl891hM8IpJjp9Vc6wu7PzU9RQymo4h9PFkXTyj4UwiF5BBZokW32hJWmt7h9f
         a1YZYZ6T7G/yc0vsaMFlsvzEgg9uoABkGUrSVB6GnB50qRPT2WH1w+OhrlzfM+x2uvr3
         MEtg==
X-Gm-Message-State: APjAAAW4tZcQvVYAnKXd7WqXNf7sxehH0nMJViJpdoPUUsElyji/RnfP
        RnQBu5pUwDr6g4S/g2easAQCBtELfmk=
X-Google-Smtp-Source: APXvYqx0zKDIao+OzmqFawUBqJNGjwaV1r2zPGZwV1XYBDOwatr5wxhAVjazna+tf66nIBpgatOJEQ==
X-Received: by 2002:a1c:b457:: with SMTP id d84mr15033505wmf.153.1564931429830;
        Sun, 04 Aug 2019 08:10:29 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:29 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 06/10] nfp: flower: detect potential pre-tunnel rules
Date:   Sun,  4 Aug 2019 16:09:08 +0100
Message-Id: <1564931351-1036-7-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pre-tunnel rules are used when the tunnel end-point is on an 'internal
port'. These rules are used to direct the tunnelled packets (based on outer
header fields) to the internal port where they can be detunnelled. The
rule must send the packet to ingress the internal port at the TC layer.

Currently FW does not support an action to send to ingress so cannot
offload such rules. However, in preparation for populating the pre-tunnel
table to represent such rules, check for rules that send to the ingress of
an internal port and mark them as such. Further validation of such rules
is left to subsequent patches.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c | 40 ++++++++++++++++++----
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  4 +++
 .../net/ethernet/netronome/nfp/flower/offload.c    | 25 ++++++++++++++
 3 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index ff2f419..1b019fd 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -173,7 +173,7 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 	      struct nfp_fl_payload *nfp_flow,
 	      bool last, struct net_device *in_dev,
 	      enum nfp_flower_tun_type tun_type, int *tun_out_cnt,
-	      struct netlink_ext_ack *extack)
+	      bool pkt_host, struct netlink_ext_ack *extack)
 {
 	size_t act_size = sizeof(struct nfp_fl_output);
 	struct nfp_flower_priv *priv = app->priv;
@@ -218,6 +218,20 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 			return gid;
 		}
 		output->port = cpu_to_be32(NFP_FL_LAG_OUT | gid);
+	} else if (nfp_flower_internal_port_can_offload(app, out_dev)) {
+		if (!(priv->flower_ext_feats & NFP_FL_FEATS_PRE_TUN_RULES)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pre-tunnel rules not supported in loaded firmware");
+			return -EOPNOTSUPP;
+		}
+
+		if (nfp_flow->pre_tun_rule.dev || !pkt_host) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pre-tunnel rules require single egress dev and ptype HOST action");
+			return -EOPNOTSUPP;
+		}
+
+		nfp_flow->pre_tun_rule.dev = out_dev;
+
+		return 0;
 	} else {
 		/* Set action output parameters. */
 		output->flags = cpu_to_be16(tmp_flags);
@@ -885,7 +899,7 @@ nfp_flower_output_action(struct nfp_app *app,
 			 struct nfp_fl_payload *nfp_fl, int *a_len,
 			 struct net_device *netdev, bool last,
 			 enum nfp_flower_tun_type *tun_type, int *tun_out_cnt,
-			 int *out_cnt, u32 *csum_updated,
+			 int *out_cnt, u32 *csum_updated, bool pkt_host,
 			 struct netlink_ext_ack *extack)
 {
 	struct nfp_flower_priv *priv = app->priv;
@@ -907,7 +921,7 @@ nfp_flower_output_action(struct nfp_app *app,
 
 	output = (struct nfp_fl_output *)&nfp_fl->action_data[*a_len];
 	err = nfp_fl_output(app, output, act, nfp_fl, last, netdev, *tun_type,
-			    tun_out_cnt, extack);
+			    tun_out_cnt, pkt_host, extack);
 	if (err)
 		return err;
 
@@ -939,7 +953,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		       struct net_device *netdev,
 		       enum nfp_flower_tun_type *tun_type, int *tun_out_cnt,
 		       int *out_cnt, u32 *csum_updated,
-		       struct nfp_flower_pedit_acts *set_act,
+		       struct nfp_flower_pedit_acts *set_act, bool *pkt_host,
 		       struct netlink_ext_ack *extack, int act_idx)
 {
 	struct nfp_fl_set_ipv4_tun *set_tun;
@@ -955,17 +969,21 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 	case FLOW_ACTION_DROP:
 		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_DROP);
 		break;
+	case FLOW_ACTION_REDIRECT_INGRESS:
 	case FLOW_ACTION_REDIRECT:
 		err = nfp_flower_output_action(app, act, nfp_fl, a_len, netdev,
 					       true, tun_type, tun_out_cnt,
-					       out_cnt, csum_updated, extack);
+					       out_cnt, csum_updated, *pkt_host,
+					       extack);
 		if (err)
 			return err;
 		break;
+	case FLOW_ACTION_MIRRED_INGRESS:
 	case FLOW_ACTION_MIRRED:
 		err = nfp_flower_output_action(app, act, nfp_fl, a_len, netdev,
 					       false, tun_type, tun_out_cnt,
-					       out_cnt, csum_updated, extack);
+					       out_cnt, csum_updated, *pkt_host,
+					       extack);
 		if (err)
 			return err;
 		break;
@@ -1095,6 +1113,13 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		nfp_fl_set_mpls(set_m, act);
 		*a_len += sizeof(struct nfp_fl_set_mpls);
 		break;
+	case FLOW_ACTION_PTYPE:
+		/* TC ptype skbedit sets PACKET_HOST for ingress redirect. */
+		if (act->ptype != PACKET_HOST)
+			return -EOPNOTSUPP;
+
+		*pkt_host = true;
+		break;
 	default:
 		/* Currently we do not handle any other actions. */
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported action in action list");
@@ -1150,6 +1175,7 @@ int nfp_flower_compile_action(struct nfp_app *app,
 	struct nfp_flower_pedit_acts set_act;
 	enum nfp_flower_tun_type tun_type;
 	struct flow_action_entry *act;
+	bool pkt_host = false;
 	u32 csum_updated = 0;
 
 	memset(nfp_flow->action_data, 0, NFP_FL_MAX_A_SIZ);
@@ -1166,7 +1192,7 @@ int nfp_flower_compile_action(struct nfp_app *app,
 		err = nfp_flower_loop_action(app, act, flow, nfp_flow, &act_len,
 					     netdev, &tun_type, &tun_out_cnt,
 					     &out_cnt, &csum_updated,
-					     &set_act, extack, i);
+					     &set_act, &pkt_host, extack, i);
 		if (err)
 			return err;
 		act_cnt++;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index af9441d..6e9de4e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -42,6 +42,7 @@ struct nfp_app;
 #define NFP_FL_FEATS_VLAN_PCP		BIT(3)
 #define NFP_FL_FEATS_VF_RLIM		BIT(4)
 #define NFP_FL_FEATS_FLOW_MOD		BIT(5)
+#define NFP_FL_FEATS_PRE_TUN_RULES	BIT(6)
 #define NFP_FL_FEATS_FLOW_MERGE		BIT(30)
 #define NFP_FL_FEATS_LAG		BIT(31)
 
@@ -280,6 +281,9 @@ struct nfp_fl_payload {
 	char *action_data;
 	struct list_head linked_flows;
 	bool in_hw;
+	struct {
+		struct net_device *dev;
+	} pre_tun_rule;
 };
 
 struct nfp_fl_payload_link {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 607426c..fba802a 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -489,6 +489,7 @@ nfp_flower_allocate_new(struct nfp_fl_key_ls *key_layer)
 	flow_pay->meta.flags = 0;
 	INIT_LIST_HEAD(&flow_pay->linked_flows);
 	flow_pay->in_hw = false;
+	flow_pay->pre_tun_rule.dev = NULL;
 
 	return flow_pay;
 
@@ -997,6 +998,24 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 }
 
 /**
+ * nfp_flower_validate_pre_tun_rule()
+ * @app:	Pointer to the APP handle
+ * @flow:	Pointer to NFP flow representation of rule
+ * @extack:	Netlink extended ACK report
+ *
+ * Verifies the flow as a pre-tunnel rule.
+ *
+ * Return: negative value on error, 0 if verified.
+ */
+static int
+nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
+				 struct nfp_fl_payload *flow,
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+/**
  * nfp_flower_add_offload() - Adds a new flow to hardware.
  * @app:	Pointer to the APP handle
  * @netdev:	netdev structure.
@@ -1046,6 +1065,12 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 	if (err)
 		goto err_destroy_flow;
 
+	if (flow_pay->pre_tun_rule.dev) {
+		err = nfp_flower_validate_pre_tun_rule(app, flow_pay, extack);
+		if (err)
+			goto err_destroy_flow;
+	}
+
 	err = nfp_compile_flow_metadata(app, flow, flow_pay, netdev, extack);
 	if (err)
 		goto err_destroy_flow;
-- 
2.7.4

