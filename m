Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FFA66BA4E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjAPJ1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjAPJ1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:27:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADFA166EB;
        Mon, 16 Jan 2023 01:27:31 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30G8Qg4I005259;
        Mon, 16 Jan 2023 09:27:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Uu0aNkmf9ejhsYUht9GH51ocJs6a19u3PDGJMUoPyuQ=;
 b=DOYKWY7DQkynjcBlXYMnKuL76aytio2TyMAnmwjPcNv0BJPUdZ0kpryTfiv3M0x131Wa
 tXKlAvtHRGhL4rnyPOIqEEnAi0ufndRlNDo2lxb+aubE8G/UFU5+58jQZRwKN96h4IQJ
 JSNWn36LHjemqmZ+4Oc0scCKam9qJF9WDDR5da3UYeAwbv/t/T8A51+Dh0xe7rw5ATjk
 o3q6FAwWZdTwfCGDTu5q7GDTbfXT0vfzfbsj8GqpBtwfW6E8Tvwk1WMvrUtzzfaffctt
 QdTxpPmy0KlD0nNQgEUCAydIFByBGF5202LhyOtmlbBSW7942NG2wxmDxpj7jRowVagE Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n48y5hjr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:25 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30G99RpA012659;
        Mon, 16 Jan 2023 09:27:25 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n48y5hjq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:25 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30F9DpHc010590;
        Mon, 16 Jan 2023 09:27:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n3knf9kut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:23 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30G9RJC944827052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 09:27:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 589CB20040;
        Mon, 16 Jan 2023 09:27:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D284D2004D;
        Mon, 16 Jan 2023 09:27:18 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.177.79])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 09:27:18 +0000 (GMT)
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
Subject: [net-next 7/8] s390/ism: Consolidate SMC-D-related code
Date:   Mon, 16 Jan 2023 10:27:11 +0100
Message-Id: <20230116092712.10176-8-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116092712.10176-1-jaka@linux.ibm.com>
References: <20230116092712.10176-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: shlPr10kc5-Cg2We6S65Aw3L_e1StabG
X-Proofpoint-ORIG-GUID: gGrJduyu6JxNd7kGvsG6OSrnZgNJ0RUC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_06,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 clxscore=1015 spamscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

The ism module had SMC-D-specific code sprinkled across the entire module.
We are now consolidating the SMC-D-specific parts into the latter parts
of the module, so it becomes more clear what code is intended for use with
ISM, and which parts are glue code for usage in the context of SMC-D.
This is the fourth part of a bigger overhaul of the interfaces between SMC
and ISM.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 drivers/s390/net/ism.h     |   2 +
 drivers/s390/net/ism_drv.c | 162 ++++++++++++++++++++++---------------
 include/net/smc.h          |   5 +-
 net/smc/smc_ism.c          |  64 +++++++++------
 4 files changed, 144 insertions(+), 89 deletions(-)

diff --git a/drivers/s390/net/ism.h b/drivers/s390/net/ism.h
index 70c5bbda0fea..3e99fb0ed086 100644
--- a/drivers/s390/net/ism.h
+++ b/drivers/s390/net/ism.h
@@ -231,4 +231,6 @@ static inline int __ism_move(struct ism_dev *ism, u64 dmb_req, void *data,
 	return __zpci_store_block(data, req, dmb_req);
 }
 
+const struct smcd_ops *ism_get_smcd_ops(void);
+
 #endif /* S390_ISM_H */
diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index e6c810a96b24..73c8f42a22a7 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -289,11 +289,6 @@ static int ism_query_rgid(struct ism_dev *ism, u64 rgid, u32 vid_valid,
 	return ism_cmd(ism, &cmd);
 }
 
-static int smcd_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid, u32 vid)
-{
-	return ism_query_rgid(smcd->priv, rgid, vid_valid, vid);
-}
-
 static void ism_free_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	clear_bit(dmb->sba_idx, ism->sba_bitmap);
@@ -363,11 +358,6 @@ int ism_register_dmb(struct ism_dev *ism, struct ism_dmb *dmb,
 }
 EXPORT_SYMBOL_GPL(ism_register_dmb);
 
-static int smcd_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
-{
-	return ism_register_dmb(smcd->priv, (struct ism_dmb *)dmb, NULL);
-}
-
 int ism_unregister_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	union ism_unreg_dmb cmd;
@@ -391,11 +381,6 @@ int ism_unregister_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 }
 EXPORT_SYMBOL_GPL(ism_unregister_dmb);
 
