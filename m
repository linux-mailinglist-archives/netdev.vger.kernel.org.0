Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876BF318352
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 02:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBKB4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 20:56:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35868 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230179AbhBKBtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 20:49:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11B1kgKx000423;
        Wed, 10 Feb 2021 17:48:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=0M0SD2wSsN0orD4MfhmK710/UXhQIgcHGsLyie1jkZI=;
 b=SzUSjUvbaYtAblM2tWgxLB4AbyphxEdnU7xod8xfCf48IG2uju/NjzdD7hFYWE4ggb6l
 d4UX3mh5JfZ7VJw7kemoQQ3bKTHuViqF+zvFBvuvHUekmRQRjRdt0iSZ+qgQgUWtsRUl
 2QeXjpSNQ4ui4MvBCbtGiW8ZRbvfZ8tQZPuflI/OWoY+OQOU9dLDTIy2Hmk4F6XyKtOJ
 wYMmP9yeZF/DFIMVmHpTEAX1fHE2dOqomyPs42Uq2wRHOI/6z9Sh8gNmcOcAdPz3VQWp
 ZXDZ6D8qhi+hze7TNzfOs9J+tB0tFU9FjcxKwXfrR++4weeiVF6FwImRtAafZWJFtUM7 Qg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqdhdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:48:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 17:48:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 17:48:24 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 761B53F703F;
        Wed, 10 Feb 2021 17:48:20 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <jerinj@marvell.com>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <schalla@marvell.com>, Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v5 14/14] octeontx2-af: cn10k: MAC internal loopback support
Date:   Thu, 11 Feb 2021 07:16:31 +0530
Message-ID: <20210211014631.9578-15-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210211014631.9578-1-gakula@marvell.com>
References: <20210211014631.9578-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

MAC on CN10K silicon support loopback for selftest or debug purposes.
This patch does necessary configuration to loopback packets upon receiving
request from LMAC mapped RVU PF's netdev via mailbox.

Also MAC (CGX) on OcteonTx2 silicon variants and MAC (RPM) on
OcteonTx3 CN10K are different and loopback needs to be configured
differently. Upper layer interface between RVU AF and PF netdev is
kept same. Based on silicon variant appropriate fn() pointer is
called to config the MAC.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |  9 ++--
 .../ethernet/marvell/octeontx2/af/cgx_fw_if.h |  1 +
 .../marvell/octeontx2/af/lmac_common.h        |  4 +-
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 44 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  5 +++
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  6 +--
 6 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 7b03234567ca..fefefa4db726 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -228,8 +228,9 @@ int cgx_set_pkind(void *cgxd, u8 lmac_id, int pkind)
 	return 0;
 }
 
-static inline u8 cgx_get_lmac_type(struct cgx *cgx, int lmac_id)
+static u8 cgx_get_lmac_type(void *cgxd, int lmac_id)
 {
+	struct cgx *cgx = cgxd;
 	u64 cfg;
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
@@ -246,7 +247,7 @@ int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable)
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
-	lmac_type = cgx_get_lmac_type(cgx, lmac_id);
+	lmac_type = cgx->mac_ops->get_lmac_type(cgx, lmac_id);
 	if (lmac_type == LMAC_MODE_SGMII || lmac_type == LMAC_MODE_QSGMII) {
 		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_PCS_MRX_CTL);
 		if (enable)
@@ -637,7 +638,7 @@ static inline void link_status_user_format(u64 lstat,
 	linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
 	linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
 	linfo->speed = cgx_speed_mbps[FIELD_GET(RESP_LINKSTAT_SPEED, lstat)];
-	linfo->lmac_type_id = cgx_get_lmac_type(cgx, lmac_id);
+	linfo->lmac_type_id = FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
 	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
 	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);
 }
