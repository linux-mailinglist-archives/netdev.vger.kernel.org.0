Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015091C5D89
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgEEQ0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:26:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730475AbgEEQ0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:26:09 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045G2lp9052337;
        Tue, 5 May 2020 12:26:07 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8sgxu4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:26:07 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045GJwor023816;
        Tue, 5 May 2020 16:26:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 30s0g5jy5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 16:26:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045GQ2Kl63897758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 16:26:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 570CF4203F;
        Tue,  5 May 2020 16:26:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1092F42045;
        Tue,  5 May 2020 16:26:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 16:26:01 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 02/11] s390/qeth: process local address events
Date:   Tue,  5 May 2020 18:25:50 +0200
Message-Id: <20200505162559.14138-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505162559.14138-1-jwi@linux.ibm.com>
References: <20200505162559.14138-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_09:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In configurations where specific HW offloads are in use, OSA adapters
will raise notifications to their virtual devices about the IP addresses
that currently reside on the same adapter.
Cache these addresses in two RCU-enabled hash tables, and flush the
tables once the relevant HW offload(s) get disabled.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  13 ++
 drivers/s390/net/qeth_core_main.c | 217 ++++++++++++++++++++++++++++++
 drivers/s390/net/qeth_core_mpc.h  |  25 ++++
 drivers/s390/net/qeth_l2_main.c   |   1 +
 drivers/s390/net/qeth_l3_main.c   |   1 +
 5 files changed, 257 insertions(+)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 2ac7771394d8..b92af3735dd4 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -21,8 +21,10 @@
 #include <linux/seq_file.h>
 #include <linux/hashtable.h>
 #include <linux/ip.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
 #include <linux/timer.h>
+#include <linux/types.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
@@ -356,6 +358,12 @@ static inline bool qeth_l3_same_next_hop(struct qeth_hdr_layer3 *h1,
 			       &h2->next_hop.ipv6_addr);
 }
 
+struct qeth_local_addr {
+	struct hlist_node hnode;
+	struct rcu_head rcu;
+	struct in6_addr addr;
+};
+
 enum qeth_qdio_info_states {
 	QETH_QDIO_UNINITIALIZED,
 	QETH_QDIO_ALLOCATED,
@@ -800,6 +808,10 @@ struct qeth_card {
 	wait_queue_head_t wait_q;
 	DECLARE_HASHTABLE(mac_htable, 4);
 	DECLARE_HASHTABLE(ip_htable, 4);
+	DECLARE_HASHTABLE(local_addrs4, 4);
+	DECLARE_HASHTABLE(local_addrs6, 4);
+	spinlock_t local_addrs4_lock;
+	spinlock_t local_addrs6_lock;
 	struct mutex ip_lock;
 	DECLARE_HASHTABLE(ip_mc_htable, 4);
 	struct work_struct rx_mode_work;
@@ -1025,6 +1037,7 @@ void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason);
 void qeth_put_cmd(struct qeth_cmd_buffer *iob);
 
 void qeth_schedule_recovery(struct qeth_card *);
+void qeth_flush_local_addrs(struct qeth_card *card);
 int qeth_poll(struct napi_struct *napi, int budget);
 void qeth_clear_ipacmd_list(struct qeth_card *);
 int qeth_qdio_clear_card(struct qeth_card *, int);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index ef96890eea5c..6b5d42a4501c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -26,6 +26,7 @@
 #include <linux/if_vlan.h>
 #include <linux/netdevice.h>
 #include <linux/netdev_features.h>
+#include <linux/rcutree.h>
 #include <linux/skbuff.h>
 #include <linux/vmalloc.h>
 
@@ -623,6 +624,187 @@ void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason)
 }
 EXPORT_SYMBOL_GPL(qeth_notify_cmd);
 
