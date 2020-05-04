Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2891C385C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgEDLiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728665AbgEDLiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:38:19 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3122C061A0E;
        Mon,  4 May 2020 04:38:17 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id hi11so3645544pjb.3;
        Mon, 04 May 2020 04:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N/Lcs9lpqr+PSaNN7SZtiFiqLWOfZAn2LZGKUFkaTP0=;
        b=qd0nUOyo7Nu2q7fszBmHCJ/GV4/1TPzX5x4+cOWdYaErD7MfY6XbUMyyhDN9rqRIYt
         3js7+L0OIPZoYG19sZrc3rxAzd3zeTK2/LBoleTPQYeIx08CDUAhXsJZ++faW9dC29JG
         EWXqPwacFyp9w4qKe3oHIQ5BUAEeP7e6a9goobb14OSXQl3k0NvFn73YsHOAEHFBvSG5
         nO6YvaaURTPcbcFeKf8DUyQ4TGnQoh8YlsOtUeci37oUWzBmV4JPUa5ZkRrbR4mpsQXm
         gB58KXUb+jBAMHA8T3gMrx917DRunGBg/vkPea5QYY7L6qBx39fxk3r8x1DKijazbzQi
         otgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N/Lcs9lpqr+PSaNN7SZtiFiqLWOfZAn2LZGKUFkaTP0=;
        b=AZFmpkcX7tWR+OXSHZO/zbnVMY64N1hDWnNUbSWgGM2ayS67TFJCooKxuUOpE67tqc
         lqQ+GVLaPx5bYWOlh8mhclp4HgAw3zYpDcUaN+vjRvtZ5jgzr0w0MNgqGnI2KvUSGngF
         3O4Sea3ZeIdoHRSJU8R9aXzXIYcj+o/m8fzYp10HkEX0w8QRkOKBR6GzEaHrzSshJEvp
         XeYkLx2yR3knj0JQ9f6V8/RhDMEQfRdBOcAn8QYEqZ+V7iZl+M3sxH2ALwZNA1MK1Cgg
         keidBlKZ2w7mZxPfwv+PpjVZY6DKOMgKU1vrF/3ge0I2axFZpn+HN8SveAeZ0qqMcKiz
         WJnw==
X-Gm-Message-State: AGi0PuYYRrOcRtfQQRMZq9QJedXkhMN5BDs8DQZbaFxB1Iq27181fS4O
        2CXdsy6QRZB4vJYEWRtLc8Y=
X-Google-Smtp-Source: APiQypKTwfnWjI8Xpm787Exy3XZxDoD+Y7odtKjscGiHC2wXHIWAx7+5L3W6dl6Ufq1YaC0wYSi9Lw==
X-Received: by 2002:a17:90a:718c:: with SMTP id i12mr17039986pjk.142.1588592297303;
        Mon, 04 May 2020 04:38:17 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id x185sm8650789pfx.155.2020.05.04.04.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 04:38:16 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH bpf-next 05/13] i40e: refactor rx_bi accesses
Date:   Mon,  4 May 2020 13:37:07 +0200
Message-Id: <20200504113716.7930-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200504113716.7930-1-bjorn.topel@gmail.com>
References: <20200504113716.7930-1-bjorn.topel@gmail.com>
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
index b8496037ef7f..58daba8fabc8 100644
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
@@ -1576,7 +1581,7 @@ bool i40e_alloc_rx_buffers(struct i40e_ring *rx_ring, u16 cleaned_count)
 		return false;
 
 	rx_desc = I40E_RX_DESC(rx_ring, ntu);
-	bi = &rx_ring->rx_bi[ntu];
+	bi = i40e_rx_bi(rx_ring, ntu);
 
 	do {
 		if (!i40e_alloc_mapped_page(rx_ring, bi))
@@ -1598,7 +1603,7 @@ bool i40e_alloc_rx_buffers(struct i40e_ring *rx_ring, u16 cleaned_count)
 		ntu++;
 		if (unlikely(ntu == rx_ring->count)) {
 			rx_desc = I40E_RX_DESC(rx_ring, 0);
-			bi = rx_ring->rx_bi;
+			bi = i40e_rx_bi(rx_ring, 0);
 			ntu = 0;
 		}
 
@@ -1965,7 +1970,7 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
 {
 	struct i40e_rx_buffer *rx_buffer;
 
-	rx_buffer = &rx_ring->rx_bi[rx_ring->next_to_clean];
+	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 	prefetchw(rx_buffer->page);
 
 	/* we are reusing so sync this buffer for CPU use */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 452bba7bc4ff..8d29477bb0b6 100644
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
@@ -824,7 +830,7 @@ void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring)
 	u16 i;
 
 	for (i = 0; i < rx_ring->count; i++) {
-		struct i40e_rx_buffer *rx_bi = &rx_ring->rx_bi[i];
+		struct i40e_rx_buffer *rx_bi = i40e_rx_bi(rx_ring, i);
 
 		if (!rx_bi->addr)
 			continue;
-- 
2.25.1

