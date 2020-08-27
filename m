Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1160E253F9D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgH0HxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:53:25 -0400
Received: from mx57.baidu.com ([61.135.168.57]:24998 "EHLO
        tc-sys-mailedm04.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726882AbgH0HxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:53:22 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id CD523236C013;
        Thu, 27 Aug 2020 15:53:05 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH] iavf: use kvzalloc instead of kzalloc for rx/tx_bi buffer
Date:   Thu, 27 Aug 2020 15:53:08 +0800
Message-Id: <1598514788-31039-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when changes the rx/tx ring to 4096, kzalloc may fail due to
a temporary shortage on slab entries.

kvmalloc is used to allocate this memory as there is no need
to have this memory area physical continuously.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 256fa07d54d5..f5a3e195ec54 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -92,7 +92,7 @@ void iavf_clean_tx_ring(struct iavf_ring *tx_ring)
 void iavf_free_tx_resources(struct iavf_ring *tx_ring)
 {
 	iavf_clean_tx_ring(tx_ring);
-	kfree(tx_ring->tx_bi);
+	kvfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
 
 	if (tx_ring->desc) {
@@ -622,7 +622,7 @@ int iavf_setup_tx_descriptors(struct iavf_ring *tx_ring)
 	/* warn if we are about to overwrite the pointer */
 	WARN_ON(tx_ring->tx_bi);
 	bi_size = sizeof(struct iavf_tx_buffer) * tx_ring->count;
-	tx_ring->tx_bi = kzalloc(bi_size, GFP_KERNEL);
+	tx_ring->tx_bi = kvzalloc(bi_size, GFP_KERNEL);
 	if (!tx_ring->tx_bi)
 		goto err;
 
@@ -643,7 +643,7 @@ int iavf_setup_tx_descriptors(struct iavf_ring *tx_ring)
 	return 0;
 
 err:
-	kfree(tx_ring->tx_bi);
+	kvfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
 	return -ENOMEM;
 }
@@ -714,7 +714,7 @@ void iavf_clean_rx_ring(struct iavf_ring *rx_ring)
 void iavf_free_rx_resources(struct iavf_ring *rx_ring)
 {
 	iavf_clean_rx_ring(rx_ring);
-	kfree(rx_ring->rx_bi);
+	kvfree(rx_ring->rx_bi);
 	rx_ring->rx_bi = NULL;
 
 	if (rx_ring->desc) {
@@ -738,7 +738,7 @@ int iavf_setup_rx_descriptors(struct iavf_ring *rx_ring)
 	/* warn if we are about to overwrite the pointer */
 	WARN_ON(rx_ring->rx_bi);
 	bi_size = sizeof(struct iavf_rx_buffer) * rx_ring->count;
-	rx_ring->rx_bi = kzalloc(bi_size, GFP_KERNEL);
+	rx_ring->rx_bi = kvzalloc(bi_size, GFP_KERNEL);
 	if (!rx_ring->rx_bi)
 		goto err;
 
@@ -762,7 +762,7 @@ int iavf_setup_rx_descriptors(struct iavf_ring *rx_ring)
 
 	return 0;
 err:
-	kfree(rx_ring->rx_bi);
+	kvfree(rx_ring->rx_bi);
 	rx_ring->rx_bi = NULL;
 	return -ENOMEM;
 }
-- 
2.16.2

