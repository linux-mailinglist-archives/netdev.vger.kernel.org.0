Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BC61C5D84
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbgEEQ0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:26:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730634AbgEEQ0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:26:10 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045G2jKR052189;
        Tue, 5 May 2020 12:26:09 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8sgxu4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:26:08 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045GJnBa023461;
        Tue, 5 May 2020 16:26:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 30s0g5jy5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 16:26:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045GQ3bM60293270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 16:26:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A08A42041;
        Tue,  5 May 2020 16:26:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0969E42049;
        Tue,  5 May 2020 16:26:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 16:26:02 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 05/11] s390/qeth: don't use restricted offloads for local traffic
Date:   Tue,  5 May 2020 18:25:53 +0200
Message-Id: <20200505162559.14138-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505162559.14138-1-jwi@linux.ibm.com>
References: <20200505162559.14138-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_09:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0
 mlxlogscore=786 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current OSA models don't support TSO for traffic to local next-hops, and
some old models didn't offer TX CSO for such packets either.

So as part of .ndo_features_check, check if a packet's next-hop resides
on the same OSA Adapter. Opt out from affected HW offloads accordingly.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 84 +++++++++++++++++++++++++++++--
 drivers/s390/net/qeth_l2_main.c   |  1 +
 2 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 771282cb7aef..1f18b38047a0 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -806,6 +806,58 @@ static void qeth_del_local_addrs6(struct qeth_card *card,
 	spin_unlock(&card->local_addrs6_lock);
 }
 
+static bool qeth_next_hop_is_local_v4(struct qeth_card *card,
+				      struct sk_buff *skb)
+{
+	struct qeth_local_addr *tmp;
+	bool is_local = false;
+	unsigned int key;
+	__be32 next_hop;
+
+	if (hash_empty(card->local_addrs4))
+		return false;
+
+	rcu_read_lock();
+	next_hop = qeth_next_hop_v4_rcu(skb, qeth_dst_check_rcu(skb, 4));
+	key = ipv4_addr_hash(next_hop);
+
+	hash_for_each_possible_rcu(card->local_addrs4, tmp, hnode, key) {
+		if (tmp->addr.s6_addr32[3] == next_hop) {
+			is_local = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return is_local;
+}
+
+static bool qeth_next_hop_is_local_v6(struct qeth_card *card,
+				      struct sk_buff *skb)
+{
+	struct qeth_local_addr *tmp;
+	struct in6_addr *next_hop;
+	bool is_local = false;
+	u32 key;
+
+	if (hash_empty(card->local_addrs6))
+		return false;
+
+	rcu_read_lock();
+	next_hop = qeth_next_hop_v6_rcu(skb, qeth_dst_check_rcu(skb, 6));
+	key = ipv6_addr_hash(next_hop);
+
+	hash_for_each_possible_rcu(card->local_addrs6, tmp, hnode, key) {
+		if (ipv6_addr_equal(&tmp->addr, next_hop)) {
+			is_local = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return is_local;
+}
+
 static int qeth_debugfs_local_addr_show(struct seq_file *m, void *v)
 {
 	struct qeth_card *card = m->private;
@@ -6578,10 +6630,6 @@ static int qeth_set_csum_on(struct qeth_card *card, enum qeth_ipa_funcs cstype,
 	if (lp2lp)
 		*lp2lp = qeth_ipa_caps_enabled(&caps, QETH_IPA_CHECKSUM_LP2LP);
 
-	if (lp2lp && !*lp2lp)
-		dev_warn(&card->gdev->dev,
-			 "Hardware checksumming is performed only if %s and its peer use different OSA Express 3 ports\n",
-			 QETH_CARD_IFNAME(card));
 	return 0;
 }
 
@@ -6816,6 +6864,34 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 				      struct net_device *dev,
 				      netdev_features_t features)
 {
+	/* Traffic with local next-hop is not eligible for some offloads: */
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		struct qeth_card *card = dev->ml_priv;
+		netdev_features_t restricted = 0;
+
+		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
+			restricted |= NETIF_F_ALL_TSO;
+
+		switch (vlan_get_protocol(skb)) {
+		case htons(ETH_P_IP):
+			if (!card->info.has_lp2lp_cso_v4)
+				restricted |= NETIF_F_IP_CSUM;
+
+			if (restricted && qeth_next_hop_is_local_v4(card, skb))
+				features &= ~restricted;
+			break;
+		case htons(ETH_P_IPV6):
+			if (!card->info.has_lp2lp_cso_v6)
+				restricted |= NETIF_F_IPV6_CSUM;
+
+			if (restricted && qeth_next_hop_is_local_v6(card, skb))
+				features &= ~restricted;
+			break;
+		default:
+			break;
+		}
+	}
+
 	/* GSO segmentation builds skbs with
 	 *	a (small) linear part for the headers, and
 	 *	page frags for the data.
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 47f624b37040..da47e423e1b1 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -710,6 +710,7 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 
 	if (card->dev->hw_features & (NETIF_F_TSO | NETIF_F_TSO6)) {
 		card->dev->needed_headroom = sizeof(struct qeth_hdr_tso);
+		netif_keep_dst(card->dev);
 		netif_set_gso_max_size(card->dev,
 				       PAGE_SIZE * (QDIO_MAX_ELEMENTS_PER_BUFFER - 1));
 	}
-- 
2.17.1

