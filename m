Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6AC337E6A
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhCKTp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:45:59 -0500
Received: from mail-ej1-f44.google.com ([209.85.218.44]:36542 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhCKTp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 14:45:26 -0500
Received: by mail-ej1-f44.google.com with SMTP id e19so48788116ejt.3;
        Thu, 11 Mar 2021 11:45:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OeCiiJBsFe7jdSlbBr+NErlckMGg0noG5UTFudr/xQg=;
        b=nlmh4IuPsrC9/yRJValBnwzz5QgO4TLUJoMExnBSDOLu+u3drUg+GRFaqvyOZuo2iw
         5+SENAX9Gt7rdBzq6w/lrICkr12FDxdnbj8UAvnsMRsRTlsojP6cWa6vl3XXrBh0HFf0
         9MtwzzO/GZin40gE2PzSqzDaNbkPR2OY6lN2E3e+v8Ul5d5FC82m6obX5KoS/6woH18e
         ACqE6xCiB3srPfRtxvYbDlZ3IPMid8b+DDobBJ9sSLTaAPeQx871KuywJ6Rl3xv1oYTe
         EgNJSaZUo2YyiKg7jkGs4WXiaKbIOaOnc9Nd5u9SvkE9F6CAx7bsPBJua7mR2P3YUZNc
         sRCQ==
X-Gm-Message-State: AOAM533HqUQKerSl/KiSI1K2+khha45RFdgTBKcYAZIlybOa8E3Ebgov
        PBoYdX5ngqAexxyge1ubpfMjg2+g9OU=
X-Google-Smtp-Source: ABdhPJyv/nXJ6jqUnFK1YSLBHWALjvbKGaD2EgXaa8fpdAV1hkKMgtKDwfZNovwsvwlzZg4ZkLiZfA==
X-Received: by 2002:a17:906:1386:: with SMTP id f6mr4626744ejc.45.1615491924807;
        Thu, 11 Mar 2021 11:45:24 -0800 (PST)
Received: from msft-t490s.teknoraver.net (net-188-216-41-250.cust.vodafonedsl.it. [188.216.41.250])
        by smtp.gmail.com with ESMTPSA id t16sm1875652edi.60.2021.03.11.11.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:45:24 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [RFC net-next 6/6] mvneta: recycle buffers
Date:   Thu, 11 Mar 2021 20:42:56 +0100
Message-Id: <20210311194256.53706-7-mcroce@linux.microsoft.com>
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
In a drop rate test, the packet rate increased di 10%,
from 269 Kpps to 296 Kpps.

perf top on a stock system shows:

Overhead  Shared Object     Symbol
  21.78%  [kernel]          [k] __pi___inval_dcache_area
  21.66%  [mvneta]          [k] mvneta_rx_swbm
   7.00%  [kernel]          [k] kmem_cache_alloc
   6.05%  [kernel]          [k] eth_type_trans
   4.44%  [kernel]          [k] kmem_cache_free.part.0
   3.80%  [kernel]          [k] __netif_receive_skb_core
   3.68%  [kernel]          [k] dev_gro_receive
   3.65%  [kernel]          [k] get_page_from_freelist
   3.43%  [kernel]          [k] page_pool_release_page
   3.35%  [kernel]          [k] free_unref_page

And this is the same output with recycling enabled:

Overhead  Shared Object     Symbol
  24.10%  [kernel]          [k] __pi___inval_dcache_area
  23.02%  [mvneta]          [k] mvneta_rx_swbm
   7.19%  [kernel]          [k] kmem_cache_alloc
   6.50%  [kernel]          [k] eth_type_trans
   4.93%  [kernel]          [k] __netif_receive_skb_core
   4.77%  [kernel]          [k] kmem_cache_free.part.0
   3.93%  [kernel]          [k] dev_gro_receive
   3.03%  [kernel]          [k] build_skb
   2.91%  [kernel]          [k] page_pool_put_page
   2.85%  [kernel]          [k] __xdp_return

The test was done with mausezahn on the TX side with 64 byte raw
ethernet frames.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index a635cf84608a..8b3250394703 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2332,7 +2332,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
+	skb_mark_for_recycle(skb, virt_to_page(xdp->data), &xdp->rxq->mem);
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
@@ -2344,7 +2344,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				skb_frag_page(frag), skb_frag_off(frag),
 				skb_frag_size(frag), PAGE_SIZE);
-		page_pool_release_page(rxq->page_pool, skb_frag_page(frag));
+		skb_mark_for_recycle(skb, skb_frag_page(frag), &xdp->rxq->mem);
 	}
 
 	return skb;
-- 
2.29.2

