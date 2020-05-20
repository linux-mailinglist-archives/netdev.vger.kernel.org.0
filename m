Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF751DBDD5
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgETTVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgETTVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:21:52 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1066BC061A0E;
        Wed, 20 May 2020 12:21:52 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p30so1884878pgl.11;
        Wed, 20 May 2020 12:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4krTzV2u35Z3NG+JAyiWOTySv4f3topMKqbx3Je2xYo=;
        b=SPFMqWrCwxgyO4UkpK3BImeOXAcNFRidCtwasUw9CebKXnzQDdV0tVSkvrU+4DlRIn
         /SnE2KCIU5bMjg28RvJKK23mcWlXi6i2cWrvWURKQKDYAMF/cb1ubaD3jF1II9OdAneO
         t51VGDVpPFvGiEnlwFdYbrFWsZBvHuZiFY7td/W8zutV3MogzoA6HgDAbsyIiQXLhA6Q
         OWGayh0Xx1A2MwfbHMoUhuyTnUfP+LdOWT6pCwjfGVbgI6/7mpyNp+xMjQRrsGf1FOXJ
         GlARxm9De58vm47Ae80CH4YoE9VyFMDpmIoZFNnmUwjrGIA7/5qW37PD6YhIjQ4qXENr
         G2eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4krTzV2u35Z3NG+JAyiWOTySv4f3topMKqbx3Je2xYo=;
        b=b/mcIsO90UmklpfYpQPDYvYYIhVAm2ZIiC3kr996G3QNWg5IlyARfYw2cUSWohmJoN
         Xvm9dSKSvN0D72fazNjWwAQgoVGjdIlBYpzfTvlHjLcmnzRm36WxBAmVA/CYnYPJ+1vQ
         /hyytR/Himgs9r7SeLjoF45kf20yl1DNwjfp/DRX7svwvyOBqIfuCCfJBp0HDXfBA1fy
         2eQYOqL4fVZyv+mvn8Tz1MQkLfZPcXYHepPKugO8BdZkybVXQM9kWk5xUorrsRUAC9Zv
         CWeAUwZ+czzigNhRQvj0y0/7D4BsszYbF/ZyK6WTmG80D5dE9IgsNtRVx1HKM1fVK3hY
         Yfgg==
X-Gm-Message-State: AOAM532dNkE71Kkbi8IiKsPSPvbU9IAUahgGnoZQIUAqNT45HJ3t1bUY
        GM2OFEODVE8jf5YkL2lLv7E=
X-Google-Smtp-Source: ABdhPJxCGZff0/tSIS9qt2CJBzbWNNKhz7XosIfn6Gw8Y0zw78hYYZ2ICzKzSmGZX5lNujE9LnEQaA==
X-Received: by 2002:aa7:94a9:: with SMTP id a9mr5744101pfl.312.1590002510748;
        Wed, 20 May 2020 12:21:50 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 62sm2762424pfc.204.2020.05.20.12.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 12:21:50 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v5 06/15] i40e: refactor rx_bi accesses
Date:   Wed, 20 May 2020 21:20:54 +0200
Message-Id: <20200520192103.355233-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520192103.355233-1-bjorn.topel@gmail.com>
References: <20200520192103.355233-1-bjorn.topel@gmail.com>
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

