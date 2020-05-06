Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDF91C6B00
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgEFIKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:10:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728700AbgEFIJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:09:59 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04681aBE169302;
        Wed, 6 May 2020 04:09:58 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30twhy0cw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:09:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04686ECD019049;
        Wed, 6 May 2020 08:09:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5rpen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 08:09:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04689rE465274364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 08:09:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60084A405F;
        Wed,  6 May 2020 08:09:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 248DBA405B;
        Wed,  6 May 2020 08:09:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 08:09:53 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 05/10] s390/qeth: don't use restricted offloads for local traffic
Date:   Wed,  6 May 2020 10:09:44 +0200
Message-Id: <20200506080949.3915-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506080949.3915-1-jwi@linux.ibm.com>
References: <20200506080949.3915-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_02:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=786
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 mlxscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060058
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

