Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C98279886
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgIZKpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1532 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726948AbgIZKoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:54 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAXKte088611;
        Sat, 26 Sep 2020 06:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ObYIrsTI/+8NrQn2WAGN7jbncCbMF/vXDRUMP09mVos=;
 b=MWAR71se2TCs8Ow4kYeGIJZ6Dhx10Y4ujsEUDRL9lthqUFCiTqL8sKGZEiSSwSZ4l8f+
 AbrwtgDWE6qONKcG2dAWtWVpeW8w0awAZTyde+RZHgqzYzvxYOXt77OGnbYOcmryrmmM
 lUi2BjMvdWdjlt0M00TlZiLBXP/86+j6m4/dzL2EIQ9ZsuTk0Ae4gLlWyJ3ZA4C7S0D1
 uBSvhFm9oNdJpB1gjP/Y4l+0KtMPFx/3kX9JokRlxLYFRr8YabHBk3vHF2Q5giPnSP24
 tVX2MH29elnme0KaP+4+io6W3zN+AgcY0afqXwdnP/MOG+DrGwDAU5ySBk7bSsgslW3v qQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t2yyh447-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:51 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAg7G9004361;
        Sat, 26 Sep 2020 10:44:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 33t16k01xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAikgT18874828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88FC8A4054;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E003A405B;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 06/14] net/smc: introduce System Enterprise ID (SEID)
Date:   Sat, 26 Sep 2020 12:44:24 +0200
Message-Id: <20200926104432.74293-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_07:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=3
 malwarescore=0 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMCD version 2 defines a System Enterprise ID (short SEID).
This patch contains the SEID creation and adds the callback to
retrieve the created SEID.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/ism.h     |  7 +++++++
 drivers/s390/net/ism_drv.c | 35 +++++++++++++++++++++++++++++++++++
 include/net/smc.h          |  3 +++
 net/smc/af_smc.c           |  2 ++
 net/smc/smc_ism.c          | 21 ++++++++++++++++++++-
 net/smc/smc_ism.h          |  7 ++++++-
 6 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/ism.h b/drivers/s390/net/ism.h
index 1901e9c80ed8..38fe90c2597d 100644
--- a/drivers/s390/net/ism.h
+++ b/drivers/s390/net/ism.h
@@ -16,6 +16,7 @@
 #define ISM_DMB_WORD_OFFSET	1
 #define ISM_DMB_BIT_OFFSET	(ISM_DMB_WORD_OFFSET * 32)
 #define ISM_NR_DMBS		1920
+#define ISM_IDENT_MASK		0x00FFFF
 
 #define ISM_REG_SBA	0x1
 #define ISM_REG_IEQ	0x2
