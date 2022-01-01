Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2F1482769
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 12:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiAALi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 06:38:58 -0500
Received: from mph.eclipse.net.uk ([81.168.73.77]:55606 "EHLO
        mint-fitpc2.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S232317AbiAALi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 06:38:58 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Jan 2022 06:38:57 EST
Received: from palantir17.mph.net (unknown [192.168.0.102])
        by mint-fitpc2.localdomain (Postfix) with ESMTP id 247FB320022;
        Sat,  1 Jan 2022 11:33:01 +0000 (GMT)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1n3cdA-0006px-Jk; Sat, 01 Jan 2022 11:33:00 +0000
Subject: [PATCH net-next] sfc: The RX page_ring is optional
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, jiasheng@iscas.ac.cn, davem@davemloft.net
Cc:     ecree.xilinx@gmail.com, netdev@vger.kernel.org
Date:   Sat, 01 Jan 2022 11:33:00 +0000
Message-ID: <164103678041.26263.8354809911405746465.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX page_ring is an optional feature that improves
performance. When allocation fails the driver can still
function, but possibly with a lower bandwidth.
Guard against dereferencing a NULL page_ring.

Fixes: 2768935a4660 ("sfc: reuse pages to avoid DMA mapping/unmapping costs")
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Reported-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/sfc/falcon/rx.c |    5 +++++
 drivers/net/ethernet/sfc/rx_common.c |    5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index 11a6aee852e9..57874adfb1b2 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -110,6 +110,8 @@ static struct page *ef4_reuse_page(struct ef4_rx_queue *rx_queue)
 	struct ef4_rx_page_state *state;
 	unsigned index;
 
+	if (unlikely(!rx_queue->page_ring))
+		return NULL;
 	index = rx_queue->page_remove & rx_queue->page_ptr_mask;
 	page = rx_queue->page_ring[index];
 	if (page == NULL)
@@ -293,6 +295,9 @@ static void ef4_recycle_rx_pages(struct ef4_channel *channel,
 {
 	struct ef4_rx_queue *rx_queue = ef4_channel_get_rx_queue(channel);
 
+	if (unlikely(!rx_queue->page_ring))
+		return NULL;
+
 	do {
 		ef4_recycle_rx_page(channel, rx_buf);
 		rx_buf = ef4_rx_buf_next(rx_queue, rx_buf);
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 0983abc0cc5f..9ea50617dd04 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -45,6 +45,8 @@ static struct page *efx_reuse_page(struct efx_rx_queue *rx_queue)
 	unsigned int index;
 	struct page *page;
 
+	if (unlikely(!rx_queue->page_ring))
+		return NULL;
 	index = rx_queue->page_remove & rx_queue->page_ptr_mask;
 	page = rx_queue->page_ring[index];
 	if (page == NULL)
@@ -114,6 +116,9 @@ void efx_recycle_rx_pages(struct efx_channel *channel,
 {
 	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
 
+	if (unlikely(!rx_queue->page_ring))
+		return NULL;
+
 	do {
 		efx_recycle_rx_page(channel, rx_buf);
 		rx_buf = efx_rx_buf_next(rx_queue, rx_buf);

