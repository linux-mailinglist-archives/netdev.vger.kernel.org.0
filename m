Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F149CD226C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 10:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733253AbfJJIQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:16:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733238AbfJJIQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 04:16:31 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9A8D7ET001993
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 04:16:31 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vhy6bkd9x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 04:16:30 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 10 Oct 2019 09:16:28 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 10 Oct 2019 09:16:25 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9A8FrUB38797596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 08:15:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7F165204E;
        Thu, 10 Oct 2019 08:16:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A1E0852052;
        Thu, 10 Oct 2019 08:16:23 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH v2 net 1/3] net/smc: fix SMCD link group creation with VLAN id
Date:   Thu, 10 Oct 2019 10:16:09 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191010081611.35446-1-kgraul@linux.ibm.com>
References: <20191010081611.35446-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19101008-0012-0000-0000-00000356C8C4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101008-0013-0000-0000-00002191D0AE
Message-Id: <20191010081611.35446-2-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=825 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910100077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

If creation of an SMCD link group with VLAN id fails, the initial
smc_ism_get_vlan() step has to be reverted as well.

Fixes: c6ba7c9ba43d ("net/smc: add base infrastructure for SMC-D and ISM")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 4ca50ddf8d16..88556f0251ab 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -213,7 +213,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	lgr = kzalloc(sizeof(*lgr), GFP_KERNEL);
 	if (!lgr) {
 		rc = SMC_CLC_DECL_MEM;
-		goto out;
+		goto ism_put_vlan;
 	}
 	lgr->is_smcd = ini->is_smcd;
 	lgr->sync_err = 0;
@@ -289,6 +289,9 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	smc_llc_link_clear(lnk);
 free_lgr:
 	kfree(lgr);
+ism_put_vlan:
+	if (ini->is_smcd && ini->vlan_id)
+		smc_ism_put_vlan(ini->ism_dev, ini->vlan_id);
 out:
 	if (rc < 0) {
 		if (rc == -ENOMEM)
-- 
2.17.1

