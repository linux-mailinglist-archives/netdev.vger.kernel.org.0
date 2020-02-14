Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E57E115EC93
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390819AbgBNQH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390040AbgBNQH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EFEA24676;
        Fri, 14 Feb 2020 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696476;
        bh=IDpon7Kel+MjWfOUEwoMjIHhIYdi6Oyu2TpugZYs3X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+1HwI2dY2R7hdokZMOQQusQH/hOmBj6RBUqURwoWhUKesj4LSTgV6Y1mePg+49Gy
         GN9ILySibHfH2SHrnyREdcSyMRT8P8cLNis0Bp/pyGfEXkIAIJ3i4/4Tcla27RZwY1
         4j4BGncnjhrnMZPtw8HVJkQpJzwe8mT6mx9Puxo0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 284/459] bnxt: Detach page from page pool before sending up the stack
Date:   Fri, 14 Feb 2020 10:58:54 -0500
Message-Id: <20200214160149.11681-284-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index 41297533b4a86..68618891b0e42 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -942,6 +942,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 	dma_addr -= bp->rx_dma_offset;
 	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
 			     DMA_ATTR_WEAK_ORDERING);
+	page_pool_release_page(rxr->page_pool, page);
 
 	if (unlikely(!payload))
 		payload = eth_get_headlen(bp->dev, data_ptr, len);
-- 
2.20.1

