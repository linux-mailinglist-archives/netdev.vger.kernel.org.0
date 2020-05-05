Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1C71C5D8B
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbgEEQ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:26:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730282AbgEEQ0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:26:09 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045Fac7h168309;
        Tue, 5 May 2020 12:26:07 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s50gt5b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:26:07 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045GJkal003354;
        Tue, 5 May 2020 16:26:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5qc3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 16:26:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045GQ2H760358896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 16:26:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3DC54203F;
        Tue,  5 May 2020 16:26:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6441C42047;
        Tue,  5 May 2020 16:26:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 16:26:02 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 03/11] s390/qeth: add debugfs file for local IP addresses
Date:   Tue,  5 May 2020 18:25:51 +0200
Message-Id: <20200505162559.14138-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505162559.14138-1-jwi@linux.ibm.com>
References: <20200505162559.14138-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_08:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For debugging purposes, provide read access to the local_addr caches
via debug/qeth/<dev_name>/local_addrs.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  2 ++
 drivers/s390/net/qeth_core_main.c | 32 ++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index b92af3735dd4..3d8b8e0f2438 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -11,6 +11,7 @@
 #define __QETH_CORE_H__
 
 #include <linux/completion.h>
+#include <linux/debugfs.h>
 #include <linux/if.h>
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
@@ -797,6 +798,7 @@ struct qeth_card {
 	struct qeth_channel data;
 
 	struct net_device *dev;
+	struct dentry *debugfs;
 	struct qeth_card_stats stats;
 	struct qeth_card_info info;
 	struct qeth_token token;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6b5d42a4501c..771282cb7aef 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -61,6 +61,7 @@ EXPORT_SYMBOL_GPL(qeth_core_header_cache);
 static struct kmem_cache *qeth_qdio_outbuf_cache;
 
 static struct device *qeth_core_root_dev;
+static struct dentry *qeth_debugfs_root;
 static struct lock_class_key qdio_out_skb_queue_key;
 
 static void qeth_issue_next_read_cb(struct qeth_card *card,
@@ -805,6 +806,24 @@ static void qeth_del_local_addrs6(struct qeth_card *card,
 	spin_unlock(&card->local_addrs6_lock);
 }
 
+static int qeth_debugfs_local_addr_show(struct seq_file *m, void *v)
+{
+	struct qeth_card *card = m->private;
+	struct qeth_local_addr *tmp;
+	unsigned int i;
+
+	rcu_read_lock();
+	hash_for_each_rcu(card->local_addrs4, i, tmp, hnode)
+		seq_printf(m, "%pI4\n", &tmp->addr.s6_addr32[3]);
+	hash_for_each_rcu(card->local_addrs6, i, tmp, hnode)
+		seq_printf(m, "%pI6c\n", &tmp->addr);
+	rcu_read_unlock();
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(qeth_debugfs_local_addr);
+
 static void qeth_issue_ipa_msg(struct qeth_ipa_cmd *cmd, int rc,
 		struct qeth_card *card)
 {
@@ -1608,6 +1627,11 @@ static struct qeth_card *qeth_alloc_card(struct ccwgroup_device *gdev)
 	if (!card->read_cmd)
 		goto out_read_cmd;
 
+	card->debugfs = debugfs_create_dir(dev_name(&gdev->dev),
+					   qeth_debugfs_root);
+	debugfs_create_file("local_addrs", 0400, card->debugfs, card,
+			    &qeth_debugfs_local_addr_fops);
+
 	card->qeth_service_level.seq_print = qeth_core_sl_print;
 	register_service_level(&card->qeth_service_level);
 	return card;
@@ -5085,9 +5109,11 @@ static int qeth_qdio_establish(struct qeth_card *card)
 static void qeth_core_free_card(struct qeth_card *card)
 {
 	QETH_CARD_TEXT(card, 2, "freecrd");
+
+	unregister_service_level(&card->qeth_service_level);
+	debugfs_remove_recursive(card->debugfs);
 	qeth_put_cmd(card->read_cmd);
 	destroy_workqueue(card->event_wq);
-	unregister_service_level(&card->qeth_service_level);
 	dev_set_drvdata(&card->gdev->dev, NULL);
 	kfree(card);
 }
@@ -6967,6 +6993,8 @@ static int __init qeth_core_init(void)
 
 	pr_info("loading core functions\n");
 
+	qeth_debugfs_root = debugfs_create_dir("qeth", NULL);
+
 	rc = qeth_register_dbf_views();
 	if (rc)
 		goto dbf_err;
@@ -7008,6 +7036,7 @@ static int __init qeth_core_init(void)
 register_err:
 	qeth_unregister_dbf_views();
 dbf_err:
+	debugfs_remove_recursive(qeth_debugfs_root);
 	pr_err("Initializing the qeth device driver failed\n");
 	return rc;
 }
@@ -7021,6 +7050,7 @@ static void __exit qeth_core_exit(void)
 	kmem_cache_destroy(qeth_core_header_cache);
 	root_device_unregister(qeth_core_root_dev);
 	qeth_unregister_dbf_views();
+	debugfs_remove_recursive(qeth_debugfs_root);
 	pr_info("core functions removed\n");
 }
 
-- 
2.17.1