+static void qeth_flush_local_addrs4(struct qeth_card *card)
+{
+	struct qeth_local_addr *addr;
+	struct hlist_node *tmp;
+	unsigned int i;
+
+	spin_lock_irq(&card->local_addrs4_lock);
+	hash_for_each_safe(card->local_addrs4, i, tmp, addr, hnode) {
+		hash_del_rcu(&addr->hnode);
+		kfree_rcu(addr, rcu);
+	}
+	spin_unlock_irq(&card->local_addrs4_lock);
+}
+
+static void qeth_flush_local_addrs6(struct qeth_card *card)
+{
+	struct qeth_local_addr *addr;
+	struct hlist_node *tmp;
+	unsigned int i;
+
+	spin_lock_irq(&card->local_addrs6_lock);
+	hash_for_each_safe(card->local_addrs6, i, tmp, addr, hnode) {
+		hash_del_rcu(&addr->hnode);
+		kfree_rcu(addr, rcu);
+	}
+	spin_unlock_irq(&card->local_addrs6_lock);
+}
+
+void qeth_flush_local_addrs(struct qeth_card *card)
+{
+	qeth_flush_local_addrs4(card);
+	qeth_flush_local_addrs6(card);
+}
+EXPORT_SYMBOL_GPL(qeth_flush_local_addrs);
+
+static void qeth_add_local_addrs4(struct qeth_card *card,
+				  struct qeth_ipacmd_local_addrs4 *cmd)
+{
+	unsigned int i;
+
+	if (cmd->addr_length !=
+	    sizeof_field(struct qeth_ipacmd_local_addr4, addr)) {
+		dev_err_ratelimited(&card->gdev->dev,
+				    "Dropped IPv4 ADD LOCAL ADDR event with bad length %u\n",
+				    cmd->addr_length);
+		return;
+	}
+
+	spin_lock(&card->local_addrs4_lock);
+	for (i = 0; i < cmd->count; i++) {
+		unsigned int key = ipv4_addr_hash(cmd->addrs[i].addr);
+		struct qeth_local_addr *addr;
+		bool duplicate = false;
+
+		hash_for_each_possible(card->local_addrs4, addr, hnode, key) {
+			if (addr->addr.s6_addr32[3] == cmd->addrs[i].addr) {
+				duplicate = true;
+				break;
+			}
+		}
+
+		if (duplicate)
+			continue;
+
+		addr = kmalloc(sizeof(*addr), GFP_ATOMIC);
+		if (!addr) {
+			dev_err(&card->gdev->dev,
+				"Failed to allocate local addr object. Traffic to %pI4 might suffer.\n",
+				&cmd->addrs[i].addr);
+			continue;
+		}
+
+		ipv6_addr_set(&addr->addr, 0, 0, 0, cmd->addrs[i].addr);
+		hash_add_rcu(card->local_addrs4, &addr->hnode, key);
+	}
+	spin_unlock(&card->local_addrs4_lock);
+}
+
+static void qeth_add_local_addrs6(struct qeth_card *card,
+				  struct qeth_ipacmd_local_addrs6 *cmd)
+{
+	unsigned int i;
+
+	if (cmd->addr_length !=
+	    sizeof_field(struct qeth_ipacmd_local_addr6, addr)) {
+		dev_err_ratelimited(&card->gdev->dev,
+				    "Dropped IPv6 ADD LOCAL ADDR event with bad length %u\n",
+				    cmd->addr_length);
+		return;
+	}
+
+	spin_lock(&card->local_addrs6_lock);
+	for (i = 0; i < cmd->count; i++) {
+		u32 key = ipv6_addr_hash(&cmd->addrs[i].addr);
+		struct qeth_local_addr *addr;
+		bool duplicate = false;
+
+		hash_for_each_possible(card->local_addrs6, addr, hnode, key) {
+			if (ipv6_addr_equal(&addr->addr, &cmd->addrs[i].addr)) {
+				duplicate = true;
+				break;
+			}
+		}
+
+		if (duplicate)
+			continue;
+
+		addr = kmalloc(sizeof(*addr), GFP_ATOMIC);
+		if (!addr) {
+			dev_err(&card->gdev->dev,
+				"Failed to allocate local addr object. Traffic to %pI6c might suffer.\n",
+				&cmd->addrs[i].addr);
+			continue;
+		}
+
+		addr->addr = cmd->addrs[i].addr;
+		hash_add_rcu(card->local_addrs6, &addr->hnode, key);
+	}
+	spin_unlock(&card->local_addrs6_lock);
+}
+
+static void qeth_del_local_addrs4(struct qeth_card *card,
+				  struct qeth_ipacmd_local_addrs4 *cmd)
+{
+	unsigned int i;
+
+	if (cmd->addr_length !=
+	    sizeof_field(struct qeth_ipacmd_local_addr4, addr)) {
+		dev_err_ratelimited(&card->gdev->dev,
+				    "Dropped IPv4 DEL LOCAL ADDR event with bad length %u\n",
+				    cmd->addr_length);
+		return;
+	}
+
+	spin_lock(&card->local_addrs4_lock);
+	for (i = 0; i < cmd->count; i++) {
+		struct qeth_ipacmd_local_addr4 *addr = &cmd->addrs[i];
+		unsigned int key = ipv4_addr_hash(addr->addr);
+		struct qeth_local_addr *tmp;
+
+		hash_for_each_possible(card->local_addrs4, tmp, hnode, key) {
+			if (tmp->addr.s6_addr32[3] == addr->addr) {
+				hash_del_rcu(&tmp->hnode);
+				kfree_rcu(tmp, rcu);
+				break;
+			}
+		}
+	}
+	spin_unlock(&card->local_addrs4_lock);
+}
+
+static void qeth_del_local_addrs6(struct qeth_card *card,
+				  struct qeth_ipacmd_local_addrs6 *cmd)
+{
+	unsigned int i;
+
+	if (cmd->addr_length !=
+	    sizeof_field(struct qeth_ipacmd_local_addr6, addr)) {
+		dev_err_ratelimited(&card->gdev->dev,
+				    "Dropped IPv6 DEL LOCAL ADDR event with bad length %u\n",
+				    cmd->addr_length);
+		return;
+	}
+
+	spin_lock(&card->local_addrs6_lock);
+	for (i = 0; i < cmd->count; i++) {
+		struct qeth_ipacmd_local_addr6 *addr = &cmd->addrs[i];
+		u32 key = ipv6_addr_hash(&addr->addr);
+		struct qeth_local_addr *tmp;
+
+		hash_for_each_possible(card->local_addrs6, tmp, hnode, key) {
+			if (ipv6_addr_equal(&tmp->addr, &addr->addr)) {
+				hash_del_rcu(&tmp->hnode);
+				kfree_rcu(tmp, rcu);
+				break;
+			}
+		}
+	}
+	spin_unlock(&card->local_addrs6_lock);
+}
+
 static void qeth_issue_ipa_msg(struct qeth_ipa_cmd *cmd, int rc,
 		struct qeth_card *card)
 {
@@ -686,9 +868,19 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 	case IPA_CMD_MODCCID:
 		return cmd;
 	case IPA_CMD_REGISTER_LOCAL_ADDR:
+		if (cmd->hdr.prot_version == QETH_PROT_IPV4)
+			qeth_add_local_addrs4(card, &cmd->data.local_addrs4);
+		else if (cmd->hdr.prot_version == QETH_PROT_IPV6)
+			qeth_add_local_addrs6(card, &cmd->data.local_addrs6);
+
 		QETH_CARD_TEXT(card, 3, "irla");
 		return NULL;
 	case IPA_CMD_UNREGISTER_LOCAL_ADDR:
+		if (cmd->hdr.prot_version == QETH_PROT_IPV4)
+			qeth_del_local_addrs4(card, &cmd->data.local_addrs4);
+		else if (cmd->hdr.prot_version == QETH_PROT_IPV6)
+			qeth_del_local_addrs6(card, &cmd->data.local_addrs6);
+
 		QETH_CARD_TEXT(card, 3, "urla");
 		return NULL;
 	default:
@@ -1376,6 +1568,10 @@ static void qeth_setup_card(struct qeth_card *card)
 	qeth_init_qdio_info(card);
 	INIT_DELAYED_WORK(&card->buffer_reclaim_work, qeth_buffer_reclaim_work);
 	INIT_WORK(&card->close_dev_work, qeth_close_dev_handler);
+	hash_init(card->local_addrs4);
+	hash_init(card->local_addrs6);
+	spin_lock_init(&card->local_addrs4_lock);
+	spin_lock_init(&card->local_addrs6_lock);
 }
 
 static void qeth_core_sl_print(struct seq_file *m, struct service_level *slr)
