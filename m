Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A15335C07
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 13:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfFELtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 07:49:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727461AbfFELtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 07:49:12 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x55BlFSc081991
        for <netdev@vger.kernel.org>; Wed, 5 Jun 2019 07:49:11 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sxb4an3yq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 07:49:10 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 5 Jun 2019 12:49:06 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Jun 2019 12:49:04 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x55Bn2sX59834544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jun 2019 11:49:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEA994204F;
        Wed,  5 Jun 2019 11:49:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7092A4203F;
        Wed,  5 Jun 2019 11:49:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jun 2019 11:49:02 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v3 net 2/4] s390/qeth: check dst entry before use
Date:   Wed,  5 Jun 2019 13:48:49 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190605114851.56641-1-jwi@linux.ibm.com>
References: <20190605114851.56641-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060511-0020-0000-0000-000003461485
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060511-0021-0000-0000-00002199234B
Message-Id: <20190605114851.56641-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050075
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

Fix-up the various call sites to first validate the dst entry with
dst_check(), and fall back accordingly.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
v1 -> v2: prefer dst_check() over dst->obsolete (davem)
v2 -> v3: use the dst entry that dst_check() returns (davem)

 drivers/s390/net/qeth_l3_main.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 2df67abdfde7..13bf3e2e9cea 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1888,13 +1888,20 @@ static int qeth_l3_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 static int qeth_l3_get_cast_type(struct sk_buff *skb)
 {
+	int ipv = qeth_get_ip_version(skb);
 	struct neighbour *n = NULL;
 	struct dst_entry *dst;
 
 	rcu_read_lock();
 	dst = skb_dst(skb);
-	if (dst)
-		n = dst_neigh_lookup_skb(dst, skb);
+	if (dst) {
+		struct rt6_info *rt = (struct rt6_info *) dst;
+
+		dst = dst_check(dst, (ipv == 6) ? rt6_get_cookie(rt) : 0);
+		if (dst)
+			n = dst_neigh_lookup_skb(dst, skb);
+	}
+
 	if (n) {
 		int cast_type = n->type;
 
@@ -1909,7 +1916,7 @@ static int qeth_l3_get_cast_type(struct sk_buff *skb)
 	rcu_read_unlock();
 
 	/* no neighbour (eg AF_PACKET), fall back to target's IP address ... */
-	switch (qeth_get_ip_version(skb)) {
+	switch (ipv) {
 	case 4:
 		if (ipv4_is_lbcast(ip_hdr(skb)->daddr))
 			return RTN_BROADCAST;
@@ -1942,6 +1949,7 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 	struct qeth_hdr_layer3 *l3_hdr = &hdr->hdr.l3;
 	struct vlan_ethhdr *veth = vlan_eth_hdr(skb);
 	struct qeth_card *card = queue->card;
+	struct dst_entry *dst;
 
 	hdr->hdr.l3.length = data_len;
 
@@ -1987,15 +1995,27 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 	}
 
 	rcu_read_lock();
+	dst = skb_dst(skb);
+
 	if (ipv == 4) {
-		struct rtable *rt = skb_rtable(skb);
+		struct rtable *rt;
+
+		if (dst)
+			dst = dst_check(dst, 0);
+		rt = (struct rtable *) dst;
 
 		*((__be32 *) &hdr->hdr.l3.next_hop.ipv4.addr) = (rt) ?
 				rt_nexthop(rt, ip_hdr(skb)->daddr) :
 				ip_hdr(skb)->daddr;
 	} else {
 		/* IPv6 */
-		const struct rt6_info *rt = skb_rt6_info(skb);
+		struct rt6_info *rt;
+
+		if (dst) {
+			rt = (struct rt6_info *) dst;
+			dst = dst_check(dst, rt6_get_cookie(rt));
+		}
+		rt = (struct rt6_info *) dst;
 
 		if (rt && !ipv6_addr_any(&rt->rt6i_gateway))
 			l3_hdr->next_hop.ipv6_addr = rt->rt6i_gateway;
-- 
2.17.1

