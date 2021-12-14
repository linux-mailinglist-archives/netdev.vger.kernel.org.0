Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AB5474E07
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhLNWnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbhLNWnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:43:16 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F88C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:16 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v16so2436174pjn.1
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cO5mUymTgAgFJWnKGqoJQUmz67qzdX6pyvAot2iSw1I=;
        b=EhM1rtoDK4P8frf69NguthySI2duHxlT78rGCyVW2af6rlXn7pt8yfok/PPNTS0Kpd
         7Al2deNdYeMTq5bsXIMbMsOUm9gq8xGyC/GpPa2/tj4xWg2mcDL2dhWo3h4PQRO/0Avz
         KWE7yO/y4T5QXA2Q3xZeEMnVNXoI5aiGshWgA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cO5mUymTgAgFJWnKGqoJQUmz67qzdX6pyvAot2iSw1I=;
        b=uWepEkMfQ33jnAtjGHOqIxEI7I3OarIMyleaCoHmZm+paQYmBfU9JQNJRwR7xFNLGr
         yicegWrdzEhqhvu9i0eOsxhH8bK3FZKsyoAADYQZnDmAkCv7/LdKCU1DKTXyFOCgLsIN
         KGU5p9JZLyT0LzFPnB8rGQErvcW23ijCpFqZqXeuFd1hNpr1LUZt0KL6KlHn3KBPOIlk
         r4Pbp5oQWmiPskCmYtTHOrUQ8NtSVEdK/HEH6hXrWEd7OnVOEp4DEhkk8DaUru2Ah3BQ
         BLMRtesEDti/zmc8HADD2V+Bup8vQ65nU23bl+zwyiVTC5g9vKhFziC0JEVSovGv0Wmn
         n4Lw==
X-Gm-Message-State: AOAM5337YSVaJUCQPA1TEbv7HCVuCl4cMyPl+iuHZ6n9PQCC9tA+7jdE
        dlh25lLrv0z6nDg5tiEHYwqInQ==
X-Google-Smtp-Source: ABdhPJwON7W5NUdjfKqny/gy085ggSbv1jnp0KwjsOmVcKUbFLUwoENij9TDxpAVPpcLX8UBbaRAgw==
X-Received: by 2002:a17:90b:1c86:: with SMTP id oo6mr8511896pjb.165.1639521791161;
        Tue, 14 Dec 2021 14:43:11 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id mg12sm3448012pjb.10.2021.12.14.14.43.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 14:43:10 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [net-queue PATCH 4/5] i40e: Add a stat for tracking pages waived.
Date:   Tue, 14 Dec 2021 14:42:09 -0800
Message-Id: <1639521730-57226-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
References: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases, pages can not be reused because they are not associated with
the correct NUMA zone. Knowing how often pages are waived helps users to
understand the interaction between the driver's memory usage and their
system.

Pass rx_stats through to i40e_can_reuse_rx_page to allow tracking when
pages are waived.

The page waive count is accessible via ethtool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         |  1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    |  5 ++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 13 ++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |  1 +
 5 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index ab73de2..3774e7b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -855,6 +855,7 @@ struct i40e_vsi {
 	u64 rx_page_failed;
 	u64 rx_page_reuse;
 	u64 rx_page_alloc;
+	u64 rx_page_waive;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 22f746b..224fe6d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -297,6 +297,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
 	I40E_VSI_STAT("rx_cache_reuse", rx_page_reuse),
 	I40E_VSI_STAT("rx_cache_alloc", rx_page_alloc),
+	I40E_VSI_STAT("rx_cache_waive", rx_page_waive),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 33c3f04..ded7aa9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -812,7 +812,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	struct i40e_eth_stats *es;     /* device's eth stats */
 	u64 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u64 rx_page, rx_buf, rx_reuse, rx_alloc;
+	u64 rx_page, rx_buf, rx_reuse, rx_alloc, rx_waive;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;
@@ -840,6 +840,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	rx_buf = 0;
 	rx_reuse = 0;
 	rx_reuse = 0;
+	rx_waive = 0;
 	rcu_read_lock();
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
@@ -875,6 +876,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		rx_page += p->rx_stats.alloc_page_failed;
 		rx_reuse += p->rx_stats.page_reuse_count;
 		rx_alloc += p->rx_stats.page_alloc_count;
+		rx_waive += p->rx_stats.page_waive_count;
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
 			/* locate XDP ring */
@@ -904,6 +906,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	vsi->rx_buf_failed = rx_buf;
 	vsi->rx_page_reuse = rx_reuse;
 	vsi->rx_page_alloc = rx_alloc;
+	vsi->rx_page_waive = rx_waive;
 
 	ns->rx_packets = rx_p;
 	ns->rx_bytes = rx_b;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 1450efd..c7ad983 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1982,22 +1982,29 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx_ring, struct sk_buff *skb,
 /**
  * i40e_can_reuse_rx_page - Determine if page can be reused for another Rx
  * @rx_buffer: buffer containing the page
+ * @rx_stats: rx stats structure for the rx ring
  * @rx_buffer_pgcnt: buffer page refcount pre xdp_do_redirect() call
  *
  * If page is reusable, we have a green light for calling i40e_reuse_rx_page,
  * which will assign the current buffer to the buffer that next_to_alloc is
  * pointing to; otherwise, the DMA mapping needs to be destroyed and
- * page freed
+ * page freed.
+ *
+ * rx_stats will be updated to indicate if the page was waived because it was
+ * not reusable.
  */
 static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
+				   struct i40e_rx_queue_stats *rx_stats,
 				   int rx_buffer_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
 
 	/* Is any reuse possible? */
-	if (!dev_page_is_reusable(page))
+	if (!dev_page_is_reusable(page)) {
+		rx_stats->page_waive_count++;
 		return false;
+	}
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
@@ -2237,7 +2244,7 @@ static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
 			       struct i40e_rx_buffer *rx_buffer,
 			       int rx_buffer_pgcnt)
 {
-	if (i40e_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
+	if (i40e_can_reuse_rx_page(rx_buffer, &rx_ring->rx_stats, rx_buffer_pgcnt)) {
 		/* hand second half of page back to the ring */
 		i40e_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 7041e81..e049cf48 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -300,6 +300,7 @@ struct i40e_rx_queue_stats {
 	u64 page_reuse_count;
 	u64 realloc_count;
 	u64 page_alloc_count;
+	u64 page_waive_count;
 };
 
 enum i40e_ring_state_t {
-- 
2.7.4

