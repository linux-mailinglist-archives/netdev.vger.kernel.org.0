Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2015211C0E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 08:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgGBGiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 02:38:21 -0400
Received: from mx137-tc.baidu.com ([61.135.168.137]:54392 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbgGBGiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 02:38:19 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 6DD57204004B;
        Thu,  2 Jul 2020 14:38:05 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH][net-next] i40e: prefetch struct page of rx buffer conditionally
Date:   Thu,  2 Jul 2020 14:38:05 +0800
Message-Id: <1593671885-30822-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

page_address() accesses struct page only when WANT_PAGE_VIRTUAL
or HASHED_PAGE_VIRTUAL is defined, otherwise it returns address
based on offset, so we prefetch it conditionally

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f9555c847f73..b3836092c327 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1953,7 +1953,9 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
 	struct i40e_rx_buffer *rx_buffer;
 
 	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+#if defined(WANT_PAGE_VIRTUAL) || defined(HASHED_PAGE_VIRTUAL)
 	prefetchw(rx_buffer->page);
+#endif
 
 	/* we are reusing so sync this buffer for CPU use */
 	dma_sync_single_range_for_cpu(rx_ring->dev,
-- 
2.16.2

