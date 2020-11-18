Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C978D2B86F6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgKRVmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 16:42:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgKRVmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 16:42:08 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIL2Wp6029915;
        Wed, 18 Nov 2020 16:42:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=7P9w9bG8ZAw6HExENAKCWFv8ThdsPfVLbnUtQUTFf0U=;
 b=OGHNHYJ4GEpsL1leD1AMcqoyPlKpe1wh5iL3kmsk1d1PbB5NIpIUaCei2rSJGR2qS0Da
 Tv4I518JYvo+Iz5uF9Q1ZxG5oFa5vLSU2QptbNgkaTXJ2JY+sBWYkUJT8mBae5sj6Yjq
 uc6MCY96JFGT5fERU32Q37wKXpQnJEM4/j9vo2TasQSmZnKR+9egMhBZ9VKpEzaS9bcP
 804ObqFVPgZbVqQ1rV9+43pJFsKycyy22BVC0teSHuW2QxMiQC3E2WXGoqXpVXaSEMMk
 IRy18aIDVUH+rJ1x4g4o8Bg/3owd8sp9pO0u6cb9zOGKvWPc7qVwL+KG/CYk/oTbHxgE Ig== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w8prng9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 16:42:07 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AILbM5e005412;
        Wed, 18 Nov 2020 21:42:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 34t6v8axxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 21:42:04 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AILelim26738966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 21:40:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C8584203F;
        Wed, 18 Nov 2020 21:40:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C97F742041;
        Wed, 18 Nov 2020 21:40:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Nov 2020 21:40:46 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net 1/2] net/smc: fix matching of existing link groups
Date:   Wed, 18 Nov 2020 22:40:37 +0100
Message-Id: <20201118214038.24039-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201118214038.24039-1-kgraul@linux.ibm.com>
References: <20201118214038.24039-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_08:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=1 phishscore=0 mlxscore=0 mlxlogscore=832 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the multi-subnet support of SMC-Dv2 the match for existing link
groups should not include the vlanid of the network device.
Set ini->smcd_version accordingly before the call to smc_conn_create()
and use this value in smc_conn_create() to skip the vlanid check.

Fixes: 5c21c4ccafe8 ("net/smc: determine accepted ISM devices")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 3 ++-
 net/smc/smc_core.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f487c8c6d5..5dd4faaf7d6e 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -979,7 +979,8 @@ static int __smc_connect(struct smc_sock *smc)
 
 	/* check if smc modes and versions of CLC proposal and accept match */
 	rc = smc_connect_check_aclc(ini, aclc);
-	version = aclc->hdr.version == SMC_V1 ? SMC_V1 : version;
+	version = aclc->hdr.version == SMC_V1 ? SMC_V1 : SMC_V2;
+	ini->smcd_version = version;
 	if (rc)
 		goto vlan_cleanup;
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 2b19863f7171..af96f813c075 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1309,7 +1309,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 				    ini->ism_peer_gid[ini->ism_selected]) :
 		     smcr_lgr_match(lgr, ini->ib_lcl, role, ini->ib_clcqpn)) &&
 		    !lgr->sync_err &&
-		    lgr->vlan_id == ini->vlan_id &&
+		    (ini->smcd_version == SMC_V2 ||
+		     lgr->vlan_id == ini->vlan_id) &&
 		    (role == SMC_CLNT || ini->is_smcd ||
 		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
 			/* link group found */
-- 
2.17.1

