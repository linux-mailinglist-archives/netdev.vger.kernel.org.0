Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D42B2CABC0
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404324AbgLATV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731223AbgLATVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:45 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J5cwi009128;
        Tue, 1 Dec 2020 14:21:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jDCaiCwvw+nmkSQCw2Ei5Gdvdudsgqb5negAz6P3+Sg=;
 b=HYSMUhi9PVfIXbPCnJPtpnwy5EtE4ebZzddM2o2Q4W5TxekNslMEZYeS8Y1CSN46L8N1
 wFhxuHg+qGZ7H0tLFdvQwuteqKzPYd/1fbbPIoQWQbqjJgZDzdUhvqS2qTwbwosHfclI
 q3b5hSQVa5R6HdRKk6HweNTTejr5AX0geAyIVEq8zzPAPks+8ykeq3++CQLlKLfct/z+
 fsqNBt9774L3Yaswkkk1PQvSKCjLVhnMaFn1/etRPnymoQwJbyC2JX6cXvBQz9Tx3nCj
 DqgCJVp6OrPHjs4JjzyXf4o9HJ7slPx8TJn+XDWKx6VSgswMhvzdarDDYOeD8v5uiCKY lQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 355jt77hk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:21:01 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JI9kw018316;
        Tue, 1 Dec 2020 19:20:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 353e683etu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:20:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKuks53150112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE5EBAE045;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 749C5AE04D;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v7 04/14] net/smc: Add link counters for IB device ports
Date:   Tue,  1 Dec 2020 20:20:39 +0100
Message-Id: <20201201192049.53517-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=2 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Add link counters to the structure of the smc ib device, one counter per
ib port. Increase/decrease the counters as needed in the corresponding
routines.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 13 +++++++++++++
 net/smc/smc_ib.h   |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 5bc8ebcd03f3..46087cec3bcd 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -63,6 +63,16 @@ static inline struct list_head *smc_lgr_list_head(struct smc_link_group *lgr,
 	return &smc_lgr_list.list;
 }
 
+static void smc_ibdev_cnt_inc(struct smc_link *lnk)
+{
+	atomic_inc(&lnk->smcibdev->lnk_cnt_by_port[lnk->ibport - 1]);
+}
+
+static void smc_ibdev_cnt_dec(struct smc_link *lnk)
+{
+	atomic_dec(&lnk->smcibdev->lnk_cnt_by_port[lnk->ibport - 1]);
+}
+
 static void smc_lgr_schedule_free_work(struct smc_link_group *lgr)
 {
 	/* client link group creation always follows the server link group
@@ -316,6 +326,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->link_idx = link_idx;
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
+	smc_ibdev_cnt_inc(lnk);
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
 	atomic_set(&lnk->conn_cnt, 0);
 	smc_llc_link_set_uid(lnk);
@@ -359,6 +370,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 clear_llc_lnk:
 	smc_llc_link_clear(lnk, false);
 out:
+	smc_ibdev_cnt_dec(lnk);
 	put_device(&ini->ib_dev->ibdev->dev);
 	memset(lnk, 0, sizeof(struct smc_link));
 	lnk->state = SMC_LNK_UNUSED;
@@ -749,6 +761,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
 	smc_ib_destroy_queue_pair(lnk);
 	smc_ib_dealloc_protection_domain(lnk);
 	smc_wr_free_link_mem(lnk);
+	smc_ibdev_cnt_dec(lnk);
 	put_device(&lnk->smcibdev->ibdev->dev);
 	smcibdev = lnk->smcibdev;
 	memset(lnk, 0, sizeof(struct smc_link));
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 2ce481187dd0..3b85360a473b 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -53,6 +53,8 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	atomic_t		lnk_cnt;	/* number of links on ibdev */
 	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all links*/
 	struct mutex		mutex;		/* protect dev setup+cleanup */
+	atomic_t		lnk_cnt_by_port[SMC_MAX_PORTS];
+						/* number of links per port */
 };
 
 struct smc_buf_desc;
-- 
2.17.1

