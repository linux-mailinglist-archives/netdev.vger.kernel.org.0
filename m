Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CF41E716C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438143AbgE2A0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:26:33 -0400
Received: from correo.us.es ([193.147.175.20]:44376 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438090AbgE2AZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:25:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8CD03CE61D
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D142DA702
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 71FFEDA701; Fri, 29 May 2020 02:25:57 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3DA2DA701;
        Fri, 29 May 2020 02:25:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 02:25:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 88AF7426CCB9;
        Fri, 29 May 2020 02:25:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Subject: [PATCH net-next 6/8] nfp: update indirect block support
Date:   Fri, 29 May 2020 02:25:39 +0200
Message-Id: <20200529002541.19743-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529002541.19743-1-pablo@netfilter.org>
References: <20200529002541.19743-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register ndo callback via flow_indr_dev_register() and
flow_indr_dev_unregister().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/ethernet/netronome/nfp/flower/main.c  | 11 +++---
 .../net/ethernet/netronome/nfp/flower/main.h  |  7 ++--
 .../ethernet/netronome/nfp/flower/offload.c   | 35 ++++---------------
 3 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index d054553c75e0..0410c793a488 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -830,6 +830,10 @@ static int nfp_flower_init(struct nfp_app *app)
 	if (err)
 		goto err_cleanup;
 
+	err = flow_indr_dev_register(nfp_flower_indr_setup_tc_cb, app);
+	if (err)
+		goto err_cleanup;
+
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_init(app);
 
@@ -856,6 +860,9 @@ static void nfp_flower_clean(struct nfp_app *app)
 	skb_queue_purge(&app_priv->cmsg_skbs_low);
 	flush_work(&app_priv->cmsg_work);
 
+	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
+				 nfp_flower_setup_indr_block_cb);
+
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_cleanup(app);
 
@@ -959,10 +966,6 @@ nfp_flower_netdev_event(struct nfp_app *app, struct net_device *netdev,
 			return ret;
 	}
 
-	ret = nfp_flower_reg_indir_block_handler(app, netdev, event);
-	if (ret & NOTIFY_STOP_MASK)
-		return ret;
-
 	ret = nfp_flower_internal_port_event_handler(app, netdev, event);
 	if (ret & NOTIFY_STOP_MASK)
 		return ret;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 59abea2a39ad..6c3dc3baf387 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -458,9 +458,10 @@ void nfp_flower_qos_cleanup(struct nfp_app *app);
 int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 				 struct tc_cls_matchall_offload *flow);
 void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb);
-int nfp_flower_reg_indir_block_handler(struct nfp_app *app,
-				       struct net_device *netdev,
-				       unsigned long event);
+int nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
+				enum tc_setup_type type, void *type_data);
+int nfp_flower_setup_indr_block_cb(enum tc_setup_type type, void *type_data,
+				   void *cb_priv);
 
 void
 __nfp_flower_non_repr_priv_get(struct nfp_flower_non_repr_priv *non_repr_priv);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index c694dbc239d0..10a4e86f5371 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1618,8 +1618,8 @@ nfp_flower_indr_block_cb_priv_lookup(struct nfp_app *app,
 	return NULL;
 }
 
-static int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
-					  void *type_data, void *cb_priv)
+int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
+				   void *type_data, void *cb_priv)
 {
 	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
 	struct flow_cls_offload *flower = type_data;
@@ -1707,10 +1707,13 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 	return 0;
 }
 
-static int
+int
 nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
 			    enum tc_setup_type type, void *type_data)
 {
+	if (!nfp_fl_is_netdev_to_offload(netdev))
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return nfp_flower_setup_indr_tc_block(netdev, cb_priv,
@@ -1719,29 +1722,3 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
 		return -EOPNOTSUPP;
 	}
 }
-
-int nfp_flower_reg_indir_block_handler(struct nfp_app *app,
-				       struct net_device *netdev,
-				       unsigned long event)
-{
-	int err;
-
-	if (!nfp_fl_is_netdev_to_offload(netdev))
-		return NOTIFY_OK;
-
-	if (event == NETDEV_REGISTER) {
-		err = __flow_indr_block_cb_register(netdev, app,
-						    nfp_flower_indr_setup_tc_cb,
-						    app);
-		if (err)
-			nfp_flower_cmsg_warn(app,
-					     "Indirect block reg failed - %s\n",
-					     netdev->name);
-	} else if (event == NETDEV_UNREGISTER) {
-		__flow_indr_block_cb_unregister(netdev,
-						nfp_flower_indr_setup_tc_cb,
-						app);
-	}
-
-	return NOTIFY_OK;
-}
-- 
2.20.1

