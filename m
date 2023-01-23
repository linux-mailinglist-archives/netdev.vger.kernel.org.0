Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B9267845E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjAWSTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbjAWSS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:18:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA90A26872;
        Mon, 23 Jan 2023 10:18:42 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NI1hSn032256;
        Mon, 23 Jan 2023 18:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2g03c31fR08YkbdvVn96Z+UxWxrF3EPBE3ZVgwIPmb4=;
 b=gS6esP70DwSBfHRI2qn6Yuvk8QMXmkKX/gzSgBgKf3CRnxc2zzcaRCbIk/8EG4ZLjDfG
 PvTpevg/S/LPnjYrT36l9rI0Iy+ito4IbcFgoHIfR+7wlbpjuXEPZdRA8fQTan8vae7L
 i1S9NH8Cc+JmiFPqUd5H26RRy3lVfJ21ykALDjOAv1QtrzBriEgZZHqnPMFY6tF8Vuqk
 YNcAN/eKjmnebqMxtUuO+AG7AjyTS+d55hNV2jr1SI0044womAyqIJKwzKrNQbX4rOSb
 tzvd3DJTQOgSQ6CFC3hCvNv5NJjJaTf6GZV5eEvSkZfezj4x7frw5ynREGseBwTvvMF1 cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9y5frdek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:37 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30NI2GuY001425;
        Mon, 23 Jan 2023 18:18:37 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9y5frddc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:37 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30NH9Juu010329;
        Mon, 23 Jan 2023 18:18:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n87p6jqbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:34 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30NIIV6c42271128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 18:18:31 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2FF62004D;
        Mon, 23 Jan 2023 18:18:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC7572004B;
        Mon, 23 Jan 2023 18:18:29 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.0.149])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Jan 2023 18:18:29 +0000 (GMT)
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
Subject: [net-next v2 6/8] net/smc: Separate SMC-D and ISM APIs
Date:   Mon, 23 Jan 2023 19:17:50 +0100
Message-Id: <20230123181752.1068-7-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123181752.1068-1-jaka@linux.ibm.com>
References: <20230123181752.1068-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: emyIEd5poos_y6uQrfYXxSttmXdYUolD
X-Proofpoint-ORIG-GUID: bQZVXfmCPu0mvEaqgDBHRboEHxv3hHvg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

We separate the code implementing the struct smcd_ops API in the ISM
device driver from the functions that may be used by other exploiters of
ISM devices.
Note: We start out small, and don't offer the whole breadth of the ISM
device for public use, as many functions are specific to or likely only
ever used in the context of SMC-D.
This is the third part of a bigger overhaul of the interfaces between SMC
and ISM.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 92 ++++++++++++++++++++++++++------------
 include/linux/ism.h        |  7 +++
 include/net/smc.h          |  3 +-
 net/smc/smc_clc.c          | 11 +++--
 net/smc/smc_core.c         |  6 ++-
 net/smc/smc_diag.c         |  3 +-
 6 files changed, 86 insertions(+), 36 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index f35c6077db04..e6c810a96b24 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -273,10 +273,9 @@ static int ism_read_local_gid(struct ism_dev *ism)
 	return ret;
 }
 
-static int ism_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
+static int ism_query_rgid(struct ism_dev *ism, u64 rgid, u32 vid_valid,
 			  u32 vid)
 {
-	struct ism_dev *ism = smcd->priv;
 	union ism_query_rgid cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -290,6 +289,11 @@ static int ism_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
 	return ism_cmd(ism, &cmd);
 }
 
+static int smcd_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid, u32 vid)
+{
+	return ism_query_rgid(smcd->priv, rgid, vid_valid, vid);
+}
+
 static void ism_free_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	clear_bit(dmb->sba_idx, ism->sba_bitmap);
@@ -326,9 +330,9 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 	return dmb->cpu_addr ? 0 : -ENOMEM;
 }
 
-static int ism_register_dmb(struct smcd_dev *smcd, struct ism_dmb *dmb)
+int ism_register_dmb(struct ism_dev *ism, struct ism_dmb *dmb,
+		     struct ism_client *client)
 {
-	struct ism_dev *ism = smcd->priv;
 	union ism_reg_dmb cmd;
 	int ret;
 
@@ -353,18 +357,19 @@ static int ism_register_dmb(struct smcd_dev *smcd, struct ism_dmb *dmb)
 		goto out;
 	}
 	dmb->dmb_tok = cmd.response.dmb_tok;
