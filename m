Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57605BB1C9
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 11:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407465AbfIWJ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 05:59:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40224 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405009AbfIWJ7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 05:59:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id b24so8557448wmj.5;
        Mon, 23 Sep 2019 02:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pZat5lUolRKbSmxaPbyGXxDk1B7dZYPUSUq5sLmm1BQ=;
        b=hUWQSES5Ny2aMoCeHoPOJHTls6VRirtd7g83AFcCswq6McQ4GLtm6ywiCqRvvJF8X8
         kV6LcSvdKlYrUMSI/jFc5rrl82uenzGimh1grCiYylU+o00XZtRmirsQgdw5cJuELQd8
         vXT7yqit1bfLPeqqB7OrKO5gLD5El39KoRsdIJJt+ZX07Z61pjYSKxOcm+6AefhGrIXN
         fGzgELM4FVEc7XI9X4CyAiVodX60G3sTOC8GKexpCcIf7kerP3ZhWcz8QhhfG8LE0RpB
         4I3VgwJWUmzlhJJgupK1WSHslnu4mqww8C8BYy5KxO5h+op8L6zJijngR1pR6f7+fR6t
         2wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pZat5lUolRKbSmxaPbyGXxDk1B7dZYPUSUq5sLmm1BQ=;
        b=H+AIf8pJ+8vmp/GtrLEhpeylhywo4GFPrhDbssnPxHuO8fp667zd20hPlrM7jSTgXp
         65kKtM4/nnCutm9D5X97M8IS6QEL4Y2/d5+jxI51vQ0LO6kH70Rt1Nf6z/t1AOvhGylp
         or7urRehvqZPMXhtfkz44rOCo1lsIoHNRkcgOQ66gdRUi6y03phcJ+9VGqyNUkyL4wM3
         SD1uaUiZuGiGUut2m3MQ3YAs+Ze7TO/ddkTf9iHIGLISSnEmBGl979RLpkJywIEKHONb
         ec5Z7Mwn/7WjkDyPeipc250xYF28hhS6eztAB4rR8lIYwQngzBxiSNpnUXg+bjCqmSlx
         LIeA==
X-Gm-Message-State: APjAAAU+CbUQcEExnQ3VSLClP3NSX5PHtYfgqbTU0hSry7RKGFX+a/zm
        1h3PsCy8nkAy+z/mM2SDn3s=
X-Google-Smtp-Source: APXvYqxxCZUafviZ7h5BmtmdIFCNc6ycWGOFv3lEZWRlsrhIUMvFD8zg/JW4je9birbP9Sc/TmdMCg==
X-Received: by 2002:a1c:7418:: with SMTP id p24mr12409366wmc.132.1569232757976;
        Mon, 23 Sep 2019 02:59:17 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id t6sm16422059wmf.8.2019.09.23.02.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 02:59:16 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: Fix page pool size
Date:   Mon, 23 Sep 2019 11:59:15 +0200
Message-Id: <20190923095915.11588-1-thierry.reding@gmail.com>
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

Fixes: 2af6106ae949 ("net: stmmac: Introducing support for Page Pool")
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

