Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F9DB9621
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 19:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391863AbfITRBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 13:01:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38338 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391591AbfITRBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 13:01:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so7482316wrx.5;
        Fri, 20 Sep 2019 10:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HCtYy1oIkkXnCU1sRsRDsgHD2IvigT7Js2Tb5RJ2iT4=;
        b=T16y3fUOvcmSAfLSXdM9ch9G717GwLX9AWdReeOgRUKZ1Lrwtove8tX7oVg+Jvd2hu
         55Di6xP7aW6l5DADXPpvaDuQ5/oAlvKC4HbcRuv7xc/awOIWG0ZdbILd7SK6uwWOuge5
         SzFdyIAyHeRXEx7U+lckprXGxEGTvkZ7Hm2lGZUAIzIdTxcPxNNvCx6++aUyWKH9H6ne
         I7xuCQAcsXhCt3Pp/N74ta4yFkRKnQ3ywUTUpmJDmJGjz0Qc8JffGnk9K7sPXzX+6WlC
         5mHy2dPX3JFXxTjAg8ne3ryQbkrU4E4GJg4IuJPV5RqYdN8QwzRmHjKQvZyq5qDUlmSX
         XdEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HCtYy1oIkkXnCU1sRsRDsgHD2IvigT7Js2Tb5RJ2iT4=;
        b=kMmAEdD6VwTEImsWG9ZF4lPR0Lp0oABKvb8lFPsW1Q7qYfIHCieoG3UgKAdlld9JGt
         FfNw7xDjPDSGZLgZjvmSt7kayjEb3PHV3IkFf/AIKGhp6y0zkqbBAUzltyVi0pWrJbbH
         m1UKS7nzrpsXPoHVYpkL5DgqOAxw4wLQJE8l1ydIqA3vL66c7wHev1ofe/rraI4YcRFF
         ta7UXtBFtPih132ZC5EuV+wC/S+wJIqZIjdN0UXFdx2/t2YXxaGcCa+0yz0Kn8UHP8Kx
         /lN6F45zFpQOEuWV4/khjbvN7tWj/x3bW1zZXpgMVuZcNVr+JdKoOHiLd05GJ/TcIp8M
         MiyA==
X-Gm-Message-State: APjAAAWTLwC+MOGpgNRMrVw8XRL6CTQ1qG+cb8g0GWac5aOMTspugUcW
        UvuPdkoEAmwuhsVMtXht5qU=
X-Google-Smtp-Source: APXvYqzOfxXrLIlVZuo9vljFMoGcdaULkJY0ceMQw96GmUjbrx/99nzMNArs9UWv8X8e+2xRn7zs+Q==
X-Received: by 2002:adf:dc91:: with SMTP id r17mr12645534wrj.22.1568998889048;
        Fri, 20 Sep 2019 10:01:29 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id b16sm3397225wrh.5.2019.09.20.10.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 10:01:28 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH] net: stmmac: Fix page pool size
Date:   Fri, 20 Sep 2019 19:01:27 +0200
Message-Id: <20190920170127.22850-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The size of individual pages in the page pool in given by an order. The
order is the binary logarithm of the number of pages that make up one of
the pages in the pool. However, the driver currently passes the number
of pages rather than the order, so it ends up wasting quite a bit of
memory.

Fix this by taking the binary logarithm and passing that in the order
field.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ecd461207dbc..f8c90dba6db8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1550,13 +1550,15 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 	for (queue = 0; queue < rx_count; queue++) {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 		struct page_pool_params pp_params = { 0 };
+		unsigned int num_pages;
 
 		rx_q->queue_index = queue;
 		rx_q->priv_data = priv;
 
 		pp_params.flags = PP_FLAG_DMA_MAP;
 		pp_params.pool_size = DMA_RX_SIZE;
-		pp_params.order = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+		num_pages = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+		pp_params.order = ilog2(num_pages);
 		pp_params.nid = dev_to_node(priv->device);
 		pp_params.dev = priv->device;
 		pp_params.dma_dir = DMA_FROM_DEVICE;
-- 
2.23.0

