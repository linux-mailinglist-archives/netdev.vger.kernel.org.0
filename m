Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3573984B3
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhFBI60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:58:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232931AbhFBI6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:58:24 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1528XpNG100422;
        Wed, 2 Jun 2021 04:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eEZ6/jFDqI7XkcQofR9N67HgQCfh1BuRq6RQ416RZ4k=;
 b=riSt4gowJAbquAXq3Z62wVBtbqSyyT9XFNjf3VDwrJKm9SJUDB5YECrNu1kd5iclIq5L
 CSub5agBE8hbQbW2tKGJ+PDUZjLk/wWLpPz8pRIOoWPRvufnVJdaavGHB81AokLWXumd
 35oCXO/TKKEQtNru3/YoxaPEK5CH36w3+BXi1/UMbdj9ZE/wGP1KaTWr+o5EdvuuMZvM
 TEkBtSOH1SvuLDCwi2WQG7QaWR86bOpF3zUKM8H+tXWWjMk332PDrkoFQ0pSk8mksOuJ
 8TfRlRvCXBgJmBlbvUfmCCBx6oJ/5Do4BgNLaUeHQhgcVHqQTljI0ajYIb6KAFOUn5n+ vQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38x6k5gg99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 04:56:37 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1528uaBw017487;
        Wed, 2 Jun 2021 08:56:36 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 38ucvh97dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 08:56:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1528uXiZ21692842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 08:56:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7F27A4066;
        Wed,  2 Jun 2021 08:56:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9558A4064;
        Wed,  2 Jun 2021 08:56:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 08:56:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 1/2] net/smc: avoid possible duplicate dmb unregistration
Date:   Wed,  2 Jun 2021 10:56:25 +0200
Message-Id: <20210602085626.2877926-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602085626.2877926-1-kgraul@linux.ibm.com>
References: <20210602085626.2877926-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Lvdr-Ke0Vnt8602grT-pMenEy-J_2_j9
X-Proofpoint-GUID: Lvdr-Ke0Vnt8602grT-pMenEy-J_2_j9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_05:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 impostorscore=0 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smc_lgr_cleanup() calls smcd_unregister_all_dmbs() as part of the link
group termination process. This is a leftover from the times when
smc_lgr_cleanup() scheduled a worker to actually free the link group.
Nowadays smc_lgr_cleanup() directly calls smc_lgr_free() without any
delay so an earlier dmb unregistration is no longer needed.
So remove smcd_unregister_all_dmbs() and the call to it.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 0df85a12651e..317bc2c90fab 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1235,20 +1235,6 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 	kfree(lgr);
 }
 
-static void smcd_unregister_all_dmbs(struct smc_link_group *lgr)
-{
-	int i;
-
-	for (i = 0; i < SMC_RMBE_SIZES; i++) {
-		struct smc_buf_desc *buf_desc;
-
-		list_for_each_entry(buf_desc, &lgr->rmbs[i], list) {
-			buf_desc->len += sizeof(struct smcd_cdc_msg);
-			smc_ism_unregister_dmb(lgr->smcd, buf_desc);
-		}
-	}
-}
-
 static void smc_sk_wake_ups(struct smc_sock *smc)
 {
 	smc->sk.sk_write_space(&smc->sk);
@@ -1285,7 +1271,6 @@ static void smc_lgr_cleanup(struct smc_link_group *lgr)
 {
 	if (lgr->is_smcd) {
 		smc_ism_signal_shutdown(lgr);
-		smcd_unregister_all_dmbs(lgr);
 	} else {
 		u32 rsn = lgr->llc_termination_rsn;
 
-- 
2.25.1

