Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D344FF404
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfKPQrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:47:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727743AbfKPQrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 11:47:46 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAGGl44Y122707
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 11:47:45 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wad9tttb4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 11:47:45 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Sat, 16 Nov 2019 16:47:43 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 16 Nov 2019 16:47:41 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAGGld4159113700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Nov 2019 16:47:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3F2EA404D;
        Sat, 16 Nov 2019 16:47:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E9F7A4053;
        Sat, 16 Nov 2019 16:47:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 16 Nov 2019 16:47:39 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 1/4] net/smc: introduce bookkeeping of SMCR link groups
Date:   Sat, 16 Nov 2019 17:47:29 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191116164732.47059-1-kgraul@linux.ibm.com>
References: <20191116164732.47059-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111616-0020-0000-0000-000003875D87
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111616-0021-0000-0000-000021DD7DCA
Message-Id: <20191116164732.47059-2-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-16_05:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=3 malwarescore=0 spamscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911160156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

If the smc module is unloaded return control from exit routine only,
if all link groups are freed.
If an IB device is thrown away return control from device removal only,
if all link groups belonging to this device are freed.
Counters for the total number of SMCR link groups and for the total
number of SMCR links per IB device are introduced. smc module unloading
continues only if the total number of SMCR link groups is zero. IB device
removal continues only it the total number of SMCR links per IB device
has decreased to zero.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 18 +++++++++++++-----
 net/smc/smc_core.c | 25 +++++++++++++++++++++++++
 net/smc/smc_core.h |  1 +
 net/smc/smc_ib.c   |  4 +++-
 net/smc/smc_ib.h   |  3 +++
 5 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b7d9fd285c71..42b7fb8ab22b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2038,22 +2038,28 @@ static int __init smc_init(void)
 	if (rc)
 		goto out_pernet_subsys;
 
+	rc = smc_core_init();
+	if (rc) {
+		pr_err("%s: smc_core_init fails with %d\n", __func__, rc);
+		goto out_pnet;
+	}
+
 	rc = smc_llc_init();
 	if (rc) {
 		pr_err("%s: smc_llc_init fails with %d\n", __func__, rc);
-		goto out_pnet;
+		goto out_core;
 	}
 
 	rc = smc_cdc_init();
 	if (rc) {
 		pr_err("%s: smc_cdc_init fails with %d\n", __func__, rc);
-		goto out_pnet;
+		goto out_core;
 	}
 
 	rc = proto_register(&smc_proto, 1);
 	if (rc) {
 		pr_err("%s: proto_register(v4) fails with %d\n", __func__, rc);
-		goto out_pnet;
+		goto out_core;
 	}
 
 	rc = proto_register(&smc_proto6, 1);
@@ -2085,6 +2091,8 @@ static int __init smc_init(void)
 	proto_unregister(&smc_proto6);
 out_proto:
 	proto_unregister(&smc_proto);
+out_core:
+	smc_core_exit();
 out_pnet:
 	smc_pnet_exit();
 out_pernet_subsys:
@@ -2095,10 +2103,10 @@ static int __init smc_init(void)
 
 static void __exit smc_exit(void)
 {
-	smc_core_exit();
 	static_branch_disable(&tcp_have_smc);
-	smc_ib_unregister_client();
 	sock_unregister(PF_SMC);
+	smc_core_exit();
+	smc_ib_unregister_client();
 	proto_unregister(&smc_proto6);
 	proto_unregister(&smc_proto);
 	smc_pnet_exit();
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 97e9d21c4d1e..cf34b9d96595 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -13,6 +13,7 @@
 #include <linux/if_vlan.h>
 #include <linux/random.h>
 #include <linux/workqueue.h>
+#include <linux/wait.h>
 #include <net/tcp.h>
 #include <net/sock.h>
 #include <rdma/ib_verbs.h>
@@ -39,6 +40,9 @@ static struct smc_lgr_list smc_lgr_list = {	/* established link groups */
 	.num = 0,
 };
 
+static atomic_t lgr_cnt;		/* number of existing link groups */
+static DECLARE_WAIT_QUEUE_HEAD(lgrs_deleted);
+
 static void smc_buf_free(struct smc_link_group *lgr, bool is_rmb,
 			 struct smc_buf_desc *buf_desc);
 
@@ -319,6 +323,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		rc = smc_wr_create_link(lnk);
 		if (rc)
 			goto destroy_qp;
+		atomic_inc(&lgr_cnt);
+		atomic_inc(&ini->ib_dev->lnk_cnt);
 	}
 	smc->conn.lgr = lgr;
 	spin_lock_bh(lgr_lock);
