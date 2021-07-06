Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD60E3BCBFF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhGFLSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232115AbhGFLRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AFDF61C2C;
        Tue,  6 Jul 2021 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570095;
        bh=YvKMmRMLa/2dIXBHbsZWFMwPn11G4++wRBRGLtY7EnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lokJG8ubfV3fmix61r+cn+0gU+jEmTteRa0Rk2J8i0UOby4Ro6ZceHxwyCh5n4aLA
         sf6sZzGhJGzReRjkd699qMP2iM0f5xZbTexb++30rqjZnAxJdTAqnYDDQXxR3b2EGV
         2uvLetL2Dx/QaXSiRUgckdjay1SizcyZA4rHZ5if7qtm8HRrLDur6OMaldS8w8gavY
         qlubqMK7AGzNwqM5uM3wKxyu7WX9sU2PGpPPm/ktBA9ZxyJIDY/2MkKfS6W3O/ueeT
         N8sTqW47aU1rGOSt8m1eEHEt08jaJ6BTYm+tN3NnyipDu2wyS2f2UtrEkwsgYc3O2I
         JM0LtJZi13+/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongseok Yi <dseok.yi@samsung.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 032/189] bpf: Check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto
Date:   Tue,  6 Jul 2021 07:11:32 -0400
Message-Id: <20210706111409.2058071-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 65ab4e21c087..239de1306de9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3235,7 +3235,7 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 	return ret;
 }
 
-static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
+static int bpf_skb_proto_4_to_6(struct sk_buff *skb, u64 flags)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -3264,7 +3264,9 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 		}
 
 		/* Due to IPv6 header, MSS needs to be downgraded. */
-		skb_decrease_gso_size(shinfo, len_diff);
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+			skb_decrease_gso_size(shinfo, len_diff);
+
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3276,7 +3278,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
+static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -3305,7 +3307,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 		}
 
 		/* Due to IPv4 header, MSS can be upgraded. */
-		skb_increase_gso_size(shinfo, len_diff);
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+			skb_increase_gso_size(shinfo, len_diff);
+
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3317,17 +3321,17 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
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
@@ -3337,7 +3341,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 {
 	int ret;
 
-	if (unlikely(flags))
+	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO)))
 		return -EINVAL;
 
 	/* General idea is that this helper does the basic groundwork
@@ -3357,7 +3361,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
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

