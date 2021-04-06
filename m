Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4376B355895
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 17:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346103AbhDFPzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 11:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346083AbhDFPzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 11:55:38 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C579C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 08:55:30 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z1so17189233edb.8
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 08:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xco1pQThxSOpUExi7jQoxzuSiyToJNx7WSISppT7SWQ=;
        b=kleKC7Uyz6oXpzjGtfGGNUKbsL/lP6N9uF0HjfNOCplg2Fc+IfnNqzQdiElVZzdlcx
         vEj4X4ZnF+NfefySdbE08tRU7bD46cniO6dq0nWzmTPytMpcb+2KvU+yVv0izvR1o5Bm
         LbcpjmTSVb3uSk3rcjJwJw+kJLvVBIx/jBjWoQcP1To2i7L1ZUDrkJEEcVRrc8k3jH51
         +m3Jz4SGEfxyuukskTARwUaBh1lzeMJ8eMgKKdXmR4MTYpmOALlsLAc92lnYbXpcYh0K
         wzlcpOXC711/msiqFnE4F2qzF35WM0uVcCL2bKjKtnjKDgPw/c+AdHWzkR0bFbjrKoCa
         qkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xco1pQThxSOpUExi7jQoxzuSiyToJNx7WSISppT7SWQ=;
        b=egz0rOR1g8RzU6BE7Xjb50PMbd8h52oCjTlPRwp0jNfigLc9rwXZQwR0e8FJR0KSnS
         2Wf8iHLMPMhTsQHC/YJVnwmNo7yI5NNsXRrY+I7eHZXCq0VqxHI9QnrsSuxE7YZKBj2A
         PDKJVkAWXZbSUk5O45QodZ016GihAyv34KZVGmG9ixF4l97my8ykQH6jT+uHp5HGBAu2
         XACf6S6Bwp8lcgeZ5ZjGXMH0j9B/EFblcmzmUqi8Cd/h2B0QT3h9IpHhliPI1x/SeDh4
         8NIRaTT0aFM3NRwZ5cPjGlb3+p3aJT/HJEU8l5gIofpivvBfHDNekEMIaAcJj1LEm/E1
         QCeQ==
X-Gm-Message-State: AOAM532FAjgOPOvHWhlsSw56UHkTqev/x80ab6WlaTYAf/yawFPLP6dt
        zhrHQYF1WLWV/c9IGAOn++Y1bQ==
X-Google-Smtp-Source: ABdhPJwTZrR7DUtw+VPsuk0sLSHnY+Awb1+jzO5o5b7aMFxALk6Mgp0IsQKyt1jUekJwKzFfgXWI4Q==
X-Received: by 2002:a05:6402:35c9:: with SMTP id z9mr38599398edc.94.1617724528760;
        Tue, 06 Apr 2021 08:55:28 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id j6sm11303395edw.73.2021.04.06.08.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 08:55:27 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Peng Zhang <peng.zhang@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: [PATCH net-next] nfp: flower: add support for packet-per-second policing
Date:   Tue,  6 Apr 2021 17:54:52 +0200
Message-Id: <20210406155452.23974-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Zhang <peng.zhang@corigine.com>

Allow hardware offload of a policer action attached to a matchall filter
which enforces a packets-per-second rate-limit.

e.g.
tc filter add dev tap1 parent ffff: u32 match \
        u32 0 0 police pkts_rate 3000 pkts_burst 1000

Signed-off-by: Peng Zhang <peng.zhang@corigine.com>
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |   4 +-
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 161 +++++++++++++-----
 2 files changed, 119 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index caf12eec9945..e13e26e72ca0 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -47,6 +47,7 @@ struct nfp_app;
 #define NFP_FL_FEATS_PRE_TUN_RULES	BIT(6)
 #define NFP_FL_FEATS_IPV6_TUN		BIT(7)
 #define NFP_FL_FEATS_VLAN_QINQ		BIT(8)
+#define NFP_FL_FEATS_QOS_PPS		BIT(9)
 #define NFP_FL_FEATS_HOST_ACK		BIT(31)
 
 #define NFP_FL_ENABLE_FLOW_MERGE	BIT(0)
@@ -61,7 +62,8 @@ struct nfp_app;
 	NFP_FL_FEATS_FLOW_MOD | \
 	NFP_FL_FEATS_PRE_TUN_RULES | \
 	NFP_FL_FEATS_IPV6_TUN | \
