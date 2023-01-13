Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F48B6692FB
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241052AbjAMJaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbjAMJ2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:28:15 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22D21D0DE;
        Fri, 13 Jan 2023 01:25:17 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NtbZg3WZXzJrQK;
        Fri, 13 Jan 2023 17:23:55 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 13 Jan 2023 17:25:14 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <willemb@google.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>
Subject: [PATCH bpf-next v3 2/2] selftests/bpf: add ipip6 and ip6ip decap to test_tc_tunnel
Date:   Fri, 13 Jan 2023 17:25:10 +0800
Message-ID: <dfd2d8cfdf9111bd129170d4345296f53bee6a67.1673574419.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673574419.git.william.xuanziyang@huawei.com>
References: <cover.1673574419.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ipip6 and ip6ip decap testcases. Verify that bpf_skb_adjust_room()
correctly decapsulate ipip6 and ip6ip tunnel packets.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 .../selftests/bpf/progs/test_tc_tunnel.c      | 91 ++++++++++++++++++-
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 15 +--
 2 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
index a0e7762b1e5a..e6e678aa9874 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
@@ -38,6 +38,10 @@ static const int cfg_udp_src = 20000;
 #define	VXLAN_FLAGS     0x8
 #define	VXLAN_VNI       1
 
+#ifndef NEXTHDR_DEST
+#define NEXTHDR_DEST	60
+#endif
+
 /* MPLS label 1000 with S bit (last label) set and ttl of 255. */
 static const __u32 mpls_label = __bpf_constant_htonl(1000 << 12 |
 						     MPLS_LS_S_MASK | 0xff);
@@ -363,6 +367,61 @@ static __always_inline int __encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
 	return TC_ACT_OK;
 }
 
+static int encap_ipv6_ipip6(struct __sk_buff *skb)
+{
+	struct iphdr iph_inner;
+	struct v6hdr h_outer;
+	struct tcphdr tcph;
+	struct ethhdr eth;
+	__u64 flags;
+	int olen;
+
+	if (bpf_skb_load_bytes(skb, ETH_HLEN, &iph_inner,
+			       sizeof(iph_inner)) < 0)
+		return TC_ACT_OK;
+
+	/* filter only packets we want */
+	if (bpf_skb_load_bytes(skb, ETH_HLEN + (iph_inner.ihl << 2),
+			       &tcph, sizeof(tcph)) < 0)
+		return TC_ACT_OK;
+
+	if (tcph.dest != __bpf_constant_htons(cfg_port))
+		return TC_ACT_OK;
+
+	olen = sizeof(h_outer.ip);
+
+	flags = BPF_F_ADJ_ROOM_FIXED_GSO | BPF_F_ADJ_ROOM_ENCAP_L3_IPV6;
+
+	/* add room between mac and network header */
+	if (bpf_skb_adjust_room(skb, olen, BPF_ADJ_ROOM_MAC, flags))
+		return TC_ACT_SHOT;
+
+	/* prepare new outer network header */
+	memset(&h_outer.ip, 0, sizeof(h_outer.ip));
+	h_outer.ip.version = 6;
+	h_outer.ip.hop_limit = iph_inner.ttl;
+	h_outer.ip.saddr.s6_addr[1] = 0xfd;
+	h_outer.ip.saddr.s6_addr[15] = 1;
+	h_outer.ip.daddr.s6_addr[1] = 0xfd;
+	h_outer.ip.daddr.s6_addr[15] = 2;
+	h_outer.ip.payload_len = iph_inner.tot_len;
+	h_outer.ip.nexthdr = IPPROTO_IPIP;
+
+	/* store new outer network header */
+	if (bpf_skb_store_bytes(skb, ETH_HLEN, &h_outer, olen,
+				BPF_F_INVALIDATE_HASH) < 0)
+		return TC_ACT_SHOT;
+
+	/* update eth->h_proto */
+	if (bpf_skb_load_bytes(skb, 0, &eth, sizeof(eth)) < 0)
+		return TC_ACT_SHOT;
+	eth.h_proto = bpf_htons(ETH_P_IPV6);
+	if (bpf_skb_store_bytes(skb, 0, &eth, sizeof(eth), 0) < 0)
+		return TC_ACT_SHOT;
+
+	return TC_ACT_OK;
+}
+
 static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
 				      __u16 l2_proto)
 {
@@ -461,6 +520,15 @@ int __encap_ip6tnl_none(struct __sk_buff *skb)
 		return TC_ACT_OK;
 }
 
