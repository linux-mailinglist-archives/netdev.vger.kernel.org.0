Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A17215ADC
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgGFPi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:38:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44172 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729254AbgGFPi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:38:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066Fa5JA025539;
        Mon, 6 Jul 2020 08:38:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=X+MXOx7NhITkl8HL34oJXJqK4OM/h/MbiBXZPGnr1fo=;
 b=lohervJPBpCWDKi4E5/6erNPxifz27j9uoHuhjTYOb4DXI71+ZZqkNeEjtwuPIlvGCCJ
 qFowxUgLuvMlviWPy9LP5E/8vl3C9xf9oZL1Hn7KpKhdR7rJqZ3TJCdvN3dllTOaFD5l
 KkRVi5Gm253eK7Gtb+2zi7hRjGOyNpSyliZ/mixEaR3Nkr1hPuRbdvevtGO/PK5522ds
 3saoYJmttCvjXDxVcqvk1eGEBq2kFYxISPZyJBPag+ckxSwtC4KUgwCQLqceGjQHe3C+
 o1UhuFvYmKQWVRNM4ECcxL9eD1l8fW3lEgKPEn2UO8lADu2eA/cz49cmy4L33eOH9r6T Wg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4pqm56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:38:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:38:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:38:54 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 683833F703F;
        Mon,  6 Jul 2020 08:38:51 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/9] net: qed: move static iro_arr[] out of header file
