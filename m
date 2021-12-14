Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE47B474E02
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhLNWnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbhLNWnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:43:09 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A485C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:08 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id r34-20020a17090a43a500b001b0f0837ce8so2440086pjg.2
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZgtVJVvnbACKc4Enb0x5ug683st5CGBAW37lbrDODgg=;
        b=HxqmX4mTRoswZu9VjYM/t93M+y57BE//+Snlfzh41P/f943EIEdHuze7cacCYNIFme
         oO6MxIgBmQX331XvQtyqLm7KDdY/uGpOLp1/vPxORLlQk/GljxZXMnqgNdcriVKzHnrX
         zo+XUTWk7TOuCDdyUUlezIK3kkcfE0i3hJZD0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZgtVJVvnbACKc4Enb0x5ug683st5CGBAW37lbrDODgg=;
        b=eb6/7+NbUuGMBgfYOU/p6gFh37NPwAbIo2OWDiCOsghPwRd9p3Ksm1OaVjVlFwq2Ja
         X+6MUBEVQ7Soiweyoxc7a31ccsWvKwFaiTxpKPrRrgeMIkivhpRbb4S4UlqlQjE2cOOb
         YcMSWakwAX7V9iNqUT/afAV7plryU1uurFqJH5GVGOxES+IrkEoM1ym+2qmwwMqZyT16
         fUDsqhuqJjQd3vwFRtli0vT/RXtId8oO/Ivwo4udd0e9cXeNLyQ66vvSQSOe/lNkFsSj
         Ro7PFLZih2yKG+HHmj+vhcIfbH4Yk/FOvqBVR9TTNRrRiG2eQU60ZVvw9A/vF860rQg5
         0NMQ==
X-Gm-Message-State: AOAM530S1Flznf5/wHA8sMcuCyhh40muPambVJ8FgmieZs2EefO1eIal
        638oCM88fvKNsh/wsa8vP0TX0Q==
X-Google-Smtp-Source: ABdhPJwzT9LDDMmisoISJ/SbIwH0BCsdFvcLNKsOxB7wd+tACmY4G61jy9Wdf5ysB0dIwjY46IIgug==
X-Received: by 2002:a17:902:a584:b0:143:c2e3:c4 with SMTP id az4-20020a170902a58400b00143c2e300c4mr8690280plb.69.1639521788141;
        Tue, 14 Dec 2021 14:43:08 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id mg12sm3448012pjb.10.2021.12.14.14.43.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 14:43:07 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [net-queue PATCH 2/5] i40e: Aggregate and export RX page reuse stat.
Date:   Tue, 14 Dec 2021 14:42:07 -0800
Message-Id: <1639521730-57226-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
References: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rx page reuse was already being tracked by the i40e driver per RX ring.
Aggregate the counts and make them accessible via ethtool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         | 1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 7f40f87..b61f17bf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -853,6 +853,7 @@ struct i40e_vsi {
 	u64 tx_force_wb;
 	u64 rx_buf_failed;
 	u64 rx_page_failed;
+	u64 rx_page_reuse;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 513ba69..ceb0d5f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -295,6 +295,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("tx_busy", tx_busy),
 	I40E_VSI_STAT("rx_alloc_fail", rx_buf_failed),
 	I40E_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
+	I40E_VSI_STAT("rx_cache_reuse", rx_page_reuse),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4ff1c9b..6d3b0bc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -812,7 +812,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	struct i40e_eth_stats *es;     /* device's eth stats */
 	u64 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u64 rx_page, rx_buf;
+	u64 rx_page, rx_buf, rx_reuse;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;
@@ -838,6 +838,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	tx_restart = tx_busy = tx_linearize = tx_force_wb = 0;
 	rx_page = 0;
 	rx_buf = 0;
+	rx_reuse = 0;
 	rcu_read_lock();
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
@@ -871,6 +872,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		rx_p += packets;
 		rx_buf += p->rx_stats.alloc_buff_failed;
 		rx_page += p->rx_stats.alloc_page_failed;
+		rx_reuse += p->rx_stats.page_reuse_count;
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
 			/* locate XDP ring */
@@ -898,6 +900,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	vsi->tx_force_wb = tx_force_wb;
 	vsi->rx_page_failed = rx_page;
 	vsi->rx_buf_failed = rx_buf;
+	vsi->rx_page_reuse = rx_reuse;
 
 	ns->rx_packets = rx_p;
 	ns->rx_bytes = rx_b;
-- 
2.7.4

