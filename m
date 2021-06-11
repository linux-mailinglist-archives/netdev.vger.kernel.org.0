Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEB53A3D42
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhFKHgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:36:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231380AbhFKHfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:35:55 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7XiGR091117;
        Fri, 11 Jun 2021 03:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dDLPzLkFfung5DePtmzI/H2R0/P4uMtP+ezWi8f75tc=;
 b=d7qumuDo/GQaibF/BRVgYwjFPsEUSJFFpCnmlwVP1gea574lC225LkW8XVfLnZNl0T/S
 6GztCZC/aFAgBkLGEqAepsvSpz16JGuuyf5j/FFsyi0T0gq/4TXzon26NdRQ45S/chMO
 PZzsd/IT9Pj/643BcSF2H46iROvHFdEKqMn9jUMS0ag9VdKQWmYWf+6yosvRm2M7dJlU
 qsf1VctRAQM/NTnf48X6tNNdLxqlOp7Ca7ebt2MAaJSANYSCxc4hpcO5mU8kVxZ5nq1P
 wpbT+RnTg30orbV++WX9d/leXWidYinYdu/v0ux9njNQrLF4dMVNmk6bWHzqruOH4D7v vA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3942x412ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:33:56 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7WGxR016613;
        Fri, 11 Jun 2021 07:33:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3900hhhtgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7Xo6P25035014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:33:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B5A4A405B;
        Fri, 11 Jun 2021 07:33:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 511DFA406F;
        Fri, 11 Jun 2021 07:33:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:33:50 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 8/9] s390/qeth: shrink TX buffer struct
Date:   Fri, 11 Jun 2021 09:33:40 +0200
Message-Id: <20210611073341.1634501-9-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: plW41ixOyOnOTMyX9HPI0HxKgJOPC4zp
X-Proofpoint-ORIG-GUID: plW41ixOyOnOTMyX9HPI0HxKgJOPC4zp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the large boolean array into a bitmap, this substantially
reduces the struct's size. While at it also clarify the naming.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 2 +-
 drivers/s390/net/qeth_core_main.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index ff1064f871e5..f4d554ea0c93 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -437,7 +437,7 @@ struct qeth_qdio_out_buffer {
 	unsigned int frames;
 	unsigned int bytes;
 	struct sk_buff_head skb_list;
-	int is_header[QDIO_MAX_ELEMENTS_PER_BUFFER];
+	DECLARE_BITMAP(from_kmem_cache, QDIO_MAX_ELEMENTS_PER_BUFFER);
 
 	struct list_head list_entry;
 	struct qaob *aob;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 0ad175d54c13..62f88ccbd03f 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1347,9 +1347,8 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 	for (i = 0; i < queue->max_elements; ++i) {
 		void *data = phys_to_virt(buf->buffer->element[i].addr);
 
-		if (data && buf->is_header[i])
+		if (__test_and_clear_bit(i, buf->from_kmem_cache) && data)
 			kmem_cache_free(qeth_core_header_cache, data);
-		buf->is_header[i] = 0;
 	}
 
 	qeth_scrub_qdio_buffer(buf->buffer, queue->max_elements);
@@ -1393,7 +1392,7 @@ static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 			     i++) {
 				void *data = phys_to_virt(aob->sba[i]);
 
-				if (data && buf->is_header[i])
+				if (test_bit(i, buf->from_kmem_cache) && data)
 					kmem_cache_free(qeth_core_header_cache,
 							data);
 			}
@@ -4053,7 +4052,7 @@ static unsigned int qeth_fill_buffer(struct qeth_qdio_out_buffer *buf,
 
 		/* HW header is allocated from cache: */
 		if ((void *)hdr != skb->data)
-			buf->is_header[element] = 1;
+			__set_bit(element, buf->from_kmem_cache);
 		/* HW header was pushed and is contiguous with linear part: */
 		else if (length > 0 && !PAGE_ALIGNED(data) &&
 			 (data == (char *)hdr + hd_len))
-- 
2.25.1

