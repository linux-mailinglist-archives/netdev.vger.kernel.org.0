Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77B7218AC3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgGHPFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:05:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729921AbgGHPF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:05:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068F1wGg007931;
        Wed, 8 Jul 2020 11:05:22 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3259yxdh9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 11:05:22 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068EtEa0019584;
        Wed, 8 Jul 2020 15:05:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3251dw0dyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 15:05:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068F5I5822479100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 15:05:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0BBDAE04D;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAB7CAE05A;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 3/5] net/smc: fix sleep bug in smc_pnet_find_roce_resource()
Date:   Wed,  8 Jul 2020 17:05:13 +0200
Message-Id: <20200708150515.44938-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708150515.44938-1-kgraul@linux.ibm.com>
References: <20200708150515.44938-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_13:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 clxscore=1011 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 mlxscore=0 cotscore=-2147483648
 malwarescore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080103
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

Tests showed this BUG:
[572555.252867] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:935
[572555.252876] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 131031, name: smcapp
[572555.252879] INFO: lockdep is turned off.
[572555.252883] CPU: 1 PID: 131031 Comm: smcapp Tainted: G           O      5.7.0-rc3uschi+ #356
[572555.252885] Hardware name: IBM 3906 M03 703 (LPAR)
[572555.252887] Call Trace:
[572555.252896]  [<00000000ac364554>] show_stack+0x94/0xe8
[572555.252901]  [<00000000aca1f400>] dump_stack+0xa0/0xe0
[572555.252906]  [<00000000ac3c8c10>] ___might_sleep+0x260/0x280
[572555.252910]  [<00000000acdc0c98>] __mutex_lock+0x48/0x940
[572555.252912]  [<00000000acdc15c2>] mutex_lock_nested+0x32/0x40
[572555.252975]  [<000003ff801762d0>] mlx5_lag_get_roce_netdev+0x30/0xc0 [mlx5_core]
[572555.252996]  [<000003ff801fb3aa>] mlx5_ib_get_netdev+0x3a/0xe0 [mlx5_ib]
[572555.253007]  [<000003ff80063848>] smc_pnet_find_roce_resource+0x1d8/0x310 [smc]
[572555.253011]  [<000003ff800602f0>] __smc_connect+0x1f0/0x3e0 [smc]
[572555.253015]  [<000003ff80060634>] smc_connect+0x154/0x190 [smc]
[572555.253022]  [<00000000acbed8d4>] __sys_connect+0x94/0xd0
[572555.253025]  [<00000000acbef620>] __s390x_sys_socketcall+0x170/0x360
[572555.253028]  [<00000000acdc6800>] system_call+0x298/0x2b8
[572555.253030] INFO: lockdep is turned off.

Function smc_pnet_find_rdma_dev() might be called from
smc_pnet_find_roce_resource(). It holds the smc_ib_devices list
spinlock while calling infiniband op get_netdev(). At least for mlx5
the get_netdev operation wants mutex serialization, which conflicts
with the smc_ib_devices spinlock.
This patch switches the smc_ib_devices spinlock into a mutex to
allow sleeping when calling get_netdev().

Fixes: a4cf0443c414 ("smc: introduce SMC as an IB-client")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c |  5 +++--
 net/smc/smc_ib.c   | 11 ++++++-----
 net/smc/smc_ib.h   |  3 ++-
 net/smc/smc_pnet.c | 21 +++++++++++----------
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d695ce71837e..8bf34d9f27e5 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -15,6 +15,7 @@
 #include <linux/workqueue.h>
 #include <linux/wait.h>
 #include <linux/reboot.h>
+#include <linux/mutex.h>
 #include <net/tcp.h>
 #include <net/sock.h>
 #include <rdma/ib_verbs.h>
@@ -1961,14 +1962,14 @@ static void smc_core_going_away(void)
 	struct smc_ib_device *smcibdev;
 	struct smcd_dev *smcd;
 
-	spin_lock(&smc_ib_devices.lock);
+	mutex_lock(&smc_ib_devices.mutex);
 	list_for_each_entry(smcibdev, &smc_ib_devices.list, list) {
 		int i;
 
 		for (i = 0; i < SMC_MAX_PORTS; i++)
 			set_bit(i, smcibdev->ports_going_away);
 	}