-	NFP_FL_FEATS_VLAN_QINQ)
+	NFP_FL_FEATS_VLAN_QINQ | \
+	NFP_FL_FEATS_QOS_PPS)
 
 struct nfp_fl_mask_id {
 	struct circ_buf mask_id_free_list;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 88bea6ad59bc..784c6dbf8bc4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -10,19 +10,26 @@
 #include "../nfp_port.h"
 
 #define NFP_FL_QOS_UPDATE		msecs_to_jiffies(1000)
+#define NFP_FL_QOS_PPS  BIT(15)
 
 struct nfp_police_cfg_head {
 	__be32 flags_opts;
 	__be32 port;
 };
 
+enum NFP_FL_QOS_TYPES {
+	NFP_FL_QOS_TYPE_BPS,
+	NFP_FL_QOS_TYPE_PPS,
+	NFP_FL_QOS_TYPE_MAX,
+};
+
 /* Police cmsg for configuring a trTCM traffic conditioner (8W/32B)
  * See RFC 2698 for more details.
  * ----------------------------------------------------------------
  *    3                   2                   1
  *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
- * |                          Flag options                         |
+ * |             Reserved          |p|         Reserved            |
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  * |                          Port Ingress                         |
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
@@ -38,6 +45,9 @@ struct nfp_police_cfg_head {
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  * |                    Committed Information Rate                 |
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * Word[0](FLag options):
+ * [15] p(pps) 1 for pps ,0 for bps
+ *
  */
 struct nfp_police_config {
 	struct nfp_police_cfg_head head;
@@ -62,13 +72,18 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 				struct tc_cls_matchall_offload *flow,
 				struct netlink_ext_ack *extack)
 {
-	struct flow_action_entry *action = &flow->rule->action.entries[0];
+	struct flow_action_entry *paction = &flow->rule->action.entries[0];
+	u32 action_num = flow->rule->action.num_entries;
 	struct nfp_flower_priv *fl_priv = app->priv;
+	struct flow_action_entry *action = NULL;
 	struct nfp_flower_repr_priv *repr_priv;
 	struct nfp_police_config *config;
+	u32 netdev_port_id, i;
 	struct nfp_repr *repr;
 	struct sk_buff *skb;
-	u32 netdev_port_id;
+	bool pps_support;
+	u32 bps_num = 0;
+	u32 pps_num = 0;
 	u32 burst;
 	u64 rate;
 
@@ -78,6 +93,8 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	}
 	repr = netdev_priv(netdev);
 	repr_priv = repr->app_priv;
+	netdev_port_id = nfp_repr_get_port_id(netdev);
+	pps_support = !!(fl_priv->flower_ext_feats & NFP_FL_FEATS_QOS_PPS);
 
 	if (repr_priv->block_shared) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on shared blocks");
@@ -89,9 +106,18 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 		return -EOPNOTSUPP;
 	}
 
-	if (!flow_offload_has_one_action(&flow->rule->action)) {
-		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload requires a single action");
-		return -EOPNOTSUPP;
+	if (pps_support) {
+		if (action_num > 2 || action_num == 0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported offload: qos rate limit offload only support action number 1 or 2");
+			return -EOPNOTSUPP;
+		}
+	} else {
+		if (!flow_offload_has_one_action(&flow->rule->action)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported offload: qos rate limit offload requires a single action");
+			return -EOPNOTSUPP;
+		}
 	}
 
 	if (flow->common.prio != 1) {
@@ -99,36 +125,69 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 		return -EOPNOTSUPP;
 	}
 
-	if (action->id != FLOW_ACTION_POLICE) {
-		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload requires police action");
-		return -EOPNOTSUPP;
-	}
-
-	if (action->police.rate_pkt_ps) {
-		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not support packets per second");
-		return -EOPNOTSUPP;
+	for (i = 0 ; i < action_num; i++) {
+		action = paction + i;
+		if (action->id != FLOW_ACTION_POLICE) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported offload: qos rate limit offload requires police action");
+			return -EOPNOTSUPP;
+		}
+		if (action->police.rate_bytes_ps > 0) {
+			if (bps_num++) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "unsupported offload: qos rate limit offload only support one BPS action");
+				return -EOPNOTSUPP;
+			}
+		}
+		if (action->police.rate_pkt_ps > 0) {
+			if (!pps_support) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "unsupported offload: FW does not support PPS action");
+				return -EOPNOTSUPP;
+			}
+			if (pps_num++) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "unsupported offload: qos rate limit offload only support one PPS action");
+				return -EOPNOTSUPP;
+			}
+		}
 	}
 
