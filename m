Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718462869BB
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgJGU6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:58:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728613AbgJGU6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 16:58:00 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097KVuKf050022;
        Wed, 7 Oct 2020 16:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=yhh+Y9v/JCR/uvPDCqNhT/8coyWYfD9DDsj4+WZykB0=;
 b=GXBFMRYv7bblCK3MycheTk97INcYucflRIFPgP1j/eEcr9piQqm3+aZyUw8mUs9qijsD
 G2UVqTQod+Yvn6WQuOGtscHFDriBKMgUA30lvKTA3jbTBTkiCFGjpvkiuABUj5sTSD6M
 2+RlU9dfLu0If/7lhvW9XpJn3PJFs6RP+J5VExU0oM59kdVcFIh0NMUmpzbYKTAfq/9T
 +1+1xzqYom60NLBSU/7LDw+C0kixEO2+r60Z32z8zoRGGiEO9Zv0fuVhsXV5pHKPTSnh
 RSHOja1jhBgL3+h3GuujqGJWBviY9bu0seXoCohsxGVSOSyk6v6Cy9OzaJHCuunT0LId sA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341kvna4j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 16:57:57 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097KulWV032754;
        Wed, 7 Oct 2020 20:57:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 33xgjhadmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 20:57:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097KvqGF24707502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 20:57:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F020AE045;
        Wed,  7 Oct 2020 20:57:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 133C9AE04D;
        Wed,  7 Oct 2020 20:57:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 20:57:52 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 3/3] net/smc: restore smcd_version when all ISM V2 devices failed to init
Date:   Wed,  7 Oct 2020 22:57:43 +0200
Message-Id: <20201007205743.83535-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201007205743.83535-1-kgraul@linux.ibm.com>
References: <20201007205743.83535-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 impostorscore=0 suspectscore=1 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010070127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Field ini->smcd_version is set to SMC_V2 before calling
smc_listen_ism_init(). This clears the V1 bit that may be set. When all
matching ISM V2 devices fail to initialize then the smcd_version field
needs to get restored to allow any possible V1 devices to initialize.
And be consistent, always go to the not_found label when no device was
found.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f481f0ed2b78..82be0bd0f6e8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1481,11 +1481,12 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	struct smc_clc_v2_extension *smc_v2_ext;
 	struct smc_clc_msg_smcd *pclc_smcd;
 	unsigned int matches = 0;
+	u8 smcd_version;
 	u8 *eid = NULL;
 	int i;
 
 	if (!(ini->smcd_version & SMC_V2) || !smcd_indicated(ini->smc_type_v2))
-		return;
+		goto not_found;
 
 	pclc_smcd = smc_get_clc_msg_smcd(pclc);
 	smc_v2_ext = smc_get_clc_v2_ext(pclc);
@@ -1519,6 +1520,7 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	}
 
 	/* separate - outside the smcd_dev_list.lock */
+	smcd_version = ini->smcd_version;
 	for (i = 0; i < matches; i++) {
 		ini->smcd_version = SMC_V2;
 		ini->is_smcd = true;
@@ -1528,6 +1530,8 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 			continue;
 		return; /* matching and usable V2 ISM device found */
 	}
+	/* no V2 ISM device could be initialized */
+	ini->smcd_version = smcd_version;	/* restore original value */
 
 not_found:
 	ini->smcd_version &= ~SMC_V2;
-- 
2.17.1

