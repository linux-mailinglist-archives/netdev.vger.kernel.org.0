Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA21513990
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbfEDLr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:29 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33359 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727568AbfEDLr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:26 -0400
Received: by mail-qk1-f193.google.com with SMTP id k189so222319qkc.0
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fz/mMLV5e5Ecocy/trpGegw8dvqldMpFsvQyyEHSeTA=;
        b=lmeYm+qADQLgJIl668IZE4Ms3RmNolbvs55pGTAtgRk/mnGE7ih66+aoPdSrmonKl6
         AHNZdGMNSpLpgT3IDvh74B/yBJZ2efYgIyoBjGRccWz7NMsIen8T8ldmE4ziuqms6QS8
         uzx/tF11Ol1HRP0KUbyL8LqwHaGqnzq63RascbfJZ4ul7LVGJKcOOJq+uCoL2wLcRuf/
         eTHujjvpNEm2Il6CuvLYBJQK5itRtBr0Yo2nCHucEZDYh1wx2ygFfa/1AyshJqm8b/1y
         2MSjOrgoiK3N95AbCTrYbxRgvG739lIrnpF5Ew6pT5qYHgK6WwTo/rtKb1Fs1W0ZUceN
         15bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fz/mMLV5e5Ecocy/trpGegw8dvqldMpFsvQyyEHSeTA=;
        b=Q2CNxt0IRV1MoZks3ML11gsHzhFLrjoSI39dg5AeNzVckR5TrsGQvTxy16XVBpTKBN
         A6Jt4lSmdLmgIB00DG531XA5vtOTM8tbNSulS+LUPPqLeLsgRjIKA0WpFIYi9sXkC5tz
         rP47HGOtbsVHspaDQY7HAxpxIyhzF3Rg5n/Mzxg05MwrcbOugJOWsSmM0jhYphKY/uTf
         8n7trPVPHE4wv1GSeUJizsQ2nzJvBp81inLwmXzoYLpd15HYV9PdKcUF3AussLvyGA14
         2P7iqJVdOYt0uGv/vs9m4KfXG8bhK3cf4jnJ9hcJujJBRgLPYph5IdC5x32k5OUasDGy
         hOaA==
X-Gm-Message-State: APjAAAXGVbdMFp+7AOv9dXbiHyWRCrua23uLQ4mSFNifNTo0TBzNL/bo
        GL/vju1oNQaJPp+P9gvuFNSNTw==
X-Google-Smtp-Source: APXvYqxInjl+tkkkzD14cbJr4l+dLNXhscQl+w8EDVEs+WUH6VXDyMw7jHE5EWWVu1TKWDmymWuZwg==
X-Received: by 2002:a37:4f0d:: with SMTP id d13mr12200325qkb.159.1556970445002;
        Sat, 04 May 2019 04:47:25 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:24 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 12/13] nfp: flower: add qos offload install and remove functionality.
