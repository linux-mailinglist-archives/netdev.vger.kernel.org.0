Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9840213992
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfEDLrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:32 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35432 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfEDLr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:28 -0400
Received: by mail-qt1-f196.google.com with SMTP id e5so9746449qtq.2
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TSxVGPNziGOCwmI2UtQuCfV+VUKNQ5R4pfsEo3WN+CU=;
        b=aXxQ+MJWABaapOXeeSCIVmqkJXDpWDFyzGEjlJZm7rhJUAMN0hNW4PgtOLTntPZvMc
         VAxKhnJe8OFHe8wzyLOym8Fp73VxFBuWHeWy0wA7LlYcxZweTFzRc+Xefbf9bE9IfCar
         r/dCPmbuPWjXAsEQqdL9n1deTfe09EdXFNjdzCLd6tWhAsghN5NR17uhFJ5TuKCM5LNJ
         4DKS9Z09GYDqtAv1POKGCQvTSvyWOebin3LlaeOjgIavl/+6W4Ot2zplpuSH7zcQ5Wfi
         PHGQSA17jAG8+auYk5a3MxGvFMImBHiRciYU9iWgEk2cDS2uy8h6Y2kdC565wIW+EOaG
         X1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TSxVGPNziGOCwmI2UtQuCfV+VUKNQ5R4pfsEo3WN+CU=;
        b=pNyI8rE8r+RkV0O+AUKZaeCN+ixPYYZ5NU8yfNNBkduV+rJ9b/aXmsxqxjvWwpdwBG
         s2u8oeuoCKmhObRS/Sy+RWxP+uPISR2LQWWWf7ClAFI3uuFf4Pfo+IorVfJEQ3L6Z/L1
         cPEzdrr2wCDEiRw/wqgwK3xsu+1z5mxRqMBoqIUX825nvhXUxNrccglpHObtQXhE/QX7
         +iN0h2yEsH6Zsr2dDwTsr7R4KPj0LonLABu4x8HuGxqx0JCIthbPrH2R7dixFYbCaQeh
         lNfgDK+p1dN3mGupC218sdCpLvDtIfJp8uVq4+RKRfS6CKtCXvP65Ra9dHm0dlo5ezIZ
         jgsw==
X-Gm-Message-State: APjAAAV5YFhcU6y47nNXTJuYkdxUcNgoR8q8WY68cg4PX0NfOCap5cnc
        lp4Efe45ccDIa4JKM7DU/iChIA==
X-Google-Smtp-Source: APXvYqxspQ/vB8R1P+HEkV3WCjJqysOpq8+fxHWf2Ds9S9UMAQYayDI/qqEIP6tiBShyKc85K2IXUw==
X-Received: by 2002:ac8:5188:: with SMTP id c8mr499qtn.262.1556970447206;
        Sat, 04 May 2019 04:47:27 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:26 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 13/13] nfp: flower: add qos offload stats request and reply
Date:   Sat,  4 May 2019 04:46:28 -0700
Message-Id: <20190504114628.14755-14-jakub.kicinski@netronome.com>
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

Add stats request function that sends a stats request message to hw for
a specific police-filter. Process stats reply from hw and update the
stored qos structure.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/cmsg.c  |   3 +
 .../net/ethernet/netronome/nfp/flower/cmsg.h  |   1 +
 .../net/ethernet/netronome/nfp/flower/main.c  |   6 +
 .../net/ethernet/netronome/nfp/flower/main.h  |  16 ++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 184 ++++++++++++++++++
 5 files changed, 210 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
index 7faec6887b8d..d5bbe3d6048b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
@@ -278,6 +278,9 @@ nfp_flower_cmsg_process_one_rx(struct nfp_app *app, struct sk_buff *skb)
 	case NFP_FLOWER_CMSG_TYPE_ACTIVE_TUNS:
 		nfp_tunnel_keep_alive(app, skb);
 		break;
