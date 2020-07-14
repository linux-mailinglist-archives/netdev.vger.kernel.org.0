Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C408E21F3F2
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgGNOXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:23:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbgGNOXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:23:22 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EE2jsI183477;
        Tue, 14 Jul 2020 10:23:20 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3292umv8h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:23:20 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EEFiFG015453;
        Tue, 14 Jul 2020 14:23:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3275283e2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 14:23:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EENFqe61210950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:23:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 871264C05C;
        Tue, 14 Jul 2020 14:23:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 459284C05E;
        Tue, 14 Jul 2020 14:23:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 14:23:15 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 09/10] s390/qeth: unify RX-mode hashtables
Date:   Tue, 14 Jul 2020 16:23:04 +0200
Message-Id: <20200714142305.29297-10-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714142305.29297-1-jwi@linux.ibm.com>
References: <20200714142305.29297-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_04:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To keep track of the addresses programmed from an RX modeset, we have
two separate hashtables (L2: mac_htable, L3: ip_mc_htable).

These are never used at the same time, so unify them into a single
rx_mode_addrs hashtable.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  3 +--
 drivers/s390/net/qeth_core_main.c |  1 +
 drivers/s390/net/qeth_l2_main.c   |  9 ++++-----
 drivers/s390/net/qeth_l3_main.c   | 13 ++++++-------
 4 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index c77a87105ea8..3d54c8bbfa86 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -803,14 +803,13 @@ struct qeth_card {
 	struct workqueue_struct *event_wq;
 	struct workqueue_struct *cmd_wq;
 	wait_queue_head_t wait_q;
-	DECLARE_HASHTABLE(mac_htable, 4);
 	DECLARE_HASHTABLE(ip_htable, 4);
 	DECLARE_HASHTABLE(local_addrs4, 4);
 	DECLARE_HASHTABLE(local_addrs6, 4);
 	spinlock_t local_addrs4_lock;
 	spinlock_t local_addrs6_lock;
 	struct mutex ip_lock;
-	DECLARE_HASHTABLE(ip_mc_htable, 4);
+	DECLARE_HASHTABLE(rx_mode_addrs, 4);
 	struct work_struct rx_mode_work;
 	struct work_struct kernel_thread_starter;
 	spinlock_t thread_mask_lock;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 053a25e34e4b..01a280b5e8d2 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1647,6 +1647,7 @@ static void qeth_setup_card(struct qeth_card *card)
 	qeth_init_qdio_info(card);
 	INIT_DELAYED_WORK(&card->buffer_reclaim_work, qeth_buffer_reclaim_work);
 	INIT_WORK(&card->close_dev_work, qeth_close_dev_handler);
+	hash_init(card->rx_mode_addrs);
 	hash_init(card->local_addrs4);
 	hash_init(card->local_addrs6);
 	spin_lock_init(&card->local_addrs4_lock);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2d3bca3c0141..ef7a2db7a724 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -156,7 +156,7 @@ static void qeth_l2_drain_rx_mode_cache(struct qeth_card *card)
 	struct hlist_node *tmp;
 	int i;
 
-	hash_for_each_safe(card->mac_htable, i, tmp, mac, hnode) {
+	hash_for_each_safe(card->rx_mode_addrs, i, tmp, mac, hnode) {
 		hash_del(&mac->hnode);
 		kfree(mac);
 	}
@@ -438,7 +438,7 @@ static void qeth_l2_add_mac(struct qeth_card *card, struct netdev_hw_addr *ha)
 	u32 mac_hash = get_unaligned((u32 *)(&ha->addr[2]));
 	struct qeth_mac *mac;
 
-	hash_for_each_possible(card->mac_htable, mac, hnode, mac_hash) {
+	hash_for_each_possible(card->rx_mode_addrs, mac, hnode, mac_hash) {
 		if (ether_addr_equal_64bits(ha->addr, mac->mac_addr)) {
 			mac->disp_flag = QETH_DISP_ADDR_DO_NOTHING;
 			return;
@@ -452,7 +452,7 @@ static void qeth_l2_add_mac(struct qeth_card *card, struct netdev_hw_addr *ha)
 	ether_addr_copy(mac->mac_addr, ha->addr);
 	mac->disp_flag = QETH_DISP_ADDR_ADD;
 
-	hash_add(card->mac_htable, &mac->hnode, mac_hash);
+	hash_add(card->rx_mode_addrs, &mac->hnode, mac_hash);
 }
 
 static void qeth_l2_rx_mode_work(struct work_struct *work)
@@ -475,7 +475,7 @@ static void qeth_l2_rx_mode_work(struct work_struct *work)
 		qeth_l2_add_mac(card, ha);
 	netif_addr_unlock_bh(dev);
 
-	hash_for_each_safe(card->mac_htable, i, tmp, mac, hnode) {
+	hash_for_each_safe(card->rx_mode_addrs, i, tmp, mac, hnode) {
 		switch (mac->disp_flag) {
 		case QETH_DISP_ADDR_DELETE:
 			qeth_l2_remove_mac(card, mac->mac_addr);
@@ -601,7 +601,6 @@ static int qeth_l2_probe_device(struct ccwgroup_device *gdev)
 			return rc;
 	}
 
-	hash_init(card->mac_htable);
 	INIT_WORK(&card->rx_mode_work, qeth_l2_rx_mode_work);
 	return 0;
 }
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d4ce653ff111..15a12487ff7a 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -58,7 +58,7 @@ static struct qeth_ipaddr *qeth_l3_find_addr_by_ip(struct qeth_card *card,
 	struct qeth_ipaddr *addr;
 
 	if (query->is_multicast) {
-		hash_for_each_possible(card->ip_mc_htable, addr, hnode, key)
+		hash_for_each_possible(card->rx_mode_addrs, addr, hnode, key)
 			if (qeth_l3_addr_match_ip(addr, query))
 				return addr;
 	} else {
@@ -239,7 +239,7 @@ static void qeth_l3_drain_rx_mode_cache(struct qeth_card *card)
 	struct hlist_node *tmp;
 	int i;
 
-	hash_for_each_safe(card->ip_mc_htable, i, tmp, addr, hnode) {
+	hash_for_each_safe(card->rx_mode_addrs, i, tmp, addr, hnode) {
 		hash_del(&addr->hnode);
 		kfree(addr);
 	}
@@ -1093,7 +1093,7 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 		if (!ipm)
 			continue;
 
-		hash_add(card->ip_mc_htable, &ipm->hnode,
+		hash_add(card->rx_mode_addrs, &ipm->hnode,
 			 qeth_l3_ipaddr_hash(ipm));
 	}
 
@@ -1124,8 +1124,8 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 		if (!ipm)
 			continue;
 
-		hash_add(card->ip_mc_htable,
-				&ipm->hnode, qeth_l3_ipaddr_hash(ipm));
+		hash_add(card->rx_mode_addrs, &ipm->hnode,
+			 qeth_l3_ipaddr_hash(ipm));
 
 	}
 	read_unlock_bh(&in6_dev->lock);
@@ -1219,7 +1219,7 @@ static void qeth_l3_rx_mode_work(struct work_struct *work)
 			vlan_for_each(card->dev, qeth_l3_add_mcast_rtnl, card);
 		rtnl_unlock();
 
-		hash_for_each_safe(card->ip_mc_htable, i, tmp, addr, hnode) {
+		hash_for_each_safe(card->rx_mode_addrs, i, tmp, addr, hnode) {
 			switch (addr->disp_flag) {
 			case QETH_DISP_ADDR_DELETE:
 				rc = qeth_l3_deregister_addr_entry(card, addr);
@@ -1998,7 +1998,6 @@ static int qeth_l3_probe_device(struct ccwgroup_device *gdev)
 		}
 	}
 
-	hash_init(card->ip_mc_htable);
 	INIT_WORK(&card->rx_mode_work, qeth_l3_rx_mode_work);
 	return 0;
 }
-- 
2.17.1

