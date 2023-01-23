Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F00C678460
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjAWSTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjAWSS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:18:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA99D27D79;
        Mon, 23 Jan 2023 10:18:42 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NGNaYG019023;
        Mon, 23 Jan 2023 18:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=klxqCdWg93ZR98mmFYb2qy0PEvvCLsRg/iY/Pcb2plg=;
 b=gpIHf+y+TCL1LExvj0wJGc2VOudubISGiqoYlT/iycUyMNQsJmLeU6DJBNHm9ag2hGjB
 /P+imX+9VAIVJDUqZgdUykXutGZjTlZtG7Tk1yowSjI1VxhsJZ+DoWVnWoazE6qDLqLP
 rnLHcIuIweNxMK3WbNpe7wn5av2vCvo6YkniLYkGR3l7CEQzIbBcsWpeh6UPTt6l0RYF
 koUAtM4iyP1H6b7IQdissO3Tt8r5UG/IEVuACwf1Ortb//X2UuPTMF0zi4yrdHqoYkZb
 SGaTgn5XMzRiccV4w+PyjRQhu7iWQ6abW/6GFljLt6UOcL7tlYVLLvBV64lm1WOgbSPA 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9wqeu6ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:40 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30NGQ0cg029818;
        Mon, 23 Jan 2023 18:18:39 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9wqeu6u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30N003nw026587;
        Mon, 23 Jan 2023 18:18:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3n87p69yw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:36 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30NIIXij46334354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 18:18:33 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DEB02004D;
        Mon, 23 Jan 2023 18:18:33 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EC5F2004B;
        Mon, 23 Jan 2023 18:18:32 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.0.149])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Jan 2023 18:18:32 +0000 (GMT)
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
Subject: [net-next v2 8/8] net/smc: De-tangle ism and smc device initialization
Date:   Mon, 23 Jan 2023 19:17:52 +0100
Message-Id: <20230123181752.1068-9-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123181752.1068-1-jaka@linux.ibm.com>
References: <20230123181752.1068-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gklNnH2cQLNuUj_H6DF44ApPTsCY71tf
X-Proofpoint-ORIG-GUID: SjtS5H5rkZ7rlAYiJoXDJFxy29oi2lSi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

The struct device for ISM devices was part of struct smcd_dev. Move to
struct ism_dev, provide a new API call in struct smcd_ops, and convert
existing SMCD code accordingly.
Furthermore, remove struct smcd_dev from struct ism_dev.
This is the final part of a bigger overhaul of the interfaces between SMC
and ISM.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 25 +++++++++--------
 include/linux/ism.h        |  1 -
 include/net/smc.h          |  6 +----
 net/smc/af_smc.c           |  1 +
 net/smc/smc_core.c         |  6 +++--
 net/smc/smc_ism.c          | 55 +++++++++-----------------------------
 net/smc/smc_pnet.c         | 40 ++++++++++++++-------------
 7 files changed, 52 insertions(+), 82 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 73c8f42a22a7..eb7e13486087 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -646,6 +646,12 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ism->lock);
 	dev_set_drvdata(&pdev->dev, ism);
 	ism->pdev = pdev;
+	ism->dev.parent = &pdev->dev;
+	device_initialize(&ism->dev);
+	dev_set_name(&ism->dev, dev_name(&pdev->dev));
+	ret = device_add(&ism->dev);
+	if (ret)
+		goto err_dev;
 
 	ret = pci_enable_device_mem(pdev);
 	if (ret)
@@ -663,30 +669,23 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dma_set_max_seg_size(&pdev->dev, SZ_1M);
 	pci_set_master(pdev);
 
-	ism->smcd = smcd_alloc_dev(&pdev->dev, dev_name(&pdev->dev), &ism_ops,
-				   ISM_NR_DMBS);
-	if (!ism->smcd) {
-		ret = -ENOMEM;
-		goto err_resource;
-	}
-
-	ism->smcd->priv = ism;
 	ret = ism_dev_init(ism);
 	if (ret)
-		goto err_free;
+		goto err_resource;
 
 	return 0;
 
-err_free:
-	smcd_free_dev(ism->smcd);
 err_resource:
 	pci_clear_master(pdev);
 	pci_release_mem_regions(pdev);
 err_disable:
 	pci_disable_device(pdev);
 err:
