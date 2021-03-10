Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10CB333C2C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhCJMF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbhCJMEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:49 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F381C061761
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:49 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id dx17so38200083ejb.2
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/p6MuCdSjj8dGCJeSNxOi5fq7cl/jqB+h/TJZol4I48=;
        b=XSVV80yUzE2/Y92FrMZNN79Zp2fkKZvMaCagV4VEZDlSBDMruYhHvnmigoxBR4yety
         wlQIElfD1HJDJat54RGjtfz3UCD8YMUa4nWXu82vRlp76AcaKk+bFpcpsDVB8oV/h0Sj
         XTZ3R6YTp0Rxk58vf6rD7+8PsThRLsyh0C599noobXbld/5jrPzjeP43S9qAyoTyFHQ4
         j+axPkX2RIgMGJlH+KpgkL8dGxKsOOEXCwR6QqwPTMH3K2Y8bSKYbleDLtBdTdCxOTVd
         MzwHaUdGLd5OmtsIjgwdVrKFBrt0tmVmqlxC+vBKZp8JNhdNNGzJBQZ83rljgSK+a6zR
         NtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/p6MuCdSjj8dGCJeSNxOi5fq7cl/jqB+h/TJZol4I48=;
        b=AyOL+l1Nlvjdj3eq20BDeGmtCt9Sqwt0RNNA/Xr9NEYKJQ2QUwrUBY1VpnV8Ih5ajF
         kg1Q86YWe7FEJez5hp93uZ7N5O5IUUw1KzwEo2X/FTSIFSB3SsMSX4BaXWqFX7q+QWtR
         Pg95kxl/3UzfNuKqk+kpu9it5dDbOVHQalErmHeDAPZGXTZWJKEEQ4YToVvKmNJ4I1mQ
         n6UqavKECDYDpuF/9nF9DVlwP6J2zY/hBbYRc7tQlpIe48ST7FdDRnHXdUG9t10wLipf
         Jm5Ld6jC0reK+jMyW93ixVLF9ix8WmtfrPkvCj6W7xvSrT+x/y6/WCmbnbBw9A7UkXVy
         dM0g==
X-Gm-Message-State: AOAM532lxLQfU5Wmyz1X1TBpIsWOPXE3ezevIKRL3EZlPCbInQJKKDHz
        HvAqpi8Icfk1gqhDWsvm0nA=
X-Google-Smtp-Source: ABdhPJy6Ae276DfLs/4iMF3IqmNxbXnVBSMr28Sx9M8u0tXPMQ5+GkGwgBoX+b+la0Q546XYV7hzPA==
X-Received: by 2002:a17:906:32da:: with SMTP id k26mr3251291ejk.483.1615377888288;
        Wed, 10 Mar 2021 04:04:48 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:48 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 08/12] net: enetc: simplify callers of enetc_rxbd_next
Date:   Wed, 10 Mar 2021 14:03:47 +0200
Message-Id: <20210310120351.542292-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we iterate through the BDs in the RX ring, the software producer
index (which is already passed by value to enetc_rxbd_next) lags behind,
and we end up with this funny looking "++i == rx_ring->bd_count" check
so that we drag it after us.

Let's pass the software producer index "i" by reference, so that
enetc_rxbd_next can increment it by itself (mod rx_ring->bd_count),
especially since enetc_rxbd_next has to increment the index anyway.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 21 +++++-------------
 drivers/net/ethernet/freescale/enetc/enetc.h | 23 +++++++++++++-------
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index f92d29b62bae..3b04d7596d80 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -483,13 +483,8 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
 		/* clear 'R" as well */
 		rxbd->r.lstatus = 0;
 
-		rxbd = enetc_rxbd_next(rx_ring, rxbd, i);
-		rx_swbd++;
-		i++;
-		if (unlikely(i == rx_ring->bd_count)) {
-			i = 0;
-			rx_swbd = rx_ring->rx_swbd;
-		}
+		enetc_rxbd_next(rx_ring, &rxbd, &i);
+		rx_swbd = &rx_ring->rx_swbd[i];
 	}
 
 	if (likely(j)) {
@@ -704,9 +699,7 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		cleaned_cnt++;
 
-		rxbd = enetc_rxbd_next(rx_ring, rxbd, i);
-		if (unlikely(++i == rx_ring->bd_count))
-			i = 0;
+		enetc_rxbd_next(rx_ring, &rxbd, &i);
 
 		if (unlikely(bd_status &
 			     ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))) {
@@ -715,9 +708,7 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 				dma_rmb();
 				bd_status = le32_to_cpu(rxbd->r.lstatus);
 
-				rxbd = enetc_rxbd_next(rx_ring, rxbd, i);
-				if (unlikely(++i == rx_ring->bd_count))
-					i = 0;
+				enetc_rxbd_next(rx_ring, &rxbd, &i);
 			}
 
 			rx_ring->ndev->stats.rx_dropped++;
@@ -740,9 +731,7 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 			cleaned_cnt++;
 
-			rxbd = enetc_rxbd_next(rx_ring, rxbd, i);
-			if (unlikely(++i == rx_ring->bd_count))
-				i = 0;
+			enetc_rxbd_next(rx_ring, &rxbd, &i);
 		}
 
 		rx_byte_cnt += skb->len;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index af8b8be114bd..30b9ad550d7b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -121,19 +121,26 @@ static inline union enetc_rx_bd *enetc_rxbd(struct enetc_bdr *rx_ring, int i)
 	return &(((union enetc_rx_bd *)rx_ring->bd_base)[hw_idx]);
 }
 
-static inline union enetc_rx_bd *enetc_rxbd_next(struct enetc_bdr *rx_ring,
-						 union enetc_rx_bd *rxbd,
-						 int i)
+static inline void enetc_rxbd_next(struct enetc_bdr *rx_ring,
+				   union enetc_rx_bd **old_rxbd, int *old_index)
 {
-	rxbd++;
+	union enetc_rx_bd *new_rxbd = *old_rxbd;
+	int new_index = *old_index;
+
+	new_rxbd++;
+
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	if (rx_ring->ext_en)
-		rxbd++;
+		new_rxbd++;
 #endif
-	if (unlikely(++i == rx_ring->bd_count))
-		rxbd = rx_ring->bd_base;
 
-	return rxbd;
+	if (unlikely(++new_index == rx_ring->bd_count)) {
+		new_rxbd = rx_ring->bd_base;
+		new_index = 0;
+	}
+
+	*old_rxbd = new_rxbd;
+	*old_index = new_index;
 }
 
 static inline union enetc_rx_bd *enetc_rxbd_ext(union enetc_rx_bd *rxbd)
-- 
2.25.1

