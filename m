Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7BB2AA52C
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgKGNAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:00:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727608AbgKGNAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:00:17 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CV4Qa193779;
        Sat, 7 Nov 2020 08:00:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jH0ru1sOStMONkfOivl+0K7qUdFjXPqKLQb+LkVa5U0=;
 b=LbWyKdwjx1hmSbHMtnygnHC+mnGQPf9Cyq9D54cBaHdjY8hDQLvEjq66EidnbXIKgK8l
 V/1jKV5fAsqz27S0mIDFIANJsYPnzRO25ahK5P9fOllDNbKLJhLhcCTk0NBPSIx7h5Rf
 qz43QvHog+K3lhAU5zcrpM0riKI7I4iCagGx7vGd9/uOMlaVrvUHpmHyL7lK1N10NH3t
 TvjFm24W1fIuvGeyWmEX0AQPLvjlNpIaP5fAkBVqZvI/OFNx7U5YYOQMFGRQec93wR9V
 Q3xnWv2K0NKtAGcCBn/ocfszFA1kc4LEifDsDwyXg0ehJ9GZmCetXDEApTl33My68cZ/ cw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34np2vr29y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 08:00:14 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CvZ3i021210;
        Sat, 7 Nov 2020 13:00:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 34njuh0b1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 13:00:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A7D0Al91770226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 7 Nov 2020 13:00:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA51DA405D;
        Sat,  7 Nov 2020 13:00:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A44CCA404D;
        Sat,  7 Nov 2020 13:00:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  7 Nov 2020 13:00:08 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v3 04/15] net/smc: Add link counters for IB device ports
Date:   Sat,  7 Nov 2020 13:59:47 +0100
Message-Id: <20201107125958.16384-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107125958.16384-1-kgraul@linux.ibm.com>
References: <20201107125958.16384-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-07_07:2020-11-05,2020-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 impostorscore=0
 suspectscore=0 mlxlogscore=-1000 spamscore=100 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 phishscore=0 mlxscore=100 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011070081
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
 net/smc/smc_core.c |  3 +++
 net/smc/smc_core.h | 10 ++++++++++
 net/smc/smc_ib.h   |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 6e2077161267..e5996cf5dd3d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -316,6 +316,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->link_idx = link_idx;
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
+	smc_ibdev_cnt_inc(lnk);
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
 	atomic_set(&lnk->conn_cnt, 0);
 	smc_llc_link_set_uid(lnk);
@@ -359,6 +360,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 clear_llc_lnk:
 	smc_llc_link_clear(lnk, false);
 out:
+	smc_ibdev_cnt_dec(lnk);
 	put_device(&ini->ib_dev->ibdev->dev);
 	memset(lnk, 0, sizeof(struct smc_link));
 	lnk->state = SMC_LNK_UNUSED;
@@ -749,6 +751,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
 	smc_ib_destroy_queue_pair(lnk);
 	smc_ib_dealloc_protection_domain(lnk);
 	smc_wr_free_link_mem(lnk);
+	smc_ibdev_cnt_dec(lnk);
 	put_device(&lnk->smcibdev->ibdev->dev);
 	smcibdev = lnk->smcibdev;
 	memset(lnk, 0, sizeof(struct smc_link));
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 83a88a4635db..4cf8e811940d 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -364,6 +364,16 @@ static inline bool smc_link_active(struct smc_link *lnk)
 	return lnk->state == SMC_LNK_ACTIVE;
 }
 
+static inline void smc_ibdev_cnt_inc(struct smc_link *lnk)
+{
+	atomic_inc(&lnk->smcibdev->lnk_cnt_by_port[lnk->ibport - 1]);
+}
+
+static inline void smc_ibdev_cnt_dec(struct smc_link *lnk)
+{
+	atomic_dec(&lnk->smcibdev->lnk_cnt_by_port[lnk->ibport - 1]);
+}
+
 struct smc_sock;
 struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
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

