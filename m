Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE81181EB7
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgCKRH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:07:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730380AbgCKRH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 13:07:26 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02BGwqJo004208
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 13:07:25 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yq3u80wrk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 13:07:25 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 11 Mar 2020 17:07:22 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Mar 2020 17:07:19 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02BH6IEU50856258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 17:06:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9340B5204F;
        Wed, 11 Mar 2020 17:07:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 59DDD52050;
        Wed, 11 Mar 2020 17:07:17 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 3/3] s390/qeth: implement smarter resizing of the RX buffer pool
Date:   Wed, 11 Mar 2020 18:07:11 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200311170711.50376-1-jwi@linux.ibm.com>
References: <20200311170711.50376-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031117-4275-0000-0000-000003AAB97E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031117-4276-0000-0000-000038BFD62F
Message-Id: <20200311170711.50376-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_07:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=2 clxscore=1015 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX buffer pool is allocated in qeth_alloc_qdio_queues().
A subsequent pool resizing is then handled in a very simple way:
first free the current pool, then allocate a new pool of the requested
size.

There's two ways where this can go wrong:
1. if the resize action happens _before_ the initial pool was allocated,
   then a subsequent initialization will call qeth_alloc_qdio_queues()
   and fill the pool with a second(!) set of pages. We consume twice the
   planned amount of memory.
   This is easy to fix - just skip the resizing if the queues haven't
   been allocated yet.
2. if the initial pool was created by qeth_alloc_qdio_queues() but a
   subsequent resizing fails, then the device has no(!) RX buffer pool.
   The next initialization will _not_ call qeth_alloc_qdio_queues(), and
   attempting to back the RX buffers with pages in
   qeth_init_qdio_queues() will fail.
   Not very difficult to fix either - instead of re-allocating the whole
   pool, just allocate/free as many entries to match the desired size.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  2 +-
 drivers/s390/net/qeth_core_main.c | 55 ++++++++++++++++++++++++++-----
 drivers/s390/net/qeth_core_sys.c  |  9 +++--
 drivers/s390/net/qeth_l3_sys.c    |  9 +++--
 4 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 242b05f644eb..468cada49e72 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -983,7 +983,7 @@ extern const struct attribute_group qeth_device_blkt_group;
 extern const struct device_type qeth_generic_devtype;
 
 const char *qeth_get_cardname_short(struct qeth_card *);
-int qeth_realloc_buffer_pool(struct qeth_card *, int);
+int qeth_resize_buffer_pool(struct qeth_card *card, unsigned int count);
 int qeth_core_load_discipline(struct qeth_card *, enum qeth_discipline_id);
 void qeth_core_free_discipline(struct qeth_card *);
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index ceab3d0c4dfa..6d3f2f14b414 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -275,18 +275,57 @@ static int qeth_alloc_buffer_pool(struct qeth_card *card)
 	return 0;
 }
 
-int qeth_realloc_buffer_pool(struct qeth_card *card, int bufcnt)
+int qeth_resize_buffer_pool(struct qeth_card *card, unsigned int count)
 {
+	unsigned int buf_elements = QETH_MAX_BUFFER_ELEMENTS(card);
+	struct qeth_qdio_buffer_pool *pool = &card->qdio.init_pool;
+	struct qeth_buffer_pool_entry *entry, *tmp;
+	int delta = count - pool->buf_count;
+	LIST_HEAD(entries);
+
 	QETH_CARD_TEXT(card, 2, "realcbp");
 
-	/* TODO: steel/add buffers from/to a running card's buffer pool (?) */
-	qeth_clear_working_pool_list(card);
-	qeth_free_buffer_pool(card);
-	card->qdio.in_buf_pool.buf_count = bufcnt;
-	card->qdio.init_pool.buf_count = bufcnt;
-	return qeth_alloc_buffer_pool(card);
+	/* Defer until queue is allocated: */
+	if (!card->qdio.in_q)
+		goto out;
+
+	/* Remove entries from the pool: */
+	while (delta < 0) {
+		entry = list_first_entry(&pool->entry_list,
+					 struct qeth_buffer_pool_entry,
+					 init_list);
+		list_del(&entry->init_list);
+		qeth_free_pool_entry(entry);
+
+		delta++;
+	}
+
+	/* Allocate additional entries: */
+	while (delta > 0) {
+		entry = qeth_alloc_pool_entry(buf_elements);
+		if (!entry) {
+			list_for_each_entry_safe(entry, tmp, &entries,
+						 init_list) {
+				list_del(&entry->init_list);
+				qeth_free_pool_entry(entry);
+			}
+
+			return -ENOMEM;
+		}
+
+		list_add(&entry->init_list, &entries);
+
+		delta--;
+	}
+
+	list_splice(&entries, &pool->entry_list);
+
+out:
+	card->qdio.in_buf_pool.buf_count = count;
+	pool->buf_count = count;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(qeth_realloc_buffer_pool);
+EXPORT_SYMBOL_GPL(qeth_resize_buffer_pool);
 
 static void qeth_free_qdio_queue(struct qeth_qdio_q *q)
 {
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 2bd9993aa60b..78cae61bc924 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -247,8 +247,8 @@ static ssize_t qeth_dev_bufcnt_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
+	unsigned int cnt;
 	char *tmp;
-	int cnt, old_cnt;
 	int rc = 0;
 
 	mutex_lock(&card->conf_mutex);
@@ -257,13 +257,12 @@ static ssize_t qeth_dev_bufcnt_store(struct device *dev,
 		goto out;
 	}
 
-	old_cnt = card->qdio.in_buf_pool.buf_count;
 	cnt = simple_strtoul(buf, &tmp, 10);
 	cnt = (cnt < QETH_IN_BUF_COUNT_MIN) ? QETH_IN_BUF_COUNT_MIN :
 		((cnt > QETH_IN_BUF_COUNT_MAX) ? QETH_IN_BUF_COUNT_MAX : cnt);
-	if (old_cnt != cnt) {
-		rc = qeth_realloc_buffer_pool(card, cnt);
-	}
+
+	rc = qeth_resize_buffer_pool(card, cnt);
+
 out:
 	mutex_unlock(&card->conf_mutex);
 	return rc ? rc : count;
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 29f2517d2a31..a3d1c3bdfadb 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -206,12 +206,11 @@ static ssize_t qeth_l3_dev_sniffer_store(struct device *dev,
 		qdio_get_ssqd_desc(CARD_DDEV(card), &card->ssqd);
 		if (card->ssqd.qdioac2 & CHSC_AC2_SNIFFER_AVAILABLE) {
 			card->options.sniffer = i;
-			if (card->qdio.init_pool.buf_count !=
-					QETH_IN_BUF_COUNT_MAX)
-				qeth_realloc_buffer_pool(card,
-					QETH_IN_BUF_COUNT_MAX);
-		} else
+			qeth_resize_buffer_pool(card, QETH_IN_BUF_COUNT_MAX);
+		} else {
 			rc = -EPERM;
+		}
+
 		break;
 	default:
 		rc = -EINVAL;
-- 
2.17.1

