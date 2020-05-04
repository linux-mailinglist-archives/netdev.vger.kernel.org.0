Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6BE1C34EE
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgEDIva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728422AbgEDIvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:25 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FDDC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:25 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x77so5221532pfc.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x4d33j1yVIw7ZYIWKI8RQICWxKkL5CzQHLmKumdnXf0=;
        b=CHvGRJ7gGJuM2v5MNTOKt2fSp2jBu3B6Sua/sJaxwooMWfmymvBkOBfRd08Zac6iho
         siZi5kcaQtH5peICmAbIYcE5oIIlwuvCv+glwDd3g4nAsx8wCU6Kx+Dqojhk4gmbr4CN
         uYtFHyZrDl725bdqv5Z6A3pFhnZUYD0kVMEF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x4d33j1yVIw7ZYIWKI8RQICWxKkL5CzQHLmKumdnXf0=;
        b=INHTZbAtHkC/Wlsju1eBi1bnnDdkbq48VOjtqB8sxd7InmqDlS2hDEOP/ppLQPMex+
         ONY5i90vW1msxS1BmYeQVLdV7tNXuv2yVKtboBUhEIyEJF/ABy4mk3+Ea/L7CllbHtG2
         Qjh6z5QkuIKB4/WAnZJjPWI9Icl/iwGEuN01KgHMdylSc0Or45wcDdy5rq6XRkPPNgb5
         zAdpP1Q+riA6G+2XuguUwJpnEmYceYdHsZcU6hHMMdXD4VvtlbgYdYwhNEXk7SkM7Pnx
         vGiH1rbh4/Gh+cZy3GiMUUWDhAuux6r3TOSs2BVOhZo79ttO6m3zGQOfK6oWrciJBmnR
         phQQ==
X-Gm-Message-State: AGi0PuZCUEqHsH9V4DZSlFvw4/ZGyzhmzUIaX7ye0k3FrT7cjaZBdWOH
        cgZnMaqLMTt2ynnJv/aRXSYmdxH+HYU=
X-Google-Smtp-Source: APiQypLHHPyIJjcou5QuCiW/v7Lr96MswMDFrhCLa2aWc9K4gadKpD1q/ti0g9aRLjhvUxUEQlIeog==
X-Received: by 2002:a63:df42:: with SMTP id h2mr16384473pgj.216.1588582285183;
        Mon, 04 May 2020 01:51:25 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:24 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 14/15] bnxt_en: Split HW ring statistics strings into RX and TX parts.
Date:   Mon,  4 May 2020 04:50:40 -0400
Message-Id: <1588582241-31066-15-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will allow the RX and TX ring statistics to be separated if needed.
In the next patch, we'll be able to only display RX or TX statistcis if
the channel is RX only or TX only.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 53 ++++++++++++++---------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index b2b43a7..85080f5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -137,7 +137,7 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	return rc;
 }
 
