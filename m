Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3366427988C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgIZKp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727017AbgIZKo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:56 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAWTwT158888;
        Sat, 26 Sep 2020 06:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=+0MjIOYXRx6vZdOdvFqxFMndWDnnhLrNbhPwSl4G4qg=;
 b=VmGIPWMB1QSztMp5rpGoqevIKHWB4F/eD9aegMFW7fkjF5gzrQTb1xYwKlqBJ2ljQKSd
 qQrE4RmCqQUtfk/w2l5a/IoRvVtPmF1XAQWuKVEXQazIxacIyz1q3cHNg/UqO5S3QcyE
 S3SY2ZA97ZqDpDdHCuYnV0b6IBzuKGMbxo//pbbnUcMxm5edGCbAUFRSLUTM1vQB11bv
 7BNO9FQs8fWDovZ6W+0nDWyjxZUenaneg1d0gCn1TH4wr1t1kpfjYJEHbZ/LcetDFTvE
 K9wWNZiEnCpOmdySZc23BB1FyKbmt7kAEtL7HqfSdrmSqPsVFlbIizjxxTQtcdD2t5M/ sw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33t3xqr6jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:51 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAgvn4016081;
        Sat, 26 Sep 2020 10:44:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 33svwgr52t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAilPd29753712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A854A4054;
        Sat, 26 Sep 2020 10:44:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB1D4A405B;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 08/14] net/smc: introduce list of pnetids for Ethernet devices
Date:   Sat, 26 Sep 2020 12:44:26 +0200
Message-Id: <20200926104432.74293-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=1 bulkscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMCD version 2 allows usage of ISM devices with hardware PNETID
only, if an Ethernet net_device exists with the same hardware PNETID.
This requires to maintain a list of pnetids belonging to
Ethernet net_devices, which is covered by this patch.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_netns.h |   1 +
 net/smc/smc_pnet.c  | 145 +++++++++++++++++++++++++++++++++++++++++---
 net/smc/smc_pnet.h  |  14 +++++
 3 files changed, 153 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_netns.h b/net/smc/smc_netns.h
index e7a8fc4ae02f..0f4f35aa43ad 100644
--- a/net/smc/smc_netns.h
+++ b/net/smc/smc_netns.h
@@ -16,5 +16,6 @@ extern unsigned int smc_net_id;
 /* per-network namespace private data */
 struct smc_net {
 	struct smc_pnettable pnettable;
+	struct smc_pnetids_ndev pnetids_ndev;
 };
 #endif
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 0b0f2704026f..8a91ca22712f 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -29,6 +29,7 @@
 #include "smc_ism.h"
 #include "smc_core.h"
 
