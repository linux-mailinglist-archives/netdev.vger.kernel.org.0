Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41D7324FCB
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhBYMUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhBYMTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:19:40 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E708BC061786
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:58 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id d13so1553667edp.4
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=32CvGTFCyhyxPOPb27peakSTgH6yE19KtOt/HWGcps8=;
        b=rG1oqNmkhkBaRLITx/8V2aXkpL8fWBTRkTogdSoYcuGZv6swKr7GIqpiFFXSLh8XLE
         W7WtyblkOfOxzrf251nyUtdGD169zkUxwx+vjSxGiuV9olWXyOkUsIwswb08hscxYJnA
         GUTYs3Qi8FG9VGkz5P1FKn/6kXAX/FQLXrtjLZ+OzXY8ca7PO4ewwKv+XLK2EfexTiP4
         db2cgiKyBpI+PJfRMWXer3nIiM71n8E9f1MtmeuNAlJIhkaRcJIWqGyQFL0OqGfh4U0G
         1Ja0MweGX1gnXvSeF0iMVBYBseOne5PqUHH6t4dhCmq8T91acuwq2APmingfggD+FB5U
         JrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=32CvGTFCyhyxPOPb27peakSTgH6yE19KtOt/HWGcps8=;
        b=CSFJy7nvY0+fhMP7IOYEaWofg8du/vWOP0poPvsNT5hKQ0xyupY2Q/tIegVxoSrjB4
         IDg6YTQerT4WCotplSdySFRtPO8oIEn/yx3eC8NIri69+pzaVYGanp0s/K2424Au6vs9
         jUA7EUeQIts2F9TdeBMdRT7m+SUILyz74vvU4/inh60G8vy3URGoQ9b2TtY0+PD+CXbt
         /xyEr0Se9kcIau2k8zvLaIaqNYs2JRUuZP2/j+Xy7ayrbLmPwNPRVLXia/CiFssO46Kk
         fOJ1Q8Npvyi72Jg4X12zwQXrnsEr16crtN8MwnC8yFENwxEyBK+Iocy0c/RhKIQ+vzPz
         w97Q==
X-Gm-Message-State: AOAM532A6YCc9Ik81Fu3HaJ94AE+lGahRQEBSTWINdaIGDm0p0OtHeC0
        /ZDJ4WzXcLiIkwRrcpGnQVI=
X-Google-Smtp-Source: ABdhPJz14ReY5r5JEjFDXqyGCSWvsmiGFxQN9rwOfaVkvjpNraMGYEiaUW3tVLLad6qnnAMPApol/w==
X-Received: by 2002:a05:6402:430c:: with SMTP id m12mr2615701edc.299.1614255537662;
        Thu, 25 Feb 2021 04:18:57 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id x25sm3420925edv.65.2021.02.25.04.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 04:18:57 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 3/6] net: enetc: take the MDIO lock only once per NAPI poll cycle
Date:   Thu, 25 Feb 2021 14:18:32 +0200
Message-Id: <20210225121835.3864036-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225121835.3864036-1-olteanv@gmail.com>
References: <20210225121835.3864036-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The workaround for the ENETC MDIO erratum caused a performance
degradation of 82 Kpps (seen with IP forwarding of two 1Gbps streams of
64B packets). This is due to excessive locking and unlocking in the fast
path, which can be avoided.

By taking the MDIO read-side lock only once per NAPI poll cycle, we are
able to regain 54 Kpps (65%) of the performance hit. The rest of the
performance degradation comes from the TX data path, but unfortunately
it doesn't look like we can optimize that away easily, even with
netdev_xmit_more(), there just isn't any skb batching done, to help with
taking the MDIO lock less often than once per packet.

Fixes: fd5736bf9f23 ("enetc: Workaround for MDIO register access issue")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/freescale/enetc/enetc.c  | 31 ++++++-------------
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  2 ++
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 43f0fae30080..eebe08a99270 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -281,6 +281,8 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	int work_done;
 	int i;
 
+	enetc_lock_mdio();
+
 	for (i = 0; i < v->count_tx_rings; i++)
 		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
 			complete = false;
@@ -291,8 +293,10 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	if (work_done)
 		v->rx_napi_work = true;
 
