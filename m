Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7CE279881
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgIZKpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgIZKox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:53 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAVp6U131760;
        Sat, 26 Sep 2020 06:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=gpZhqx0eOOF7UznAv69vhu2iZmBeKtDj395AVdLhx9M=;
 b=Y7G/7SRaNsq1iLLQVi1gE2MxTmMNewHm5EdogibbOmQ6oU4+BthrKKxvblgihs7AAx24
 cnqGKrTnHczN4gww2hZNnB8qhBqHOxJtGo27izPOx2L8cRG2wDgjuoqaik1T87+lhbvd
 P5qhgEmydqTFkHOMBpXxGnBfU8ZDI6Y9EuerwCTxQHaAXeu/k6u+TqLnYsG/wMQjC1Qd
 0qSj9Myvgjvhz+btohd50cM/LUHYECHnhrmPC7mmd2bE3K849QgdHqzFrPNkGuHiErwh
 vxu+QX1G/JRndLwoSE1g9oG24vLAESQFW7koxn5hOF34sXsSTrHlPtTVaU7HrTiLpmeA XA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t2dmhs0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:51 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAgxWP011689;
        Sat, 26 Sep 2020 10:44:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97r986-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAikuH29098390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF10EA4054;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 950BBA405C;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 07/14] net/smc: introduce CHID callback for ISM devices
Date:   Sat, 26 Sep 2020 12:44:25 +0200
Message-Id: <20200926104432.74293-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

With SMCD version 2 the CHIDs of ISM devices are needed for the
CLC handshake.
This patch provides the new callback to retrieve the CHID of an
ISM device.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 12 ++++++++++++
 include/net/smc.h          |  1 +
 net/smc/af_smc.c           |  2 ++
 net/smc/smc_core.h         |  1 +
 net/smc/smc_ism.c          |  5 +++++
 net/smc/smc_ism.h          |  1 +
 6 files changed, 22 insertions(+)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index c452ea5d9c8a..fe96ca3c88a5 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -414,6 +414,17 @@ static void ism_get_system_eid(struct smcd_dev *smcd, u8 **eid)
 	*eid = &SYSTEM_EID.seid_string[0];
 }
 
+static u16 ism_get_chid(struct smcd_dev *smcd)
+{
+	struct ism_dev *ismdev;
+
+	ismdev = (struct ism_dev *)smcd->priv;
+	if (!ismdev || !ismdev->pdev)
+		return 0;
+
+	return to_zpci(ismdev->pdev)->pchid;
+}
+
 static void ism_handle_event(struct ism_dev *ism)
 {
 	struct smcd_event *entry;
@@ -471,6 +482,7 @@ static const struct smcd_ops ism_ops = {
 	.signal_event = ism_signal_ieq,
 	.move_data = ism_move,
 	.get_system_eid = ism_get_system_eid,
+	.get_chid = ism_get_chid,
 };
 
 static int ism_dev_init(struct ism_dev *ism)
diff --git a/include/net/smc.h b/include/net/smc.h
index b28b384d0625..e441aa97ad61 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -66,6 +66,7 @@ struct smcd_ops {
 			 bool sf, unsigned int offset, void *data,
 			 unsigned int size);
 	void (*get_system_eid)(struct smcd_dev *dev, u8 **eid);
+	u16 (*get_chid)(struct smcd_dev *dev);
 };
 
 struct smcd_dev {
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8c1cde36adb8..f02ed74a28e6 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -566,6 +566,8 @@ static int smc_find_ism_device(struct smc_sock *smc, struct smc_init_info *ini)
 	smc_pnet_find_ism_resource(smc->clcsock->sk, ini);
 	if (!ini->ism_dev[0])
 		return SMC_CLC_DECL_NOSMCDDEV;
+	else
+		ini->ism_chid[0] = smc_ism_get_chid(ini->ism_dev[0]);
 	return 0;
 }
 
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index ec86084b0dfd..d33bcbc3238f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -303,6 +303,7 @@ struct smc_init_info {
 	/* SMC-D */
 	u64			ism_peer_gid[SMC_MAX_ISM_DEVS + 1];
 	struct smcd_dev		*ism_dev[SMC_MAX_ISM_DEVS + 1];
+	u16			ism_chid[SMC_MAX_ISM_DEVS + 1];
 };
 
 /* Find the connection associated with the given alert token in the link group.
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 63c3dd5578bf..c5a5b70251b6 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -46,6 +46,11 @@ void smc_ism_get_system_eid(struct smcd_dev *smcd, u8 **eid)
 	smcd->ops->get_system_eid(smcd, eid);
 }
 
+u16 smc_ism_get_chid(struct smcd_dev *smcd)
+{
+	return smcd->ops->get_chid(smcd);
+}
+
 /* Set a connection using this DMBE. */
 void smc_ism_set_conn(struct smc_connection *conn)
 {
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 816d86361e1a..8048e09ddcf8 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -51,5 +51,6 @@ int smc_ism_write(struct smcd_dev *dev, const struct smc_ism_position *pos,
 		  void *data, size_t len);
 int smc_ism_signal_shutdown(struct smc_link_group *lgr);
 void smc_ism_get_system_eid(struct smcd_dev *dev, u8 **eid);
+u16 smc_ism_get_chid(struct smcd_dev *dev);
 void smc_ism_init(void);
 #endif
-- 
2.17.1

