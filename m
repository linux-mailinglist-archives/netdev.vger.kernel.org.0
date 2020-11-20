Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D217F2BA587
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgKTJJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:09:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbgKTJJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:09:50 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK95Jhd009126;
        Fri, 20 Nov 2020 04:09:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=zcEYbh9PEbpo0u35NzLSoomzBB8B/DZ7utv2nWVLZxs=;
 b=TDVk/93qq15OGc4IGqYEkz5FLe/BObNqqgJUpSA9O8P1SLIZGv+DCvuoSrUCq2yi++b3
 dMVp5BsIeVPEMXN8pXzO1xPOw5xUa24xo5egLR8EC8gWdcMxZN0y46LjoJhPlonAuNqW
 4rdegcAP1Jw3ix10/U+ZKO6nbnJDJh6g3agaaUxUaF0InGRqq+r13S++YsLkkCos3m0z
 h7ImPrhOI83o6J7SR2bOJyXpCdJqm9f+QgbgRTn5g/P9V+9qlGdRgx0Tg3R1TSY/hvZR
 bOa2Gwr94OgH5Nj2mllMug+lXz2uMsxO4mK/3gw4dzidDOXD6QmX41QjTTHb97+vheD8 Vg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xakj0fes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 04:09:47 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AK98Nri002779;
        Fri, 20 Nov 2020 09:09:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 34t6ghb5hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 09:09:44 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AK99fQ364881136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 09:09:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A613142049;
        Fri, 20 Nov 2020 09:09:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61DB142047;
        Fri, 20 Nov 2020 09:09:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 09:09:41 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 4/4] s390/qeth: fix tear down of async TX buffers
Date:   Fri, 20 Nov 2020 10:09:39 +0100
Message-Id: <20201120090939.101406-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120090939.101406-1-jwi@linux.ibm.com>
References: <20201120090939.101406-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_03:2020-11-19,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 clxscore=1015 malwarescore=0 mlxlogscore=994
 lowpriorityscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When qeth_iqd_tx_complete() detects that a TX buffer requires additional
async completion via QAOB, it might fail to replace the queue entry's
metadata (and ends up triggering recovery).

Assume now that the device gets torn down, overruling the recovery.
If the QAOB notification then arrives before the tear down has
sufficiently progressed, the buffer state is changed to
QETH_QDIO_BUF_HANDLED_DELAYED by qeth_qdio_handle_aob().

The tear down code calls qeth_drain_output_queue(), where
qeth_cleanup_handled_pending() will then attempt to replace such a
buffer _again_. If it succeeds this time, the buffer ends up dangling in
its replacement's ->next_pending list ... where it will never be freed,
since there's no further call to qeth_cleanup_handled_pending().

But the second attempt isn't actually needed, we can simply leave the
buffer on the queue and re-use it after a potential recovery has
completed. The qeth_clear_output_buffer() in qeth_drain_output_queue()
will ensure that it's in a clean state again.

Fixes: 72861ae792c2 ("qeth: recovery through asynchronous delivery")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 48f9e4a027bf..e27319de7b00 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -500,12 +500,6 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 
 		}
 	}
-	if (forced_cleanup && (atomic_read(&(q->bufs[bidx]->state)) ==
-					QETH_QDIO_BUF_HANDLED_DELAYED)) {
-		/* for recovery situations */
-		qeth_init_qdio_out_buf(q, bidx);
-		QETH_CARD_TEXT(q->card, 2, "clprecov");
-	}
 }
 
 static void qeth_qdio_handle_aob(struct qeth_card *card,
-- 
2.17.1

