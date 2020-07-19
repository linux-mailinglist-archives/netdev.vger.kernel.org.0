Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEE222540C
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 22:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGSUQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 16:16:13 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38584 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726996AbgGSUQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 16:16:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06JKFv4d012760;
        Sun, 19 Jul 2020 13:16:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=gOpE0CIDsE22VHBlzAJWjIPURA1X1fT9iugm/XZK37A=;
 b=TR1e2Of4RuoaysXbiDgaB0wIdPNY7AyhkjvyH980iPW2Yvja4fw8fRvimt9byWar1+Rc
 5ldrewH+nPeRniCGwij5hZWnN9AZ0/jP5uOsmxcCpgtO7MGToV2HHphCXH+3EgyVjgTV
 j/ALV8X2Nh41FIhvHRruemKttue72FZLl/kXI8QQ0Tr929u9DVHaKor5vZUo8KikNIxz
 ersqG/H9tEoExym4WYEF1OZ1tPdchTnwXaaRbs93fijsNLKmXi/vcww822xLbYMqMEAe
 Ywel0if1HYzW/jUkPwnWlCPcDVrTrRR0ptyRXFHk+KaSUQ81hpvrrEKngVYBTGtNjQ7q Qw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenbyuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 19 Jul 2020 13:16:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Jul
 2020 13:16:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 19 Jul 2020 13:16:08 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 358893F704B;
        Sun, 19 Jul 2020 13:16:03 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 11/14] qed: add support for new port modes
Date:   Sun, 19 Jul 2020 23:14:50 +0300
Message-ID: <20200719201453.3648-12-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200719201453.3648-1-alobakin@marvell.com>
References: <20200719201453.3648-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-19_04:2020-07-17,2020-07-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These ports ship on new boards revisions and are supported by newer
firmware versions.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 5 +++++
 drivers/net/ethernet/qlogic/qed/qed_hsi.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index eaf37822fed7..66a520099c44 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4004,6 +4004,11 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G:
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G:
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4:
 		break;
 	default:
 		DP_NOTICE(p_hwfn, "Unknown port mode in 0x%08x\n", core_cfg);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index a4a845579fd2..debc55923251 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -13015,6 +13015,11 @@ struct nvm_cfg1_glob {
 #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G			0xd
 #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G			0xe
 #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G			0xf
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1		0x11
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1		0x12
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2		0x13
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2		0x14
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4		0x15
 
 	u32							e_lane_cfg1;
 	u32							e_lane_cfg2;
-- 
2.25.1

