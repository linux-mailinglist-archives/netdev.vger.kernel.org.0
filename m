Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081196655A5
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbjAKIDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbjAKICW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:02:22 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2FF102E;
        Wed, 11 Jan 2023 00:01:41 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NsKpr1VrRz16Lxp;
        Wed, 11 Jan 2023 16:00:04 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 11 Jan 2023 16:01:37 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <willemb@google.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>
Subject: [PATCH bpf-next v2 1/2] bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
Date:   Wed, 11 Jan 2023 16:01:33 +0800
Message-ID: <b231c7d0acacd702284158cd44734e72ef661a01.1673423199.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673423199.git.william.xuanziyang@huawei.com>
References: <cover.1673423199.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
Main use case is for using cls_bpf on ingress hook to decapsulate
IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.

Add two new flags BPF_F_ADJ_ROOM_DECAP_L3_IPV{4,6} to indicate the
new IP header version after decapsulating the outer IP header.

Suggested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 include/uapi/linux/bpf.h       |  8 ++++++++
 net/core/filter.c              | 26 +++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 464ca3f01fe7..dde1c2ea1c84 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2644,6 +2644,12 @@ union bpf_attr {
  *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
  *		  L2 type as Ethernet.
  *
+ *              * **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
+ *                **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
+ *                Indicate the new IP header version after decapsulating the
+ *                outer IP header. Mainly used in scenarios that the inner and
+ *                outer IP versions are different.
+ *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
@@ -5803,6 +5809,8 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
 	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	= (1ULL << 6),
+	BPF_F_ADJ_ROOM_DECAP_L3_IPV4	= (1ULL << 7),
+	BPF_F_ADJ_ROOM_DECAP_L3_IPV6	= (1ULL << 8),
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index 43cc1fe58a2c..5fb113953f80 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3381,13 +3381,17 @@ static u32 bpf_skb_net_base_len(const struct sk_buff *skb)
 #define BPF_F_ADJ_ROOM_ENCAP_L3_MASK	(BPF_F_ADJ_ROOM_ENCAP_L3_IPV4 | \
 					 BPF_F_ADJ_ROOM_ENCAP_L3_IPV6)
 
+#define BPF_F_ADJ_ROOM_DECAP_L3_MASK	(BPF_F_ADJ_ROOM_DECAP_L3_IPV4 | \
+					 BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
+
 #define BPF_F_ADJ_ROOM_MASK		(BPF_F_ADJ_ROOM_FIXED_GSO | \
 					 BPF_F_ADJ_ROOM_ENCAP_L3_MASK | \
 					 BPF_F_ADJ_ROOM_ENCAP_L4_GRE | \
 					 BPF_F_ADJ_ROOM_ENCAP_L4_UDP | \
 					 BPF_F_ADJ_ROOM_ENCAP_L2_ETH | \
 					 BPF_F_ADJ_ROOM_ENCAP_L2( \
-					  BPF_ADJ_ROOM_ENCAP_L2_MASK))
+					  BPF_ADJ_ROOM_ENCAP_L2_MASK) | \
+					 BPF_F_ADJ_ROOM_DECAP_L3_MASK)
 
 static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 			    u64 flags)
@@ -3501,6 +3505,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 	int ret;
 
 	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
+			       BPF_F_ADJ_ROOM_DECAP_L3_MASK |
 			       BPF_F_ADJ_ROOM_NO_CSUM_RESET)))
 		return -EINVAL;
 
@@ -3519,6 +3524,14 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 	if (unlikely(ret < 0))
 		return ret;
 
+	/* Match skb->protocol to new outer l3 protocol */
+	if (skb->protocol == htons(ETH_P_IP) &&
+	    flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
+		skb->protocol = htons(ETH_P_IPV6);
+	else if (skb->protocol == htons(ETH_P_IPV6) &&
+		 flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4)
+		skb->protocol = htons(ETH_P_IP);
+
 	if (skb_is_gso(skb)) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
@@ -3596,6 +3609,10 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 	if (unlikely(proto != htons(ETH_P_IP) &&
 		     proto != htons(ETH_P_IPV6)))
 		return -ENOTSUPP;
+	if (unlikely((shrink && ((flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK) ==
+		      BPF_F_ADJ_ROOM_DECAP_L3_MASK)) || (!shrink &&
+		      flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK)))
+		return -EINVAL;
 
 	off = skb_mac_header_len(skb);
 	switch (mode) {
@@ -3608,6 +3625,13 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 		return -ENOTSUPP;
 	}
 
+	if (shrink) {
+		if (flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
+			len_min = sizeof(struct ipv6hdr);
+		else if (flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4)
+			len_min = sizeof(struct iphdr);
+	}
+
 	len_cur = skb->len - skb_network_offset(skb);
 	if ((shrink && (len_diff_abs >= len_cur ||
 			len_cur - len_diff_abs < len_min)) ||
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 464ca3f01fe7..22672e5c8466 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2644,6 +2644,12 @@ union bpf_attr {
  *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
  *		  L2 type as Ethernet.
  *
+ *              * **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
+ *                **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
+ *                Indicate the new IP header version after decapsulating the
+ *                outer IP header. Mainly used in scenarios that the inner and
+ *                outer IP versions are different.
+ *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
@@ -5803,6 +5809,8 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
 	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	= (1ULL << 6),
+	BPF_F_ADJ_ROOM_DECAP_L3_IPV4    = (1ULL << 7),
+	BPF_F_ADJ_ROOM_DECAP_L3_IPV6    = (1ULL << 8),
 };
 
 enum {
-- 
2.25.1