-static int smcd_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
-{
-	return ism_unregister_dmb(smcd->priv, (struct ism_dmb *)dmb);
-}
-
 static int ism_add_vlan_id(struct ism_dev *ism, u64 vlan_id)
 {
 	union ism_set_vlan_id cmd;
@@ -409,11 +394,6 @@ static int ism_add_vlan_id(struct ism_dev *ism, u64 vlan_id)
 	return ism_cmd(ism, &cmd);
 }
 
-static int smcd_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
-{
-	return ism_add_vlan_id(smcd->priv, vlan_id);
-}
-
 static int ism_del_vlan_id(struct ism_dev *ism, u64 vlan_id)
 {
 	union ism_set_vlan_id cmd;
@@ -427,25 +407,9 @@ static int ism_del_vlan_id(struct ism_dev *ism, u64 vlan_id)
 	return ism_cmd(ism, &cmd);
 }
 
-static int smcd_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
-{
-	return ism_del_vlan_id(smcd->priv, vlan_id);
-}
-
-static int ism_set_vlan_required(struct smcd_dev *smcd)
+static int ism_signal_ieq(struct ism_dev *ism, u64 rgid, u32 trigger_irq,
+			  u32 event_code, u64 info)
 {
-	return ism_cmd_simple(smcd->priv, ISM_SET_VLAN);
-}
-
-static int ism_reset_vlan_required(struct smcd_dev *smcd)
-{
-	return ism_cmd_simple(smcd->priv, ISM_RESET_VLAN);
-}
-
-static int smcd_signal_ieq(struct smcd_dev *smcd, u64 rgid, u32 trigger_irq,
-			   u32 event_code, u64 info)
-{
-	struct ism_dev *ism = smcd->priv;
 	union ism_sig_ieq cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -466,11 +430,9 @@ static unsigned int max_bytes(unsigned int start, unsigned int len,
 	return min(boundary - (start & (boundary - 1)), len);
 }
 
-static int smcd_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
-		     bool sf, unsigned int offset, void *data,
-		     unsigned int size)
+int ism_move(struct ism_dev *ism, u64 dmb_tok, unsigned int idx, bool sf,
+	     unsigned int offset, void *data, unsigned int size)
 {
-	struct ism_dev *ism = smcd->priv;
 	unsigned int bytes;
 	u64 dmb_req;
 	int ret;
@@ -491,6 +453,7 @@ static int smcd_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ism_move);
 
 static struct ism_systemeid SYSTEM_EID = {
 	.seid_string = "IBM-SYSZ-ISMSEID00000000",
@@ -518,10 +481,8 @@ u8 *ism_get_seid(void)
 }
 EXPORT_SYMBOL_GPL(ism_get_seid);
 