Date:   Mon, 6 Jul 2020 18:38:13 +0300
Message-ID: <20200706153821.786-2-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static variables (and functions, unless they're inline) should not
be declared in header files.
Move the static array iro_arr[] from "qed_hsi.h" to the sole place
where it's used, "qed_init_ops.c". This eliminates lots of warnings
(42 of them actually) against W=1+:

In file included from drivers/net/ethernet/qlogic/qed/qed.h:51:0,
                 from drivers/net/ethernet/qlogic/qed/qed_ooo.c:40:
drivers/net/ethernet/qlogic/qed/qed_hsi.h:4421:18: warning: 'iro_arr'
defined but not used [-Wunused-const-variable=]
 static const u32 iro_arr[] = {
                  ^~~~~~~

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     | 73 -------------------
 .../net/ethernet/qlogic/qed/qed_init_ops.c    | 73 +++++++++++++++++++
 2 files changed, 73 insertions(+), 73 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index d7e70625bdc4..1b5506c1364b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -4391,79 +4391,6 @@ void qed_fw_overlay_mem_free(struct qed_hwfn *p_hwfn,
 	(IRO[66].base + ((roce_pf_id) * IRO[66].m1))
 #define USTORM_ROCE_CQE_STATS_SIZE			(IRO[66].size)
 
-/* IRO Array */
-static const u32 iro_arr[] = {
-	0x00000000, 0x00000000, 0x00080000,
-	0x00003288, 0x00000088, 0x00880000,
-	0x000058e8, 0x00000020, 0x00200000,
-	0x00000b00, 0x00000008, 0x00040000,
-	0x00000a80, 0x00000008, 0x00040000,
-	0x00000000, 0x00000008, 0x00020000,
-	0x00000080, 0x00000008, 0x00040000,
-	0x00000084, 0x00000008, 0x00020000,
-	0x00005718, 0x00000004, 0x00040000,
-	0x00004dd0, 0x00000000, 0x00780000,
-	0x00003e40, 0x00000000, 0x00780000,
-	0x00004480, 0x00000000, 0x00780000,
-	0x00003210, 0x00000000, 0x00780000,
-	0x00003b50, 0x00000000, 0x00780000,
-	0x00007f58, 0x00000000, 0x00780000,
-	0x00005f58, 0x00000000, 0x00080000,
-	0x00007100, 0x00000000, 0x00080000,
-	0x0000aea0, 0x00000000, 0x00080000,
-	0x00004398, 0x00000000, 0x00080000,
-	0x0000a5a0, 0x00000000, 0x00080000,
-	0x0000bde8, 0x00000000, 0x00080000,
-	0x00000020, 0x00000004, 0x00040000,
-	0x000056c8, 0x00000010, 0x00100000,
-	0x0000c210, 0x00000030, 0x00300000,
-	0x0000b088, 0x00000038, 0x00380000,
-	0x00003d20, 0x00000080, 0x00400000,
-	0x0000bf60, 0x00000000, 0x00040000,
-	0x00004560, 0x00040080, 0x00040000,
-	0x000001f8, 0x00000004, 0x00040000,
-	0x00003d60, 0x00000080, 0x00200000,
-	0x00008960, 0x00000040, 0x00300000,
-	0x0000e840, 0x00000060, 0x00600000,
-	0x00004618, 0x00000080, 0x00380000,
-	0x00010738, 0x000000c0, 0x00c00000,
-	0x000001f8, 0x00000002, 0x00020000,
-	0x0000a2a0, 0x00000000, 0x01080000,
-	0x0000a3a8, 0x00000008, 0x00080000,
-	0x000001c0, 0x00000008, 0x00080000,
-	0x000001f8, 0x00000008, 0x00080000,
-	0x00000ac0, 0x00000008, 0x00080000,
-	0x00002578, 0x00000008, 0x00080000,
-	0x000024f8, 0x00000008, 0x00080000,
-	0x00000280, 0x00000008, 0x00080000,
-	0x00000680, 0x00080018, 0x00080000,
-	0x00000b78, 0x00080018, 0x00020000,
-	0x0000c640, 0x00000050, 0x003c0000,
-	0x00012038, 0x00000018, 0x00100000,
-	0x00011b00, 0x00000040, 0x00180000,
-	0x000095d0, 0x00000050, 0x00200000,
-	0x00008b10, 0x00000040, 0x00280000,
-	0x00011640, 0x00000018, 0x00100000,
-	0x0000c828, 0x00000048, 0x00380000,
-	0x00011710, 0x00000020, 0x00200000,
-	0x00004650, 0x00000080, 0x00100000,
-	0x00003618, 0x00000010, 0x00100000,
-	0x0000a968, 0x00000008, 0x00010000,
-	0x000097a0, 0x00000008, 0x00010000,
-	0x00011990, 0x00000008, 0x00010000,
-	0x0000f018, 0x00000008, 0x00010000,
-	0x00012628, 0x00000008, 0x00010000,
-	0x00011da8, 0x00000008, 0x00010000,
-	0x0000aa78, 0x00000030, 0x00100000,
-	0x0000d768, 0x00000028, 0x00280000,
-	0x00009a58, 0x00000018, 0x00180000,
-	0x00009bd8, 0x00000008, 0x00080000,
-	0x00013a18, 0x00000008, 0x00080000,
-	0x000126e8, 0x00000018, 0x00180000,
-	0x0000e608, 0x00500288, 0x00100000,
-	0x00012970, 0x00000138, 0x00280000,
-};
-
 /* Runtime array offsets */
 #define DORQ_REG_PF_MAX_ICID_0_RT_OFFSET				0
 #define DORQ_REG_PF_MAX_ICID_1_RT_OFFSET				1
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
index 736702fb81b5..7e6c6389523b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
@@ -43,6 +43,79 @@ static u32 pxp_global_win[] = {
 	0,
 };
 
+/* IRO Array */
+static const u32 iro_arr[] = {
+	0x00000000, 0x00000000, 0x00080000,
+	0x00003288, 0x00000088, 0x00880000,
+	0x000058e8, 0x00000020, 0x00200000,
+	0x00000b00, 0x00000008, 0x00040000,
+	0x00000a80, 0x00000008, 0x00040000,
+	0x00000000, 0x00000008, 0x00020000,
+	0x00000080, 0x00000008, 0x00040000,
+	0x00000084, 0x00000008, 0x00020000,
+	0x00005718, 0x00000004, 0x00040000,
+	0x00004dd0, 0x00000000, 0x00780000,
+	0x00003e40, 0x00000000, 0x00780000,
+	0x00004480, 0x00000000, 0x00780000,
+	0x00003210, 0x00000000, 0x00780000,
+	0x00003b50, 0x00000000, 0x00780000,
+	0x00007f58, 0x00000000, 0x00780000,
+	0x00005f58, 0x00000000, 0x00080000,
+	0x00007100, 0x00000000, 0x00080000,
+	0x0000aea0, 0x00000000, 0x00080000,
+	0x00004398, 0x00000000, 0x00080000,
+	0x0000a5a0, 0x00000000, 0x00080000,
+	0x0000bde8, 0x00000000, 0x00080000,
+	0x00000020, 0x00000004, 0x00040000,
+	0x000056c8, 0x00000010, 0x00100000,
+	0x0000c210, 0x00000030, 0x00300000,
+	0x0000b088, 0x00000038, 0x00380000,
+	0x00003d20, 0x00000080, 0x00400000,
+	0x0000bf60, 0x00000000, 0x00040000,
+	0x00004560, 0x00040080, 0x00040000,
+	0x000001f8, 0x00000004, 0x00040000,
+	0x00003d60, 0x00000080, 0x00200000,
+	0x00008960, 0x00000040, 0x00300000,
+	0x0000e840, 0x00000060, 0x00600000,
+	0x00004618, 0x00000080, 0x00380000,
+	0x00010738, 0x000000c0, 0x00c00000,
+	0x000001f8, 0x00000002, 0x00020000,
+	0x0000a2a0, 0x00000000, 0x01080000,
+	0x0000a3a8, 0x00000008, 0x00080000,
+	0x000001c0, 0x00000008, 0x00080000,
+	0x000001f8, 0x00000008, 0x00080000,
+	0x00000ac0, 0x00000008, 0x00080000,
+	0x00002578, 0x00000008, 0x00080000,
+	0x000024f8, 0x00000008, 0x00080000,
+	0x00000280, 0x00000008, 0x00080000,
+	0x00000680, 0x00080018, 0x00080000,
+	0x00000b78, 0x00080018, 0x00020000,
+	0x0000c640, 0x00000050, 0x003c0000,
+	0x00012038, 0x00000018, 0x00100000,
+	0x00011b00, 0x00000040, 0x00180000,
+	0x000095d0, 0x00000050, 0x00200000,
+	0x00008b10, 0x00000040, 0x00280000,
+	0x00011640, 0x00000018, 0x00100000,
+	0x0000c828, 0x00000048, 0x00380000,
+	0x00011710, 0x00000020, 0x00200000,
+	0x00004650, 0x00000080, 0x00100000,
+	0x00003618, 0x00000010, 0x00100000,
+	0x0000a968, 0x00000008, 0x00010000,
+	0x000097a0, 0x00000008, 0x00010000,
+	0x00011990, 0x00000008, 0x00010000,
+	0x0000f018, 0x00000008, 0x00010000,
+	0x00012628, 0x00000008, 0x00010000,
+	0x00011da8, 0x00000008, 0x00010000,
+	0x0000aa78, 0x00000030, 0x00100000,
+	0x0000d768, 0x00000028, 0x00280000,
+	0x00009a58, 0x00000018, 0x00180000,
+	0x00009bd8, 0x00000008, 0x00080000,
+	0x00013a18, 0x00000008, 0x00080000,
+	0x000126e8, 0x00000018, 0x00180000,
+	0x0000e608, 0x00500288, 0x00100000,
+	0x00012970, 0x00000138, 0x00280000,
+};
+
 void qed_init_iro_array(struct qed_dev *cdev)
 {
 	cdev->iro_arr = iro_arr;
-- 
2.25.1