+	ism->sba_client_arr[dmb->sba_idx - ISM_DMB_BIT_OFFSET] = client->id;
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ism_register_dmb);
 
 static int smcd_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 {
-	return ism_register_dmb(smcd, (struct ism_dmb *)dmb);
+	return ism_register_dmb(smcd->priv, (struct ism_dmb *)dmb, NULL);
 }
 
-static int ism_unregister_dmb(struct smcd_dev *smcd, struct ism_dmb *dmb)
+int ism_unregister_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
-	struct ism_dev *ism = smcd->priv;
 	union ism_unreg_dmb cmd;
 	int ret;
 
@@ -374,6 +379,8 @@ static int ism_unregister_dmb(struct smcd_dev *smcd, struct ism_dmb *dmb)
 
 	cmd.request.dmb_tok = dmb->dmb_tok;
 
+	ism->sba_client_arr[dmb->sba_idx - ISM_DMB_BIT_OFFSET] = NO_CLIENT;
+
 	ret = ism_cmd(ism, &cmd);
 	if (ret && ret != ISM_ERROR)
 		goto out;
@@ -382,15 +389,15 @@ static int ism_unregister_dmb(struct smcd_dev *smcd, struct ism_dmb *dmb)
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ism_unregister_dmb);
 
 static int smcd_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 {
-	return ism_unregister_dmb(smcd, (struct ism_dmb *)dmb);
+	return ism_unregister_dmb(smcd->priv, (struct ism_dmb *)dmb);
 }
 
-static int ism_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+static int ism_add_vlan_id(struct ism_dev *ism, u64 vlan_id)
 {
-	struct ism_dev *ism = smcd->priv;
 	union ism_set_vlan_id cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -402,9 +409,13 @@ static int ism_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
 	return ism_cmd(ism, &cmd);
 }
 
-static int ism_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+static int smcd_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	return ism_add_vlan_id(smcd->priv, vlan_id);
+}
+
+static int ism_del_vlan_id(struct ism_dev *ism, u64 vlan_id)
 {
-	struct ism_dev *ism = smcd->priv;
 	union ism_set_vlan_id cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -416,6 +427,11 @@ static int ism_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
 	return ism_cmd(ism, &cmd);
 }
 
+static int smcd_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	return ism_del_vlan_id(smcd->priv, vlan_id);
+}
+
 static int ism_set_vlan_required(struct smcd_dev *smcd)
 {
 	return ism_cmd_simple(smcd->priv, ISM_SET_VLAN);
@@ -426,8 +442,8 @@ static int ism_reset_vlan_required(struct smcd_dev *smcd)
 	return ism_cmd_simple(smcd->priv, ISM_RESET_VLAN);
 }
 
-static int ism_signal_ieq(struct smcd_dev *smcd, u64 rgid, u32 trigger_irq,
-			  u32 event_code, u64 info)
+static int smcd_signal_ieq(struct smcd_dev *smcd, u64 rgid, u32 trigger_irq,
+			   u32 event_code, u64 info)
 {
 	struct ism_dev *ism = smcd->priv;
 	union ism_sig_ieq cmd;
@@ -450,8 +466,9 @@ static unsigned int max_bytes(unsigned int start, unsigned int len,
 	return min(boundary - (start & (boundary - 1)), len);
 }
 
-static int ism_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
-		    bool sf, unsigned int offset, void *data, unsigned int size)
+static int smcd_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
+		     bool sf, unsigned int offset, void *data,
+		     unsigned int size)
 {
 	struct ism_dev *ism = smcd->priv;
 	unsigned int bytes;
@@ -495,14 +512,15 @@ static void ism_create_system_eid(void)
 	memcpy(&SYSTEM_EID.type, tmp, 4);
 }
 
-static u8 *ism_get_system_eid(void)
+u8 *ism_get_seid(void)
 {
 	return SYSTEM_EID.seid_string;
 }
+EXPORT_SYMBOL_GPL(ism_get_seid);
 
