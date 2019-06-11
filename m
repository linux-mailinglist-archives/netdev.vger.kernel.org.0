Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6DB3D27A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405664AbfFKQii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57022 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404082AbfFKQiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:13 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGRIA7021890
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:12 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2enacfv8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:11 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:10 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:06 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc5Tw56688686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 218174C059;
        Tue, 11 Jun 2019 16:38:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C71334C044;
        Tue, 11 Jun 2019 16:38:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 16:38:04 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 02/13] s390/qeth: use mm helpers
Date:   Tue, 11 Jun 2019 18:37:49 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-0016-0000-0000-000002882EC9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-0017-0000-0000-000032E55E99
Message-Id: <20190611163800.64730-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slightly reduce the complexity of the core xmit path, by replacing some
open-coded logic with the corresponding helpers.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 33 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index cd9e2f70d8f6..feb9e1c9d506 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -20,6 +20,7 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/mii.h>
+#include <linux/mm.h>
 #include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/if_vlan.h>
@@ -3723,8 +3724,8 @@ static int qeth_add_hw_header(struct qeth_qdio_out_q *queue,
 			__elements = 1 + qeth_count_elements(skb, proto_len);
 		else
 			__elements = qeth_count_elements(skb, 0);
-	} else if (!proto_len && qeth_get_elements_for_range(start, end) == 1) {
-		/* Push HW header into a new page. */
+	} else if (!proto_len && PAGE_ALIGNED(skb->data)) {
+		/* Push HW header into preceding page, flush with skb->data. */
 		push_ok = true;
 		__elements = 1 + qeth_count_elements(skb, 0);
 	} else {
@@ -3778,18 +3779,16 @@ static void __qeth_fill_buffer(struct sk_buff *skb,
 	int element = buf->next_element_to_fill;
 	int length = skb_headlen(skb) - offset;
 	char *data = skb->data + offset;
-	int length_here, cnt;
+	unsigned int elem_length, cnt;
 
 	/* map linear part into buffer element(s) */
 	while (length > 0) {
-		/* length_here is the remaining amount of data in this page */
-		length_here = PAGE_SIZE - ((unsigned long) data % PAGE_SIZE);
-		if (length < length_here)
-			length_here = length;
+		elem_length = min_t(unsigned int, length,
+				    PAGE_SIZE - offset_in_page(data));
 
 		buffer->element[element].addr = data;
-		buffer->element[element].length = length_here;
-		length -= length_here;
+		buffer->element[element].length = elem_length;
+		length -= elem_length;
 		if (is_first_elem) {
 			is_first_elem = false;
 			if (length || skb_is_nonlinear(skb))
@@ -3802,7 +3801,8 @@ static void __qeth_fill_buffer(struct sk_buff *skb,
 			buffer->element[element].eflags =
 				SBAL_EFLAGS_MIDDLE_FRAG;
 		}
-		data += length_here;
+
+		data += elem_length;
 		element++;
 	}
 
@@ -3813,17 +3813,16 @@ static void __qeth_fill_buffer(struct sk_buff *skb,
 		data = skb_frag_address(frag);
 		length = skb_frag_size(frag);
 		while (length > 0) {
-			length_here = PAGE_SIZE -
-				((unsigned long) data % PAGE_SIZE);
-			if (length < length_here)
-				length_here = length;
+			elem_length = min_t(unsigned int, length,
+					    PAGE_SIZE - offset_in_page(data));
 
 			buffer->element[element].addr = data;
-			buffer->element[element].length = length_here;
+			buffer->element[element].length = elem_length;
 			buffer->element[element].eflags =
 				SBAL_EFLAGS_MIDDLE_FRAG;
-			length -= length_here;
-			data += length_here;
+
+			length -= elem_length;
+			data += elem_length;
 			element++;
 		}
 	}
-- 
2.17.1

