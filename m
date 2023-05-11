Return-Path: <netdev+bounces-1666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 777866FEBA1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 317541C20ED7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 06:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE2221CF0;
	Thu, 11 May 2023 06:17:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAC263F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:17:30 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD1F3A89
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 23:17:28 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ANlOUm015970;
	Wed, 10 May 2023 23:17:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=6T1JXCxnyfHxKLaf253vIaMIOPH6rR8adAwSWbrAcLc=;
 b=BcL7kZm44KhK4YJxhdm3qI5zAFXWwPGq33ce8KrMZR4UtYghVDLvr+E0cGFNuq42yprQ
 W6iF9U+EK4Gsf007F1oMq3FYtUF2bcmpIhhdJdM6LCKkAG6UTP4oH4KbOwGON2ieWCSP
 wSclaYJ9r7SBj/lfy6j7S3bAHYfne7m+lMB0cUOiVPy/JvTgXVTAWZ3bKfeJJO7c0XNA
 8DEZZR1hy6GAg/j7cFQ8dq1SSR8tG1cdvkNY5RHVYrsAtL6V386+hKTT+zJbuqkDEzML
 +FyMP938KpoDNGOer/4Sv9/2JHQZw2fdGvg+CJgigtW1SU2AgxOZ0IpIsRsVkaV0OK40 fA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qgd223hkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 23:17:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 10 May
 2023 23:17:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 10 May 2023 23:17:20 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
	by maili.marvell.com (Postfix) with ESMTP id 06E773F704C;
	Wed, 10 May 2023 23:17:13 -0700 (PDT)
From: Subbaraya Sundeep <sbhatta@marvell.com>
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC: <gakula@marvell.com>, <naveenm@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
        "Sunil
 Kovvuri Goutham" <sgoutham@marvell.com>
Subject: [net-next PATCH v2] octeontx2-pf: mcs: Offload extended packet number(XPN) feature
Date: Thu, 11 May 2023 11:47:12 +0530
Message-ID: <1683785832-13047-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: S4P72XjjxZdFP7Em_dl8k_6c6VmxCTnU
X-Proofpoint-ORIG-GUID: S4P72XjjxZdFP7Em_dl8k_6c6VmxCTnU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The macsec hardware block supports XPN cipher suites also.
Hence added changes to offload XPN feature. Changes include
configuring SecY policy to XPN cipher suite, Salt and SSCI values.
64 bit packet number is passed instead of 32 bit packet number.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
v2:
 Fixed sparse warnings by using (__force u64)

 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  | 89 +++++++++++++++++-----
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  5 ++
 2 files changed, 75 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index aea4c80..8eaa50d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -6,7 +6,6 @@
 
 #include <linux/rtnetlink.h>
 #include <linux/bitfield.h>
-#include <net/macsec.h>
 #include "otx2_common.h"
 
 #define MCS_TCAM0_MAC_DA_MASK		GENMASK_ULL(47, 0)
