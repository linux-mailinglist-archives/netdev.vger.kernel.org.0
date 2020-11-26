Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E5D2C5D35
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 21:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391522AbgKZUmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 15:42:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391431AbgKZUmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 15:42:01 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKYFYh019683;
        Thu, 26 Nov 2020 15:41:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=btU64YZMlfBupi2PAU8bk1pdlvTby4GSm9PUxmSR3iQ=;
 b=gmFKDUnCv/kpjxW42bhiVqGD6HjGevThMytqj22vIvARauauzaKm3q4QMEJkmnuPUQK3
 QF2HqeHI/32Db9lalmOjEEnjBsNBOrvdw0R6DXj2IpkO9jkKR/DzRgR3w8+beSjK/Tew
 RHbVzRprT/ZYNg0RZfQxorSa5wFKfZCBDC7r8+fJC1Pql3Z8VupCNK/+XehsVlOBwIbS
 o5Jp2ddMELnZnAH10XcW9GKT+RZgF4yx6tzTIg8oFGJ3yqDIQHs8WXoofTU0KH6NNjXq
 nzBx5HCKxEaqVj+vhJiA9i9r1Y1yd5LV6N72s1rObjsQ/LmH54F56xRjc0UOiNWhDWTe pQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352jvm8vca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 15:41:59 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKWM5P025345;
        Thu, 26 Nov 2020 20:41:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 352jgsg28c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 20:41:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQKdOSf1704548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 20:39:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A8D3A4051;
        Thu, 26 Nov 2020 20:39:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45607A404D;
        Thu, 26 Nov 2020 20:39:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 20:39:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v6 07/14] net/smc: Refactor smc ism v2 capability handling
Date:   Thu, 26 Nov 2020 21:39:09 +0100
Message-Id: <20201126203916.56071-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201126203916.56071-1-kgraul@linux.ibm.com>
References: <20201126203916.56071-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_09:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260128
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Encapsulate the smc ism v2 capability boolean value
in a function for better information hiding.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c  | 12 ++++++------
 net/smc/smc_ism.c |  8 +++++++-
 net/smc/smc_ism.h |  5 ++---
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 13db3f260e94..f79b59a972f0 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -668,7 +668,7 @@ static int smc_find_proposal_devices(struct smc_sock *smc,
 				ini->smc_type_v1 = SMC_TYPE_N;
 		} /* else RDMA is supported for this connection */
 	}
-	if (smc_ism_v2_capable && smc_find_ism_v2_device_clnt(smc, ini))
+	if (smc_ism_is_v2_capable() && smc_find_ism_v2_device_clnt(smc, ini))
 		ini->smc_type_v2 = SMC_TYPE_N;
 
 	/* if neither ISM nor RDMA are supported, fallback */
@@ -920,7 +920,7 @@ static int smc_connect_check_aclc(struct smc_init_info *ini,
 /* perform steps before actually connecting */
 static int __smc_connect(struct smc_sock *smc)
 {
-	u8 version = smc_ism_v2_capable ? SMC_V2 : SMC_V1;
+	u8 version = smc_ism_is_v2_capable() ? SMC_V2 : SMC_V1;
 	struct smc_clc_msg_accept_confirm_v2 *aclc2;
 	struct smc_clc_msg_accept_confirm *aclc;
 	struct smc_init_info *ini = NULL;
@@ -945,9 +945,9 @@ static int __smc_connect(struct smc_sock *smc)
 						    version);
 
 	ini->smcd_version = SMC_V1;
-	ini->smcd_version |= smc_ism_v2_capable ? SMC_V2 : 0;
+	ini->smcd_version |= smc_ism_is_v2_capable() ? SMC_V2 : 0;
 	ini->smc_type_v1 = SMC_TYPE_B;
-	ini->smc_type_v2 = smc_ism_v2_capable ? SMC_TYPE_D : SMC_TYPE_N;
+	ini->smc_type_v2 = smc_ism_is_v2_capable() ? SMC_TYPE_D : SMC_TYPE_N;
 
 	/* get vlan id from IP device */
 	if (smc_vlan_by_tcpsk(smc->clcsock, ini)) {
@@ -1355,7 +1355,7 @@ static int smc_listen_v2_check(struct smc_sock *new_smc,
 		rc = SMC_CLC_DECL_PEERNOSMC;
 		goto out;
 	}
-	if (!smc_ism_v2_capable) {
+	if (!smc_ism_is_v2_capable()) {
 		ini->smcd_version &= ~SMC_V2;
 		rc = SMC_CLC_DECL_NOISM2SUPP;
 		goto out;
@@ -1681,7 +1681,7 @@ static void smc_listen_work(struct work_struct *work)
 {
 	struct smc_sock *new_smc = container_of(work, struct smc_sock,
 						smc_listen_work);
-	u8 version = smc_ism_v2_capable ? SMC_V2 : SMC_V1;
+	u8 version = smc_ism_is_v2_capable() ? SMC_V2 : SMC_V1;
 	struct socket *newclcsock = new_smc->clcsock;
 	struct smc_clc_msg_accept_confirm *cclc;
 	struct smc_clc_msg_proposal_area *buf;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 6abbdd09a580..2456ee8228cd 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -21,7 +21,7 @@ struct smcd_dev_list smcd_dev_list = {
 	.mutex = __MUTEX_INITIALIZER(smcd_dev_list.mutex)
 };
 
-bool smc_ism_v2_capable;
+static bool smc_ism_v2_capable;
 
 /* Test if an ISM communication is possible - same CPC */
 int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *smcd)
@@ -51,6 +51,12 @@ u16 smc_ism_get_chid(struct smcd_dev *smcd)
 	return smcd->ops->get_chid(smcd);
 }
 
+/* HW supports ISM V2 and thus System EID is defined */
+bool smc_ism_is_v2_capable(void)
+{
+	return smc_ism_v2_capable;
+}
+
 /* Set a connection using this DMBE. */
 void smc_ism_set_conn(struct smc_connection *conn)
 {
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 8048e09ddcf8..481a4b7df30b 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -10,6 +10,7 @@
 #define SMCD_ISM_H
 
 #include <linux/uio.h>
+#include <linux/types.h>
 #include <linux/mutex.h>
 
 #include "smc.h"
@@ -20,9 +21,6 @@ struct smcd_dev_list {	/* List of SMCD devices */
 };
 
 extern struct smcd_dev_list	smcd_dev_list;	/* list of smcd devices */
-extern bool	smc_ism_v2_capable;	/* HW supports ISM V2 and thus
-					 * System EID is defined
-					 */
 
 struct smc_ism_vlanid {			/* VLAN id set on ISM device */
 	struct list_head list;
@@ -52,5 +50,6 @@ int smc_ism_write(struct smcd_dev *dev, const struct smc_ism_position *pos,
 int smc_ism_signal_shutdown(struct smc_link_group *lgr);
 void smc_ism_get_system_eid(struct smcd_dev *dev, u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
+bool smc_ism_is_v2_capable(void);
 void smc_ism_init(void);
 #endif
-- 
2.17.1

