Return-Path: <netdev+bounces-5974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76FD6713E69
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 21:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAE561C20978
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BAE569F;
	Sun, 28 May 2023 19:35:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C682611B;
	Sun, 28 May 2023 19:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D8FC4339B;
	Sun, 28 May 2023 19:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302526;
	bh=jEbjE/K5dtGjjxmck4EinA1O4+gINe8liBJUquSqtss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01Q+WUxWmqr0mrprwvlt0gIp7gU0RPO8ZmGtlyqABaREZhIRIrIJxasuq0x89pClN
	 r9UJax4FcwkuASaCsESZsnQrtufTiIiP0MUetAtaEjQMuXtiAm+WxcB++3oXeHXUfD
	 YdnsDkHVneznYif0/IIAyIeUJ+SK2+1arvnG7+/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
Subject: [PATCH 6.1 011/119] skbuff: Proactively round up to kmalloc bucket size
Date: Sun, 28 May 2023 20:10:11 +0100
Message-Id: <20230528190835.721989959@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

commit 12d6c1d3a2ad0c199ec57c201cdc71e8e157a232 upstream.

Instead of discovering the kmalloc bucket size _after_ allocation, round
up proactively so the allocation is explicitly made for the full size,
allowing the compiler to correctly reason about the resulting size of
the buffer through the existing __alloc_size() hint.

This will allow for kernels built with CONFIG_UBSAN_BOUNDS or the
coming dynamic bounds checking under CONFIG_FORTIFY_SOURCE to gain
back the __alloc_size() hints that were temporarily reverted in commit
93dd04ab0b2b ("slab: remove __alloc_size attribute from __kmalloc_track_caller")

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221021234713.you.031-kees@kernel.org/
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221025223811.up.360-kees@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Cc: Daniel Díaz <daniel.diaz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -506,14 +506,14 @@ struct sk_buff *__alloc_skb(unsigned int
 	 */
 	size = SKB_DATA_ALIGN(size);
 	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
+	osize = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
 	if (unlikely(!data))
 		goto nodata;
-	/* kmalloc(size) might give us more room than requested.
+	/* kmalloc_size_roundup() might give us more room than requested.
 	 * Put skb_shared_info exactly at the end of allocated zone,
 	 * to allow max possible filling before reallocation.
 	 */
-	osize = ksize(data);
 	size = SKB_WITH_OVERHEAD(osize);
 	prefetchw(data + size);
 
@@ -1822,10 +1822,11 @@ EXPORT_SYMBOL(__pskb_copy_fclone);
 int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 		     gfp_t gfp_mask)
 {
-	int i, osize = skb_end_offset(skb);
-	int size = osize + nhead + ntail;
+	unsigned int osize = skb_end_offset(skb);
+	unsigned int size = osize + nhead + ntail;
 	long off;
 	u8 *data;
+	int i;
 
 	BUG_ON(nhead < 0);
 
@@ -1833,15 +1834,16 @@ int pskb_expand_head(struct sk_buff *skb
 
 	skb_zcopy_downgrade_managed(skb);
 
-	size = SKB_DATA_ALIGN(size);
-
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+
+	size = SKB_DATA_ALIGN(size);
+	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(size);
 
 	/* Copy only real data... and, alas, header. This should be
 	 * optimized for the cases when header is void.
@@ -6182,21 +6184,20 @@ static int pskb_carve_inside_header(stru
 				    const int headlen, gfp_t gfp_mask)
 {
 	int i;
-	int size = skb_end_offset(skb);
+	unsigned int size = skb_end_offset(skb);
 	int new_hlen = headlen - off;
 	u8 *data;
 
-	size = SKB_DATA_ALIGN(size);
-
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size +
-			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+
+	size = SKB_DATA_ALIGN(size);
+	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
-
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(size);
 
 	/* Copy real data, and all frags */
 	skb_copy_from_linear_data_offset(skb, off, data, new_hlen);
@@ -6301,22 +6302,21 @@ static int pskb_carve_inside_nonlinear(s
 				       int pos, gfp_t gfp_mask)
 {
 	int i, k = 0;
-	int size = skb_end_offset(skb);
+	unsigned int size = skb_end_offset(skb);
 	u8 *data;
 	const int nfrags = skb_shinfo(skb)->nr_frags;
 	struct skb_shared_info *shinfo;
 
-	size = SKB_DATA_ALIGN(size);
-
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size +
-			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+
+	size = SKB_DATA_ALIGN(size);
+	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
-
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(size);
 
 	memcpy((struct skb_shared_info *)(data + size),
 	       skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));



