Return-Path: <netdev+bounces-1355-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C116FD94D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:29:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 818C3281281
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0239912B80;
	Wed, 10 May 2023 08:29:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8396AB5
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:29:16 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CA35258;
	Wed, 10 May 2023 01:28:59 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A86fqL022865;
	Wed, 10 May 2023 01:28:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=x5P1UpN16iIhBVyx2vF9wFYMVwLlyy9uArfDdi6cawU=;
 b=WAsnpu2Z0HUGv/qFz1iJtNM7or6CyBPjWrY1GY+hsxO31p775KLIZTXpQawd+3Q31BfH
 3qsIOxBQpb0C9K7EaF9tdb5E9QaSA1aDzqD2Zf0X/qJ72XcjGtZX06NsQRpAvIYxahKO
 DhpM9BzQcKktzu8e07PE52p44BxDkHdamaH+bxJ13Elegfl6zmhGqocRI1h7eLpEWsI3
 5ixh7EC5RxlfOQOmSXanywXTKSO3UaLwhv7naA708+YlERcb8bD2pTCR2oY19pSiP42Z
 poqB0e1qY8Gw11uF3STcsywzB2fZj0NhHVMdatYNofpXGT81ekTnSiB1qN8JMSQ1xw/f ag== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qf77s5npa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 01:28:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 10 May
 2023 01:28:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 10 May 2023 01:28:27 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
	by maili.marvell.com (Postfix) with ESMTP id 200FF3F7043;
	Wed, 10 May 2023 01:28:20 -0700 (PDT)
From: Subbaraya Sundeep <sbhatta@marvell.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC: <saeedm@nvidia.com>, <tariqt@nvidia.com>, <roid@nvidia.com>,
        <leon@kernel.org>, <maxtram95@gmail.com>, <kliteyn@nvidia.com>,
        <irusskikh@marvell.com>, <liorna@nvidia.com>, <ehakim@nvidia.com>,
        <dbogdanov@marvell.com>, <sd@queasysnail.net>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <naveenm@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH] macsec: Use helper macsec_netdev_priv for offload drivers