@@ -6496,6 +6692,24 @@ void qeth_enable_hw_features(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(qeth_enable_hw_features);
 
+static void qeth_check_restricted_features(struct qeth_card *card,
+					   netdev_features_t changed,
+					   netdev_features_t actual)
+{
+	netdev_features_t ipv6_features = NETIF_F_TSO6;
+	netdev_features_t ipv4_features = NETIF_F_TSO;
+
+	if (!card->info.has_lp2lp_cso_v6)
+		ipv6_features |= NETIF_F_IPV6_CSUM;
+	if (!card->info.has_lp2lp_cso_v4)
+		ipv4_features |= NETIF_F_IP_CSUM;
+
+	if ((changed & ipv6_features) && !(actual & ipv6_features))
+		qeth_flush_local_addrs6(card);
+	if ((changed & ipv4_features) && !(actual & ipv4_features))
+		qeth_flush_local_addrs4(card);
+}
+
 int qeth_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qeth_card *card = dev->ml_priv;
@@ -6537,6 +6751,9 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 			changed ^= NETIF_F_TSO6;
 	}
 
+	qeth_check_restricted_features(card, dev->features ^ features,
+				       dev->features ^ changed);
+
 	/* everything changed successfully? */
 	if ((dev->features ^ features) == changed)
 		return 0;
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index d89a04bfd8b0..9d6f39d8f9ab 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -772,6 +772,29 @@ struct qeth_ipacmd_addr_change {
 	struct qeth_ipacmd_addr_change_entry entry[];
 } __packed;
 
