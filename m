Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3F71FA294
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 23:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbgFOVNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 17:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgFOVNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 17:13:37 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A86A2078E;
        Mon, 15 Jun 2020 21:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592255617;
        bh=9hmhNMnytDn/12vZ0JJhYVVPOEacvK3Su5cLBW/296g=;
        h=Date:From:To:Cc:Subject:From;
        b=zwkav/Taf2V3vmB29SJyATCj765103/cMPGXfIToXae2+m2mXInGF22eQvWXPRdHH
         xtdIDonAq3ni7NC9c5GdTbeoFyhamfX56YCA2yac1hu/pYVkBVGN5qqT2yS6JhLNIi
         IwvUH1xZfl6IrCPI8OliPOn2ZUXy9gNcD935czzo=
Date:   Mon, 15 Jun 2020 16:18:55 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] liquidio: Replace vmalloc_node + memset with vzalloc_node
 and use array_size
Message-ID: <20200615211855.GA32663@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use vzalloc/vzalloc_node instead of the vmalloc/vzalloc_node and memset.

Also, notice that vzalloc_node() function has no 2-factor argument form
to calculate the size for the allocation, so multiplication factors need
to be wrapped in array_size().

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/request_manager.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/request_manager.c b/drivers/net/ethernet/cavium/liquidio/request_manager.c
index 6dd65f9b347c..8e59c2825533 100644
--- a/drivers/net/ethernet/cavium/liquidio/request_manager.c
+++ b/drivers/net/ethernet/cavium/liquidio/request_manager.c
@@ -95,12 +95,10 @@ int octeon_init_instr_queue(struct octeon_device *oct,
 	/* Initialize a list to holds requests that have been posted to Octeon
 	 * but has yet to be fetched by octeon
 	 */
-	iq->request_list = vmalloc_node((sizeof(*iq->request_list) * num_descs),
-					       numa_node);
+	iq->request_list = vzalloc_node(array_size(num_descs, sizeof(*iq->request_list)),
+					numa_node);
 	if (!iq->request_list)
-		iq->request_list =
-			vmalloc(array_size(num_descs,
-					   sizeof(*iq->request_list)));
+		iq->request_list = vzalloc(array_size(num_descs, sizeof(*iq->request_list)));
 	if (!iq->request_list) {
 		lio_dma_free(oct, q_size, iq->base_addr, iq->base_addr_dma);
 		dev_err(&oct->pci_dev->dev, "Alloc failed for IQ[%d] nr free list\n",
@@ -108,8 +106,6 @@ int octeon_init_instr_queue(struct octeon_device *oct,
 		return 1;
 	}
 
-	memset(iq->request_list, 0, sizeof(*iq->request_list) * num_descs);
-
 	dev_dbg(&oct->pci_dev->dev, "IQ[%d]: base: %p basedma: %pad count: %d\n",
 		iq_no, iq->base_addr, &iq->base_addr_dma, iq->max_count);
 
-- 
2.27.0

