Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C2A439325
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbhJYKAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:00:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22726 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232720AbhJYJ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:36 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9XJmN004653;
        Mon, 25 Oct 2021 09:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=L7dw5vd8FJSVo/VaW4FOfmQ1+IZwHR0wH10GZgpdnCM=;
 b=OOfs2khHZRLfF4ptPRgC2PDQ0G+aXfBEXXsEM4g+SI3RxyzSqn3D/0ybBOJ3plJpe3mT
 8Kcqz5aulXzMMpoY2XdvHVvYmS4Q4N5gCZitYSyTp+nUDUCKCqHEhlvz2Vh1qhiXvOKi
 pW1h6fjhacYplPoszxqRN5da8USZORsbHzqlEQxulrTj326aMPiitxUv9dZmLCiCG8nH
 uekLKTKi+CQUYbBlSBcJjrwoJSPs1c9iSc2ZNR/P/Zjbb2MShuug0begoWRHUQRgu4bS
 uHxzWC+eqVsyhCoqAXR6uuh2WkSB+3LZunD9ldsQIR6f1ExRgPVyYoCSgyqJZ1WC0YxM zg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bwt25geh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:10 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9gxLc000861;
        Mon, 25 Oct 2021 09:57:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3bv9njcdcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v5Xl48890168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 415D611C054;
        Mon, 25 Oct 2021 09:57:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC52411C05B;
        Mon, 25 Oct 2021 09:57:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:04 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH net-next 3/9] s390/qeth: move qdio's QAOB cache into qeth
Date:   Mon, 25 Oct 2021 11:56:52 +0200
Message-Id: <20211025095658.3527635-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K19A9QnFKxOEXE_lP_U6y3cLjxn186Cl
X-Proofpoint-GUID: K19A9QnFKxOEXE_lP_U6y3cLjxn186Cl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qdio.ko no longer needs to care about how the QAOBs are allocated,
from its perspective they are merely another parameter to do_QDIO().

So for a start, shift the cache into the only qdio driver that uses
QAOBs (ie. qeth). Here there's further opportunity to optimize its
usage in the future - eg. make it per-{device, TX queue}, or only
compile it when the driver is built with CQ/QAOB support.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---
 arch/s390/include/asm/qdio.h      |  2 --
 drivers/s390/cio/qdio_setup.c     | 34 ++-----------------------------
 drivers/s390/net/qeth_core_main.c | 19 +++++++++++++++--
 3 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index 25b5dc34db75..4b9b14b20984 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -349,8 +349,6 @@ extern int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 extern int qdio_establish(struct ccw_device *cdev,
 			  struct qdio_initialize *init_data);
 extern int qdio_activate(struct ccw_device *);
-extern struct qaob *qdio_allocate_aob(void);
-extern void qdio_release_aob(struct qaob *);
 extern int do_QDIO(struct ccw_device *cdev, unsigned int callflags, int q_nr,
 		   unsigned int bufnr, unsigned int count, struct qaob *aob);
 extern int qdio_start_irq(struct ccw_device *cdev);
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index 20efafe47897..efbb5e5eca05 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -24,19 +24,6 @@
 #define QBUFF_PER_PAGE (PAGE_SIZE / sizeof(struct qdio_buffer))
 
 static struct kmem_cache *qdio_q_cache;
