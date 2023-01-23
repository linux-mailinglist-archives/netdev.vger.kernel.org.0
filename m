Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F286D67845A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjAWSSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbjAWSSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:18:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42C5BBAD;
        Mon, 23 Jan 2023 10:18:40 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NHtTLT005050;
        Mon, 23 Jan 2023 18:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZhUxwEsjNCrMyE6j+o1L93u23A6g38QV0f83h956VGo=;
 b=UaBCGmW1BuhdFw+e/QXVKUSwRi92Nlz5wKeU2bOm3Vj0Ar+wWt/KaiK4z3CRtBHJUzXZ
 iTL8Wm4tpCxUMj9s/l9vSm+OY20CjTYHcssV+xnYd/LElRQ80QOwjYM+5hP+KkxFWQGM
 kI4Li4k3vCFFvaGu0sK3SWJ0attueS2FPSBl4bU7tUChK4C8CtxmOdrdC7SWuB6VZ5hQ
 2C5wOOMjtsEm91rVn57frMR9tifdJ6vbqjDeSvWUhH6hZRcEMdHLO0Ns5Zbh2uhjam6w
 ICxN4oVapIjnDoJI/b2N84lVtKS2ofZNAn88vGe99tqu3f3PGMMOaVe1U+o7Nr16bB1u qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9y2b8mad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:35 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30NIFYQh021115;
        Mon, 23 Jan 2023 18:18:34 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9y2b8m9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30N5Ua9V014941;
        Mon, 23 Jan 2023 18:18:32 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n87afapyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:32 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30NIISVO43254144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 18:18:28 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B829220040;
        Mon, 23 Jan 2023 18:18:28 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B068F2004D;
        Mon, 23 Jan 2023 18:18:27 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.0.149])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Jan 2023 18:18:27 +0000 (GMT)
From:   Jan Karcher <jaka@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
Subject: [net-next v2 4/8] net/ism: Add new API for client registration
Date:   Mon, 23 Jan 2023 19:17:48 +0100
Message-Id: <20230123181752.1068-5-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123181752.1068-1-jaka@linux.ibm.com>
References: <20230123181752.1068-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: niyM8v0npc1D0E1sADin31oQkFe017Ra
X-Proofpoint-ORIG-GUID: QDlZadeKXdXH_fCzvArhq_nBEDbRh24V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Add a new API that allows other drivers to concurrently access ISM devices.
To do so, we introduce a new API that allows other modules to register for
ISM device usage. Furthermore, we move the GID to struct ism, where it
belongs conceptually, and rename and relocate struct smcd_event to struct
ism_event.
This is the first part of a bigger overhaul of the interfaces between SMC
and ISM.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 drivers/s390/net/ism.h     |  18 +---
 drivers/s390/net/ism_drv.c | 172 +++++++++++++++++++++++++++++++++++--
 include/linux/ism.h        |  67 +++++++++++++++
 include/net/smc.h          |  11 +--
 net/smc/smc_ism.c          |   4 +-
 5 files changed, 236 insertions(+), 36 deletions(-)

diff --git a/drivers/s390/net/ism.h b/drivers/s390/net/ism.h
index 90af51370183..70c5bbda0fea 100644
--- a/drivers/s390/net/ism.h
+++ b/drivers/s390/net/ism.h
@@ -16,7 +16,6 @@
  */
 #define ISM_DMB_WORD_OFFSET	1
 #define ISM_DMB_BIT_OFFSET	(ISM_DMB_WORD_OFFSET * 32)
-#define ISM_NR_DMBS		1920
 #define ISM_IDENT_MASK		0x00FFFF
 
 #define ISM_REG_SBA	0x1
