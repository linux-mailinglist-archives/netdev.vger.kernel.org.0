Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D3A6692F7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbjAMJaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240818AbjAMJ2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:28:13 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3742915F35;
        Fri, 13 Jan 2023 01:25:03 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NtbZ24bHsznVLF;
        Fri, 13 Jan 2023 17:23:22 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 13 Jan 2023 17:24:59 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <willemb@google.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>
Subject: [PATCH bpf-next v3 1/2] bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
Date:   Fri, 13 Jan 2023 17:24:51 +0800
Message-ID: <b268ec7f0ff9431f4f43b1b40ab856ebb28cb4e1.1673574419.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673574419.git.william.xuanziyang@huawei.com>
References: <cover.1673574419.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
 include/uapi/linux/bpf.h       |  7 +++++++
 net/core/filter.c              | 31 ++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |  7 +++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 464ca3f01fe7..b6c1720a7abf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2644,6 +2644,11 @@ union bpf_attr {
  *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
  *		  L2 type as Ethernet.
  *
+ *		* **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
+ *		  **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
+ *		  Indicate the new IP header version after decapsulating the outer
+ *		  IP header. Used when the inner and outer IP versions are different.
+ *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
@@ -5803,6 +5808,8 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
 	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	= (1ULL << 6),
+	BPF_F_ADJ_ROOM_DECAP_L3_IPV4	= (1ULL << 7),
+	BPF_F_ADJ_ROOM_DECAP_L3_IPV6	= (1ULL << 8),
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index 43cc1fe58a2c..4c9c4e6b1f6c 100644
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
 
@@ -3608,6 +3621,22 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 		return -ENOTSUPP;
 	}
 
+	if (flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK) {
+		if (!shrink)
+			return -EINVAL;
+
+		switch (flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK) {
+		case BPF_F_ADJ_ROOM_DECAP_L3_IPV4:
+			len_min = sizeof(struct iphdr);
+			break;
+		case BPF_F_ADJ_ROOM_DECAP_L3_IPV6:
+			len_min = sizeof(struct ipv6hdr);
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
 	len_cur = skb->len - skb_network_offset(skb);
 	if ((shrink && (len_diff_abs >= len_cur ||
 			len_cur - len_diff_abs < len_min)) ||
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 464ca3f01fe7..fa9dc6b50fa8 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2644,6 +2644,11 @@ union bpf_attr {
  *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
  *		  L2 type as Ethernet.
  *
+ *		* **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
+ *		  **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
+ *		  Indicate the new IP header version after decapsulating the outer
+ *		  IP header. Used when the inner and outer IP versions are different.
+ *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
@@ -5803,6 +5808,8 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
 	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	= (1ULL << 6),
+	BPF_F_ADJ_ROOM_DECAP_L3_IPV4    = (1ULL << 7),
+	BPF_F_ADJ_ROOM_DECAP_L3_IPV6    = (1ULL << 8),
 };
 
 enum {
-- 
2.25.1

