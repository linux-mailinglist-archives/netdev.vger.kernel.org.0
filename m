Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818CE58007E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbiGYOK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbiGYOK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:10:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1B91261C;
        Mon, 25 Jul 2022 07:10:26 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PDkxnc005257;
        Mon, 25 Jul 2022 14:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0CA5Em3e4TuuRQ8BiobOvhV7DP6kl3US2Hl7ipdNGDI=;
 b=dy09Qid3kdzuCi9c05OFEBhvrk3E4jyCiFeEH2/E60/dBa0sogf0TP5XTHqm9DbNDhdv
 BxvETpFK7WnRM1bUQr6GivUH0fE9C7s0cjlu8uezS66Ct6xE6HVw11jAPG3IWkUNIkIB
 XBHhCe6q10aIT685AAAXuo2DtHthkuSK36y770C7ip3JLvjWecK+8PjExjsqgGYjlcrl
 zzHKBTccGEsnvBWL6srj6cUvsPM1Kn//DuL4ZyLlVhFOb6jekwNDSONtCFP6dJacy1lU
 n+2dW/JSkdpOVpdYbcslxValB5C0KXhTV/Khk66pjwOp0+J49aVPjXrOeFu/XA3I3xMD Hw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhvc48y4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 14:10:23 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26PE73YK005757;
        Mon, 25 Jul 2022 14:10:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hg97taj52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 14:10:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26PEAVvN25559382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 14:10:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40CF84203F;
        Mon, 25 Jul 2022 14:10:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 582E242045;
        Mon, 25 Jul 2022 14:10:15 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.211.136.94])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Jul 2022 14:10:15 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next 3/4] net/smc: Pass on DMBE bit mask in IRQ handler
Date:   Mon, 25 Jul 2022 16:09:59 +0200
Message-Id: <20220725141000.70347-4-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220725141000.70347-1-wenjia@linux.ibm.com>
References: <20220725141000.70347-1-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RfpdkOcK0pxvMU5J7SydLBKTpsv7WHev
X-Proofpoint-GUID: RfpdkOcK0pxvMU5J7SydLBKTpsv7WHev
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_09,2022-07-25_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=900 spamscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207250059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Make the DMBE bits, which are passed on individually in ism_move() as
parameter idx, available to the receiver.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Wenjia Zhang < wenjia@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 4 +++-
 include/net/smc.h          | 2 +-
 net/smc/smc_ism.c          | 6 +++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 4665e9a0e048..d34bb6ec1490 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -443,6 +443,7 @@ static irqreturn_t ism_handle_irq(int irq, void *data)
 	struct ism_dev *ism = data;
 	unsigned long bit, end;
 	unsigned long *bv;
+	u16 dmbemask;
 
 	bv = (void *) &ism->sba->dmb_bits[ISM_DMB_WORD_OFFSET];
 	end = sizeof(ism->sba->dmb_bits) * BITS_PER_BYTE - ISM_DMB_BIT_OFFSET;
@@ -456,9 +457,10 @@ static irqreturn_t ism_handle_irq(int irq, void *data)
 			break;
 
 		clear_bit_inv(bit, bv);
+		dmbemask = ism->sba->dmbe_mask[bit + ISM_DMB_BIT_OFFSET];
 		ism->sba->dmbe_mask[bit + ISM_DMB_BIT_OFFSET] = 0;
 		barrier();
-		smcd_handle_irq(ism->smcd, bit + ISM_DMB_BIT_OFFSET);
+		smcd_handle_irq(ism->smcd, bit + ISM_DMB_BIT_OFFSET, dmbemask);
 	}
 
 	if (ism->sba->e) {
diff --git a/include/net/smc.h b/include/net/smc.h
index 1868a5014dea..c926d3313e05 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -101,5 +101,5 @@ int smcd_register_dev(struct smcd_dev *smcd);
 void smcd_unregister_dev(struct smcd_dev *smcd);
 void smcd_free_dev(struct smcd_dev *smcd);
 void smcd_handle_event(struct smcd_dev *dev, struct smcd_event *event);
-void smcd_handle_irq(struct smcd_dev *dev, unsigned int bit);
+void smcd_handle_irq(struct smcd_dev *dev, unsigned int bit, u16 dmbemask);
 #endif	/* _SMC_H */
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index e51c0cdff8e0..911fe08bc54b 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -508,13 +508,13 @@ void smcd_handle_event(struct smcd_dev *smcd, struct smcd_event *event)
 EXPORT_SYMBOL_GPL(smcd_handle_event);
 
 /* SMCD Device interrupt handler. Called from ISM device interrupt handler.
- * Parameters are smcd device pointer and DMB number. Find the connection and
- * schedule the tasklet for this connection.
+ * Parameters are smcd device pointer, DMB number, and the DMBE bitmask.
+ * Find the connection and schedule the tasklet for this connection.
  *
  * Context:
  * - Function called in IRQ context from ISM device driver IRQ handler.
  */
-void smcd_handle_irq(struct smcd_dev *smcd, unsigned int dmbno)
+void smcd_handle_irq(struct smcd_dev *smcd, unsigned int dmbno, u16 dmbemask)
 {
 	struct smc_connection *conn = NULL;
 	unsigned long flags;
-- 
2.35.2

