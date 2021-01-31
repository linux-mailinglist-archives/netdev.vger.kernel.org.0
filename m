Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9E7309CC0
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhAaOQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:16:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14250 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232477AbhAaNcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 08:32:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VD5uws026017;
        Sun, 31 Jan 2021 05:11:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=nMHFIkDEt4/PM7fJPn1gkFD4A3di4jOUuKhlm1VAh1c=;
 b=YcX7CKaLDPGwkrerpV4bc54uRmj9Stg9MVMIjiP1fDfSGVvUpoFPJx0zTh0DB0tUFoRZ
 pM8ZSsBkbCipJVae273L6Vjmr4/ykpIXFZsCRL/d0NvStgcGTOY/IXseYNkLnwQ56gXq
 Sl3rqWRE+S7zuFFbIbJOZtp3YyLsl8a0ebtQnhyzyuWYW9DOMqTQMiboZt0OaKACXFjR
 GqYxlDUgbQJU8kMicjvI4V8mgzKU+aIVmRTYloGW1i4JnkLoXF9XbiuwhuqnxLnUNdad
 chBL4UtNm7HFTOFJ/lrJDbGVJE3/mlW/wvQI3xDJTC6utq8hFQvQv1kKSKoDBwsXWjZ2 Xg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq1kbx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 05:11:27 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 05:11:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 05:11:25 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id D5E283F7043;
        Sun, 31 Jan 2021 05:11:21 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v3 net-next 4/7] octeontx2-af: Physical link configuration support
Date:   Sun, 31 Jan 2021 18:41:02 +0530
Message-ID: <1612098665-187767-5-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
References: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christina Jacob <cjacob@marvell.com>

CGX LMAC, the physical interface support link configuration parameters
like speed, auto negotiation, duplex  etc. Firmware saves these into
memory region shared between firmware and this driver.

This patch adds mailbox handler set_link_mode, fw_data_get to
configure and read these parameters.

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 58 +++++++++++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  2 +
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  | 18 ++++++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 21 ++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 17 +++++++
 5 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index b636341..5b7d858 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -660,6 +660,39 @@ static inline void cgx_link_usertable_init(void)
 	cgx_lmactype_string[LMAC_MODE_USXGMII] = "USXGMII";
 }
 
+static int cgx_link_usertable_index_map(int speed)
+{
+	switch (speed) {
+	case SPEED_10:
+		return CGX_LINK_10M;
+	case SPEED_100:
+		return CGX_LINK_100M;
+	case SPEED_1000:
+		return CGX_LINK_1G;
+	case SPEED_2500:
+		return CGX_LINK_2HG;
+	case SPEED_5000:
+		return CGX_LINK_5G;
+	case SPEED_10000:
+		return CGX_LINK_10G;
+	case SPEED_20000:
+		return CGX_LINK_20G;
+	case SPEED_25000:
+		return CGX_LINK_25G;
+	case SPEED_40000:
+		return CGX_LINK_40G;
+	case SPEED_50000:
+		return CGX_LINK_50G;
+	case 80000:
+		return CGX_LINK_80G;
+	case SPEED_100000:
+		return CGX_LINK_100G;
+	case SPEED_UNKNOWN:
+		return CGX_LINK_NONE;
+	}
+	return CGX_LINK_NONE;
+}
+
 static inline void link_status_user_format(u64 lstat,
 					   struct cgx_link_user_info *linfo,
 					   struct cgx *cgx, u8 lmac_id)
@@ -669,6 +702,7 @@ static inline void link_status_user_format(u64 lstat,
 	linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
 	linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
 	linfo->speed = cgx_speed_mbps[FIELD_GET(RESP_LINKSTAT_SPEED, lstat)];
+	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
 	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
 	linfo->lmac_type_id = cgx_get_lmac_type(cgx, lmac_id);
 	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
@@ -697,6 +731,9 @@ static inline void cgx_link_change_handler(u64 lstat,
 	lmac->link_info = event.link_uinfo;
 	linfo = &lmac->link_info;
 
+	if (err_type == CGX_ERR_SPEED_CHANGE_INVALID)
+		return;
+
 	/* Ensure callback doesn't get unregistered until we finish it */
 	spin_lock(&lmac->event_cb_lock);
 
@@ -725,7 +762,8 @@ static inline bool cgx_cmdresp_is_linkevent(u64 event)
 
 	id = FIELD_GET(EVTREG_ID, event);
 	if (id == CGX_CMD_LINK_BRING_UP ||
-	    id == CGX_CMD_LINK_BRING_DOWN)
+	    id == CGX_CMD_LINK_BRING_DOWN ||
+	    id == CGX_CMD_MODE_CHANGE)
 		return true;
 	else
 		return false;
@@ -840,6 +878,24 @@ int cgx_get_fwdata_base(u64 *base)
 	return err;
 }
 
+int cgx_set_link_mode(void *cgxd, struct cgx_set_link_mode_args args,
+		      int cgx_id, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+	u64 req = 0, resp;
+
+	if (!cgx)
+		return -ENODEV;
+
+	req = FIELD_SET(CMDREG_ID, CGX_CMD_MODE_CHANGE, req);
+	req = FIELD_SET(CMDMODECHANGE_SPEED,
+			cgx_link_usertable_index_map(args.speed), req);
+	req = FIELD_SET(CMDMODECHANGE_DUPLEX, args.duplex, req);
+	req = FIELD_SET(CMDMODECHANGE_AN, args.an, req);
+	req = FIELD_SET(CMDMODECHANGE_PORT, args.ports, req);
+	req = FIELD_SET(CMDMODECHANGE_FLAGS, args.flags, req);
+	return cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
+}
 int cgx_set_fec(u64 fec, int cgx_id, int lmac_id)
 {
 	u64 req = 0, resp;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index c5294b7..b458ad0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -155,5 +155,7 @@ u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id);
 int cgx_set_fec(u64 fec, int cgx_id, int lmac_id);
 int cgx_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp);
 int cgx_get_phy_fec_stats(void *cgxd, int lmac_id);
