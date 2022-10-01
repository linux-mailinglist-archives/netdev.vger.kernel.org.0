Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2685F19EE
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 07:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiJAFB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 01:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJAFAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 01:00:50 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557F92AE0C
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 22:00:44 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2912qlxh009288;
        Fri, 30 Sep 2022 22:00:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=fJRKPNx5g5Ks+7Vt2RoBdIcP6zoBXR4DSN5A58fBYRU=;
 b=biO+2MO/7vF00+F+riFUpSiLHr1T0WAITav3dxLWXySOtC37tjDN5Ne+mhI7VI5FMapG
 pHfYVUnMhmgCDNHg/PEfvW9vs7bj3lcB0Geu/CysgahUFwzBldVQYeBYSmuuS9QTCoVd
 BaEF4M6Lq/S9kBh4UALMleW1ekqUUs/x+O4tofsO3PKR5g18SoEc8hQm7biS9I2RyHSD
 uWY+qAt3MqYRnrNPQlc00zPKhgjolFM0N3uJ4VnwtvNwx6lJ8/dP5vq2vkruTUaS4sDA
 M9ly7wp6FpIFnYQR8sbUXiEf0CVw8O6oDI3F3Nc1gXWukQ6Y0b13enZTjQcL8FnIX8k1 Xg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3jx18bambg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 22:00:36 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 30 Sep
 2022 22:00:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 30 Sep 2022 22:00:34 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id ECD623F70A8;
        Fri, 30 Sep 2022 22:00:31 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <naveenm@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v3 8/8] octeontx2-pf: mcs: Introduce MACSEC hardware offloading
Date:   Sat, 1 Oct 2022 10:29:49 +0530
Message-ID: <1664600389-5758-9-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
References: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: VxPrN_IQcqZupF3fRFePYwNbxUGV8GSQ
X-Proofpoint-GUID: VxPrN_IQcqZupF3fRFePYwNbxUGV8GSQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_03,2022-09-29_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the macsec offload feature to cn10k
PF netdev driver. The macsec offload ops like adding, deleting
and updating SecYs, SCs, SAs and stats are supported. XPN support
will be added in later patches. Some stats use same counter in hardware
which means based on the SecY mode the same counter represents different
stat. Hence when SecY mode/policy is changed then snapshot of current
stats are captured. Also there is no provision to specify the unique
flow-id/SCI per packet to hardware hence different mac address needs to
be set for macsec interfaces.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    1 +
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  | 1668 ++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    1 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   90 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   16 +
 5 files changed, 1776 insertions(+)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index d463dc72..73fdb87 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -13,5 +13,6 @@ rvu_nicvf-y := otx2_vf.o otx2_devlink.o
 
 rvu_nicpf-$(CONFIG_DCB) += otx2_dcbnl.o
 rvu_nicvf-$(CONFIG_DCB) += otx2_dcbnl.o
