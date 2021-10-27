Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A3443C7AE
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 12:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbhJ0Kdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:33:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54788 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231643AbhJ0Kdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 06:33:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R6HcNa008431;
        Wed, 27 Oct 2021 03:31:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=cObWES/0aFmg3GBNFKjJmVTt9XyjUgheg5xCzY/punE=;
 b=eY/dskOvsIDr0PUDhfAYSW+Fh+rHU+5fhZSUgWnDzfsNM8HVmG9b4311umbGITcSM315
 6rzon6FKe1b3FCuW7PcWOqHR+60G0FAV9WZ7ZZSTxNVPeIzW/yZV7LIcxl/55qqmAAZ7
 rTV3d8Fu4AqZFYMudgRy3IEdcpHkiXQWHJLpv1Dsuk6wzTCzYn4ZaOuxyU2PkSNtkS5g
 CB0RWUBIFZY0phDm2epIJyvUYbI4i66UspzPslsxiTin8B/X+tk7MY77+U3dOwF9A8Kf
 4CcgKBDfY1qWge0/2jVNKaBwqqXvgo0O4p6otEFvrIDFoKyyigWvCWgUzdb1MieZlsX1 9g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bxuhpj5x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 03:31:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 03:31:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 03:31:23 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id A0B773F7075;
        Wed, 27 Oct 2021 03:31:20 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        <rsaladi2@marvell.com>, Vamsi Attunuru <vattunuru@marvell.com>,
        "Subbaraya Sundeep" <sbhatta@marvell.com>
Subject: [net-next PATCH 1/2] octeontx2-pf: Add devlink param to init and de-init serdes
Date:   Wed, 27 Oct 2021 16:01:14 +0530
Message-ID: <1635330675-25592-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SX3DBgLHhIkOrvRPTBq7PipdN9Aq0y0g
X-Proofpoint-GUID: SX3DBgLHhIkOrvRPTBq7PipdN9Aq0y0g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

The physical/SerDes link of an netdev interface is not
toggled on interface bring up and bring down. This is
because the same link is shared between PFs and its VFs.
This patch adds devlink param to toggle physical link so
that it is useful in cases where a physical link needs to
be re-initialized. A command is sent to firmware for
link change.

commands:
    devlink dev param show
        pci/0002:02:00.0:
          name serdes_link type driver-specific
     values:
          cmode runtime value true

    devlink dev param set pci/0002:02:00.0 name serdes_link value true
    cmode runtime

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 11 ++++++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  7 ++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 24 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 20 +++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  | 29 ++++++++++++++++++++++
 7 files changed, 93 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 186d00a9..26c8763 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1376,6 +1376,17 @@ static void cgx_lmac_linkup_work(struct work_struct *work)
 	}
 }
 
+int cgx_set_link_state(void *cgxd, int lmac_id, bool enable)
+{
+	struct cgx *cgx = cgxd;
+
+	if (!cgx)
+		return -ENODEV;
+
+	return cgx_fwi_link_change(cgx, lmac_id, enable);
+}
+EXPORT_SYMBOL(cgx_set_link_state);
+
 int cgx_lmac_linkup_start(void *cgxd)
 {
 	struct cgx *cgx = cgxd;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index ab1e4ab..4d7c320 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -172,4 +172,5 @@ u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset);
 int cgx_lmac_addr_update(u8 cgx_id, u8 lmac_id, u8 *mac_addr, u8 index);
 u64 cgx_read_dmac_ctrl(void *cgxd, int lmac_id);
 u64 cgx_read_dmac_entry(void *cgxd, int index);
+int cgx_set_link_state(void *cgxd, int lmac_id, bool enable);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 4e79e91..25c2497 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -162,6 +162,8 @@ M(CGX_MAC_ADDR_DEL,	0x212, cgx_mac_addr_del, cgx_mac_addr_del_req,    \
 			       msg_rsp)		\
 M(CGX_MAC_MAX_ENTRIES_GET, 0x213, cgx_mac_max_entries_get, msg_req,    \
 				  cgx_max_dmac_entries_get_rsp)		\