+/* [UN]REGISTER_LOCAL_ADDRESS notifications */
+struct qeth_ipacmd_local_addr4 {
+	__be32 addr;
+	u32 flags;
+};
+
+struct qeth_ipacmd_local_addrs4 {
+	u32 count;
+	u32 addr_length;
+	struct qeth_ipacmd_local_addr4 addrs[];
+};
+
+struct qeth_ipacmd_local_addr6 {
+	struct in6_addr addr;
+	u32 flags;
+};
+
+struct qeth_ipacmd_local_addrs6 {
+	u32 count;
+	u32 addr_length;
+	struct qeth_ipacmd_local_addr6 addrs[];
+};
+
 /* Header for each IPA command */
 struct qeth_ipacmd_hdr {
 	__u8   command;
@@ -803,6 +826,8 @@ struct qeth_ipa_cmd {
 		struct qeth_ipacmd_setbridgeport	sbp;
 		struct qeth_ipacmd_addr_change		addrchange;
 		struct qeth_ipacmd_vnicc		vnicc;
+		struct qeth_ipacmd_local_addrs4		local_addrs4;
+		struct qeth_ipacmd_local_addrs6		local_addrs6;
 	} data;
 } __attribute__ ((packed));
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 0bd5b09e7a22..47f624b37040 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -291,6 +291,7 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 	qeth_qdio_clear_card(card, 0);
 	qeth_clear_working_pool_list(card);
 	flush_workqueue(card->event_wq);
+	qeth_flush_local_addrs(card);
 	card->info.promisc_mode = 0;
 }
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 0742a749d26e..fec4ac41e946 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1176,6 +1176,7 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 	qeth_qdio_clear_card(card, 0);
 	qeth_clear_working_pool_list(card);
 	flush_workqueue(card->event_wq);
+	qeth_flush_local_addrs(card);
 	card->info.promisc_mode = 0;
 }
 
-- 
2.17.1

