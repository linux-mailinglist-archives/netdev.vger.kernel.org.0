Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABF31DAF3B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgETJsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgETJso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:48:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F379C061A0E;
        Wed, 20 May 2020 02:48:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n15so1310244pfd.0;
        Wed, 20 May 2020 02:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4krTzV2u35Z3NG+JAyiWOTySv4f3topMKqbx3Je2xYo=;
        b=aqPTtXkqSVPLHXb+Nvf51I6nb/QRUADzJebA6MOI58g6LvGp82t50pf87BzDoAHHG8
         Uaio837t53Z8dmMmRc3cAwRt0Y12vhyIFwKDROB+aUqjRjsIMOB7SvbdaSHo2QBnWLHn
         ayLUT5l7SaLXExXexDOtQt4gKPGbovlBP0PXQ52i2a8w3geG+8qoRBBdAggixtk5rp2h
         tnWfIx1X0DrrvrtqFuITDoCKgswirBbMN6FPmJcYQcjHr3Jw2IY+DRzyK9LcRAVVTbmk
         OcQu7yJ4/9oXsrjkF35MFKJsg1um+j51Z4XTZm/BWWxtm3rJMHiR0MmWO6JSMfBp1Xg1
         wCbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4krTzV2u35Z3NG+JAyiWOTySv4f3topMKqbx3Je2xYo=;
        b=rnjyPrkLSRQm9qREcSHTLcRyECHVPbq+kF7mSZQd/armPD5sl+cKz7rh1UD7yJmhWp
         6gJhr9jkNA3PPvQSKRRS9k6GvyMekLgkCzUMMyt4q3M+pEui8XRgLS5uCvMdeKo4PFTo
         F+4P1q/W+nB9/Yio99pX+gt0RPKDejFHLv7PFFp1DoybwTBGC8Dp4Y63sRpUoCuQgDMI
         cQXx4LWRabq+RGO95ZrZn2yz8twG2Lnf1iPZjJXlV4AKAbj6qa/+zubuT+SD6r/DDvOC
         HLSD6UV/Y3ebYt7S1h8LHs60bZrUZeiNODPunsMalL7srUt+YlqAiGio357B0HypcfLD
         KgRA==
X-Gm-Message-State: AOAM530MKNg9nrEItCl80SdKsmTs4hwIoWTbXK+5zbPX2y0Eip+5JTUL
        6qTB8/gBZ/sRPcD6Traka+TwV0CeguXNmLHS
X-Google-Smtp-Source: ABdhPJzGZ24TM016q0eCwfi2/w9ZdphUyu1Wc1bxZnGijAHoFp2fEiganmqXxZEtYzwpX8NaSvtMnQ==
X-Received: by 2002:a63:5fc8:: with SMTP id t191mr3281640pgb.185.1589968123581;
        Wed, 20 May 2020 02:48:43 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id c124sm1707494pfb.187.2020.05.20.02.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 02:48:42 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v4 06/15] i40e: refactor rx_bi accesses
Date:   Wed, 20 May 2020 11:47:33 +0200
Message-Id: <20200520094742.337678-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520094742.337678-1-bjorn.topel@gmail.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

As a first step to migrate i40e to the new MEM_TYPE_XSK_BUFF_POOL
APIs, code that accesses the rx_bi (SW/shadow ring) is refactored to
use an accessor function.

Cc: intel-wired-lan@lists.osuosl.org
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 17 +++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 18 ++++++++++++------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index a3772beffe02..9b9ef951f9ce 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1195,6 +1195,11 @@ static void i40e_update_itr(struct i40e_q_vector *q_vector,
 	rc->total_packets = 0;
 }
 
+static struct i40e_rx_buffer *i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
+{
+	return &rx_ring->rx_bi[idx];
+}
+
 /**
  * i40e_reuse_rx_page - page flip buffer and store it back on the ring
  * @rx_ring: rx descriptor ring to store buffers on
@@ -1208,7 +1213,7 @@ static void i40e_reuse_rx_page(struct i40e_ring *rx_ring,
 	struct i40e_rx_buffer *new_buff;
 	u16 nta = rx_ring->next_to_alloc;
 
-	new_buff = &rx_ring->rx_bi[nta];
+	new_buff = i40e_rx_bi(rx_ring, nta);
 
 	/* update, and store next to alloc */
 	nta++;