@@ -178,7 +177,7 @@ struct ism_eq_header {
 
 struct ism_eq {
 	struct ism_eq_header header;
-	struct smcd_event entry[15];
+	struct ism_event entry[15];
 };
 
 struct ism_sba {
@@ -190,21 +189,6 @@ struct ism_sba {
 	u16 dmbe_mask[ISM_NR_DMBS];
 };
 
-struct ism_dev {
-	spinlock_t lock;
-	struct pci_dev *pdev;
-	struct smcd_dev *smcd;
-
-	struct ism_sba *sba;
-	dma_addr_t sba_dma_addr;
-	DECLARE_BITMAP(sba_bitmap, ISM_NR_DMBS);
-
-	struct ism_eq *ieq;
-	dma_addr_t ieq_dma_addr;
-
-	int ieq_idx;
-};
-
 #define ISM_CREATE_REQ(dmb, idx, sf, offset)		\
 	((dmb) | (idx) << 24 | (sf) << 23 | (offset))
 
diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index b9f33f411d78..24983224f47e 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -15,9 +15,6 @@
 #include <linux/err.h>
 #include <linux/ctype.h>
 #include <linux/processor.h>
-#include <net/smc.h>
-
-#include <asm/debug.h>
 
 #include "ism.h"
 
@@ -34,6 +31,84 @@ static const struct pci_device_id ism_device_table[] = {
 MODULE_DEVICE_TABLE(pci, ism_device_table);
 
 static debug_info_t *ism_debug_info;
+static const struct smcd_ops ism_ops;
+
+#define NO_CLIENT		0xff		/* must be >= MAX_CLIENTS */
+static struct ism_client *clients[MAX_CLIENTS];	/* use an array rather than */
+						/* a list for fast mapping  */
+static u8 max_client;
+static DEFINE_SPINLOCK(clients_lock);
+struct ism_dev_list {
+	struct list_head list;
+	struct mutex mutex; /* protects ism device list */
+};
+
+static struct ism_dev_list ism_dev_list = {
+	.list = LIST_HEAD_INIT(ism_dev_list.list),
+	.mutex = __MUTEX_INITIALIZER(ism_dev_list.mutex),
+};
+
+int ism_register_client(struct ism_client *client)
+{
+	struct ism_dev *ism;
+	unsigned long flags;
+	int i, rc = -ENOSPC;
+
+	mutex_lock(&ism_dev_list.mutex);
+	spin_lock_irqsave(&clients_lock, flags);
+	for (i = 0; i < MAX_CLIENTS; ++i) {
+		if (!clients[i]) {
+			clients[i] = client;
+			client->id = i;
+			if (i == max_client)
+				max_client++;
+			rc = 0;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&clients_lock, flags);
+	if (i < MAX_CLIENTS) {
+		/* initialize with all devices that we got so far */
+		list_for_each_entry(ism, &ism_dev_list.list, list) {
+			ism->priv[i] = NULL;
+			client->add(ism);
+		}
+	}
+	mutex_unlock(&ism_dev_list.mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ism_register_client);
+
+int ism_unregister_client(struct ism_client *client)
+{
+	struct ism_dev *ism;
+	unsigned long flags;
+	int rc = 0;
+
+	mutex_lock(&ism_dev_list.mutex);
+	spin_lock_irqsave(&clients_lock, flags);
+	clients[client->id] = NULL;
+	if (client->id + 1 == max_client)
+		max_client--;
+	spin_unlock_irqrestore(&clients_lock, flags);
+	list_for_each_entry(ism, &ism_dev_list.list, list) {
+		for (int i = 0; i < ISM_NR_DMBS; ++i) {
+			if (ism->sba_client_arr[i] == client->id) {
+				pr_err("%s: attempt to unregister client '%s'"
+				       "with registered dmb(s)\n", __func__,
+				       client->name);
+				rc = -EBUSY;
+				goto out;
+			}
+		}
+	}
+out:
+	mutex_unlock(&ism_dev_list.mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ism_unregister_client);
 
 static int ism_cmd(struct ism_dev *ism, void *cmd)
 {
@@ -193,7 +268,7 @@ static int ism_read_local_gid(struct ism_dev *ism)
 	if (ret)
 		goto out;
 
-	ism->smcd->local_gid = cmd.response.gid;
+	ism->local_gid = cmd.response.gid;
 out:
 	return ret;
 }
@@ -437,7 +512,8 @@ static u16 ism_get_chid(struct smcd_dev *smcd)
 
 static void ism_handle_event(struct ism_dev *ism)
 {
-	struct smcd_event *entry;
+	struct ism_event *entry;
+	int i;
 
 	while ((ism->ieq_idx + 1) != READ_ONCE(ism->ieq->header.idx)) {
 		if (++(ism->ieq_idx) == ARRAY_SIZE(ism->ieq->entry))
@@ -445,13 +521,18 @@ static void ism_handle_event(struct ism_dev *ism)
 
 		entry = &ism->ieq->entry[ism->ieq_idx];
 		debug_event(ism_debug_info, 2, entry, sizeof(*entry));
-		smcd_handle_event(ism->smcd, entry);
+		spin_lock(&clients_lock);
+		for (i = 0; i < max_client; ++i)
+			if (clients[i])
+				clients[i]->handle_event(ism, entry);
+		spin_unlock(&clients_lock);
 	}
 }
 
 static irqreturn_t ism_handle_irq(int irq, void *data)
 {
 	struct ism_dev *ism = data;
+	struct ism_client *clt;
 	unsigned long bit, end;
 	unsigned long *bv;
 	u16 dmbemask;
@@ -471,7 +552,8 @@ static irqreturn_t ism_handle_irq(int irq, void *data)
 		dmbemask = ism->sba->dmbe_mask[bit + ISM_DMB_BIT_OFFSET];
 		ism->sba->dmbe_mask[bit + ISM_DMB_BIT_OFFSET] = 0;
 		barrier();
-		smcd_handle_irq(ism->smcd, bit + ISM_DMB_BIT_OFFSET, dmbemask);
+		clt = clients[ism->sba_client_arr[bit]];
+		clt->handle_irq(ism, bit + ISM_DMB_BIT_OFFSET, dmbemask);
 	}
 
 	if (ism->sba->e) {
@@ -497,10 +579,21 @@ static const struct smcd_ops ism_ops = {
 	.get_chid = ism_get_chid,
 };
 
+static void ism_dev_add_work_func(struct work_struct *work)
+{
+	struct ism_client *client = container_of(work, struct ism_client,
+						 add_work);
+
+	client->add(client->tgt_ism);
+	atomic_dec(&client->tgt_ism->add_dev_cnt);
+	wake_up(&client->tgt_ism->waitq);
+}
+
 static int ism_dev_init(struct ism_dev *ism)
 {
 	struct pci_dev *pdev = ism->pdev;
-	int ret;
+	unsigned long flags;
+	int i, ret;
 
 	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
 	if (ret <= 0)
@@ -527,6 +620,28 @@ static int ism_dev_init(struct ism_dev *ism)
 		/* hardware is V2 capable */
 		ism_create_system_eid();
 
+	init_waitqueue_head(&ism->waitq);
+	atomic_set(&ism->free_clients_cnt, 0);
+	atomic_set(&ism->add_dev_cnt, 0);
+
+	wait_event(ism->waitq, !atomic_read(&ism->add_dev_cnt));
+	spin_lock_irqsave(&clients_lock, flags);
+	for (i = 0; i < max_client; ++i)
+		if (clients[i]) {
+			INIT_WORK(&clients[i]->add_work,
+				  ism_dev_add_work_func);
+			clients[i]->tgt_ism = ism;
+			atomic_inc(&ism->add_dev_cnt);
+			schedule_work(&clients[i]->add_work);
+		}
+	spin_unlock_irqrestore(&clients_lock, flags);
+
+	wait_event(ism->waitq, !atomic_read(&ism->add_dev_cnt));
+
+	mutex_lock(&ism_dev_list.mutex);
+	list_add(&ism->list, &ism_dev_list.list);
+	mutex_unlock(&ism_dev_list.mutex);
+
 	ret = smcd_register_dev(ism->smcd);
 	if (ret)
 		goto unreg_ieq;
@@ -602,9 +717,36 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+static void ism_dev_remove_work_func(struct work_struct *work)
+{
+	struct ism_client *client = container_of(work, struct ism_client,
+						 remove_work);
+
+	client->remove(client->tgt_ism);
+	atomic_dec(&client->tgt_ism->free_clients_cnt);
+	wake_up(&client->tgt_ism->waitq);
+}
+
+/* Callers must hold ism_dev_list.mutex */
 static void ism_dev_exit(struct ism_dev *ism)
 {
 	struct pci_dev *pdev = ism->pdev;
+	unsigned long flags;
+	int i;
+
+	wait_event(ism->waitq, !atomic_read(&ism->free_clients_cnt));
+	spin_lock_irqsave(&clients_lock, flags);
+	for (i = 0; i < max_client; ++i)
+		if (clients[i]) {
+			INIT_WORK(&clients[i]->remove_work,
+				  ism_dev_remove_work_func);
+			clients[i]->tgt_ism = ism;
+			atomic_inc(&ism->free_clients_cnt);
+			schedule_work(&clients[i]->remove_work);
+		}
+	spin_unlock_irqrestore(&clients_lock, flags);
+
+	wait_event(ism->waitq, !atomic_read(&ism->free_clients_cnt));
 
 	smcd_unregister_dev(ism->smcd);
 	if (SYSTEM_EID.serial_number[0] != '0' ||
@@ -614,18 +756,22 @@ static void ism_dev_exit(struct ism_dev *ism)
 	unregister_sba(ism);
 	free_irq(pci_irq_vector(pdev, 0), ism);
 	pci_free_irq_vectors(pdev);
+	list_del_init(&ism->list);
 }
 
 static void ism_remove(struct pci_dev *pdev)
 {
 	struct ism_dev *ism = dev_get_drvdata(&pdev->dev);
 
+	mutex_lock(&ism_dev_list.mutex);
 	ism_dev_exit(ism);
+	mutex_unlock(&ism_dev_list.mutex);
 
 	smcd_free_dev(ism->smcd);
 	pci_clear_master(pdev);
 	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
+	device_del(&ism->dev);
 	dev_set_drvdata(&pdev->dev, NULL);
 	kfree(ism);
 }
@@ -645,6 +791,8 @@ static int __init ism_init(void)
 	if (!ism_debug_info)
 		return -ENODEV;
 
+	memset(clients, 0, sizeof(clients));
+	max_client = 0;
 	debug_register_view(ism_debug_info, &debug_hex_ascii_view);
 	ret = pci_register_driver(&ism_driver);
 	if (ret)
@@ -655,6 +803,14 @@ static int __init ism_init(void)
 
 static void __exit ism_exit(void)
 {
+	struct ism_dev *ism;
+
+	mutex_lock(&ism_dev_list.mutex);
+	list_for_each_entry(ism, &ism_dev_list.list, list) {
+		ism_dev_exit(ism);
+	}
+	mutex_unlock(&ism_dev_list.mutex);
+
 	pci_unregister_driver(&ism_driver);
 	debug_unregister(ism_debug_info);
 }
diff --git a/include/linux/ism.h b/include/linux/ism.h
index 69bfbf0faaa1..55c8ad306928 100644
--- a/include/linux/ism.h
+++ b/include/linux/ism.h
@@ -9,6 +9,8 @@
 #ifndef _ISM_H
 #define _ISM_H
 
+#include <linux/workqueue.h>
+
 struct ism_dmb {
 	u64 dmb_tok;
 	u64 rgid;
@@ -20,4 +22,69 @@ struct ism_dmb {
 	dma_addr_t dma_addr;
 };
 
+/* Unless we gain unexpected popularity, this limit should hold for a while */
+#define MAX_CLIENTS		8
+#define ISM_NR_DMBS		1920
+
+struct ism_dev {
+	spinlock_t lock; /* protects the ism device */
+	struct list_head list;
+	struct pci_dev *pdev;
+	struct smcd_dev *smcd;
+
+	struct ism_sba *sba;
+	dma_addr_t sba_dma_addr;
+	DECLARE_BITMAP(sba_bitmap, ISM_NR_DMBS);
+	u8 *sba_client_arr;	/* entries are indices into 'clients' array */
+	void *priv[MAX_CLIENTS];
+
+	struct ism_eq *ieq;
+	dma_addr_t ieq_dma_addr;
+
+	struct device dev;
+	u64 local_gid;
+	int ieq_idx;
+
+	atomic_t free_clients_cnt;
+	atomic_t add_dev_cnt;
+	wait_queue_head_t waitq;
+};
+
+struct ism_event {
+	u32 type;
+	u32 code;
+	u64 tok;
+	u64 time;
+	u64 info;
+};
+
+struct ism_client {
+	const char *name;
+	void (*add)(struct ism_dev *dev);
+	void (*remove)(struct ism_dev *dev);
+	void (*handle_event)(struct ism_dev *dev, struct ism_event *event);
+	/* Parameter dmbemask contains a bit vector with updated DMBEs, if sent
+	 * via ism_move_data(). Callback function must handle all active bits
+	 * indicated by dmbemask.
+	 */
+	void (*handle_irq)(struct ism_dev *dev, unsigned int bit, u16 dmbemask);
+	/* Private area - don't touch! */
+	struct work_struct remove_work;
+	struct work_struct add_work;
+	struct ism_dev *tgt_ism;
+	u8 id;
+};
+
+int ism_register_client(struct ism_client *client);
+int  ism_unregister_client(struct ism_client *client);
+static inline void *ism_get_priv(struct ism_dev *dev,
+				 struct ism_client *client) {
+	return dev->priv[client->id];
+}
+
+static inline void ism_set_priv(struct ism_dev *dev, struct ism_client *client,
+				void *priv) {
+	dev->priv[client->id] = priv;
+}
+
 #endif	/* _ISM_H */
diff --git a/include/net/smc.h b/include/net/smc.h
index c926d3313e05..98689b16b841 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include "linux/ism.h"
 
 struct sock;
 
@@ -48,14 +49,6 @@ struct smcd_dmb {
 
 #define ISM_ERROR	0xFFFF
 
-struct smcd_event {
-	u32 type;
-	u32 code;
-	u64 tok;
-	u64 time;
-	u64 info;
-};
-
 struct smcd_dev;
 
 struct smcd_ops {
@@ -100,6 +93,6 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 int smcd_register_dev(struct smcd_dev *smcd);
 void smcd_unregister_dev(struct smcd_dev *smcd);
 void smcd_free_dev(struct smcd_dev *smcd);
-void smcd_handle_event(struct smcd_dev *dev, struct smcd_event *event);
+void smcd_handle_event(struct smcd_dev *dev, struct ism_event *event);
 void smcd_handle_irq(struct smcd_dev *dev, unsigned int bit, u16 dmbemask);
 #endif	/* _SMC_H */
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 28e1641f990c..215409889872 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -296,7 +296,7 @@ int smcd_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb)
 struct smc_ism_event_work {
 	struct work_struct work;
 	struct smcd_dev *smcd;
-	struct smcd_event event;
+	struct ism_event event;
 };
 
 #define ISM_EVENT_REQUEST		0x0001
@@ -490,7 +490,7 @@ EXPORT_SYMBOL_GPL(smcd_free_dev);
  * Context:
  * - Function called in IRQ context from ISM device driver event handler.
  */
-void smcd_handle_event(struct smcd_dev *smcd, struct smcd_event *event)
+void smcd_handle_event(struct smcd_dev *smcd, struct ism_event *event)
 {
 	struct smc_ism_event_work *wrk;
 
-- 
2.25.1