+SEC("encap_ipip6_none")
+int __encap_ipip6_none(struct __sk_buff *skb)
+{
+	if (skb->protocol == __bpf_constant_htons(ETH_P_IP))
+		return encap_ipv6_ipip6(skb);
+	else
+		return TC_ACT_OK;
+}
+
 SEC("encap_ip6gre_none")
 int __encap_ip6gre_none(struct __sk_buff *skb)
 {
@@ -528,13 +596,33 @@ int __encap_ip6vxlan_eth(struct __sk_buff *skb)
 
 static int decap_internal(struct __sk_buff *skb, int off, int len, char proto)
 {
+	__u64 flags = BPF_F_ADJ_ROOM_FIXED_GSO;
+	struct ipv6_opt_hdr ip6_opt_hdr;
 	struct gre_hdr greh;
 	struct udphdr udph;
 	int olen = len;
 
 	switch (proto) {
 	case IPPROTO_IPIP:
+		flags |= BPF_F_ADJ_ROOM_DECAP_L3_IPV4;
+		break;
 	case IPPROTO_IPV6:
+		flags |= BPF_F_ADJ_ROOM_DECAP_L3_IPV6;
+		break;
+	case NEXTHDR_DEST:
+		if (bpf_skb_load_bytes(skb, off + len, &ip6_opt_hdr,
+				       sizeof(ip6_opt_hdr)) < 0)
+			return TC_ACT_OK;
+		switch (ip6_opt_hdr.nexthdr) {
+		case IPPROTO_IPIP:
+			flags |= BPF_F_ADJ_ROOM_DECAP_L3_IPV4;
+			break;
+		case IPPROTO_IPV6:
+			flags |= BPF_F_ADJ_ROOM_DECAP_L3_IPV6;
+			break;
+		default:
+			return TC_ACT_OK;
+		}
 		break;
 	case IPPROTO_GRE:
 		olen += sizeof(struct gre_hdr);
@@ -569,8 +657,7 @@ static int decap_internal(struct __sk_buff *skb, int off, int len, char proto)
 		return TC_ACT_OK;
 	}
 
-	if (bpf_skb_adjust_room(skb, -olen, BPF_ADJ_ROOM_MAC,
-				BPF_F_ADJ_ROOM_FIXED_GSO))
+	if (bpf_skb_adjust_room(skb, -olen, BPF_ADJ_ROOM_MAC, flags))
 		return TC_ACT_SHOT;
 
 	return TC_ACT_OK;
diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh b/tools/testing/selftests/bpf/test_tc_tunnel.sh
index 334bdfeab940..910044f08908 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -100,6 +100,9 @@ if [[ "$#" -eq "0" ]]; then
 	echo "ipip"
 	$0 ipv4 ipip none 100
 
+	echo "ipip6"
+	$0 ipv4 ipip6 none 100
+
 	echo "ip6ip6"
 	$0 ipv6 ip6tnl none 100
 
@@ -224,6 +227,9 @@ elif [[ "$tuntype" =~ "gre" && "$mac" == "eth" ]]; then
 elif [[ "$tuntype" =~ "vxlan" && "$mac" == "eth" ]]; then
 	ttype="vxlan"
 	targs="id 1 dstport 8472 udp6zerocsumrx"
+elif [[ "$tuntype" == "ipip6" ]]; then
+	ttype="ip6tnl"
+	targs=""
 else
 	ttype=$tuntype
 	targs=""
@@ -233,6 +239,9 @@ fi
 if [[ "${tuntype}" == "sit" ]]; then
 	link_addr1="${ns1_v4}"
 	link_addr2="${ns2_v4}"
+elif [[ "${tuntype}" == "ipip6" ]]; then
+	link_addr1="${ns1_v6}"
+	link_addr2="${ns2_v6}"
 else
 	link_addr1="${addr1}"
 	link_addr2="${addr2}"
@@ -287,12 +296,6 @@ else
 	server_listen
 fi
 
-# bpf_skb_net_shrink does not take tunnel flags yet, cannot update L3.
-if [[ "${tuntype}" == "sit" ]]; then
-	echo OK
-	exit 0
-fi
-
 # serverside, use BPF for decap
 ip netns exec "${ns2}" ip link del dev testtun0
 ip netns exec "${ns2}" tc qdisc add dev veth2 clsact
-- 
2.25.1