+	case NFP_FLOWER_CMSG_TYPE_QOS_STATS:
+		nfp_flower_stats_rlim_reply(app, skb);
+		break;
 	case NFP_FLOWER_CMSG_TYPE_LAG_CONFIG:
 		if (app_priv->flower_ext_feats & NFP_FL_FEATS_LAG) {
 			skb_stored = nfp_flower_lag_unprocessed_msg(app, skb);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 743f6fd4ecd3..537f7fc19584 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -418,6 +418,7 @@ enum nfp_flower_cmsg_type_port {
 	NFP_FLOWER_CMSG_TYPE_PORT_ECHO =	16,
 	NFP_FLOWER_CMSG_TYPE_QOS_MOD =		18,
 	NFP_FLOWER_CMSG_TYPE_QOS_DEL =		19,
+	NFP_FLOWER_CMSG_TYPE_QOS_STATS =	20,
 	NFP_FLOWER_CMSG_TYPE_MAX =		32,
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index d476917c8f7d..eb846133943b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -776,6 +776,9 @@ static int nfp_flower_init(struct nfp_app *app)
 		nfp_warn(app->cpp, "Flow mod/merge not supported by FW.\n");
 	}
 
+	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
+		nfp_flower_qos_init(app);
+
 	INIT_LIST_HEAD(&app_priv->indr_block_cb_priv);
 	INIT_LIST_HEAD(&app_priv->non_repr_priv);
 
@@ -799,6 +802,9 @@ static void nfp_flower_clean(struct nfp_app *app)
 	skb_queue_purge(&app_priv->cmsg_skbs_low);
 	flush_work(&app_priv->cmsg_work);
 
+	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
+		nfp_flower_qos_cleanup(app);
+
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_LAG)
 		nfp_flower_lag_cleanup(&app_priv->nfp_lag);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 25b5ceb3c197..6a6be7285105 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -5,6 +5,7 @@
 #define __NFP_FLOWER_H__ 1
 
 #include "cmsg.h"
+#include "../nfp_net.h"
 
 #include <linux/circ_buf.h>
 #include <linux/hashtable.h>
