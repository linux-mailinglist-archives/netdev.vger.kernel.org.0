Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22352188C0B
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCQR3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:29:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52958 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbgCQR3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y+eqYz6yAyXYK7PXXbQ/6uCaIrVxme+xjGQpkLgBZxA=;
        b=I/HlR6hQAZiZNO5uQ8hgIq9rMKbr3l50bpegHD6+6Kz4Dnauu6YOnd7TxH0gb3xTwieyjA
        T9qrOEHV+fUI6FpfYhW6Yb1kjB5Rrql0xVezza+1O6qOkLGz39mANw00rjMJPRClrAcKVU
        nDuROvstk7LE0HfozikdjJ+19D6er6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-5WdjETnPPk-4i6Xz77i8kQ-1; Tue, 17 Mar 2020 13:29:47 -0400
X-MC-Unique: 5WdjETnPPk-4i6Xz77i8kQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EEBC18A5524;
        Tue, 17 Mar 2020 17:29:34 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F4917E30A;
        Tue, 17 Mar 2020 17:29:34 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 26C4B30721A66;
        Tue, 17 Mar 2020 18:29:33 +0100 (CET)
Subject: [PATCH RFC v1 05/15] ixgbe: add XDP frame size to driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 17 Mar 2020 18:29:33 +0100
Message-ID: <158446617307.702578.17057660405507953624.stgit@firesoul>
In-Reply-To: <158446612466.702578.2795159620575737080.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ixgbe driver uses different memory models depending on PAGE_SIZE at
compile time. For PAGE_SIZE 4K it uses page splitting, meaning for
normal MTU frame size is 2048 bytes (and headroom 192 bytes).
For PAGE_SIZE larger than 4K, driver advance its rx_buffer->page_offset
with the frame size "truesize".

When driver enable XDP it uses build_skb() which provides the necessary
tailroom for XDP-redirect.

When XDP frame size doesn't depend on RX packet size (4K case), then
xdp.frame_sz can be updated once outside the main NAPI loop.

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   17 +++++++++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   18 ++++++++++--------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 2833e4f041ce..943b643b6ed8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -417,6 +417,23 @@ static inline unsigned int ixgbe_rx_pg_order(struct ixgbe_ring *ring)
 }
 #define ixgbe_rx_pg_size(_ring) (PAGE_SIZE << ixgbe_rx_pg_order(_ring))
 
+static inline unsigned int ixgbe_rx_frame_truesize(struct ixgbe_ring *rx_ring,
+						   unsigned int size)
+{
+	unsigned int truesize;
+
+#if (PAGE_SIZE < 8192)
+	truesize = ixgbe_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
+#else
+	/* Notice XDP must use build_skb() mode */
+	truesize = ring_uses_build_skb(rx_ring) ?
+		SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) +
+		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
+		SKB_DATA_ALIGN(size);
+#endif
+	return truesize;
+}
+
 #define IXGBE_ITR_ADAPTIVE_MIN_INC	2
 #define IXGBE_ITR_ADAPTIVE_MIN_USECS	10
 #define IXGBE_ITR_ADAPTIVE_MAX_USECS	126
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ea6834bae04c..f505ed8c9dc1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2248,16 +2248,10 @@ static void ixgbe_rx_buffer_flip(struct ixgbe_ring *rx_ring,
 				 struct ixgbe_rx_buffer *rx_buffer,
 				 unsigned int size)
 {
+	unsigned int truesize = ixgbe_rx_frame_truesize(rx_ring, size);
 #if (PAGE_SIZE < 8192)
-	unsigned int truesize = ixgbe_rx_pg_size(rx_ring) / 2;
-
 	rx_buffer->page_offset ^= truesize;
 #else
-	unsigned int truesize = ring_uses_build_skb(rx_ring) ?
-				SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) +
-				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
-				SKB_DATA_ALIGN(size);
-
 	rx_buffer->page_offset += truesize;
 #endif
 }
@@ -2291,6 +2285,11 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 
 	xdp.rxq = &rx_ring->xdp_rxq;
 
+	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
+#if (PAGE_SIZE < 8192)
+	xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, 0);
+#endif
+
 	while (likely(total_rx_packets < budget)) {
 		union ixgbe_adv_rx_desc *rx_desc;
 		struct ixgbe_rx_buffer *rx_buffer;
@@ -2324,7 +2323,10 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			xdp.data_hard_start = xdp.data -
 					      ixgbe_rx_offset(rx_ring);
 			xdp.data_end = xdp.data + size;
-
+#if (PAGE_SIZE > 4096)
+			/* At larger PAGE_SIZE, frame_sz depend on size */
+			xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, size);
+#endif
 			skb = ixgbe_run_xdp(adapter, rx_ring, &xdp);
 		}
 