+M(CGX_SET_LINK_STATE,	0x214, cgx_set_link_state,			\
+			       cgx_set_link_state_msg, msg_rsp)		\
 M(CGX_FEC_STATS,	0x217, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
 M(CGX_SET_LINK_MODE,	0x218, cgx_set_link_mode, cgx_set_link_mode_req,\
 			       cgx_set_link_mode_rsp)	\
@@ -581,6 +583,11 @@ struct cgx_set_link_mode_rsp {
 	int status;
 };
 
+struct cgx_set_link_state_msg {
+	struct mbox_msghdr hdr;
+	u8 enable; /* '1' for link up, '0' for link down */
+};
+
 struct cgx_mac_addr_update_req {
 	struct mbox_msghdr hdr;
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 2ca182a..7781be1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1069,3 +1069,27 @@ int rvu_mbox_handler_cgx_mac_addr_update(struct rvu *rvu,
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_lmac_addr_update(cgx_id, lmac_id, req->mac_addr, req->index);
 }
+
+int rvu_mbox_handler_cgx_set_link_state(struct rvu *rvu,
+					struct cgx_set_link_state_msg *req,
+					struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	u8 cgx_id, lmac_id;
+	int pf, err;
+
+	pf = rvu_get_pf(pcifunc);
+
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return LMAC_AF_ERR_PERM_DENIED;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	err = cgx_set_link_state(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
+				 !!req->enable);
+	if (err)
+		dev_warn(rvu->dev, "Cannot set link state to %s, err %d\n",
+			 (req->enable) ? "enable" : "disable", err);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 66da31f..446378a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -263,6 +263,26 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
 	return err;
 }
 
+int otx2_config_serdes_link_state(struct otx2_nic *pfvf, bool en)
+{
+	struct cgx_set_link_state_msg *req;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_set_link_state(&pfvf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+
+	req->enable = !!en;
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+unlock:
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+EXPORT_SYMBOL(otx2_config_serdes_link_state);
+
 int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 61e5281..8e60e3c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -771,6 +771,7 @@ void otx2_get_mac_from_af(struct net_device *netdev);
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx);
 int otx2_config_pause_frm(struct otx2_nic *pfvf);
 void otx2_setup_segmentation(struct otx2_nic *pfvf);
+int otx2_config_serdes_link_state(struct otx2_nic *pfvf, bool en);
 
 /* RVU block related APIs */
 int otx2_attach_npa_nix(struct otx2_nic *pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 777a270..471097b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -64,9 +64,33 @@ static int otx2_dl_mcam_count_get(struct devlink *devlink, u32 id,
 	return 0;
 }
 
+static int otx2_dl_serdes_link_set(struct devlink *devlink, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+
+	if (!is_otx2_vf(pfvf->pcifunc))
+		return otx2_config_serdes_link_state(pfvf, ctx->val.vbool);
+
+	return -EOPNOTSUPP;
+}
+
+static int otx2_dl_serdes_link_get(struct devlink *devlink, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+
+	ctx->val.vbool = (pfvf->linfo.link_up) ? true : false;
+
+	return 0;
+}
+
 enum otx2_dl_param_id {
 	OTX2_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	OTX2_DEVLINK_PARAM_ID_MCAM_COUNT,
+	OTX2_DEVLINK_PARAM_ID_SERDES_LINK,
 };
 
 static const struct devlink_param otx2_dl_params[] = {
@@ -75,6 +99,11 @@ static const struct devlink_param otx2_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     otx2_dl_mcam_count_get, otx2_dl_mcam_count_set,
 			     otx2_dl_mcam_count_validate),
+	DEVLINK_PARAM_DRIVER(OTX2_DEVLINK_PARAM_ID_SERDES_LINK,
+			     "serdes_link", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_dl_serdes_link_get, otx2_dl_serdes_link_set,
+			     NULL),
 };
 
 /* Devlink OPs */
-- 
2.7.4

