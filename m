Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3876F1C111F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgEAKsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50582 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728623AbgEAKsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:32 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AWBE5108241;
        Fri, 1 May 2020 06:48:30 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r82sp7jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:30 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041Ak6lt026483;
        Fri, 1 May 2020 10:48:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5vh5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AmPcX36175910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:48:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4525A405C;
        Fri,  1 May 2020 10:48:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 881A0A4062;
        Fri,  1 May 2020 10:48:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:25 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 11/13] net/smc: introduce smc_pnet_find_alt_roce()
Date:   Fri,  1 May 2020 12:48:11 +0200
Message-Id: <20200501104813.76601-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_02:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 clxscore=1015
 spamscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=986 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new function in smc_pnet.c that searches for an alternate
IB device, using an existing link group and a primary IB device. The
alternate IB device needs to be active and must have the same PNETID
as the link group.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_pnet.c | 15 +++++++++++++--
 net/smc/smc_pnet.h |  5 ++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index bd01c71b827a..50c96e843fab 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -777,7 +777,8 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 
 /* find a roce device for the given pnetid */
 static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
-					  struct smc_init_info *ini)
+					  struct smc_init_info *ini,
+					  struct smc_ib_device *known_dev)
 {
 	struct smc_ib_device *ibdev;
 	int i;
@@ -785,6 +786,8 @@ static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
 	ini->ib_dev = NULL;
 	spin_lock(&smc_ib_devices.lock);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
+		if (ibdev == known_dev)
+			continue;
 		for (i = 1; i <= SMC_MAX_PORTS; i++) {
 			if (!rdma_is_port_valid(ibdev->ibdev, i))
 				continue;
@@ -803,6 +806,14 @@ static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
 	spin_unlock(&smc_ib_devices.lock);
 }
 
+/* find alternate roce device with same pnet_id and vlan_id */
+void smc_pnet_find_alt_roce(struct smc_link_group *lgr,
+			    struct smc_init_info *ini,
+			    struct smc_ib_device *known_dev)
+{
+	_smc_pnet_find_roce_by_pnetid(lgr->pnet_id, ini, known_dev);
+}
+
 /* if handshake network device belongs to a roce device, return its
  * IB device and port
  */
@@ -857,7 +868,7 @@ static void smc_pnet_find_roce_by_pnetid(struct net_device *ndev,
 		smc_pnet_find_rdma_dev(ndev, ini);
 		return; /* pnetid could not be determined */
 	}
-	_smc_pnet_find_roce_by_pnetid(ndev_pnetid, ini);
+	_smc_pnet_find_roce_by_pnetid(ndev_pnetid, ini, NULL);
 }
 
 static void smc_pnet_find_ism_by_pnetid(struct net_device *ndev,
diff --git a/net/smc/smc_pnet.h b/net/smc/smc_pnet.h
index ea207f8fc6f7..811a65986691 100644
--- a/net/smc/smc_pnet.h
+++ b/net/smc/smc_pnet.h
@@ -19,6 +19,7 @@
 struct smc_ib_device;
 struct smcd_dev;
 struct smc_init_info;
+struct smc_link_group;
 
 /**
  * struct smc_pnettable - SMC PNET table anchor
@@ -48,5 +49,7 @@ void smc_pnet_find_roce_resource(struct sock *sk, struct smc_init_info *ini);
 void smc_pnet_find_ism_resource(struct sock *sk, struct smc_init_info *ini);
 int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port);
 int smc_pnetid_by_table_smcd(struct smcd_dev *smcd);
-
+void smc_pnet_find_alt_roce(struct smc_link_group *lgr,
+			    struct smc_init_info *ini,
+			    struct smc_ib_device *known_dev);
 #endif
-- 
2.17.1

