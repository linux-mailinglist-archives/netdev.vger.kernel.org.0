Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945332A41C8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgKCK0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:26:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57928 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728147AbgKCKZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:25:57 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3A2qDg149833;
        Tue, 3 Nov 2020 05:25:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=GXYYG5W/z64twXT5jsWbsX3F6v3+7ExKhA4tiagpNYk=;
 b=oIGN7BxpoMaumtPy6yCGOr1S2mcCCEVaOalJiYKaGIC0ibKSylEjrbON+iQUZKSpLmDc
 d+zixxOS6SPiVT94DQbUa/emWUVn+Xq5WGCwodaRsJp4tKYW4vU4MreO+772pw9FHOgJ
 q7QKZbElyT6eU9ILGlA8YqgAgRUYVffDkTcagTU5Jz3YBbeTAjCKa0yDMbjk75Q+I671
 BE29Bcfi6/AVOyBQr0R/nkYslLSrVC6MO34oClitYpMEoOs/PzgaNNE18QM315xqk9XC
 8XFyFulsTQ2q9PD+xVFpNXfhbJVD/6W6eFva6+EUC0XH7ebkvJziXQW2zdk+h4RybyF0 og== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34k4ntse4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 05:25:55 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3ANUZY001593;
        Tue, 3 Nov 2020 10:25:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 34hm6habw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 10:25:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3APouc8061652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 10:25:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 737BAA4054;
        Tue,  3 Nov 2020 10:25:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BCCDA405C;
        Tue,  3 Nov 2020 10:25:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 10:25:50 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v2 14/15] net/smc: Refactor smc ism v2 capability handling
Date:   Tue,  3 Nov 2020 11:25:30 +0100
Message-Id: <20201103102531.91710-15-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201103102531.91710-1-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_07:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030066
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
 net/smc/smc_ism.c |  9 ++++++++-
 net/smc/smc_ism.h |  5 ++---
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index bc3e45289771..850e6df47a59 100644
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
@@ -1354,7 +1354,7 @@ static int smc_listen_v2_check(struct smc_sock *new_smc,
 		rc = SMC_CLC_DECL_PEERNOSMC;
 		goto out;
 	}
-	if (!smc_ism_v2_capable) {
+	if (!smc_ism_is_v2_capable()) {
 		ini->smcd_version &= ~SMC_V2;
 		rc = SMC_CLC_DECL_NOISM2SUPP;
 		goto out;
@@ -1680,7 +1680,7 @@ static void smc_listen_work(struct work_struct *work)
 {
 	struct smc_sock *new_smc = container_of(work, struct smc_sock,
 						smc_listen_work);
-	u8 version = smc_ism_v2_capable ? SMC_V2 : SMC_V1;
+	u8 version = smc_ism_is_v2_capable() ? SMC_V2 : SMC_V1;
 	struct socket *newclcsock = new_smc->clcsock;
 	struct smc_clc_msg_accept_confirm *cclc;
 	struct smc_clc_msg_proposal_area *buf;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 5bb2c7fb4ea8..2a2571637bc6 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -22,7 +22,7 @@ struct smcd_dev_list smcd_dev_list = {
 };
 EXPORT_SYMBOL_GPL(smcd_dev_list);
 
-bool smc_ism_v2_capable;
+static bool smc_ism_v2_capable;
 
 /* Test if an ISM communication is possible - same CPC */
 int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *smcd)
@@ -53,6 +53,13 @@ u16 smc_ism_get_chid(struct smcd_dev *smcd)
 }
 EXPORT_SYMBOL_GPL(smc_ism_get_chid);
 
+/* HW supports ISM V2 and thus System EID is defined */
+bool smc_ism_is_v2_capable(void)
+{
+	return smc_ism_v2_capable;
+}
+EXPORT_SYMBOL_GPL(smc_ism_is_v2_capable);
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

