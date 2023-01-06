Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8810465FA84
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjAFDzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjAFDzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:55:42 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD116B582;
        Thu,  5 Jan 2023 19:55:41 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Np8XV1BTvzJq5w;
        Fri,  6 Jan 2023 11:51:38 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 6 Jan 2023 11:55:39 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>
Subject: [PATCH bpf-next 1/2] bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
Date:   Fri, 6 Jan 2023 11:55:34 +0800
Message-ID: <7e9ca6837b20bea661248957dbbd1db198e3d1f8.1672976410.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1672976410.git.william.xuanziyang@huawei.com>
References: <cover.1672976410.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/core/filter.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 929358677183..73982fb4fe2e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3495,6 +3495,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 			      u64 flags)
 {
+	union {
+		struct iphdr *v4;
+		struct ipv6hdr *v6;
+		unsigned char *hdr;
+	} ip;
+	__be16 proto;
 	int ret;
 
 	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
@@ -3512,10 +3518,19 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 	if (unlikely(ret < 0))
 		return ret;
 
+	ip.hdr = skb_inner_network_header(skb);
+	if (ip.v4->version == 4)
+		proto = htons(ETH_P_IP);
+	else
+		proto = htons(ETH_P_IPV6);
+
 	ret = bpf_skb_net_hdr_pop(skb, off, len_diff);
 	if (unlikely(ret < 0))
 		return ret;
 
+	/* Match skb->protocol to new outer l3 protocol */
+	skb->protocol = proto;
+
 	if (skb_is_gso(skb)) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
@@ -3578,10 +3593,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 	   u32, mode, u64, flags)
 {
 	u32 len_cur, len_diff_abs = abs(len_diff);
-	u32 len_min = bpf_skb_net_base_len(skb);
-	u32 len_max = BPF_SKB_MAX_LEN;
+	u32 len_min, len_max = BPF_SKB_MAX_LEN;
 	__be16 proto = skb->protocol;
 	bool shrink = len_diff < 0;
+	union {
+		struct iphdr *v4;
+		struct ipv6hdr *v6;
+		unsigned char *hdr;
+	} ip;
 	u32 off;
 	int ret;
 
@@ -3594,6 +3613,9 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 		     proto != htons(ETH_P_IPV6)))
 		return -ENOTSUPP;
 
+	if (unlikely(shrink && !skb->encapsulation))
+		return -ENOTSUPP;
+
 	off = skb_mac_header_len(skb);
 	switch (mode) {
 	case BPF_ADJ_ROOM_NET:
@@ -3605,6 +3627,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 		return -ENOTSUPP;
 	}
 
+	if (shrink) {
+		ip.hdr = skb_inner_network_header(skb);
+		if (ip.v4->version == 4)
+			len_min = sizeof(struct iphdr);
+		else
+			len_min = sizeof(struct ipv6hdr);
+	}
+
 	len_cur = skb->len - skb_network_offset(skb);
 	if ((shrink && (len_diff_abs >= len_cur ||
 			len_cur - len_diff_abs < len_min)) ||
-- 
2.25.1

