Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0023474E06
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhLNWnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234225AbhLNWnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:43:13 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B8FC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:13 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id n8so14763735plf.4
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9N389LoTGE6mkt5oIUV8Cfwv96Xp7JiTrhAZSKUqRm8=;
        b=cML2mpwqvMNN/LTebykUwE2fMZaeIvgC07oc10BPfDvg5nrr3JaWt/wN8DiF4JezUg
         BZg6J38YgSojWHCycSirp7dPxJBAF0wMS0HVKR5guq1G061AUEQdFzqwQehh5DPY+LwX
         tia7GwRmwhCsGvlVSJc5T2Pfs/ZmCSPOHi2DE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9N389LoTGE6mkt5oIUV8Cfwv96Xp7JiTrhAZSKUqRm8=;
        b=rp1TaeNskZoP/Q4M7EYmv+l4ISEzK2vT6tIHB5R1z8J7Y98OcB0Uq/0lZSJPMi1j7J
         r4ovxLPj5YYPXZHnhddvRjH4sPZp3p6msYnv+LcG0zDsIOAG+DTOds8rxWNfHbVHDIru
         WmlcVfkGQywQmdxKuG7xVv35mk/SNvh9X237i5VckwxV3LkMZvYJRYA4aKMhOSfXGGzH
         4ysoJJUJ+5c7lfcVrG5nVjSoYDQ0UVSRZWdyIM2d78w33UJiywyoYh4oreDrZ0WyXiGl
         O+hyaBqHAracqCQERCrvWTHkq7EoLwpI+GVpbvq828J6cY2RbVtIBBcQQxVBhXnjXIu3
         mQxA==
X-Gm-Message-State: AOAM530IiVO7UAbXr0K/Z2DLhwMzcncoZxROPI3HailkuDY00ssFoV93
        3XiUaFRXmRsc+Y223xVnP23/qw==
X-Google-Smtp-Source: ABdhPJwu8VvQfDP4t4kH5s1EridEC1TGMkQI5RwoCYPjm8LiNZj2QNJLNnq6k8u2Ywe5rhG3FS+d5g==
X-Received: by 2002:a17:902:8645:b0:142:8c0d:3f4a with SMTP id y5-20020a170902864500b001428c0d3f4amr8075863plt.3.1639521792792;
        Tue, 14 Dec 2021 14:43:12 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id mg12sm3448012pjb.10.2021.12.14.14.43.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 14:43:12 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [net-queue PATCH 5/5] i40e: Add a stat for tracking busy rx pages.
Date:   Tue, 14 Dec 2021 14:42:10 -0800
Message-Id: <1639521730-57226-6-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
References: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases, pages cannot be reused by i40e because the page is busy. Add
a counter for this event.

Busy page count is accessible via ethtool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         |  1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    |  5 ++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 12 ++++++++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |  1 +
 5 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 3774e7b..b50530e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -856,6 +856,7 @@ struct i40e_vsi {
 	u64 rx_page_reuse;
 	u64 rx_page_alloc;
 	u64 rx_page_waive;
+	u64 rx_page_busy;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 224fe6d..64fd869 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -298,6 +298,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("rx_cache_reuse", rx_page_reuse),
 	I40E_VSI_STAT("rx_cache_alloc", rx_page_alloc),
 	I40E_VSI_STAT("rx_cache_waive", rx_page_waive),
+	I40E_VSI_STAT("rx_cache_busy", rx_page_busy),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ded7aa9..1d9032c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -812,7 +812,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	struct i40e_eth_stats *es;     /* device's eth stats */
 	u64 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u64 rx_page, rx_buf, rx_reuse, rx_alloc, rx_waive;
+	u64 rx_page, rx_buf, rx_reuse, rx_alloc, rx_waive, rx_busy;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;
@@ -841,6 +841,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	rx_reuse = 0;
 	rx_reuse = 0;
 	rx_waive = 0;
+	rx_busy = 0;
 	rcu_read_lock();
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
@@ -877,6 +878,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		rx_reuse += p->rx_stats.page_reuse_count;
 		rx_alloc += p->rx_stats.page_alloc_count;
 		rx_waive += p->rx_stats.page_waive_count;
+		rx_busy += p->rx_stats.page_busy_count;
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
 			/* locate XDP ring */
@@ -907,6 +909,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	vsi->rx_page_reuse = rx_reuse;
 	vsi->rx_page_alloc = rx_alloc;
 	vsi->rx_page_waive = rx_waive;
+	vsi->rx_page_busy = rx_busy;
 
 	ns->rx_packets = rx_p;
 	ns->rx_bytes = rx_b;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index c7ad983..271697b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1990,8 +1990,8 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx_ring, struct sk_buff *skb,
  * pointing to; otherwise, the DMA mapping needs to be destroyed and
  * page freed.
  *
- * rx_stats will be updated to indicate if the page was waived because it was
- * not reusable.
+ * rx_stats will be updated to indicate whether the page was waived
+ * or busy if it could not be reused.
  */
 static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
 				   struct i40e_rx_queue_stats *rx_stats,
@@ -2008,13 +2008,17 @@ static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1)) {
+		rx_stats->page_busy_count++;
 		return false;
+	}
 #else
 #define I40E_LAST_OFFSET \
 	(SKB_WITH_OVERHEAD(PAGE_SIZE) - I40E_RXBUFFER_2048)
-	if (rx_buffer->page_offset > I40E_LAST_OFFSET)
+	if (rx_buffer->page_offset > I40E_LAST_OFFSET) {
+		rx_stats->page_busy_count++;
 		return false;
+	}
 #endif
 
 	/* If we have drained the page fragment pool we need to update
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index e049cf48..fd22e2f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -301,6 +301,7 @@ struct i40e_rx_queue_stats {
 	u64 realloc_count;
 	u64 page_alloc_count;
 	u64 page_waive_count;
+	u64 page_busy_count;
 };
 
 enum i40e_ring_state_t {
-- 
2.7.4

