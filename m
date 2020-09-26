Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0998727987A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgIZKoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:44:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726311AbgIZKow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:52 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAXKFg088646;
        Sat, 26 Sep 2020 06:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=qItE09KMid1mLrmlfGYo7bIPmc3EjcXBoSw4u24+Cqc=;
 b=hEISyenQyxZqPnHbquX8BFR+jJ1sCk15bCqu7Z+yWi1i2gazXs3eFHBvmr9CLFAnEUzJ
 ZCgEZbAuFtVhtJYAja+be2r2S1oZBIc9/YQ3F8rBPnYQIdUJreLBxxjjFjbWP8Rhsnef
 67CqOHvh7MS7iCSIDy+zysotA843Xop5eIBD7UTTZdEwxUx2uD71Z+LLsZse5r2b1g3d
 bAlStWukTgITU3Sr4irj+1qCCmntrhE9p29bmVt87yucPjA9LykqpC/9F8oOvdlBcmbg
 iFAIc3bfKC69nN1yujQmSYjRy4mGz+/Vu7nDui50zB6lWx95RAw/NcC2XKZq2V5qIzmG Hg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t2yyh441-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:50 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAgRAP015667;
        Sat, 26 Sep 2020 10:44:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 33svwgr52s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAijeO20250964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 042D0A4054;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD397A4060;
        Sat, 26 Sep 2020 10:44:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:44 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 01/14] net/smc: remove constant and introduce helper to check for a pnet id
Date:   Sat, 26 Sep 2020 12:44:19 +0200
Message-Id: <20200926104432.74293-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_07:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=1
 malwarescore=0 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the existing symbol _S instead of SMC_ASCII_BLANK, and introduce a
helper to check if a pnetid is set. No functional change.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_pnet.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 70684c49510e..0af5b4acca30 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -29,8 +29,6 @@
 #include "smc_ism.h"
 #include "smc_core.h"
 
-#define SMC_ASCII_BLANK 32
-
 static struct net_device *pnet_find_base_ndev(struct net_device *ndev);
 
 static const struct nla_policy smc_pnet_policy[SMC_PNETID_MAX + 1] = {
@@ -73,14 +71,22 @@ struct smc_pnetentry {
 	};
 };
 
+/* Check if the pnetid is set */
+static bool smc_pnet_is_pnetid_set(u8 *pnetid)
+{
+	if (pnetid[0] == 0 || pnetid[0] == _S)
+		return false;
+	return true;
+}
+
 /* Check if two given pnetids match */
 static bool smc_pnet_match(u8 *pnetid1, u8 *pnetid2)
 {
 	int i;
 
 	for (i = 0; i < SMC_MAX_PNETID_LEN; i++) {
-		if ((pnetid1[i] == 0 || pnetid1[i] == SMC_ASCII_BLANK) &&
-		    (pnetid2[i] == 0 || pnetid2[i] == SMC_ASCII_BLANK))
+		if ((pnetid1[i] == 0 || pnetid1[i] == _S) &&
+		    (pnetid2[i] == 0 || pnetid2[i] == _S))
 			break;
 		if (pnetid1[i] != pnetid2[i])
 			return false;
@@ -238,11 +244,10 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 static bool smc_pnet_apply_ib(struct smc_ib_device *ib_dev, u8 ib_port,
 			      char *pnet_name)
 {
-	u8 pnet_null[SMC_MAX_PNETID_LEN] = {0};
 	bool applied = false;
 
 	mutex_lock(&smc_ib_devices.mutex);
-	if (smc_pnet_match(ib_dev->pnetid[ib_port - 1], pnet_null)) {
+	if (!smc_pnet_is_pnetid_set(ib_dev->pnetid[ib_port - 1])) {
 		memcpy(ib_dev->pnetid[ib_port - 1], pnet_name,
 		       SMC_MAX_PNETID_LEN);
 		ib_dev->pnetid_by_user[ib_port - 1] = true;
@@ -256,11 +261,10 @@ static bool smc_pnet_apply_ib(struct smc_ib_device *ib_dev, u8 ib_port,
  */
 static bool smc_pnet_apply_smcd(struct smcd_dev *smcd_dev, char *pnet_name)
 {
-	u8 pnet_null[SMC_MAX_PNETID_LEN] = {0};
 	bool applied = false;
 
 	mutex_lock(&smcd_dev_list.mutex);
-	if (smc_pnet_match(smcd_dev->pnetid, pnet_null)) {
+	if (!smc_pnet_is_pnetid_set(smcd_dev->pnetid)) {
 		memcpy(smcd_dev->pnetid, pnet_name, SMC_MAX_PNETID_LEN);
 		smcd_dev->pnetid_by_user = true;
 		applied = true;
-- 
2.17.1