Date:   Sat,  4 May 2019 04:46:27 -0700
Message-Id: <20190504114628.14755-13-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Add install and remove offload functionality for qos offloads. We
first check that a police filter can be implemented by the VF rate
limiting feature in hw, then we install the filter via the qos
infrastructure. Finally we implement the mechanism for removing
these types of filters.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/cmsg.h  |   2 +
 .../net/ethernet/netronome/nfp/flower/main.h  |  10 ++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 163 +++++++++++++++++-
 3 files changed, 174 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index a10c29ade5c2..743f6fd4ecd3 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -416,6 +416,8 @@ enum nfp_flower_cmsg_type_port {
 	NFP_FLOWER_CMSG_TYPE_TUN_IPS =		14,
 	NFP_FLOWER_CMSG_TYPE_FLOW_STATS =	15,
 	NFP_FLOWER_CMSG_TYPE_PORT_ECHO =	16,
+	NFP_FLOWER_CMSG_TYPE_QOS_MOD =		18,
+	NFP_FLOWER_CMSG_TYPE_QOS_DEL =		19,
 	NFP_FLOWER_CMSG_TYPE_MAX =		32,
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 16f0b8dcd8e1..25b5ceb3c197 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -188,6 +188,14 @@ struct nfp_flower_priv {
 	struct nfp_fl_internal_ports internal_ports;
 };
 
+/**
+ * struct nfp_fl_qos - Flower APP priv data for quality of service
+ * @netdev_port_id:	NFP port number of repr with qos info
+ */
+struct nfp_fl_qos {
+	u32 netdev_port_id;
+};
+
 /**
  * struct nfp_flower_repr_priv - Flower APP per-repr priv data
  * @nfp_repr:		Back pointer to nfp_repr
@@ -195,6 +203,7 @@ struct nfp_flower_priv {
  * @mac_offloaded:	Flag indicating a MAC address is offloaded for repr
  * @offloaded_mac_addr:	MAC address that has been offloaded for repr
  * @mac_list:		List entry of reprs that share the same offloaded MAC
+ * @qos_table:		Stored info on filters implementing qos
  */
 struct nfp_flower_repr_priv {
 	struct nfp_repr *nfp_repr;
@@ -202,6 +211,7 @@ struct nfp_flower_repr_priv {
 	bool mac_offloaded;
 	u8 offloaded_mac_addr[ETH_ALEN];
 	struct list_head mac_list;
+	struct nfp_fl_qos qos_table;
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 82422afa9f8b..0880a5d8e224 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -1,10 +1,162 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2019 Netronome Systems, Inc. */
 
+#include <linux/math64.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #include "cmsg.h"
 #include "main.h"
+#include "../nfp_port.h"
+
+struct nfp_police_cfg_head {
+	__be32 flags_opts;
+	__be32 port;
+};
+
+/* Police cmsg for configuring a trTCM traffic conditioner (8W/32B)
+ * See RFC 2698 for more details.
+ * ----------------------------------------------------------------
+ *    3                   2                   1
+ *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                          Flag options                         |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                          Port Ingress                         |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                        Token Bucket Peak                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                     Token Bucket Committed                    |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                         Peak Burst Size                       |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                      Committed Burst Size                     |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                      Peak Information Rate                    |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                    Committed Information Rate                 |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ */
+struct nfp_police_config {
+	struct nfp_police_cfg_head head;
+	__be32 bkt_tkn_p;
+	__be32 bkt_tkn_c;
+	__be32 pbs;
+	__be32 cbs;
+	__be32 pir;
+	__be32 cir;
+};
+
+static int
+nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
+				struct tc_cls_matchall_offload *flow,
+				struct netlink_ext_ack *extack)
+{
+	struct flow_action_entry *action = &flow->rule->action.entries[0];
+	struct nfp_flower_repr_priv *repr_priv;
+	struct nfp_police_config *config;
+	struct nfp_repr *repr;
+	struct sk_buff *skb;
+	u32 netdev_port_id;
+	u64 burst, rate;
+
+	if (!nfp_netdev_is_nfp_repr(netdev)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on higher level port");
+		return -EOPNOTSUPP;
+	}
+	repr = netdev_priv(netdev);
+
+	if (tcf_block_shared(flow->common.block)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on shared blocks");
+		return -EOPNOTSUPP;
+	}
+
+	if (repr->port->type != NFP_PORT_VF_PORT) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on non-VF ports");
+		return -EOPNOTSUPP;
+	}
+
+	if (!flow_offload_has_one_action(&flow->rule->action)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload requires a single action");
+		return -EOPNOTSUPP;
+	}
+
+	if (flow->common.prio != (1 << 16)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload requires highest priority");
+		return -EOPNOTSUPP;
+	}
+
+	if (action->id != FLOW_ACTION_POLICE) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload requires police action");
+		return -EOPNOTSUPP;
+	}
+
+	rate = action->police.rate_bytes_ps;
+	burst = div_u64(rate * PSCHED_NS2TICKS(action->police.burst),
+			PSCHED_TICKS_PER_SEC);
+	netdev_port_id = nfp_repr_get_port_id(netdev);
+
+	skb = nfp_flower_cmsg_alloc(repr->app, sizeof(struct nfp_police_config),
+				    NFP_FLOWER_CMSG_TYPE_QOS_MOD, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	config = nfp_flower_cmsg_get_data(skb);
+	memset(config, 0, sizeof(struct nfp_police_config));
+	config->head.port = cpu_to_be32(netdev_port_id);
+	config->bkt_tkn_p = cpu_to_be32(burst);
+	config->bkt_tkn_c = cpu_to_be32(burst);
+	config->pbs = cpu_to_be32(burst);
+	config->cbs = cpu_to_be32(burst);
+	config->pir = cpu_to_be32(rate);
+	config->cir = cpu_to_be32(rate);
+	nfp_ctrl_tx(repr->app->ctrl, skb);
+
+	repr_priv = repr->app_priv;
+	repr_priv->qos_table.netdev_port_id = netdev_port_id;
+
+	return 0;
+}
+
+static int
+nfp_flower_remove_rate_limiter(struct nfp_app *app, struct net_device *netdev,
+			       struct tc_cls_matchall_offload *flow,
+			       struct netlink_ext_ack *extack)
+{
+	struct nfp_flower_repr_priv *repr_priv;
+	struct nfp_police_config *config;
+	struct nfp_repr *repr;
+	struct sk_buff *skb;
+	u32 netdev_port_id;
+
+	if (!nfp_netdev_is_nfp_repr(netdev)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on higher level port");
+		return -EOPNOTSUPP;
+	}
+	repr = netdev_priv(netdev);
+
+	netdev_port_id = nfp_repr_get_port_id(netdev);
+	repr_priv = repr->app_priv;
+
+	if (!repr_priv->qos_table.netdev_port_id) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: cannot remove qos entry that does not exist");
+		return -EOPNOTSUPP;
+	}
+
+	skb = nfp_flower_cmsg_alloc(repr->app, sizeof(struct nfp_police_config),
+				    NFP_FLOWER_CMSG_TYPE_QOS_DEL, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	/* Clear all qos associate data for this interface */
+	memset(&repr_priv->qos_table, 0, sizeof(struct nfp_fl_qos));
+	config = nfp_flower_cmsg_get_data(skb);
+	memset(config, 0, sizeof(struct nfp_police_config));
+	config->head.port = cpu_to_be32(netdev_port_id);
+	nfp_ctrl_tx(repr->app->ctrl, skb);
+
+	return 0;
+}
 
 int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 				 struct tc_cls_matchall_offload *flow)
@@ -17,5 +169,14 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 		return -EOPNOTSUPP;
 	}
 
-	return -EOPNOTSUPP;
+	switch (flow->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return nfp_flower_install_rate_limiter(app, netdev, flow,
+						       extack);
+	case TC_CLSMATCHALL_DESTROY:
+		return nfp_flower_remove_rate_limiter(app, netdev, flow,
+						      extack);
+	default:
+		return -EOPNOTSUPP;
+	}
 }
-- 
2.21.0

