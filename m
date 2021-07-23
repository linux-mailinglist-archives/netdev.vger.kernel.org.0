Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296093D3289
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 05:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbhGWDRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233720AbhGWDQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 23:16:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ACCC60ED7;
        Fri, 23 Jul 2021 03:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012653;
        bh=XtMkpLHRLWK+zAm2LioxcOrroipcW2wChBIfA5L+Rxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgj1wjOepIFw4XR4aHV/JdjjLjhmq+S6cO85G+W6ff6p4yf0ELohAAmDe/NqfpyDk
         prKlRu97Bi6daIt3TrPNXVbnExSvT6y9yTLALKwGfeZngFN5zV+M1qLEkmHttxlnBl
         WEpKC08Zq25c6wEB4KxBcEuqoZzVqkwov7TuRHsFai46qy5GoO6eg0PNUBYc9vLd6G
         zGlxsE+65cblYSYjelTyhf4Nmn4sSBbBfWXGpmxblscYm557soJggC/5xO3igpK4Oc
         Ycjz+CIQKVJ+kA99Z7nYtWbFGo6KHgNYp8Y6J3O3lxYurbLjhQaLm4TDshegzOkfs2
         R8ITKTdxdhhjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 09/19] sfc: ensure correct number of XDP queues
Date:   Thu, 22 Jul 2021 23:57:10 -0400
Message-Id: <20210723035721.531372-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035721.531372-1-sashal@kernel.org>
References: <20210723035721.531372-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 788bc000d4c2f25232db19ab3a0add0ba4e27671 ]

Commit 99ba0ea616aa ("sfc: adjust efx->xdp_tx_queue_count with the real
number of initialized queues") intended to fix a problem caused by a
round up when calculating the number of XDP channels and queues.
However, this was not the real problem. The real problem was that the
number of XDP TX queues had been reduced to half in
commit e26ca4b53582 ("sfc: reduce the number of requested xdp ev queues"),
but the variable xdp_tx_queue_count had remained the same.

Once the correct number of XDP TX queues is created again in the
previous patch of this series, this also can be reverted since the error
doesn't actually exist.

Only in the case that there is a bug in the code we can have different
values in xdp_queue_number and efx->xdp_tx_queue_count. Because of this,
and per Edward Cree's suggestion, I add instead a WARN_ON to catch if it
happens again in the future.

Note that the number of allocated queues can be higher than the number
of used ones due to the round up, as explained in the existing comment
in the code. That's why we also have to stop increasing xdp_queue_number
beyond efx->xdp_tx_queue_count.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index a3ca406a3561..bea0b27baf4b 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -891,18 +891,20 @@ int efx_set_channels(struct efx_nic *efx)
 			if (efx_channel_is_xdp_tx(channel)) {
 				efx_for_each_channel_tx_queue(tx_queue, channel) {
 					tx_queue->queue = next_queue++;
-					netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
-						  channel->channel, tx_queue->label,
-						  xdp_queue_number, tx_queue->queue);
+
 					/* We may have a few left-over XDP TX
 					 * queues owing to xdp_tx_queue_count
 					 * not dividing evenly by EFX_MAX_TXQ_PER_CHANNEL.
 					 * We still allocate and probe those
 					 * TXQs, but never use them.
 					 */
-					if (xdp_queue_number < efx->xdp_tx_queue_count)
+					if (xdp_queue_number < efx->xdp_tx_queue_count) {
+						netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
+							  channel->channel, tx_queue->label,
+							  xdp_queue_number, tx_queue->queue);
 						efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
-					xdp_queue_number++;
+						xdp_queue_number++;
+					}
 				}
 			} else {
 				efx_for_each_channel_tx_queue(tx_queue, channel) {
@@ -914,8 +916,7 @@ int efx_set_channels(struct efx_nic *efx)
 			}
 		}
 	}
-	if (xdp_queue_number)
-		efx->xdp_tx_queue_count = xdp_queue_number;
+	WARN_ON(xdp_queue_number != efx->xdp_tx_queue_count);
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
-- 
2.30.2

