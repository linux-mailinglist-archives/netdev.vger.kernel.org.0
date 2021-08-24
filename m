Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6CA3F56E2
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 06:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhHXEDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 00:03:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36232 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229482AbhHXEDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 00:03:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NHEv6L021112;
        Mon, 23 Aug 2021 21:02:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Y+PI8mItc1EzxpSMlVZBfwt5yjVV6K0xVTxdRSwZS7E=;
 b=W7SH5HQQXtb22k3TcmZRx54O/qTKLM7HWCMZ3P+xhIdblTWh7+xXR1Oaw5q69h91i0Vm
 XMuH1Q4A0eFGQ3Hkyes9YtUpFO9NLH5zFelQxLv/nt8dbftusKEGuyyJ2Z0G5sFpacx+
 pzflpJuI7m42dPoJERV1IL7sQzrtI8MOfZVd8uYth7At6gBfP7xdVQ9Uhtt4EoWGtmIM
 Ia5rQyRvU6iVD+i0kDPH/dyg89cPqJw3pX2+jOiR9MHl7TIFqCdwOB32mJLrNexsG0DW
 mP6Fu6eWUulleu/E7ATj6FT67TMS4NfdxV7sWDJmjqC32XQFl1aPNVXb5lB34bKziyxs cw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3amfwj1x8m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 21:02:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 23 Aug
 2021 21:02:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 23 Aug 2021 21:02:54 -0700
Received: from alpha-dell-r720.punelab.qlogic.com032qlogic.org032qlogic.com032mv.qlogic.com032av.na032marvell.com (unknown [10.30.46.139])
        by maili.marvell.com (Postfix) with ESMTP id 2C8723F707D;
        Mon, 23 Aug 2021 21:02:51 -0700 (PDT)
From:   Alok Prasad <palok@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <GR-everest-linux-l2@marvell.com>
CC:     <smalin@marvell.com>, Alok Prasad <palok@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next] qed: Enable automatic recovery on error condition.
Date:   Tue, 24 Aug 2021 04:02:46 +0000
Message-ID: <20210824040246.21689-1-palok@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: yjDfZ-U8_Uu-vUCcivjYr6m5J4Lt4HwU
X-Proofpoint-GUID: yjDfZ-U8_Uu-vUCcivjYr6m5J4Lt4HwU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-24_01,2021-08-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables automatic recovery by default in case of various
error condition like fw assert , hardware error etc.
This also ensure driver can handle multiple iteration of assertion
conditions.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c     | 10 +++++++++
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h    |  8 +++++++
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 21 ++++++++++++++++++-
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index cf7f4da68e69..61349b8adf75 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -93,7 +93,7 @@ static const struct devlink_health_reporter_ops qed_fw_fatal_reporter_ops = {
 		.dump = qed_fw_fatal_reporter_dump,
 };
 
-#define QED_REPORTER_FW_GRACEFUL_PERIOD 1200000
+#define QED_REPORTER_FW_GRACEFUL_PERIOD 0
 
 void qed_fw_reporters_create(struct devlink *devlink)
 {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 578935f643b8..0993fea75ea1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -351,6 +351,9 @@ static int qed_fw_assertion(struct qed_hwfn *p_hwfn)
 	qed_hw_err_notify(p_hwfn, p_hwfn->p_dpc_ptt, QED_HW_ERR_FW_ASSERT,
 			  "FW assertion!\n");
 
+	/* Clear assert indications */
+	qed_wr(p_hwfn, p_hwfn->p_dpc_ptt, MISC_REG_AEU_GENERAL_ATTN_32, 0);
+
 	return -EINVAL;
 }
 
