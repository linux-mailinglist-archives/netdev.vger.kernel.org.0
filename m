Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A5B343248
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhCUMKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:10:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10190 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229883AbhCUMKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:10:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12LC5G3x023747;
        Sun, 21 Mar 2021 05:10:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8buGOtr0eugx/ZsBHN3wxj49ibipe44hW6VdD29TO8o=;
 b=fRje9ZsPdL+9CAQxznxAeXLcEIlkkNniO9QPSLfGBux7ex07+RFqNNTL7CNxo7N4s0YG
 9PcBUym6Hz5lMt8HQx21NssLf/H8reboo7rCOkzH0+36JXEQCZZ9mOKxGIip+gUuwS8P
 //k2t7w6w/nFwkFUFbZ0mj06Z0zatFve+24u6gcpioKEAaNh63XPqF8SNvjfDjUCdG3v
 V/3sMsjwIeMWQ5ChZLtmLkC9bZy1cSS98aW+P7owj7YagAOzpxSThi4u2wllOs4ik7th
 Ip/bfzhmsoQuNrrH6d/YnEBRkim0pzN6uZ8k+I3UcMHvvsQQtiOphn8KnsWHXtQ8644u og== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrab2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 05:10:08 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 05:10:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 21 Mar 2021 05:10:06 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id A8C073F704E;
        Sun, 21 Mar 2021 05:10:03 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 1/8] octeontx2-af: Add new CGX_CMDs to set and get PHY modulation type
Date:   Sun, 21 Mar 2021 17:39:51 +0530
Message-ID: <20210321120958.17531-2-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210321120958.17531-1-hkelam@marvell.com>
References: <20210321120958.17531-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-21_01:2021-03-19,2021-03-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Manlunas <fmanlunas@marvell.com>

Implement commands to set and get PHY line-side modulation type
(NRZ or PAM4) from firmware.

Signed-off-by: Felix Manlunas <fmanlunas@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 29 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  2 ++
 .../ethernet/marvell/octeontx2/af/cgx_fw_if.h |  6 ++++
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 10 +++++-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 31 +++++++++++++++++++
 5 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 68deae529bc..294e7d12f15 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1072,6 +1072,35 @@ int cgx_get_phy_fec_stats(void *cgxd, int lmac_id)
 	return cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
 }
 
+int cgx_set_phy_mod_type(int mod, void *cgxd, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+	u64 req = 0, resp;
+
+	if (!cgx)
+		return -ENODEV;
+
+	req = FIELD_SET(CMDREG_ID, CGX_CMD_SET_PHY_MOD_TYPE, req);
+	req = FIELD_SET(CMDSETPHYMODTYPE, mod, req);
+	return cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
+}
+
+int cgx_get_phy_mod_type(void *cgxd, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+	u64 req = 0, resp;
+	int err;
+
+	if (!cgx)
+		return -ENODEV;
+
+	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_PHY_MOD_TYPE, req);
+	err = cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
+	if (!err)
+		return FIELD_GET(RESP_GETPHYMODTYPE, resp);
+	return err;
+}
+
 static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool enable)
 {
 	u64 req = 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 12521262164..10b5611a3b4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -165,4 +165,6 @@ u8 cgx_get_lmacid(void *cgxd, u8 lmac_index);
 unsigned long cgx_get_lmac_bmap(void *cgxd);
 void cgx_lmac_write(int cgx_id, int lmac_id, u64 offset, u64 val);
 u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset);
+int cgx_set_phy_mod_type(int mod, void *cgxd, int lmac_id);
+int cgx_get_phy_mod_type(void *cgxd, int lmac_id);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index aa4e42f78f1..6bde02c8e4b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -264,4 +264,10 @@ struct cgx_lnk_sts {
 #define CMDMODECHANGE_PORT		GENMASK_ULL(21, 14)
 #define CMDMODECHANGE_FLAGS		GENMASK_ULL(63, 22)
 
+/* command argument to be passed for cmd ID - CGX_CMD_SET_PHY_MOD_TYPE */
+#define CMDSETPHYMODTYPE	GENMASK_ULL(8, 8)
+
+/* response to cmd ID - RESP_GETPHYMODTYPE */
+#define RESP_GETPHYMODTYPE	GENMASK_ULL(9, 9)
+
 #endif /* __CGX_FW_INTF_H__ */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 3af4d0ffcf7..66ab320b845 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -162,7 +162,10 @@ M(CGX_SET_LINK_MODE,	0x214, cgx_set_link_mode, cgx_set_link_mode_req,\
 M(CGX_FEATURES_GET,	0x215, cgx_features_get, msg_req,		\
 			       cgx_features_info_msg)			\
 M(RPM_STATS,		0x216, rpm_stats, msg_req, rpm_stats_rsp)	\
- /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
+M(CGX_GET_PHY_MOD_TYPE, 0x217, cgx_get_phy_mod_type, msg_req,		\
+			       cgx_phy_mod_type)                        \
+M(CGX_SET_PHY_MOD_TYPE, 0x218, cgx_set_phy_mod_type, cgx_phy_mod_type,	\
+			       msg_rsp) \
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
 				npa_lf_alloc_req, npa_lf_alloc_rsp)	\
@@ -510,6 +513,11 @@ struct rpm_stats_rsp {
 	u64 tx_stats[RPM_TX_STATS_COUNT];
 };
 
+struct cgx_phy_mod_type {
+	struct mbox_msghdr hdr;
+	int mod;
+};
+
 /* NPA mbox message formats */
 
 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index e668e482383..b78e48d18f6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -939,3 +939,34 @@ int rvu_mbox_handler_cgx_set_link_mode(struct rvu *rvu,
 	rsp->status = cgx_set_link_mode(cgxd, req->args, cgx_idx, lmac);
 	return 0;
 }
+
+int rvu_mbox_handler_cgx_set_phy_mod_type(struct rvu *rvu,
+					  struct cgx_phy_mod_type *req,
+					  struct msg_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	return cgx_set_phy_mod_type(req->mod, rvu_cgx_pdata(cgx_id, rvu),
+				    lmac_id);
+}
+
+int rvu_mbox_handler_cgx_get_phy_mod_type(struct rvu *rvu, struct msg_req *req,
+					  struct cgx_phy_mod_type *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	rsp->mod = cgx_get_phy_mod_type(rvu_cgx_pdata(cgx_id, rvu), lmac_id);
+	if (rsp->mod < 0)
+		return rsp->mod;
+	return 0;
+}
-- 
2.17.1

