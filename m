Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372BD66BA4D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjAPJ1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjAPJ1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:27:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F232B166C1;
        Mon, 16 Jan 2023 01:27:29 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30G8Ykov018670;
        Mon, 16 Jan 2023 09:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8DxjOs/T/afHHKRRsxcHS1Go6CPMdf853KaaTUeGxEQ=;
 b=HGS1p+Xc1x49cuD2OE9K73a+Q5jMReJ5y/cG3tnPSKPd7dI2gu9yE9M5T7bwgEm7ydal
 04OJCsF9kfprFPkIghLfZHu7lKdIgsdjsWfXp/awuqNmfCDcptYK9VVK1w7RTu+hwoWS
 X3mSuyKW1FLmmnRUJxN81VWLLMvJanTkceKppk1gZquH/JKPzT8wUd/czv+4wfP4QCAY
 9XHweEoPVWyyN/DZEe3A3G2JCitLtnDyIMlP8EZTjSEYAUA6NXXpyx7EUQivE1P4jIVS
 fjTf/7Fa30jRcO9bW/w0kEk5pb3BpwhkQBwhpjB0KhN855rm+e0gAquJyccanVFxWcrU Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n4g5c3a2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:26 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30G9KdVk021248;
        Mon, 16 Jan 2023 09:27:26 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n4g5c3a1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:26 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30F9DpHd010590;
        Mon, 16 Jan 2023 09:27:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n3knf9kuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:23 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30G9RIrr40567096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 09:27:18 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4418320040;
        Mon, 16 Jan 2023 09:27:18 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B56CA2005A;
        Mon, 16 Jan 2023 09:27:17 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.177.79])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 09:27:17 +0000 (GMT)
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
Subject: [net-next 5/8] net/smc: Register SMC-D as ISM client
Date:   Mon, 16 Jan 2023 10:27:09 +0100
Message-Id: <20230116092712.10176-6-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116092712.10176-1-jaka@linux.ibm.com>
References: <20230116092712.10176-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2kbroaUuvas59hLOmUv54mq3pnFP5igD
X-Proofpoint-ORIG-GUID: 87vJCaqfW68FxmYe3qpanbFSKBTyb190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_07,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Register the smc module with the new ism device driver API.
This is the second part of a bigger overhaul of the interfaces between SMC
and ISM.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c |  5 ---
 include/net/smc.h          |  5 +--
 net/smc/af_smc.c           |  8 +++-
 net/smc/smc_core.c         |  1 +
 net/smc/smc_ism.c          | 82 +++++++++++++++++++++++++++-----------
 net/smc/smc_ism.h          |  3 +-
 6 files changed, 69 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 24983224f47e..f35c6077db04 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -642,10 +642,6 @@ static int ism_dev_init(struct ism_dev *ism)
 	list_add(&ism->list, &ism_dev_list.list);
 	mutex_unlock(&ism_dev_list.mutex);
 
-	ret = smcd_register_dev(ism->smcd);
-	if (ret)
-		goto unreg_ieq;
-
 	query_info(ism);
 	return 0;
 
@@ -748,7 +744,6 @@ static void ism_dev_exit(struct ism_dev *ism)
 
 	wait_event(ism->waitq, !atomic_read(&ism->free_clients_cnt));
 
-	smcd_unregister_dev(ism->smcd);
 	if (SYSTEM_EID.serial_number[0] != '0' ||
 	    SYSTEM_EID.type[0] != '0')
 		ism_del_vlan_id(ism->smcd, ISM_RESERVED_VLANID);
diff --git a/include/net/smc.h b/include/net/smc.h
index 98689b16b841..151aa54d9ad2 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -90,9 +90,6 @@ struct smcd_dev {
 
 struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 				const struct smcd_ops *ops, int max_dmbs);
-int smcd_register_dev(struct smcd_dev *smcd);
-void smcd_unregister_dev(struct smcd_dev *smcd);
 void smcd_free_dev(struct smcd_dev *smcd);
-void smcd_handle_event(struct smcd_dev *dev, struct ism_event *event);
-void smcd_handle_irq(struct smcd_dev *dev, unsigned int bit, u16 dmbemask);
+
 #endif	/* _SMC_H */
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e12d4fa5aece..5d037714ab78 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3382,12 +3382,14 @@ static int __init smc_init(void)
 	if (rc)
 		goto out_pernet_subsys;
 
