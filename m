Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E08D0931
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfJIIIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:08:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729983AbfJIIIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:08:00 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9987Qc8138687
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 04:07:59 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vhbekrnth-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 04:07:59 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Wed, 9 Oct 2019 09:07:57 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 9 Oct 2019 09:07:54 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9987rwW51511544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Oct 2019 08:07:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F282DA4064;
        Wed,  9 Oct 2019 08:07:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B330AA4060;
        Wed,  9 Oct 2019 08:07:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Oct 2019 08:07:52 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 3/5] net/smc: increase device refcount for added link group
Date:   Wed,  9 Oct 2019 10:07:45 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009080747.95516-1-kgraul@linux.ibm.com>
References: <20191009080747.95516-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19100908-0012-0000-0000-000003566065
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100908-0013-0000-0000-00002191647A
Message-Id: <20191009080747.95516-4-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-09_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910090076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMCD link groups belong to certain ISM-devices and SMCR link group
links belong to certain IB-devices. Increase the refcount for
these devices, as long as corresponding link groups exist.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 96d3150d4d1c..a12ec621b54c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -248,12 +248,14 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	lgr->conns_all = RB_ROOT;
 	if (ini->is_smcd) {
 		/* SMC-D specific settings */
+		get_device(&ini->ism_dev->dev);
 		lgr->peer_gid = ini->ism_gid;
 		lgr->smcd = ini->ism_dev;
 		lgr_list = &ini->ism_dev->lgr_list;
 		lgr_lock = &lgr->smcd->lgr_lock;
 	} else {
 		/* SMC-R specific settings */
+		get_device(&ini->ib_dev->ibdev->dev);
 		lgr->role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
 		memcpy(lgr->peer_systemid, ini->ib_lcl->id_for_peer,
 		       SMC_SYSTEMID_LEN);
@@ -451,10 +453,13 @@ static void smc_lgr_free_bufs(struct smc_link_group *lgr)
 static void smc_lgr_free(struct smc_link_group *lgr)
 {
 	smc_lgr_free_bufs(lgr);
-	if (lgr->is_smcd)
+	if (lgr->is_smcd) {
 		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
-	else
+		put_device(&lgr->smcd->dev);
+	} else {
 		smc_link_clear(&lgr->lnk[SMC_SINGLE_LINK]);
+		put_device(&lgr->lnk[SMC_SINGLE_LINK].smcibdev->ibdev->dev);
+	}
 	kfree(lgr);
 }
 
-- 
2.17.1