-	if (!complete)
+	if (!complete) {
+		enetc_unlock_mdio();
 		return budget;
+	}
 
 	napi_complete_done(napi, work_done);
 
@@ -301,8 +305,6 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 
 	v->rx_napi_work = false;
 
-	enetc_lock_mdio();
-
 	/* enable interrupts */
 	enetc_wr_reg_hot(v->rbier, ENETC_RBIER_RXTIE);
 
@@ -327,8 +329,8 @@ static void enetc_get_tx_tstamp(struct enetc_hw *hw, union enetc_tx_bd *txbd,
 {
 	u32 lo, hi, tstamp_lo;
 
-	lo = enetc_rd(hw, ENETC_SICTR0);
-	hi = enetc_rd(hw, ENETC_SICTR1);
+	lo = enetc_rd_hot(hw, ENETC_SICTR0);
+	hi = enetc_rd_hot(hw, ENETC_SICTR1);
 	tstamp_lo = le32_to_cpu(txbd->wb.tstamp);
 	if (lo <= tstamp_lo)
 		hi -= 1;
@@ -358,9 +360,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 	i = tx_ring->next_to_clean;
 	tx_swbd = &tx_ring->tx_swbd[i];
 
-	enetc_lock_mdio();
 	bds_to_clean = enetc_bd_ready_count(tx_ring, i);
-	enetc_unlock_mdio();
 
 	do_tstamp = false;
 
@@ -403,8 +403,6 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 			tx_swbd = tx_ring->tx_swbd;
 		}
 
-		enetc_lock_mdio();
-
 		/* BD iteration loop end */
 		if (is_eof) {
 			tx_frm_cnt++;
@@ -415,8 +413,6 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 
 		if (unlikely(!bds_to_clean))
 			bds_to_clean = enetc_bd_ready_count(tx_ring, i);
-
-		enetc_unlock_mdio();
 	}
 
 	tx_ring->next_to_clean = i;
@@ -660,8 +656,6 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		u32 bd_status;
 		u16 size;
 
-		enetc_lock_mdio();
-
 		if (cleaned_cnt >= ENETC_RXBD_BUNDLE) {
 			int count = enetc_refill_rx_ring(rx_ring, cleaned_cnt);
 
@@ -672,19 +666,15 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
-		if (!bd_status) {
-			enetc_unlock_mdio();
+		if (!bd_status)
 			break;
-		}
 
 		enetc_wr_reg_hot(rx_ring->idr, BIT(rx_ring->index));
 		dma_rmb(); /* for reading other rxbd fields */
 		size = le16_to_cpu(rxbd->r.buf_len);
 		skb = enetc_map_rx_buff_to_skb(rx_ring, i, size);
-		if (!skb) {
-			enetc_unlock_mdio();
+		if (!skb)
 			break;
-		}
 
 		enetc_get_offloads(rx_ring, rxbd, skb);
 
@@ -696,7 +686,6 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		if (unlikely(bd_status &
 			     ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))) {
-			enetc_unlock_mdio();
 			dev_kfree_skb(skb);
 			while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
 				dma_rmb();
@@ -736,8 +725,6 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		enetc_process_skb(rx_ring, skb);
 
-		enetc_unlock_mdio();
-
 		napi_gro_receive(napi, skb);
 
 		rx_frm_cnt++;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index c71fe8d751d5..8b54562f5da6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -453,6 +453,8 @@ static inline u64 _enetc_rd_reg64_wa(void __iomem *reg)
 #define enetc_wr_reg(reg, val)		_enetc_wr_reg_wa((reg), (val))
 #define enetc_rd(hw, off)		enetc_rd_reg((hw)->reg + (off))
 #define enetc_wr(hw, off, val)		enetc_wr_reg((hw)->reg + (off), val)
+#define enetc_rd_hot(hw, off)		enetc_rd_reg_hot((hw)->reg + (off))
+#define enetc_wr_hot(hw, off, val)	enetc_wr_reg_hot((hw)->reg + (off), val)
 #define enetc_rd64(hw, off)		_enetc_rd_reg64_wa((hw)->reg + (off))
 /* port register accessors - PF only */
 #define enetc_port_rd(hw, off)		enetc_rd_reg((hw)->port + (off))
-- 
2.25.1

