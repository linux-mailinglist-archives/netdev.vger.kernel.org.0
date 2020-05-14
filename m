Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB881D2D60
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgENKuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:50:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44269 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727098AbgENKun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589453442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCdO9GIbmXvKJcfcTXYpA04NQOdCRGMOmMqqJpuzEPA=;
        b=e5Jpz2bJ9oKzS6PZTj/QBewrn60XTQGrJkk79uzcjFLn468bw3RstGaNtuXWU31xLhv/D6
        kbTIFtVaObln1loLxMA8XAJeS3J3MYIHx1xB0lt+fv1QY4kZumE+PN65rtI5xda8ucmAUO
        Vw5eikOV/7hqPyo3nAc6O2PZohhKibg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-f6x7UodAMuOfjuS-m-caDw-1; Thu, 14 May 2020 06:50:38 -0400
X-MC-Unique: f6x7UodAMuOfjuS-m-caDw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2B03107ACCA;
        Thu, 14 May 2020 10:50:36 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46D0A7D95E;
        Thu, 14 May 2020 10:50:30 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2E139300020FC;
        Thu, 14 May 2020 12:50:29 +0200 (CEST)
Subject: [PATCH net-next v4 18/33] nfp: add XDP frame size to netronome driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Thu, 14 May 2020 12:50:29 +0200
Message-ID: <158945342911.97035.11214251236208648808.stgit@firesoul>
In-Reply-To: <158945314698.97035.5286827951225578467.stgit@firesoul>
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 


