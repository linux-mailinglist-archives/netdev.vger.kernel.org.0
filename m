Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE045810B6
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiGZKE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiGZKED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:04:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A049731DD7;
        Tue, 26 Jul 2022 03:04:01 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q9qfdt019655;
        Tue, 26 Jul 2022 10:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cuKhIVTjEXlQSehpeuBhYrCwWAJ8jZSFtt7rqQdWwQs=;
 b=Y84p4517vchqu8b6S+8IEti8vd8LVhfGLxdnOqKtl+83iTJGoZrceUWLx+c8AgGiTcPX
 s19fS3+A624ehTCRsZjj36Ia2PrEjE/jGdo8vzP+r6RDOVX74MpucF62MmcmdPt/Pjjl
 csZMIYdAmjcRjKjUQ0znt+hg6XcizMMtqYnCfTS6sPwFS4TSH/4zNg+nY3Cee8SLulXm
 +3GxbSRoXx6w5xJEjn6Ij5fLLj8/rBustUZbgJJiAL64W01xCy9SfZUvX4CsyQ5z2nW7
 72Nv1vugS1LO+h0EauW/aShBKjnGido5JAcUxXFWRgv3FqkegbJ29j3BZ6G0nNZ0m8h8 Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hje18gamr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:57 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26Q9roWR023212;
        Tue, 26 Jul 2022 10:03:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hje18gam7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26Q9pNYS011068;
        Tue, 26 Jul 2022 10:03:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3hh6euja21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26QA3pve19464540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 10:03:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 613384C040;
        Tue, 26 Jul 2022 10:03:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 342994C050;
        Tue, 26 Jul 2022 10:03:48 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.211.107.22])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 10:03:47 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next v2 3/4] net/smc: Pass on DMBE bit mask in IRQ handler
Date:   Tue, 26 Jul 2022 12:03:29 +0200
Message-Id: <20220726100330.75191-4-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220726100330.75191-1-wenjia@linux.ibm.com>
References: <20220726100330.75191-1-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cHAs8lyl0K74yOXBHxQcIEdfGG_Xm1ev
X-Proofpoint-GUID: 2ZSQMcFI4LJL4fSGidjW7ekFZAf5mOTj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_02,2022-07-25_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207260035
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
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
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

