Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4246BC3F
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 14:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGQM03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 08:26:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbfGQM03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 08:26:29 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6HCImQ0007527
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 08:26:28 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tt2kau453-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 08:26:28 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 17 Jul 2019 13:26:25 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 17 Jul 2019 13:26:23 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6HCQMlb62783544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 12:26:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED91742041;
        Wed, 17 Jul 2019 12:26:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB2CF42042;
        Wed, 17 Jul 2019 12:26:21 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.96.15])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jul 2019 12:26:21 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf] selftests/bpf: fix test_xdp_noinline on s390
Date:   Wed, 17 Jul 2019 14:26:20 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071712-0008-0000-0000-000002FE5109
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071712-0009-0000-0000-0000226BCB84
Message-Id: <20190717122620.58792-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-17_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907170151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_xdp_noinline fails on s390 due to a handful of endianness issues.
Use ntohs for parsing eth_proto.
Replace bswaps with ntohs/htons.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
---
 .../selftests/bpf/progs/test_xdp_noinline.c     | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index dad8a7e33eaa..e88d7b9d65ab 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -14,6 +14,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include "bpf_helpers.h"
+#include "bpf_endian.h"
 
 static __u32 rol32(__u32 word, unsigned int shift)
 {
@@ -305,7 +306,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
 	ip6h->nexthdr = IPPROTO_IPV6;
 	ip_suffix = pckt->flow.srcv6[3] ^ pckt->flow.port16[0];
 	ip6h->payload_len =
-	    __builtin_bswap16(pkt_bytes + sizeof(struct ipv6hdr));
+	    bpf_htons(pkt_bytes + sizeof(struct ipv6hdr));
 	ip6h->hop_limit = 4;
 
 	ip6h->saddr.in6_u.u6_addr32[0] = 1;
@@ -322,7 +323,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
 	      struct real_definition *dst, __u32 pkt_bytes)
 {
 
-	__u32 ip_suffix = __builtin_bswap16(pckt->flow.port16[0]);
+	__u32 ip_suffix = bpf_ntohs(pckt->flow.port16[0]);
 	struct eth_hdr *new_eth;
 	struct eth_hdr *old_eth;
 	__u16 *next_iph_u16;
@@ -352,7 +353,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
 	iph->protocol = IPPROTO_IPIP;
 	iph->check = 0;
 	iph->tos = 1;
-	iph->tot_len = __builtin_bswap16(pkt_bytes + sizeof(struct iphdr));
+	iph->tot_len = bpf_htons(pkt_bytes + sizeof(struct iphdr));
 	/* don't update iph->daddr, since it will overwrite old eth_proto
 	 * and multiple iterations of bpf_prog_run() will fail
 	 */
@@ -639,7 +640,7 @@ static int process_l3_headers_v6(struct packet_description *pckt,
 	iph_len = sizeof(struct ipv6hdr);
 	*protocol = ip6h->nexthdr;
 	pckt->flow.proto = *protocol;
-	*pkt_bytes = __builtin_bswap16(ip6h->payload_len);
+	*pkt_bytes = bpf_ntohs(ip6h->payload_len);
 	off += iph_len;
 	if (*protocol == 45) {
 		return XDP_DROP;
@@ -671,7 +672,7 @@ static int process_l3_headers_v4(struct packet_description *pckt,
 		return XDP_DROP;
 	*protocol = iph->protocol;
 	pckt->flow.proto = *protocol;
-	*pkt_bytes = __builtin_bswap16(iph->tot_len);
+	*pkt_bytes = bpf_ntohs(iph->tot_len);
 	off += 20;
 	if (iph->frag_off & 65343)
 		return XDP_DROP;
@@ -808,10 +809,10 @@ int balancer_ingress(struct xdp_md *ctx)
 	nh_off = sizeof(struct eth_hdr);
 	if (data + nh_off > data_end)
 		return XDP_DROP;
-	eth_proto = eth->eth_proto;
-	if (eth_proto == 8)
+	eth_proto = bpf_ntohs(eth->eth_proto);
+	if (eth_proto == ETH_P_IP)
 		return process_packet(data, nh_off, data_end, 0, ctx);
-	else if (eth_proto == 56710)
+	else if (eth_proto == ETH_P_IPV6)
 		return process_packet(data, nh_off, data_end, 1, ctx);
 	else
 		return XDP_DROP;
-- 
2.21.0

