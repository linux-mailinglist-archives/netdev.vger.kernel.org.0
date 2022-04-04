Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3019F4F134B
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356949AbiDDKuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358205AbiDDKuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:50:51 -0400
Received: from mint-fitpc2.localdomain (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DA3C13FA4
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 03:48:54 -0700 (PDT)
Received: from palantir17.mph.net (palantir17 [192.168.0.4])
        by mint-fitpc2.localdomain (Postfix) with ESMTP id 22E5E3200AE;
        Mon,  4 Apr 2022 11:48:52 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nbKGR-0005H1-CA; Mon, 04 Apr 2022 11:48:51 +0100
Subject: [PATCH net] sfc: Do not free an empty page_ring
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ap420073@gmail.com, ecree.xilinx@gmail.com
Date:   Mon, 04 Apr 2022 11:48:51 +0100
Message-ID: <164906933121.20253.7433900739619890644.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the page_ring is not used page_ptr_mask is 0.
Do not dereference page_ring[0] in this case.

Fixes: 2768935a4660 ("sfc: reuse pages to avoid DMA mapping/unmapping costs")
Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/rx_common.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 1b22c7be0088..fa8b9aacca11 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -150,6 +150,9 @@ static void efx_fini_rx_recycle_ring(struct efx_rx_queue *rx_queue)
 	struct efx_nic *efx = rx_queue->efx;
 	int i;
 
+	if (unlikely(!rx_queue->page_ring))
+		return;
+
 	/* Unmap and release the pages in the recycle ring. Remove the ring. */
 	for (i = 0; i <= rx_queue->page_ptr_mask; i++) {
 		struct page *page = rx_queue->page_ring[i];

