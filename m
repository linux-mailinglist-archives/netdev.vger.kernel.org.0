Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C055A3E1A22
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 19:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbhHERLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 13:11:36 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:44666 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhHERLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 13:11:36 -0400
Received: by mail-ed1-f53.google.com with SMTP id z11so9380644edb.11;
        Thu, 05 Aug 2021 10:11:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Zmyx7SsE2CZ1f1aWOzazG1eiYj3hoTl2IjNLvtlL+c=;
        b=qgnyCcg/el3xzLC+YMccrG8L9cy6IW6bD4bYqpQOhunlwwY5QOWK2HT6EmBBc6MTTU
         Qn+xOdqbXc/IaAhJ8JfVH2NGFyXMeAX7E2NlxJoSU37Zb2y5D6Andfi/l2rnUTHtMpDu
         xf6mMI4SHtDTC4wiUXGF9P88kRoOCzD3eXJeeYlDG8XdaG140yDHpjc4T0pfCrQkbaMy
         4s/q33IpiSfNb6cbn7/9Lz9e+ZSzifE6eC4piW0zx56ZjU2pnNkeQRYT+hr+clUXy2/0
         G6/32aPY1wIeSyGhFA4R7F6JR77nmUXejSteiJWf1KM2uX3MX5FcUC4CjcMdnjGxhF2x
         J57g==
X-Gm-Message-State: AOAM5314wRR0s2LCL4O3YEYVKZXCyAEXqcusBkDbxpgi6YNlkGqedVPw
        +dkmxb7gdtroGbBJ3yJs/tKnzrPzxDMXLw==
X-Google-Smtp-Source: ABdhPJzLqHFvCFevmrya4YFKb6AejF9zs+3Of0jN857PIM+ynmoddWFCAw8SdwMdoDtjp3aQ+rbMlw==
X-Received: by 2002:a05:6402:13d8:: with SMTP id a24mr7911446edx.158.1628183479714;
        Thu, 05 Aug 2021 10:11:19 -0700 (PDT)
Received: from msft-t490s.fritz.box (host-80-116-27-227.retail.telecomitalia.it. [80.116.27.227])
        by smtp.gmail.com with ESMTPSA id n2sm2592655edi.32.2021.08.05.10.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 10:11:19 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFT net-next 2/2] stmmac: skb recycling
Date:   Thu,  5 Aug 2021 19:11:01 +0200
Message-Id: <20210805171101.13776-3-mcroce@linux.microsoft.com>
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 30a0d915cd4b..2c48f1b5e9e9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5219,7 +5219,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			skb_reserve(skb, buf->page_offset);
 			skb_put(skb, buf1_len);
 
-			page_pool_release_page(rx_q->page_pool, buf->page);
+			skb_mark_for_recycle(skb, buf->page, rx_q->page_pool);
 			buf->page = NULL;
 		} else if (buf1_len) {
 			dma_sync_single_for_cpu(priv->device, buf->addr,
@@ -5229,7 +5229,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 					priv->dma_buf_sz);
 
 			/* Data payload appended into SKB */
-			page_pool_release_page(rx_q->page_pool, buf->page);
+			page_pool_store_mem_info(buf->page, rx_q->page_pool);
 			buf->page = NULL;
 		}
 
@@ -5241,7 +5241,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 					priv->dma_buf_sz);
 
 			/* Data payload appended into SKB */
-			page_pool_release_page(rx_q->page_pool, buf->sec_page);
+			page_pool_store_mem_info(buf->sec_page, rx_q->page_pool);
 			buf->sec_page = NULL;
 		}
 
-- 
2.31.1

