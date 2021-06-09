Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1E33A1600
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhFINuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:50:12 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:45611 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbhFINuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:50:09 -0400
Received: by mail-wr1-f51.google.com with SMTP id z8so25531988wrp.12;
        Wed, 09 Jun 2021 06:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ob6PnWhKav7jMFqFY+b+WTV4eaWghvwiq60OTVa4u2A=;
        b=GYHSeZPo34jeBLHh/sCUIdxO1hQZh36/JnIyZDl0LES2nd23mJwjBw3GSlGkBfOQJx
         sR8vGgFXr+jt+aMIR3dvvAzZep2RdTIGtGjLZvB3GlJvlqUzG+i/DqPfqKxVlRzKa1uk
         J36X2QQ6rlpPy7AplDQ2dosl9aMrEG09mPl7Q+XmVpFkqbKpo7wMxl92lPHZh8FtmEy4
         dGp+t+CIoXh6d23izgxdotfQbERpnyTbftiFvEbGT2bMUlPmHghsM4A+/kpVvznSG+sN
         aF1TRHZbn0luDb5XzVQ8ZDLG4VdQLFrGjJR1DT/UBDcFLBwbpjMbu7kF/uwYtgJv8RC8
         nZSA==
X-Gm-Message-State: AOAM5301qvP4bTOAQxGu0WjirDJp039bqUg1hk8u7UdQPR/0JcdETMxT
        yGVYEChX2yKpqdLfGYCm8uRPsMBkht+EXg==
X-Google-Smtp-Source: ABdhPJyaQfaop0D//baox/2aMwkJjAdH0+kRl4J2HwWcdWYJxkqS9EQfqvwqrw4W6zuMhvoxcFMRZw==
X-Received: by 2002:adf:f78d:: with SMTP id q13mr27990870wrp.191.1623246493659;
        Wed, 09 Jun 2021 06:48:13 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id o5sm13882351wrw.65.2021.06.09.06.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 06:48:13 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next 2/2] mvpp2: prefetch page
Date:   Wed,  9 Jun 2021 15:47:14 +0200
Message-Id: <20210609134714.13715-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609134714.13715-1-mcroce@linux.microsoft.com>
References: <20210609134714.13715-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Most of the time during the RX is caused by the compound_head() call
done at the end of the RX loop:

       │     build_skb():
       [...]
       │     static inline struct page *compound_head(struct page *page)
       │     {
       │     unsigned long head = READ_ONCE(page->compound_head);
 65.23 │       ldr  x2, [x1, #8]

Prefetch the page struct as soon as possible, to speedup the RX path
noticeabily by a ~3-4% packet rate in a drop test.

       │     build_skb():
       [...]
       │     static inline struct page *compound_head(struct page *page)
       │     {
       │     unsigned long head = READ_ONCE(page->compound_head);
 17.92 │       ldr  x2, [x1, #8]

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 07d8f3e31b52..9bca8c8f9f8d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3900,15 +3900,19 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		phys_addr_t phys_addr;
 		u32 rx_status, timestamp;
 		int pool, rx_bytes, err, ret;
+		struct page *page;
 		void *data;
 
+		phys_addr = mvpp2_rxdesc_cookie_get(port, rx_desc);
+		data = (void *)phys_to_virt(phys_addr);
+		page = virt_to_page(data);
+		prefetch(page);
+
 		rx_done++;
 		rx_status = mvpp2_rxdesc_status_get(port, rx_desc);
 		rx_bytes = mvpp2_rxdesc_size_get(port, rx_desc);
 		rx_bytes -= MVPP2_MH_SIZE;
 		dma_addr = mvpp2_rxdesc_dma_addr_get(port, rx_desc);
-		phys_addr = mvpp2_rxdesc_cookie_get(port, rx_desc);
-		data = (void *)phys_to_virt(phys_addr);
 
 		pool = (rx_status & MVPP2_RXD_BM_POOL_ID_MASK) >>
 			MVPP2_RXD_BM_POOL_ID_OFFS;
@@ -3997,7 +4001,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		}
 
 		if (pp)
-			skb_mark_for_recycle(skb, virt_to_page(data), pp);
+			skb_mark_for_recycle(skb, page, pp);
 		else
 			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
-- 
2.31.1