-	kfree(ism);
+	device_del(&ism->dev);
+err_dev:
 	dev_set_drvdata(&pdev->dev, NULL);
+	kfree(ism);
+
 	return ret;
 }
 
@@ -740,7 +739,6 @@ static void ism_remove(struct pci_dev *pdev)
 	ism_dev_exit(ism);
 	mutex_unlock(&ism_dev_list.mutex);
 
-	smcd_free_dev(ism->smcd);
 	pci_clear_master(pdev);
 	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
@@ -874,6 +872,7 @@ static const struct smcd_ops ism_ops = {
 	.get_system_eid = ism_get_seid,
 	.get_local_gid = smcd_get_local_gid,
 	.get_chid = smcd_get_chid,
+	.get_dev = smcd_get_dev,
 };
 
 const struct smcd_ops *ism_get_smcd_ops(void)
diff --git a/include/linux/ism.h b/include/linux/ism.h
index 104ce2fd503a..ea2bcdae7401 100644
--- a/include/linux/ism.h
+++ b/include/linux/ism.h
@@ -30,7 +30,6 @@ struct ism_dev {
 	spinlock_t lock; /* protects the ism device */
 	struct list_head list;
 	struct pci_dev *pdev;
-	struct smcd_dev *smcd;
 
 	struct ism_sba *sba;
 	dma_addr_t sba_dma_addr;
diff --git a/include/net/smc.h b/include/net/smc.h
index 556b96c12279..597cb9381182 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -70,11 +70,11 @@ struct smcd_ops {
 	u8* (*get_system_eid)(void);
 	u64 (*get_local_gid)(struct smcd_dev *dev);
 	u16 (*get_chid)(struct smcd_dev *dev);
+	struct device* (*get_dev)(struct smcd_dev *dev);
 };
 
 struct smcd_dev {
 	const struct smcd_ops *ops;
-	struct device dev;
 	void *priv;
 	struct list_head list;
 	spinlock_t lock;
@@ -90,8 +90,4 @@ struct smcd_dev {
 	u8 going_away : 1;
 };
 
-struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
-				const struct smcd_ops *ops, int max_dmbs);
-void smcd_free_dev(struct smcd_dev *smcd);
-
 #endif	/* _SMC_H */
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 5d037714ab78..036532cf39aa 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3499,6 +3499,7 @@ static void __exit smc_exit(void)
 	sock_unregister(PF_SMC);
 	smc_core_exit();
 	smc_ib_unregister_client();
+	smc_ism_exit();
 	destroy_workqueue(smc_close_wq);
 	destroy_workqueue(smc_tcp_ls_wq);
 	destroy_workqueue(smc_hs_wq);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index ec04966e9bf9..7642b16c41d1 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -822,6 +822,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 {
 	struct smc_link_group *lgr;
 	struct list_head *lgr_list;
+	struct smcd_dev *smcd;
 	struct smc_link *lnk;
 	spinlock_t *lgr_lock;
 	u8 link_idx;
@@ -868,7 +869,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	lgr->conns_all = RB_ROOT;
 	if (ini->is_smcd) {
 		/* SMC-D specific settings */
-		get_device(&ini->ism_dev[ini->ism_selected]->dev);
+		smcd = ini->ism_dev[ini->ism_selected];
+		get_device(smcd->ops->get_dev(smcd));
 		lgr->peer_gid = ini->ism_peer_gid[ini->ism_selected];
 		lgr->smcd = ini->ism_dev[ini->ism_selected];
 		lgr_list = &ini->ism_dev[ini->ism_selected]->lgr_list;
@@ -1387,7 +1389,7 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 	destroy_workqueue(lgr->tx_wq);
 	if (lgr->is_smcd) {
 		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
-		put_device(&lgr->smcd->dev);
+		put_device(lgr->smcd->ops->get_dev(lgr->smcd));
 	}
 	smc_lgr_put(lgr); /* theoretically last lgr_put */
 }
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 6196b305df44..3b0b7710c6b0 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -231,9 +231,11 @@ static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
 	struct smc_pci_dev smc_pci_dev;
 	struct nlattr *port_attrs;
 	struct nlattr *attrs;
+	struct ism_dev *ism;
 	int use_cnt = 0;
 	void *nlh;
 
+	ism = smcd->priv;
 	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			  &smc_gen_nl_family, NLM_F_MULTI,
 			  SMC_NETLINK_GET_DEV_SMCD);
@@ -248,7 +250,7 @@ static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
 	if (nla_put_u8(skb, SMC_NLA_DEV_IS_CRIT, use_cnt > 0))
 		goto errattr;
 	memset(&smc_pci_dev, 0, sizeof(smc_pci_dev));
-	smc_set_pci_values(to_pci_dev(smcd->dev.parent), &smc_pci_dev);
+	smc_set_pci_values(to_pci_dev(ism->dev.parent), &smc_pci_dev);
 	if (nla_put_u32(skb, SMC_NLA_DEV_PCI_FID, smc_pci_dev.pci_fid))
 		goto errattr;
 	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_CHID, smc_pci_dev.pci_pchid))
