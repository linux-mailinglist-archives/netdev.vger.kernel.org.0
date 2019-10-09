Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA6CD092D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbfJIIIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:08:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729918AbfJIIH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:07:59 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9987MNq112199
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 04:07:58 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vha4ck7g7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 04:07:57 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Wed, 9 Oct 2019 09:07:56 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 9 Oct 2019 09:07:54 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9987MlR16777474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Oct 2019 08:07:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DC86A4069;
        Wed,  9 Oct 2019 08:07:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19321A405C;
        Wed,  9 Oct 2019 08:07:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Oct 2019 08:07:52 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 1/5] net/smc: separate SMCD and SMCR link group lists
Date:   Wed,  9 Oct 2019 10:07:43 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009080747.95516-1-kgraul@linux.ibm.com>
References: <20191009080747.95516-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19100908-0028-0000-0000-000003A85D25
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100908-0029-0000-0000-0000246A60B7
Message-Id: <20191009080747.95516-2-kgraul@linux.ibm.com>
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

Currently SMCD and SMCR link groups are maintained in one list.
To facilitate abnormal termination handling they are split into
a separate list for SMCR link groups and separate lists for SMCD
link groups per SMCD device.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/net/smc.h  |  1 +
 net/smc/smc_core.c | 24 +++++++++++++++++-------
 net/smc/smc_ism.c  |  1 +
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/net/smc.h b/include/net/smc.h
index bd9c0fb3b577..c08e8c415673 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -75,6 +75,7 @@ struct smcd_dev {
 	struct workqueue_struct *event_wq;
 	u8 pnetid[SMC_MAX_PNETID_LEN];
 	bool pnetid_by_user;
+	struct list_head lgr_list;
 };
 
 struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 2d2850adc2a3..92612978d783 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -198,6 +198,7 @@ static void smc_lgr_free_work(struct work_struct *work)
 static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 {
 	struct smc_link_group *lgr;
+	struct list_head *lgr_list;
 	struct smc_link *lnk;
 	u8 rndvec[3];
 	int rc = 0;
@@ -233,6 +234,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		/* SMC-D specific settings */
 		lgr->peer_gid = ini->ism_gid;
 		lgr->smcd = ini->ism_dev;
+		lgr_list = &ini->ism_dev->lgr_list;
 	} else {
 		/* SMC-R specific settings */
 		lgr->role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
@@ -245,6 +247,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lnk->link_id = SMC_SINGLE_LINK;
 		lnk->smcibdev = ini->ib_dev;
 		lnk->ibport = ini->ib_port;
+		lgr_list = &smc_lgr_list.list;
 		lnk->path_mtu =
 			ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
 		if (!ini->ib_dev->initialized)
@@ -275,7 +278,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	}
 	smc->conn.lgr = lgr;
 	spin_lock_bh(&smc_lgr_list.lock);
-	list_add(&lgr->list, &smc_lgr_list.list);
+	list_add(&lgr->list, lgr_list);
 	spin_unlock_bh(&smc_lgr_list.lock);
 	return 0;
 
@@ -512,9 +515,8 @@ void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid, unsigned short vlan)
 
 	/* run common cleanup function and build free list */
 	spin_lock_bh(&smc_lgr_list.lock);
-	list_for_each_entry_safe(lgr, l, &smc_lgr_list.list, list) {
-		if (lgr->is_smcd && lgr->smcd == dev &&
-		    (!peer_gid || lgr->peer_gid == peer_gid) &&
+	list_for_each_entry_safe(lgr, l, &dev->lgr_list, list) {
+		if ((!peer_gid || lgr->peer_gid == peer_gid) &&
 		    (vlan == VLAN_VID_MASK || lgr->vlan_id == vlan)) {
 			__smc_lgr_terminate(lgr);
 			list_move(&lgr->list, &lgr_free_list);
@@ -604,10 +606,12 @@ static bool smcd_lgr_match(struct smc_link_group *lgr,
 int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 {
 	struct smc_connection *conn = &smc->conn;
+	struct list_head *lgr_list;
 	struct smc_link_group *lgr;
 	enum smc_lgr_role role;
 	int rc = 0;
 
+	lgr_list = ini->is_smcd ? &ini->ism_dev->lgr_list : &smc_lgr_list.list;
 	ini->cln_first_contact = SMC_FIRST_CONTACT;
 	role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
 	if (role == SMC_CLNT && ini->srv_first_contact)
@@ -616,7 +620,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 
 	/* determine if an existing link group can be reused */
 	spin_lock_bh(&smc_lgr_list.lock);
-	list_for_each_entry(lgr, &smc_lgr_list.list, list) {
+	list_for_each_entry(lgr, lgr_list, list) {
 		write_lock_bh(&lgr->conns_lock);
 		if ((ini->is_smcd ?
 		     smcd_lgr_match(lgr, ini->ism_dev, ini->ism_gid) :
@@ -1026,11 +1030,17 @@ void smc_core_exit(void)
 {
 	struct smc_link_group *lgr, *lg;
 	LIST_HEAD(lgr_freeing_list);
+	struct smcd_dev *smcd;
 
 	spin_lock_bh(&smc_lgr_list.lock);
-	if (!list_empty(&smc_lgr_list.list))
-		list_splice_init(&smc_lgr_list.list, &lgr_freeing_list);
+	list_splice_init(&smc_lgr_list.list, &lgr_freeing_list);
 	spin_unlock_bh(&smc_lgr_list.lock);
+
+	spin_lock(&smcd_dev_list.lock);
+	list_for_each_entry(smcd, &smcd_dev_list.list, list)
+		list_splice_init(&smcd->lgr_list, &lgr_freeing_list);
+	spin_unlock(&smcd_dev_list.lock);
+
 	list_for_each_entry_safe(lgr, lg, &lgr_freeing_list, list) {
 		list_del_init(&lgr->list);
 		if (!lgr->is_smcd) {
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index e89e918b88e0..674eb5ae2320 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -287,6 +287,7 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 
 	spin_lock_init(&smcd->lock);
 	INIT_LIST_HEAD(&smcd->vlan);
+	INIT_LIST_HEAD(&smcd->lgr_list);
 	smcd->event_wq = alloc_ordered_workqueue("ism_evt_wq-%s)",
 						 WQ_MEM_RECLAIM, name);
 	if (!smcd->event_wq) {
-- 
2.17.1

