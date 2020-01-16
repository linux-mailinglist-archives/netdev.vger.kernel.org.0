Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE87113E19E
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgAPQrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:47:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729547AbgAPQrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7EBE207FF;
        Thu, 16 Jan 2020 16:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193223;
        bh=dAs/zNG/m+VHy0DYPM6tcOxHAC0qIG1JB0YFDX/OnZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLyrxKrUf6JvIKh67lmBcPTEKw/NvUZPci1U67WINGt4UbDmDTDiYPuXH/OcWIixm
         YG+9WY0Y3g2qNtAW4UNjHGe2ei1fMk0RsGQVqLSB2KjVnelOTcKzJD0WUb/pqkW+Cf
         dveCKyON+GdWJXN48yCkOjkyRatbKTVRKEhAG6TY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 049/205] net: netsec: Correct dma sync for XDP_TX frames
Date:   Thu, 16 Jan 2020 11:40:24 -0500
Message-Id: <20200116164300.6705-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

[ Upstream commit d9496f3ecfe4823c1e12aecbcc29220147fa012c ]

bpf_xdp_adjust_head() can change the frame boundaries. Account for the
potential shift properly by calculating the new offset before
syncing the buffer to the device for XDP_TX

Fixes: ba2b232108d3 ("net: netsec: add XDP support")
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index f9e6744d8fd6..41ddd8fff2a7 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -847,8 +847,8 @@ static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
 		enum dma_data_direction dma_dir =
 			page_pool_get_dma_dir(rx_ring->page_pool);
 
-		dma_handle = page_pool_get_dma_addr(page) +
-			NETSEC_RXBUF_HEADROOM;
+		dma_handle = page_pool_get_dma_addr(page) + xdpf->headroom +
+			sizeof(*xdpf);
 		dma_sync_single_for_device(priv->dev, dma_handle, xdpf->len,
 					   dma_dir);
 		tx_desc.buf_type = TYPE_NETSEC_XDP_TX;
-- 
2.20.1

