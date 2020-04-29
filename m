Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA5A1BE232
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgD2PLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgD2PLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:40 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF0lwc020312;
        Wed, 29 Apr 2020 11:11:38 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30pjm9my6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:38 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFB1Ga021582;
        Wed, 29 Apr 2020 15:11:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 30mcu7wu96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFAOPG53281264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:10:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DBBEAE077;
        Wed, 29 Apr 2020 15:11:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB712AE073;
        Wed, 29 Apr 2020 15:11:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 12/13] net/smc: use mutex instead of rwlock_t to protect buffers
Date:   Wed, 29 Apr 2020 17:10:48 +0200
Message-Id: <20200429151049.49979-13-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 suspectscore=3 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The locks for sndbufs and rmbs are never used from atomic context. Using
a mutex for these locks will allow to nest locks with other mutexes.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 22 +++++++++++-----------
 net/smc/smc_core.h |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a1463da14614..8a43d2948493 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -385,8 +385,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	lgr->freefast = 0;
 	lgr->freeing = 0;
 	lgr->vlan_id = ini->vlan_id;
-	rwlock_init(&lgr->sndbufs_lock);
-	rwlock_init(&lgr->rmbs_lock);
+	mutex_init(&lgr->sndbufs_lock);
+	mutex_init(&lgr->rmbs_lock);
 	rwlock_init(&lgr->conns_lock);
 	for (i = 0; i < SMC_RMBE_SIZES; i++) {
 		INIT_LIST_HEAD(&lgr->sndbufs[i]);
@@ -456,9 +456,9 @@ static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
 	}
 	if (rmb_desc->is_reg_err) {
 		/* buf registration failed, reuse not possible */
-		write_lock_bh(&lgr->rmbs_lock);
+		mutex_lock(&lgr->rmbs_lock);
 		list_del(&rmb_desc->list);
-		write_unlock_bh(&lgr->rmbs_lock);
+		mutex_unlock(&lgr->rmbs_lock);
 
 		smc_buf_free(lgr, true, rmb_desc);
 	} else {
@@ -1059,19 +1059,19 @@ int smc_uncompress_bufsize(u8 compressed)
  * buffer size; if not available, return NULL
  */
 static struct smc_buf_desc *smc_buf_get_slot(int compressed_bufsize,
-					     rwlock_t *lock,
+					     struct mutex *lock,
 					     struct list_head *buf_list)
 {
 	struct smc_buf_desc *buf_slot;
 
-	read_lock_bh(lock);
+	mutex_lock(lock);
 	list_for_each_entry(buf_slot, buf_list, list) {
 		if (cmpxchg(&buf_slot->used, 0, 1) == 0) {
-			read_unlock_bh(lock);
+			mutex_unlock(lock);
 			return buf_slot;
 		}
 	}
-	read_unlock_bh(lock);
+	mutex_unlock(lock);
 	return NULL;
 }
 
@@ -1220,8 +1220,8 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 	struct smc_link_group *lgr = conn->lgr;
 	struct list_head *buf_list;
 	int bufsize, bufsize_short;
+	struct mutex *lock;	/* lock buffer list */
 	int sk_buf_size;
-	rwlock_t *lock;
 
 	if (is_rmb)
 		/* use socket recv buffer size (w/o overhead) as start value */
@@ -1262,9 +1262,9 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 			continue;
 
 		buf_desc->used = 1;
-		write_lock_bh(lock);
+		mutex_lock(lock);
 		list_add(&buf_desc->list, buf_list);
-		write_unlock_bh(lock);
+		mutex_unlock(lock);
 		break; /* found */
 	}
 
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index d785656b3489..379ced490c49 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -205,9 +205,9 @@ struct smc_link_group {
 	unsigned short		vlan_id;	/* vlan id of link group */
 
 	struct list_head	sndbufs[SMC_RMBE_SIZES];/* tx buffers */
-	rwlock_t		sndbufs_lock;	/* protects tx buffers */
+	struct mutex		sndbufs_lock;	/* protects tx buffers */
 	struct list_head	rmbs[SMC_RMBE_SIZES];	/* rx buffers */
-	rwlock_t		rmbs_lock;	/* protects rx buffers */
+	struct mutex		rmbs_lock;	/* protects rx buffers */
 
 	u8			id[SMC_LGR_ID_SIZE];	/* unique lgr id */
 	struct delayed_work	free_work;	/* delayed freeing of an lgr */
-- 
2.17.1

