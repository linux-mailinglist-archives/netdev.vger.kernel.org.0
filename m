Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E1C1216FC
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbfLPSdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:33:04 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39588 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730833AbfLPSdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:33:02 -0500
Received: by mail-pj1-f65.google.com with SMTP id v93so3355697pjb.6
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 10:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=muvIZPXZzFYwA2KnEz8hZgGKrX75pxgv3Lg3oHbwLBw=;
        b=q0owXzgWorl+IT7EkpCMUN7xBbxlHC/mqAg9W9RTyNS1DZPouBDeAjh2z75XOKd2XM
         H2zvMJ4+D+vRCyLPoV6/ukez7dhju4BzISB2MFuIgVn9R1bF60KrQ550ejjEjQQhfJ3d
         R6NMNgCf9eQ1IK4+oUHoP4GJq41qma1QJ5kd37GC7FjKlmfruE/dmor9jXZdFrXVKioA
         MjjovHVvZIdkz64f6uLojQxp16D0wP4RaCry0+ZHNRAZb/NA2qnA5ZNWLVFXFDoN8Puk
         qTHH3zv1kSFftAZkAo5ErJVGH268XiYuT8vWzHBZEYjeH53PXUOGImxAgc3iof0dfak+
         TCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=muvIZPXZzFYwA2KnEz8hZgGKrX75pxgv3Lg3oHbwLBw=;
        b=rx8fPSaXrhpNFaax4TAnhztqsrjlV2VC+tWfNxnwp74azV0vZBzyhByYbP1J152C92
         TH9FqmumAypddugp0sWW/rI1Pou1138P++6YA1kw8omwCdJDsHFlm3bC+W3K2ceT3S1E
         s+Gghy7kuFVW/WPxSbkgSRNL5zDQDNYDyI4+z1wYeegOrPjF0RABWPzABx0tNve1twEw
         Jr3kbD2RIGjz9EzEH0AKFi2ef1gdNTNyeMkDKu2DMSCugKCOiDFLlJ+CwIlMZxE0zIJs
         hqhD376XD43QCNXQi5EU9bIZ415hafwSIMezEQPyqYRf4pRuOKAZ1/3G3ELpVtjd1dkx
         pZdw==
X-Gm-Message-State: APjAAAWhV0Oh3tdNvviBLQR/k7mM3J1YKSyjqXMbF67aVqumdsyzaN3l
        RWaZl0IBvf0ZMT64F9aIWK9gbcR8
X-Google-Smtp-Source: APXvYqygLqbMNydAuYdfkCmF+8oCs3Vw2xkRqAtHA6tCsjJGXCzAIzsezFGkNLbfktPTVScTqWNo8w==
X-Received: by 2002:a17:902:bd85:: with SMTP id q5mr4061608pls.17.1576521181571;
        Mon, 16 Dec 2019 10:33:01 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d65sm23400738pfa.159.2019.12.16.10.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 10:33:00 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 2/3] net: axienet: Support software transmit time stamping.
Date:   Mon, 16 Dec 2019 10:32:55 -0800
Message-Id: <79b2d20c323484b8f86690ea56dae52b1be6a8e9.1576520432.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576520432.git.richardcochran@gmail.com>
References: <cover.1576520432.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC drivers are expected to invoke the transmit time stamping hook in
order to support both software time stamping and PHY time stamping.
This patch adds the missing hook.  In addition, drivers calling
netif_rx() should first check for PHY time stamping by calling
skb_defer_rx_timestamp().

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 53644abe52da..05fa7371c39a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -675,6 +675,9 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p->skb = skb;
 
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
+
+	skb_tx_timestamp(skb);
+
 	/* Start the transfer */
 	axienet_dma_out32(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
 	if (++lp->tx_bd_tail >= lp->tx_bd_num)
@@ -736,7 +739,8 @@ static void axienet_recv(struct net_device *ndev)
 			skb->ip_summed = CHECKSUM_COMPLETE;
 		}
 
-		netif_rx(skb);
+		if (!skb_defer_rx_timestamp(skb))
+			netif_rx(skb);
 
 		size += length;
 		packets++;
@@ -1367,6 +1371,7 @@ static const struct ethtool_ops axienet_ethtool_ops = {
 	.set_pauseparam = axienet_ethtools_set_pauseparam,
 	.get_coalesce   = axienet_ethtools_get_coalesce,
 	.set_coalesce   = axienet_ethtools_set_coalesce,
+	.get_ts_info	= ethtool_op_get_ts_info,
 	.get_link_ksettings = axienet_ethtools_get_link_ksettings,
 	.set_link_ksettings = axienet_ethtools_set_link_ksettings,
 };
-- 
2.20.1

