Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E3F66BA4A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjAPJ1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjAPJ1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:27:30 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC86B16331;
        Mon, 16 Jan 2023 01:27:29 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30G8hxlZ031192;
        Mon, 16 Jan 2023 09:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FUBkLCVrXq0V5HEt8zhEPA0jrDtMBtTTJGtr83LAbPg=;
 b=FM7+Q2LnrzFsVT0c0yGHESAkDBAnxgdtC/ZhQM3BNXqfNNRNKkmxjr8GVfMz69uQPt8y
 h/zdR3Z3OcTzh/eT1fV4RIdUSwtArcV1GOszoeLZMFvUvITtVEwCUkwP57akQ9Uh5GMl
 opaX+l1gb1WV7TX0/NFidw/ZZHagmFmS3eCtUvy7NRTJXz/t4AAe0qXYcj8NHOiGgYt4
 wOWVcGuDH3dnAWhYwtt207dvoE1BdQ1xg5mDcE95Fhi4hZhYgWv86BplYUvjrhRvKd/f
 DNF1PVfp6Wbudjkj6oXcrG/ufjFpPJQQHGg2duv96k1Wir2ejMASWJVWb9auqg1XpSWa gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n53b0152h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:23 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30G8vLFM026282;
        Mon, 16 Jan 2023 09:27:23 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n53b0151w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:22 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30FASiOp004582;
        Mon, 16 Jan 2023 09:27:20 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n3m169jwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30G9RHhA53281098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 09:27:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 167172004B;
        Mon, 16 Jan 2023 09:27:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 916E820063;
        Mon, 16 Jan 2023 09:27:16 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.177.79])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 09:27:16 +0000 (GMT)
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
Subject: [net-next 3/8] s390/ism: Introduce struct ism_dmb
Date:   Mon, 16 Jan 2023 10:27:07 +0100
Message-Id: <20230116092712.10176-4-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116092712.10176-1-jaka@linux.ibm.com>
References: <20230116092712.10176-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YBCUbVCbuvTNpu6u_19hD7iNNV53ugW7
X-Proofpoint-ORIG-GUID: 5H8ttyR8WDYdSW0cVlgJWTbnBhfrsy8y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_06,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=797 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

