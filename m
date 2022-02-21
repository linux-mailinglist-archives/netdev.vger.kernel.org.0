Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20C44BE602
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378623AbiBUO5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:57:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378603AbiBUO50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:57:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEC8EAF;
        Mon, 21 Feb 2022 06:57:00 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LECbLU025898;
        Mon, 21 Feb 2022 14:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nmg/Xu+Zeqw4ZNbefBUlEITgvpUHK6dz96W0jT7JJvI=;
 b=NYWea+2Ls1oHPq/gEmFS0X8O+a6A1ycuo3KOQBdKvwt94TQDfQiR9t0Wc/LMf/PVJzvC
 RD0BYgnjk22F8dgZWoj9LsSYwGiFtIqeUAGOoGq/xCK2cDAgtTCwMA2hCmjL1s98Snuk
 AqyXLss1Nm+1wQ+E+CbNfgkFqp0r7cf9hBROaO+zzlYJk2Nsn6IoyjGumJuzt+hv8uQH
 kutiMqI0siBisIFLm9yScPjp7soprEaGDSQ4++H2fRRAUY7VyFQIv2q8W5lOOEaR32mp
 /zpKIAmyWinOPK2Yg6LPPttCY5qU1FZuaEsjXyNjeTgOArkUlvUSnIrsOZtUznFCCnj/ lw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ecc9uryef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 14:56:56 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LESvIH022061;
        Mon, 21 Feb 2022 14:56:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqthufp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 14:56:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LEunDh37028112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 14:56:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C24211C052;
        Mon, 21 Feb 2022 14:56:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29DBB11C05E;
        Mon, 21 Feb 2022 14:56:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Feb 2022 14:56:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id CBB52E03D6; Mon, 21 Feb 2022 15:56:48 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, agordeev@linux.ibm.com,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next 2/2] s390/net: sort out physical vs virtual pointers usage
Date:   Mon, 21 Feb 2022 15:56:33 +0100
Message-Id: <20220221145633.3869621-3-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220221145633.3869621-1-wintera@linux.ibm.com>
References: <20220221145633.3869621-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -XKZSDi1toCT1WliuEfQ1NIMauWZ2Avt
X-Proofpoint-GUID: -XKZSDi1toCT1WliuEfQ1NIMauWZ2Avt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

Fix virtual vs physical address confusion (which currently are the same).

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/lcs.c            | 8 ++++----
 drivers/s390/net/qeth_core_main.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index a61d38a1b4ed..bab9b34926c6 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -223,7 +223,7 @@ lcs_setup_read_ccws(struct lcs_card *card)
 		 * we do not need to do set_normalized_cda.
 		 */
 		card->read.ccws[cnt].cda =
-			(__u32) __pa(card->read.iob[cnt].data);
+			(__u32)virt_to_phys(card->read.iob[cnt].data);
 		((struct lcs_header *)
 		 card->read.iob[cnt].data)->offset = LCS_ILLEGAL_OFFSET;
 		card->read.iob[cnt].callback = lcs_get_frames_cb;
@@ -236,7 +236,7 @@ lcs_setup_read_ccws(struct lcs_card *card)
 	/* Last ccw is a tic (transfer in channel). */
 	card->read.ccws[LCS_NUM_BUFFS].cmd_code = LCS_CCW_TRANSFER;
 	card->read.ccws[LCS_NUM_BUFFS].cda =
-		(__u32) __pa(card->read.ccws);
+		(__u32)virt_to_phys(card->read.ccws);
 	/* Setg initial state of the read channel. */
 	card->read.state = LCS_CH_STATE_INIT;
 
@@ -278,12 +278,12 @@ lcs_setup_write_ccws(struct lcs_card *card)
 		 * we do not need to do set_normalized_cda.
 		 */
 		card->write.ccws[cnt].cda =
-			(__u32) __pa(card->write.iob[cnt].data);
+			(__u32)virt_to_phys(card->write.iob[cnt].data);
 	}
 	/* Last ccw is a tic (transfer in channel). */
 	card->write.ccws[LCS_NUM_BUFFS].cmd_code = LCS_CCW_TRANSFER;
 	card->write.ccws[LCS_NUM_BUFFS].cda =
-		(__u32) __pa(card->write.ccws);
+		(__u32)virt_to_phys(card->write.ccws);
 	/* Set initial state of the write channel. */
 	card->read.state = LCS_CH_STATE_INIT;
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 29f0111f8e11..d99c5b773e22 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -426,7 +426,7 @@ static void qeth_setup_ccw(struct ccw1 *ccw, u8 cmd_code, u8 flags, u32 len,
 	ccw->cmd_code = cmd_code;
 	ccw->flags = flags | CCW_FLAG_SLI;
 	ccw->count = len;
-	ccw->cda = (__u32) __pa(data);
+	ccw->cda = (__u32)virt_to_phys(data);
 }
 
 static int __qeth_issue_next_read(struct qeth_card *card)
-- 
2.32.0