@@ -206,6 +207,12 @@ struct ism_dev {
 #define ISM_CREATE_REQ(dmb, idx, sf, offset)		\
 	((dmb) | (idx) << 24 | (sf) << 23 | (offset))
 
+struct ism_systemeid {
+	u8	seid_string[24];
+	u8	serial_number[4];
+	u8	type[4];
+};
+
 static inline void __ism_read_cmd(struct ism_dev *ism, void *data,
 				  unsigned long offset, unsigned long len)
 {
diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 5fbe9eae84d1..c452ea5d9c8a 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -13,6 +13,8 @@
 #include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/err.h>
+#include <linux/ctype.h>
+#include <linux/processor.h>
 #include <net/smc.h>
 
 #include <asm/debug.h>
@@ -387,6 +389,31 @@ static int ism_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
 	return 0;
 }
 
+static struct ism_systemeid SYSTEM_EID = {
+	.seid_string = "IBM-SYSZ-IBMSEID00000000",
+	.serial_number = "0000",
+	.type = "0000",
+};
+
+static void ism_create_system_eid(void)
+{
+	struct cpuid id;
+	u16 ident_tail;
+	char tmp[5];
+
+	get_cpu_id(&id);
+	ident_tail = (u16)(id.ident & ISM_IDENT_MASK);
+	snprintf(tmp, 5, "%04X", ident_tail);
+	memcpy(&SYSTEM_EID.serial_number, tmp, 4);
+	snprintf(tmp, 5, "%04X", id.machine);
+	memcpy(&SYSTEM_EID.type, tmp, 4);
+}
+
+static void ism_get_system_eid(struct smcd_dev *smcd, u8 **eid)
+{
+	*eid = &SYSTEM_EID.seid_string[0];
+}
+
 static void ism_handle_event(struct ism_dev *ism)
 {
 	struct smcd_event *entry;
@@ -443,6 +470,7 @@ static const struct smcd_ops ism_ops = {
 	.reset_vlan_required = ism_reset_vlan_required,
 	.signal_event = ism_signal_ieq,
 	.move_data = ism_move,
+	.get_system_eid = ism_get_system_eid,
 };
 
 static int ism_dev_init(struct ism_dev *ism)
@@ -471,6 +499,10 @@ static int ism_dev_init(struct ism_dev *ism)
 	if (ret)
 		goto unreg_ieq;
 
+	if (!ism_add_vlan_id(ism->smcd, ISM_RESERVED_VLANID))
+		/* hardware is V2 capable */
+		ism_create_system_eid();
+
 	ret = smcd_register_dev(ism->smcd);
 	if (ret)
 		goto unreg_ieq;
@@ -550,6 +582,9 @@ static void ism_dev_exit(struct ism_dev *ism)
 	struct pci_dev *pdev = ism->pdev;
 
 	smcd_unregister_dev(ism->smcd);
+	if (SYSTEM_EID.serial_number[0] != '0' ||
+	    SYSTEM_EID.type[0] != '0')
+		ism_del_vlan_id(ism->smcd, ISM_RESERVED_VLANID);
 	unregister_ieq(ism);
 	unregister_sba(ism);
 	free_irq(pci_irq_vector(pdev, 0), ism);
diff --git a/include/net/smc.h b/include/net/smc.h
index 646feb4bc75f..b28b384d0625 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -37,6 +37,8 @@ struct smcd_dmb {
 #define ISM_EVENT_GID	1
 #define ISM_EVENT_SWR	2
 
+#define ISM_RESERVED_VLANID	0x1FFF
+
 #define ISM_ERROR	0xFFFF
 
 struct smcd_event {
@@ -63,6 +65,7 @@ struct smcd_ops {
 	int (*move_data)(struct smcd_dev *dev, u64 dmb_tok, unsigned int idx,
 			 bool sf, unsigned int offset, void *data,
 			 unsigned int size);
+	void (*get_system_eid)(struct smcd_dev *dev, u8 **eid);
 };
 
 struct smcd_dev {
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index dc0049b25bd9..8c1cde36adb8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2137,6 +2137,8 @@ static int __init smc_init(void)
 	if (rc)
 		return rc;
 
+	smc_ism_init();
+
 	rc = smc_pnet_init();
 	if (rc)
 		goto out_pernet_subsys;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 998c525de785..63c3dd5578bf 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -21,7 +21,9 @@ struct smcd_dev_list smcd_dev_list = {
 	.mutex = __MUTEX_INITIALIZER(smcd_dev_list.mutex)
 };
 
-/* Test if an ISM communication is possible. */
+bool smc_ism_v2_capable;
+
+/* Test if an ISM communication is possible - same CPC */
 int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *smcd)
 {
 	return smcd->ops->query_remote_gid(smcd, peer_gid, vlan_id ? 1 : 0,
@@ -39,6 +41,11 @@ int smc_ism_write(struct smcd_dev *smcd, const struct smc_ism_position *pos,
 	return rc < 0 ? rc : 0;
 }
 
+void smc_ism_get_system_eid(struct smcd_dev *smcd, u8 **eid)
+{
+	smcd->ops->get_system_eid(smcd, eid);
+}
+
 /* Set a connection using this DMBE. */
 void smc_ism_set_conn(struct smc_connection *conn)
 {
@@ -319,6 +326,13 @@ EXPORT_SYMBOL_GPL(smcd_alloc_dev);
 int smcd_register_dev(struct smcd_dev *smcd)
 {
 	mutex_lock(&smcd_dev_list.mutex);
+	if (list_empty(&smcd_dev_list.list)) {
+		u8 *system_eid = NULL;
+
+		smc_ism_get_system_eid(smcd, &system_eid);
+		if ((*system_eid) + 24 != '0' || (*system_eid) + 28 != '0')
+			smc_ism_v2_capable = true;
+	}
 	list_add_tail(&smcd->list, &smcd_dev_list.list);
 	mutex_unlock(&smcd_dev_list.mutex);
 
@@ -399,3 +413,8 @@ void smcd_handle_irq(struct smcd_dev *smcd, unsigned int dmbno)
 	spin_unlock_irqrestore(&smcd->lock, flags);
 }
 EXPORT_SYMBOL_GPL(smcd_handle_irq);
+
+void __init smc_ism_init(void)
+{
+	smc_ism_v2_capable = false;
+}
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 81cc4537efd3..816d86361e1a 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -19,7 +19,10 @@ struct smcd_dev_list {	/* List of SMCD devices */
 	struct mutex mutex;	/* Protects list of devices */
 };
 
-extern struct smcd_dev_list	smcd_dev_list; /* list of smcd devices */
+extern struct smcd_dev_list	smcd_dev_list;	/* list of smcd devices */
+extern bool	smc_ism_v2_capable;	/* HW supports ISM V2 and thus
+					 * System EID is defined
+					 */
 
 struct smc_ism_vlanid {			/* VLAN id set on ISM device */
 	struct list_head list;
@@ -47,4 +50,6 @@ int smc_ism_unregister_dmb(struct smcd_dev *dev, struct smc_buf_desc *dmb_desc);
 int smc_ism_write(struct smcd_dev *dev, const struct smc_ism_position *pos,
 		  void *data, size_t len);
 int smc_ism_signal_shutdown(struct smc_link_group *lgr);
+void smc_ism_get_system_eid(struct smcd_dev *dev, u8 **eid);
+void smc_ism_init(void);
 #endif
-- 
2.17.1