-static u16 smcd_get_chid(struct smcd_dev *smcd)
+static u16 ism_get_chid(struct ism_dev *ism)
 {
-	struct ism_dev *ism = smcd->priv;
-
 	if (!ism || !ism->pdev)
 		return 0;
 
@@ -583,28 +544,11 @@ static irqreturn_t ism_handle_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static u64 smcd_get_local_gid(struct smcd_dev *smcd)
+static u64 ism_get_local_gid(struct ism_dev *ism)
 {
-	struct ism_dev *ism = smcd->priv;
-
 	return ism->local_gid;
 }
 
-static const struct smcd_ops ism_ops = {
-	.query_remote_gid = smcd_query_rgid,
-	.register_dmb = smcd_register_dmb,
-	.unregister_dmb = smcd_unregister_dmb,
-	.add_vlan_id = smcd_add_vlan_id,
-	.del_vlan_id = smcd_del_vlan_id,
-	.set_vlan_required = ism_set_vlan_required,
-	.reset_vlan_required = ism_reset_vlan_required,
-	.signal_event = smcd_signal_ieq,
-	.move_data = smcd_move,
-	.get_system_eid = ism_get_seid,
-	.get_local_gid = smcd_get_local_gid,
-	.get_chid = smcd_get_chid,
-};
-
 static void ism_dev_add_work_func(struct work_struct *work)
 {
 	struct ism_client *client = container_of(work, struct ism_client,
@@ -846,3 +790,95 @@ static void __exit ism_exit(void)
 
 module_init(ism_init);
 module_exit(ism_exit);
+
+/*************************** SMC-D Implementation *****************************/
+
+#if IS_ENABLED(CONFIG_SMC)
+static int smcd_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
+			   u32 vid)
+{
+	return ism_query_rgid(smcd->priv, rgid, vid_valid, vid);
+}
+
+static int smcd_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
+			     struct ism_client *client)
+{
+	return ism_register_dmb(smcd->priv, (struct ism_dmb *)dmb, client);
+}
+
+static int smcd_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	return ism_unregister_dmb(smcd->priv, (struct ism_dmb *)dmb);
+}
+
+static int smcd_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	return ism_add_vlan_id(smcd->priv, vlan_id);
+}
+
+static int smcd_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	return ism_del_vlan_id(smcd->priv, vlan_id);
+}
+
+static int smcd_set_vlan_required(struct smcd_dev *smcd)
+{
+	return ism_cmd_simple(smcd->priv, ISM_SET_VLAN);
+}
+
+static int smcd_reset_vlan_required(struct smcd_dev *smcd)
+{
+	return ism_cmd_simple(smcd->priv, ISM_RESET_VLAN);
+}
+
+static int smcd_signal_ieq(struct smcd_dev *smcd, u64 rgid, u32 trigger_irq,
+			   u32 event_code, u64 info)
+{
+	return ism_signal_ieq(smcd->priv, rgid, trigger_irq, event_code, info);
+}
+
+static int smcd_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
+		     bool sf, unsigned int offset, void *data,
+		     unsigned int size)
+{
+	return ism_move(smcd->priv, dmb_tok, idx, sf, offset, data, size);
+}
+
+static u64 smcd_get_local_gid(struct smcd_dev *smcd)
+{
+	return ism_get_local_gid(smcd->priv);
+}
+
+static u16 smcd_get_chid(struct smcd_dev *smcd)
+{
+	return ism_get_chid(smcd->priv);
+}
+
+static inline struct device *smcd_get_dev(struct smcd_dev *dev)
+{
+	struct ism_dev *ism = dev->priv;
+
+	return &ism->dev;
+}
+
+static const struct smcd_ops ism_ops = {
+	.query_remote_gid = smcd_query_rgid,
+	.register_dmb = smcd_register_dmb,
+	.unregister_dmb = smcd_unregister_dmb,
+	.add_vlan_id = smcd_add_vlan_id,
+	.del_vlan_id = smcd_del_vlan_id,
+	.set_vlan_required = smcd_set_vlan_required,
+	.reset_vlan_required = smcd_reset_vlan_required,
+	.signal_event = smcd_signal_ieq,
+	.move_data = smcd_move,
+	.get_system_eid = ism_get_seid,
+	.get_local_gid = smcd_get_local_gid,
+	.get_chid = smcd_get_chid,
+};
+
+const struct smcd_ops *ism_get_smcd_ops(void)
+{
+	return &ism_ops;
+}
+EXPORT_SYMBOL_GPL(ism_get_smcd_ops);
+#endif
diff --git a/include/net/smc.h b/include/net/smc.h
index d5f8f18169d7..556b96c12279 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -50,11 +50,13 @@ struct smcd_dmb {
 #define ISM_ERROR	0xFFFF
 
 struct smcd_dev;
+struct ism_client;
 
 struct smcd_ops {
 	int (*query_remote_gid)(struct smcd_dev *dev, u64 rgid, u32 vid_valid,
 				u32 vid);
-	int (*register_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
+	int (*register_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb,
+			    struct ism_client *client);
 	int (*unregister_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
 	int (*add_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
 	int (*del_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
@@ -73,7 +75,6 @@ struct smcd_ops {
 struct smcd_dev {
 	const struct smcd_ops *ops;
 	struct device dev;
-	struct ism_dev *ism;
 	void *priv;
 	struct list_head list;
 	spinlock_t lock;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 6d31e9bbc5f9..37c1b207f15c 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -18,6 +18,7 @@
 #include "smc_pnet.h"
 #include "smc_netlink.h"
 #include "linux/ism.h"
+#include "../../drivers/s390/net/ism.h"
 
 struct smcd_dev_list smcd_dev_list = {
 	.list = LIST_HEAD_INIT(smcd_dev_list.list),
@@ -27,6 +28,7 @@ struct smcd_dev_list smcd_dev_list = {
 static bool smc_ism_v2_capable;
 static u8 smc_ism_v2_system_eid[SMC_MAX_EID_LEN];
 
+#if IS_ENABLED(CONFIG_ISM)
 static void smcd_register_dev(struct ism_dev *ism);
 static void smcd_unregister_dev(struct ism_dev *ism);
 static void smcd_handle_event(struct ism_dev *ism, struct ism_event *event);
@@ -40,6 +42,7 @@ static struct ism_client smc_ism_client = {
 	.handle_event = smcd_handle_event,
 	.handle_irq = smcd_handle_irq,
 };
+#endif
 
 /* Test if an ISM communication is possible - same CPC */
 int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *smcd)
@@ -198,6 +201,7 @@ int smc_ism_unregister_dmb(struct smcd_dev *smcd, struct smc_buf_desc *dmb_desc)
 int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 			 struct smc_buf_desc *dmb_desc)
 {
+#if IS_ENABLED(CONFIG_ISM)
 	struct smcd_dmb dmb;
 	int rc;
 
@@ -206,7 +210,7 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 	dmb.sba_idx = dmb_desc->sba_idx;
 	dmb.vlan_id = lgr->vlan_id;
 	dmb.rgid = lgr->peer_gid;
-	rc = lgr->smcd->ops->register_dmb(lgr->smcd, &dmb);
+	rc = lgr->smcd->ops->register_dmb(lgr->smcd, &dmb, &smc_ism_client);
 	if (!rc) {
 		dmb_desc->sba_idx = dmb.sba_idx;
 		dmb_desc->token = dmb.dmb_tok;
@@ -215,6 +219,9 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 		dmb_desc->len = dmb.dmb_len;
 	}
 	return rc;
+#else
+	return 0;
+#endif
 }
 
 static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
@@ -308,6 +315,7 @@ int smcd_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+#if IS_ENABLED(CONFIG_ISM)
 struct smc_ism_event_work {
 	struct work_struct work;
 	struct smcd_dev *smcd;
@@ -351,24 +359,6 @@ static void smcd_handle_sw_event(struct smc_ism_event_work *wrk)
 	}
 }
 
-int smc_ism_signal_shutdown(struct smc_link_group *lgr)
-{
-	int rc;
-	union smcd_sw_event_info ev_info;
-
-	if (lgr->peer_shutdown)
-		return 0;
-
-	memcpy(ev_info.uid, lgr->id, SMC_LGR_ID_SIZE);
-	ev_info.vlan_id = lgr->vlan_id;
-	ev_info.code = ISM_EVENT_REQUEST;
-	rc = lgr->smcd->ops->signal_event(lgr->smcd, lgr->peer_gid,
-					  ISM_EVENT_REQUEST_IR,
-					  ISM_EVENT_CODE_SHUTDOWN,
-					  ev_info.info);
-	return rc;
-}
-
 /* worker for SMC-D events */
 static void smc_ism_event_work(struct work_struct *work)
 {
@@ -442,9 +432,12 @@ EXPORT_SYMBOL_GPL(smcd_free_dev);
 
 static void smcd_register_dev(struct ism_dev *ism)
 {
-	const struct smcd_ops *ops = NULL;
+	const struct smcd_ops *ops = ism_get_smcd_ops();
 	struct smcd_dev *smcd;
 
+	if (!ops)
+		return;
+
 	smcd = smcd_alloc_dev(&ism->pdev->dev, dev_name(&ism->pdev->dev), ops,
 			      ISM_NR_DMBS);
 	if (!smcd)
@@ -550,16 +543,39 @@ static void smcd_handle_irq(struct ism_dev *ism, unsigned int dmbno,
 		tasklet_schedule(&conn->rx_tsklet);
 	spin_unlock_irqrestore(&smcd->lock, flags);
 }
+#endif
+
+int smc_ism_signal_shutdown(struct smc_link_group *lgr)
+{
+	int rc = 0;
+#if IS_ENABLED(CONFIG_ISM)
+	union smcd_sw_event_info ev_info;
+
+	if (lgr->peer_shutdown)
+		return 0;
+
+	memcpy(ev_info.uid, lgr->id, SMC_LGR_ID_SIZE);
+	ev_info.vlan_id = lgr->vlan_id;
+	ev_info.code = ISM_EVENT_REQUEST;
+	rc = lgr->smcd->ops->signal_event(lgr->smcd, lgr->peer_gid,
+					  ISM_EVENT_REQUEST_IR,
+					  ISM_EVENT_CODE_SHUTDOWN,
+					  ev_info.info);
+#endif
+	return rc;
+}
 
 int smc_ism_init(void)
 {
+	int rc = 0;
+
+#if IS_ENABLED(CONFIG_ISM)
 	smc_ism_v2_capable = false;
 	memset(smc_ism_v2_system_eid, 0, SMC_MAX_EID_LEN);
-#if IS_ENABLED(CONFIG_ISM)
-	return ism_register_client(&smc_ism_client);
-#else
-	return 0;
+
+	rc = ism_register_client(&smc_ism_client);
 #endif
+	return rc;
 }
 
 void smc_ism_exit(void)
-- 
2.25.1

