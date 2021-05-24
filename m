Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A56B38F55B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 00:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhEXWIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 18:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbhEXWIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 18:08:12 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5E9C061574;
        Mon, 24 May 2021 15:06:44 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FprsF2yQyzQjmW;
        Tue, 25 May 2021 00:06:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:mime-version:message-id:date:date
        :subject:subject:from:from:received; s=mail20150812; t=
        1621894000; bh=gmaCOau1u9jtoZTGkqghvCruMPooaEIFzqnYgI00D20=; b=u
        LXDWSeRTrAI7T8/sF+RFbr1+24qLBWqgoF9HdZuihtf9289BhIwZwCdqg/+0bQ1d
        0Ah4cfUHLppN5SWFFLM5I0RxNMDeXSGcArj9/KuXcv+3KUK5OglWNZXpMuQG8bY2
        9psu0BQrf9zBpr4lYijRsgBgQD6MpOE3hg2dfbAPTpR8LCDFCY/DxpKJ5NcCedLO
        okL+bcHw8e7tvsdq95oA9BrMfCJsWhJxMzUtoHc99ok0UzH9fCpR/DvIyq41g02n
        jxpBTGS+47vgsa6a3rheuxx9fk52vd6ehYJdOonurXDLwX95cPtAvxOZGWpUPrko
        kzRSyWaYBO/Muc2MSIbtA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id fECnRS3Nnkec; Tue, 25 May 2021 00:06:40 +0200 (CEST)
From:   Markus Boehme <markubo@amazon.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Emil Tantilov <emil.s.tantilov@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Markus Boehme <markubo@amazon.com>,
        stable@vger.kernel.org
Subject: [PATCH net] ixgbe: Fix packet corruption due to missing DMA sync
Date:   Tue, 25 May 2021 00:05:31 +0200
Message-Id: <20210524220531.64640-1-markubo@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: ****
X-Rspamd-Score: 4.86 / 15.00 / 15.00
X-Rspamd-Queue-Id: 0D0EA15F8
X-Rspamd-UID: 723dc2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving a packet with multiple fragments, hardware may still
touch the first fragment until the entire packet has been received. The
driver therefore keeps the first fragment mapped for DMA until end of
packet has been asserted, and delays its dma_sync call until then.

The driver tries to fit multiple receive buffers on one page. When using
3K receive buffers (e.g. using Jumbo frames and legacy-rx is turned
off/build_skb is being used) on an architecture with 4K pages, the
driver allocates an order 1 compound page and uses one page per receive
buffer. To determine the correct offset for a delayed DMA sync of the
first fragment of a multi-fragment packet, the driver then cannot just
use PAGE_MASK on the DMA address but has to construct a mask based on
the actual size of the backing page.

Using PAGE_MASK in the 3K RX buffer/4K page architecture configuration
will always sync the first page of a compound page. With the SWIOTLB
enabled this can lead to corrupted packets (zeroed out first fragment,
re-used garbage from another packet) and various consequences, such as
slow/stalling data transfers and connection resets. For example, testing
on a link with MTU exceeding 3058 bytes on a host with SWIOTLB enabled
(e.g. "iommu=soft swiotlb=262144,force") TCP transfers quickly fizzle
out without this patch.

Cc: stable@vger.kernel.org
Fixes: 0c5661ecc5dd7 ("ixgbe: fix crash in build_skb Rx code path")
Signed-off-by: Markus Boehme <markubo@amazon.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c5ec17d19c59..507ef3471301 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1825,7 +1825,8 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 				struct sk_buff *skb)
 {
 	if (ring_uses_build_skb(rx_ring)) {
-		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
+		unsigned long mask = (unsigned long)ixgbe_rx_pg_size(rx_ring) - 1;
+		unsigned long offset = (unsigned long)(skb->data) & mask;
 
 		dma_sync_single_range_for_cpu(rx_ring->dev,
 					      IXGBE_CB(skb)->dma,
-- 
2.25.1

