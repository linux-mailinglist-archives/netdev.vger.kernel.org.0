Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6791C34ED
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgEDIv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728428AbgEDIvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:24 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3135C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:23 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id y6so3506413pjc.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tg7NdtzbHMMPyDPv491t70ZKJY5OzCj+r1V6LhEqTII=;
        b=dYzMSfRiCmIAxi58WN5q6VRJJsM4EoPOat5bZ++1jRquaAdMS9lSknCyzkvkcT691Z
         ZTgsYfBJOV3rv4reBSSaCF9yWQB3+nWHMvKgMmg4NkbsEIt8jaGZPRZ4rn1g3BzuBWQQ
         vK4v3ma9AcYJy7EV/4mEFEeD/cyPVy71ZAboo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tg7NdtzbHMMPyDPv491t70ZKJY5OzCj+r1V6LhEqTII=;
        b=UL9uY7yyapbrpLeCCaatDYECwvuZP/CExDfad/cPPjMO+okzwO456tUz5yY9ieCfBL
         KrZUg3q2zjQFpW+b49BTyepPWOJxJKWJ24pil8cbC2zKy8w/qYEhSq//suoo9vVHypag
         4mbXTiFkL/VQumZwAkktlcW9uBw4qPdvbRTcH51BD3upwFYIUNYsQeGKyXs7Dsg6O3+F
         v5DRwVN3DjMZh53o05w/voB0LnUPBCABSovB6LOzf+EizZ5UkgndHcvtkyF1nXWqsm9A
         gXQ2H1s4lbHEKwLFHkfb3Oheo7zUl7uuI8TfBAAWqYG8918C/1HtO+OjGXzLYzV1h4RI
         G6vQ==
X-Gm-Message-State: AGi0PubTi5v1wWT+mJqA4RStPSGQmW6vJFbjoj5RiwFgsMI3wZPFJXg0
        CSIeAmSfJaiBZoRau3IWueDNOVkhQTc=
X-Google-Smtp-Source: APiQypJE1565YD61Uf5O61lWF8JGmHdtTvRJccEQs5ALX/o7J2wFkXPaHuivWMmDq1sHqsqKa0vYhg==
X-Received: by 2002:a17:90a:7788:: with SMTP id v8mr16686534pjk.111.1588582283170;
        Mon, 04 May 2020 01:51:23 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 13/15] bnxt_en: Refactor the software ring counters.
Date:   Mon,  4 May 2020 04:50:39 -0400
Message-Id: <1588582241-31066-14-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently have 3 software ring counters, rx_l4_csum_errors,
rx_buf_errors, and missed_irqs.  The 1st two are RX counters and the
last one is a common counter.  Organize them into 2 structures
bnxt_rx_sw_stats and bnxt_cmn_sw_stats.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  6 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 19 +++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 30 +++++++++++++++++------
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8f11344..4bbfea1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1766,7 +1766,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 		rc = -EIO;
 		if (rx_err & RX_CMPL_ERRORS_BUFFER_ERROR_MASK) {
-			bnapi->cp_ring.rx_buf_errors++;
+			bnapi->cp_ring.sw_stats.rx.rx_buf_errors++;
 			if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
 				netdev_warn(bp->dev, "RX buffer error %x\n",
 					    rx_err);
@@ -1849,7 +1849,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	} else {
 		if (rxcmp1->rx_cmp_cfa_code_errors_v2 & RX_CMP_L4_CS_ERR_BITS) {
 			if (dev->features & NETIF_F_RXCSUM)
-				bnapi->cp_ring.rx_l4_csum_errors++;
+				bnapi->cp_ring.sw_stats.rx.rx_l4_csum_errors++;
 		}
 	}
 
@@ -10285,7 +10285,7 @@ static void bnxt_chk_missed_irq(struct bnxt *bp)
 			bnxt_dbg_hwrm_ring_info_get(bp,
 				DBG_RING_INFO_GET_REQ_RING_TYPE_L2_CMPL,
 				fw_ring_id, &val[0], &val[1]);
-			cpr->missed_irqs++;
+			cpr->sw_stats.cmn.missed_irqs++;
 		}
 	}
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 6114b0a..c15517f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -910,6 +910,20 @@ struct bnxt_rx_ring_info {
 	struct page_pool	*page_pool;
 };
 
