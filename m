Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B211BF69E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgD3LWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:22:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727835AbgD3LWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCdO9GIbmXvKJcfcTXYpA04NQOdCRGMOmMqqJpuzEPA=;
        b=h63VJQaA7br9BElD26JZ7we6Qj+i2xsPvIn+rV3qeFgmVnSwJUdlLNIuzmEHJH11kq487w
        8uMLzdzOfImOCmym1euMNl4O1qU8UFADnOD1Vyru+Cu0JYILNsSsjnrKsquKcqtRQgqGNZ
        g14fB3urv3ow2V2Wl65HSoOVeKZAB2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-8PEkyoVFPneVX-iHGsDERg-1; Thu, 30 Apr 2020 07:22:01 -0400
X-MC-Unique: 8PEkyoVFPneVX-iHGsDERg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8088145F;
        Thu, 30 Apr 2020 11:21:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC4CC600EF;
        Thu, 30 Apr 2020 11:21:53 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id F0650324DB2C0;
        Thu, 30 Apr 2020 13:21:52 +0200 (CEST)
Subject: [PATCH net-next v2 18/33] nfp: add XDP frame size to netronome driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jakub Kicinski <kuba@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
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
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Date:   Thu, 30 Apr 2020 13:21:52 +0200
Message-ID: <158824571291.2172139.13881518836729206257.stgit@firesoul>
In-Reply-To: <158824557985.2172139.4173570969543904434.stgit@firesoul>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netronome nfp driver use PAGE_SIZE when xdp_prog is set, but
xdp.data_hard_start begins at offset NFP_NET_RX_BUF_HEADROOM.
Thus, adjust for this when setting xdp.frame_sz, as it counts
from data_hard_start.

When doing XDP_TX this driver is smart and instead of a full DMA-map
does a DMA-sync on with packet length. As xdp_adjust_tail can now
grow packet length, add checks to make sure that grow size is within
the DMA-mapped size.

Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 9bfb3b077bc1..0e0cc3d58bdc 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1741,10 +1741,15 @@ nfp_net_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 		   struct nfp_net_rx_buf *rxbuf, unsigned int dma_off,
 		   unsigned int pkt_len, bool *completed)
 {
+	unsigned int dma_map_sz = dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA;
 	struct nfp_net_tx_buf *txbuf;
 	struct nfp_net_tx_desc *txd;
 	int wr_idx;
 
+	/* Reject if xdp_adjust_tail grow packet beyond DMA area */
+	if (pkt_len + dma_off > dma_map_sz)
+		return false;
+
 	if (unlikely(nfp_net_tx_full(tx_ring, 1))) {
 		if (!*completed) {
 			nfp_net_xdp_complete(tx_ring);
@@ -1817,6 +1822,7 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(dp->xdp_prog);
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
+	xdp.frame_sz = PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM;
 	xdp.rxq = &rx_ring->xdp_rxq;
 	tx_ring = r_vec->xdp_ring;
 


