Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145BD1D1B60
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389702AbgEMQmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:42:00 -0400
Received: from correo.us.es ([193.147.175.20]:54032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389680AbgEMQl6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 12:41:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 32B5727F8B2
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:41:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 248051158F1
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:41:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 190AC1158EA; Wed, 13 May 2020 18:41:57 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09E1B11540C;
        Wed, 13 May 2020 18:41:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 13 May 2020 18:41:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ABF8642EF4E1;
        Wed, 13 May 2020 18:41:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com
Subject: [PATCH 7/8 net] bnxt_tc: update indirect block support
Date:   Wed, 13 May 2020 18:41:39 +0200
Message-Id: <20200513164140.7956-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200513164140.7956-1-pablo@netfilter.org>
References: <20200513164140.7956-1-pablo@netfilter.org>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.h    |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 51 +++++---------------
 2 files changed, 12 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f6a3250ef1c5..e7d1c12673bd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1857,7 +1857,6 @@ struct bnxt {
 	u8			dsn[8];
 	struct bnxt_tc_info	*tc_info;
 	struct list_head	tc_indr_block_list;
-	struct notifier_block	tc_netdev_nb;
 	struct dentry		*debugfs_pdev;
 	struct device		*hwmon_dev;
 };
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 782ea0771221..0eef4f5e4a46 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1939,53 +1939,25 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 	return 0;
 }
 
-static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
-				 enum tc_setup_type type, void *type_data)
-{
-	switch (type) {
-	case TC_SETUP_BLOCK:
-		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static bool bnxt_is_netdev_indr_offload(struct net_device *netdev)
 {
 	return netif_is_vxlan(netdev);
 }
 
-static int bnxt_tc_indr_block_event(struct notifier_block *nb,
-				    unsigned long event, void *ptr)
+static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
+				 enum tc_setup_type type, void *type_data)
 {
-	struct net_device *netdev;
-	struct bnxt *bp;
-	int rc;
-
-	netdev = netdev_notifier_info_to_dev(ptr);
 	if (!bnxt_is_netdev_indr_offload(netdev))
-		return NOTIFY_OK;
-
-	bp = container_of(nb, struct bnxt, tc_netdev_nb);
+		return -EOPNOTSUPP;
 
-	switch (event) {
-	case NETDEV_REGISTER:
-		rc = __flow_indr_block_cb_register(netdev, bp,
-						   bnxt_tc_setup_indr_cb,
-						   bp);
-		if (rc)
-			netdev_info(bp->dev,
-				    "Failed to register indirect blk: dev: %s\n",
-				    netdev->name);
-		break;
-	case NETDEV_UNREGISTER:
-		__flow_indr_block_cb_unregister(netdev,
-						bnxt_tc_setup_indr_cb,
-						bp);
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data);
+	default:
 		break;
 	}
 
-	return NOTIFY_DONE;
+	return -EOPNOTSUPP;
 }
 
 static const struct rhashtable_params bnxt_tc_flow_ht_params = {
@@ -2074,8 +2046,8 @@ int bnxt_init_tc(struct bnxt *bp)
 
 	/* init indirect block notifications */
 	INIT_LIST_HEAD(&bp->tc_indr_block_list);
-	bp->tc_netdev_nb.notifier_call = bnxt_tc_indr_block_event;
-	rc = register_netdevice_notifier(&bp->tc_netdev_nb);
+
+	rc = flow_indr_dev_register(bnxt_tc_setup_indr_cb, bp);
 	if (!rc)
 		return 0;
 
@@ -2101,7 +2073,8 @@ void bnxt_shutdown_tc(struct bnxt *bp)
 	if (!bnxt_tc_flower_enabled(bp))
 		return;
 
-	unregister_netdevice_notifier(&bp->tc_netdev_nb);
+	flow_indr_dev_unregister(bnxt_tc_setup_indr_cb, bp,
+				 bnxt_tc_setup_indr_block_cb);
 	rhashtable_destroy(&tc_info->flow_table);
 	rhashtable_destroy(&tc_info->l2_table);
 	rhashtable_destroy(&tc_info->decap_l2_table);
-- 
2.20.1