@@ -377,41 +379,24 @@ static void smc_ism_event_work(struct work_struct *work)
 	kfree(wrk);
 }
 
-static void smcd_release(struct device *dev)
-{
-	struct smcd_dev *smcd = container_of(dev, struct smcd_dev, dev);
-
-	kfree(smcd->conn);
-	kfree(smcd);
-}
-
-struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
-				const struct smcd_ops *ops, int max_dmbs)
+static struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
+				       const struct smcd_ops *ops, int max_dmbs)
 {
 	struct smcd_dev *smcd;
 
-	smcd = kzalloc(sizeof(*smcd), GFP_KERNEL);
+	smcd = devm_kzalloc(parent, sizeof(*smcd), GFP_KERNEL);
 	if (!smcd)
 		return NULL;
-	smcd->conn = kcalloc(max_dmbs, sizeof(struct smc_connection *),
-			     GFP_KERNEL);
-	if (!smcd->conn) {
-		kfree(smcd);
+	smcd->conn = devm_kcalloc(parent, max_dmbs,
+				  sizeof(struct smc_connection *), GFP_KERNEL);
+	if (!smcd->conn)
 		return NULL;
-	}
 
 	smcd->event_wq = alloc_ordered_workqueue("ism_evt_wq-%s)",
 						 WQ_MEM_RECLAIM, name);
-	if (!smcd->event_wq) {
-		kfree(smcd->conn);
-		kfree(smcd);
+	if (!smcd->event_wq)
 		return NULL;
-	}
 
-	smcd->dev.parent = parent;
-	smcd->dev.release = smcd_release;
-	device_initialize(&smcd->dev);
-	dev_set_name(&smcd->dev, name);
 	smcd->ops = ops;
 
 	spin_lock_init(&smcd->lock);
@@ -421,13 +406,6 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 	init_waitqueue_head(&smcd->lgrs_deleted);
 	return smcd;
 }
-EXPORT_SYMBOL_GPL(smcd_alloc_dev);
-
-void smcd_free_dev(struct smcd_dev *smcd)
-{
-	put_device(&smcd->dev);
-}
-EXPORT_SYMBOL_GPL(smcd_free_dev);
 
 static void smcd_register_dev(struct ism_dev *ism)
 {
@@ -465,16 +443,9 @@ static void smcd_register_dev(struct ism_dev *ism)
 	mutex_unlock(&smcd_dev_list.mutex);
 
 	pr_warn_ratelimited("smc: adding smcd device %s with pnetid %.16s%s\n",
-			    dev_name(&smcd->dev), smcd->pnetid,
+			    dev_name(&ism->dev), smcd->pnetid,
 			    smcd->pnetid_by_user ? " (user defined)" : "");
 
-	if (device_add(&smcd->dev)) {
-		mutex_lock(&smcd_dev_list.mutex);
-		list_del(&smcd->list);
-		mutex_unlock(&smcd_dev_list.mutex);
-		smcd_free_dev(smcd);
-	}
-
 	return;
 }
 
@@ -483,15 +454,13 @@ static void smcd_unregister_dev(struct ism_dev *ism)
 	struct smcd_dev *smcd = ism_get_priv(ism, &smc_ism_client);
 
 	pr_warn_ratelimited("smc: removing smcd device %s\n",
-			    dev_name(&smcd->dev));
+			    dev_name(&ism->dev));
 	smcd->going_away = 1;
 	smc_smcd_terminate_all(smcd);
 	mutex_lock(&smcd_dev_list.mutex);
 	list_del_init(&smcd->list);
 	mutex_unlock(&smcd_dev_list.mutex);
 	destroy_workqueue(smcd->event_wq);
