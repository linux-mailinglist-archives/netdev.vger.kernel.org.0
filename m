Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D50678452
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjAWSSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbjAWSSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:18:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A729BB81;
        Mon, 23 Jan 2023 10:18:39 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NIDXnH000618;
        Mon, 23 Jan 2023 18:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FUBkLCVrXq0V5HEt8zhEPA0jrDtMBtTTJGtr83LAbPg=;
 b=I0d5EUPwRwmGi+2fIluaQbH7YXa4qd4/ZvG/9pND1jUXfdj+ea2jef53E0trgpVamx7f
 yL06QmfiR6AQD/2BvPlyap07MUQp6ycDaizw5jWuldww/fwF6TVUiB40tSct3qN0XN2U
 wanDQYyNBLeAaCHavRQKSKYlR0Zr3JHWcQ8YYSJbFcRE4BuTDoA8XHNiTrbYTtgKmckz
 1adBihMYULZqL2uaTiiJcUnvnrEzpGjyKS0fDKr5zHKvEoKga3eg5Zar2h8vfwcGLyCi
 RHeZ7P96nb4lzORVboybL7MaxZ+ucVf3mO4vuc+wGnkGrijSUF9ZfVzut6T/6e06zmES hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9xmk923y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:33 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30NIGuPj012837;
        Mon, 23 Jan 2023 18:18:33 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9xmk922y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:33 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30N5ALEB009185;
        Mon, 23 Jan 2023 18:18:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n87p69y5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:31 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30NIIRvR24052464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 18:18:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97F182004B;
        Mon, 23 Jan 2023 18:18:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9049C20040;
        Mon, 23 Jan 2023 18:18:26 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.0.149])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Jan 2023 18:18:26 +0000 (GMT)
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
Subject: [net-next v2 3/8] s390/ism: Introduce struct ism_dmb
Date:   Mon, 23 Jan 2023 19:17:47 +0100
Message-Id: <20230123181752.1068-4-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123181752.1068-1-jaka@linux.ibm.com>
References: <20230123181752.1068-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eTk52u9mZK1nAa4cd7xFFL-4FqQRgaL5
X-Proofpoint-ORIG-GUID: Vd5BWDA8xG8TQaX-aeV1ArwS6TnbVe5e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=789 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

Conceptually, a DMB is a structure that belongs to ISM devices. However,
SMC currently 'owns' this structure. So future exploiters of ISM devices
would be forced to include SMC headers to work - which is just weird.
Therefore, we switch ISM to struct ism_dmb, introduce a new public header
with the definition (will be populated with further API calls later on),
and, add a thin wrapper to please SMC. Since structs smcd_dmb and ism_dmb
are identical, we can simply convert between the two for now.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 drivers/s390/net/ism.h     |  1 +
 drivers/s390/net/ism_drv.c | 22 ++++++++++++++++------
 include/linux/ism.h        | 23 +++++++++++++++++++++++
 3 files changed, 40 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/ism.h

diff --git a/drivers/s390/net/ism.h b/drivers/s390/net/ism.h
index 38fe90c2597d..90af51370183 100644
--- a/drivers/s390/net/ism.h
+++ b/drivers/s390/net/ism.h
@@ -5,6 +5,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/ism.h>
 #include <net/smc.h>
 #include <asm/pci_insn.h>
 
diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index e253949aa975..b9f33f411d78 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -215,14 +215,14 @@ static int ism_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
 	return ism_cmd(ism, &cmd);
 }
 
-static void ism_free_dmb(struct ism_dev *ism, struct smcd_dmb *dmb)
+static void ism_free_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	clear_bit(dmb->sba_idx, ism->sba_bitmap);
 	dma_free_coherent(&ism->pdev->dev, dmb->dmb_len,
 			  dmb->cpu_addr, dmb->dma_addr);
 }
 
-static int ism_alloc_dmb(struct ism_dev *ism, struct smcd_dmb *dmb)
+static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	unsigned long bit;
 
@@ -251,7 +251,7 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct smcd_dmb *dmb)
 	return dmb->cpu_addr ? 0 : -ENOMEM;
 }
 
-static int ism_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+static int ism_register_dmb(struct smcd_dev *smcd, struct ism_dmb *dmb)
 {
 	struct ism_dev *ism = smcd->priv;
 	union ism_reg_dmb cmd;
@@ -282,7 +282,12 @@ static int ism_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 	return ret;
 }
 
-static int ism_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+static int smcd_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	return ism_register_dmb(smcd, (struct ism_dmb *)dmb);
+}
+
+static int ism_unregister_dmb(struct smcd_dev *smcd, struct ism_dmb *dmb)
 {
 	struct ism_dev *ism = smcd->priv;
 	union ism_unreg_dmb cmd;
@@ -303,6 +308,11 @@ static int ism_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 	return ret;
 }
 
+static int smcd_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	return ism_unregister_dmb(smcd, (struct ism_dmb *)dmb);
+}
+
 static int ism_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
 {
 	struct ism_dev *ism = smcd->priv;
@@ -475,8 +485,8 @@ static irqreturn_t ism_handle_irq(int irq, void *data)
 
 static const struct smcd_ops ism_ops = {
 	.query_remote_gid = ism_query_rgid,
-	.register_dmb = ism_register_dmb,
-	.unregister_dmb = ism_unregister_dmb,
+	.register_dmb = smcd_register_dmb,
+	.unregister_dmb = smcd_unregister_dmb,
 	.add_vlan_id = ism_add_vlan_id,
 	.del_vlan_id = ism_del_vlan_id,
 	.set_vlan_required = ism_set_vlan_required,
diff --git a/include/linux/ism.h b/include/linux/ism.h
new file mode 100644
index 000000000000..69bfbf0faaa1
--- /dev/null
+++ b/include/linux/ism.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Internal Shared Memory
+ *
+ *  Definitions for the ISM module
+ *
+ *  Copyright IBM Corp. 2022
+ */
+#ifndef _ISM_H
+#define _ISM_H
+
+struct ism_dmb {
+	u64 dmb_tok;
+	u64 rgid;
+	u32 dmb_len;
+	u32 sba_idx;
+	u32 vlan_valid;
+	u32 vlan_id;
+	void *cpu_addr;
+	dma_addr_t dma_addr;
+};
+
+#endif	/* _ISM_H */
-- 
2.25.1

