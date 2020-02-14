Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5F915F167
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgBNSCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731777AbgBNPz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C55B024682;
        Fri, 14 Feb 2020 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695756;
        bh=TR7zXGPKrRyVAFY0prVY1a+2it4hknv8ec1MtPqoews=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeDm6iDT553JvrY5yDfm13TB5k8nOzwb+I+8SQ/q8zIVPET5rtkGyxHP+rsLMmM8r
         BxFvIt15YawQVqhff/gOLlraM7wCJLwoJKl9Wgdw93h+Uvc8UYi3Knv4OQIQLrEu7+
         him20fiOkv3TL6TMvbkpKkFsWpPLJ+HRZL1Xp2Yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 325/542] bnxt: Detach page from page pool before sending up the stack
Date:   Fri, 14 Feb 2020 10:45:17 -0500
Message-Id: <20200214154854.6746-325-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit 3071c51783b39d6a676d02a9256c3b3f87804285 ]

When running in XDP mode, pages come from the page pool, and should
be freed back to the same pool or specifically detached.  Currently,
when the driver re-initializes, the page pool destruction is delayed
forever since it thinks there are oustanding pages.

Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 01b603c5e76ad..9d62200b6c335 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -944,6 +944,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 	dma_addr -= bp->rx_dma_offset;
 	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
 			     DMA_ATTR_WEAK_ORDERING);
+	page_pool_release_page(rxr->page_pool, page);
 
 	if (unlikely(!payload))
 		payload = eth_get_headlen(bp->dev, data_ptr, len);
-- 
2.20.1