-
-	device_del(&smcd->dev);
 }
 
 /* SMCD Device event handler. Called from ISM device interrupt handler.
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 25fb2fd186e2..11775401df68 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -103,7 +103,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 	struct smc_pnetentry *pnetelem, *tmp_pe;
 	struct smc_pnettable *pnettable;
 	struct smc_ib_device *ibdev;
-	struct smcd_dev *smcd_dev;
+	struct smcd_dev *smcd;
 	struct smc_net *sn;
 	int rc = -ENOENT;
 	int ibport;
@@ -162,16 +162,17 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 	mutex_unlock(&smc_ib_devices.mutex);
 	/* remove smcd devices */
 	mutex_lock(&smcd_dev_list.mutex);
-	list_for_each_entry(smcd_dev, &smcd_dev_list.list, list) {
-		if (smcd_dev->pnetid_by_user &&
+	list_for_each_entry(smcd, &smcd_dev_list.list, list) {
+		if (smcd->pnetid_by_user &&
 		    (!pnet_name ||
-		     smc_pnet_match(pnet_name, smcd_dev->pnetid))) {
+		     smc_pnet_match(pnet_name, smcd->pnetid))) {
 			pr_warn_ratelimited("smc: smcd device %s "
 					    "erased user defined pnetid "
-					    "%.16s\n", dev_name(&smcd_dev->dev),
-					    smcd_dev->pnetid);
-			memset(smcd_dev->pnetid, 0, SMC_MAX_PNETID_LEN);
-			smcd_dev->pnetid_by_user = false;
+					    "%.16s\n",
+					    dev_name(smcd->ops->get_dev(smcd)),
+					    smcd->pnetid);
+			memset(smcd->pnetid, 0, SMC_MAX_PNETID_LEN);
+			smcd->pnetid_by_user = false;
 			rc = 0;
 		}
 	}
@@ -331,8 +332,8 @@ static struct smcd_dev *smc_pnet_find_smcd(char *smcd_name)
 
 	mutex_lock(&smcd_dev_list.mutex);
 	list_for_each_entry(smcd_dev, &smcd_dev_list.list, list) {
-		if (!strncmp(dev_name(&smcd_dev->dev), smcd_name,
-			     IB_DEVICE_NAME_MAX - 1))
+		if (!strncmp(dev_name(smcd_dev->ops->get_dev(smcd_dev)),
+			     smcd_name, IB_DEVICE_NAME_MAX - 1))
 			goto out;
 	}
 	smcd_dev = NULL;
@@ -411,7 +412,8 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	struct smc_ib_device *ib_dev;
 	bool smcddev_applied = true;
 	bool ibdev_applied = true;
-	struct smcd_dev *smcd_dev;
+	struct smcd_dev *smcd;
+	struct device *dev;
 	bool new_ibdev;
 
 	/* try to apply the pnetid to active devices */
@@ -425,14 +427,16 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 					    ib_port,
 					    ib_dev->pnetid[ib_port - 1]);
 	}
-	smcd_dev = smc_pnet_find_smcd(ib_name);
-	if (smcd_dev) {
-		smcddev_applied = smc_pnet_apply_smcd(smcd_dev, pnet_name);
-		if (smcddev_applied)
+	smcd = smc_pnet_find_smcd(ib_name);
+	if (smcd) {
+		smcddev_applied = smc_pnet_apply_smcd(smcd, pnet_name);
+		if (smcddev_applied) {
+			dev = smcd->ops->get_dev(smcd);
 			pr_warn_ratelimited("smc: smcd device %s "
 					    "applied user defined pnetid "
-					    "%.16s\n", dev_name(&smcd_dev->dev),
-					    smcd_dev->pnetid);
+					    "%.16s\n", dev_name(dev),
+					    smcd->pnetid);
+		}
 	}
 	/* Apply fails when a device has a hardware-defined pnetid set, do not
 	 * add a pnet table entry in that case.
@@ -1181,7 +1185,7 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
  */
 int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
 {
-	const char *ib_name = dev_name(&smcddev->dev);
+	const char *ib_name = dev_name(smcddev->ops->get_dev(smcddev));
 	struct smc_pnettable *pnettable;
 	struct smc_pnetentry *tmp_pe;
 	struct smc_net *sn;
-- 
2.25.1