-static u16 ism_get_chid(struct smcd_dev *smcd)
+static u16 smcd_get_chid(struct smcd_dev *smcd)
 {
-	struct ism_dev *ism = (struct ism_dev *)smcd->priv;
+	struct ism_dev *ism = smcd->priv;
 
 	if (!ism || !ism->pdev)
 		return 0;
@@ -565,18 +583,26 @@ static irqreturn_t ism_handle_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static u64 smcd_get_local_gid(struct smcd_dev *smcd)
+{
+	struct ism_dev *ism = smcd->priv;
+
+	return ism->local_gid;
+}
+
 static const struct smcd_ops ism_ops = {
-	.query_remote_gid = ism_query_rgid,
+	.query_remote_gid = smcd_query_rgid,
 	.register_dmb = smcd_register_dmb,
 	.unregister_dmb = smcd_unregister_dmb,
-	.add_vlan_id = ism_add_vlan_id,
-	.del_vlan_id = ism_del_vlan_id,
+	.add_vlan_id = smcd_add_vlan_id,
+	.del_vlan_id = smcd_del_vlan_id,
 	.set_vlan_required = ism_set_vlan_required,
 	.reset_vlan_required = ism_reset_vlan_required,
-	.signal_event = ism_signal_ieq,
-	.move_data = ism_move,
-	.get_system_eid = ism_get_system_eid,
-	.get_chid = ism_get_chid,
+	.signal_event = smcd_signal_ieq,
+	.move_data = smcd_move,
+	.get_system_eid = ism_get_seid,
+	.get_local_gid = smcd_get_local_gid,
+	.get_chid = smcd_get_chid,
 };
 
 static void ism_dev_add_work_func(struct work_struct *work)
@@ -599,10 +625,15 @@ static int ism_dev_init(struct ism_dev *ism)
 	if (ret <= 0)
 		goto out;
 
+	ism->sba_client_arr = kzalloc(ISM_NR_DMBS, GFP_KERNEL);
+	if (!ism->sba_client_arr)
+		goto free_vectors;
+	memset(ism->sba_client_arr, NO_CLIENT, ISM_NR_DMBS);
+
 	ret = request_irq(pci_irq_vector(pdev, 0), ism_handle_irq, 0,
 			  pci_name(pdev), ism);
 	if (ret)
-		goto free_vectors;
+		goto free_client_arr;
 
 	ret = register_sba(ism);
 	if (ret)
@@ -616,7 +647,7 @@ static int ism_dev_init(struct ism_dev *ism)
 	if (ret)
 		goto unreg_ieq;
 
-	if (!ism_add_vlan_id(ism->smcd, ISM_RESERVED_VLANID))
+	if (!ism_add_vlan_id(ism, ISM_RESERVED_VLANID))
 		/* hardware is V2 capable */
 		ism_create_system_eid();
 
@@ -651,6 +682,8 @@ static int ism_dev_init(struct ism_dev *ism)
 	unregister_sba(ism);
 free_irq:
 	free_irq(pci_irq_vector(pdev, 0), ism);
+free_client_arr:
+	kfree(ism->sba_client_arr);
 free_vectors:
 	pci_free_irq_vectors(pdev);
 out:
@@ -746,10 +779,11 @@ static void ism_dev_exit(struct ism_dev *ism)
 
 	if (SYSTEM_EID.serial_number[0] != '0' ||
 	    SYSTEM_EID.type[0] != '0')
-		ism_del_vlan_id(ism->smcd, ISM_RESERVED_VLANID);
+		ism_del_vlan_id(ism, ISM_RESERVED_VLANID);
 	unregister_ieq(ism);
 	unregister_sba(ism);
 	free_irq(pci_irq_vector(pdev, 0), ism);
+	kfree(ism->sba_client_arr);
 	pci_free_irq_vectors(pdev);
 	list_del_init(&ism->list);
 }
diff --git a/include/linux/ism.h b/include/linux/ism.h
index 55c8ad306928..bdd29e08d4fe 100644
--- a/include/linux/ism.h
+++ b/include/linux/ism.h
@@ -87,4 +87,11 @@ static inline void ism_set_priv(struct ism_dev *dev, struct ism_client *client,
 	dev->priv[client->id] = priv;
 }
 
+int  ism_register_dmb(struct ism_dev *dev, struct ism_dmb *dmb,
+		      struct ism_client *client);
+int  ism_unregister_dmb(struct ism_dev *dev, struct ism_dmb *dmb);
+int  ism_move(struct ism_dev *dev, u64 dmb_tok, unsigned int idx, bool sf,
+	      unsigned int offset, void *data, unsigned int size);
+u8  *ism_get_seid(void);
+
 #endif	/* _ISM_H */
diff --git a/include/net/smc.h b/include/net/smc.h
index 151aa54d9ad2..d5f8f18169d7 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -66,14 +66,15 @@ struct smcd_ops {
 			 bool sf, unsigned int offset, void *data,
 			 unsigned int size);
 	u8* (*get_system_eid)(void);