+static struct net_device *__pnet_find_base_ndev(struct net_device *ndev);
 static struct net_device *pnet_find_base_ndev(struct net_device *ndev);
 
 static const struct nla_policy smc_pnet_policy[SMC_PNETID_MAX + 1] = {
@@ -712,10 +713,115 @@ static struct genl_family smc_pnet_nl_family __ro_after_init = {
 	.n_ops =  ARRAY_SIZE(smc_pnet_ops)
 };
 
+bool smc_pnet_is_ndev_pnetid(struct net *net, u8 *pnetid)
+{
+	struct smc_net *sn = net_generic(net, smc_net_id);
+	struct smc_pnetids_ndev_entry *pe;
+	bool rc = false;
+
+	read_lock(&sn->pnetids_ndev.lock);
+	list_for_each_entry(pe, &sn->pnetids_ndev.list, list) {
+		if (smc_pnet_match(pnetid, pe->pnetid)) {
+			rc = true;
+			goto unlock;
+		}
+	}
+
+unlock:
+	read_unlock(&sn->pnetids_ndev.lock);
+	return rc;
+}
+
+static int smc_pnet_add_pnetid(struct net *net, u8 *pnetid)
+{
+	struct smc_net *sn = net_generic(net, smc_net_id);
+	struct smc_pnetids_ndev_entry *pe, *pi;
+
+	pe = kzalloc(sizeof(*pe), GFP_KERNEL);
+	if (!pe)
+		return -ENOMEM;
+
+	write_lock(&sn->pnetids_ndev.lock);
+	list_for_each_entry(pi, &sn->pnetids_ndev.list, list) {
+		if (smc_pnet_match(pnetid, pe->pnetid)) {
+			refcount_inc(&pi->refcnt);
+			kfree(pe);
+			goto unlock;
+		}
+	}
+	refcount_set(&pe->refcnt, 1);
+	memcpy(pe->pnetid, pnetid, SMC_MAX_PNETID_LEN);
+	list_add_tail(&pe->list, &sn->pnetids_ndev.list);
+
+unlock:
+	write_unlock(&sn->pnetids_ndev.lock);
+	return 0;
+}
+
+static void smc_pnet_remove_pnetid(struct net *net, u8 *pnetid)
+{
+	struct smc_net *sn = net_generic(net, smc_net_id);
+	struct smc_pnetids_ndev_entry *pe, *pe2;
+
+	write_lock(&sn->pnetids_ndev.lock);
+	list_for_each_entry_safe(pe, pe2, &sn->pnetids_ndev.list, list) {
+		if (smc_pnet_match(pnetid, pe->pnetid)) {
+			if (refcount_dec_and_test(&pe->refcnt)) {
+				list_del(&pe->list);
+				kfree(pe);
+			}
+			break;
+		}
+	}
+	write_unlock(&sn->pnetids_ndev.lock);
+}
+
+static void smc_pnet_add_base_pnetid(struct net *net, struct net_device *dev,
+				     u8 *ndev_pnetid)
+{
+	struct net_device *base_dev;
+
+	base_dev = __pnet_find_base_ndev(dev);
+	if (base_dev->flags & IFF_UP &&
+	    !smc_pnetid_by_dev_port(base_dev->dev.parent, base_dev->dev_port,
+				    ndev_pnetid)) {
+		/* add to PNETIDs list */
+		smc_pnet_add_pnetid(net, ndev_pnetid);
+	}
+}
+
+/* create initial list of netdevice pnetids */
+static void smc_pnet_create_pnetids_list(struct net *net)
+{
+	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
+	struct net_device *dev;
+
+	rtnl_lock();
+	for_each_netdev(net, dev)
+		smc_pnet_add_base_pnetid(net, dev, ndev_pnetid);
+	rtnl_unlock();
+}
+
+/* clean up list of netdevice pnetids */
+static void smc_pnet_destroy_pnetids_list(struct net *net)
+{
+	struct smc_net *sn = net_generic(net, smc_net_id);
+	struct smc_pnetids_ndev_entry *pe, *temp_pe;
+
+	write_lock(&sn->pnetids_ndev.lock);
+	list_for_each_entry_safe(pe, temp_pe, &sn->pnetids_ndev.list, list) {
+		list_del(&pe->list);
+		kfree(pe);
+	}
+	write_unlock(&sn->pnetids_ndev.lock);
+}
+
 static int smc_pnet_netdev_event(struct notifier_block *this,
 				 unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(event_dev);
+	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
 
 	switch (event) {
 	case NETDEV_REBOOT:
@@ -725,6 +831,17 @@ static int smc_pnet_netdev_event(struct notifier_block *this,
 	case NETDEV_REGISTER:
 		smc_pnet_add_by_ndev(event_dev);
 		return NOTIFY_OK;
+	case NETDEV_UP:
+		smc_pnet_add_base_pnetid(net, event_dev, ndev_pnetid);
+		return NOTIFY_OK;
+	case NETDEV_DOWN:
+		event_dev = __pnet_find_base_ndev(event_dev);
+		if (!smc_pnetid_by_dev_port(event_dev->dev.parent,
+					    event_dev->dev_port, ndev_pnetid)) {
+			/* remove from PNETIDs list */
+			smc_pnet_remove_pnetid(net, ndev_pnetid);
+		}
+		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
 	}
@@ -739,9 +856,14 @@ int smc_pnet_net_init(struct net *net)
 {
 	struct smc_net *sn = net_generic(net, smc_net_id);
 	struct smc_pnettable *pnettable = &sn->pnettable;
+	struct smc_pnetids_ndev *pnetids_ndev = &sn->pnetids_ndev;
 
 	INIT_LIST_HEAD(&pnettable->pnetlist);
 	rwlock_init(&pnettable->lock);
+	INIT_LIST_HEAD(&pnetids_ndev->list);
+	rwlock_init(&pnetids_ndev->lock);
+
+	smc_pnet_create_pnetids_list(net);
 
 	return 0;
 }
@@ -756,6 +878,7 @@ int __init smc_pnet_init(void)
 	rc = register_netdevice_notifier(&smc_netdev_notifier);
 	if (rc)
 		genl_unregister_family(&smc_pnet_nl_family);
+
 	return rc;
 }
 
@@ -764,6 +887,7 @@ void smc_pnet_net_exit(struct net *net)
 {
 	/* flush pnet table */
 	smc_pnet_remove_by_pnetid(net, NULL);
+	smc_pnet_destroy_pnetids_list(net);
 }
 
 void smc_pnet_exit(void)
@@ -772,16 +896,11 @@ void smc_pnet_exit(void)
 	genl_unregister_family(&smc_pnet_nl_family);
 }
 
-/* Determine one base device for stacked net devices.
- * If the lower device level contains more than one devices
- * (for instance with bonding slaves), just the first device
- * is used to reach a base device.
- */
-static struct net_device *pnet_find_base_ndev(struct net_device *ndev)
+static struct net_device *__pnet_find_base_ndev(struct net_device *ndev)
 {
 	int i, nest_lvl;
 
-	rtnl_lock();
+	ASSERT_RTNL();
 	nest_lvl = ndev->lower_level;
 	for (i = 0; i < nest_lvl; i++) {
 		struct list_head *lower = &ndev->adj_list.lower;
@@ -791,6 +910,18 @@ static struct net_device *pnet_find_base_ndev(struct net_device *ndev)
 		lower = lower->next;
 		ndev = netdev_lower_get_next(ndev, &lower);
 	}
+	return ndev;
+}
+
+/* Determine one base device for stacked net devices.
+ * If the lower device level contains more than one devices
+ * (for instance with bonding slaves), just the first device
+ * is used to reach a base device.
+ */
+static struct net_device *pnet_find_base_ndev(struct net_device *ndev)
+{
+	rtnl_lock();
+	ndev = __pnet_find_base_ndev(ndev);
 	rtnl_unlock();
 	return ndev;
 }
diff --git a/net/smc/smc_pnet.h b/net/smc/smc_pnet.h
index 811a65986691..677a47ac158e 100644
--- a/net/smc/smc_pnet.h
+++ b/net/smc/smc_pnet.h
@@ -12,6 +12,8 @@
 #ifndef _SMC_PNET_H
 #define _SMC_PNET_H
 
+#include <net/smc.h>
+
 #if IS_ENABLED(CONFIG_HAVE_PNETID)
 #include <asm/pnet.h>
 #endif
@@ -31,6 +33,17 @@ struct smc_pnettable {
 	struct list_head pnetlist;
 };
 
+struct smc_pnetids_ndev {	/* list of pnetids for net devices in UP state*/
+	struct list_head	list;
+	rwlock_t		lock;
+};
+
+struct smc_pnetids_ndev_entry {
+	struct list_head	list;
+	u8			pnetid[SMC_MAX_PNETID_LEN];
+	refcount_t		refcnt;
+};
+
 static inline int smc_pnetid_by_dev_port(struct device *dev,
 					 unsigned short port, u8 *pnetid)
 {
@@ -52,4 +65,5 @@ int smc_pnetid_by_table_smcd(struct smcd_dev *smcd);
 void smc_pnet_find_alt_roce(struct smc_link_group *lgr,
 			    struct smc_init_info *ini,
 			    struct smc_ib_device *known_dev);
+bool smc_pnet_is_ndev_pnetid(struct net *net, u8 *pnetid);
 #endif
-- 
2.17.1

