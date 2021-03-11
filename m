Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B732337E64
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhCKTp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:45:27 -0500
Received: from mail-ej1-f49.google.com ([209.85.218.49]:44647 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhCKTpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 14:45:19 -0500
Received: by mail-ej1-f49.google.com with SMTP id ox4so33092145ejb.11;
        Thu, 11 Mar 2021 11:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PMIMYcrbHu95+Z5QYKuH8PdFbTbIU3hECwcgYx+rkRc=;
        b=qGQtdgfUXfvBOBPSLmaOCi1dSk9+wJ/g5OBN6Td+vRtbOFWa7m1cWq78vAsOoSfhrQ
         oBOXu+m50TEpwMCtky2wak/OeFW2y+K2BptkKwjhOzB4IeieITIEdWpe4VNHcmNPsU2O
         HhQUFGAs01w32C/E3wXlP1YMwCt4H/wwt3p3ez9Svhj5lYsigkD76GlnfH1XJcTRMZjU
         XmZ4XGcHgvuWkkqJK3P42DO7Q5Om18inMAcJbXOsFFOTPtsFKeN09qgt45i1UUiIeB4h
         F4AfzFsSmTTQnf9sSLmC7u/bAqAXdf8NPzZe2p8I+owkMlV0mAVFtomt6Zdwp0cGeYG6
         zfCg==
X-Gm-Message-State: AOAM531oYAy38t+mvO1wGfZTHuP7B5ntrB+TgqGbdmLzeoZcKSSeCT2q
        rbVQy74/POHhNZH6JDliyQkrq4g/IKg=
X-Google-Smtp-Source: ABdhPJzvWv/yOEXPHkrJeMTWiiMzh5T6YRcekoJODR3IqQF0imt6oNulnHANkRYGrQVPP6dBtd5QPA==
X-Received: by 2002:a17:906:2344:: with SMTP id m4mr4595885eja.327.1615491918324;
        Thu, 11 Mar 2021 11:45:18 -0800 (PST)
Received: from msft-t490s.teknoraver.net (net-188-216-41-250.cust.vodafonedsl.it. [188.216.41.250])
        by smtp.gmail.com with ESMTPSA id t16sm1875652edi.60.2021.03.11.11.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:45:17 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [RFC net-next 5/6] mvpp2: recycle buffers
Date:   Thu, 11 Mar 2021 20:42:55 +0100
Message-Id: <20210311194256.53706-6-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311194256.53706-1-mcroce@linux.microsoft.com>
References: <20210311194256.53706-1-mcroce@linux.microsoft.com>
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
index 1767c60056c5..8f03bbc763bc 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3848,6 +3848,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 	struct mvpp2_pcpu_stats ps = {};
 	enum dma_data_direction dma_dir;
 	struct bpf_prog *xdp_prog;
+	struct xdp_rxq_info *rxqi;
 	struct xdp_buff xdp;
 	int rx_received;
 	int rx_done = 0;
@@ -3913,15 +3914,15 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
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
@@ -3965,7 +3966,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		}
 
 		if (pp)
-			page_pool_release_page(pp, virt_to_page(data));
+			skb_mark_for_recycle(skb, virt_to_page(data), &rxqi->mem);
 		else
 			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
-- 
2.29.2

