Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB60B31076B
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 10:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhBEJLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 04:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhBEJJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 04:09:56 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDD1C06178A
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 01:09:16 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id a16so7454343wmm.0
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 01:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y49irSyVfNAggSfPuZlywntYMQM69bQ0nbpSgVeCqwg=;
        b=E6m6zB9zS79rjFw3qcouP+OcVhvqtsx9x9yFyu1rn9voNv3OYbL2LO/UJQ7JCNpi78
         jtxxWEY0ln1OWMSlrchT5KCqEbNPAn+Lryaowiykdijz5cHLWGVaumk0+Wj4e+UQA+Dx
         7sl59RTHd6nDNAK68yXez/E6jEFL62cOE3ULbAGi1DUHCZAyqKMZ3MczZ1evP9yDZOWN
         kHc9tBjEh+jvZsEhdCh5TVUTwfqpX3cEFYCBEUTKzdU1Xs4uI9CJkYnwZOSX9yAuDxXj
         F/Lax+/rc3OXYUwl4rOxuLZEw02UwcF0rxHRdPnoLSP1FqIX3ZVfsVpi8wx5lqUdUYlJ
         6tpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y49irSyVfNAggSfPuZlywntYMQM69bQ0nbpSgVeCqwg=;
        b=r5/+gzTFvEHCHHuwkoP/DjXcsl0TC8jc/aOGh6lSZzIYWEb/awP5+IQwX4JmU1Jin6
         YWyGJ4X5aot1Ecd54jMe3FxWqR7GGvBfzIDoVV/srLpCCfUK0neM046Hlaers2Ek1zNn
         oiUq0xPYEI5f5B9UEwxyXxsPh/0ulwrB3JZezEbVsZ43B9yIcwAzDePM1mN8ClbTgDVq
         UGfvQwmoYmuJzch3kTM7Cwar22xlWvIknj+AX6wdlkaepVU9p3TxQLPEikv/KsqDn+G9
         e2cER2Kj7v+XWm/mFkNtOxmNPMoFaXL+ag7DgAKB8UsOTv3P/8HoB5SrFoZk39to1K0S
         waow==
X-Gm-Message-State: AOAM533rmhVSAxkgbpmklSgRd5l6y1SxIBEYm/KWINTXtPA2mlVQLoVj
        N1tZ7YDIxzwYKJk/82JQBrw=
X-Google-Smtp-Source: ABdhPJwu4v/5tQ36DQC1YUXwLOZ5KqJ8afUsQfNHnQiskbGkBQbW0cvZb/iUI2DCkl/QGEKXcm2tdw==
X-Received: by 2002:a1c:6a09:: with SMTP id f9mr2677492wmc.104.1612516154986;
        Fri, 05 Feb 2021 01:09:14 -0800 (PST)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id g16sm7950303wmi.30.2021.02.05.01.09.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 01:09:14 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH intel-net] ice: fix napi work done reporting in xsk path
Date:   Fri,  5 Feb 2021 10:09:04 +0100
Message-Id: <20210205090904.20794-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix the wrong napi work done reporting in the xsk path of the ice
driver. The code in the main Rx processing loop was written to assume
that the buffer allocation code returns true if all allocations where
successful and false if not. In contrast with all other Intel NIC xsk
drivers, the ice_alloc_rx_bufs_zc() has the inverted logic messing up
the work done reporting in the napi loop.

This can be fixed either by inverting the return value from
ice_alloc_rx_bufs_zc() in the function that uses this in an incorrect
way, or by changing the return value of ice_alloc_rx_bufs_zc(). We
chose the latter as it makes all the xsk allocation functions for
Intel NICs behave in the same way. My guess is that it was this
unexpected discrepancy that gave rise to this bug in the first place.

Fixes: 5bb0c4b5eb61 ("ice, xsk: Move Rx allocation out of while-loop")
Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c |  6 ++++--
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 10 +++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 3124a3bf519a..952e41a1e001 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -418,6 +418,8 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	writel(0, ring->tail);
 
 	if (ring->xsk_pool) {
+		bool ok;
+
 		if (!xsk_buff_can_alloc(ring->xsk_pool, num_bufs)) {
 			dev_warn(dev, "XSK buffer pool does not provide enough addresses to fill %d buffers on Rx ring %d\n",
 				 num_bufs, ring->q_index);
@@ -426,8 +428,8 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 			return 0;
 		}
 
-		err = ice_alloc_rx_bufs_zc(ring, num_bufs);
-		if (err)
+		ok = ice_alloc_rx_bufs_zc(ring, num_bufs);
+		if (!ok)
 			dev_info(dev, "Failed to allocate some buffers on XSK buffer pool enabled Rx ring %d (pf_q %d)\n",
 				 ring->q_index, pf_q);
 		return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 1782146db644..69ee1a8e87ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -408,18 +408,18 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
  * This function allocates a number of Rx buffers from the fill ring
  * or the internal recycle mechanism and places them on the Rx ring.
  *
- * Returns false if all allocations were successful, true if any fail.
+ * Returns true if all allocations were successful, false if any fail.
  */
 bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 {
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
 	struct ice_rx_buf *rx_buf;
-	bool ret = false;
+	bool ok = true;
 	dma_addr_t dma;
 
 	if (!count)
-		return false;
+		return true;
 
 	rx_desc = ICE_RX_DESC(rx_ring, ntu);
 	rx_buf = &rx_ring->rx_buf[ntu];
@@ -427,7 +427,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 	do {
 		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_pool);
 		if (!rx_buf->xdp) {
-			ret = true;
+			ok = false;
 			break;
 		}
 
@@ -452,7 +452,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 		ice_release_rx_desc(rx_ring, ntu);
 	}
 
-	return ret;
+	return ok;
 }
 
 /**

base-commit: b3d2c7b876d450e1d2624fd67658acc96465a9e6
-- 
2.29.0