-	smc_ism_init();
+	rc = smc_ism_init();
+	if (rc)
+		goto out_pernet_subsys_stat;
 	smc_clc_init();
 
 	rc = smc_nl_init();
 	if (rc)
-		goto out_pernet_subsys_stat;
+		goto out_ism;
 
 	rc = smc_pnet_init();
 	if (rc)
@@ -3480,6 +3482,8 @@ static int __init smc_init(void)
 	smc_pnet_exit();
 out_nl:
 	smc_nl_exit();
+out_ism:
+	smc_ism_exit();
 out_pernet_subsys_stat:
 	unregister_pernet_subsys(&smc_net_stat_ops);
 out_pernet_subsys:
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c305d8dd23f8..e15ee084cc5a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2595,6 +2595,7 @@ static int smc_core_reboot_event(struct notifier_block *this,
 {
 	smc_lgrs_shutdown();
 	smc_ib_unregister_client();
+	smc_ism_exit();
 	return 0;
 }
 
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 215409889872..6d31e9bbc5f9 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -17,6 +17,7 @@
 #include "smc_ism.h"
 #include "smc_pnet.h"
 #include "smc_netlink.h"
+#include "linux/ism.h"
 
 struct smcd_dev_list smcd_dev_list = {
 	.list = LIST_HEAD_INIT(smcd_dev_list.list),
@@ -26,6 +27,20 @@ struct smcd_dev_list smcd_dev_list = {
 static bool smc_ism_v2_capable;
 static u8 smc_ism_v2_system_eid[SMC_MAX_EID_LEN];
 
+static void smcd_register_dev(struct ism_dev *ism);
+static void smcd_unregister_dev(struct ism_dev *ism);
+static void smcd_handle_event(struct ism_dev *ism, struct ism_event *event);
+static void smcd_handle_irq(struct ism_dev *ism, unsigned int dmbno,
+			    u16 dmbemask);
+
+static struct ism_client smc_ism_client = {
+	.name = "SMC-D",
+	.add = smcd_register_dev,
+	.remove = smcd_unregister_dev,
+	.handle_event = smcd_handle_event,
+	.handle_irq = smcd_handle_irq,
+};
+
 /* Test if an ISM communication is possible - same CPC */
 int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *smcd)
 {
@@ -409,8 +424,6 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 	device_initialize(&smcd->dev);
 	dev_set_name(&smcd->dev, name);
 	smcd->ops = ops;
-	if (smc_pnetid_by_dev_port(parent, 0, smcd->pnetid))
-		smc_pnetid_by_table_smcd(smcd);
 
 	spin_lock_init(&smcd->lock);
 	spin_lock_init(&smcd->lgr_lock);
@@ -421,9 +434,25 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 }
 EXPORT_SYMBOL_GPL(smcd_alloc_dev);
 
-int smcd_register_dev(struct smcd_dev *smcd)
+void smcd_free_dev(struct smcd_dev *smcd)
 {
-	int rc;
+	put_device(&smcd->dev);
+}
+EXPORT_SYMBOL_GPL(smcd_free_dev);
+
+static void smcd_register_dev(struct ism_dev *ism)
+{
+	const struct smcd_ops *ops = NULL;
+	struct smcd_dev *smcd;
+
+	smcd = smcd_alloc_dev(&ism->pdev->dev, dev_name(&ism->pdev->dev), ops,
+			      ISM_NR_DMBS);
+	if (!smcd)
+		return;
+	smcd->priv = ism;
+	ism_set_priv(ism, &smc_ism_client, smcd);
+	if (smc_pnetid_by_dev_port(&ism->pdev->dev, 0, smcd->pnetid))
+		smc_pnetid_by_table_smcd(smcd);
 
 	mutex_lock(&smcd_dev_list.mutex);
 	if (list_empty(&smcd_dev_list.list)) {
@@ -447,19 +476,20 @@ int smcd_register_dev(struct smcd_dev *smcd)
 			    dev_name(&smcd->dev), smcd->pnetid,
 			    smcd->pnetid_by_user ? " (user defined)" : "");
 
-	rc = device_add(&smcd->dev);
-	if (rc) {
+	if (device_add(&smcd->dev)) {
 		mutex_lock(&smcd_dev_list.mutex);
 		list_del(&smcd->list);
 		mutex_unlock(&smcd_dev_list.mutex);
+		smcd_free_dev(smcd);
 	}
 
-	return rc;
+	return;
 }
-EXPORT_SYMBOL_GPL(smcd_register_dev);
 
-void smcd_unregister_dev(struct smcd_dev *smcd)
+static void smcd_unregister_dev(struct ism_dev *ism)
 {
+	struct smcd_dev *smcd = ism_get_priv(ism, &smc_ism_client);
+
 	pr_warn_ratelimited("smc: removing smcd device %s\n",
 			    dev_name(&smcd->dev));
 	smcd->going_away = 1;
@@ -471,16 +501,9 @@ void smcd_unregister_dev(struct smcd_dev *smcd)
 
 	device_del(&smcd->dev);
 }
-EXPORT_SYMBOL_GPL(smcd_unregister_dev);
-
-void smcd_free_dev(struct smcd_dev *smcd)
-{
-	put_device(&smcd->dev);
-}
-EXPORT_SYMBOL_GPL(smcd_free_dev);
 
 /* SMCD Device event handler. Called from ISM device interrupt handler.
- * Parameters are smcd device pointer,
+ * Parameters are ism device pointer,
  * - event->type (0 --> DMB, 1 --> GID),
  * - event->code (event code),
  * - event->tok (either DMB token when event type 0, or GID when event type 1)
@@ -490,8 +513,9 @@ EXPORT_SYMBOL_GPL(smcd_free_dev);
  * Context:
  * - Function called in IRQ context from ISM device driver event handler.
  */
-void smcd_handle_event(struct smcd_dev *smcd, struct ism_event *event)
+static void smcd_handle_event(struct ism_dev *ism, struct ism_event *event)
 {
+	struct smcd_dev *smcd = ism_get_priv(ism, &smc_ism_client);
 	struct smc_ism_event_work *wrk;
 
 	if (smcd->going_away)
@@ -505,17 +529,18 @@ void smcd_handle_event(struct smcd_dev *smcd, struct ism_event *event)
 	wrk->event = *event;
 	queue_work(smcd->event_wq, &wrk->work);
 }
-EXPORT_SYMBOL_GPL(smcd_handle_event);
 
 /* SMCD Device interrupt handler. Called from ISM device interrupt handler.
- * Parameters are smcd device pointer, DMB number, and the DMBE bitmask.
+ * Parameters are the ism device pointer, DMB number, and the DMBE bitmask.
  * Find the connection and schedule the tasklet for this connection.
  *
  * Context:
  * - Function called in IRQ context from ISM device driver IRQ handler.
  */
-void smcd_handle_irq(struct smcd_dev *smcd, unsigned int dmbno, u16 dmbemask)
+static void smcd_handle_irq(struct ism_dev *ism, unsigned int dmbno,
+			    u16 dmbemask)
 {
+	struct smcd_dev *smcd = ism_get_priv(ism, &smc_ism_client);
 	struct smc_connection *conn = NULL;
 	unsigned long flags;
 
@@ -525,10 +550,21 @@ void smcd_handle_irq(struct smcd_dev *smcd, unsigned int dmbno, u16 dmbemask)
 		tasklet_schedule(&conn->rx_tsklet);
 	spin_unlock_irqrestore(&smcd->lock, flags);
 }
-EXPORT_SYMBOL_GPL(smcd_handle_irq);
 
-void __init smc_ism_init(void)
+int smc_ism_init(void)
 {
 	smc_ism_v2_capable = false;
 	memset(smc_ism_v2_system_eid, 0, SMC_MAX_EID_LEN);
+#if IS_ENABLED(CONFIG_ISM)
+	return ism_register_client(&smc_ism_client);
+#else
+	return 0;
+#endif
+}
+
+void smc_ism_exit(void)
+{
+#if IS_ENABLED(CONFIG_ISM)
+	ism_unregister_client(&smc_ism_client);
+#endif
 }
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index d6b2db604fe8..832b2f42d79f 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -42,7 +42,8 @@ int smc_ism_signal_shutdown(struct smc_link_group *lgr);
 void smc_ism_get_system_eid(u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
 bool smc_ism_is_v2_capable(void);
-void smc_ism_init(void);
+int smc_ism_init(void);
+void smc_ism_exit(void);
 int smcd_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb);
 
 static inline int smc_ism_write(struct smcd_dev *smcd, u64 dmb_tok,
-- 
2.25.1

