Return-Path: <netdev+bounces-2154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5001F70089D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CFEA281185
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317161DDED;
	Fri, 12 May 2023 13:08:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BDD1078B;
	Fri, 12 May 2023 13:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F33C433D2;
	Fri, 12 May 2023 13:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683896913;
	bh=luFaSfXIUleSXHpn1H9AjHgoe1X6sU9XB4j7pTWrGLw=;
	h=From:To:Cc:Subject:Date:From;
	b=fI1wUydqgLP3LCirPbZyEOercn1DpLL4AzTYnQGaSQ4rB4jWi8DMMfLxNV2rt2/S4
	 QMSqyGOn4Lu9K8FIxTH9egL8QVmOh2m+N8yROUKZLyx3u+Ndnsz7/EYlPGCKGiHQRZ
	 9eJ5zMWC7StY35ZgE5DRmTYfbMXady6PJorAaNROk7w387FZrf16/mOeU6mr/nY8so
	 a5vD1zHudHGRHLvvof/Zgm0aQSgOhOQGmsNIMI0dIAu4rdBRBdK6vM3lYYiVn/bC4K
	 DihjyAD0gUek7q/KLU1Yln/17Y4IIumbtRnmo72/UTPixpRzgyUfbBTmkyh2Cafwn6
	 uzpS87rKz9dUg==
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: netdev@vger.kernel.org
Cc: lorenzo.bianconi@redhat.com,
	bpf@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	linyunsheng@huawei.com
Subject: [RFC net-next] net: veth: reduce page_pool memory footprint using half page per-buffer
Date: Fri, 12 May 2023 15:08:13 +0200
Message-Id: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to reduce page_pool memory footprint, rely on
page_pool_dev_alloc_frag routine and reduce buffer size
(VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one page
for two 1500B frames. Reduce VETH_XDP_PACKET_HEADROOM to 192 from 256
(XDP_PACKET_HEADROOM) to fit max_head_size in VETH_PAGE_POOL_FRAG_SIZE.
Please note, using default values (CONFIG_MAX_SKB_FRAGS=17), maximum
supported MTU is now reduced to 36350B.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 614f3e3efab0..0e648703cccf 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -31,9 +31,12 @@
 #define DRV_NAME	"veth"
 #define DRV_VERSION	"1.0"
 
-#define VETH_XDP_FLAG		BIT(0)
-#define VETH_RING_SIZE		256
-#define VETH_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
+#define VETH_XDP_FLAG			BIT(0)
+#define VETH_RING_SIZE			256
+#define VETH_XDP_PACKET_HEADROOM	192
+#define VETH_XDP_HEADROOM		(VETH_XDP_PACKET_HEADROOM + \
+					 NET_IP_ALIGN)
+#define VETH_PAGE_POOL_FRAG_SIZE	2048
 
 #define VETH_XDP_TX_BULK_SIZE	16
 #define VETH_XDP_BATCH		16
@@ -736,7 +739,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
 	    skb_shinfo(skb)->nr_frags ||
 	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
-		u32 size, len, max_head_size, off;
+		u32 size, len, max_head_size, off, pp_off;
 		struct sk_buff *nskb;
 		struct page *page;
 		int i, head_off;
@@ -747,17 +750,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 		 *
 		 * Make sure we have enough space for linear and paged area
 		 */
-		max_head_size = SKB_WITH_OVERHEAD(PAGE_SIZE -
+		max_head_size = SKB_WITH_OVERHEAD(VETH_PAGE_POOL_FRAG_SIZE -
 						  VETH_XDP_HEADROOM);
-		if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
+		if (skb->len >
+		    VETH_PAGE_POOL_FRAG_SIZE * MAX_SKB_FRAGS + max_head_size)
 			goto drop;
 
 		/* Allocate skb head */
-		page = page_pool_dev_alloc_pages(rq->page_pool);
+		page = page_pool_dev_alloc_frag(rq->page_pool, &pp_off,
+						VETH_PAGE_POOL_FRAG_SIZE);
 		if (!page)
 			goto drop;
 
-		nskb = napi_build_skb(page_address(page), PAGE_SIZE);
+		nskb = napi_build_skb(page_address(page) + pp_off,
+				      VETH_PAGE_POOL_FRAG_SIZE);
 		if (!nskb) {
 			page_pool_put_full_page(rq->page_pool, page, true);
 			goto drop;
@@ -782,15 +788,18 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 		len = skb->len - off;
 
 		for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
-			page = page_pool_dev_alloc_pages(rq->page_pool);
+			page = page_pool_dev_alloc_frag(rq->page_pool, &pp_off,
+							VETH_PAGE_POOL_FRAG_SIZE);
 			if (!page) {
 				consume_skb(nskb);
 				goto drop;
 			}
 
-			size = min_t(u32, len, PAGE_SIZE);
-			skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE);
-			if (skb_copy_bits(skb, off, page_address(page),
+			size = min_t(u32, len, VETH_PAGE_POOL_FRAG_SIZE);
+			skb_add_rx_frag(nskb, i, page, pp_off, size,
+					VETH_PAGE_POOL_FRAG_SIZE);
+			if (skb_copy_bits(skb, off,
+					  page_address(page) + pp_off,
 					  size)) {
 				consume_skb(nskb);
 				goto drop;
@@ -1035,6 +1044,7 @@ static int veth_create_page_pool(struct veth_rq *rq)
 	struct page_pool_params pp_params = {
 		.order = 0,
 		.pool_size = VETH_RING_SIZE,
+		.flags = PP_FLAG_PAGE_FRAG,
 		.nid = NUMA_NO_NODE,
 		.dev = &rq->dev->dev,
 	};
@@ -1634,13 +1644,14 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			goto err;
 		}
 
-		max_mtu = SKB_WITH_OVERHEAD(PAGE_SIZE - VETH_XDP_HEADROOM) -
+		max_mtu = SKB_WITH_OVERHEAD(VETH_PAGE_POOL_FRAG_SIZE -
+					    VETH_XDP_HEADROOM) -
 			  peer->hard_header_len;
 		/* Allow increasing the max_mtu if the program supports
 		 * XDP fragments.
 		 */
 		if (prog->aux->xdp_has_frags)
-			max_mtu += PAGE_SIZE * MAX_SKB_FRAGS;
+			max_mtu += VETH_PAGE_POOL_FRAG_SIZE * MAX_SKB_FRAGS;
 
 		if (peer->mtu > max_mtu) {
 			NL_SET_ERR_MSG_MOD(extack, "Peer MTU is too large to set XDP");
-- 
2.40.1


