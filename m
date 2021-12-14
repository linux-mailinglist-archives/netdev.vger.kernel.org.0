Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D449474E04
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhLNWnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbhLNWnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:43:10 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0E4C06173E
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:10 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso17353571pjl.3
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cXLbOOaKhjGO3E8gN2CpwZMKvhA9B+iiFAqoEOQ+Usg=;
        b=Gb8fEwmpJD1S0gkVEZWABOIHoLGna9SzvqYAHT/p2SzMnGDoGs2aByWAGEV5vDJggK
         tVOAYDMs8FnbLbZZnUn1MEbOPxnO+Y+k3TOSqLv9AmO7xdRlC2AFO/UZdIXQTrfJs9/e
         r28ZOWRwFggMeqjoFTw2EfaBTbosZdKFmmDWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cXLbOOaKhjGO3E8gN2CpwZMKvhA9B+iiFAqoEOQ+Usg=;
        b=NhQFzX7Tz/BYnpa2WSC6jY6RrsDV3pbPKI54TYUiRjv1BpZDgH3D4vkiX1ATSADFkq
         wXqaPce2gD43nbJIotZvO31WQoEB1P9t2mCRt2f4FJdBvNbpoFbirV2viHyUpHHwGtw0
         0vXzrYvKJx3kvLb3IBDcQQOuRsXEI4bah1VJuHEaZN3CZ4gNzZBKd4+kc4//+Gz1Aj8R
         N5B6CrowLHrXCSxUz5nq/UK5VxGAUieQ1WAIHyy73AngzIVNyZfMBRoILf2GNOzznrsU
         R2sOO+BrB6BklQ8/dkIGiRERnkgBAImI9bVt5UZ8UYZvvY5QiTHjNFznAzmQkWjnT2Ao
         Soww==
X-Gm-Message-State: AOAM531nroaFP8FDRGwp1xjPmpXRYAnmtjgViusrKlLMeYliYbj9mS0+
        buiWZUHacCt+cOjkImmVUE3yTg==
X-Google-Smtp-Source: ABdhPJyfMY/ECw/n2chQbxc0QyP1z+G2CwtY+nsTeYdfcT0+LziUyi/WqC+sIsImE5+Md6OcrTrpSg==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr8428148pjb.96.1639521789600;
        Tue, 14 Dec 2021 14:43:09 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id mg12sm3448012pjb.10.2021.12.14.14.43.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 14:43:09 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [net-queue PATCH 3/5] i40e: Add a stat tracking new RX page allocations.
Date:   Tue, 14 Dec 2021 14:42:08 -0800
Message-Id: <1639521730-57226-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
References: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a counter for new page allocations in the i40e RX path. This stat is
accessible with ethtool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         | 1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 5 ++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 2 ++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    | 1 +
 5 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index b61f17bf..ab73de2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -854,6 +854,7 @@ struct i40e_vsi {
 	u64 rx_buf_failed;
 	u64 rx_page_failed;
 	u64 rx_page_reuse;
+	u64 rx_page_alloc;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index ceb0d5f..22f746b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -296,6 +296,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("rx_alloc_fail", rx_buf_failed),
 	I40E_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
 	I40E_VSI_STAT("rx_cache_reuse", rx_page_reuse),
+	I40E_VSI_STAT("rx_cache_alloc", rx_page_alloc),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6d3b0bc..33c3f04 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -812,7 +812,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	struct i40e_eth_stats *es;     /* device's eth stats */
 	u64 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u64 rx_page, rx_buf, rx_reuse;
+	u64 rx_page, rx_buf, rx_reuse, rx_alloc;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;
@@ -839,6 +839,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	rx_page = 0;
 	rx_buf = 0;
 	rx_reuse = 0;
+	rx_reuse = 0;
 	rcu_read_lock();
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
@@ -873,6 +874,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		rx_buf += p->rx_stats.alloc_buff_failed;
 		rx_page += p->rx_stats.alloc_page_failed;
 		rx_reuse += p->rx_stats.page_reuse_count;
+		rx_alloc += p->rx_stats.page_alloc_count;
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
 			/* locate XDP ring */
@@ -901,6 +903,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	vsi->rx_page_failed = rx_page;
 	vsi->rx_buf_failed = rx_buf;
 	vsi->rx_page_reuse = rx_reuse;
+	vsi->rx_page_alloc = rx_alloc;
 
 	ns->rx_packets = rx_p;
 	ns->rx_bytes = rx_b;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 8b3ffb7..1450efd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1671,6 +1671,8 @@ static bool i40e_alloc_mapped_page(struct i40e_ring *rx_ring,
 	if (unlikely(!page)) {
 		rx_ring->rx_stats.alloc_page_failed++;
 		return false;
+	} else {
+		rx_ring->rx_stats.page_alloc_count++;
 	}
 
 	/* map page for use */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index bfc2845..7041e81 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -299,6 +299,7 @@ struct i40e_rx_queue_stats {
 	u64 alloc_buff_failed;
 	u64 page_reuse_count;
 	u64 realloc_count;
+	u64 page_alloc_count;
 };
 
 enum i40e_ring_state_t {
-- 
2.7.4

