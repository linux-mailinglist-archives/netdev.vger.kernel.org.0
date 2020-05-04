Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B731C34EF
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgEDIva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728428AbgEDIv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE20C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:28 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id q124so8179771pgq.13
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LRCDblSRJiI+h0s8c0CqbQk3dO/iqfIvOpiSibkp6xw=;
        b=gekN+Z0RiPRmNDWO9ZCOcTg3MVDslZenMzjG8/gOOpxbUVS0VUPmyznPo+5FLzvS8u
         rB4DaV1wEP+gCd0EU6SfOsQ6X0dyfhKus9D+miYle0DUqlm1Yzp63SblqfLOcjMQmlA0
         feDjdHzcrvRWC6nudUPELKs6IXGh4M2NLZCco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LRCDblSRJiI+h0s8c0CqbQk3dO/iqfIvOpiSibkp6xw=;
        b=cdvcKoWG1F7g5R13WEJvpzfOTmV89lCC+knEBKnjwXvvYh1ify3Z8+52L7SB+rKJWV
         yCvQVFuhEo7rXJvb81wEfeNXzCTqgUO+4AfPo0M1GPC3xM+iMygh1MweREBihZKzP8m0
         JkLPq5uKVOInjG9a/PngacCAU9x+Cg06zKJtHOzZGhofV8IOMzx5wvIRJYquRWWGVr11
         3g6fjue5mw4Jfa1q9oNa7pLpqUu+nMx/C6EpJsusEEmBsZ64TKBh6kRx8pvyQVJkK7Vv
         RudLnuEuSiJUP1sjyaRBCM+KXmiwTm+Mdqk3Dk9kTNScgH5fN2Rv9UVXQrnnHUQn8Qxh
         GZ8Q==
X-Gm-Message-State: AGi0PuYRG2vtfQJWU957O+cn//IaeaGabo4Vz5ihJrXk9vcXSmiMw41u
        0tJhLkJ+iUGgDMZzmMqkvroaacfWoys=
X-Google-Smtp-Source: APiQypJw92N2QqyPxnlJS472l0mZQWCjHTFRk61GLM09WrJwc/2T1Q96Ru6uPNv/f8Oe0bdL2gK3Yw==
X-Received: by 2002:a63:4446:: with SMTP id t6mr16000918pgk.450.1588582287445;
        Mon, 04 May 2020 01:51:27 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:27 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Rajesh Ravi <rajesh.ravi@broadcom.com>
Subject: [PATCH net-next 15/15] bnxt_en: show only relevant ethtool stats for a TX or RX ring
Date:   Mon,  4 May 2020 04:50:41 -0400
Message-Id: <1588582241-31066-16-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rajesh Ravi <rajesh.ravi@broadcom.com>

Currently, ethtool -S shows all TX/RX ring counters whether the
channel is combined, RX, or TX.  The unused counters will always be
zero.  Improve it by showing only the relevant counters if the channel
is RX or TX.  If the channel is combined, the counters will be shown
exactly the same as before.

[ MChan: Lots of cleanups and simplifications on Rajesh's original
code]

Signed-off-by: Rajesh Ravi <rajesh.ravi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 93 +++++++++++++++++------
 1 file changed, 71 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 85080f5..0752686 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -494,12 +494,20 @@ static int bnxt_get_num_tpa_ring_stats(struct bnxt *bp)
 static int bnxt_get_num_ring_stats(struct bnxt *bp)
 {
 	int rx, tx, cmn;
+	bool sh = false;
+
+	if (bp->flags & BNXT_FLAG_SHARED_RINGS)
+		sh = true;
 
 	rx = NUM_RING_RX_HW_STATS + NUM_RING_RX_SW_STATS +
 	     bnxt_get_num_tpa_ring_stats(bp);
 	tx = NUM_RING_TX_HW_STATS;
 	cmn = NUM_RING_CMN_SW_STATS;
-	return (rx + tx + cmn) * bp->cp_nr_rings;
+	if (sh)
+		return (rx + tx + cmn) * bp->cp_nr_rings;
+	else
+		return rx * bp->rx_nr_rings + tx * bp->tx_nr_rings +
+		       cmn * bp->cp_nr_rings;
 }
 
 static int bnxt_get_num_stats(struct bnxt *bp)
@@ -540,13 +548,29 @@ static int bnxt_get_sset_count(struct net_device *dev, int sset)
 	}
 }
 
