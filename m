Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0905692419
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjBJRLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbjBJRLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:11:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492F961D03;
        Fri, 10 Feb 2023 09:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676049060; x=1707585060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Piz3pSgJaKZ6KUSNLIn5AEYtmz3ciGmMf3v0y3UzRKs=;
  b=bLybvqzopVciX8lrnk7kXcNb7i0rlIoa4bwMakzcSXMMRLC8pN6MGHhA
   Poy0Y6T72dOkMJ+Q0oE23K0yDrPKDisck22El8ywVFOgH3xX1vbK+TlGU
   o+AU1iDM8/UdFOjUv7dFjex5yPe1RChn93v3ClY072CxM2Fm1GcXXnMAY
   ocSkd6m4NfyWRgw5pUgDOAE694a7ZiTOo4bZl2oajXu1OHVw9dfb4P+3T
   W5B4mWHNgUJcu6dqDNK75Yi3eqlqI9vbNizkAb4aufkdhHsylek1EuRtc
   +JQe857BtsPMU4ne9rlwQ7dirPeVajJdLSY8NUgV4J3UiMc6Z9cKdRrQR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="395076676"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="395076676"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:07:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="668107537"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="668107537"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga002.jf.intel.com with ESMTP; 10 Feb 2023 09:07:24 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id DCF613C625;
        Fri, 10 Feb 2023 17:07:22 +0000 (GMT)
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/6] ice: fix ice_tx_ring::xdp_tx_active underflow
Date:   Fri, 10 Feb 2023 18:06:13 +0100
Message-Id: <20230210170618.1973430-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
References: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_tx_active is used to indicate whether an XDP ring has any %XDP_TX
frames queued to shortcut processing Tx cleaning for XSk-enabled queues.
When !XSk, it simply indicates whether the ring has any queued frames in
general.
It gets increased on each frame placed onto the ring and counts the
whole frame, not each frag. However, currently it gets decremented in
ice_clean_xdp_tx_buf(), which is called per each buffer, i.e. per each
frag. Thus, on completing multi-frag frames, an underflow happens.
Move the decrement to the outer function and do it once per frame, not
buf. Also, do that on the stack and update the ring counter after the
loop is done to save several cycles.
XSk rings are fine since there are no frags at the moment.

Fixes: 3246a10752a7 ("ice: Add support for XDP multi-buffer on Tx side")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 9bbed3f14e42..d1a7171e618b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -231,7 +231,6 @@ ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
 	dma_unmap_len_set(tx_buf, len, 0);
-	xdp_ring->xdp_tx_active--;
 	page_frag_free(tx_buf->raw_buf);
 	tx_buf->raw_buf = NULL;
 }
@@ -246,8 +245,8 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 	u32 ntc = xdp_ring->next_to_clean;
 	struct ice_tx_desc *tx_desc;
 	u32 cnt = xdp_ring->count;
+	u32 frags, xdp_tx = 0;
 	u32 ready_frames = 0;
-	u32 frags;
 	u32 idx;
 	u32 ret;
 
@@ -274,6 +273,7 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 		total_pkts++;
 		/* count head + frags */
 		ready_frames -= frags + 1;
+		xdp_tx++;
 
 		if (xdp_ring->xsk_pool)
 			xsk_buff_free(tx_buf->xdp);
@@ -295,6 +295,7 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 
 	tx_desc->cmd_type_offset_bsz = 0;
 	xdp_ring->next_to_clean = ntc;
+	xdp_ring->xdp_tx_active -= xdp_tx;
 	ice_update_tx_ring_stats(xdp_ring, total_pkts, total_bytes);
 
 	return ret;
-- 
2.39.1