@@ -158,6 +159,9 @@ struct nfp_fl_internal_ports {
  * @active_mem_unit:	Current active memory unit for flower rules
  * @total_mem_units:	Total number of available memory units for flower rules
  * @internal_ports:	Internal port ids used in offloaded rules
+ * @qos_stats_work:	Workqueue for qos stats processing
+ * @qos_rate_limiters:	Current active qos rate limiters
+ * @qos_stats_lock:	Lock on qos stats updates
  */
 struct nfp_flower_priv {
 	struct nfp_app *app;
@@ -186,14 +190,23 @@ struct nfp_flower_priv {
 	unsigned int active_mem_unit;
 	unsigned int total_mem_units;
 	struct nfp_fl_internal_ports internal_ports;
+	struct delayed_work qos_stats_work;
+	unsigned int qos_rate_limiters;
+	spinlock_t qos_stats_lock; /* Protect the qos stats */
 };
 
 /**
  * struct nfp_fl_qos - Flower APP priv data for quality of service
  * @netdev_port_id:	NFP port number of repr with qos info
+ * @curr_stats:		Currently stored stats updates for qos info
+ * @prev_stats:		Previously stored updates for qos info
+ * @last_update:	Stored time when last stats were updated
  */
 struct nfp_fl_qos {
 	u32 netdev_port_id;
+	struct nfp_stat_pair curr_stats;
+	struct nfp_stat_pair prev_stats;
+	u64 last_update;
 };
 
 /**
@@ -377,8 +390,11 @@ int nfp_flower_lag_populate_pre_action(struct nfp_app *app,
 				       struct nfp_fl_pre_lag *pre_act);
 int nfp_flower_lag_get_output_id(struct nfp_app *app,
 				 struct net_device *master);
+void nfp_flower_qos_init(struct nfp_app *app);
+void nfp_flower_qos_cleanup(struct nfp_app *app);
 int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 				 struct tc_cls_matchall_offload *flow);
+void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb);
 int nfp_flower_reg_indir_block_handler(struct nfp_app *app,
 				       struct net_device *netdev,
 				       unsigned long event);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 0880a5d8e224..1b2ee18d7ff9 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -9,6 +9,8 @@
 #include "main.h"
 #include "../nfp_port.h"
 
+#define NFP_FL_QOS_UPDATE		msecs_to_jiffies(1000)
+
 struct nfp_police_cfg_head {
 	__be32 flags_opts;
 	__be32 port;
@@ -47,12 +49,21 @@ struct nfp_police_config {
 	__be32 cir;
 };
 
+struct nfp_police_stats_reply {
+	struct nfp_police_cfg_head head;
+	__be64 pass_bytes;
+	__be64 pass_pkts;
+	__be64 drop_bytes;
+	__be64 drop_pkts;
+};
+
 static int
 nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 				struct tc_cls_matchall_offload *flow,
 				struct netlink_ext_ack *extack)
 {
 	struct flow_action_entry *action = &flow->rule->action.entries[0];
+	struct nfp_flower_priv *fl_priv = app->priv;
 	struct nfp_flower_repr_priv *repr_priv;
 	struct nfp_police_config *config;
 	struct nfp_repr *repr;
@@ -114,6 +125,10 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 
 	repr_priv = repr->app_priv;
 	repr_priv->qos_table.netdev_port_id = netdev_port_id;
+	fl_priv->qos_rate_limiters++;
+	if (fl_priv->qos_rate_limiters == 1)
+		schedule_delayed_work(&fl_priv->qos_stats_work,
+				      NFP_FL_QOS_UPDATE);
 
 	return 0;
 }
@@ -123,6 +138,7 @@ nfp_flower_remove_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 			       struct tc_cls_matchall_offload *flow,
 			       struct netlink_ext_ack *extack)
 {
+	struct nfp_flower_priv *fl_priv = app->priv;
 	struct nfp_flower_repr_priv *repr_priv;
 	struct nfp_police_config *config;
 	struct nfp_repr *repr;
@@ -150,6 +166,10 @@ nfp_flower_remove_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 
 	/* Clear all qos associate data for this interface */
 	memset(&repr_priv->qos_table, 0, sizeof(struct nfp_fl_qos));
+	fl_priv->qos_rate_limiters--;
+	if (!fl_priv->qos_rate_limiters)
+		cancel_delayed_work_sync(&fl_priv->qos_stats_work);
+
 	config = nfp_flower_cmsg_get_data(skb);
 	memset(config, 0, sizeof(struct nfp_police_config));
 	config->head.port = cpu_to_be32(netdev_port_id);
@@ -158,6 +178,167 @@ nfp_flower_remove_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	return 0;
 }
 
+void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb)
+{
+	struct nfp_flower_priv *fl_priv = app->priv;
+	struct nfp_flower_repr_priv *repr_priv;
+	struct nfp_police_stats_reply *msg;
+	struct nfp_stat_pair *curr_stats;
+	struct nfp_stat_pair *prev_stats;
+	struct net_device *netdev;
+	struct nfp_repr *repr;
+	u32 netdev_port_id;
+
+	msg = nfp_flower_cmsg_get_data(skb);
+	netdev_port_id = be32_to_cpu(msg->head.port);
+	rcu_read_lock();
+	netdev = nfp_app_dev_get(app, netdev_port_id, NULL);
+	if (!netdev)
+		goto exit_unlock_rcu;
+
+	repr = netdev_priv(netdev);
+	repr_priv = repr->app_priv;
+	curr_stats = &repr_priv->qos_table.curr_stats;
+	prev_stats = &repr_priv->qos_table.prev_stats;
+
+	spin_lock_bh(&fl_priv->qos_stats_lock);
+	curr_stats->pkts = be64_to_cpu(msg->pass_pkts) +
+			   be64_to_cpu(msg->drop_pkts);
+	curr_stats->bytes = be64_to_cpu(msg->pass_bytes) +
+			    be64_to_cpu(msg->drop_bytes);
+
+	if (!repr_priv->qos_table.last_update) {
+		prev_stats->pkts = curr_stats->pkts;
+		prev_stats->bytes = curr_stats->bytes;
+	}
+
+	repr_priv->qos_table.last_update = jiffies;
+	spin_unlock_bh(&fl_priv->qos_stats_lock);
+
+exit_unlock_rcu:
+	rcu_read_unlock();
+}
+
+static void
+nfp_flower_stats_rlim_request(struct nfp_flower_priv *fl_priv,
+			      u32 netdev_port_id)
+{
+	struct nfp_police_cfg_head *head;
+	struct sk_buff *skb;
+
+	skb = nfp_flower_cmsg_alloc(fl_priv->app,
+				    sizeof(struct nfp_police_cfg_head),
+				    NFP_FLOWER_CMSG_TYPE_QOS_STATS,
+				    GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	head = nfp_flower_cmsg_get_data(skb);
+	memset(head, 0, sizeof(struct nfp_police_cfg_head));
+	head->port = cpu_to_be32(netdev_port_id);
+
+	nfp_ctrl_tx(fl_priv->app->ctrl, skb);
+}
+
+static void
+nfp_flower_stats_rlim_request_all(struct nfp_flower_priv *fl_priv)
+{
+	struct nfp_reprs *repr_set;
+	int i;
+
+	rcu_read_lock();
+	repr_set = rcu_dereference(fl_priv->app->reprs[NFP_REPR_TYPE_VF]);
+	if (!repr_set)
+		goto exit_unlock_rcu;
+
+	for (i = 0; i < repr_set->num_reprs; i++) {
+		struct net_device *netdev;
+
+		netdev = rcu_dereference(repr_set->reprs[i]);
+		if (netdev) {
+			struct nfp_repr *priv = netdev_priv(netdev);
+			struct nfp_flower_repr_priv *repr_priv;
+			u32 netdev_port_id;
+
+			repr_priv = priv->app_priv;
+			netdev_port_id = repr_priv->qos_table.netdev_port_id;
+			if (!netdev_port_id)
+				continue;
+
+			nfp_flower_stats_rlim_request(fl_priv, netdev_port_id);
+		}
+	}
+
+exit_unlock_rcu:
+	rcu_read_unlock();
+}
+
+static void update_stats_cache(struct work_struct *work)
+{
+	struct delayed_work *delayed_work;
+	struct nfp_flower_priv *fl_priv;
+
+	delayed_work = to_delayed_work(work);
+	fl_priv = container_of(delayed_work, struct nfp_flower_priv,
+			       qos_stats_work);
+
+	nfp_flower_stats_rlim_request_all(fl_priv);
+	schedule_delayed_work(&fl_priv->qos_stats_work, NFP_FL_QOS_UPDATE);
+}
+
+static int
+nfp_flower_stats_rate_limiter(struct nfp_app *app, struct net_device *netdev,
+			      struct tc_cls_matchall_offload *flow,
+			      struct netlink_ext_ack *extack)
+{
+	struct nfp_flower_priv *fl_priv = app->priv;
+	struct nfp_flower_repr_priv *repr_priv;
+	struct nfp_stat_pair *curr_stats;
+	struct nfp_stat_pair *prev_stats;
+	u64 diff_bytes, diff_pkts;
+	struct nfp_repr *repr;
+
+	if (!nfp_netdev_is_nfp_repr(netdev)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on higher level port");
+		return -EOPNOTSUPP;
+	}
+	repr = netdev_priv(netdev);
+
+	repr_priv = repr->app_priv;
+	if (!repr_priv->qos_table.netdev_port_id) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: cannot find qos entry for stats update");
+		return -EOPNOTSUPP;
+	}
+
+	spin_lock_bh(&fl_priv->qos_stats_lock);
+	curr_stats = &repr_priv->qos_table.curr_stats;
+	prev_stats = &repr_priv->qos_table.prev_stats;
+	diff_pkts = curr_stats->pkts - prev_stats->pkts;
+	diff_bytes = curr_stats->bytes - prev_stats->bytes;
+	prev_stats->pkts = curr_stats->pkts;
+	prev_stats->bytes = curr_stats->bytes;
+	spin_unlock_bh(&fl_priv->qos_stats_lock);
+
+	flow_stats_update(&flow->stats, diff_bytes, diff_pkts,
+			  repr_priv->qos_table.last_update);
+	return 0;
+}
+
+void nfp_flower_qos_init(struct nfp_app *app)
+{
+	struct nfp_flower_priv *fl_priv = app->priv;
+
+	spin_lock_init(&fl_priv->qos_stats_lock);
+	INIT_DELAYED_WORK(&fl_priv->qos_stats_work, &update_stats_cache);
+}
+
+void nfp_flower_qos_cleanup(struct nfp_app *app)
+{
+	struct nfp_flower_priv *fl_priv = app->priv;
+
+	cancel_delayed_work_sync(&fl_priv->qos_stats_work);
+}
+
 int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 				 struct tc_cls_matchall_offload *flow)
 {
@@ -176,6 +357,9 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 	case TC_CLSMATCHALL_DESTROY:
 		return nfp_flower_remove_rate_limiter(app, netdev, flow,
 						      extack);
+	case TC_CLSMATCHALL_STATS:
+		return nfp_flower_stats_rate_limiter(app, netdev, flow,
+						     extack);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.21.0

