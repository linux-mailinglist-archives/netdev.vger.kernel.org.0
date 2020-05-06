Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8251C6B12
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgEFIKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:10:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728699AbgEFIJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:09:59 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046839VZ069375;
        Wed, 6 May 2020 04:09:58 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8syvuh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:09:58 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04685YOa030027;
        Wed, 6 May 2020 08:09:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 30s0g5kh3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 08:09:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04689rof65143062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 08:09:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17AFBA4054;
        Wed,  6 May 2020 08:09:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0898A4064;
        Wed,  6 May 2020 08:09:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 08:09:52 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 04/10] s390/qeth: extract helpers for next-hop lookup
Date:   Wed,  6 May 2020 10:09:43 +0200
Message-Id: <20200506080949.3915-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506080949.3915-1-jwi@linux.ibm.com>
References: <20200506080949.3915-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_02:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These will be used in a subsequent patch.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    | 29 ++++++++++++++++++++++-------
 drivers/s390/net/qeth_l3_main.c | 18 +++++-------------
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 3d8b8e0f2438..6b0d37d2c638 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -34,6 +34,7 @@
 #include <net/ipv6.h>
 #include <net/if_inet6.h>
 #include <net/addrconf.h>
+#include <net/route.h>
 #include <net/sch_generic.h>
 #include <net/tcp.h>
 
@@ -234,11 +235,7 @@ struct qeth_hdr_layer3 {
 	__u16 frame_offset;
 	union {
 		/* TX: */
-		struct in6_addr ipv6_addr;
-		struct ipv4 {
-			u8 res[12];
-			u32 addr;
-		} ipv4;
+		struct in6_addr addr;
 		/* RX: */
 		struct rx {
 			u8 res1[2];
@@ -355,8 +352,7 @@ static inline bool qeth_l3_same_next_hop(struct qeth_hdr_layer3 *h1,
 					 struct qeth_hdr_layer3 *h2)
 {
 	return !((h1->flags ^ h2->flags) & QETH_HDR_IPV6) &&
-	       ipv6_addr_equal(&h1->next_hop.ipv6_addr,
-			       &h2->next_hop.ipv6_addr);
+	       ipv6_addr_equal(&h1->next_hop.addr, &h2->next_hop.addr);
 }
 
 struct qeth_local_addr {
@@ -945,6 +941,25 @@ static inline struct dst_entry *qeth_dst_check_rcu(struct sk_buff *skb, int ipv)
 	return dst;
 }
 
+static inline __be32 qeth_next_hop_v4_rcu(struct sk_buff *skb,
+					  struct dst_entry *dst)
+{
+	struct rtable *rt = (struct rtable *) dst;
+
+	return (rt) ? rt_nexthop(rt, ip_hdr(skb)->daddr) : ip_hdr(skb)->daddr;
+}
+
+static inline struct in6_addr *qeth_next_hop_v6_rcu(struct sk_buff *skb,
+						    struct dst_entry *dst)
+{
+	struct rt6_info *rt = (struct rt6_info *) dst;
+
+	if (rt && !ipv6_addr_any(&rt->rt6i_gateway))
+		return &rt->rt6i_gateway;
+	else
+		return &ipv6_hdr(skb)->daddr;
+}
+
 static inline void qeth_tx_csum(struct sk_buff *skb, u8 *flags, int ipv)
 {
 	*flags |= QETH_HDR_EXT_CSUM_TRANSP_REQ;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index fec4ac41e946..1e50aa0297a3 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1694,8 +1694,8 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 
 		if (skb->protocol == htons(ETH_P_AF_IUCV)) {
 			l3_hdr->flags = QETH_HDR_IPV6 | QETH_CAST_UNICAST;
-			l3_hdr->next_hop.ipv6_addr.s6_addr16[0] = htons(0xfe80);
-			memcpy(&l3_hdr->next_hop.ipv6_addr.s6_addr32[2],
+			l3_hdr->next_hop.addr.s6_addr16[0] = htons(0xfe80);
+			memcpy(&l3_hdr->next_hop.addr.s6_addr32[2],
 			       iucv_trans_hdr(skb)->destUserID, 8);
 			return;
 		}
@@ -1729,18 +1729,10 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 	l3_hdr->flags |= qeth_l3_cast_type_to_flag(cast_type);
 
 	if (ipv == 4) {
-		struct rtable *rt = (struct rtable *) dst;
-
-		*((__be32 *) &hdr->hdr.l3.next_hop.ipv4.addr) = (rt) ?
-				rt_nexthop(rt, ip_hdr(skb)->daddr) :
-				ip_hdr(skb)->daddr;
+		l3_hdr->next_hop.addr.s6_addr32[3] =
+					qeth_next_hop_v4_rcu(skb, dst);
 	} else if (ipv == 6) {
-		struct rt6_info *rt = (struct rt6_info *) dst;
-
-		if (rt && !ipv6_addr_any(&rt->rt6i_gateway))
-			l3_hdr->next_hop.ipv6_addr = rt->rt6i_gateway;
-		else
-			l3_hdr->next_hop.ipv6_addr = ipv6_hdr(skb)->daddr;
+		l3_hdr->next_hop.addr = *qeth_next_hop_v6_rcu(skb, dst);
 
 		hdr->hdr.l3.flags |= QETH_HDR_IPV6;
 		if (!IS_IQD(card))
-- 
2.17.1