@@ -943,6 +946,13 @@ qed_int_deassertion_aeu_bit(struct qed_hwfn *p_hwfn,
 	DP_INFO(p_hwfn, "`%s' - Disabled future attentions\n",
 		p_bit_name);
 
+	/* Re-enable FW aassertion (Gen 32) interrupts */
+	val = qed_rd(p_hwfn, p_hwfn->p_dpc_ptt,
+		     MISC_REG_AEU_ENABLE4_IGU_OUT_0);
+	val |= MISC_REG_AEU_ENABLE4_IGU_OUT_0_GENERAL_ATTN32;
+	qed_wr(p_hwfn, p_hwfn->p_dpc_ptt,
+	       MISC_REG_AEU_ENABLE4_IGU_OUT_0, val);
+
 out:
 	return rc;
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
index 9db22be42476..da1b7fdcbda7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
@@ -504,6 +504,8 @@
 	0x180824UL
 #define  MISC_REG_AEU_GENERAL_ATTN_0 \
 	0x008400UL
+#define MISC_REG_AEU_GENERAL_ATTN_32 \
+	0x008480UL
 #define MISC_REG_AEU_GENERAL_ATTN_35 \
 	0x00848cUL
 #define  CAU_REG_SB_ADDR_MEMORY \
@@ -518,6 +520,12 @@
 	0x180804UL
 #define  MISC_REG_AEU_ENABLE1_IGU_OUT_0 \
 	0x00849cUL
+#define MISC_REG_AEU_ENABLE4_IGU_OUT_0 \
+	0x0084a8UL
+#define MISC_REG_AEU_ENABLE4_IGU_OUT_0_GENERAL_ATTN32      \
+	(0x1UL << 0)
+#define MISC_REG_AEU_ENABLE4_IGU_OUT_0_GENERAL_ATTN32_SHIFT \
+	0
 #define MISC_REG_AEU_AFTER_INVERT_1_IGU	\
 	0x0087b4UL
 #define  MISC_REG_AEU_MASK_ATTN_IGU \
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 7c6064baeba2..e86301cfb49c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1906,6 +1906,12 @@ static int qede_req_msix_irqs(struct qede_dev *edev)
 				 &edev->fp_array[i]);
 		if (rc) {
 			DP_ERR(edev, "Request fp %d irq failed\n", i);
+#ifdef CONFIG_RFS_ACCEL
+			if (edev->ndev->rx_cpu_rmap)
+				free_irq_cpu_rmap(edev->ndev->rx_cpu_rmap);
+
+			edev->ndev->rx_cpu_rmap = NULL;
+#endif
 			qede_sync_free_irqs(edev);
 			return rc;
 		}
@@ -2298,6 +2304,15 @@ static void qede_unload(struct qede_dev *edev, enum qede_unload_mode mode,
 
 		rc = qede_stop_queues(edev);
 		if (rc) {
+#ifdef CONFIG_RFS_ACCEL
+			if (edev->dev_info.common.b_arfs_capable) {
+				qede_poll_for_freeing_arfs_filters(edev);
+				if (edev->ndev->rx_cpu_rmap)
+					free_irq_cpu_rmap(edev->ndev->rx_cpu_rmap);
+
+				edev->ndev->rx_cpu_rmap = NULL;
+			}
+#endif
 			qede_sync_free_irqs(edev);
 			goto out;
 		}
@@ -2628,8 +2643,10 @@ static void qede_generic_hw_err_handler(struct qede_dev *edev)
 		  "Generic sleepable HW error handling started - err_flags 0x%lx\n",
 		  edev->err_flags);
 
-	if (edev->devlink)
+	if (edev->devlink) {
+		DP_NOTICE(edev, "Reporting fatal error to devlink\n");
 		edev->ops->common->report_fatal_error(edev->devlink, edev->last_err_type);
+	}
 
 	clear_bit(QEDE_ERR_IS_HANDLED, &edev->err_flags);
 
@@ -2651,6 +2668,8 @@ static void qede_set_hw_err_flags(struct qede_dev *edev,
 	case QED_HW_ERR_FW_ASSERT:
 		set_bit(QEDE_ERR_ATTN_CLR_EN, &err_flags);
 		set_bit(QEDE_ERR_GET_DBG_INFO, &err_flags);
+		/* make this error as recoverable and start recovery*/
+		set_bit(QEDE_ERR_IS_RECOVERABLE, &err_flags);
 		break;
 
 	default:
-- 
2.17.1