@@ -1046,6 +1047,8 @@ static struct mac_ops	cgx_mac_ops    = {
 	.rx_stats_cnt   =       9,
 	.tx_stats_cnt   =       18,
 	.get_nr_lmacs	=	cgx_get_nr_lmacs,
+	.get_lmac_type  =       cgx_get_lmac_type,
+	.mac_lmac_intl_lbk =    cgx_lmac_internal_loopback,
 	.mac_get_rx_stats  =	cgx_get_rx_stats,
 	.mac_get_tx_stats  =	cgx_get_tx_stats,
 	.mac_enadis_rx_pause_fwding =	cgx_lmac_enadis_rx_pause_fwding,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index c3702fa58b6b..c07a96ed6c61 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -154,6 +154,7 @@ enum cgx_cmd_own {
  * CGX_STAT_SUCCESS
  */
 #define RESP_FWD_BASE		GENMASK_ULL(56, 9)
+#define RESP_LINKSTAT_LMAC_TYPE                GENMASK_ULL(35, 28)
 
 /* Response to cmd ID - CGX_CMD_LINK_BRING_UP/DOWN, event ID CGX_EVT_LINK_CHANGE
  * status can be either CGX_STAT_FAIL or CGX_STAT_SUCCESS
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index fea230393782..45706fd87120 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -70,7 +70,9 @@ struct mac_ops {
 	 * number of setbits in lmac_exist tells number of lmacs
 	 */
 	int			(*get_nr_lmacs)(void *cgx);
-
+	u8                      (*get_lmac_type)(void *cgx, int lmac_id);
+	int                     (*mac_lmac_intl_lbk)(void *cgx, int lmac_id,
+						     bool enable);
 	/* Register Stats related functions */
 	int			(*mac_get_rx_stats)(void *cgx, int lmac_id,
 						    int idx, u64 *rx_stat);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 3870cd436683..a91ccdc59403 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -21,6 +21,8 @@ static struct mac_ops	rpm_mac_ops   = {
 	.rx_stats_cnt   =       43,
 	.tx_stats_cnt   =       34,
 	.get_nr_lmacs	=	rpm_get_nr_lmacs,
+	.get_lmac_type  =       rpm_get_lmac_type,
+	.mac_lmac_intl_lbk =    rpm_lmac_internal_loopback,
 	.mac_get_rx_stats  =	rpm_get_rx_stats,
 	.mac_get_tx_stats  =	rpm_get_tx_stats,
 	.mac_enadis_rx_pause_fwding =	rpm_lmac_enadis_rx_pause_fwding,
@@ -226,3 +228,45 @@ int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat)
 	mutex_unlock(&rpm->lock);
 	return 0;
 }
+
+u8 rpm_get_lmac_type(void *rpmd, int lmac_id)
+{
+	rpm_t *rpm = rpmd;
+	u64 req = 0, resp;
+	int err;
+
+	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_LINK_STS, req);
+	err = cgx_fwi_cmd_generic(req, &resp, rpm, 0);
+	if (!err)
+		return FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, resp);
+	return err;
+}
+
+int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u8 lmac_type;
+	u64 cfg;
+
+	if (!rpm || lmac_id >= rpm->lmac_count)
+		return -ENODEV;
+	lmac_type = rpm->mac_ops->get_lmac_type(rpm, lmac_id);
+	if (lmac_type == LMAC_MODE_100G_R) {
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1);
+
+		if (enable)
+			cfg |= RPMX_MTI_PCS_LBK;
+		else
+			cfg &= ~RPMX_MTI_PCS_LBK;
+		rpm_write(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1, cfg);
+	} else {
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_LPCSX_CONTROL1);
+		if (enable)
+			cfg |= RPMX_MTI_PCS_LBK;
+		else
+			cfg &= ~RPMX_MTI_PCS_LBK;
+		rpm_write(rpm, lmac_id, RPMX_MTI_LPCSX_CONTROL1, cfg);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index c939302308b5..d32e74bd5964 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -18,6 +18,9 @@
 #define RPMX_CMRX_SW_INT_W1S            0x188
 #define RPMX_CMRX_SW_INT_ENA_W1S        0x198
 #define RPMX_CMRX_LINK_CFG		0x1070
+#define RPMX_MTI_PCS100X_CONTROL1       0x20000
+#define RPMX_MTI_LPCSX_CONTROL1         0x30000
+#define RPMX_MTI_PCS_LBK                BIT_ULL(14)
 #define RPMX_MTI_LPCSX_CONTROL(id)     (0x30000 | ((id) * 0x100))
 
 #define RPMX_CMRX_LINK_RANGE_MASK	GENMASK_ULL(19, 16)
@@ -41,6 +44,8 @@
 
 /* Function Declarations */
 int rpm_get_nr_lmacs(void *rpmd);
+u8 rpm_get_lmac_type(void *rpmd, int lmac_id);
+int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable);
 void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_get_pause_frm_status(void *cgxd, int lmac_id, u8 *tx_pause,
 				  u8 *rx_pause);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index e0f9414f8358..b3dd89a4c322 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -706,15 +706,15 @@ u32 rvu_cgx_get_fifolen(struct rvu *rvu)
 
 static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
 {
-	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, pcifunc))
 		return -EPERM;
 
-	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
 
-	return cgx_lmac_internal_loopback(rvu_cgx_pdata(cgx_id, rvu),
+	return mac_ops->mac_lmac_intl_lbk(rvu_cgx_pdata(cgx_id, rvu),
 					  lmac_id, en);
 }
 
-- 
2.17.1

