Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E05958513
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfF0PCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:02:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726865AbfF0PCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:02:03 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5REx4Qk007787
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:02:02 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcxcte71j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:02:00 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:43 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:41 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1di619922950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B95FA405F;
        Thu, 27 Jun 2019 15:01:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08BCCA4054;
        Thu, 27 Jun 2019 15:01:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 15:01:38 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 12/12] s390/qeth: move cast type selection into fill_header()
Date:   Thu, 27 Jun 2019 17:01:33 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0008-0000-0000-000002F7B603
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0009-0000-0000-00002264EFB0
Message-Id: <20190627150133.58746-13-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cast type currently gets selected in .ndo_start_xmit, and is then
piped through several layers until it's stored into the HW header.
Push the selection down into qeth_l?_fill_header() to (1) reduce the
number of xmit-wide parameters, and (2) merge the two route validation
checks into just one.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  5 ++--
 drivers/s390/net/qeth_core_main.c |  7 +++--
 drivers/s390/net/qeth_l2_main.c   |  4 +--
 drivers/s390/net/qeth_l3_main.c   | 43 ++++++++++++++-----------------
 4 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index d354b39cdf4b..c7ee07ce3615 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1040,11 +1040,10 @@ int qeth_stop(struct net_device *dev);
 
 int qeth_vm_request_mac(struct qeth_card *card);
 int qeth_xmit(struct qeth_card *card, struct sk_buff *skb,
-	      struct qeth_qdio_out_q *queue, int ipv, int cast_type,
+	      struct qeth_qdio_out_q *queue, int ipv,
 	      void (*fill_header)(struct qeth_qdio_out_q *queue,
 				  struct qeth_hdr *hdr, struct sk_buff *skb,
-				  int ipv, int cast_type,
-				  unsigned int data_len));
+				  int ipv, unsigned int data_len));
 
 /* exports for OSN */
 int qeth_osn_assist(struct net_device *, void *, int);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3011cae00391..4d0caeebc802 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3908,11 +3908,10 @@ static void qeth_fill_tso_ext(struct qeth_hdr_tso *hdr,
 }
 
 int qeth_xmit(struct qeth_card *card, struct sk_buff *skb,
-	      struct qeth_qdio_out_q *queue, int ipv, int cast_type,
+	      struct qeth_qdio_out_q *queue, int ipv,
 	      void (*fill_header)(struct qeth_qdio_out_q *queue,
 				  struct qeth_hdr *hdr, struct sk_buff *skb,
-				  int ipv, int cast_type,
-				  unsigned int data_len))
+				  int ipv, unsigned int data_len))
 {
 	unsigned int proto_len, hw_hdr_len;
 	unsigned int frame_len = skb->len;
@@ -3946,7 +3945,7 @@ int qeth_xmit(struct qeth_card *card, struct sk_buff *skb,
 		data_offset = push_len + proto_len;
 	}
 	memset(hdr, 0, hw_hdr_len);
-	fill_header(queue, hdr, skb, ipv, cast_type, frame_len);
+	fill_header(queue, hdr, skb, ipv, frame_len);
 	if (is_tso)
 		qeth_fill_tso_ext((struct qeth_hdr_tso *) hdr,
 				  frame_len - proto_len, skb, proto_len);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 4a2ff9d8aa5f..fd64bc3f4062 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -164,8 +164,9 @@ static void qeth_l2_drain_rx_mode_cache(struct qeth_card *card)
 
 static void qeth_l2_fill_header(struct qeth_qdio_out_q *queue,
 				struct qeth_hdr *hdr, struct sk_buff *skb,
-				int ipv, int cast_type, unsigned int data_len)
+				int ipv, unsigned int data_len)
 {
+	int cast_type = qeth_get_ether_cast_type(skb);
 	struct vlan_ethhdr *veth = vlan_eth_hdr(skb);
 
 	hdr->hdr.l2.pkt_length = data_len;
@@ -598,7 +599,6 @@ static netdev_tx_t qeth_l2_hard_start_xmit(struct sk_buff *skb,
 		rc = qeth_l2_xmit_osn(card, skb, queue);
 	else
 		rc = qeth_xmit(card, skb, queue, qeth_get_ip_version(skb),
-			       qeth_get_ether_cast_type(skb),
 			       qeth_l2_fill_header);
 
 	if (!rc) {
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 5bf5129ddcd4..2dd99f103671 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1939,12 +1939,13 @@ static u8 qeth_l3_cast_type_to_flag(int cast_type)
 
 static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 				struct qeth_hdr *hdr, struct sk_buff *skb,
-				int ipv, int cast_type, unsigned int data_len)
+				int ipv, unsigned int data_len)
 {
 	struct qeth_hdr_layer3 *l3_hdr = &hdr->hdr.l3;
 	struct vlan_ethhdr *veth = vlan_eth_hdr(skb);
 	struct qeth_card *card = queue->card;
 	struct dst_entry *dst;
+	int cast_type;
 
 	hdr->hdr.l3.length = data_len;
 
@@ -1981,25 +1982,22 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 		hdr->hdr.l3.vlan_id = ntohs(veth->h_vlan_TCI);
 	}
 
-	l3_hdr->flags = qeth_l3_cast_type_to_flag(cast_type);
-
-	/* OSA only: */
-	if (!ipv) {
-		l3_hdr->flags |= QETH_HDR_PASSTHRU;
-		return;
-	}
-
 	rcu_read_lock();
 	dst = qeth_dst_check_rcu(skb, ipv);
 
+	if (IS_IQD(card) && skb_get_queue_mapping(skb) != QETH_IQD_MCAST_TXQ)
+		cast_type = RTN_UNICAST;
+	else
+		cast_type = qeth_l3_get_cast_type_rcu(skb, dst, ipv);
+	l3_hdr->flags |= qeth_l3_cast_type_to_flag(cast_type);
+
 	if (ipv == 4) {
 		struct rtable *rt = (struct rtable *) dst;
 
 		*((__be32 *) &hdr->hdr.l3.next_hop.ipv4.addr) = (rt) ?
 				rt_nexthop(rt, ip_hdr(skb)->daddr) :
 				ip_hdr(skb)->daddr;
-	} else {
-		/* IPv6 */
+	} else if (ipv == 6) {
 		struct rt6_info *rt = (struct rt6_info *) dst;
 
 		if (rt && !ipv6_addr_any(&rt->rt6i_gateway))
@@ -2010,6 +2008,9 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 		hdr->hdr.l3.flags |= QETH_HDR_IPV6;
 		if (!IS_IQD(card))
 			hdr->hdr.l3.flags |= QETH_HDR_PASSTHRU;
+	} else {
+		/* OSA only: */
+		l3_hdr->flags |= QETH_HDR_PASSTHRU;
 	}
 	rcu_read_unlock();
 }
