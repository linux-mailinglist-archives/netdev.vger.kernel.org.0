Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C38265FA86
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjAFDz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjAFDzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:55:54 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37456B5B4;
        Thu,  5 Jan 2023 19:55:53 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Np8bg3FN5znV5l;
        Fri,  6 Jan 2023 11:54:23 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 6 Jan 2023 11:55:51 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>
Subject: [PATCH bpf-next 2/2] selftests/bpf: add ipip6 and ip6ip decap to test_tc_tunnel
Date:   Fri, 6 Jan 2023 11:55:47 +0800
Message-ID: <8c669b9c5e8ff517bcdc210303be10dbb1105aee.1672976410.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1672976410.git.william.xuanziyang@huawei.com>
References: <cover.1672976410.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
 .../selftests/bpf/progs/test_tc_tunnel.c      | 64 +++++++++++++++++++
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 15 +++--
 2 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
index a0e7762b1e5a..1d24f1bee186 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
@@ -363,6 +363,61 @@ static __always_inline int __encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
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
@@ -461,6 +516,15 @@ int __encap_ip6tnl_none(struct __sk_buff *skb)
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

