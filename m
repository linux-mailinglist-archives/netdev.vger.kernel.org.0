Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516C533315
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbfFCPGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:06:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729081AbfFCPGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 11:06:11 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53F370b058524
        for <netdev@vger.kernel.org>; Mon, 3 Jun 2019 11:06:10 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw4yhk976-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 11:06:07 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 3 Jun 2019 16:05:37 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 16:05:34 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53F5XPk60489756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 15:05:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E2CB4C050;
        Mon,  3 Jun 2019 15:05:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDED94C04A;
        Mon,  3 Jun 2019 15:05:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 15:05:32 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/4] s390/qeth: don't use obsolete dst entry
Date:   Mon,  3 Jun 2019 17:04:44 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603150446.23351-1-jwi@linux.ibm.com>
References: <20190603150446.23351-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060315-0016-0000-0000-000002833920
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060315-0017-0000-0000-000032E04445
Message-Id: <20190603150446.23351-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=914 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While qeth_l3 uses netif_keep_dst() to hold onto the dst, a skb's dst
may still have been obsoleted (via dst_dev_put()) by the time that we
end up using it. The dst then points to the loopback interface, which
means the neighbour lookup in qeth_l3_get_cast_type() determines a bogus
cast type of RTN_BROADCAST.
For IQD interfaces this causes us to place such skbs on the wrong
HW queue, resulting in TX errors.

Fix-up the various call sites to check whether the dst is obsolete, and
fall back accordingly.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |  2 +-
 drivers/s390/net/qeth_l3_main.c | 57 ++++++++++++++++++++-------------
 2 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 784a2e76a1b0..f89f5b0a9805 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -275,7 +275,7 @@ struct qeth_hdr_layer3 {
 		struct in6_addr ipv6_addr;
 		struct ipv4 {
 			u8 res[12];
-			u32 addr;
+			__be32 addr;
 		} ipv4;
 		/* RX: */
 		struct rx {
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 2df67abdfde7..93bcfc272f20 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1893,8 +1893,9 @@ static int qeth_l3_get_cast_type(struct sk_buff *skb)
 
 	rcu_read_lock();
 	dst = skb_dst(skb);
-	if (dst)
+	if (dst && dst->obsolete <= 0)
 		n = dst_neigh_lookup_skb(dst, skb);
+
 	if (n) {
 		int cast_type = n->type;
 
@@ -1924,6 +1925,33 @@ static int qeth_l3_get_cast_type(struct sk_buff *skb)
 	}
 }
 
+static void qeth_l3_get_next_hop_v4(struct sk_buff *skb, __be32 *next_hop)
+{
+	struct rtable *rt;
+
+	rcu_read_lock();
+	rt = skb_rtable(skb);
+	if (rt && rt->dst.obsolete <= 0)
+		*next_hop = rt_nexthop(rt, ip_hdr(skb)->daddr);
+	else
+		*next_hop = ip_hdr(skb)->daddr;
+	rcu_read_unlock();
+}
+
+static void qeth_l3_get_next_hop_v6(struct sk_buff *skb,
+				    struct in6_addr *next_hop)
+{
+	const struct rt6_info *rt;
+
+	rcu_read_lock();
+	rt = skb_rt6_info(skb);
+	if (rt && rt->dst.obsolete <= 0 && !ipv6_addr_any(&rt->rt6i_gateway))
+		*next_hop = rt->rt6i_gateway;
+	else
+		*next_hop = ipv6_hdr(skb)->daddr;
+	rcu_read_unlock();
+}
+
 static u8 qeth_l3_cast_type_to_flag(int cast_type)
 {
 	if (cast_type == RTN_MULTICAST)
@@ -1980,33 +2008,18 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 
 	l3_hdr->flags = qeth_l3_cast_type_to_flag(cast_type);
 
-	/* OSA only: */
-	if (!ipv) {
-		l3_hdr->flags |= QETH_HDR_PASSTHRU;
-		return;
-	}
-
-	rcu_read_lock();
 	if (ipv == 4) {
-		struct rtable *rt = skb_rtable(skb);
-
-		*((__be32 *) &hdr->hdr.l3.next_hop.ipv4.addr) = (rt) ?
-				rt_nexthop(rt, ip_hdr(skb)->daddr) :
-				ip_hdr(skb)->daddr;
-	} else {
-		/* IPv6 */
-		const struct rt6_info *rt = skb_rt6_info(skb);
-
-		if (rt && !ipv6_addr_any(&rt->rt6i_gateway))
-			l3_hdr->next_hop.ipv6_addr = rt->rt6i_gateway;
-		else
-			l3_hdr->next_hop.ipv6_addr = ipv6_hdr(skb)->daddr;
+		qeth_l3_get_next_hop_v4(skb, &l3_hdr->next_hop.ipv4.addr);
+	} else if (ipv == 6) {
+		qeth_l3_get_next_hop_v6(skb, &l3_hdr->next_hop.ipv6_addr);
 
 		hdr->hdr.l3.flags |= QETH_HDR_IPV6;
 		if (!IS_IQD(card))
 			hdr->hdr.l3.flags |= QETH_HDR_PASSTHRU;
+	} else {
+		/* OSA only */
+		l3_hdr->flags |= QETH_HDR_PASSTHRU;
 	}
-	rcu_read_unlock();
 }
 
 static void qeth_l3_fixup_headers(struct sk_buff *skb)
-- 
2.17.1

