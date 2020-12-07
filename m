Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1017D2D118B
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgLGNN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:13:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35100 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726481AbgLGNNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:13:24 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7CkBs6042368;
        Mon, 7 Dec 2020 08:12:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6uhrysBzGNEZOD8UGqrdW5sdZduFtK6f+n7PY/sx8kk=;
 b=r64dqSjq+G6jZt57v9+x6WFejVHb6dlUMhdxJDmm5L/3Vn99g8qAPOvrQ5t8EAqJiDOi
 qSuMPmDlKA/uabkO+RWrKaagZ8gOSqhVq+qHdaSPuo3OMdj5QE+HoaT65H8naDWFVqXf
 h+uktmGQX8X5+HWL+ensmn7CxwUs4HL53UPYspfV6Onv75DW5zptZcMnnXJZlRTeSZ2Y
 d2mcfKk8wrCphKN1cfzlTh6NId2QHT2eU+8u2VJVqi9C2I1HMGXMd6OGgtyhSxx5dQ+r
 2uz57fNoXSe2QtfQrrQW930WbD2rWYAtQG91zXqyORthfWjCifyaNIZSJdx/KInXI28C hg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359ka3k3mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 08:12:42 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7DCG0v026377;
        Mon, 7 Dec 2020 13:12:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u82gc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:12:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7DCbEI50332076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 13:12:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4C2411C064;
        Mon,  7 Dec 2020 13:12:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 962AC11C054;
        Mon,  7 Dec 2020 13:12:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 13:12:37 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/6] s390/qeth: make qeth_qdio_handle_aob() more robust
Date:   Mon,  7 Dec 2020 14:12:33 +0100
Message-Id: <20201207131233.90383-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207131233.90383-1-jwi@linux.ibm.com>
References: <20201207131233.90383-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 suspectscore=2 bulkscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When qeth_qdio_handle_aob() frees dangling allocations in the notified
TX buffer, there are rare tear-down cases where
qeth_drain_output_queue() would later call qeth_clear_output_buffer()
for the same buffer - and thus end up walking the buffer a second time
to check for dangling kmem_cache allocations.

Luckily current code previously scrubs such a buffer, so
qeth_clear_output_buffer() would find buf->buffer->element[i].addr as
NULL and not do anything. But this is fragile, and we can easily improve
it by consistently clearing the ->is_header flag after freeing the
allocation.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index da27ef451d05..f4b60294a969 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -546,6 +546,7 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 
 			if (data && buffer->is_header[i])
 				kmem_cache_free(qeth_core_header_cache, data);
+			buffer->is_header[i] = 0;
 		}
 
 		atomic_set(&buffer->state, QETH_QDIO_BUF_EMPTY);
-- 
2.17.1