-static struct kmem_cache *qdio_aob_cache;
-
-struct qaob *qdio_allocate_aob(void)
-{
-	return kmem_cache_zalloc(qdio_aob_cache, GFP_ATOMIC);
-}
-EXPORT_SYMBOL_GPL(qdio_allocate_aob);
-
-void qdio_release_aob(struct qaob *aob)
-{
-	kmem_cache_free(qdio_aob_cache, aob);
-}
-EXPORT_SYMBOL_GPL(qdio_release_aob);
 
 /**
  * qdio_free_buffers() - free qdio buffers
@@ -447,39 +434,22 @@ void qdio_print_subchannel_info(struct qdio_irq *irq_ptr)
 
 int __init qdio_setup_init(void)
 {
-	int rc;
-
 	qdio_q_cache = kmem_cache_create("qdio_q", sizeof(struct qdio_q),
 					 256, 0, NULL);
 	if (!qdio_q_cache)
 		return -ENOMEM;
 
-	qdio_aob_cache = kmem_cache_create("qdio_aob",
-					sizeof(struct qaob),
-					sizeof(struct qaob),
-					0,
-					NULL);
-	if (!qdio_aob_cache) {
-		rc = -ENOMEM;
-		goto free_qdio_q_cache;
-	}
-
 	/* Check for OSA/FCP thin interrupts (bit 67). */
 	DBF_EVENT("thinint:%1d",
 		  (css_general_characteristics.aif_osa) ? 1 : 0);
 
 	/* Check for QEBSM support in general (bit 58). */
 	DBF_EVENT("cssQEBSM:%1d", css_general_characteristics.qebsm);
-	rc = 0;
-out:
-	return rc;
-free_qdio_q_cache:
-	kmem_cache_destroy(qdio_q_cache);
-	goto out;
+
+	return 0;
 }
 
 void qdio_setup_exit(void)
 {
-	kmem_cache_destroy(qdio_aob_cache);
 	kmem_cache_destroy(qdio_q_cache);
 }
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 4149ea253fa0..48dea62bdaa4 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -59,6 +59,7 @@ EXPORT_SYMBOL_GPL(qeth_dbf);
 
 static struct kmem_cache *qeth_core_header_cache;
 static struct kmem_cache *qeth_qdio_outbuf_cache;
+static struct kmem_cache *qeth_qaob_cache;
 
 static struct device *qeth_core_root_dev;
 static struct dentry *qeth_debugfs_root;
@@ -1338,7 +1339,7 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 static void qeth_free_out_buf(struct qeth_qdio_out_buffer *buf)
 {
 	if (buf->aob)
-		qdio_release_aob(buf->aob);
+		kmem_cache_free(qeth_qaob_cache, buf->aob);
 	kmem_cache_free(qeth_qdio_outbuf_cache, buf);
 }
 
@@ -3554,7 +3555,8 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		    !qeth_iqd_is_mcast_queue(card, queue) &&
 		    count == 1) {
 			if (!buf->aob)
-				buf->aob = qdio_allocate_aob();
+				buf->aob = kmem_cache_zalloc(qeth_qaob_cache,
+							     GFP_ATOMIC);
 			if (buf->aob) {
 				struct qeth_qaob_priv1 *priv;
 
@@ -7174,6 +7176,16 @@ static int __init qeth_core_init(void)
 		rc = -ENOMEM;
 		goto cqslab_err;
 	}
+
+	qeth_qaob_cache = kmem_cache_create("qeth_qaob",
+					    sizeof(struct qaob),
+					    sizeof(struct qaob),
+					    0, NULL);
+	if (!qeth_qaob_cache) {
+		rc = -ENOMEM;
+		goto qaob_err;
+	}
+
 	rc = ccw_driver_register(&qeth_ccw_driver);
 	if (rc)
 		goto ccw_err;
@@ -7186,6 +7198,8 @@ static int __init qeth_core_init(void)
 ccwgroup_err:
 	ccw_driver_unregister(&qeth_ccw_driver);
 ccw_err:
+	kmem_cache_destroy(qeth_qaob_cache);
+qaob_err:
 	kmem_cache_destroy(qeth_qdio_outbuf_cache);
 cqslab_err:
 	kmem_cache_destroy(qeth_core_header_cache);
@@ -7204,6 +7218,7 @@ static void __exit qeth_core_exit(void)
 	qeth_clear_dbf_list();
 	ccwgroup_driver_unregister(&qeth_core_ccwgroup_driver);
 	ccw_driver_unregister(&qeth_ccw_driver);
+	kmem_cache_destroy(qeth_qaob_cache);
 	kmem_cache_destroy(qeth_qdio_outbuf_cache);
 	kmem_cache_destroy(qeth_core_header_cache);
 	root_device_unregister(qeth_core_root_dev);
-- 
2.25.1

