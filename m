Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BE91D2D42
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgENKtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:49:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21726 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726225AbgENKti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589453376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDrz/SQNvcoIj92PW7nYhi7Qhvg4RN/AwHC55qRVh3c=;
        b=I0prj5O7Gq4vw76UybvyLySQ9WVQsaxZywb8WBAxrjotBpsSefpE132cMF9AZWJZIgMj3G
        kQT48eFnmMrIYaLllEJaf/9QyuTs5R5+sQ26TCqatwzeeJf9lFrUlw2sOFREz93c+7PpNm
        IBs/h4Q7pqXY/GdksznaGNbQ/MPtCx8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-pE4V6q3EN22J0C8SGaQ-fQ-1; Thu, 14 May 2020 06:49:32 -0400
X-MC-Unique: pE4V6q3EN22J0C8SGaQ-fQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF50B8014D7;
        Thu, 14 May 2020 10:49:30 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E0D35D9F1;
        Thu, 14 May 2020 10:49:24 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 07952325159C9;
        Thu, 14 May 2020 12:49:23 +0200 (CEST)
Subject: [PATCH net-next v4 05/33] net: netsec: Add support for XDP frame size
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
Date:   Thu, 14 May 2020 12:49:23 +0200
Message-ID: <158945336295.97035.15034759661036971024.stgit@firesoul>
In-Reply-To: <158945314698.97035.5286827951225578467.stgit@firesoul>
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

This driver takes advantage of page_pool PP_FLAG_DMA_SYNC_DEV that
can help reduce the number of cache-lines that need to be flushed
when doing DMA sync for_device. Due to xdp_adjust_tail can grow the
area accessible to the by the CPU (can possibly write into), then max
sync length *after* bpf_prog_run_xdp() needs to be taken into account.

For XDP_TX action the driver is smart and does DMA-sync. When growing
tail this is still safe, because page_pool have DMA-mapped the entire
page size.

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index a5a0fb60193a..e1f4be4b3d69 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -884,23 +884,28 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 			  struct xdp_buff *xdp)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
-	unsigned int len = xdp->data_end - xdp->data;
+	unsigned int sync, len = xdp->data_end - xdp->data;
 	u32 ret = NETSEC_XDP_PASS;
+	struct page *page;
 	int err;
 	u32 act;
 
 	act = bpf_prog_run_xdp(prog, xdp);
 
+	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
+	sync = xdp->data_end - xdp->data_hard_start - NETSEC_RXBUF_HEADROOM;
+	sync = max(sync, len);
+
 	switch (act) {
 	case XDP_PASS:
 		ret = NETSEC_XDP_PASS;
 		break;
 	case XDP_TX:
 		ret = netsec_xdp_xmit_back(priv, xdp);
-		if (ret != NETSEC_XDP_TX)
-			page_pool_put_page(dring->page_pool,
-					   virt_to_head_page(xdp->data), len,
-					   true);
+		if (ret != NETSEC_XDP_TX) {
+			page = virt_to_head_page(xdp->data);
+			page_pool_put_page(dring->page_pool, page, sync, true);
+		}
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(priv->ndev, xdp, prog);
@@ -908,9 +913,8 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 			ret = NETSEC_XDP_REDIR;
 		} else {
 			ret = NETSEC_XDP_CONSUMED;
-			page_pool_put_page(dring->page_pool,
-					   virt_to_head_page(xdp->data), len,
-					   true);
+			page = virt_to_head_page(xdp->data);
+			page_pool_put_page(dring->page_pool, page, sync, true);
 		}
 		break;
 	default:
@@ -921,8 +925,8 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 		/* fall through -- handle aborts by dropping packet */
 	case XDP_DROP:
 		ret = NETSEC_XDP_CONSUMED;
-		page_pool_put_page(dring->page_pool,
-				   virt_to_head_page(xdp->data), len, true);
+		page = virt_to_head_page(xdp->data);
+		page_pool_put_page(dring->page_pool, page, sync, true);
 		break;
 	}
 
@@ -936,10 +940,14 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 	struct netsec_rx_pkt_info rx_info;
 	enum dma_data_direction dma_dir;
 	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
 	u16 xdp_xmit = 0;
 	u32 xdp_act = 0;
 	int done = 0;
 
+	xdp.rxq = &dring->xdp_rxq;
+	xdp.frame_sz = PAGE_SIZE;
+
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(priv->xdp_prog);
 	dma_dir = page_pool_get_dma_dir(dring->page_pool);
@@ -953,7 +961,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		struct sk_buff *skb = NULL;
 		u16 pkt_len, desc_len;
 		dma_addr_t dma_handle;
-		struct xdp_buff xdp;
 		void *buf_addr;
 
 		if (de->attr & (1U << NETSEC_RX_PKT_OWN_FIELD)) {
@@ -1002,7 +1009,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		xdp.data = desc->addr + NETSEC_RXBUF_HEADROOM;
 		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + pkt_len;
-		xdp.rxq = &dring->xdp_rxq;
 
 		if (xdp_prog) {
 			xdp_result = netsec_run_xdp(priv, xdp_prog, &xdp);