-	rate = action->police.rate_bytes_ps;
-	burst = action->police.burst;
-	netdev_port_id = nfp_repr_get_port_id(netdev);
-
-	skb = nfp_flower_cmsg_alloc(repr->app, sizeof(struct nfp_police_config),
-				    NFP_FLOWER_CMSG_TYPE_QOS_MOD, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-
-	config = nfp_flower_cmsg_get_data(skb);
-	memset(config, 0, sizeof(struct nfp_police_config));
-	config->head.port = cpu_to_be32(netdev_port_id);
-	config->bkt_tkn_p = cpu_to_be32(burst);
-	config->bkt_tkn_c = cpu_to_be32(burst);
-	config->pbs = cpu_to_be32(burst);
-	config->cbs = cpu_to_be32(burst);
-	config->pir = cpu_to_be32(rate);
-	config->cir = cpu_to_be32(rate);
-	nfp_ctrl_tx(repr->app->ctrl, skb);
+	for (i = 0 ; i < action_num; i++) {
+		/* Set QoS data for this interface */
+		action = paction + i;
+		if (action->police.rate_bytes_ps > 0) {
+			rate = action->police.rate_bytes_ps;
+			burst = action->police.burst;
+		} else if (action->police.rate_pkt_ps > 0) {
+			rate = action->police.rate_pkt_ps;
+			burst = action->police.burst_pkt;
+		} else {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported offload: qos rate limit is not BPS or PPS");
+			continue;
+		}
 
+		if (rate != 0) {
+			skb = nfp_flower_cmsg_alloc(repr->app, sizeof(struct nfp_police_config),
+						    NFP_FLOWER_CMSG_TYPE_QOS_MOD, GFP_KERNEL);
+			if (!skb)
+				return -ENOMEM;
+
+			config = nfp_flower_cmsg_get_data(skb);
+			memset(config, 0, sizeof(struct nfp_police_config));
+			if (action->police.rate_pkt_ps > 0)
+				config->head.flags_opts = cpu_to_be32(NFP_FL_QOS_PPS);
+			config->head.port = cpu_to_be32(netdev_port_id);
+			config->bkt_tkn_p = cpu_to_be32(burst);
+			config->bkt_tkn_c = cpu_to_be32(burst);
+			config->pbs = cpu_to_be32(burst);
+			config->cbs = cpu_to_be32(burst);
+			config->pir = cpu_to_be32(rate);
+			config->cir = cpu_to_be32(rate);
+			nfp_ctrl_tx(repr->app->ctrl, skb);
+		}
+	}
 	repr_priv->qos_table.netdev_port_id = netdev_port_id;
 	fl_priv->qos_rate_limiters++;
 	if (fl_priv->qos_rate_limiters == 1)
@@ -146,9 +205,10 @@ nfp_flower_remove_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	struct nfp_flower_priv *fl_priv = app->priv;
 	struct nfp_flower_repr_priv *repr_priv;
 	struct nfp_police_config *config;
+	u32 netdev_port_id, i;
 	struct nfp_repr *repr;
 	struct sk_buff *skb;
-	u32 netdev_port_id;
+	bool pps_support;
 
 	if (!nfp_netdev_is_nfp_repr(netdev)) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on higher level port");
@@ -158,27 +218,38 @@ nfp_flower_remove_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 
 	netdev_port_id = nfp_repr_get_port_id(netdev);
 	repr_priv = repr->app_priv;
+	pps_support = !!(fl_priv->flower_ext_feats & NFP_FL_FEATS_QOS_PPS);
 
 	if (!repr_priv->qos_table.netdev_port_id) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: cannot remove qos entry that does not exist");
 		return -EOPNOTSUPP;
 	}
 
-	skb = nfp_flower_cmsg_alloc(repr->app, sizeof(struct nfp_police_config),
-				    NFP_FLOWER_CMSG_TYPE_QOS_DEL, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-
-	/* Clear all qos associate data for this interface */
 	memset(&repr_priv->qos_table, 0, sizeof(struct nfp_fl_qos));
 	fl_priv->qos_rate_limiters--;
 	if (!fl_priv->qos_rate_limiters)
 		cancel_delayed_work_sync(&fl_priv->qos_stats_work);
-
-	config = nfp_flower_cmsg_get_data(skb);
-	memset(config, 0, sizeof(struct nfp_police_config));
-	config->head.port = cpu_to_be32(netdev_port_id);
-	nfp_ctrl_tx(repr->app->ctrl, skb);
+	for (i = 0 ; i < NFP_FL_QOS_TYPE_MAX; i++) {
+		if (i == NFP_FL_QOS_TYPE_PPS && !pps_support)
+			break;
+		/* 0:bps 1:pps
+		 * Clear QoS data for this interface.
+		 * There is no need to check if a specific QOS_TYPE was
+		 * configured as the firmware handles clearing a QoS entry
+		 * safely, even if it wasn't explicitly added.
+		 */
+		skb = nfp_flower_cmsg_alloc(repr->app, sizeof(struct nfp_police_config),
+					    NFP_FLOWER_CMSG_TYPE_QOS_DEL, GFP_KERNEL);
+		if (!skb)
+			return -ENOMEM;
+
+		config = nfp_flower_cmsg_get_data(skb);
+		memset(config, 0, sizeof(struct nfp_police_config));
+		if (i == NFP_FL_QOS_TYPE_PPS)
+			config->head.flags_opts = cpu_to_be32(NFP_FL_QOS_PPS);
+		config->head.port = cpu_to_be32(netdev_port_id);
+		nfp_ctrl_tx(repr->app->ctrl, skb);
+	}
 
 	return 0;
 }
-- 
2.20.1

