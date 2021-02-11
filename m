Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB777318F90
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhBKQJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:09:49 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4516 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231166AbhBKQBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:01:11 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BFuZX1009103;
        Thu, 11 Feb 2021 08:00:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=tOJRPsvToGpolf8duCIgTDokYJGEyocpXFVNmADhVlk=;
 b=KWn6Mnd1+x9255E0gmyrLuGBD5UgpIyVSJShy0Ebu2Lhk1sdvJoO09X9NDwmJqiYTUMM
 KmLxZ+OWoNC1FrTBSAVCCpHzfyFtXDINVCpM2aM90BWa2Bl05fA1h3RDi4x2WZ/9Z/HV
 7W9FJABhuxXvmMHydd7gPat0WQM3gt44nmZQeRTpiH1ajE1tAoYsgd1iSqKCvHlqb8n2
 FKcPzF4zGpsmeNABn3iyXC3f/I94Q3UAknmAwlmpXWO8mG1b5r3+adKwL2mooi9sijRp
 9iPv43I4NPQxbIeDWBY7pPNi5Xp9loP8Zoya6595cOP/PVq/HUDH0nV6FUEOOrrpxTvW xA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrqjpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 08:00:23 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 08:00:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 08:00:22 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 5AA423F703F;
        Thu, 11 Feb 2021 08:00:18 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <jerinj@marvell.com>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <schalla@marvell.com>, Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v6 14/14] octeontx2-af: cn10k: MAC internal loopback support
Date:   Thu, 11 Feb 2021 21:28:34 +0530
Message-ID: <20210211155834.31874-15-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210211155834.31874-1-gakula@marvell.com>
References: <20210211155834.31874-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
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
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |  7 ++-
 .../ethernet/marvell/octeontx2/af/cgx_fw_if.h |  1 +
 .../marvell/octeontx2/af/lmac_common.h        |  4 +-
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 44 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  5 +++
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  6 +--
 6 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 0368d762bcff..9caa375d01b1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -229,8 +229,9 @@ int cgx_set_pkind(void *cgxd, u8 lmac_id, int pkind)
 	return 0;
 }
 
-static inline u8 cgx_get_lmac_type(struct cgx *cgx, int lmac_id)
+static u8 cgx_get_lmac_type(void *cgxd, int lmac_id)
 {
+	struct cgx *cgx = cgxd;
 	u64 cfg;
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
@@ -247,7 +248,7 @@ int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable)
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
-	lmac_type = cgx_get_lmac_type(cgx, lmac_id);
+	lmac_type = cgx->mac_ops->get_lmac_type(cgx, lmac_id);
 	if (lmac_type == LMAC_MODE_SGMII || lmac_type == LMAC_MODE_QSGMII) {
 		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_PCS_MRX_CTL);
 		if (enable)
@@ -1302,6 +1303,8 @@ static struct mac_ops	cgx_mac_ops    = {
 	.rx_stats_cnt   =       9,
 	.tx_stats_cnt   =       18,
 	.get_nr_lmacs	=	cgx_get_nr_lmacs,
+	.get_lmac_type  =       cgx_get_lmac_type,
+	.mac_lmac_intl_lbk =    cgx_lmac_internal_loopback,
 	.mac_get_rx_stats  =	cgx_get_rx_stats,
 	.mac_get_tx_stats  =	cgx_get_tx_stats,
 	.mac_enadis_rx_pause_fwding =	cgx_lmac_enadis_rx_pause_fwding,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index dde2bd0bc936..aa4e42f78f13 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -204,6 +204,7 @@ enum cgx_cmd_own {
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
index 0667ab3cfdae..3a1809c28e83 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -722,15 +722,15 @@ u32 rvu_cgx_get_fifolen(struct rvu *rvu)
 
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