+rvu_nicpf-$(CONFIG_MACSEC) += cn10k_macsec.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
new file mode 100644
index 0000000..64f3acd
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -0,0 +1,1668 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell MACSEC hardware offload driver
+ *
+ * Copyright (C) 2022 Marvell.
+ */
+
+#include <linux/rtnetlink.h>
+#include <linux/bitfield.h>
+#include <net/macsec.h>
+#include "otx2_common.h"
+
+#define MCS_TCAM0_MAC_SA_MASK		GENMASK_ULL(63, 48)
+#define MCS_TCAM1_MAC_SA_MASK		GENMASK_ULL(31, 0)
+#define MCS_TCAM1_ETYPE_MASK		GENMASK_ULL(47, 32)
+
+#define MCS_SA_MAP_MEM_SA_USE		BIT_ULL(9)
+
+#define MCS_RX_SECY_PLCY_RW_MASK	GENMASK_ULL(49, 18)
+#define MCS_RX_SECY_PLCY_RP		BIT_ULL(17)
+#define MCS_RX_SECY_PLCY_AUTH_ENA	BIT_ULL(16)
+#define MCS_RX_SECY_PLCY_CIP		GENMASK_ULL(8, 5)
+#define MCS_RX_SECY_PLCY_VAL		GENMASK_ULL(2, 1)
+#define MCS_RX_SECY_PLCY_ENA		BIT_ULL(0)
+
+#define MCS_TX_SECY_PLCY_MTU		GENMASK_ULL(43, 28)
+#define MCS_TX_SECY_PLCY_ST_TCI		GENMASK_ULL(27, 22)
+#define MCS_TX_SECY_PLCY_ST_OFFSET	GENMASK_ULL(21, 15)
+#define MCS_TX_SECY_PLCY_INS_MODE	BIT_ULL(14)
+#define MCS_TX_SECY_PLCY_AUTH_ENA	BIT_ULL(13)
+#define MCS_TX_SECY_PLCY_CIP		GENMASK_ULL(5, 2)
+#define MCS_TX_SECY_PLCY_PROTECT	BIT_ULL(1)
+#define MCS_TX_SECY_PLCY_ENA		BIT_ULL(0)
+
+#define MCS_GCM_AES_128			0
+#define MCS_GCM_AES_256			1
+#define MCS_GCM_AES_XPN_128		2
+#define MCS_GCM_AES_XPN_256		3
+
+#define MCS_TCI_ES			0x40 /* end station */
+#define MCS_TCI_SC			0x20 /* SCI present */
+#define MCS_TCI_SCB			0x10 /* epon */
+#define MCS_TCI_E			0x08 /* encryption */
+#define MCS_TCI_C			0x04 /* changed text */
+
+static struct cn10k_mcs_txsc *cn10k_mcs_get_txsc(struct cn10k_mcs_cfg *cfg,
+						 struct macsec_secy *secy)
+{
+	struct cn10k_mcs_txsc *txsc;
+
+	list_for_each_entry(txsc, &cfg->txsc_list, entry) {
+		if (txsc->sw_secy == secy)
+			return txsc;
+	}
+
+	return NULL;
+}
+
+static struct cn10k_mcs_rxsc *cn10k_mcs_get_rxsc(struct cn10k_mcs_cfg *cfg,
+						 struct macsec_secy *secy,
+						 struct macsec_rx_sc *rx_sc)
+{
+	struct cn10k_mcs_rxsc *rxsc;
+
+	list_for_each_entry(rxsc, &cfg->rxsc_list, entry) {
+		if (rxsc->sw_rxsc == rx_sc && rxsc->sw_secy == secy)
+			return rxsc;
+	}
+
+	return NULL;
+}
+
+static const char *rsrc_name(enum mcs_rsrc_type rsrc_type)
+{
+	switch (rsrc_type) {
+	case MCS_RSRC_TYPE_FLOWID:
+		return "FLOW";
+	case MCS_RSRC_TYPE_SC:
+		return "SC";
+	case MCS_RSRC_TYPE_SECY:
+		return "SECY";
+	case MCS_RSRC_TYPE_SA:
+		return "SA";
+	default:
+		return "Unknown";
+	};
+
+	return "Unknown";
+}
+
+static int cn10k_mcs_alloc_rsrc(struct otx2_nic *pfvf, enum mcs_direction dir,
+				enum mcs_rsrc_type type, u16 *rsrc_id)
+{
+	struct mbox *mbox = &pfvf->mbox;
+	struct mcs_alloc_rsrc_req *req;
+	struct mcs_alloc_rsrc_rsp *rsp;
+	int ret = -ENOMEM;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_alloc_resources(mbox);
+	if (!req)
+		goto fail;
+
+	req->rsrc_type = type;
+	req->rsrc_cnt  = 1;
+	req->dir = dir;
+
+	ret = otx2_sync_mbox_msg(mbox);
+	if (ret)
+		goto fail;
+
+	rsp = (struct mcs_alloc_rsrc_rsp *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
+							     0, &req->hdr);
+	if (IS_ERR(rsp) || req->rsrc_cnt != rsp->rsrc_cnt ||
+	    req->rsrc_type != rsp->rsrc_type || req->dir != rsp->dir) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	switch (rsp->rsrc_type) {
+	case MCS_RSRC_TYPE_FLOWID:
+		*rsrc_id = rsp->flow_ids[0];
+		break;
+	case MCS_RSRC_TYPE_SC:
+		*rsrc_id = rsp->sc_ids[0];
+		break;
+	case MCS_RSRC_TYPE_SECY:
+		*rsrc_id = rsp->secy_ids[0];
+		break;
+	case MCS_RSRC_TYPE_SA:
+		*rsrc_id = rsp->sa_ids[0];
+		break;
+	default:
+		ret = -EINVAL;
+		goto fail;
+	};
+
+	mutex_unlock(&mbox->lock);
+
+	return 0;
+fail:
+	dev_err(pfvf->dev, "Failed to allocate %s %s resource\n",
+		dir == MCS_TX ? "TX" : "RX", rsrc_name(type));
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static void cn10k_mcs_free_rsrc(struct otx2_nic *pfvf, enum mcs_direction dir,
+				enum mcs_rsrc_type type, u16 hw_rsrc_id,
+				bool all)
+{
+	struct mbox *mbox = &pfvf->mbox;
+	struct mcs_free_rsrc_req *req;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_free_resources(mbox);
+	if (!req)
+		goto fail;
+
+	req->rsrc_id = hw_rsrc_id;
+	req->rsrc_type = type;
+	req->dir = dir;
+	if (all)
+		req->all = 1;
+
+	if (otx2_sync_mbox_msg(&pfvf->mbox))
+		goto fail;
+
+	mutex_unlock(&mbox->lock);
+
+	return;
+fail:
+	dev_err(pfvf->dev, "Failed to free %s %s resource\n",
+		dir == MCS_TX ? "TX" : "RX", rsrc_name(type));
+	mutex_unlock(&mbox->lock);
+}
+
+static int cn10k_mcs_alloc_txsa(struct otx2_nic *pfvf, u16 *hw_sa_id)
+{
+	return cn10k_mcs_alloc_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SA, hw_sa_id);
+}
+
+static int cn10k_mcs_alloc_rxsa(struct otx2_nic *pfvf, u16 *hw_sa_id)
+{
+	return cn10k_mcs_alloc_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SA, hw_sa_id);
+}
+
+static void cn10k_mcs_free_txsa(struct otx2_nic *pfvf, u16 hw_sa_id)
+{
+	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SA, hw_sa_id, false);
+}
+
+static void cn10k_mcs_free_rxsa(struct otx2_nic *pfvf, u16 hw_sa_id)
+{
+	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SA, hw_sa_id, false);
+}
+
+static int cn10k_mcs_write_rx_secy(struct otx2_nic *pfvf,
+				   struct macsec_secy *secy, u8 hw_secy_id)
+{
+	struct mcs_secy_plcy_write_req *req;
+	struct mbox *mbox = &pfvf->mbox;
+	u64 policy;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_secy_plcy_write(mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	policy = FIELD_PREP(MCS_RX_SECY_PLCY_RW_MASK, secy->replay_window);
+	if (secy->replay_protect)
+		policy |= MCS_RX_SECY_PLCY_RP;
+
+	policy |= MCS_RX_SECY_PLCY_AUTH_ENA;
+	policy |= FIELD_PREP(MCS_RX_SECY_PLCY_CIP, MCS_GCM_AES_128);
+	policy |= FIELD_PREP(MCS_RX_SECY_PLCY_VAL, secy->validate_frames);
+
+	policy |= MCS_RX_SECY_PLCY_ENA;
+
+	req->plcy = policy;
+	req->secy_id = hw_secy_id;
+	req->dir = MCS_RX;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_write_rx_flowid(struct otx2_nic *pfvf,
+				     struct cn10k_mcs_rxsc *rxsc, u8 hw_secy_id)
+{
+	struct macsec_rx_sc *sw_rx_sc = rxsc->sw_rxsc;
+	struct mcs_flowid_entry_write_req *req;
+	struct mbox *mbox = &pfvf->mbox;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_flowid_entry_write(mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	req->data[1] = FIELD_PREP(MCS_TCAM1_ETYPE_MASK, ETH_P_MACSEC);
+	req->mask[1] = ~0ULL;
+	req->mask[1] &= ~MCS_TCAM1_ETYPE_MASK;
+
+	req->mask[0] = ~0ULL;
+	req->mask[2] = ~0ULL;
+	req->mask[3] = ~0ULL;
+
+	req->flow_id = rxsc->hw_flow_id;
+	req->secy_id = hw_secy_id;
+	req->sc_id = rxsc->hw_sc_id;
+	req->dir = MCS_RX;
+
+	if (sw_rx_sc->active)
+		req->ena = 1;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_write_sc_cam(struct otx2_nic *pfvf,
+				  struct cn10k_mcs_rxsc *rxsc, u8 hw_secy_id)
+{
+	struct macsec_rx_sc *sw_rx_sc = rxsc->sw_rxsc;
+	struct mcs_rx_sc_cam_write_req *sc_req;
+	struct mbox *mbox = &pfvf->mbox;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	sc_req = otx2_mbox_alloc_msg_mcs_rx_sc_cam_write(mbox);
+	if (!sc_req) {
+		return -ENOMEM;
+		goto fail;
+	}
+
+	sc_req->sci = (__force u64)cpu_to_be64((__force u64)sw_rx_sc->sci);
+	sc_req->sc_id = rxsc->hw_sc_id;
+	sc_req->secy_id = hw_secy_id;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_write_rx_sa_plcy(struct otx2_nic *pfvf,
+				      struct macsec_secy *secy,
+				      struct cn10k_mcs_rxsc *rxsc,
+				      u8 assoc_num, bool sa_in_use)
+{
+	unsigned char *src = rxsc->sa_key[assoc_num];
+	struct mcs_sa_plcy_write_req *plcy_req;
+	struct mcs_rx_sc_sa_map *map_req;
+	struct mbox *mbox = &pfvf->mbox;
+	u8 reg, key_len;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	plcy_req = otx2_mbox_alloc_msg_mcs_sa_plcy_write(mbox);
+	if (!plcy_req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	map_req = otx2_mbox_alloc_msg_mcs_rx_sc_sa_map_write(mbox);
+	if (!map_req) {
+		otx2_mbox_reset(&mbox->mbox, 0);
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	for (reg = 0, key_len = 0; key_len < secy->key_len; key_len += 8) {
+		memcpy((u8 *)&plcy_req->plcy[0][reg],
+		       (src + reg * 8), 8);
+		reg++;
+	}
+
+	plcy_req->sa_index[0] = rxsc->hw_sa_id[assoc_num];
+	plcy_req->sa_cnt = 1;
+	plcy_req->dir = MCS_RX;
+
+	map_req->sa_index = rxsc->hw_sa_id[assoc_num];
+	map_req->sa_in_use = sa_in_use;
+	map_req->sc_id = rxsc->hw_sc_id;
+	map_req->an = assoc_num;
+
+	/* Send two messages together */
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_write_rx_sa_pn(struct otx2_nic *pfvf,
+				    struct cn10k_mcs_rxsc *rxsc,
+				    u8 assoc_num, u64 next_pn)
+{
+	struct mcs_pn_table_write_req *req;
+	struct mbox *mbox = &pfvf->mbox;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_pn_table_write(mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	req->pn_id = rxsc->hw_sa_id[assoc_num];
+	req->next_pn = next_pn;
+	req->dir = MCS_RX;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_write_tx_secy(struct otx2_nic *pfvf,
+				   struct macsec_secy *secy,
+				   struct cn10k_mcs_txsc *txsc)
+{
+	struct mcs_secy_plcy_write_req *req;
+	struct mbox *mbox = &pfvf->mbox;
+	struct macsec_tx_sc *sw_tx_sc;
+	/* Insert SecTag after 12 bytes (DA+SA)*/
+	u8 tag_offset = 12;
+	u8 sectag_tci = 0;
+	u64 policy;
+	int ret;
+
+	sw_tx_sc = &secy->tx_sc;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_secy_plcy_write(mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	if (sw_tx_sc->send_sci) {
+		sectag_tci |= MCS_TCI_SC;
+	} else {
+		if (sw_tx_sc->end_station)
+			sectag_tci |= MCS_TCI_ES;
+		if (sw_tx_sc->scb)
+			sectag_tci |= MCS_TCI_SCB;
+	}
+
+	if (sw_tx_sc->encrypt)
+		sectag_tci |= (MCS_TCI_E | MCS_TCI_C);
+
+	policy = FIELD_PREP(MCS_TX_SECY_PLCY_MTU, secy->netdev->mtu);
+	/* Write SecTag excluding AN bits(1..0) */
+	policy |= FIELD_PREP(MCS_TX_SECY_PLCY_ST_TCI, sectag_tci >> 2);
+	policy |= FIELD_PREP(MCS_TX_SECY_PLCY_ST_OFFSET, tag_offset);
+	policy |= MCS_TX_SECY_PLCY_INS_MODE;
+	policy |= MCS_TX_SECY_PLCY_AUTH_ENA;
+	policy |= FIELD_PREP(MCS_TX_SECY_PLCY_CIP, MCS_GCM_AES_128);
+
+	if (secy->protect_frames)
+		policy |= MCS_TX_SECY_PLCY_PROTECT;
+
+	/* If the encodingsa does not exist/active and protect is
+	 * not set then frames can be sent out as it is. Hence enable
+	 * the policy irrespective of secy operational when !protect.
+	 */
+	if (!secy->protect_frames || secy->operational)
+		policy |= MCS_TX_SECY_PLCY_ENA;
+
+	req->plcy = policy;
+	req->secy_id = txsc->hw_secy_id_tx;
+	req->dir = MCS_TX;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_write_tx_flowid(struct otx2_nic *pfvf,
+				     struct macsec_secy *secy,
+				     struct cn10k_mcs_txsc *txsc)
+{
+	struct mcs_flowid_entry_write_req *req;
+	struct mbox *mbox = &pfvf->mbox;
+	u64 mac_sa;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_flowid_entry_write(mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	mac_sa = ether_addr_to_u64(secy->netdev->dev_addr);
+
+	req->data[0] = FIELD_PREP(MCS_TCAM0_MAC_SA_MASK, mac_sa);
+	req->data[1] = FIELD_PREP(MCS_TCAM1_MAC_SA_MASK, mac_sa >> 16);
+
+	req->mask[0] = ~0ULL;
+	req->mask[0] &= ~MCS_TCAM0_MAC_SA_MASK;
+
+	req->mask[1] = ~0ULL;
+	req->mask[1] &= ~MCS_TCAM1_MAC_SA_MASK;
+
+	req->mask[2] = ~0ULL;
+	req->mask[3] = ~0ULL;
+
+	req->flow_id = txsc->hw_flow_id;
+	req->secy_id = txsc->hw_secy_id_tx;
+	req->sc_id = txsc->hw_sc_id;
+	req->sci = (__force u64)cpu_to_be64((__force u64)secy->sci);
+	req->dir = MCS_TX;
+	/* This can be enabled since stack xmits packets only when interface is up */
+	req->ena = 1;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_link_tx_sa2sc(struct otx2_nic *pfvf,
+				   struct macsec_secy *secy,
+				   struct cn10k_mcs_txsc *txsc,
+				   u8 sa_num, bool sa_active)
+{
+	struct mcs_tx_sc_sa_map *map_req;
+	struct mbox *mbox = &pfvf->mbox;
+	int ret;
+
+	/* Link the encoding_sa only to SC out of all SAs */
+	if (txsc->encoding_sa != sa_num)
+		return 0;
+
+	mutex_lock(&mbox->lock);
+
+	map_req = otx2_mbox_alloc_msg_mcs_tx_sc_sa_map_write(mbox);
+	if (!map_req) {
+		otx2_mbox_reset(&mbox->mbox, 0);
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	map_req->sa_index0 = txsc->hw_sa_id[sa_num];
+	map_req->sa_index0_vld = sa_active;
+	map_req->sectag_sci = (__force u64)cpu_to_be64((__force u64)secy->sci);
+	map_req->sc_id = txsc->hw_sc_id;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_write_tx_sa_plcy(struct otx2_nic *pfvf,
+				      struct macsec_secy *secy,
+				      struct cn10k_mcs_txsc *txsc,
+				      u8 assoc_num)
+{
+	unsigned char *src = txsc->sa_key[assoc_num];
+	struct mcs_sa_plcy_write_req *plcy_req;
+	struct mbox *mbox = &pfvf->mbox;
+	u8 reg, key_len;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	plcy_req = otx2_mbox_alloc_msg_mcs_sa_plcy_write(mbox);
+	if (!plcy_req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	for (reg = 0, key_len = 0; key_len < secy->key_len; key_len += 8) {
+		memcpy((u8 *)&plcy_req->plcy[0][reg], (src + reg * 8), 8);
+		reg++;
+	}
+
+	plcy_req->plcy[0][8] = assoc_num;
+	plcy_req->sa_index[0] = txsc->hw_sa_id[assoc_num];
+	plcy_req->sa_cnt = 1;
+	plcy_req->dir = MCS_TX;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_write_tx_sa_pn(struct otx2_nic *pfvf,
+				struct cn10k_mcs_txsc *txsc,
+				u8 assoc_num, u64 next_pn)
+{
+	struct mcs_pn_table_write_req *req;
+	struct mbox *mbox = &pfvf->mbox;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_pn_table_write(mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	req->pn_id = txsc->hw_sa_id[assoc_num];
+	req->next_pn = next_pn;
+	req->dir = MCS_TX;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_ena_dis_flowid(struct otx2_nic *pfvf, u16 hw_flow_id,
+				    bool enable, enum mcs_direction dir)
+{
+	struct mcs_flowid_ena_dis_entry *req;
+	struct mbox *mbox = &pfvf->mbox;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_flowid_ena_entry(mbox);
+	if (!req) {
+		return -ENOMEM;
+		goto fail;
+	}
+
+	req->flow_id = hw_flow_id;
+	req->ena = enable;
+	req->dir = dir;
+
+	ret = otx2_sync_mbox_msg(mbox);
+
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_sa_stats(struct otx2_nic *pfvf, u8 hw_sa_id,
+			      struct mcs_sa_stats *rsp_p,
+			      enum mcs_direction dir, bool clear)
+{
+	struct mcs_clear_stats *clear_req;
+	struct mbox *mbox = &pfvf->mbox;
+	struct mcs_stats_req *req;
+	struct mcs_sa_stats *rsp;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_get_sa_stats(mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	req->id = hw_sa_id;
+	req->dir = dir;
+
+	if (!clear)
+		goto send_msg;
+
+	clear_req = otx2_mbox_alloc_msg_mcs_clear_stats(mbox);
+	if (!clear_req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	clear_req->id = hw_sa_id;
+	clear_req->dir = dir;
+	clear_req->type = MCS_RSRC_TYPE_SA;
+
+send_msg:
+	ret = otx2_sync_mbox_msg(mbox);
+	if (ret)
+		goto fail;
+
+	rsp = (struct mcs_sa_stats *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
+						       0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		ret = PTR_ERR(rsp);
+		goto fail;
+	}
+
+	memcpy(rsp_p, rsp, sizeof(*rsp_p));
+
+	mutex_unlock(&mbox->lock);
+
+	return 0;
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_sc_stats(struct otx2_nic *pfvf, u8 hw_sc_id,
+			      struct mcs_sc_stats *rsp_p,
+			      enum mcs_direction dir, bool clear)
+{
+	struct mcs_clear_stats *clear_req;
+	struct mbox *mbox = &pfvf->mbox;
+	struct mcs_stats_req *req;
+	struct mcs_sc_stats *rsp;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_get_sc_stats(mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	req->id = hw_sc_id;
+	req->dir = dir;
+
+	if (!clear)
+		goto send_msg;
+
+	clear_req = otx2_mbox_alloc_msg_mcs_clear_stats(mbox);
+	if (!clear_req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	clear_req->id = hw_sc_id;
+	clear_req->dir = dir;
+	clear_req->type = MCS_RSRC_TYPE_SC;
+
+send_msg:
+	ret = otx2_sync_mbox_msg(mbox);
+	if (ret)
+		goto fail;
+
+	rsp = (struct mcs_sc_stats *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
+						       0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		ret = PTR_ERR(rsp);
+		goto fail;
+	}
+
+	memcpy(rsp_p, rsp, sizeof(*rsp_p));
+
+	mutex_unlock(&mbox->lock);
+
+	return 0;
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static int cn10k_mcs_secy_stats(struct otx2_nic *pfvf, u8 hw_secy_id,
+				struct mcs_secy_stats *rsp_p,
+				enum mcs_direction dir, bool clear)
+{
+	struct mcs_clear_stats *clear_req;
+	struct mbox *mbox = &pfvf->mbox;
+	struct mcs_secy_stats *rsp;
+	struct mcs_stats_req *req;
+	int ret;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_get_secy_stats(mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	req->id = hw_secy_id;
+	req->dir = dir;
+
+	if (!clear)
+		goto send_msg;
+
+	clear_req = otx2_mbox_alloc_msg_mcs_clear_stats(mbox);
+	if (!clear_req) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	clear_req->id = hw_secy_id;
+	clear_req->dir = dir;
+	clear_req->type = MCS_RSRC_TYPE_SECY;
+
+send_msg:
+	ret = otx2_sync_mbox_msg(mbox);
+	if (ret)
+		goto fail;
+
+	rsp = (struct mcs_secy_stats *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
+							 0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		ret = PTR_ERR(rsp);
+		goto fail;
+	}
+
+	memcpy(rsp_p, rsp, sizeof(*rsp_p));
+
+	mutex_unlock(&mbox->lock);
+
+	return 0;
+fail:
+	mutex_unlock(&mbox->lock);
+	return ret;
+}
+
+static struct cn10k_mcs_txsc *cn10k_mcs_create_txsc(struct otx2_nic *pfvf)
+{
+	struct cn10k_mcs_txsc *txsc;
+	int ret;
+
+	txsc = kzalloc(sizeof(*txsc), GFP_KERNEL);
+	if (!txsc)
+		return ERR_PTR(-ENOMEM);
+
+	ret = cn10k_mcs_alloc_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_FLOWID,
+				   &txsc->hw_flow_id);
+	if (ret)
+		goto fail;
+
+	/* For a SecY, one TX secy and one RX secy HW resources are needed */
+	ret = cn10k_mcs_alloc_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY,
+				   &txsc->hw_secy_id_tx);
+	if (ret)
+		goto free_flowid;
+
+	ret = cn10k_mcs_alloc_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY,
+				   &txsc->hw_secy_id_rx);
+	if (ret)
+		goto free_tx_secy;
+
+	ret = cn10k_mcs_alloc_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SC,
+				   &txsc->hw_sc_id);
+	if (ret)
+		goto free_rx_secy;
+
+	return txsc;
+free_rx_secy:
+	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY,
+			    txsc->hw_secy_id_rx, false);
+free_tx_secy:
+	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY,
+			    txsc->hw_secy_id_tx, false);
+free_flowid:
+	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_FLOWID,
+			    txsc->hw_flow_id, false);
+fail:
+	return ERR_PTR(ret);
+}
+
+/* Free Tx SC and its SAs(if any) resources to AF
+ */
+static void cn10k_mcs_delete_txsc(struct otx2_nic *pfvf,
+				  struct cn10k_mcs_txsc *txsc)
+{
+	u8 sa_bmap = txsc->sa_bmap;
+	u8 sa_num = 0;
+
+	while (sa_bmap) {
+		if (sa_bmap & 1) {
+			cn10k_mcs_write_tx_sa_plcy(pfvf, txsc->sw_secy,
+						   txsc, sa_num);
+			cn10k_mcs_free_txsa(pfvf, txsc->hw_sa_id[sa_num]);
+		}
+		sa_num++;
+		sa_bmap >>= 1;
+	}
+
+	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SC,
+			    txsc->hw_sc_id, false);
+	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY,
+			    txsc->hw_secy_id_rx, false);
+	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY,
+			    txsc->hw_secy_id_tx, false);
+	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_FLOWID,
+			    txsc->hw_flow_id, false);
+}
+
+static struct cn10k_mcs_rxsc *cn10k_mcs_create_rxsc(struct otx2_nic *pfvf)
+{
+	struct cn10k_mcs_rxsc *rxsc;
+	int ret;
+
+	rxsc = kzalloc(sizeof(*rxsc), GFP_KERNEL);
+	if (!rxsc)
+		return ERR_PTR(-ENOMEM);
+
+	ret = cn10k_mcs_alloc_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_FLOWID,
+				   &rxsc->hw_flow_id);
+	if (ret)
+		goto fail;
+
+	ret = cn10k_mcs_alloc_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SC,
+				   &rxsc->hw_sc_id);
+	if (ret)
+		goto free_flowid;
+
+	return rxsc;
+free_flowid:
+	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_FLOWID,
+			    rxsc->hw_flow_id, false);
+fail:
+	return ERR_PTR(ret);
+}
+
+/* Free Rx SC and its SAs(if any) resources to AF
+ */
+static void cn10k_mcs_delete_rxsc(struct otx2_nic *pfvf,
+				  struct cn10k_mcs_rxsc *rxsc)
+{
+	u8 sa_bmap = rxsc->sa_bmap;
+	u8 sa_num = 0;
+
+	while (sa_bmap) {
+		if (sa_bmap & 1) {
+			cn10k_mcs_write_rx_sa_plcy(pfvf, rxsc->sw_secy, rxsc,
+						   sa_num, false);
+			cn10k_mcs_free_rxsa(pfvf, rxsc->hw_sa_id[sa_num]);
+		}
+		sa_num++;
+		sa_bmap >>= 1;
+	}
+
+	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SC,
+			    rxsc->hw_sc_id, false);
+	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_FLOWID,
+			    rxsc->hw_flow_id, false);
+}
+
+static int cn10k_mcs_secy_tx_cfg(struct otx2_nic *pfvf, struct macsec_secy *secy,
+				 struct cn10k_mcs_txsc *txsc,
+				 struct macsec_tx_sa *sw_tx_sa, u8 sa_num)
+{
+	if (sw_tx_sa) {
+		cn10k_mcs_write_tx_sa_plcy(pfvf, secy, txsc, sa_num);
+		cn10k_write_tx_sa_pn(pfvf, txsc, sa_num,
+				     sw_tx_sa->next_pn_halves.lower);
+		cn10k_mcs_link_tx_sa2sc(pfvf, secy, txsc, sa_num,
+					sw_tx_sa->active);
+	}
+
+	cn10k_mcs_write_tx_secy(pfvf, secy, txsc);
+	cn10k_mcs_write_tx_flowid(pfvf, secy, txsc);
+	/* When updating secy, change RX secy also */
+	cn10k_mcs_write_rx_secy(pfvf, secy, txsc->hw_secy_id_rx);
+
+	return 0;
+}
+
+static int cn10k_mcs_secy_rx_cfg(struct otx2_nic *pfvf,
+				 struct macsec_secy *secy, u8 hw_secy_id)
+{
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct cn10k_mcs_rxsc *mcs_rx_sc;
+	struct macsec_rx_sc *sw_rx_sc;
+	struct macsec_rx_sa *sw_rx_sa;
+	u8 sa_num;
+
+	for (sw_rx_sc = rcu_dereference_bh(secy->rx_sc); sw_rx_sc && sw_rx_sc->active;
+	     sw_rx_sc = rcu_dereference_bh(sw_rx_sc->next)) {
+		mcs_rx_sc = cn10k_mcs_get_rxsc(cfg, secy, sw_rx_sc);
+		if (unlikely(!mcs_rx_sc))
+			continue;
+
+		for (sa_num = 0; sa_num < CN10K_MCS_SA_PER_SC; sa_num++) {
+			sw_rx_sa = rcu_dereference_bh(sw_rx_sc->sa[sa_num]);
+			if (!sw_rx_sa)
+				continue;
+
+			cn10k_mcs_write_rx_sa_plcy(pfvf, secy, mcs_rx_sc,
+						   sa_num, sw_rx_sa->active);
+			cn10k_mcs_write_rx_sa_pn(pfvf, mcs_rx_sc, sa_num,
+						 sw_rx_sa->next_pn_halves.lower);
+		}
+
+		cn10k_mcs_write_rx_flowid(pfvf, mcs_rx_sc, hw_secy_id);
+		cn10k_mcs_write_sc_cam(pfvf, mcs_rx_sc, hw_secy_id);
+	}
+
+	return 0;
+}
+
+static int cn10k_mcs_disable_rxscs(struct otx2_nic *pfvf,
+				   struct macsec_secy *secy,
+				   bool delete)
+{
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct cn10k_mcs_rxsc *mcs_rx_sc;
+	struct macsec_rx_sc *sw_rx_sc;
+	int ret;
+
+	for (sw_rx_sc = rcu_dereference_bh(secy->rx_sc); sw_rx_sc && sw_rx_sc->active;
+	     sw_rx_sc = rcu_dereference_bh(sw_rx_sc->next)) {
+		mcs_rx_sc = cn10k_mcs_get_rxsc(cfg, secy, sw_rx_sc);
+		if (unlikely(!mcs_rx_sc))
+			continue;
+
+		ret = cn10k_mcs_ena_dis_flowid(pfvf, mcs_rx_sc->hw_flow_id,
+					       false, MCS_RX);
+		if (ret)
+			dev_err(pfvf->dev, "Failed to disable TCAM for SC %d\n",
+				mcs_rx_sc->hw_sc_id);
+		if (delete) {
+			cn10k_mcs_delete_rxsc(pfvf, mcs_rx_sc);
+			list_del(&mcs_rx_sc->entry);
+			kfree(mcs_rx_sc);
+		}
+	}
+
+	return 0;
+}
+
+static void cn10k_mcs_sync_stats(struct otx2_nic *pfvf, struct macsec_secy *secy,
+				 struct cn10k_mcs_txsc *txsc)
+{
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct mcs_secy_stats rx_rsp = { 0 };
+	struct mcs_sc_stats sc_rsp = { 0 };
+	struct cn10k_mcs_rxsc *rxsc;
+
+	/* Because of shared counters for some stats in the hardware, when
+	 * updating secy policy take a snapshot of current stats and reset them.
+	 * Below are the effected stats because of shared counters.
+	 */
+
+	/* Check if sync is really needed */
+	if (secy->validate_frames == txsc->last_validate_frames &&
+	    secy->protect_frames == txsc->last_protect_frames)
+		return;
+
+	cn10k_mcs_secy_stats(pfvf, txsc->hw_secy_id_rx, &rx_rsp, MCS_RX, true);
+
+	txsc->stats.InPktsBadTag += rx_rsp.pkt_badtag_cnt;
+	txsc->stats.InPktsUnknownSCI += rx_rsp.pkt_nosa_cnt;
+	txsc->stats.InPktsNoSCI += rx_rsp.pkt_nosaerror_cnt;
+	if (txsc->last_validate_frames == MACSEC_VALIDATE_STRICT)
+		txsc->stats.InPktsNoTag += rx_rsp.pkt_untaged_cnt;
+	else
+		txsc->stats.InPktsUntagged += rx_rsp.pkt_untaged_cnt;
+
+	list_for_each_entry(rxsc, &cfg->rxsc_list, entry) {
+		cn10k_mcs_sc_stats(pfvf, rxsc->hw_sc_id, &sc_rsp, MCS_RX, true);
+
+		rxsc->stats.InOctetsValidated += sc_rsp.octet_validate_cnt;
+		rxsc->stats.InOctetsDecrypted += sc_rsp.octet_decrypt_cnt;
+
+		rxsc->stats.InPktsInvalid += sc_rsp.pkt_invalid_cnt;
+		rxsc->stats.InPktsNotValid += sc_rsp.pkt_notvalid_cnt;
+
+		if (txsc->last_protect_frames)
+			rxsc->stats.InPktsLate += sc_rsp.pkt_late_cnt;
+		else
+			rxsc->stats.InPktsDelayed += sc_rsp.pkt_late_cnt;
+
+		if (txsc->last_validate_frames == MACSEC_VALIDATE_CHECK)
+			rxsc->stats.InPktsUnchecked += sc_rsp.pkt_unchecked_cnt;
+		else
+			rxsc->stats.InPktsOK += sc_rsp.pkt_unchecked_cnt;
+	}
+
+	txsc->last_validate_frames = secy->validate_frames;
+	txsc->last_protect_frames = secy->protect_frames;
+}
+
+static int cn10k_mdo_open(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_secy *secy = ctx->secy;
+	struct macsec_tx_sa *sw_tx_sa;
+	struct cn10k_mcs_txsc *txsc;
+	u8 sa_num;
+	int err;
+
+	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
+	if (!txsc)
+		return -ENOENT;
+
+	sa_num = txsc->encoding_sa;
+	sw_tx_sa = rcu_dereference_bh(secy->tx_sc.sa[sa_num]);
+
+	err = cn10k_mcs_secy_tx_cfg(pfvf, secy, txsc, sw_tx_sa, sa_num);
+	if (err)
+		return err;
+
+	return cn10k_mcs_secy_rx_cfg(pfvf, secy, txsc->hw_secy_id_rx);
+}
+
+static int cn10k_mdo_stop(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct cn10k_mcs_txsc *txsc;
+	int err;
+
+	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
+	if (!txsc)
+		return -ENOENT;
+
+	err = cn10k_mcs_ena_dis_flowid(pfvf, txsc->hw_flow_id, false, MCS_TX);
+	if (err)
+		return err;
+
+	return cn10k_mcs_disable_rxscs(pfvf, ctx->secy, false);
+}
+
+static int cn10k_mdo_add_secy(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_secy *secy = ctx->secy;
+	struct cn10k_mcs_txsc *txsc;
+
+	if (secy->icv_len != MACSEC_DEFAULT_ICV_LEN)
+		return -EOPNOTSUPP;
+
+	/* Stick to 16 bytes key len until XPN support is added */
+	if (secy->key_len != 16)
+		return -EOPNOTSUPP;
+
+	if (secy->xpn)
+		return -EOPNOTSUPP;
+
+	txsc = cn10k_mcs_create_txsc(pfvf);
+	if (IS_ERR(txsc))
+		return -ENOSPC;
+
+	txsc->sw_secy = secy;
+	txsc->encoding_sa = secy->tx_sc.encoding_sa;
+	txsc->last_validate_frames = secy->validate_frames;
+	txsc->last_protect_frames = secy->protect_frames;
+
+	list_add(&txsc->entry, &cfg->txsc_list);
+
+	if (netif_running(secy->netdev))
+		return cn10k_mcs_secy_tx_cfg(pfvf, secy, txsc, NULL, 0);
+
+	return 0;
+}
+
+static int cn10k_mdo_upd_secy(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_secy *secy = ctx->secy;
+	struct macsec_tx_sa *sw_tx_sa;
+	struct cn10k_mcs_txsc *txsc;
+	u8 sa_num;
+	int err;
+
+	txsc = cn10k_mcs_get_txsc(cfg, secy);
+	if (!txsc)
+		return -ENOENT;
+
+	txsc->encoding_sa = secy->tx_sc.encoding_sa;
+
+	sa_num = txsc->encoding_sa;
+	sw_tx_sa = rcu_dereference_bh(secy->tx_sc.sa[sa_num]);
+
+	if (netif_running(secy->netdev)) {
+		cn10k_mcs_sync_stats(pfvf, secy, txsc);
+
+		err = cn10k_mcs_secy_tx_cfg(pfvf, secy, txsc, sw_tx_sa, sa_num);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int cn10k_mdo_del_secy(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct cn10k_mcs_txsc *txsc;
+
+	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
+	if (!txsc)
+		return -ENOENT;
+
+	cn10k_mcs_ena_dis_flowid(pfvf, txsc->hw_flow_id, false, MCS_TX);
+	cn10k_mcs_disable_rxscs(pfvf, ctx->secy, true);
+	cn10k_mcs_delete_txsc(pfvf, txsc);
+	list_del(&txsc->entry);
+	kfree(txsc);
+
+	return 0;
+}
+
+static int cn10k_mdo_add_txsa(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct macsec_tx_sa *sw_tx_sa = ctx->sa.tx_sa;
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_secy *secy = ctx->secy;
+	u8 sa_num = ctx->sa.assoc_num;
+	struct cn10k_mcs_txsc *txsc;
+	int err;
+
+	txsc = cn10k_mcs_get_txsc(cfg, secy);
+	if (!txsc)
+		return -ENOENT;
+
+	if (sa_num >= CN10K_MCS_SA_PER_SC)
+		return -EOPNOTSUPP;
+
+	if (cn10k_mcs_alloc_txsa(pfvf, &txsc->hw_sa_id[sa_num]))
+		return -ENOSPC;
+
+	memcpy(&txsc->sa_key[sa_num], ctx->sa.key, secy->key_len);
+	txsc->sa_bmap |= 1 << sa_num;
+
+	if (netif_running(secy->netdev)) {
+		err = cn10k_mcs_write_tx_sa_plcy(pfvf, secy, txsc, sa_num);
+		if (err)
+			return err;
+
+		err = cn10k_write_tx_sa_pn(pfvf, txsc, sa_num,
+					   sw_tx_sa->next_pn_halves.lower);
+		if (err)
+			return err;
+
+		err = cn10k_mcs_link_tx_sa2sc(pfvf, secy, txsc,
+					      sa_num, sw_tx_sa->active);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int cn10k_mdo_upd_txsa(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct macsec_tx_sa *sw_tx_sa = ctx->sa.tx_sa;
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_secy *secy = ctx->secy;
+	u8 sa_num = ctx->sa.assoc_num;
+	struct cn10k_mcs_txsc *txsc;
+	int err;
+
+	txsc = cn10k_mcs_get_txsc(cfg, secy);
+	if (!txsc)
+		return -ENOENT;
+
+	if (sa_num >= CN10K_MCS_SA_PER_SC)
+		return -EOPNOTSUPP;
+
+	if (netif_running(secy->netdev)) {
+		/* Keys cannot be changed after creation */
+		err = cn10k_write_tx_sa_pn(pfvf, txsc, sa_num,
+					   sw_tx_sa->next_pn_halves.lower);
+		if (err)
+			return err;
+
+		err = cn10k_mcs_link_tx_sa2sc(pfvf, secy, txsc,
+					      sa_num, sw_tx_sa->active);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int cn10k_mdo_del_txsa(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	u8 sa_num = ctx->sa.assoc_num;
+	struct cn10k_mcs_txsc *txsc;
+
+	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
+	if (!txsc)
+		return -ENOENT;
+
+	if (sa_num >= CN10K_MCS_SA_PER_SC)
+		return -EOPNOTSUPP;
+
+	cn10k_mcs_free_txsa(pfvf, txsc->hw_sa_id[sa_num]);
+	txsc->sa_bmap &= ~(1 << sa_num);
+
+	return 0;
+}
+
+static int cn10k_mdo_add_rxsc(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_secy *secy = ctx->secy;
+	struct cn10k_mcs_rxsc *rxsc;
+	struct cn10k_mcs_txsc *txsc;
+	int err;
+
+	txsc = cn10k_mcs_get_txsc(cfg, secy);
+	if (!txsc)
+		return -ENOENT;
+
+	rxsc = cn10k_mcs_create_rxsc(pfvf);
+	if (IS_ERR(rxsc))
+		return -ENOSPC;
+
+	rxsc->sw_secy = ctx->secy;
+	rxsc->sw_rxsc = ctx->rx_sc;
+	list_add(&rxsc->entry, &cfg->rxsc_list);
+
+	if (netif_running(secy->netdev)) {
+		err = cn10k_mcs_write_rx_flowid(pfvf, rxsc, txsc->hw_secy_id_rx);
+		if (err)
+			return err;
+
+		err = cn10k_mcs_write_sc_cam(pfvf, rxsc, txsc->hw_secy_id_rx);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int cn10k_mdo_upd_rxsc(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_secy *secy = ctx->secy;
+	bool enable = ctx->rx_sc->active;
+	struct cn10k_mcs_rxsc *rxsc;
+
+	rxsc = cn10k_mcs_get_rxsc(cfg, secy, ctx->rx_sc);
+	if (!rxsc)
+		return -ENOENT;
+
+	if (netif_running(secy->netdev))
+		return cn10k_mcs_ena_dis_flowid(pfvf, rxsc->hw_flow_id,
+						enable, MCS_RX);
+
+	return 0;
+}
+
+static int cn10k_mdo_del_rxsc(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct cn10k_mcs_rxsc *rxsc;
+
+	rxsc = cn10k_mcs_get_rxsc(cfg, ctx->secy, ctx->rx_sc);
+	if (!rxsc)
+		return -ENOENT;
+
+	cn10k_mcs_ena_dis_flowid(pfvf, rxsc->hw_flow_id, false, MCS_RX);
+	cn10k_mcs_delete_rxsc(pfvf, rxsc);
+	list_del(&rxsc->entry);
+	kfree(rxsc);
+
+	return 0;
+}
+
+static int cn10k_mdo_add_rxsa(struct macsec_context *ctx)
+{
+	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_rx_sa *rx_sa = ctx->sa.rx_sa;
+	u64 next_pn = rx_sa->next_pn_halves.lower;
+	struct macsec_secy *secy = ctx->secy;
+	bool sa_in_use = rx_sa->active;
+	u8 sa_num = ctx->sa.assoc_num;
+	struct cn10k_mcs_rxsc *rxsc;
+	int err;
+
+	rxsc = cn10k_mcs_get_rxsc(cfg, secy, sw_rx_sc);
+	if (!rxsc)
+		return -ENOENT;
+
+	if (sa_num >= CN10K_MCS_SA_PER_SC)
+		return -EOPNOTSUPP;
+
+	if (cn10k_mcs_alloc_rxsa(pfvf, &rxsc->hw_sa_id[sa_num]))
+		return -ENOSPC;
+
+	memcpy(&rxsc->sa_key[sa_num], ctx->sa.key, ctx->secy->key_len);
+	rxsc->sa_bmap |= 1 << sa_num;
+
+	if (netif_running(secy->netdev)) {
+		err = cn10k_mcs_write_rx_sa_plcy(pfvf, secy, rxsc,
+						 sa_num, sa_in_use);
+		if (err)
+			return err;
+
+		err = cn10k_mcs_write_rx_sa_pn(pfvf, rxsc, sa_num, next_pn);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int cn10k_mdo_upd_rxsa(struct macsec_context *ctx)
+{
+	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_rx_sa *rx_sa = ctx->sa.rx_sa;
+	u64 next_pn = rx_sa->next_pn_halves.lower;
+	struct macsec_secy *secy = ctx->secy;
+	bool sa_in_use = rx_sa->active;
+	u8 sa_num = ctx->sa.assoc_num;
+	struct cn10k_mcs_rxsc *rxsc;
+	int err;
+
+	rxsc = cn10k_mcs_get_rxsc(cfg, secy, sw_rx_sc);
+	if (!rxsc)
+		return -ENOENT;
+
+	if (sa_num >= CN10K_MCS_SA_PER_SC)
+		return -EOPNOTSUPP;
+
+	if (netif_running(secy->netdev)) {
+		err = cn10k_mcs_write_rx_sa_plcy(pfvf, secy, rxsc, sa_num, sa_in_use);
+		if (err)
+			return err;
+
+		err = cn10k_mcs_write_rx_sa_pn(pfvf, rxsc, sa_num, next_pn);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int cn10k_mdo_del_rxsa(struct macsec_context *ctx)
+{
+	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	u8 sa_num = ctx->sa.assoc_num;
+	struct cn10k_mcs_rxsc *rxsc;
+
+	rxsc = cn10k_mcs_get_rxsc(cfg, ctx->secy, sw_rx_sc);
+	if (!rxsc)
+		return -ENOENT;
+
+	if (sa_num >= CN10K_MCS_SA_PER_SC)
+		return -EOPNOTSUPP;
+
+	cn10k_mcs_write_rx_sa_plcy(pfvf, ctx->secy, rxsc, sa_num, false);
+	cn10k_mcs_free_rxsa(pfvf, rxsc->hw_sa_id[sa_num]);
+
+	rxsc->sa_bmap &= ~(1 << sa_num);
+
+	return 0;
+}
+
+static int cn10k_mdo_get_dev_stats(struct macsec_context *ctx)
+{
+	struct mcs_secy_stats tx_rsp = { 0 }, rx_rsp = { 0 };
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_secy *secy = ctx->secy;
+	struct cn10k_mcs_txsc *txsc;
+
+	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
+	if (!txsc)
+		return -ENOENT;
+
+	cn10k_mcs_secy_stats(pfvf, txsc->hw_secy_id_tx, &tx_rsp, MCS_TX, false);
+	ctx->stats.dev_stats->OutPktsUntagged = tx_rsp.pkt_untagged_cnt;
+	ctx->stats.dev_stats->OutPktsTooLong = tx_rsp.pkt_toolong_cnt;
+
+	cn10k_mcs_secy_stats(pfvf, txsc->hw_secy_id_rx, &rx_rsp, MCS_RX, true);
+	txsc->stats.InPktsBadTag += rx_rsp.pkt_badtag_cnt;
+	txsc->stats.InPktsUnknownSCI += rx_rsp.pkt_nosa_cnt;
+	txsc->stats.InPktsNoSCI += rx_rsp.pkt_nosaerror_cnt;
+	if (secy->validate_frames == MACSEC_VALIDATE_STRICT)
+		txsc->stats.InPktsNoTag += rx_rsp.pkt_untaged_cnt;
+	else
+		txsc->stats.InPktsUntagged += rx_rsp.pkt_untaged_cnt;
+	txsc->stats.InPktsOverrun = 0;
+
+	ctx->stats.dev_stats->InPktsNoTag = txsc->stats.InPktsNoTag;
+	ctx->stats.dev_stats->InPktsUntagged = txsc->stats.InPktsUntagged;
+	ctx->stats.dev_stats->InPktsBadTag = txsc->stats.InPktsBadTag;
+	ctx->stats.dev_stats->InPktsUnknownSCI = txsc->stats.InPktsUnknownSCI;
+	ctx->stats.dev_stats->InPktsNoSCI = txsc->stats.InPktsNoSCI;
+	ctx->stats.dev_stats->InPktsOverrun = txsc->stats.InPktsOverrun;
+
+	return 0;
+}
+
+static int cn10k_mdo_get_tx_sc_stats(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct mcs_sc_stats rsp = { 0 };
+	struct cn10k_mcs_txsc *txsc;
+
+	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
+	if (!txsc)
+		return -ENOENT;
+
+	cn10k_mcs_sc_stats(pfvf, txsc->hw_sc_id, &rsp, MCS_TX, false);
+
+	ctx->stats.tx_sc_stats->OutPktsProtected = rsp.pkt_protected_cnt;
+	ctx->stats.tx_sc_stats->OutPktsEncrypted = rsp.pkt_encrypt_cnt;
+	ctx->stats.tx_sc_stats->OutOctetsProtected = rsp.octet_protected_cnt;
+	ctx->stats.tx_sc_stats->OutOctetsEncrypted = rsp.octet_encrypt_cnt;
+
+	return 0;
+}
+
+static int cn10k_mdo_get_tx_sa_stats(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct mcs_sa_stats rsp = { 0 };
+	u8 sa_num = ctx->sa.assoc_num;
+	struct cn10k_mcs_txsc *txsc;
+
+	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
+	if (!txsc)
+		return -ENOENT;
+
+	if (sa_num >= CN10K_MCS_SA_PER_SC)
+		return -EOPNOTSUPP;
+
+	cn10k_mcs_sa_stats(pfvf, txsc->hw_sa_id[sa_num], &rsp, MCS_TX, false);
+
+	ctx->stats.tx_sa_stats->OutPktsProtected = rsp.pkt_protected_cnt;
+	ctx->stats.tx_sa_stats->OutPktsEncrypted = rsp.pkt_encrypt_cnt;
+
+	return 0;
+}
+
+static int cn10k_mdo_get_rx_sc_stats(struct macsec_context *ctx)
+{
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_secy *secy = ctx->secy;
+	struct mcs_sc_stats rsp = { 0 };
+	struct cn10k_mcs_rxsc *rxsc;
+
+	rxsc = cn10k_mcs_get_rxsc(cfg, secy, ctx->rx_sc);
+	if (!rxsc)
+		return -ENOENT;
+
+	cn10k_mcs_sc_stats(pfvf, rxsc->hw_sc_id, &rsp, MCS_RX, true);
+
+	rxsc->stats.InOctetsValidated += rsp.octet_validate_cnt;
+	rxsc->stats.InOctetsDecrypted += rsp.octet_decrypt_cnt;
+
+	rxsc->stats.InPktsInvalid += rsp.pkt_invalid_cnt;
+	rxsc->stats.InPktsNotValid += rsp.pkt_notvalid_cnt;
+
+	if (secy->protect_frames)
+		rxsc->stats.InPktsLate += rsp.pkt_late_cnt;
+	else
+		rxsc->stats.InPktsDelayed += rsp.pkt_late_cnt;
+
+	if (secy->validate_frames == MACSEC_VALIDATE_CHECK)
+		rxsc->stats.InPktsUnchecked += rsp.pkt_unchecked_cnt;
+	else
+		rxsc->stats.InPktsOK += rsp.pkt_unchecked_cnt;
+
+	ctx->stats.rx_sc_stats->InOctetsValidated = rxsc->stats.InOctetsValidated;
+	ctx->stats.rx_sc_stats->InOctetsDecrypted = rxsc->stats.InOctetsDecrypted;
+	ctx->stats.rx_sc_stats->InPktsInvalid = rxsc->stats.InPktsInvalid;
+	ctx->stats.rx_sc_stats->InPktsNotValid = rxsc->stats.InPktsNotValid;
+	ctx->stats.rx_sc_stats->InPktsLate = rxsc->stats.InPktsLate;
+	ctx->stats.rx_sc_stats->InPktsDelayed = rxsc->stats.InPktsDelayed;
+	ctx->stats.rx_sc_stats->InPktsUnchecked = rxsc->stats.InPktsUnchecked;
+	ctx->stats.rx_sc_stats->InPktsOK = rxsc->stats.InPktsOK;
+
+	return 0;
+}
+
+static int cn10k_mdo_get_rx_sa_stats(struct macsec_context *ctx)
+{
+	struct macsec_rx_sc *sw_rx_sc = ctx->sa.rx_sa->sc;
+	struct otx2_nic *pfvf = netdev_priv(ctx->netdev);
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct mcs_sa_stats rsp = { 0 };
+	u8 sa_num = ctx->sa.assoc_num;
+	struct cn10k_mcs_rxsc *rxsc;
+
+	rxsc = cn10k_mcs_get_rxsc(cfg, ctx->secy, sw_rx_sc);
+	if (!rxsc)
+		return -ENOENT;
+
+	if (sa_num >= CN10K_MCS_SA_PER_SC)
+		return -EOPNOTSUPP;
+
+	cn10k_mcs_sa_stats(pfvf, rxsc->hw_sa_id[sa_num], &rsp, MCS_RX, false);
+
+	ctx->stats.rx_sa_stats->InPktsOK = rsp.pkt_ok_cnt;
+	ctx->stats.rx_sa_stats->InPktsInvalid = rsp.pkt_invalid_cnt;
+	ctx->stats.rx_sa_stats->InPktsNotValid = rsp.pkt_notvalid_cnt;
+	ctx->stats.rx_sa_stats->InPktsNotUsingSA = rsp.pkt_nosaerror_cnt;
+	ctx->stats.rx_sa_stats->InPktsUnusedSA = rsp.pkt_nosa_cnt;
+
+	return 0;
+}
+
+static const struct macsec_ops cn10k_mcs_ops = {
+	.mdo_dev_open = cn10k_mdo_open,
+	.mdo_dev_stop = cn10k_mdo_stop,
+	.mdo_add_secy = cn10k_mdo_add_secy,
+	.mdo_upd_secy = cn10k_mdo_upd_secy,
+	.mdo_del_secy = cn10k_mdo_del_secy,
+	.mdo_add_rxsc = cn10k_mdo_add_rxsc,
+	.mdo_upd_rxsc = cn10k_mdo_upd_rxsc,
+	.mdo_del_rxsc = cn10k_mdo_del_rxsc,
+	.mdo_add_rxsa = cn10k_mdo_add_rxsa,
+	.mdo_upd_rxsa = cn10k_mdo_upd_rxsa,
+	.mdo_del_rxsa = cn10k_mdo_del_rxsa,
+	.mdo_add_txsa = cn10k_mdo_add_txsa,
+	.mdo_upd_txsa = cn10k_mdo_upd_txsa,
+	.mdo_del_txsa = cn10k_mdo_del_txsa,
+	.mdo_get_dev_stats = cn10k_mdo_get_dev_stats,
+	.mdo_get_tx_sc_stats = cn10k_mdo_get_tx_sc_stats,
+	.mdo_get_tx_sa_stats = cn10k_mdo_get_tx_sa_stats,
+	.mdo_get_rx_sc_stats = cn10k_mdo_get_rx_sc_stats,
+	.mdo_get_rx_sa_stats = cn10k_mdo_get_rx_sa_stats,
+};
+
+void cn10k_handle_mcs_event(struct otx2_nic *pfvf, struct mcs_intr_info *event)
+{
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+	struct macsec_tx_sa *sw_tx_sa = NULL;
+	struct macsec_secy *secy = NULL;
+	struct cn10k_mcs_txsc *txsc;
+	u8 an;
+
+	if (!test_bit(CN10K_HW_MACSEC, &pfvf->hw.cap_flag))
+		return;
+
+	if (!(event->intr_mask & MCS_CPM_TX_PACKET_XPN_EQ0_INT))
+		return;
+
+	/* Find the SecY to which the expired hardware SA is mapped */
+	list_for_each_entry(txsc, &cfg->txsc_list, entry) {
+		for (an = 0; an < CN10K_MCS_SA_PER_SC; an++)
+			if (txsc->hw_sa_id[an] == event->sa_id) {
+				secy = txsc->sw_secy;
+				sw_tx_sa = rcu_dereference_bh(secy->tx_sc.sa[an]);
+			}
+	}
+
+	if (secy && sw_tx_sa)
+		macsec_pn_wrapped(secy, sw_tx_sa);
+}
+
+int cn10k_mcs_init(struct otx2_nic *pfvf)
+{
+	struct mbox *mbox = &pfvf->mbox;
+	struct cn10k_mcs_cfg *cfg;
+	struct mcs_intr_cfg *req;
+
+	if (!test_bit(CN10K_HW_MACSEC, &pfvf->hw.cap_flag))
+		return 0;
+
+	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&cfg->txsc_list);
+	INIT_LIST_HEAD(&cfg->rxsc_list);
+	pfvf->macsec_cfg = cfg;
+
+	pfvf->netdev->features |= NETIF_F_HW_MACSEC;
+	pfvf->netdev->macsec_ops = &cn10k_mcs_ops;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_mcs_intr_cfg(mbox);
+	if (!req)
+		goto fail;
+
+	req->intr_mask = MCS_CPM_TX_PACKET_XPN_EQ0_INT;
+
+	if (otx2_sync_mbox_msg(mbox))
+		goto fail;
+
+	mutex_unlock(&mbox->lock);
+
+	return 0;
+fail:
+	dev_err(pfvf->dev, "Cannot notify PN wrapped event\n");
+	return 0;
+}
+
+void cn10k_mcs_free(struct otx2_nic *pfvf)
+{
+	if (!test_bit(CN10K_HW_MACSEC, &pfvf->hw.cap_flag))
+		return;
+
+	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY, 0, true);
+	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY, 0, true);
+	kfree(pfvf->macsec_cfg);
+	pfvf->macsec_cfg = NULL;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index bc3e6aae..9ac9e66 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1827,4 +1827,5 @@ otx2_mbox_up_handler_ ## _fn_name(struct otx2_nic *pfvf,		\
 }									\
 EXPORT_SYMBOL(otx2_mbox_up_handler_ ## _fn_name);
 MBOX_UP_CGX_MESSAGES
+MBOX_UP_MCS_MESSAGES
 #undef M
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 4c7691a..282db6f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -19,6 +19,7 @@
 #include <net/devlink.h>
 #include <linux/time64.h>
 #include <linux/dim.h>
+#include <uapi/linux/if_macsec.h>
 
 #include <mbox.h>
 #include <npc.h>
@@ -33,6 +34,7 @@
 #define PCI_DEVID_OCTEONTX2_RVU_AFVF		0xA0F8
 
 #define PCI_SUBSYS_DEVID_96XX_RVU_PFVF		0xB200
+#define PCI_SUBSYS_DEVID_CN10K_B_RVU_PFVF	0xBD00
 
 /* PCI BAR nos */
 #define PCI_CFG_REG_BAR_NUM                     2
@@ -244,6 +246,7 @@ struct otx2_hw {
 #define CN10K_LMTST		2
 #define CN10K_RPM		3
 #define CN10K_PTP_ONESTEP	4
+#define CN10K_HW_MACSEC		5
 	unsigned long		cap_flag;
 
 #define LMT_LINE_SIZE		128
@@ -351,6 +354,66 @@ struct dev_hw_ops {
 	void	(*aura_freeptr)(void *dev, int aura, u64 buf);
 };
 
+#define CN10K_MCS_SA_PER_SC	4
+
+/* Stats which need to be accumulated in software because
+ * of shared counters in hardware.
+ */
+struct cn10k_txsc_stats {
+	u64 InPktsUntagged;
+	u64 InPktsNoTag;
+	u64 InPktsBadTag;
+	u64 InPktsUnknownSCI;
+	u64 InPktsNoSCI;
+	u64 InPktsOverrun;
+};
+
+struct cn10k_rxsc_stats {
+	u64 InOctetsValidated;
+	u64 InOctetsDecrypted;
+	u64 InPktsUnchecked;
+	u64 InPktsDelayed;
+	u64 InPktsOK;
+	u64 InPktsInvalid;
+	u64 InPktsLate;
+	u64 InPktsNotValid;
+	u64 InPktsNotUsingSA;
+	u64 InPktsUnusedSA;
+};
+
+struct cn10k_mcs_txsc {
+	struct macsec_secy *sw_secy;
+	struct cn10k_txsc_stats stats;
+	struct list_head entry;
+	enum macsec_validation_type last_validate_frames;
+	bool last_protect_frames;
+	u16 hw_secy_id_tx;
+	u16 hw_secy_id_rx;
+	u16 hw_flow_id;
+	u16 hw_sc_id;
+	u16 hw_sa_id[CN10K_MCS_SA_PER_SC];
+	u8 sa_bmap;
+	u8 sa_key[CN10K_MCS_SA_PER_SC][MACSEC_MAX_KEY_LEN];
+	u8 encoding_sa;
+};
+
+struct cn10k_mcs_rxsc {
+	struct macsec_secy *sw_secy;
+	struct macsec_rx_sc *sw_rxsc;
+	struct cn10k_rxsc_stats stats;
+	struct list_head entry;
+	u16 hw_flow_id;
+	u16 hw_sc_id;
+	u16 hw_sa_id[CN10K_MCS_SA_PER_SC];
+	u8 sa_bmap;
+	u8 sa_key[CN10K_MCS_SA_PER_SC][MACSEC_MAX_KEY_LEN];
+};
+
+struct cn10k_mcs_cfg {
+	struct list_head txsc_list;
+	struct list_head rxsc_list;
+};
+
 struct otx2_nic {
 	void __iomem		*reg_base;
 	struct net_device	*netdev;
@@ -438,6 +501,10 @@ struct otx2_nic {
 
 	/* napi event count. It is needed for adaptive irq coalescing. */
 	u32 napi_events;
+
+#if IS_ENABLED(CONFIG_MACSEC)
+	struct cn10k_mcs_cfg	*macsec_cfg;
+#endif
 };
 
 static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
@@ -477,6 +544,11 @@ static inline bool is_dev_otx2(struct pci_dev *pdev)
 		midr == PCI_REVISION_ID_95XXMM || midr == PCI_REVISION_ID_95XXO);
 }
 
+static inline bool is_dev_cn10kb(struct pci_dev *pdev)
+{
+	return pdev->subsystem_device == PCI_SUBSYS_DEVID_CN10K_B_RVU_PFVF;
+}
+
 static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 {
 	struct otx2_hw *hw = &pfvf->hw;
@@ -508,6 +580,9 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 		__set_bit(CN10K_RPM, &hw->cap_flag);
 		__set_bit(CN10K_PTP_ONESTEP, &hw->cap_flag);
 	}
+
+	if (is_dev_cn10kb(pfvf->pdev))
+		__set_bit(CN10K_HW_MACSEC, &hw->cap_flag);
 }
 
 /* Register read/write APIs */
@@ -763,6 +838,7 @@ otx2_mbox_up_handler_ ## _fn_name(struct otx2_nic *pfvf,		\
 				struct _rsp_type *rsp);			\
 
 MBOX_UP_CGX_MESSAGES
+MBOX_UP_MCS_MESSAGES
 #undef M
 
 /* Time to wait before watchdog kicks off */
@@ -945,4 +1021,18 @@ int otx2_pfc_txschq_alloc(struct otx2_nic *pfvf);
 int otx2_pfc_txschq_update(struct otx2_nic *pfvf);
 int otx2_pfc_txschq_stop(struct otx2_nic *pfvf);
 #endif
+
+#if IS_ENABLED(CONFIG_MACSEC)
+/* MACSEC offload support */
+int cn10k_mcs_init(struct otx2_nic *pfvf);
+void cn10k_mcs_free(struct otx2_nic *pfvf);
+void cn10k_handle_mcs_event(struct otx2_nic *pfvf, struct mcs_intr_info *event);
+#else
+static inline int cn10k_mcs_init(struct otx2_nic *pfvf) { return 0; }
+static inline void cn10k_mcs_free(struct otx2_nic *pfvf) {}
+static inline void cn10k_handle_mcs_event(struct otx2_nic *pfvf,
+					  struct mcs_intr_info *event)
+{}
+#endif /* CONFIG_MACSEC */
+
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index fa9348d..5803d7f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -858,6 +858,15 @@ static void otx2_handle_link_event(struct otx2_nic *pf)
 	}
 }
 
+int otx2_mbox_up_handler_mcs_intr_notify(struct otx2_nic *pf,
+					 struct mcs_intr_info *event,
+					 struct msg_rsp *rsp)
+{
+	cn10k_handle_mcs_event(pf, event);
+
+	return 0;
+}
+
 int otx2_mbox_up_handler_cgx_link_event(struct otx2_nic *pf,
 					struct cgx_link_info_msg *msg,
 					struct msg_rsp *rsp)
@@ -917,6 +926,7 @@ static int otx2_process_mbox_msg_up(struct otx2_nic *pf,
 		return err;						\
 	}
 MBOX_UP_CGX_MESSAGES
+MBOX_UP_MCS_MESSAGES
 #undef M
 		break;
 	default:
@@ -2764,6 +2774,10 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_ptp_destroy;
 
+	err = cn10k_mcs_init(pf);
+	if (err)
+		goto err_del_mcam_entries;
+
 	if (pf->flags & OTX2_FLAG_NTUPLE_SUPPORT)
 		netdev->hw_features |= NETIF_F_NTUPLE;
 
@@ -2978,6 +2992,8 @@ static void otx2_remove(struct pci_dev *pdev)
 		otx2_config_pause_frm(pf);
 	}
 
+	cn10k_mcs_free(pf);
+
 #ifdef CONFIG_DCB
 	/* Disable PFC config */
 	if (pf->pfc_en) {
-- 
2.7.4