-	spin_unlock(&smc_ib_devices.lock);
+	mutex_unlock(&smc_ib_devices.mutex);
 
 	spin_lock(&smcd_dev_list.lock);
 	list_for_each_entry(smcd, &smcd_dev_list.list, list) {
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 562a52d01ad1..7637fdebbb78 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -16,6 +16,7 @@
 #include <linux/workqueue.h>
 #include <linux/scatterlist.h>
 #include <linux/wait.h>
+#include <linux/mutex.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
 
@@ -33,7 +34,7 @@
 #define SMC_QP_RNR_RETRY			7 /* 7: infinite */
 
 struct smc_ib_devices smc_ib_devices = {	/* smc-registered ib devices */
-	.lock = __SPIN_LOCK_UNLOCKED(smc_ib_devices.lock),
+	.mutex = __MUTEX_INITIALIZER(smc_ib_devices.mutex),
 	.list = LIST_HEAD_INIT(smc_ib_devices.list),
 };
 
@@ -565,9 +566,9 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
 	INIT_WORK(&smcibdev->port_event_work, smc_ib_port_event_work);
 	atomic_set(&smcibdev->lnk_cnt, 0);
 	init_waitqueue_head(&smcibdev->lnks_deleted);
-	spin_lock(&smc_ib_devices.lock);
+	mutex_lock(&smc_ib_devices.mutex);
 	list_add_tail(&smcibdev->list, &smc_ib_devices.list);
-	spin_unlock(&smc_ib_devices.lock);
+	mutex_unlock(&smc_ib_devices.mutex);
 	ib_set_client_data(ibdev, &smc_ib_client, smcibdev);
 	INIT_IB_EVENT_HANDLER(&smcibdev->event_handler, smcibdev->ibdev,
 			      smc_ib_global_event_handler);
@@ -602,9 +603,9 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
 {
 	struct smc_ib_device *smcibdev = client_data;
 
-	spin_lock(&smc_ib_devices.lock);
+	mutex_lock(&smc_ib_devices.mutex);
 	list_del_init(&smcibdev->list); /* remove from smc_ib_devices */
-	spin_unlock(&smc_ib_devices.lock);
+	mutex_unlock(&smc_ib_devices.mutex);
 	pr_warn_ratelimited("smc: removing ib device %s\n",
 			    smcibdev->ibdev->name);
 	smc_smcr_terminate_all(smcibdev);
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index e6a696ae15f3..ae6776e1e726 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -14,6 +14,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/if_ether.h>
+#include <linux/mutex.h>
 #include <linux/wait.h>
 #include <rdma/ib_verbs.h>
 #include <net/smc.h>
@@ -25,7 +26,7 @@
 
 struct smc_ib_devices {			/* list of smc ib devices definition */
 	struct list_head	list;
-	spinlock_t		lock;	/* protects list of smc ib devices */
+	struct mutex		mutex;	/* protects list of smc ib devices */
 };
 
 extern struct smc_ib_devices	smc_ib_devices; /* list of smc ib devices */
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 014d91b9778e..d4aac31d39f5 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/ctype.h>
+#include <linux/mutex.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
@@ -129,7 +130,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 		return rc;
 
 	/* remove ib devices */
-	spin_lock(&smc_ib_devices.lock);
+	mutex_lock(&smc_ib_devices.mutex);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
 		for (ibport = 0; ibport < SMC_MAX_PORTS; ibport++) {
 			if (ibdev->pnetid_by_user[ibport] &&
@@ -149,7 +150,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 			}
 		}
 	}
-	spin_unlock(&smc_ib_devices.lock);
+	mutex_unlock(&smc_ib_devices.mutex);
 	/* remove smcd devices */
 	spin_lock(&smcd_dev_list.lock);
 	list_for_each_entry(smcd_dev, &smcd_dev_list.list, list) {
@@ -240,14 +241,14 @@ static bool smc_pnet_apply_ib(struct smc_ib_device *ib_dev, u8 ib_port,
 	u8 pnet_null[SMC_MAX_PNETID_LEN] = {0};
 	bool applied = false;
 
-	spin_lock(&smc_ib_devices.lock);
+	mutex_lock(&smc_ib_devices.mutex);
 	if (smc_pnet_match(ib_dev->pnetid[ib_port - 1], pnet_null)) {
 		memcpy(ib_dev->pnetid[ib_port - 1], pnet_name,
 		       SMC_MAX_PNETID_LEN);
 		ib_dev->pnetid_by_user[ib_port - 1] = true;
 		applied = true;
 	}
-	spin_unlock(&smc_ib_devices.lock);
+	mutex_unlock(&smc_ib_devices.mutex);
 	return applied;
 }
 
@@ -300,7 +301,7 @@ static struct smc_ib_device *smc_pnet_find_ib(char *ib_name)
 {
 	struct smc_ib_device *ibdev;
 
-	spin_lock(&smc_ib_devices.lock);
+	mutex_lock(&smc_ib_devices.mutex);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
 		if (!strncmp(ibdev->ibdev->name, ib_name,
 			     sizeof(ibdev->ibdev->name)) ||
@@ -311,7 +312,7 @@ static struct smc_ib_device *smc_pnet_find_ib(char *ib_name)
 	}
 	ibdev = NULL;
 out:
-	spin_unlock(&smc_ib_devices.lock);
+	mutex_unlock(&smc_ib_devices.mutex);
 	return ibdev;
 }
 
@@ -825,7 +826,7 @@ static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
 	int i;
 
 	ini->ib_dev = NULL;
-	spin_lock(&smc_ib_devices.lock);
+	mutex_lock(&smc_ib_devices.mutex);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
 		if (ibdev == known_dev)
 			continue;
@@ -844,7 +845,7 @@ static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
 		}
 	}
 out:
-	spin_unlock(&smc_ib_devices.lock);
+	mutex_unlock(&smc_ib_devices.mutex);
 }
 
 /* find alternate roce device with same pnet_id and vlan_id */
@@ -863,7 +864,7 @@ static void smc_pnet_find_rdma_dev(struct net_device *netdev,
 {
 	struct smc_ib_device *ibdev;
 
-	spin_lock(&smc_ib_devices.lock);
+	mutex_lock(&smc_ib_devices.mutex);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
 		struct net_device *ndev;
 		int i;
@@ -888,7 +889,7 @@ static void smc_pnet_find_rdma_dev(struct net_device *netdev,
 			}
 		}
 	}
-	spin_unlock(&smc_ib_devices.lock);
+	mutex_unlock(&smc_ib_devices.mutex);
 }
 
 /* Determine the corresponding IB device port based on the hardware PNETID.
-- 
2.17.1