@@ -2029,7 +2030,7 @@ static void qeth_l3_fixup_headers(struct sk_buff *skb)
 }
 
 static int qeth_l3_xmit(struct qeth_card *card, struct sk_buff *skb,
-			struct qeth_qdio_out_q *queue, int ipv, int cast_type)
+			struct qeth_qdio_out_q *queue, int ipv)
 {
 	unsigned int hw_hdr_len;
 	int rc;
@@ -2043,7 +2044,7 @@ static int qeth_l3_xmit(struct qeth_card *card, struct sk_buff *skb,
 	skb_pull(skb, ETH_HLEN);
 
 	qeth_l3_fixup_headers(skb);
-	return qeth_xmit(card, skb, queue, ipv, cast_type, qeth_l3_fill_header);
+	return qeth_xmit(card, skb, queue, ipv, qeth_l3_fill_header);
 }
 
 static netdev_tx_t qeth_l3_hard_start_xmit(struct sk_buff *skb,
@@ -2054,7 +2055,7 @@ static netdev_tx_t qeth_l3_hard_start_xmit(struct sk_buff *skb,
 	int ipv = qeth_get_ip_version(skb);
 	struct qeth_qdio_out_q *queue;
 	int tx_bytes = skb->len;
-	int cast_type, rc;
+	int rc;
 
 	if (IS_IQD(card)) {
 		queue = card->qdio.out_qs[qeth_iqd_translate_txq(dev, txq)];
@@ -2065,24 +2066,18 @@ static netdev_tx_t qeth_l3_hard_start_xmit(struct sk_buff *skb,
 		    (card->options.cq == QETH_CQ_ENABLED &&
 		     skb->protocol != htons(ETH_P_AF_IUCV)))
 			goto tx_drop;
-
-		if (txq == QETH_IQD_MCAST_TXQ)
-			cast_type = qeth_l3_get_cast_type(skb);
-		else
-			cast_type = RTN_UNICAST;
 	} else {
 		queue = card->qdio.out_qs[txq];
-		cast_type = qeth_l3_get_cast_type(skb);
 	}
 
-	if (cast_type == RTN_BROADCAST && !card->info.broadcast_capable)
+	if (!(dev->flags & IFF_BROADCAST) &&
+	    qeth_l3_get_cast_type(skb) == RTN_BROADCAST)
 		goto tx_drop;
 
 	if (ipv == 4 || IS_IQD(card))
-		rc = qeth_l3_xmit(card, skb, queue, ipv, cast_type);
+		rc = qeth_l3_xmit(card, skb, queue, ipv);
 	else
-		rc = qeth_xmit(card, skb, queue, ipv, cast_type,
-			       qeth_l3_fill_header);
+		rc = qeth_xmit(card, skb, queue, ipv, qeth_l3_fill_header);
 
 	if (!rc) {
 		QETH_TXQ_STAT_INC(queue, tx_packets);
-- 
2.17.1

