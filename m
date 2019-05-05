Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0942013F26
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfEELRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46767 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbfEELRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:23 -0400
Received: by mail-pf1-f195.google.com with SMTP id j11so5193383pff.13
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yDDWnqDumzVZWPjjOeCYzgaK/ZpYDkJkKWt64ZC5g30=;
        b=TKZrg2wclwTRzBVnLG1Zzd+dXtNs/BMez/pyU5NfLNj5HH8bsmwOcAe+rHihe2uIUw
         YjAWWRzE2qh+7YYmlE56669Wbx+Lqqdq1m00B5eDGlrEUg7YESN6/ueWaI/E1EseKoJV
         puuC1Ibt9oEcjTRWMWsXVyGXevduS8d/j1vlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yDDWnqDumzVZWPjjOeCYzgaK/ZpYDkJkKWt64ZC5g30=;
        b=arQcHFfbx7PvW2lcDsL7R5o5metjGtYOvek6xvWewp4XxjugKzvrR8vowM+ICHew0M
         zvlh7q6khm+VGKxmCuEm+J4w2MA09fwNR+0cXCV9QylJuEYkjegyJZ1LpJqaCibNLlnV
         1USSUnZ+Aq31J4FVs+qb2w4y9XCfv+/6YdMe3SVZMgzX6/h+C+aQ/cNFSTkc2SPBJN7j
         czf2CtLMDevEcxV/B/wS9DJvZLjhAC3/fJ1fqWMJgtkdDKaIufYgs2FqOQdhvgLc6kYp
         dnOYRB871K4akbsf0HfGt80DJviA+Oh+mmjXAXFhUo6whH8uPSP7bs8zb5Mik3+P0P/3
         w1PA==
X-Gm-Message-State: APjAAAUQWd+CUvphy2tr1G4UfgfvxdtZ7ZaaMc6lLk58qWSIe58z3lPl
        PsSy49e8/3E62eWO2tWfVIUa4A==
X-Google-Smtp-Source: APXvYqzYxZaNRPE9BOVQqD1B2qZFc5R5zxVcc3mf0ugL26ETiDCRoqgzrOacOZHOGOCB7U780KGclg==
X-Received: by 2002:a63:6f0b:: with SMTP id k11mr295685pgc.342.1557055042067;
        Sun, 05 May 2019 04:17:22 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:21 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 02/11] bnxt_en: Refactor bnxt_alloc_stats().
Date:   Sun,  5 May 2019 07:16:59 -0400
Message-Id: <1557055028-14816-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Reverse the condition of the large "if" block and return early.  This
will simplify the follow up patch to add PCIe statistics.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 75 +++++++++++++++----------------
 1 file changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a0de3c3..1fb6d5e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3440,56 +3440,53 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 		cpr->hw_stats_ctx_id = INVALID_STATS_CTX_ID;
 	}
 
-	if (BNXT_PF(bp) && bp->chip_num != CHIP_NUM_58700) {
-		if (bp->hw_rx_port_stats)
-			goto alloc_ext_stats;
+	if (BNXT_VF(bp) || bp->chip_num == CHIP_NUM_58700)
+		return 0;
 
-		bp->hw_port_stats_size = sizeof(struct rx_port_stats) +
-					 sizeof(struct tx_port_stats) + 1024;
+	if (bp->hw_rx_port_stats)
+		goto alloc_ext_stats;
 
-		bp->hw_rx_port_stats =
-			dma_alloc_coherent(&pdev->dev, bp->hw_port_stats_size,
-					   &bp->hw_rx_port_stats_map,
-					   GFP_KERNEL);
-		if (!bp->hw_rx_port_stats)
-			return -ENOMEM;
+	bp->hw_port_stats_size = sizeof(struct rx_port_stats) +
+				 sizeof(struct tx_port_stats) + 1024;
+
+	bp->hw_rx_port_stats =
+		dma_alloc_coherent(&pdev->dev, bp->hw_port_stats_size,
+				   &bp->hw_rx_port_stats_map,
+				   GFP_KERNEL);
+	if (!bp->hw_rx_port_stats)
+		return -ENOMEM;
 
-		bp->hw_tx_port_stats = (void *)(bp->hw_rx_port_stats + 1) +
-				       512;
-		bp->hw_tx_port_stats_map = bp->hw_rx_port_stats_map +
-					   sizeof(struct rx_port_stats) + 512;
-		bp->flags |= BNXT_FLAG_PORT_STATS;
+	bp->hw_tx_port_stats = (void *)(bp->hw_rx_port_stats + 1) + 512;
+	bp->hw_tx_port_stats_map = bp->hw_rx_port_stats_map +
+				   sizeof(struct rx_port_stats) + 512;
+	bp->flags |= BNXT_FLAG_PORT_STATS;
 
 alloc_ext_stats:
-		/* Display extended statistics only if FW supports it */
-		if (bp->hwrm_spec_code < 0x10804 ||
-		    bp->hwrm_spec_code == 0x10900)
-			return 0;
+	/* Display extended statistics only if FW supports it */
+	if (bp->hwrm_spec_code < 0x10804 || bp->hwrm_spec_code == 0x10900)
+		return 0;
 
-		if (bp->hw_rx_port_stats_ext)
-			goto alloc_tx_ext_stats;
+	if (bp->hw_rx_port_stats_ext)
+		goto alloc_tx_ext_stats;
 
-		bp->hw_rx_port_stats_ext =
-			dma_alloc_coherent(&pdev->dev,
-					   sizeof(struct rx_port_stats_ext),
-					   &bp->hw_rx_port_stats_ext_map,
-					   GFP_KERNEL);
-		if (!bp->hw_rx_port_stats_ext)
-			return 0;
+	bp->hw_rx_port_stats_ext =
+		dma_alloc_coherent(&pdev->dev, sizeof(struct rx_port_stats_ext),
+				   &bp->hw_rx_port_stats_ext_map, GFP_KERNEL);
+	if (!bp->hw_rx_port_stats_ext)
+		return 0;
 
 alloc_tx_ext_stats:
-		if (bp->hw_tx_port_stats_ext)
-			return 0;
+	if (bp->hw_tx_port_stats_ext)
+		return 0;
 
-		if (bp->hwrm_spec_code >= 0x10902) {
-			bp->hw_tx_port_stats_ext =
-				dma_alloc_coherent(&pdev->dev,
-						   sizeof(struct tx_port_stats_ext),
-						   &bp->hw_tx_port_stats_ext_map,
-						   GFP_KERNEL);
-		}
-		bp->flags |= BNXT_FLAG_PORT_STATS_EXT;
+	if (bp->hwrm_spec_code >= 0x10902) {
+		bp->hw_tx_port_stats_ext =
+			dma_alloc_coherent(&pdev->dev,
+					   sizeof(struct tx_port_stats_ext),
+					   &bp->hw_tx_port_stats_ext_map,
+					   GFP_KERNEL);
 	}
+	bp->flags |= BNXT_FLAG_PORT_STATS_EXT;
 	return 0;
 }
 
-- 
2.5.1

