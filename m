Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB1A58529
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfF0PEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:04:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42840 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726443AbfF0PEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:04:55 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RF4WZp114804
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:04:54 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tcy16c43e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:04:47 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:44 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:40 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1dBo60621040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5CB1A406A;
        Thu, 27 Jun 2019 15:01:38 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD439A4068;
        Thu, 27 Jun 2019 15:01:38 +0000 (GMT)
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
Subject: [PATCH net-next 11/12] s390/qeth: extract helper for route validation
Date:   Thu, 27 Jun 2019 17:01:32 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0016-0000-0000-0000028D0D0E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0017-0000-0000-000032EA8BAA
Message-Id: <20190627150133.58746-12-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As follow-up to commit 0cd6783d3c7d ("s390/qeth: check dst entry before use"),
consolidate the dst_check() logic into a single helper and add a wrapper
around the cast type selection.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    | 13 +++++++++
 drivers/s390/net/qeth_l3_main.c | 49 ++++++++++++++-------------------
 2 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index c81d5ec26803..d354b39cdf4b 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -25,6 +25,8 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
+#include <net/dst.h>
+#include <net/ip6_fib.h>
 #include <net/ipv6.h>
 #include <net/if_inet6.h>
 #include <net/addrconf.h>
@@ -877,6 +879,17 @@ static inline int qeth_get_ether_cast_type(struct sk_buff *skb)
 	return RTN_UNICAST;
 }
 
+static inline struct dst_entry *qeth_dst_check_rcu(struct sk_buff *skb, int ipv)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct rt6_info *rt;
+
+	rt = (struct rt6_info *) dst;
+	if (dst)
+		dst = dst_check(dst, (ipv == 6) ? rt6_get_cookie(rt) : 0);
+	return dst;
+}
+
 static inline void qeth_rx_csum(struct qeth_card *card, struct sk_buff *skb,
 				u8 flags)
 {
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 15351922b209..5bf5129ddcd4 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -32,7 +32,6 @@
 #include <net/route.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
-#include <net/ip6_fib.h>
 #include <net/iucv/af_iucv.h>
 #include <linux/hashtable.h>
 
@@ -1878,26 +1877,17 @@ static int qeth_l3_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	return rc;
 }
 
-static int qeth_l3_get_cast_type(struct sk_buff *skb)
+static int qeth_l3_get_cast_type_rcu(struct sk_buff *skb, struct dst_entry *dst,
+				     int ipv)
 {
-	int ipv = qeth_get_ip_version(skb);
 	struct neighbour *n = NULL;
-	struct dst_entry *dst;
 
-	rcu_read_lock();
-	dst = skb_dst(skb);
-	if (dst) {
-		struct rt6_info *rt = (struct rt6_info *) dst;
-
-		dst = dst_check(dst, (ipv == 6) ? rt6_get_cookie(rt) : 0);
-		if (dst)
-			n = dst_neigh_lookup_skb(dst, skb);
-	}
+	if (dst)
+		n = dst_neigh_lookup_skb(dst, skb);
 
 	if (n) {
 		int cast_type = n->type;
 
-		rcu_read_unlock();
 		neigh_release(n);
 		if ((cast_type == RTN_BROADCAST) ||
 		    (cast_type == RTN_MULTICAST) ||
@@ -1905,7 +1895,6 @@ static int qeth_l3_get_cast_type(struct sk_buff *skb)
 			return cast_type;
 		return RTN_UNICAST;
 	}
-	rcu_read_unlock();
 
 	/* no neighbour (eg AF_PACKET), fall back to target's IP address ... */
 	switch (ipv) {
@@ -1923,6 +1912,20 @@ static int qeth_l3_get_cast_type(struct sk_buff *skb)
 	}
 }
 
+static int qeth_l3_get_cast_type(struct sk_buff *skb)
+{
+	int ipv = qeth_get_ip_version(skb);
+	struct dst_entry *dst;
+	int cast_type;
+
+	rcu_read_lock();
+	dst = qeth_dst_check_rcu(skb, ipv);
+	cast_type = qeth_l3_get_cast_type_rcu(skb, dst, ipv);
+	rcu_read_unlock();
+
+	return cast_type;
+}
+
 static u8 qeth_l3_cast_type_to_flag(int cast_type)
 {
 	if (cast_type == RTN_MULTICAST)
@@ -1987,27 +1990,17 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 	}
 
 	rcu_read_lock();
-	dst = skb_dst(skb);
+	dst = qeth_dst_check_rcu(skb, ipv);
 
 	if (ipv == 4) {
-		struct rtable *rt;
-
-		if (dst)
-			dst = dst_check(dst, 0);
-		rt = (struct rtable *) dst;
+		struct rtable *rt = (struct rtable *) dst;
 
 		*((__be32 *) &hdr->hdr.l3.next_hop.ipv4.addr) = (rt) ?
 				rt_nexthop(rt, ip_hdr(skb)->daddr) :
 				ip_hdr(skb)->daddr;
 	} else {
 		/* IPv6 */
-		struct rt6_info *rt;
-
-		if (dst) {
-			rt = (struct rt6_info *) dst;
-			dst = dst_check(dst, rt6_get_cookie(rt));
-		}
-		rt = (struct rt6_info *) dst;
+		struct rt6_info *rt = (struct rt6_info *) dst;
 
 		if (rt && !ipv6_addr_any(&rt->rt6i_gateway))
 			l3_hdr->next_hop.ipv6_addr = rt->rt6i_gateway;
-- 
2.17.1

