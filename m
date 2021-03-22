Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E703B344CBA
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhCVRFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:05:01 -0400
Received: from mail-ej1-f43.google.com ([209.85.218.43]:39429 "EHLO
        mail-ej1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbhCVREe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:04:34 -0400
Received: by mail-ej1-f43.google.com with SMTP id ce10so22483417ejb.6;
        Mon, 22 Mar 2021 10:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ihzH3n3aHmXKOtcPI8KDnr7LGDtclLmi/Ni6ekZYQ8Q=;
        b=RAQiCc6Iu0MyRhjmihJEEZYBD37Y0pptCTJIZRdJ9iEBg8sf0YpzocyiQVkLu14EQO
         9HBa4ax7PyKRH4BrIbQXBIJx9kWWvHV9r7Irn5+53AA5rpPnMRkJqq6XdEtc790vUIXT
         shU1vGiMeCZRRu3cWwyW/cKPNWrHzOX/ttEfDzlnK4Jj8ZqO4UlUVHnQTWx78owKxiye
         SKLiHuYN2RmA9FYQUwKSsk4RV9U3s+c6mgE0yTYfx/mzIDi9L6m+bMIpbZ4Aav7w3RwI
         EdwaVcONh8MrSTBjiOvcMJV96s3CtA+zQLpzSN0rfeOuvZGU5jvho0U5g+y+dWS/WiJO
         61DA==
X-Gm-Message-State: AOAM531PIx8och63vuMgqRRISOgRvRLFHnbrfWy7c6fSeKy1aL/jCMhU
        HpQPNFyWK5YVxMoC5rCmJAVMrqnMVRc=
X-Google-Smtp-Source: ABdhPJxG8i7OUEAd0loUyPeeBTqEPCwSXanQojoNFFaiLHW681sxXpFa0WXn3zRQV8XnnT/Cr7jfYA==
X-Received: by 2002:a17:906:3f88:: with SMTP id b8mr854411ejj.36.1616432673283;
        Mon, 22 Mar 2021 10:04:33 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id h22sm9891589eji.80.2021.03.22.10.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:04:32 -0700 (PDT)
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
Subject: [PATCH net-next 6/6] mvneta: recycle buffers
Date:   Mon, 22 Mar 2021 18:03:01 +0100
Message-Id: <20210322170301.26017-7-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322170301.26017-1-mcroce@linux.microsoft.com>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
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
2.30.2