@@ -1272,7 +1277,7 @@ struct i40e_rx_buffer *i40e_clean_programming_status(
 	ntc = rx_ring->next_to_clean;
 
 	/* fetch, update, and store next to clean */
-	rx_buffer = &rx_ring->rx_bi[ntc++];
+	rx_buffer = i40e_rx_bi(rx_ring, ntc++);
 	ntc = (ntc < rx_ring->count) ? ntc : 0;
 	rx_ring->next_to_clean = ntc;
 
@@ -1361,7 +1366,7 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 
 	/* Free all the Rx ring sk_buffs */
 	for (i = 0; i < rx_ring->count; i++) {
-		struct i40e_rx_buffer *rx_bi = &rx_ring->rx_bi[i];
+		struct i40e_rx_buffer *rx_bi = i40e_rx_bi(rx_ring, i);
 
 		if (!rx_bi->page)
 			continue;
@@ -1592,7 +1597,7 @@ bool i40e_alloc_rx_buffers(struct i40e_ring *rx_ring, u16 cleaned_count)
 		return false;
 
 	rx_desc = I40E_RX_DESC(rx_ring, ntu);
-	bi = &rx_ring->rx_bi[ntu];
+	bi = i40e_rx_bi(rx_ring, ntu);
 
 	do {
 		if (!i40e_alloc_mapped_page(rx_ring, bi))
@@ -1614,7 +1619,7 @@ bool i40e_alloc_rx_buffers(struct i40e_ring *rx_ring, u16 cleaned_count)
 		ntu++;
 		if (unlikely(ntu == rx_ring->count)) {
 			rx_desc = I40E_RX_DESC(rx_ring, 0);
-			bi = rx_ring->rx_bi;
+			bi = i40e_rx_bi(rx_ring, 0);
 			ntu = 0;
 		}
 
@@ -1981,7 +1986,7 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
 {
 	struct i40e_rx_buffer *rx_buffer;
 
-	rx_buffer = &rx_ring->rx_bi[rx_ring->next_to_clean];
+	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 	prefetchw(rx_buffer->page);
 
 	/* we are reusing so sync this buffer for CPU use */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index d8b0be29099a..d84ec92f8538 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -9,6 +9,11 @@
 #include "i40e_txrx_common.h"
 #include "i40e_xsk.h"
 
+static struct i40e_rx_buffer *i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
+{
+	return &rx_ring->rx_bi[idx];
+}
+
 /**
  * i40e_xsk_umem_dma_map - DMA maps all UMEM memory for the netdev
  * @vsi: Current VSI
@@ -321,7 +326,7 @@ __i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count,
 	bool ok = true;
 
 	rx_desc = I40E_RX_DESC(rx_ring, ntu);
-	bi = &rx_ring->rx_bi[ntu];
+	bi = i40e_rx_bi(rx_ring, ntu);
 	do {
 		if (!alloc(rx_ring, bi)) {
 			ok = false;
@@ -340,7 +345,7 @@ __i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count,
 
 		if (unlikely(ntu == rx_ring->count)) {
 			rx_desc = I40E_RX_DESC(rx_ring, 0);
-			bi = rx_ring->rx_bi;
+			bi = i40e_rx_bi(rx_ring, 0);
 			ntu = 0;
 		}
 
@@ -402,7 +407,7 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer_zc(struct i40e_ring *rx_ring,
 {
 	struct i40e_rx_buffer *bi;
 
-	bi = &rx_ring->rx_bi[rx_ring->next_to_clean];
+	bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 
 	/* we are reusing so sync this buffer for CPU use */
 	dma_sync_single_range_for_cpu(rx_ring->dev,
@@ -424,7 +429,8 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer_zc(struct i40e_ring *rx_ring,
 static void i40e_reuse_rx_buffer_zc(struct i40e_ring *rx_ring,
 				    struct i40e_rx_buffer *old_bi)
 {
-	struct i40e_rx_buffer *new_bi = &rx_ring->rx_bi[rx_ring->next_to_alloc];
+	struct i40e_rx_buffer *new_bi = i40e_rx_bi(rx_ring,
+						   rx_ring->next_to_alloc);
 	u16 nta = rx_ring->next_to_alloc;
 
 	/* update, and store next to alloc */
@@ -456,7 +462,7 @@ void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
 	mask = rx_ring->xsk_umem->chunk_mask;
 
 	nta = rx_ring->next_to_alloc;
-	bi = &rx_ring->rx_bi[nta];
+	bi = i40e_rx_bi(rx_ring, nta);
 
 	nta++;
 	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
@@ -826,7 +832,7 @@ void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring)
 	u16 i;
 
 	for (i = 0; i < rx_ring->count; i++) {
-		struct i40e_rx_buffer *rx_bi = &rx_ring->rx_bi[i];
+		struct i40e_rx_buffer *rx_bi = i40e_rx_bi(rx_ring, i);
 
 		if (!rx_bi->addr)
 			continue;
-- 
2.25.1