@@ -212,6 +211,7 @@ static int cn10k_mcs_write_rx_secy(struct otx2_nic *pfvf,
 	struct mcs_secy_plcy_write_req *req;
 	struct mbox *mbox = &pfvf->mbox;
 	u64 policy;
+	u8 cipher;
 	int ret;
 
 	mutex_lock(&mbox->lock);
@@ -227,7 +227,21 @@ static int cn10k_mcs_write_rx_secy(struct otx2_nic *pfvf,
 		policy |= MCS_RX_SECY_PLCY_RP;
 
 	policy |= MCS_RX_SECY_PLCY_AUTH_ENA;
-	policy |= FIELD_PREP(MCS_RX_SECY_PLCY_CIP, MCS_GCM_AES_128);
+
+	switch (secy->key_len) {
+	case 16:
+		cipher = secy->xpn ? MCS_GCM_AES_XPN_128 : MCS_GCM_AES_128;
+		break;
+	case 32:
+		cipher = secy->xpn ? MCS_GCM_AES_XPN_256 : MCS_GCM_AES_256;
+		break;
+	default:
+		cipher = MCS_GCM_AES_128;
+		dev_warn(pfvf->dev, "Unsupported key length\n");
+		break;
+	};
+
+	policy |= FIELD_PREP(MCS_RX_SECY_PLCY_CIP, cipher);
 	policy |= FIELD_PREP(MCS_RX_SECY_PLCY_VAL, secy->validate_frames);
 
 	policy |= MCS_RX_SECY_PLCY_ENA;
@@ -323,9 +337,12 @@ static int cn10k_mcs_write_rx_sa_plcy(struct otx2_nic *pfvf,
 {
 	unsigned char *src = rxsc->sa_key[assoc_num];
 	struct mcs_sa_plcy_write_req *plcy_req;
+	u8 *salt_p = rxsc->salt[assoc_num];
 	struct mcs_rx_sc_sa_map *map_req;
 	struct mbox *mbox = &pfvf->mbox;
+	u64 ssci_salt_95_64 = 0;
 	u8 reg, key_len;
+	u64 salt_63_0;
 	int ret;
 
 	mutex_lock(&mbox->lock);
@@ -349,6 +366,15 @@ static int cn10k_mcs_write_rx_sa_plcy(struct otx2_nic *pfvf,
 		reg++;
 	}
 
+	if (secy->xpn) {
+		memcpy((u8 *)&salt_63_0, salt_p, 8);
+		memcpy((u8 *)&ssci_salt_95_64, salt_p + 8, 4);
+		ssci_salt_95_64 |= (__force u64)rxsc->ssci[assoc_num] << 32;
+
+		plcy_req->plcy[0][6] = salt_63_0;
+		plcy_req->plcy[0][7] = ssci_salt_95_64;
+	}
+
 	plcy_req->sa_index[0] = rxsc->hw_sa_id[assoc_num];
 	plcy_req->sa_cnt = 1;
 	plcy_req->dir = MCS_RX;
@@ -404,6 +430,7 @@ static int cn10k_mcs_write_tx_secy(struct otx2_nic *pfvf,
 	u8 tag_offset = 12;
 	u8 sectag_tci = 0;
 	u64 policy;
+	u8 cipher;
 	int ret;
 
 	sw_tx_sc = &secy->tx_sc;
@@ -434,7 +461,21 @@ static int cn10k_mcs_write_tx_secy(struct otx2_nic *pfvf,
 	policy |= FIELD_PREP(MCS_TX_SECY_PLCY_ST_OFFSET, tag_offset);
 	policy |= MCS_TX_SECY_PLCY_INS_MODE;
 	policy |= MCS_TX_SECY_PLCY_AUTH_ENA;
-	policy |= FIELD_PREP(MCS_TX_SECY_PLCY_CIP, MCS_GCM_AES_128);
+
+	switch (secy->key_len) {
+	case 16:
+		cipher = secy->xpn ? MCS_GCM_AES_XPN_128 : MCS_GCM_AES_128;
+		break;
+	case 32:
+		cipher = secy->xpn ? MCS_GCM_AES_XPN_256 : MCS_GCM_AES_256;
+		break;
+	default:
+		cipher = MCS_GCM_AES_128;
+		dev_warn(pfvf->dev, "Unsupported key length\n");
+		break;
+	};
+
+	policy |= FIELD_PREP(MCS_TX_SECY_PLCY_CIP, cipher);
 
 	if (secy->protect_frames)
 		policy |= MCS_TX_SECY_PLCY_PROTECT;
@@ -544,8 +585,11 @@ static int cn10k_mcs_write_tx_sa_plcy(struct otx2_nic *pfvf,
 {
 	unsigned char *src = txsc->sa_key[assoc_num];
 	struct mcs_sa_plcy_write_req *plcy_req;
+	u8 *salt_p = txsc->salt[assoc_num];
 	struct mbox *mbox = &pfvf->mbox;
+	u64 ssci_salt_95_64 = 0;
 	u8 reg, key_len;
+	u64 salt_63_0;
 	int ret;
 
 	mutex_lock(&mbox->lock);
@@ -561,6 +605,15 @@ static int cn10k_mcs_write_tx_sa_plcy(struct otx2_nic *pfvf,
 		reg++;
 	}
 
+	if (secy->xpn) {
+		memcpy((u8 *)&salt_63_0, salt_p, 8);
+		memcpy((u8 *)&ssci_salt_95_64, salt_p + 8, 4);
+		ssci_salt_95_64 |= (__force u64)txsc->ssci[assoc_num] << 32;
+
+		plcy_req->plcy[0][6] = salt_63_0;
+		plcy_req->plcy[0][7] = ssci_salt_95_64;
+	}
+
 	plcy_req->plcy[0][8] = assoc_num;
 	plcy_req->sa_index[0] = txsc->hw_sa_id[assoc_num];
 	plcy_req->sa_cnt = 1;
@@ -922,8 +975,7 @@ static int cn10k_mcs_secy_tx_cfg(struct otx2_nic *pfvf, struct macsec_secy *secy
 {
 	if (sw_tx_sa) {
 		cn10k_mcs_write_tx_sa_plcy(pfvf, secy, txsc, sa_num);
-		cn10k_write_tx_sa_pn(pfvf, txsc, sa_num,
-				     sw_tx_sa->next_pn_halves.lower);
+		cn10k_write_tx_sa_pn(pfvf, txsc, sa_num, sw_tx_sa->next_pn);
 		cn10k_mcs_link_tx_sa2sc(pfvf, secy, txsc, sa_num,
 					sw_tx_sa->active);
 	}
@@ -959,7 +1011,7 @@ static int cn10k_mcs_secy_rx_cfg(struct otx2_nic *pfvf,
 			cn10k_mcs_write_rx_sa_plcy(pfvf, secy, mcs_rx_sc,
 						   sa_num, sw_rx_sa->active);
 			cn10k_mcs_write_rx_sa_pn(pfvf, mcs_rx_sc, sa_num,
-						 sw_rx_sa->next_pn_halves.lower);
+						 sw_rx_sa->next_pn);
 		}
 
 		cn10k_mcs_write_rx_flowid(pfvf, mcs_rx_sc, hw_secy_id);
@@ -1103,13 +1155,6 @@ static int cn10k_mdo_add_secy(struct macsec_context *ctx)
 	if (secy->icv_len != MACSEC_DEFAULT_ICV_LEN)
 		return -EOPNOTSUPP;
 
-	/* Stick to 16 bytes key len until XPN support is added */
-	if (secy->key_len != 16)
-		return -EOPNOTSUPP;
-
-	if (secy->xpn)
-		return -EOPNOTSUPP;
-
 	txsc = cn10k_mcs_create_txsc(pfvf);
 	if (IS_ERR(txsc))
 		return -ENOSPC;
@@ -1202,6 +1247,9 @@ static int cn10k_mdo_add_txsa(struct macsec_context *ctx)
 		return -ENOSPC;
 
 	memcpy(&txsc->sa_key[sa_num], ctx->sa.key, secy->key_len);
+	memcpy(&txsc->salt[sa_num], sw_tx_sa->key.salt.bytes, MACSEC_SALT_LEN);
+	txsc->ssci[sa_num] = sw_tx_sa->ssci;
+
 	txsc->sa_bmap |= 1 << sa_num;
 
 	if (netif_running(secy->netdev)) {
@@ -1210,7 +1258,7 @@ static int cn10k_mdo_add_txsa(struct macsec_context *ctx)
 			return err;
 
 		err = cn10k_write_tx_sa_pn(pfvf, txsc, sa_num,
-					   sw_tx_sa->next_pn_halves.lower);
+					   sw_tx_sa->next_pn);
 		if (err)
 			return err;
 
@@ -1243,7 +1291,7 @@ static int cn10k_mdo_upd_txsa(struct macsec_context *ctx)
 	if (netif_running(secy->netdev)) {
 		/* Keys cannot be changed after creation */
 		err = cn10k_write_tx_sa_pn(pfvf, txsc, sa_num,
-					   sw_tx_sa->next_pn_halves.lower);
+					   sw_tx_sa->next_pn);
 		if (err)
 			return err;
 
@@ -1353,7 +1401,6 @@ static int cn10k_mdo_add_rxsa(struct macsec_context *ctx)
 	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_rx_sa *rx_sa = ctx->sa.rx_sa;
-	u64 next_pn = rx_sa->next_pn_halves.lower;
 	struct macsec_secy *secy = ctx->secy;
 	bool sa_in_use = rx_sa->active;
 	u8 sa_num = ctx->sa.assoc_num;
@@ -1371,6 +1418,9 @@ static int cn10k_mdo_add_rxsa(struct macsec_context *ctx)
 		return -ENOSPC;
 
 	memcpy(&rxsc->sa_key[sa_num], ctx->sa.key, ctx->secy->key_len);
+	memcpy(&rxsc->salt[sa_num], rx_sa->key.salt.bytes, MACSEC_SALT_LEN);
+	rxsc->ssci[sa_num] = rx_sa->ssci;
+
 	rxsc->sa_bmap |= 1 << sa_num;
 
 	if (netif_running(secy->netdev)) {
@@ -1379,7 +1429,8 @@ static int cn10k_mdo_add_rxsa(struct macsec_context *ctx)
 		if (err)
 			return err;
 
-		err = cn10k_mcs_write_rx_sa_pn(pfvf, rxsc, sa_num, next_pn);
+		err = cn10k_mcs_write_rx_sa_pn(pfvf, rxsc, sa_num,
+					       rx_sa->next_pn);
 		if (err)
 			return err;
 	}
@@ -1393,7 +1444,6 @@ static int cn10k_mdo_upd_rxsa(struct macsec_context *ctx)
 	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct macsec_rx_sa *rx_sa = ctx->sa.rx_sa;
-	u64 next_pn = rx_sa->next_pn_halves.lower;
 	struct macsec_secy *secy = ctx->secy;
 	bool sa_in_use = rx_sa->active;
 	u8 sa_num = ctx->sa.assoc_num;
@@ -1412,7 +1462,8 @@ static int cn10k_mdo_upd_rxsa(struct macsec_context *ctx)
 		if (err)
 			return err;
 
-		err = cn10k_mcs_write_rx_sa_pn(pfvf, rxsc, sa_num, next_pn);
+		err = cn10k_mcs_write_rx_sa_pn(pfvf, rxsc, sa_num,
+					       rx_sa->next_pn);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 0c8fc66..d17274a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -15,6 +15,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <linux/soc/marvell/octeontx2/asm.h>
+#include <net/macsec.h>
 #include <net/pkt_cls.h>
 #include <net/devlink.h>
 #include <linux/time64.h>
@@ -398,6 +399,8 @@ struct cn10k_mcs_txsc {
 	u8 sa_bmap;
 	u8 sa_key[CN10K_MCS_SA_PER_SC][MACSEC_MAX_KEY_LEN];
 	u8 encoding_sa;
+	u8 salt[CN10K_MCS_SA_PER_SC][MACSEC_SALT_LEN];
+	ssci_t ssci[CN10K_MCS_SA_PER_SC];
 };
 
 struct cn10k_mcs_rxsc {
@@ -410,6 +413,8 @@ struct cn10k_mcs_rxsc {
 	u16 hw_sa_id[CN10K_MCS_SA_PER_SC];
 	u8 sa_bmap;
 	u8 sa_key[CN10K_MCS_SA_PER_SC][MACSEC_MAX_KEY_LEN];
+	u8 salt[CN10K_MCS_SA_PER_SC][MACSEC_SALT_LEN];
+	ssci_t ssci[CN10K_MCS_SA_PER_SC];
 };
 
 struct cn10k_mcs_cfg {
-- 
2.7.4


