Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431793BD5AE
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhGFMYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235996AbhGFLbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95CA61C81;
        Tue,  6 Jul 2021 11:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570554;
        bh=y7uvhNOmc+fx2bgsAmC+9xwgyJ7WukUp/1Fbx6pN8H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exKvAzxGq43am1N0FX5B4e2kRI+I8GTwSIZxoaEFsqsEYDAnj/pRGlw/Nb0lUVmcK
         xu276VRtF8bw82mmiE+icOko4D2NCaPHivZmcdifhEjJD3F5usDJcRswvQv6xZ2FeG
         atrHR0aGHZz3BZr57xyxZSudVkfZzztOaeVByWd6de4xTsTSPk1lBrU++2uVjZORgW
         Mr1nAiJnwPrif3uRX8sL0u1nEqaSHRH/94kaDdsLDC0z6q1noTky3km7ZuoCguxj7Y
         PJpxG+EnLNK5k7VtRGUn7Yjwjjyy98Ym49tgFiTc1Vt9UR01ccV26DeGUJtD37inTC
         ayDIlJ/OHD3HQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongseok Yi <dseok.yi@samsung.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 023/137] bpf: Check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto
Date:   Tue,  6 Jul 2021 07:20:09 -0400
Message-Id: <20210706112203.2062605-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index ef6bdbb63ecb..ffc8f1f9a780 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3238,7 +3238,7 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 	return ret;
 }
 
-static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
+static int bpf_skb_proto_4_to_6(struct sk_buff *skb, u64 flags)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -3267,7 +3267,9 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 		}
 
 		/* Due to IPv6 header, MSS needs to be downgraded. */
-		skb_decrease_gso_size(shinfo, len_diff);
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+			skb_decrease_gso_size(shinfo, len_diff);
+
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3279,7 +3281,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
+static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -3308,7 +3310,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 		}
 
 		/* Due to IPv4 header, MSS can be upgraded. */
-		skb_increase_gso_size(shinfo, len_diff);
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+			skb_increase_gso_size(shinfo, len_diff);
+
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3320,17 +3324,17 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
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
@@ -3340,7 +3344,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 {
 	int ret;
 
-	if (unlikely(flags))
+	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO)))
 		return -EINVAL;
 
 	/* General idea is that this helper does the basic groundwork
@@ -3360,7 +3364,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
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