-static const char * const bnxt_ring_stats_str[] = {
+static const char * const bnxt_ring_rx_stats_str[] = {
 	"rx_ucast_packets",
 	"rx_mcast_packets",
 	"rx_bcast_packets",
@@ -146,6 +146,9 @@ static const char * const bnxt_ring_stats_str[] = {
 	"rx_ucast_bytes",
 	"rx_mcast_bytes",
 	"rx_bcast_bytes",
+};
+
+static const char * const bnxt_ring_tx_stats_str[] = {
 	"tx_ucast_packets",
 	"tx_mcast_packets",
 	"tx_bcast_packets",
@@ -306,6 +309,11 @@ static struct {
 	{0, "tx_total_discard_pkts"},
 };
 
+#define NUM_RING_RX_SW_STATS		ARRAY_SIZE(bnxt_rx_sw_stats_str)
+#define NUM_RING_CMN_SW_STATS		ARRAY_SIZE(bnxt_cmn_sw_stats_str)
+#define NUM_RING_RX_HW_STATS		ARRAY_SIZE(bnxt_ring_rx_stats_str)
+#define NUM_RING_TX_HW_STATS		ARRAY_SIZE(bnxt_ring_tx_stats_str)
+
 static const struct {
 	long offset;
 	char string[ETH_GSTRING_LEN];
@@ -485,13 +493,13 @@ static int bnxt_get_num_tpa_ring_stats(struct bnxt *bp)
 
 static int bnxt_get_num_ring_stats(struct bnxt *bp)
 {
-	int num_stats;
+	int rx, tx, cmn;
 
-	num_stats = ARRAY_SIZE(bnxt_ring_stats_str) +
-		    ARRAY_SIZE(bnxt_rx_sw_stats_str) +
-		    ARRAY_SIZE(bnxt_cmn_sw_stats_str) +
-		    bnxt_get_num_tpa_ring_stats(bp);
-	return num_stats * bp->cp_nr_rings;
+	rx = NUM_RING_RX_HW_STATS + NUM_RING_RX_SW_STATS +
+	     bnxt_get_num_tpa_ring_stats(bp);
+	tx = NUM_RING_TX_HW_STATS;
+	cmn = NUM_RING_CMN_SW_STATS;
+	return (rx + tx + cmn) * bp->cp_nr_rings;
 }
 
 static int bnxt_get_num_stats(struct bnxt *bp)
@@ -537,7 +545,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 {
 	u32 i, j = 0;
 	struct bnxt *bp = netdev_priv(dev);
-	u32 stat_fields = ARRAY_SIZE(bnxt_ring_stats_str) +
+	u32 stat_fields = NUM_RING_RX_HW_STATS + NUM_RING_TX_HW_STATS +
 			  bnxt_get_num_tpa_ring_stats(bp);
 
 	if (!bp->bnapi) {
@@ -559,11 +567,11 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 			buf[j] = le64_to_cpu(hw_stats[k]);
 
 		sw = (u64 *)&cpr->sw_stats.rx;
-		for (k = 0; k < ARRAY_SIZE(bnxt_rx_sw_stats_str); j++, k++)
+		for (k = 0; k < NUM_RING_RX_SW_STATS; j++, k++)
 			buf[j] = sw[k];
 
 		sw = (u64 *)&cpr->sw_stats.cmn;
-		for (k = 0; k < ARRAY_SIZE(bnxt_cmn_sw_stats_str); j++, k++)
+		for (k = 0; k < NUM_RING_CMN_SW_STATS; j++, k++)
 			buf[j] = sw[k];
 
 		bnxt_sw_func_stats[RX_TOTAL_DISCARDS].counter +=
@@ -642,34 +650,39 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < bp->cp_nr_rings; i++) {
-			num_str = ARRAY_SIZE(bnxt_ring_stats_str);
+			num_str = NUM_RING_RX_HW_STATS;
 			for (j = 0; j < num_str; j++) {
 				sprintf(buf, "[%d]: %s", i,
-					bnxt_ring_stats_str[j]);
+					bnxt_ring_rx_stats_str[j]);
 				buf += ETH_GSTRING_LEN;
 			}
-			if (!BNXT_SUPPORTS_TPA(bp))
+			num_str = NUM_RING_TX_HW_STATS;
+			for (j = 0; j < num_str; j++) {
+				sprintf(buf, "[%d]: %s", i,
+					bnxt_ring_tx_stats_str[j]);
+				buf += ETH_GSTRING_LEN;
+			}
+			num_str = bnxt_get_num_tpa_ring_stats(bp);
+			if (!num_str)
 				goto skip_tpa_stats;
 
-			if (bp->max_tpa_v2) {
-				num_str = ARRAY_SIZE(bnxt_ring_tpa2_stats_str);
+			if (bp->max_tpa_v2)
 				str = bnxt_ring_tpa2_stats_str;
-			} else {
-				num_str = ARRAY_SIZE(bnxt_ring_tpa_stats_str);
+			else
 				str = bnxt_ring_tpa_stats_str;
-			}
+
 			for (j = 0; j < num_str; j++) {
 				sprintf(buf, "[%d]: %s", i, str[j]);
 				buf += ETH_GSTRING_LEN;
 			}
 skip_tpa_stats:
-			num_str = ARRAY_SIZE(bnxt_rx_sw_stats_str);
+			num_str = NUM_RING_RX_SW_STATS;
 			for (j = 0; j < num_str; j++) {
 				sprintf(buf, "[%d]: %s", i,
 					bnxt_rx_sw_stats_str[j]);
 				buf += ETH_GSTRING_LEN;
 			}
-			num_str = ARRAY_SIZE(bnxt_cmn_sw_stats_str);
+			num_str = NUM_RING_CMN_SW_STATS;
 			for (j = 0; j < num_str; j++) {
 				sprintf(buf, "[%d]: %s", i,
 					bnxt_cmn_sw_stats_str[j]);
-- 
2.5.1