+int cgx_set_link_mode(void *cgxd, struct cgx_set_link_mode_args args,
+		      int cgx_id, int lmac_id);
 
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index 65f832a..70610e7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -43,7 +43,13 @@ enum cgx_error_type {
 	CGX_ERR_TRAINING_FAIL,
 	CGX_ERR_RX_EQU_FAIL,
 	CGX_ERR_SPUX_BER_FAIL,
-	CGX_ERR_SPUX_RSFEC_ALGN_FAIL,   /* = 22 */
+	CGX_ERR_SPUX_RSFEC_ALGN_FAIL,
+	CGX_ERR_SPUX_MARKER_LOCK_FAIL,
+	CGX_ERR_SET_FEC_INVALID,
+	CGX_ERR_SET_FEC_FAIL,
+	CGX_ERR_MODULE_INVALID,
+	CGX_ERR_MODULE_NOT_PRESENT,
+	CGX_ERR_SPEED_CHANGE_INVALID,
 };
 
 /* LINK speed types */
@@ -59,6 +65,7 @@ enum cgx_link_speed {
 	CGX_LINK_25G,
 	CGX_LINK_40G,
 	CGX_LINK_50G,
+	CGX_LINK_80G,
 	CGX_LINK_100G,
 	CGX_LINK_SPEED_MAX,
 };
@@ -75,7 +82,7 @@ enum cgx_cmd_id {
 	CGX_CMD_INTERNAL_LBK,
 	CGX_CMD_EXTERNAL_LBK,
 	CGX_CMD_HIGIG,
-	CGX_CMD_LINK_STATE_CHANGE,
+	CGX_CMD_LINK_STAT_CHANGE,
 	CGX_CMD_MODE_CHANGE,		/* hot plug support */
 	CGX_CMD_INTF_SHUTDOWN,
 	CGX_CMD_GET_MKEX_PRFL_SIZE,
@@ -219,4 +226,11 @@ struct cgx_lnk_sts {
 #define CMDLINKCHANGE_SPEED	GENMASK_ULL(13, 10)
 
 #define CMDSETFEC			GENMASK_ULL(9, 8)
+/* command argument to be passed for cmd ID - CGX_CMD_MODE_CHANGE */
+#define CMDMODECHANGE_SPEED		GENMASK_ULL(11, 8)
+#define CMDMODECHANGE_DUPLEX		GENMASK_ULL(12, 12)
+#define CMDMODECHANGE_AN		GENMASK_ULL(13, 13)
+#define CMDMODECHANGE_PORT		GENMASK_ULL(21, 14)
+#define CMDMODECHANGE_FLAGS		GENMASK_ULL(29, 22)
+
 #endif /* __CGX_FW_INTF_H__ */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 204040e..a050902 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -153,6 +153,8 @@ M(CGX_FEC_SET,		0x210, cgx_set_fec_param, fec_mode, fec_mode)   \
 M(CGX_FEC_STATS,	0x211, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
 M(CGX_GET_PHY_FEC_STATS, 0x212, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
 M(CGX_FW_DATA_GET,	0x213, cgx_get_aux_link_info, msg_req, cgx_fw_data) \
+M(CGX_SET_LINK_MODE,	0x214, cgx_set_link_mode, cgx_set_link_mode_req,\
+			       cgx_set_link_mode_rsp)	\
  /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
@@ -383,6 +385,7 @@ struct cgx_link_user_info {
 	uint64_t full_duplex:1;
 	uint64_t lmac_type_id:4;
 	uint64_t speed:20; /* speed in Mbps */
+	uint64_t an:1;		/* AN supported or not */
 	uint64_t fec:2;	 /* FEC type if enabled else 0 */
 #define LMACTYPE_STR_LEN 16
 	char lmac_type[LMACTYPE_STR_LEN];
@@ -454,6 +457,24 @@ struct cgx_fw_data {
 	struct cgx_lmac_fwdata_s fwdata;
 };
 
+struct cgx_set_link_mode_args {
+	u32 speed;
+	u8 duplex;
+	u8 an;
+	u8 ports;
+	u8 flags;
+};
+
+struct cgx_set_link_mode_req {
+	struct mbox_msghdr hdr;
+	struct cgx_set_link_mode_args args;
+};
+
+struct cgx_set_link_mode_rsp {
+	struct mbox_msghdr hdr;
+	int status;
+};
+
 /* NPA mbox message formats */
 
 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index c6fd2d5..1247bb7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -830,3 +830,20 @@ int rvu_mbox_handler_cgx_get_aux_link_info(struct rvu *rvu, struct msg_req *req,
 	       sizeof(struct cgx_lmac_fwdata_s));
 	return 0;
 }
+
+int rvu_mbox_handler_cgx_set_link_mode(struct rvu *rvu,
+				       struct cgx_set_link_mode_req *req,
+				       struct cgx_set_link_mode_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_idx, lmac;
+	void *cgxd;
+
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
+	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
+	rsp->status = cgx_set_link_mode(cgxd, req->args, cgx_idx, lmac);
+	return 0;
+}
-- 
2.7.4

