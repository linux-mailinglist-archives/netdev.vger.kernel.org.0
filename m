Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637DD281626
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388222AbgJBPJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:09:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387893AbgJBPJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:09:41 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092F34HJ004153;
        Fri, 2 Oct 2020 11:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=t0EHLLyR2+IWFrOZB/abguo1Td4X1ULIAOb0mZ0qWSU=;
 b=LBMl1iUaNtlgSqCGbBoBFyBmRpdKkkb1SQHAWqcg1eSQS9O7aa+i/yZCbyocikkFonYz
 gmibcxZUmL6BkNoSkTNgng0JdGq5zK3r5eRC7vlDNjaHfdMbwS/ReISVTdFKMDpJQ3r5
 7GzfqjBH/6755zVrhzbGTOaMt6aDb5WG3Nj9rFYtITEYF7krR8mE9I0qoH6QzGRNP2Gk
 SkDlEpjhahGV3nQY9eS8ywF/jbKP1d+wcMhA2eGd+Ug0lH1Doee0b+4myXoPGQzXAv+o
 /7DkwHq0NiDthysmfoOUqJDzzUawdEJjJxuY2MnKo9goaF9b0vRXA2OwtVU44Vq3nkXW 0Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x5ry9x38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:09:39 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092F2HNu001603;
        Fri, 2 Oct 2020 15:09:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 33v6mgu8a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:09:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092F9Xg523003532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:09:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B21D1A4040;
        Fri,  2 Oct 2020 15:09:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73C07A4053;
        Fri,  2 Oct 2020 15:09:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:09:33 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 1/2] net/smc: send ISM devices with unique chid in CLC proposal
Date:   Fri,  2 Oct 2020 17:09:26 +0200
Message-Id: <20201002150927.72261-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002150927.72261-1-kgraul@linux.ibm.com>
References: <20201002150927.72261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building a CLC proposal message then the list of ISM devices does
not need to contain multiple devices that have the same chid value,
all these devices use the same function at the end.
Improve smc_find_ism_v2_device_clnt() to collect only ISM devices that
have unique chid values.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e874d0e6267f..670e802a73cb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -599,6 +599,18 @@ static int smc_find_ism_device(struct smc_sock *smc, struct smc_init_info *ini)
 	return 0;
 }
 
+/* is chid unique for the ism devices that are already determined? */
+static bool smc_find_ism_v2_is_unique_chid(u16 chid, struct smc_init_info *ini,
+					   int cnt)
+{
+	int i = (!ini->ism_dev[0]) ? 1 : 0;
+
+	for (; i < cnt; i++)
+		if (ini->ism_chid[i] == chid)
+			return false;
+	return true;
+}
+
 /* determine possible V2 ISM devices (either without PNETID or with PNETID plus
  * PNETID matching net_device)
  */
@@ -608,6 +620,7 @@ static int smc_find_ism_v2_device_clnt(struct smc_sock *smc,
 	int rc = SMC_CLC_DECL_NOSMCDDEV;
 	struct smcd_dev *smcd;
 	int i = 1;
+	u16 chid;
 
 	if (smcd_indicated(ini->smc_type_v1))
 		rc = 0;		/* already initialized for V1 */
@@ -615,10 +628,13 @@ static int smc_find_ism_v2_device_clnt(struct smc_sock *smc,
 	list_for_each_entry(smcd, &smcd_dev_list.list, list) {
 		if (smcd->going_away || smcd == ini->ism_dev[0])
 			continue;
+		chid = smc_ism_get_chid(smcd);
+		if (!smc_find_ism_v2_is_unique_chid(chid, ini, i))
+			continue;
 		if (!smc_pnet_is_pnetid_set(smcd->pnetid) ||
 		    smc_pnet_is_ndev_pnetid(sock_net(&smc->sk), smcd->pnetid)) {
 			ini->ism_dev[i] = smcd;
-			ini->ism_chid[i] = smc_ism_get_chid(ini->ism_dev[i]);
+			ini->ism_chid[i] = chid;
 			ini->is_smcd = true;
 			rc = 0;
 			i++;
-- 
2.17.1

