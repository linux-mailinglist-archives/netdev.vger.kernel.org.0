Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6D824A7B6
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgHSU3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:29:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6338 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727082AbgHSU3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:29:43 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JKK9uL021262;
        Wed, 19 Aug 2020 13:29:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=qTvrAALTusaFrLROoENsrwSttre1kxw+6KTrU+EGQ0w=;
 b=Gw1iUPec40OL7xnoWkoIQTZST+StCV6fktZfr0vBPKAf+rqUjvc9NUTO/daV7d4FDLSV
 Cpqu3g7WV/k9d/BCPCMBgrD0nRxavsk/4MsqyGn50IUcTQ9GxVCCzw/80Y9MHEFIYZp8
 70SXnsPDUe1wrDaat58wLQ3CnvID1pRwaI/fME0pbp/mFCYePrurG2eZjmdXbMJnW9b9
 Wfzx0TbNMVyNK/QVA+PU5cjJnFLUBw9A6+yTCbK2kO2oQNQ9QXcqdFEuCaweCipNlCS5
 C33tzgEsGH+1PUx3H1p9gKfjv9x33O/Ar4LA6NZ+JVZl98Opt2vk36McPjcAeSp8L7OZ pA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhsmty-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 13:29:38 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 Aug
 2020 13:29:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Aug 2020 13:29:36 -0700
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.54.69])
        by maili.marvell.com (Postfix) with ESMTP id 3D3F13F703F;
        Wed, 19 Aug 2020 13:29:34 -0700 (PDT)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Dmitry Bogdanov <dbogdanov@marvell.com>,
        Manish Chopra <mchopra@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net 1/3] net: qed: Disable aRFS for NPAR and 100G
Date:   Wed, 19 Aug 2020 23:29:27 +0300
Message-ID: <ef4c8d8002a50a0d69978e8fca1b8fa8227a4519.1597833340.git.dbogdanov@marvell.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <cover.1597833340.git.dbogdanov@marvell.com>
References: <cover.1597833340.git.dbogdanov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In CMT and NPAR the PF is unknown when the GFS block processes the
packet. Therefore cannot use searcher as it has a per PF database,
and thus ARFS must be disabled.

Fixes: d51e4af5c209 ("qed: aRFS infrastructure support")
Signed-off-by: Manish Chopra <mchopra@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c  | 11 ++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_l2.c   |  3 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c |  2 ++
 include/linux/qed/qed_if.h                 |  1 +
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index b3c9ebaf2280..c78a48ae9ea6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4253,7 +4253,8 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 			cdev->mf_bits = BIT(QED_MF_LLH_MAC_CLSS) |
 					BIT(QED_MF_LLH_PROTO_CLSS) |
 					BIT(QED_MF_LL2_NON_UNICAST) |
-					BIT(QED_MF_INTER_PF_SWITCH);
+					BIT(QED_MF_INTER_PF_SWITCH) |
+					BIT(QED_MF_DISABLE_ARFS);
 			break;
 		case NVM_CFG1_GLOB_MF_MODE_DEFAULT:
 			cdev->mf_bits = BIT(QED_MF_LLH_MAC_CLSS) |
@@ -4266,6 +4267,14 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 		DP_INFO(p_hwfn, "Multi function mode is 0x%lx\n",
 			cdev->mf_bits);
+
+		/* In CMT the PF is unknown when the GFS block processes the
+		 * packet. Therefore cannot use searcher as it has a per PF
+		 * database, and thus ARFS must be disabled.
+		 *
+		 */
+		if (QED_IS_CMT(cdev))
+			cdev->mf_bits |= BIT(QED_MF_DISABLE_ARFS);
 	}
 
 	DP_INFO(p_hwfn, "Multi function mode is 0x%lx\n",
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 4c6ac8862744..07824bf9d68d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -1980,6 +1980,9 @@ void qed_arfs_mode_configure(struct qed_hwfn *p_hwfn,
 			     struct qed_ptt *p_ptt,
 			     struct qed_arfs_config_params *p_cfg_params)
 {
+	if (test_bit(QED_MF_DISABLE_ARFS, &p_hwfn->cdev->mf_bits))
+		return;
+
 	if (p_cfg_params->mode != QED_FILTER_CONFIG_MODE_DISABLE) {
 		qed_gft_config(p_hwfn, p_ptt, p_hwfn->rel_pf_id,
 			       p_cfg_params->tcp,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2558cb680db3..309216ff7a84 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -444,6 +444,8 @@ int qed_fill_dev_info(struct qed_dev *cdev,
 		dev_info->fw_eng = FW_ENGINEERING_VERSION;
 		dev_info->b_inter_pf_switch = test_bit(QED_MF_INTER_PF_SWITCH,
 						       &cdev->mf_bits);
+		if (!test_bit(QED_MF_DISABLE_ARFS, &cdev->mf_bits))
+			dev_info->b_arfs_capable = true;
 		dev_info->tx_switching = true;
 
 		if (hw_info->b_wol_support == QED_WOL_SUPPORT_PME)
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index cd6a5c7e56eb..cdd73afc4c46 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -623,6 +623,7 @@ struct qed_dev_info {
 #define QED_MFW_VERSION_3_OFFSET	24
 
 	u32		flash_size;
+	bool		b_arfs_capable;
 	bool		b_inter_pf_switch;
 	bool		tx_switching;
 	bool		rdma_supported;
-- 
2.17.1