+struct bnxt_rx_sw_stats {
+	u64			rx_l4_csum_errors;
+	u64			rx_buf_errors;
+};
+
+struct bnxt_cmn_sw_stats {
+	u64			missed_irqs;
+};
+
+struct bnxt_sw_stats {
+	struct bnxt_rx_sw_stats rx;
+	struct bnxt_cmn_sw_stats cmn;
+};
+
 struct bnxt_cp_ring_info {
 	struct bnxt_napi	*bnapi;
 	u32			cp_raw_cons;
@@ -937,9 +951,8 @@ struct bnxt_cp_ring_info {
 	struct ctx_hw_stats	*hw_stats;
 	dma_addr_t		hw_stats_map;
 	u32			hw_stats_ctx_id;
-	u64			rx_l4_csum_errors;
-	u64			rx_buf_errors;
-	u64			missed_irqs;
+
+	struct bnxt_sw_stats	sw_stats;
 
 	struct bnxt_ring_struct	cp_ring_struct;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ad68bc3..b2b43a7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -171,9 +171,12 @@ static const char * const bnxt_ring_tpa2_stats_str[] = {
 	"rx_tpa_errors",
 };
 
-static const char * const bnxt_ring_sw_stats_str[] = {
+static const char * const bnxt_rx_sw_stats_str[] = {
 	"rx_l4_csum_errors",
 	"rx_buf_errors",
+};
+
+static const char * const bnxt_cmn_sw_stats_str[] = {
 	"missed_irqs",
 };
 
@@ -485,7 +488,8 @@ static int bnxt_get_num_ring_stats(struct bnxt *bp)
 	int num_stats;
 
 	num_stats = ARRAY_SIZE(bnxt_ring_stats_str) +
-		    ARRAY_SIZE(bnxt_ring_sw_stats_str) +
+		    ARRAY_SIZE(bnxt_rx_sw_stats_str) +
+		    ARRAY_SIZE(bnxt_cmn_sw_stats_str) +
 		    bnxt_get_num_tpa_ring_stats(bp);
 	return num_stats * bp->cp_nr_rings;
 }
@@ -548,13 +552,19 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
 		__le64 *hw_stats = (__le64 *)cpr->hw_stats;
+		u64 *sw;
 		int k;
 
 		for (k = 0; k < stat_fields; j++, k++)
 			buf[j] = le64_to_cpu(hw_stats[k]);
-		buf[j++] = cpr->rx_l4_csum_errors;
-		buf[j++] = cpr->rx_buf_errors;
-		buf[j++] = cpr->missed_irqs;
+
+		sw = (u64 *)&cpr->sw_stats.rx;
+		for (k = 0; k < ARRAY_SIZE(bnxt_rx_sw_stats_str); j++, k++)
+			buf[j] = sw[k];
+
+		sw = (u64 *)&cpr->sw_stats.cmn;
+		for (k = 0; k < ARRAY_SIZE(bnxt_cmn_sw_stats_str); j++, k++)
+			buf[j] = sw[k];
 
 		bnxt_sw_func_stats[RX_TOTAL_DISCARDS].counter +=
 			le64_to_cpu(cpr->hw_stats->rx_discard_pkts);
@@ -653,10 +663,16 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 				buf += ETH_GSTRING_LEN;
 			}
 skip_tpa_stats:
-			num_str = ARRAY_SIZE(bnxt_ring_sw_stats_str);
+			num_str = ARRAY_SIZE(bnxt_rx_sw_stats_str);
+			for (j = 0; j < num_str; j++) {
+				sprintf(buf, "[%d]: %s", i,
+					bnxt_rx_sw_stats_str[j]);
+				buf += ETH_GSTRING_LEN;
+			}
+			num_str = ARRAY_SIZE(bnxt_cmn_sw_stats_str);
 			for (j = 0; j < num_str; j++) {
 				sprintf(buf, "[%d]: %s", i,
-					bnxt_ring_sw_stats_str[j]);
+					bnxt_cmn_sw_stats_str[j]);
 				buf += ETH_GSTRING_LEN;
 			}
 		}
-- 
2.5.1

