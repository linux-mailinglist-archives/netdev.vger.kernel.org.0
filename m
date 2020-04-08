Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2718E1A205F
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgDHLw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:52:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728756AbgDHLw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MCv8fhfDJ9MisBpERalYAZGMbZ3E/f/f6YpVxnzKLGM=;
        b=GdgxAUJYBKrFXmhBFw8/pQou93/ucDWP0twBpPTg2hDOvxSNKnqZeIvx3qFm3+OyZFcXxY
        a2t9e2qfhS+cU3Gax/d7ko7Leslq8XjoyWH3cWcJygzmkNq0N8Q8Zhv72naVH7cPq+bo23
        NqKiGKC4EIczOzspJ2tWEo+ps3+SyTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-4ukuvbKPNdqFRMKct9HgGA-1; Wed, 08 Apr 2020 07:52:55 -0400
X-MC-Unique: 4ukuvbKPNdqFRMKct9HgGA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 253DD800D50;
        Wed,  8 Apr 2020 11:52:53 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 798171001938;
        Wed,  8 Apr 2020 11:52:52 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 93C37300020FB;
        Wed,  8 Apr 2020 13:52:51 +0200 (CEST)
Subject: [PATCH RFC v2 27/33] ice: add XDP frame size to driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:52:51 +0200
Message-ID: <158634677153.707275.15058521423175287393.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver uses different memory models depending on PAGE_SIZE at
compile time. For PAGE_SIZE 4K it uses page splitting, meaning for
normal MTU frame size is 2048 bytes (and headroom 192 bytes). For
larger MTUs the driver still use page splitting, by allocating
order-1 pages (8192 bytes) for RX frames. For PAGE_SIZE larger than
4K, driver instead advance its rx_buffer->page_offset with the frame
size "truesize".

For XDP frame size calculations, this mean that in PAGE_SIZE larger
than 4K mode the frame_sz change on a per packet basis. For the page
split 4K PAGE_SIZE mode, xdp.frame_sz is more constant and can be
updated once outside the main NAPI loop.

The default setting in the driver uses build_skb(), which provides
the necessary headroom and tailroom for XDP-redirect in RX-frame
(in both modes).

There is one complication, which is legacy-rx mode (configurable via
ethtool priv-flags). There are zero headroom in this mode, which is a
requirement for XDP-redirect to work. The conversion to xdp_frame
(convert_to_xdp_frame) will detect this insufficient space, and
xdp_do_redirect() call will fail. This is deemed acceptable, as it
allows other XDP actions to still work in legacy-mode. In
legacy-mode + larger PAGE_SIZE due to lacking tailroom, we also
accept that xdp_adjust_tail shrink doesn't work.

Cc: intel-wired-lan@lists.osuosl.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c |   34 +++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index f67e8362958c..695f86694224 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -423,6 +423,22 @@ static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
 	return 0;
 }
 
+static unsigned int ice_rx_frame_truesize(struct ice_ring *rx_ring,
+					  unsigned int size)
+{
+	unsigned int truesize;
+
+#if (PAGE_SIZE < 8192)
+	truesize = ice_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
+#else
+	truesize = ice_rx_offset(rx_ring) ?
+		SKB_DATA_ALIGN(ice_rx_offset(rx_ring) + size) +
+		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
+		SKB_DATA_ALIGN(size)
+#endif
+	return truesize;
+}
+
 /**
  * ice_run_xdp - Executes an XDP program on initialized xdp_buff
  * @rx_ring: Rx ring
@@ -991,6 +1007,10 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 	bool failure;
 
 	xdp.rxq = &rx_ring->xdp_rxq;
+	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
+#if (PAGE_SIZE < 8192)
+	xdp.frame_sz = ice_rx_frame_truesize(rx_ring, 0);
+#endif
 
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
@@ -1038,6 +1058,10 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		xdp.data_hard_start = xdp.data - ice_rx_offset(rx_ring);
 		xdp.data_meta = xdp.data;
 		xdp.data_end = xdp.data + size;
+#if (PAGE_SIZE > 4096)
+		/* At larger PAGE_SIZE, frame_sz depend on len size */
+		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
+#endif
 
 		rcu_read_lock();
 		xdp_prog = READ_ONCE(rx_ring->xdp_prog);
@@ -1051,16 +1075,8 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		if (!xdp_res)
 			goto construct_skb;
 		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
-			unsigned int truesize;
-
-#if (PAGE_SIZE < 8192)
-			truesize = ice_rx_pg_size(rx_ring) / 2;
-#else
-			truesize = SKB_DATA_ALIGN(ice_rx_offset(rx_ring) +
-						  size);
-#endif
 			xdp_xmit |= xdp_res;
-			ice_rx_buf_adjust_pg_offset(rx_buf, truesize);
+			ice_rx_buf_adjust_pg_offset(rx_buf, xdp.frame_sz);
 		} else {
 			rx_buf->pagecnt_bias++;
 		}


