Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAB1451646
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346439AbhKOVSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:18:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238231AbhKOUjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:39:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637008615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f2TutiekFMTaKNriZYHOVfGQpVSzepL0rcZb/D7ZuAw=;
        b=EnroqIJKGVja2Polk03wYWDxuio8zyDmydvcJ3MI+4iRYPhRTu17cSHbZbj6g/So5q+2of
        2RYqAEmfMv1JQHp7Wg9YOl0sYMREI2J6P/ovq6GxAjJY+Gebu2eM9o1X0khtbjAY/s5DUg
        2iiGB7kjRn+yCFDCqdGxJU17375YyHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-tsKGtkodPTmdsphWHtAVvQ-1; Mon, 15 Nov 2021 15:36:52 -0500
X-MC-Unique: tsKGtkodPTmdsphWHtAVvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E766E1851721;
        Mon, 15 Nov 2021 20:36:50 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 648845BAF0;
        Mon, 15 Nov 2021 20:36:32 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E4EA830027803;
        Mon, 15 Nov 2021 21:36:30 +0100 (CET)
Subject: [PATCH net-next 2/2] igc: enable XDP metadata in driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
        bjorn@kernel.org
Date:   Mon, 15 Nov 2021 21:36:30 +0100
Message-ID: <163700859087.565980.3578855072170209153.stgit@firesoul>
In-Reply-To: <163700856423.565980.10162564921347693758.stgit@firesoul>
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enabling the XDP bpf_prog access to data_meta area is a very small
change. Hint passing 'true' to xdp_prepare_buff().

The SKB layers can also access data_meta area, which required more
driver changes to support. Reviewers, notice the igc driver have two
different functions that can create SKBs, depending on driver config.

Hint for testers, ethtool priv-flags legacy-rx enables
the function igc_construct_skb()

 ethtool --set-priv-flags DEV legacy-rx on

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 76b0a7311369..b516f1b301b4 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1718,24 +1718,26 @@ static void igc_add_rx_frag(struct igc_ring *rx_ring,
 
 static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
 				     struct igc_rx_buffer *rx_buffer,
-				     union igc_adv_rx_desc *rx_desc,
-				     unsigned int size)
+				     struct xdp_buff *xdp)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	unsigned int size = xdp->data_end - xdp->data;
 	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
+	unsigned int metasize = xdp->data - xdp->data_meta;
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	net_prefetch(va);
+	net_prefetch(xdp->data);
 
 	/* build an skb around the page buffer */
-	skb = build_skb(va - IGC_SKB_PAD, truesize);
+	skb = build_skb(xdp->data_hard_start, truesize);
 	if (unlikely(!skb))
 		return NULL;
 
 	/* update pointers within the skb to store the data */
-	skb_reserve(skb, IGC_SKB_PAD);
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	__skb_put(skb, size);
+	if (metasize)
+		skb_metadata_set(skb, metasize);
 
 	igc_rx_buffer_flip(rx_buffer, truesize);
 	return skb;
@@ -1746,6 +1748,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 					 struct xdp_buff *xdp,
 					 ktime_t timestamp)
 {
+	unsigned int metasize = xdp->data - xdp->data_meta;
 	unsigned int size = xdp->data_end - xdp->data;
 	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
 	void *va = xdp->data;
@@ -1756,7 +1759,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 	net_prefetch(va);
 
 	/* allocate a skb to store the frags */
-	skb = napi_alloc_skb(&rx_ring->q_vector->napi, IGC_RX_HDR_LEN);
+	skb = napi_alloc_skb(&rx_ring->q_vector->napi, IGC_RX_HDR_LEN + metasize);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -1769,7 +1772,13 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 		headlen = eth_get_headlen(skb->dev, va, IGC_RX_HDR_LEN);
 
 	/* align pull length to size of long to optimize memcpy performance */
-	memcpy(__skb_put(skb, headlen), va, ALIGN(headlen, sizeof(long)));
+	memcpy(__skb_put(skb, headlen + metasize), xdp->data_meta,
+	       ALIGN(headlen + metasize, sizeof(long)));
+
+	if (metasize) {
+		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
 
 	/* update all of the pointers */
 	size -= headlen;
@@ -2354,7 +2363,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		if (!skb) {
 			xdp_init_buff(&xdp, truesize, &rx_ring->xdp_rxq);
 			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
-					 igc_rx_offset(rx_ring) + pkt_offset, size, false);
+					 igc_rx_offset(rx_ring) + pkt_offset, size, true);
 
 			skb = igc_xdp_run_prog(adapter, &xdp);
 		}
@@ -2378,7 +2387,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		} else if (skb)
 			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
 		else if (ring_uses_build_skb(rx_ring))
-			skb = igc_build_skb(rx_ring, rx_buffer, rx_desc, size);
+			skb = igc_build_skb(rx_ring, rx_buffer, &xdp);
 		else
 			skb = igc_construct_skb(rx_ring, rx_buffer, &xdp,
 						timestamp);