@@ -406,6 +412,8 @@ static void smc_link_clear(struct smc_link *lnk)
 	smc_ib_destroy_queue_pair(lnk);
 	smc_ib_dealloc_protection_domain(lnk);
 	smc_wr_free_link_mem(lnk);
+	if (!atomic_dec_return(&lnk->smcibdev->lnk_cnt))
+		wake_up(&lnk->smcibdev->lnks_deleted);
 }
 
 static void smcr_buf_free(struct smc_link_group *lgr, bool is_rmb,
@@ -492,6 +500,8 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 	} else {
 		smc_link_clear(&lgr->lnk[SMC_SINGLE_LINK]);
 		put_device(&lgr->lnk[SMC_SINGLE_LINK].smcibdev->ibdev->dev);
+		if (!atomic_dec_return(&lgr_cnt))
+			wake_up(&lgrs_deleted);
 	}
 	kfree(lgr);
 }
@@ -729,6 +739,15 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 		list_del_init(&lgr->list);
 		__smc_lgr_terminate(lgr, false);
 	}
+
+	if (smcibdev) {
+		if (atomic_read(&smcibdev->lnk_cnt))
+			wait_event(smcibdev->lnks_deleted,
+				   !atomic_read(&smcibdev->lnk_cnt));
+	} else {
+		if (atomic_read(&lgr_cnt))
+			wait_event(lgrs_deleted, !atomic_read(&lgr_cnt));
+	}
 }
 
 /* Determine vlan of internal TCP socket.
@@ -1263,6 +1282,12 @@ static void smc_lgrs_shutdown(void)
 	spin_unlock(&smcd_dev_list.lock);
 }
 
+int __init smc_core_init(void)
+{
+	atomic_set(&lgr_cnt, 0);
+	return 0;
+}
+
 /* Called (from smc_exit) when module is removed */
 void smc_core_exit(void)
 {
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index a428db6cd2e2..c472e12951d1 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -318,6 +318,7 @@ void smc_conn_free(struct smc_connection *conn);
 int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini);
 void smcd_conn_free(struct smc_connection *conn);
 void smc_lgr_schedule_free_work_fast(struct smc_link_group *lgr);
+int smc_core_init(void);
 void smc_core_exit(void);
 
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 0ab122e66328..548632621f4b 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -15,6 +15,7 @@
 #include <linux/random.h>
 #include <linux/workqueue.h>
 #include <linux/scatterlist.h>
+#include <linux/wait.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
 
@@ -543,7 +544,8 @@ static void smc_ib_add_dev(struct ib_device *ibdev)
 
 	smcibdev->ibdev = ibdev;
 	INIT_WORK(&smcibdev->port_event_work, smc_ib_port_event_work);
-
+	atomic_set(&smcibdev->lnk_cnt, 0);
+	init_waitqueue_head(&smcibdev->lnks_deleted);
 	spin_lock(&smc_ib_devices.lock);
 	list_add_tail(&smcibdev->list, &smc_ib_devices.list);
 	spin_unlock(&smc_ib_devices.lock);
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 6a0069db6cae..255db87547d3 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -14,6 +14,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/if_ether.h>
+#include <linux/wait.h>
 #include <rdma/ib_verbs.h>
 #include <net/smc.h>
 
@@ -48,6 +49,8 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	struct work_struct	port_event_work;
 	unsigned long		port_event_mask;
 	DECLARE_BITMAP(ports_going_away, SMC_MAX_PORTS);
+	atomic_t		lnk_cnt;	/* number of links on ibdev */
+	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all links*/
 };
 
 struct smc_buf_desc;
-- 
2.17.1

