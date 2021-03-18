Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC628340D92
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhCRSzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:55:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229958AbhCRSzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:55:08 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IIYNLn067507;
        Thu, 18 Mar 2021 14:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=I96ZE7Ybv1EQHbi8vMBRVEz3PSyuFyH5lvk2YGQeMkw=;
 b=CUlddIcDhtwmcH7oGtQGL7iJniIwtVguJnmJWATmJcqLfhDRXmrP68KhuAWb2sVBRnYh
 CET8Csr+7OA00XbganAiBvOkm+ktttW7pKcLxQbFGDEWhyP5wV3KR18yJS1yUMLd5myN
 TfBs4EfMGOeYr/fpiW1AuIU9nIAa+DBhviHED6+x/IGF2dUjOjWp4aQLoZhMla1ZJn29
 uL57kNJA68qYx1mIxXtP7E5gmGgrS/jRtAmJkZUAxx3Jp3k2bPC+SC9bBvSVET/NiT6z
 E1fvMgDrbFiqG9iZ/cEPR1l5Fvogehobr2OKC4l/K3XamXTxRDhRLbNqrqid7FfE4Svt aw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c102qd09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 14:55:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IIqErn017135;
        Thu, 18 Mar 2021 18:55:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 378n18n1d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 18:55:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IIt0Td14811510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 18:55:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE05BA4057;
        Thu, 18 Mar 2021 18:55:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94926A4051;
        Thu, 18 Mar 2021 18:55:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 18:55:00 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/3] s390/qeth: allocate initial TX Buffer structs with GFP_KERNEL
Date:   Thu, 18 Mar 2021 19:54:54 +0100
Message-Id: <20210318185456.2153426-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318185456.2153426-1-jwi@linux.ibm.com>
References: <20210318185456.2153426-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_init_qdio_out_buf() is typically called during initialization, and
the GFP_ATOMIC is only needed for a very specific & rare case during TX
completion.

Allow callers to specify a gfp mask, so that the initialization path can
select GFP_KERNEL. While at it also clarify the function name.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index a814698387bc..abd1e49cf97a 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2590,11 +2590,12 @@ static int qeth_ulp_setup(struct qeth_card *card)
 	return qeth_send_control_data(card, iob, qeth_ulp_setup_cb, NULL);
 }
 
-static int qeth_init_qdio_out_buf(struct qeth_qdio_out_q *q, int bidx)
+static int qeth_alloc_out_buf(struct qeth_qdio_out_q *q, unsigned int bidx,
+			      gfp_t gfp)
 {
 	struct qeth_qdio_out_buffer *newbuf;
 
-	newbuf = kmem_cache_zalloc(qeth_qdio_outbuf_cache, GFP_ATOMIC);
+	newbuf = kmem_cache_zalloc(qeth_qdio_outbuf_cache, gfp);
 	if (!newbuf)
 		return -ENOMEM;
 
@@ -2629,7 +2630,7 @@ static struct qeth_qdio_out_q *qeth_alloc_output_queue(void)
 		goto err_qdio_bufs;
 
 	for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++) {
-		if (qeth_init_qdio_out_buf(q, i))
+		if (qeth_alloc_out_buf(q, i, GFP_KERNEL))
 			goto err_out_bufs;
 	}
 
@@ -6088,7 +6089,8 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 
 				/* Prepare the queue slot for immediate re-use: */
 				qeth_scrub_qdio_buffer(buffer->buffer, queue->max_elements);
-				if (qeth_init_qdio_out_buf(queue, bidx)) {
+				if (qeth_alloc_out_buf(queue, bidx,
+						       GFP_ATOMIC)) {
 					QETH_CARD_TEXT(card, 2, "outofbuf");
 					qeth_schedule_recovery(card);
 				}
-- 
2.25.1

