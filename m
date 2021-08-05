Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8FA3E1A20
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 19:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbhHERLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 13:11:32 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:46600 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhHERLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 13:11:31 -0400
Received: by mail-ej1-f44.google.com with SMTP id gs8so10669941ejc.13;
        Thu, 05 Aug 2021 10:11:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D7+jxX/JlbsLDgJC0GgP7ELLd+nfENBJ343/im26+GM=;
        b=Xx+/Wn+dQDyGDn4eOM/NYetuH/jvHii2M4D6mhruGiPUA6zmqobFve36IKyfHfga9p
         3h1dKJ7fgG8wwPm30VcZca1bnNJCCixE/rHDgzkxN0q+yUxaBDPC42japzPCVskawbFt
         p0P70+dF5uHpBq4Mp3T3OZBZvyNQHltjsZE2ThRiiKO47IhJZlrwfdigE2uR0qjq0S4S
         73ln8/k2koy0DQYH8TBkDLMhNYeyvOvtgDY7oPBkvpkedFFEVfoCHhtgPNk9cZcRU1rL
         0dBkmE+ZUbE8nIsBCU+MU5jPwwkgjqQOtd79HC1zdVlWViGJyNkr3U0M+NmoAnaDcZi6
         Epug==
X-Gm-Message-State: AOAM531UPjSeI3Hiz0u4wQuWdwmnKAAr9dptMnwmM298CDJiQEyUR74y
        o4AqLZyHW7neESVwk+hVb3aq5MheEb3IAA==
X-Google-Smtp-Source: ABdhPJygIfEvBUqlx0/X5AzYLa/bnmtDp5d4zz7lx3m8P24V0rWS5lGo5uMBsVpMwgA+mF2pSX/rQg==
X-Received: by 2002:a17:906:fb0a:: with SMTP id lz10mr5878137ejb.502.1628183475524;
        Thu, 05 Aug 2021 10:11:15 -0700 (PDT)
Received: from msft-t490s.fritz.box (host-80-116-27-227.retail.telecomitalia.it. [80.116.27.227])
        by smtp.gmail.com with ESMTPSA id n2sm2592655edi.32.2021.08.05.10.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 10:11:15 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFT net-next 1/2] stmmac: use build_skb()
Date:   Thu,  5 Aug 2021 19:11:00 +0200
Message-Id: <20210805171101.13776-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805171101.13776-1-mcroce@linux.microsoft.com>
References: <20210805171101.13776-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a2aa75cb184e..30a0d915cd4b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5208,7 +5208,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			/* XDP program may expand or reduce tail */
 			buf1_len = xdp.data_end - xdp.data;
 
-			skb = napi_alloc_skb(&ch->rx_napi, buf1_len);
+			skb = build_skb(xdp.data_hard_start, PAGE_SIZE);
 			if (!skb) {
 				priv->dev->stats.rx_dropped++;
 				count++;
@@ -5216,11 +5216,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			}
 
 			/* XDP program may adjust header */
-			skb_copy_to_linear_data(skb, xdp.data, buf1_len);
+			skb_reserve(skb, buf->page_offset);
 			skb_put(skb, buf1_len);
 
-			/* Data payload copied into SKB, page ready for recycle */
-			page_pool_recycle_direct(rx_q->page_pool, buf->page);
+			page_pool_release_page(rx_q->page_pool, buf->page);
 			buf->page = NULL;
 		} else if (buf1_len) {
 			dma_sync_single_for_cpu(priv->device, buf->addr,
-- 
2.31.1

