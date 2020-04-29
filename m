Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C651BE656
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgD2Shu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2Sht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:37:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722D8C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:37:49 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y25so1484506pfn.5
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rrb1mAJQwtJnlsoCFjs27U5rfQ87ajEOcmCJLdQEk5Q=;
        b=kPNs4QLHfBhvUnUCpM7C+06TLEgqo31sWAsvQdKPTIQrsD7FUWpYA3i1LyS714s74x
         mrtUKvA2RkQ3U7f/3AoRb/U5s1GB33cG8hs++mlkVGvP4qTlIrERl4ZLnbk5M6aBjmZY
         2RY8tf8kNPUVbg/cWVsYaZic3f9jL/tOnQuASAjblpbtohgXEp4ibfmy9M6edoEJR7dG
         FY9gzNkhHvg6l/gPNuOTbypquVzijJb9BgMfG6zJPoOIeU4n15cgJzpF9hQRrdfdnAIP
         mv22f2uSbyH4tV1wU3arXXARIle/w87Ea6eO2HrkBLXk6svRQMPvTsMZ1pD2P2CPys3G
         UJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rrb1mAJQwtJnlsoCFjs27U5rfQ87ajEOcmCJLdQEk5Q=;
        b=fou3mLprhbdQk75+bGSzwtdkoHCjPT6umBC0e8i6jggZ92wC9lkCmydIUsg0F7F73L
         9H9tArvNqtRo7+uvdoSGYjoDFNUkEoEZJ9uyxrIf8C1trUXJGZA7DjFqzCrQdNY5PWDF
         avW1GWGW/T+tzgO03bYmR1NmhJpQcwoeX3s3oVEtTzWZq7ajHud0HqugA+H7g4160+A1
         1ClyEhvKVFfB0FheH9RHnpyw+47+E15miXvj5pmDCBEPT4ayJ3QZCJVKWmTapmCk4J3+
         jNo6NaO8IjNM1lwy77+zbskoB+s1PD3wK9IJQtbRvNofK4/Qxrs3g8tIEV+AJDYhlOho
         oanw==
X-Gm-Message-State: AGi0PuZLVnPU1c/DNJxOoc/2hGyA3ITc3eq0Y24K1bmPf/zRIOVPsFJn
        d7nPRmZTYG66TTamgy8yh1bWE05IpRQ=
X-Google-Smtp-Source: APiQypKeVnwB19JBvDw0bKZYgWqWH+Xm08SScG8WLaBayeX6lojblMfR5cnOJ9HZVc3/42IyqUE5PQ==
X-Received: by 2002:aa7:9546:: with SMTP id w6mr2049122pfq.114.1588185468691;
        Wed, 29 Apr 2020 11:37:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g27sm1511190pgn.52.2020.04.29.11.37.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 11:37:48 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/2] ionic: add LIF_READY state to close probe-open race
Date:   Wed, 29 Apr 2020 11:37:38 -0700
Message-Id: <20200429183739.56540-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429183739.56540-1-snelson@pensando.io>
References: <20200429183739.56540-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bit of state to the lif to signify when the queues are
ready to be used.  This closes an ionic_probe()/ionic_open()
race condition where the driver has registered the netdev
and signaled Link Up while running under ionic_probe(),
which NetworkManager or other user processes can see and then
try to bring up the device before the initial pass through
ionic_link_status_check() has finished.  NetworkManager's
thread can get into __dev_open() and set __LINK_STATE_START
in dev->state before the ionic_probe() thread makes it to the
netif_running() check, which results in the ionic_probe() thread
trying to start the queues before the queues have completed
their initialization.

Adding a LIF_QREADY flag allows us to prevent this condition by
signaling whether the Tx/Rx queues are initialized and ready.

Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c |  6 ++++++
 drivers/net/ethernet/pensando/ionic/ionic_lif.h | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5acf4f46c268..2dc513f43fd4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1627,6 +1627,9 @@ static int ionic_start_queues(struct ionic_lif *lif)
 {
 	int err;
 
+	if (!test_bit(IONIC_LIF_F_QREADY, lif->state))
+		return 0;
+
 	if (test_and_set_bit(IONIC_LIF_F_UP, lif->state))
 		return 0;
 
@@ -1652,6 +1655,7 @@ int ionic_open(struct net_device *netdev)
 	err = ionic_txrx_init(lif);
 	if (err)
 		goto err_out;
+	set_bit(IONIC_LIF_F_QREADY, lif->state);
 
 	/* don't start the queues until we have link */
 	if (netif_carrier_ok(netdev)) {
@@ -1663,6 +1667,7 @@ int ionic_open(struct net_device *netdev)
 	return 0;
 
 err_txrx_deinit:
+	clear_bit(IONIC_LIF_F_QREADY, lif->state);
 	ionic_txrx_deinit(lif);
 err_out:
 	ionic_txrx_free(lif);
@@ -1685,6 +1690,7 @@ int ionic_stop(struct net_device *netdev)
 	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 		return 0;
 
+	clear_bit(IONIC_LIF_F_QREADY, lif->state);
 	ionic_stop_queues(lif);
 	ionic_txrx_deinit(lif);
 	ionic_txrx_free(lif);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 5d4ffda5c05f..a7bf85c17354 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -121,9 +121,20 @@ struct ionic_lif_sw_stats {
 	u64 rx_csum_error;
 };
 
+/**
+ * enum ionic_lif_state_flags - driver LIF states
+ * @IONIC_LIF_F_INITED:		LIF configured, adminq running
+ * @IONIC_LIF_F_SW_DEBUG_STATS:	Ethtool printing of extra stats is enabled
+ * @IONIC_LIF_F_QREADY:		LIF queues are configured and ready for UP
+ * @IONIC_LIF_F_UP:		LIF is fully UP and running
+ * @IONIC_LIF_F_LINK_CHECK_REQUESTED:	Link check has been requested
+ * @IONIC_LIF_F_QUEUE_RESET:	LIF is resetting all queues
+ * @IONIC_LIF_F_FW_RESET:	FW is going through reset
+ */
 enum ionic_lif_state_flags {
 	IONIC_LIF_F_INITED,
 	IONIC_LIF_F_SW_DEBUG_STATS,
+	IONIC_LIF_F_QREADY,
 	IONIC_LIF_F_UP,
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_QUEUE_RESET,
-- 
2.17.1

