Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D62646F96E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbhLJDDL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Dec 2021 22:03:11 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16353 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbhLJDDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 22:03:09 -0500
Received: from canpemm100002.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J9FwY37RJz91YY;
        Fri, 10 Dec 2021 10:58:53 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 canpemm100002.china.huawei.com (7.192.105.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 10:59:33 +0800
Received: from kwepemm600007.china.huawei.com ([7.193.23.208]) by
 kwepemm600007.china.huawei.com ([7.193.23.208]) with mapi id 15.01.2308.020;
 Fri, 10 Dec 2021 10:59:32 +0800
From:   "zhounan (E)" <zhounan14@huawei.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "bugs@openvswitch.org" <bugs@openvswitch.org>
CC:     "liucheng (J)" <liucheng11@huawei.com>,
        "Hejiajun (he jiajun, SOCF&uDF )" <hejiajun@huawei.com>,
        Lichunhe <lichunhe@huawei.com>,
        Gregory Rose <gvrose8192@gmail.com>,
        "pravin.ovn@gmail.com" <pravin.ovn@gmail.com>
Subject: [ovs-dev] [PATCH] datapath: fix crash when ipv6 fragment pkt
 recalculate L4 checksum
Thread-Topic: [ovs-dev] [PATCH] datapath: fix crash when ipv6 fragment pkt
 recalculate L4 checksum
Thread-Index: AdfmZtKXsQ9RrfMPQa+M3wuy8s7DzgAAPTXQAcH6SZA=
Date:   Fri, 10 Dec 2021 02:59:32 +0000
Message-ID: <396da6f61fa948ac854531e935921dfc@huawei.com>
References: <54c2ae5d003f49f6a29eec6a67c72315@huawei.com>
 <35aa84e0d1fe4bd1ad1bf6fb61c83338@huawei.com>
In-Reply-To: <35aa84e0d1fe4bd1ad1bf6fb61c83338@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.151.167]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhou Nan <zhounan14@huawei.com>

When we set ipv6 addr, we need to recalculate checksum of L4 header.
In our testcase, after send ipv6 fragment package, KASAN detect "use after free" when calling function update_ipv6_checksum, and crash occurred after a while.
If ipv6 package is fragment, and it is not first seg, we should not recalculate checksum of L4 header since this kind of package has no
L4 header.
To prevent crash, we set "recalc_csum" "false" when calling function "set_ipv6_addr".
We also find that function skb_ensure_writable (make sure L4 header is writable) is helpful before calling inet_proto_csum_replace16 to recalculate checksum.

Fixes: ada5efce102d6191e5c66fc385ba52a2d340ef50
       ("datapath: Fix IPv6 later frags parsing")

Signed-off-by: Zhou Nan <zhounan14@huawei.com>
---
 datapath/actions.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/datapath/actions.c b/datapath/actions.c index fbf4457..52cf03e 100644
--- a/datapath/actions.c
+++ b/datapath/actions.c
@@ -456,12 +456,21 @@ static void update_ipv6_checksum(struct sk_buff *skb, u8 l4_proto,
 				 __be32 addr[4], const __be32 new_addr[4])  {
 	int transport_len = skb->len - skb_transport_offset(skb);
+	int err;
 
 	if (l4_proto == NEXTHDR_TCP) {
+		err = skb_ensure_writable(skb, skb_transport_offset(skb) +
+				sizeof(struct tcphdr));
+		if (unlikely(err))
+			return;
 		if (likely(transport_len >= sizeof(struct tcphdr)))
 			inet_proto_csum_replace16(&tcp_hdr(skb)->check, skb,
 						  addr, new_addr, true);
 	} else if (l4_proto == NEXTHDR_UDP) {
+		err = skb_ensure_writable(skb, skb_transport_offset(skb) +
+				sizeof(struct udphdr));
+		if (unlikely(err))
+			return;
 		if (likely(transport_len >= sizeof(struct udphdr))) {
 			struct udphdr *uh = udp_hdr(skb);
 
@@ -473,6 +482,10 @@ static void update_ipv6_checksum(struct sk_buff *skb, u8 l4_proto,
 			}
 		}
 	} else if (l4_proto == NEXTHDR_ICMP) {
+		err = skb_ensure_writable(skb, skb_transport_offset(skb) +
+				sizeof(struct icmp6hdr));
+		if (unlikely(err))
+			return;
 		if (likely(transport_len >= sizeof(struct icmp6hdr)))
 			inet_proto_csum_replace16(&icmp6_hdr(skb)->icmp6_cksum,
 						  skb, addr, new_addr, true);
@@ -589,12 +602,15 @@ static int set_ipv6(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	if (is_ipv6_mask_nonzero(mask->ipv6_src)) {
 		__be32 *saddr = (__be32 *)&nh->saddr;
 		__be32 masked[4];
+		bool recalc_csum = true;
 
 		mask_ipv6_addr(saddr, key->ipv6_src, mask->ipv6_src, masked);
 
 		if (unlikely(memcmp(saddr, masked, sizeof(masked)))) {
+			if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+				recalc_csum = false;
 			set_ipv6_addr(skb, flow_key->ip.proto, saddr, masked,
-				      true);
+				      recalc_csum);
 			memcpy(&flow_key->ipv6.addr.src, masked,
 			       sizeof(flow_key->ipv6.addr.src));
 		}
@@ -614,6 +630,8 @@ static int set_ipv6(struct sk_buff *skb, struct sw_flow_key *flow_key,
 							     NEXTHDR_ROUTING,
 							     NULL, &flags)
 					       != NEXTHDR_ROUTING);
+			if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+				recalc_csum = false;
 
 			set_ipv6_addr(skb, flow_key->ip.proto, daddr, masked,
 				      recalc_csum);
--
2.27.0

