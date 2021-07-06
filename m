Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C093BD20F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbhGFLlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237086AbhGFLfx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E95561E9D;
        Tue,  6 Jul 2021 11:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570725;
        bh=S3q5+8GXB75Xf7g+Pzl9qYFzT+wHQlfna6ymitQ/T3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+Iizmi6FcwFiApRJK/mOd03wcH84r3Q9o+jXzPvE57SNCxWhCOpPzYcp66ucHUxm
         F/dO9oSwoyszEYy69/iz2iDSbWwStEAgnGvDy/kpL7ahcCJbIfXoFFc7Z2hLyCnlls
         z+iWYPfQg0vnvQ+5gE4m8I4zPkh+8eGijc0NSwyjogZVJ5Z9NDZijiOR5nLcAzRp6c
         s40IspVAO6oTUEYkGUczgdLALJTZXCIRenE1+7+s4N+Fl67vQTKvfUPmUUeZl93ItT
         5VpmTvKNalMN/DpvHxwKtmXi+CizYMWC/B+H66atHUzaYDeN3ctD3hjeZPLrmNgFNX
         kn37PWdXpEMTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongseok Yi <dseok.yi@samsung.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/74] bpf: Check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto
Date:   Tue,  6 Jul 2021 07:24:05 -0400
Message-Id: <20210706112502.2064236-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongseok Yi <dseok.yi@samsung.com>

[ Upstream commit fa7b83bf3b156c767f3e4a25bbf3817b08f3ff8e ]

In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
coalesced packet payload can be > MSS, but < MSS + 20.

bpf_skb_proto_6_to_4() will upgrade the MSS and it can be > the payload
length. After then tcp_gso_segment checks for the payload length if it
is <= MSS. The condition is causing the packet to be dropped.

tcp_gso_segment():
        [...]
        mss = skb_shinfo(skb)->gso_size;
        if (unlikely(skb->len <= mss))
                goto out;
        [...]

Allow to upgrade/downgrade MSS only when BPF_F_ADJ_ROOM_FIXED_GSO is
not set.

Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/bpf/1620804453-57566-1-git-send-email-dseok.yi@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 108bcf600052..823e77846525 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2833,7 +2833,7 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 	return ret;
 }
 
-static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
+static int bpf_skb_proto_4_to_6(struct sk_buff *skb, u64 flags)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -2862,7 +2862,9 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 		}
 
 		/* Due to IPv6 header, MSS needs to be downgraded. */
-		skb_decrease_gso_size(shinfo, len_diff);
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+			skb_decrease_gso_size(shinfo, len_diff);
+
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -2874,7 +2876,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
+static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -2903,7 +2905,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 		}
 
 		/* Due to IPv4 header, MSS can be upgraded. */
-		skb_increase_gso_size(shinfo, len_diff);
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+			skb_increase_gso_size(shinfo, len_diff);
+
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -2915,17 +2919,17 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
+static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto, u64 flags)
 {
 	__be16 from_proto = skb->protocol;
 
 	if (from_proto == htons(ETH_P_IP) &&
 	      to_proto == htons(ETH_P_IPV6))
-		return bpf_skb_proto_4_to_6(skb);
+		return bpf_skb_proto_4_to_6(skb, flags);
 
 	if (from_proto == htons(ETH_P_IPV6) &&
 	      to_proto == htons(ETH_P_IP))
-		return bpf_skb_proto_6_to_4(skb);
+		return bpf_skb_proto_6_to_4(skb, flags);
 
 	return -ENOTSUPP;
 }
@@ -2935,7 +2939,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 {
 	int ret;
 
-	if (unlikely(flags))
+	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO)))
 		return -EINVAL;
 
 	/* General idea is that this helper does the basic groundwork
@@ -2955,7 +2959,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 	 * that. For offloads, we mark packet as dodgy, so that headers
 	 * need to be verified first.
 	 */
-	ret = bpf_skb_proto_xlat(skb, proto);
+	ret = bpf_skb_proto_xlat(skb, proto, flags);
 	bpf_compute_data_pointers(skb);
 	return ret;
 }
-- 
2.30.2

