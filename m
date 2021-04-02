Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DDA352F1B
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbhDBSUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:20:37 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:42731 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBSUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:20:37 -0400
Received: by mail-wr1-f53.google.com with SMTP id x13so5377955wrs.9;
        Fri, 02 Apr 2021 11:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Er0JvX9LJJW9NGmHRaC1luhAateCi8wCBUT1RypacVs=;
        b=isiNL5Uiunz3gxJ37Y1OVc2NoH7X0YFIW4o8BkhKTu/1x8HNTgrgI/chYntlPKXHwr
         EeMh3bOsmcahSD4NvozupoKahOA9D/tDX59QQtFi9j2kQ8YvNXFjZBxkjzR3+B3GBbsd
         vi46dceVagh53FqcafFm6COqB0nAc0FaYVC9SaRI4hXf7gO5X4Ww9yuhiMH1BY5HLPQY
         vfGoI7oDNPDE7Tx3MyfSpKxGYbES38MoAiUC7ZJaCqVnqawkEvCWSU9Ks6FXGUXnPU+s
         D3GmmYN5qhwZBA1+0AiTkgcUSdivsTMt0NCIjGFxQcM6JuimdT2WeZVCkBPXPIw9fvUv
         8isg==
X-Gm-Message-State: AOAM5319YlzgNUbYV2VzaJ/8Jp0UvEQ+wu82EfTNnylTXZQMNpwpr4kT
        Go7LUakCB6dQLNrsnYYjsByxifRLFdc=
X-Google-Smtp-Source: ABdhPJwgK/+KFhjuGNLJ8r2SaP4sJb/h9zP3xXrOuyZNka5/3to/0YCfcy6AJtNTxZXrVOKd457HWg==
X-Received: by 2002:adf:e411:: with SMTP id g17mr16405180wrm.225.1617387634607;
        Fri, 02 Apr 2021 11:20:34 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id l9sm11472831wmq.2.2021.04.02.11.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 11:20:33 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 4/5] mvpp2: recycle buffers
Date:   Fri,  2 Apr 2021 20:17:32 +0200
Message-Id: <20210402181733.32250-5-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210402181733.32250-1-mcroce@linux.microsoft.com>
References: <20210402181733.32250-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Use the new recycling API for page_pool.
In a drop rate test, the packet rate is more than doubled,
from 962 Kpps to 2047 Kpps.

perf top on a stock system shows:

Overhead  Shared Object     Symbol
  30.67%  [kernel]          [k] page_pool_release_page
   8.37%  [kernel]          [k] get_page_from_freelist
   7.34%  [kernel]          [k] free_unref_page
   6.47%  [mvpp2]           [k] mvpp2_rx
   4.69%  [kernel]          [k] eth_type_trans
   4.55%  [kernel]          [k] __netif_receive_skb_core
   4.40%  [kernel]          [k] build_skb
   4.29%  [kernel]          [k] kmem_cache_free
   4.00%  [kernel]          [k] kmem_cache_alloc
   3.81%  [kernel]          [k] dev_gro_receive

With packet rate stable at 962 Kpps:

tx: 0 bps 0 pps rx: 477.4 Mbps 962.6 Kpps
tx: 0 bps 0 pps rx: 477.6 Mbps 962.8 Kpps
tx: 0 bps 0 pps rx: 477.6 Mbps 962.9 Kpps
tx: 0 bps 0 pps rx: 477.2 Mbps 962.1 Kpps
tx: 0 bps 0 pps rx: 477.5 Mbps 962.7 Kpps

And this is the same output with recycling enabled:

Overhead  Shared Object     Symbol
  12.75%  [mvpp2]           [k] mvpp2_rx
   9.56%  [kernel]          [k] __netif_receive_skb_core
   9.29%  [kernel]          [k] build_skb
   9.27%  [kernel]          [k] eth_type_trans
   8.39%  [kernel]          [k] kmem_cache_alloc
   7.85%  [kernel]          [k] kmem_cache_free
   7.36%  [kernel]          [k] page_pool_put_page
   6.45%  [kernel]          [k] dev_gro_receive
   4.72%  [kernel]          [k] __xdp_return
   3.06%  [kernel]          [k] page_pool_refill_alloc_cache

With packet rate above 2000 Kpps:

tx: 0 bps 0 pps rx: 1015 Mbps 2046 Kpps
tx: 0 bps 0 pps rx: 1015 Mbps 2047 Kpps
tx: 0 bps 0 pps rx: 1015 Mbps 2047 Kpps
tx: 0 bps 0 pps rx: 1015 Mbps 2047 Kpps
tx: 0 bps 0 pps rx: 1015 Mbps 2047 Kpps

The major performance increase is explained by the fact that the most CPU
consuming functions (page_pool_release_page, get_page_from_freelist
and free_unref_page) are no longer called on a per packet basis.

The test was done by sending to the macchiatobin 64 byte ethernet frames
with an invalid ethertype, so the packets are dropped early in the RX path.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ec706d614cac..633b39cfef65 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3847,6 +3847,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 	struct mvpp2_pcpu_stats ps = {};
 	enum dma_data_direction dma_dir;
 	struct bpf_prog *xdp_prog;
+	struct xdp_rxq_info *rxqi;
 	struct xdp_buff xdp;
 	int rx_received;
 	int rx_done = 0;
@@ -3912,15 +3913,15 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		else
 			frag_size = bm_pool->frag_size;
 
-		if (xdp_prog) {
-			struct xdp_rxq_info *xdp_rxq;
+		if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
+			rxqi = &rxq->xdp_rxq_short;
+		else
+			rxqi = &rxq->xdp_rxq_long;
 
-			if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
-				xdp_rxq = &rxq->xdp_rxq_short;
-			else
-				xdp_rxq = &rxq->xdp_rxq_long;
+		if (xdp_prog) {
+			xdp.rxq = rxqi;
 
-			xdp_init_buff(&xdp, PAGE_SIZE, xdp_rxq);
+			xdp_init_buff(&xdp, PAGE_SIZE, rxqi);
 			xdp_prepare_buff(&xdp, data,
 					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
 					 rx_bytes, false);
@@ -3964,7 +3965,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		}
 
 		if (pp)
-			page_pool_release_page(pp, virt_to_page(data));
+			skb_mark_for_recycle(skb, virt_to_page(data), &rxqi->mem);
 		else
 			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
-- 
2.30.2

