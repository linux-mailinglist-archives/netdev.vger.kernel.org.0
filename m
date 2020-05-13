Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0195C1D0AAB
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 10:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgEMIRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 04:17:50 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56454 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730127AbgEMIRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 04:17:50 -0400
Received: from penelope.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 64A5025B78C;
        Wed, 13 May 2020 18:17:48 +1000 (AEST)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 1BD98737; Wed, 13 May 2020 10:17:46 +0200 (CEST)
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     oss-drivers@netronome.com, Louis Peens <louis.peens@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-net] nfp: flower: inform firmware of flower features in the driver
Date:   Wed, 13 May 2020 10:17:23 +0200
Message-Id: <20200513081723.17624-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@netronome.com>

For backwards compatibility it may be required for the firmware to
disable certain features depending on the features supported by
the host. Combine the host feature bits and firmware feature bits
and write this back to the firmware.

Signed-off-by: Louis Peens <louis.peens@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/main.c  | 110 +++++++++++++-----
 .../net/ethernet/netronome/nfp/flower/main.h  |  11 ++
 2 files changed, 91 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index d8ad9346a26a..2830c1203c76 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -665,6 +665,81 @@ static int nfp_flower_vnic_init(struct nfp_app *app, struct nfp_net *nn)
 	return err;
 }
 
+static void nfp_flower_wait_host_bit(struct nfp_app *app)
+{
+	unsigned long err_at;
+	u64 feat;
+	int err;
+
+	/* Wait for HOST_ACK flag bit to propagate */
+	feat = nfp_rtsym_read_le(app->pf->rtbl,
+				 "_abi_flower_combined_feat_global",
+				 &err);
+	err_at = jiffies + HZ / 100;
+	while (!err && !(feat & NFP_FL_FEATS_HOST_ACK)) {
+		usleep_range(1000, 2000);
+		feat = nfp_rtsym_read_le(app->pf->rtbl,
+					 "_abi_flower_combined_feat_global",
+					 &err);
+		if (time_is_before_eq_jiffies(err_at)) {
+			nfp_warn(app->cpp,
+				 "HOST_ACK bit not propagated in FW.\n");
+			break;
+		}
+	}
+}
+
+static int nfp_flower_sync_feature_bits(struct nfp_app *app)
+{
+	struct nfp_flower_priv *app_priv = app->priv;
+	int err = 0;
+
+	/* Tell the firmware of the host supported features. */
+	err = nfp_rtsym_write_le(app->pf->rtbl, "_abi_flower_host_mask",
+				 app_priv->flower_ext_feats |
+				 NFP_FL_FEATS_HOST_ACK);
+	if (!err) {
+		nfp_flower_wait_host_bit(app);
+	} else if (err == -ENOENT) {
+		nfp_info(app->cpp,
+			 "Telling FW of host capabilities not supported.\n");
+		err = 0;
+	} else {
+		return err;
+	}
+
+	/* Tell the firmware that the driver supports lag. */
+	err = nfp_rtsym_write_le(app->pf->rtbl,
+				 "_abi_flower_balance_sync_enable", 1);
+	if (!err) {
+		app_priv->flower_ext_feats |= NFP_FL_FEATS_LAG;
+		nfp_flower_lag_init(&app_priv->nfp_lag);
+	} else if (err == -ENOENT) {
+		nfp_warn(app->cpp, "LAG not supported by FW.\n");
+		err = 0;
+	} else {
+		return err;
+	}
+
+	if (app_priv->flower_ext_feats & NFP_FL_FEATS_FLOW_MOD) {
+		/* Tell the firmware that the driver supports flow merging. */
+		err = nfp_rtsym_write_le(app->pf->rtbl,
+					 "_abi_flower_merge_hint_enable", 1);
+		if (!err) {
+			app_priv->flower_ext_feats |= NFP_FL_FEATS_FLOW_MERGE;
+			nfp_flower_internal_port_init(app_priv);
+		} else if (err == -ENOENT) {
+			nfp_warn(app->cpp,
+				 "Flow merge not supported by FW.\n");
+			err = 0;
+		}
+	} else {
+		nfp_warn(app->cpp, "Flow mod/merge not supported by FW.\n");
+	}
+
+	return err;
+}
+
 static int nfp_flower_init(struct nfp_app *app)
 {
 	u64 version, features, ctx_count, num_mems;
@@ -753,35 +828,11 @@ static int nfp_flower_init(struct nfp_app *app)
 	if (err)
 		app_priv->flower_ext_feats = 0;
 	else
-		app_priv->flower_ext_feats = features;
-
-	/* Tell the firmware that the driver supports lag. */
-	err = nfp_rtsym_write_le(app->pf->rtbl,
-				 "_abi_flower_balance_sync_enable", 1);
-	if (!err) {
-		app_priv->flower_ext_feats |= NFP_FL_FEATS_LAG;
-		nfp_flower_lag_init(&app_priv->nfp_lag);
-	} else if (err == -ENOENT) {
-		nfp_warn(app->cpp, "LAG not supported by FW.\n");
-	} else {
-		goto err_cleanup_metadata;
-	}
+		app_priv->flower_ext_feats = features & NFP_FL_FEATS_HOST;
 
-	if (app_priv->flower_ext_feats & NFP_FL_FEATS_FLOW_MOD) {
-		/* Tell the firmware that the driver supports flow merging. */
-		err = nfp_rtsym_write_le(app->pf->rtbl,
-					 "_abi_flower_merge_hint_enable", 1);
-		if (!err) {
-			app_priv->flower_ext_feats |= NFP_FL_FEATS_FLOW_MERGE;
-			nfp_flower_internal_port_init(app_priv);
-		} else if (err == -ENOENT) {
-			nfp_warn(app->cpp, "Flow merge not supported by FW.\n");
-		} else {
-			goto err_lag_clean;
-		}
-	} else {
-		nfp_warn(app->cpp, "Flow mod/merge not supported by FW.\n");
-	}
+	err = nfp_flower_sync_feature_bits(app);
+	if (err)
+		goto err_cleanup;
 
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_init(app);
@@ -792,10 +843,9 @@ static int nfp_flower_init(struct nfp_app *app)
 
 	return 0;
 
-err_lag_clean:
+err_cleanup:
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_LAG)
 		nfp_flower_lag_cleanup(&app_priv->nfp_lag);