+static bool is_rx_ring(struct bnxt *bp, int ring_num)
+{
+	return ring_num < bp->rx_nr_rings;
+}
+
+static bool is_tx_ring(struct bnxt *bp, int ring_num)
+{
+	int tx_base = 0;
+
+	if (!(bp->flags & BNXT_FLAG_SHARED_RINGS))
+		tx_base = bp->rx_nr_rings;
+
+	if (ring_num >= tx_base && ring_num < (tx_base + bp->tx_nr_rings))
+		return true;
+	return false;
+}
+
 static void bnxt_get_ethtool_stats(struct net_device *dev,
 				   struct ethtool_stats *stats, u64 *buf)
 {
 	u32 i, j = 0;
 	struct bnxt *bp = netdev_priv(dev);
-	u32 stat_fields = NUM_RING_RX_HW_STATS + NUM_RING_TX_HW_STATS +
-			  bnxt_get_num_tpa_ring_stats(bp);
+	u32 tpa_stats;
 
 	if (!bp->bnapi) {
 		j += bnxt_get_num_ring_stats(bp) + BNXT_NUM_SW_FUNC_STATS;
@@ -556,6 +580,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 	for (i = 0; i < BNXT_NUM_SW_FUNC_STATS; i++)
 		bnxt_sw_func_stats[i].counter = 0;
 
+	tpa_stats = bnxt_get_num_tpa_ring_stats(bp);
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
@@ -563,12 +588,30 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		u64 *sw;
 		int k;
 
-		for (k = 0; k < stat_fields; j++, k++)
+		if (is_rx_ring(bp, i)) {
+			for (k = 0; k < NUM_RING_RX_HW_STATS; j++, k++)
+				buf[j] = le64_to_cpu(hw_stats[k]);
+		}
+		if (is_tx_ring(bp, i)) {
+			k = NUM_RING_RX_HW_STATS;
+			for (; k < NUM_RING_RX_HW_STATS + NUM_RING_TX_HW_STATS;
+			       j++, k++)
+				buf[j] = le64_to_cpu(hw_stats[k]);
+		}
+		if (!tpa_stats || !is_rx_ring(bp, i))
+			goto skip_tpa_ring_stats;
+
+		k = NUM_RING_RX_HW_STATS + NUM_RING_TX_HW_STATS;
+		for (; k < NUM_RING_RX_HW_STATS + NUM_RING_TX_HW_STATS +
+			   tpa_stats; j++, k++)
 			buf[j] = le64_to_cpu(hw_stats[k]);
 
+skip_tpa_ring_stats:
 		sw = (u64 *)&cpr->sw_stats.rx;
-		for (k = 0; k < NUM_RING_RX_SW_STATS; j++, k++)
-			buf[j] = sw[k];
+		if (is_rx_ring(bp, i)) {
+			for (k = 0; k < NUM_RING_RX_SW_STATS; j++, k++)
+				buf[j] = sw[k];
+		}
 
 		sw = (u64 *)&cpr->sw_stats.cmn;
 		for (k = 0; k < NUM_RING_CMN_SW_STATS; j++, k++)
@@ -650,20 +693,24 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < bp->cp_nr_rings; i++) {
-			num_str = NUM_RING_RX_HW_STATS;
-			for (j = 0; j < num_str; j++) {
-				sprintf(buf, "[%d]: %s", i,
-					bnxt_ring_rx_stats_str[j]);
-				buf += ETH_GSTRING_LEN;
+			if (is_rx_ring(bp, i)) {
+				num_str = NUM_RING_RX_HW_STATS;
+				for (j = 0; j < num_str; j++) {
+					sprintf(buf, "[%d]: %s", i,
+						bnxt_ring_rx_stats_str[j]);
+					buf += ETH_GSTRING_LEN;
+				}
 			}
-			num_str = NUM_RING_TX_HW_STATS;
-			for (j = 0; j < num_str; j++) {
-				sprintf(buf, "[%d]: %s", i,
-					bnxt_ring_tx_stats_str[j]);
-				buf += ETH_GSTRING_LEN;
+			if (is_tx_ring(bp, i)) {
+				num_str = NUM_RING_TX_HW_STATS;
+				for (j = 0; j < num_str; j++) {
+					sprintf(buf, "[%d]: %s", i,
+						bnxt_ring_tx_stats_str[j]);
+					buf += ETH_GSTRING_LEN;
+				}
 			}
 			num_str = bnxt_get_num_tpa_ring_stats(bp);
-			if (!num_str)
+			if (!num_str || !is_rx_ring(bp, i))
 				goto skip_tpa_stats;
 
 			if (bp->max_tpa_v2)
@@ -676,11 +723,13 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 				buf += ETH_GSTRING_LEN;
 			}
 skip_tpa_stats:
-			num_str = NUM_RING_RX_SW_STATS;
-			for (j = 0; j < num_str; j++) {
-				sprintf(buf, "[%d]: %s", i,
-					bnxt_rx_sw_stats_str[j]);
-				buf += ETH_GSTRING_LEN;
+			if (is_rx_ring(bp, i)) {
+				num_str = NUM_RING_RX_SW_STATS;
+				for (j = 0; j < num_str; j++) {
+					sprintf(buf, "[%d]: %s", i,
+						bnxt_rx_sw_stats_str[j]);
+					buf += ETH_GSTRING_LEN;
+				}
 			}
 			num_str = NUM_RING_CMN_SW_STATS;
 			for (j = 0; j < num_str; j++) {
-- 
2.5.1