+	u64 (*get_local_gid)(struct smcd_dev *dev);
 	u16 (*get_chid)(struct smcd_dev *dev);
 };
 
 struct smcd_dev {
 	const struct smcd_ops *ops;
 	struct device dev;
+	struct ism_dev *ism;
 	void *priv;
-	u64 local_gid;
 	struct list_head list;
 	spinlock_t lock;
 	struct smc_connection **conn;
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index dfb9797f7bc6..b9b8b07aa702 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -813,6 +813,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 	struct smc_clc_v2_extension *v2_ext;
 	struct smc_clc_msg_smcd *pclc_smcd;
 	struct smc_clc_msg_trail *trl;
+	struct smcd_dev *smcd;
 	int len, i, plen, rc;
 	int reason_code = 0;
 	struct kvec vec[8];
@@ -868,7 +869,9 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 	if (smcd_indicated(ini->smc_type_v1)) {
 		/* add SMC-D specifics */
 		if (ini->ism_dev[0]) {
-			pclc_smcd->ism.gid = htonll(ini->ism_dev[0]->local_gid);
+			smcd = ini->ism_dev[0];
+			pclc_smcd->ism.gid =
+				htonll(smcd->ops->get_local_gid(smcd));
 			pclc_smcd->ism.chid =
 				htons(smc_ism_get_chid(ini->ism_dev[0]));
 		}
@@ -914,8 +917,9 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 		plen += sizeof(*smcd_v2_ext);
 		if (ini->ism_offered_cnt) {
 			for (i = 1; i <= ini->ism_offered_cnt; i++) {
+				smcd = ini->ism_dev[i];
 				gidchids[i - 1].gid =
-					htonll(ini->ism_dev[i]->local_gid);
+					htonll(smcd->ops->get_local_gid(smcd));
 				gidchids[i - 1].chid =
 					htons(smc_ism_get_chid(ini->ism_dev[i]));
 			}
@@ -1000,7 +1004,8 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		memcpy(clc->hdr.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
 		clc->hdr.typev1 = SMC_TYPE_D;
-		clc->d0.gid = conn->lgr->smcd->local_gid;
+		clc->d0.gid =
+			conn->lgr->smcd->ops->get_local_gid(conn->lgr->smcd);
 		clc->d0.token = conn->rmb_desc->token;
 		clc->d0.dmbe_size = conn->rmbe_size_short;
 		clc->d0.dmbe_idx = 0;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index e15ee084cc5a..ec04966e9bf9 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -500,6 +500,7 @@ static int smc_nl_fill_smcd_lgr(struct smc_link_group *lgr,
 				struct netlink_callback *cb)
 {
 	char smc_pnet[SMC_MAX_PNETID_LEN + 1];
+	struct smcd_dev *smcd = lgr->smcd;
 	struct nlattr *attrs;
 	void *nlh;
 
@@ -515,8 +516,9 @@ static int smc_nl_fill_smcd_lgr(struct smc_link_group *lgr,
 
 	if (nla_put_u32(skb, SMC_NLA_LGR_D_ID, *((u32 *)&lgr->id)))
 		goto errattr;
-	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_D_GID, lgr->smcd->local_gid,
-			      SMC_NLA_LGR_D_PAD))
+	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_D_GID,
+			      smcd->ops->get_local_gid(smcd),
+				  SMC_NLA_LGR_D_PAD))
 		goto errattr;
 	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_D_PEER_GID, lgr->peer_gid,
 			      SMC_NLA_LGR_D_PAD))
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 80ea7d954ece..7ff2152971a5 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -167,12 +167,13 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 	    !list_empty(&smc->conn.lgr->list)) {
 		struct smc_connection *conn = &smc->conn;
 		struct smcd_diag_dmbinfo dinfo;
+		struct smcd_dev *smcd = conn->lgr->smcd;
 
 		memset(&dinfo, 0, sizeof(dinfo));
 
 		dinfo.linkid = *((u32 *)conn->lgr->id);
 		dinfo.peer_gid = conn->lgr->peer_gid;
-		dinfo.my_gid = conn->lgr->smcd->local_gid;
+		dinfo.my_gid = smcd->ops->get_local_gid(smcd);
 		dinfo.token = conn->rmb_desc->token;
 		dinfo.peer_token = conn->peer_token;
 
-- 
2.25.1