Date: Wed, 10 May 2023 13:58:09 +0530
Message-ID: <1683707289-2854-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 5Mtwd_bpYo_McDl_pGvDvl7jbBYUBmmH
X-Proofpoint-GUID: 5Mtwd_bpYo_McDl_pGvDvl7jbBYUBmmH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Now macsec on top of vlan can be offloaded to macsec offloading
devices so that VLAN tag is sent in clear text on wire i.e,
packet structure is DMAC|SMAC|VLAN|SECTAG. Offloading devices can
simply enable NETIF_F_HW_MACSEC feature in netdev->vlan_features for
this to work. But the logic in offloading drivers to retrieve the
private structure from netdev needs to be changed to check whether
the netdev received is real device or a vlan device and get private
structure accordingly. This patch changes the offloading drivers to
use helper macsec_netdev_priv instead of netdev_priv.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c | 40 +++++++++++-----------
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  | 38 ++++++++++----------
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  9 -----
 include/net/macsec.h                               | 10 ++++++
 4 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 7eb5851..6afff8a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -289,7 +289,7 @@ static int aq_get_txsc_stats(struct aq_hw_s *hw, const int sc_idx,
 
 static int aq_mdo_dev_open(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	int ret = 0;
 
 	if (netif_carrier_ok(nic->ndev))
@@ -300,7 +300,7 @@ static int aq_mdo_dev_open(struct macsec_context *ctx)
 
 static int aq_mdo_dev_stop(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	int i;
 
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
@@ -439,7 +439,7 @@ static enum aq_macsec_sc_sa sc_sa_from_num_an(const int num_an)
 
 static int aq_mdo_add_secy(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	const struct macsec_secy *secy = ctx->secy;
 	enum aq_macsec_sc_sa sc_sa;
@@ -474,7 +474,7 @@ static int aq_mdo_add_secy(struct macsec_context *ctx)
 
 static int aq_mdo_upd_secy(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_secy *secy = ctx->secy;
 	int txsc_idx;
 	int ret = 0;
@@ -528,7 +528,7 @@ static int aq_clear_txsc(struct aq_nic_s *nic, const int txsc_idx,
 
 static int aq_mdo_del_secy(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	int ret = 0;
 
 	if (!nic->macsec_cfg)
@@ -576,7 +576,7 @@ static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 static int aq_mdo_add_txsa(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	const struct macsec_secy *secy = ctx->secy;
 	struct aq_macsec_txsc *aq_txsc;
@@ -603,7 +603,7 @@ static int aq_mdo_add_txsa(struct macsec_context *ctx)
 
 static int aq_mdo_upd_txsa(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	const struct macsec_secy *secy = ctx->secy;
 	struct aq_macsec_txsc *aq_txsc;
@@ -652,7 +652,7 @@ static int aq_clear_txsa(struct aq_nic_s *nic, struct aq_macsec_txsc *aq_txsc,
 
 static int aq_mdo_del_txsa(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	int txsc_idx;
 	int ret = 0;
@@ -744,7 +744,7 @@ static int aq_set_rxsc(struct aq_nic_s *nic, const u32 rxsc_idx)
 
 static int aq_mdo_add_rxsc(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	const u32 rxsc_idx_max = aq_sc_idx_max(cfg->sc_sa);
 	u32 rxsc_idx;
@@ -775,7 +775,7 @@ static int aq_mdo_add_rxsc(struct macsec_context *ctx)
 
 static int aq_mdo_upd_rxsc(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	int rxsc_idx;
 	int ret = 0;
 
@@ -838,7 +838,7 @@ static int aq_clear_rxsc(struct aq_nic_s *nic, const int rxsc_idx,
 
 static int aq_mdo_del_rxsc(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	enum aq_clear_type clear_type = AQ_CLEAR_SW;
 	int rxsc_idx;
 	int ret = 0;
@@ -906,8 +906,8 @@ static int aq_update_rxsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 static int aq_mdo_add_rxsa(struct macsec_context *ctx)
 {
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sc *rx_sc = ctx->sa.rx_sa->sc;
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
 	const struct macsec_secy *secy = ctx->secy;
 	struct aq_macsec_rxsc *aq_rxsc;
 	int rxsc_idx;
@@ -933,8 +933,8 @@ static int aq_mdo_add_rxsa(struct macsec_context *ctx)
 
 static int aq_mdo_upd_rxsa(struct macsec_context *ctx)
 {
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sc *rx_sc = ctx->sa.rx_sa->sc;
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	const struct macsec_secy *secy = ctx->secy;
 	int rxsc_idx;
@@ -982,8 +982,8 @@ static int aq_clear_rxsa(struct aq_nic_s *nic, struct aq_macsec_rxsc *aq_rxsc,
 
 static int aq_mdo_del_rxsa(struct macsec_context *ctx)
 {
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sc *rx_sc = ctx->sa.rx_sa->sc;
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	int rxsc_idx;
 	int ret = 0;
@@ -1000,7 +1000,7 @@ static int aq_mdo_del_rxsa(struct macsec_context *ctx)
 
 static int aq_mdo_get_dev_stats(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_common_stats *stats = &nic->macsec_cfg->stats;
 	struct aq_hw_s *hw = nic->aq_hw;
 
@@ -1020,7 +1020,7 @@ static int aq_mdo_get_dev_stats(struct macsec_context *ctx)
 
 static int aq_mdo_get_tx_sc_stats(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_tx_sc_stats *stats;
 	struct aq_hw_s *hw = nic->aq_hw;
 	struct aq_macsec_txsc *aq_txsc;
@@ -1044,7 +1044,7 @@ static int aq_mdo_get_tx_sc_stats(struct macsec_context *ctx)
 
 static int aq_mdo_get_tx_sa_stats(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	struct aq_macsec_tx_sa_stats *stats;
 	struct aq_hw_s *hw = nic->aq_hw;
@@ -1084,7 +1084,7 @@ static int aq_mdo_get_tx_sa_stats(struct macsec_context *ctx)
 
 static int aq_mdo_get_rx_sc_stats(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	struct aq_macsec_rx_sa_stats *stats;
 	struct aq_hw_s *hw = nic->aq_hw;
@@ -1129,7 +1129,7 @@ static int aq_mdo_get_rx_sc_stats(struct macsec_context *ctx)
 
 static int aq_mdo_get_rx_sa_stats(struct macsec_context *ctx)
 {
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);
 	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
 	struct aq_macsec_rx_sa_stats *stats;
 	struct aq_hw_s *hw = nic->aq_hw;
@@ -1399,7 +1399,7 @@ static void aq_check_txsa_expiration(struct aq_nic_s *nic)
 #define AQ_LOCKED_MDO_DEF(mdo)						\
 static int aq_locked_mdo_##mdo(struct macsec_context *ctx)		\
 {									\
-	struct aq_nic_s *nic = netdev_priv(ctx->netdev);		\
+	struct aq_nic_s *nic = macsec_netdev_priv(ctx->netdev);		\
 	int ret;							\
 	mutex_lock(&nic->macsec_mutex);					\
 	ret = aq_mdo_##mdo(ctx);					\
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index a487a98..aea4c80 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1053,7 +1053,7 @@ static void cn10k_mcs_sync_stats(struct otx2_nic *pfvf, struct macsec_secy *secy
 
 static int cn10k_mdo_open(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_secy *secy = ctx->secy;
 	struct macsec_tx_sa *sw_tx_sa;
@@ -1077,7 +1077,7 @@ static int cn10k_mdo_open(struct macsec_context *ctx)
 
 static int cn10k_mdo_stop(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct cn10k_mcs_txsc *txsc;
 	int err;
@@ -1095,7 +1095,7 @@ static int cn10k_mdo_stop(struct macsec_context *ctx)
 
 static int cn10k_mdo_add_secy(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_secy *secy = ctx->secy;
 	struct cn10k_mcs_txsc *txsc;
@@ -1129,7 +1129,7 @@ static int cn10k_mdo_add_secy(struct macsec_context *ctx)
 
 static int cn10k_mdo_upd_secy(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_secy *secy = ctx->secy;
 	struct macsec_tx_sa *sw_tx_sa;
@@ -1164,7 +1164,7 @@ static int cn10k_mdo_upd_secy(struct macsec_context *ctx)
 
 static int cn10k_mdo_del_secy(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct cn10k_mcs_txsc *txsc;
 
@@ -1183,7 +1183,7 @@ static int cn10k_mdo_del_secy(struct macsec_context *ctx)
 
 static int cn10k_mdo_add_txsa(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct macsec_tx_sa *sw_tx_sa = ctx->sa.tx_sa;
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_secy *secy = ctx->secy;
@@ -1225,7 +1225,7 @@ static int cn10k_mdo_add_txsa(struct macsec_context *ctx)
 
 static int cn10k_mdo_upd_txsa(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct macsec_tx_sa *sw_tx_sa = ctx->sa.tx_sa;
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_secy *secy = ctx->secy;
@@ -1258,7 +1258,7 @@ static int cn10k_mdo_upd_txsa(struct macsec_context *ctx)
 
 static int cn10k_mdo_del_txsa(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	u8 sa_num = ctx->sa.assoc_num;
 	struct cn10k_mcs_txsc *txsc;
@@ -1278,7 +1278,7 @@ static int cn10k_mdo_del_txsa(struct macsec_context *ctx)
 
 static int cn10k_mdo_add_rxsc(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_secy *secy = ctx->secy;
 	struct cn10k_mcs_rxsc *rxsc;
@@ -1312,7 +1312,7 @@ static int cn10k_mdo_add_rxsc(struct macsec_context *ctx)
 
 static int cn10k_mdo_upd_rxsc(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_secy *secy = ctx->secy;
 	bool enable = ctx->rx_sc->active;
@@ -1331,7 +1331,7 @@ static int cn10k_mdo_upd_rxsc(struct macsec_context *ctx)
 
 static int cn10k_mdo_del_rxsc(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct cn10k_mcs_rxsc *rxsc;
 
@@ -1349,8 +1349,8 @@ static int cn10k_mdo_del_rxsc(struct macsec_context *ctx)
 
 static int cn10k_mdo_add_rxsa(struct macsec_context *ctx)
 {
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_rx_sa *rx_sa = ctx->sa.rx_sa;
 	u64 next_pn = rx_sa->next_pn_halves.lower;
@@ -1389,8 +1389,8 @@ static int cn10k_mdo_add_rxsa(struct macsec_context *ctx)
 
 static int cn10k_mdo_upd_rxsa(struct macsec_context *ctx)
 {
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_rx_sa *rx_sa = ctx->sa.rx_sa;
 	u64 next_pn = rx_sa->next_pn_halves.lower;
@@ -1422,8 +1422,8 @@ static int cn10k_mdo_upd_rxsa(struct macsec_context *ctx)
 
 static int cn10k_mdo_del_rxsa(struct macsec_context *ctx)
 {
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	u8 sa_num = ctx->sa.assoc_num;
 	struct cn10k_mcs_rxsc *rxsc;
@@ -1445,8 +1445,8 @@ static int cn10k_mdo_del_rxsa(struct macsec_context *ctx)
 
 static int cn10k_mdo_get_dev_stats(struct macsec_context *ctx)
 {
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct mcs_secy_stats tx_rsp = { 0 }, rx_rsp = { 0 };
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_secy *secy = ctx->secy;
 	struct cn10k_mcs_txsc *txsc;
@@ -1481,7 +1481,7 @@ static int cn10k_mdo_get_dev_stats(struct macsec_context *ctx)
 
 static int cn10k_mdo_get_tx_sc_stats(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct mcs_sc_stats rsp = { 0 };
 	struct cn10k_mcs_txsc *txsc;
@@ -1502,7 +1502,7 @@ static int cn10k_mdo_get_tx_sc_stats(struct macsec_context *ctx)
 
 static int cn10k_mdo_get_tx_sa_stats(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct mcs_sa_stats rsp = { 0 };
 	u8 sa_num = ctx->sa.assoc_num;
@@ -1525,7 +1525,7 @@ static int cn10k_mdo_get_tx_sa_stats(struct macsec_context *ctx)
 
 static int cn10k_mdo_get_rx_sc_stats(struct macsec_context *ctx)
 {
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_secy *secy = ctx->secy;
 	struct mcs_sc_stats rsp = { 0 };
@@ -1567,8 +1567,8 @@ static int cn10k_mdo_get_rx_sc_stats(struct macsec_context *ctx)
 
 static int cn10k_mdo_get_rx_sa_stats(struct macsec_context *ctx)
 {
+	struct otx2_nic *pfvf = macsec_netdev_priv(ctx->netdev);
 	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
-	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct mcs_sa_stats rsp = { 0 };
 	u8 sa_num = ctx->sa.assoc_num;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 6b7b563..592b165 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -349,15 +349,6 @@ static void mlx5e_macsec_cleanup_sa(struct mlx5e_macsec *macsec,
 	sa->macsec_rule = NULL;
 }
 
-static struct mlx5e_priv *macsec_netdev_priv(const struct net_device *dev)
-{
-#if IS_ENABLED(CONFIG_VLAN_8021Q)
-	if (is_vlan_dev(dev))
-		return netdev_priv(vlan_dev_priv(dev)->real_dev);
-#endif
-	return netdev_priv(dev);
-}
-
 static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 				struct mlx5e_macsec_sa *sa,
 				bool encrypt,
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 5b9c61c..441ed8f 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -8,6 +8,7 @@
 #define _NET_MACSEC_H_
 
 #include <linux/u64_stats_sync.h>
+#include <linux/if_vlan.h>
 #include <uapi/linux/if_link.h>
 #include <uapi/linux/if_macsec.h>
 
@@ -312,4 +313,13 @@ static inline bool macsec_send_sci(const struct macsec_secy *secy)
 		(secy->n_rx_sc > 1 && !tx_sc->end_station && !tx_sc->scb);
 }
 
+static inline void *macsec_netdev_priv(const struct net_device *dev)
+{
+#if IS_ENABLED(CONFIG_VLAN_8021Q)
+	if (is_vlan_dev(dev))
+		return netdev_priv(vlan_dev_priv(dev)->real_dev);
+#endif
+	return netdev_priv(dev);
+}
+
 #endif /* _NET_MACSEC_H_ */
-- 
2.7.4