-err_cleanup_metadata:
 	nfp_flower_metadata_cleanup(app);
 err_free_app_priv:
 	vfree(app->priv);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index d55d0d33bc45..dfc07611603e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -44,9 +44,20 @@ struct nfp_app;
 #define NFP_FL_FEATS_FLOW_MOD		BIT(5)
 #define NFP_FL_FEATS_PRE_TUN_RULES	BIT(6)
 #define NFP_FL_FEATS_IPV6_TUN		BIT(7)
+#define NFP_FL_FEATS_HOST_ACK		BIT(31)
 #define NFP_FL_FEATS_FLOW_MERGE		BIT(30)
 #define NFP_FL_FEATS_LAG		BIT(31)
 
+#define NFP_FL_FEATS_HOST \
+	(NFP_FL_FEATS_GENEVE | \
+	NFP_FL_NBI_MTU_SETTING | \
+	NFP_FL_FEATS_GENEVE_OPT | \
+	NFP_FL_FEATS_VLAN_PCP | \
+	NFP_FL_FEATS_VF_RLIM | \
+	NFP_FL_FEATS_FLOW_MOD | \
+	NFP_FL_FEATS_PRE_TUN_RULES | \
+	NFP_FL_FEATS_IPV6_TUN)
+
 struct nfp_fl_mask_id {
 	struct circ_buf mask_id_free_list;
 	ktime_t *last_used;
-- 
2.20.1

