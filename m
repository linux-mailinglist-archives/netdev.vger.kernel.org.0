Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDA6181EB1
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbgCKRHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:07:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730159AbgCKRHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 13:07:23 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02BGxJbc144292
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 13:07:22 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yq15v918d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 13:07:22 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 11 Mar 2020 17:07:20 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Mar 2020 17:07:18 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02BH6H1944696050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 17:06:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5832B5204F;
        Wed, 11 Mar 2020 17:07:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1E9DA52051;
        Wed, 11 Mar 2020 17:07:17 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/3] s390/qeth: refactor buffer pool code
Date:   Wed, 11 Mar 2020 18:07:10 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200311170711.50376-1-jwi@linux.ibm.com>
References: <20200311170711.50376-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031117-0012-0000-0000-0000038F7F76
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031117-0013-0000-0000-000021CC4ED1
Message-Id: <20200311170711.50376-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_07:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 suspectscore=2 clxscore=1015 adultscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for a subsequent fix, split out helpers to allocate/free
individual pool entries.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 83 +++++++++++++++++++------------
 1 file changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 8f682fc178a9..ceab3d0c4dfa 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -65,7 +65,6 @@ static struct lock_class_key qdio_out_skb_queue_key;
 static void qeth_issue_next_read_cb(struct qeth_card *card,
 				    struct qeth_cmd_buffer *iob,
 				    unsigned int data_length);
-static void qeth_free_buffer_pool(struct qeth_card *);
 static int qeth_qdio_establish(struct qeth_card *);
 static void qeth_free_qdio_queues(struct qeth_card *card);
 static void qeth_notify_skbs(struct qeth_qdio_out_q *queue,
@@ -212,33 +211,66 @@ void qeth_clear_working_pool_list(struct qeth_card *card)
 }
 EXPORT_SYMBOL_GPL(qeth_clear_working_pool_list);
 
+static void qeth_free_pool_entry(struct qeth_buffer_pool_entry *entry)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(entry->elements); i++) {
+		if (entry->elements[i])
+			__free_page(entry->elements[i]);
+	}
+
+	kfree(entry);
+}
+
+static void qeth_free_buffer_pool(struct qeth_card *card)
+{
+	struct qeth_buffer_pool_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &card->qdio.init_pool.entry_list,
+				 init_list) {
+		list_del(&entry->init_list);
+		qeth_free_pool_entry(entry);
+	}
+}
+
+static struct qeth_buffer_pool_entry *qeth_alloc_pool_entry(unsigned int pages)
+{
+	struct qeth_buffer_pool_entry *entry;
+	unsigned int i;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return NULL;
+
+	for (i = 0; i < pages; i++) {
+		entry->elements[i] = alloc_page(GFP_KERNEL);
+
+		if (!entry->elements[i]) {
+			qeth_free_pool_entry(entry);
+			return NULL;
+		}
+	}
+
+	return entry;
+}
+
 static int qeth_alloc_buffer_pool(struct qeth_card *card)
 {
-	struct qeth_buffer_pool_entry *pool_entry;
-	int i, j;
+	unsigned int buf_elements = QETH_MAX_BUFFER_ELEMENTS(card);
+	unsigned int i;
 
 	QETH_CARD_TEXT(card, 5, "alocpool");
 	for (i = 0; i < card->qdio.init_pool.buf_count; ++i) {
-		pool_entry = kzalloc(sizeof(*pool_entry), GFP_KERNEL);
-		if (!pool_entry) {
+		struct qeth_buffer_pool_entry *entry;
+
+		entry = qeth_alloc_pool_entry(buf_elements);
+		if (!entry) {
 			qeth_free_buffer_pool(card);
 			return -ENOMEM;
 		}
 
-		for (j = 0; j < QETH_MAX_BUFFER_ELEMENTS(card); ++j) {
-			struct page *page = alloc_page(GFP_KERNEL);
-
-			if (!page) {
-				while (j > 0)
-					__free_page(pool_entry->elements[--j]);
-				kfree(pool_entry);
-				qeth_free_buffer_pool(card);
-				return -ENOMEM;
-			}
-			pool_entry->elements[j] = page;
-		}
-		list_add(&pool_entry->init_list,
-			 &card->qdio.init_pool.entry_list);
+		list_add(&entry->init_list, &card->qdio.init_pool.entry_list);
 	}
 	return 0;
 }
@@ -1170,19 +1202,6 @@ void qeth_drain_output_queues(struct qeth_card *card)
 }
 EXPORT_SYMBOL_GPL(qeth_drain_output_queues);
 
-static void qeth_free_buffer_pool(struct qeth_card *card)
-{
-	struct qeth_buffer_pool_entry *pool_entry, *tmp;
-	int i = 0;
-	list_for_each_entry_safe(pool_entry, tmp,
-				 &card->qdio.init_pool.entry_list, init_list){
-		for (i = 0; i < QETH_MAX_BUFFER_ELEMENTS(card); ++i)
-			__free_page(pool_entry->elements[i]);
-		list_del(&pool_entry->init_list);
-		kfree(pool_entry);
-	}
-}
-
 static int qeth_osa_set_output_queues(struct qeth_card *card, bool single)
 {
 	unsigned int count = single ? 1 : card->dev->num_tx_queues;
-- 
2.17.1

