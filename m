Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D1ED995B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394309AbfJPSlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:41:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44359 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbfJPSlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:41:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id z9so29222060wrl.11
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 11:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7JIytsXwhhFqsqyiZQPDkEpzvI2WmdzotFJ/OGJTvsI=;
        b=DWVAQfgjHl0YMcUUsJafgXuvyHLZ3XhTD/pyvC7iIZk/maCZgcIwPm9iXTYiFwDsTG
         cfGtl7uvh2iYW34qsNZSOkqSiQNcyvci6RNHvW9J/lVUMRUnEmXFDPSUhcmaIm2xUHje
         GiJTbtcoBDPSOxWkA25oDjBVmkdcks9nxBGeMhUtWtOf7vlqIXx/3/IEr9rhHKM3KQ04
         QSnsAHi54mfwHLBaKgQhww3YzXfdBQYwdBvGPJuexc7avyor4yL5O9gvHt6UrAEXzZih
         MKasEEw1fzotW1g//AVGiW9ZSmHhd12sTU/NwKcJlRLOzo9gna0QaZqa0fSwF6nHIw3N
         uO5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7JIytsXwhhFqsqyiZQPDkEpzvI2WmdzotFJ/OGJTvsI=;
        b=eCwcv21D1Zm6CevQes9kq/zixUa2su65oyYYRtuuM0mac1RrjXpM007dl2xlwrqPn5
         QbxOBBWY4BE762MEQUjtAKwZ1rwbh3oI/fE9hTr5rswXlDoBWWPZ+7g4jfo9kFgJFWPA
         37Eeo3+q1HIBw8YXEKmzLUXLfHQBoLrFzAO/iKaF5sBE8w8QhofqTV0ed4xUCBmMY8bW
         e/o2xW4/z+SblDOOaVIOYEscOaeq6jkOdCXITJR0IJvZhW5647ZGPgXSIS7vv99EF3FI
         B8cdVypp3m0ADbwIXNndwqojvJWVTBDHrnNN7ZdZ4GYzx7asKzzhbIBk1uNkaUkRTdF3
         Sceg==
X-Gm-Message-State: APjAAAXYds1agWSjP/Mo4/tjz55ZYCLiczEEAYfFSX8/UB81bPxJmfCs
        G1lZef416InKZAHoP7SQgt0=
X-Google-Smtp-Source: APXvYqyt9nyVRTDq0MG6+0syu3jPSyIK8EQfv2PdsaXlS/u+DXgrn0XzyCqIQRypAbCQ4ZVO8ZFFlg==
X-Received: by 2002:a5d:4748:: with SMTP id o8mr4093469wrs.239.1571251279238;
        Wed, 16 Oct 2019 11:41:19 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id t10sm3317138wrw.23.2019.10.16.11.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 11:41:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next] net: dsa: sja1105: Switch to hardware operations for PTP
Date:   Wed, 16 Oct 2019 21:41:02 +0300
Message-Id: <20191016184102.1335-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjusting the hardware clock (PTPCLKVAL, PTPCLKADD, PTPCLKRATE) is a
requirement for the auxiliary PTP functionality of the switch
(TTEthernet, PPS input, PPS output).

Therefore we need to switch to using these registers to keep a
synchronized time in hardware, instead of the timecounter/cyclecounter
implementation, which is reliant on the free-running PTPTSCLK.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
This patch deletes the timecounter/cyclecounter implementation of a
free-running PHC and replaces it with actual hardware corrections of the
PTP timestamping clock.

It has been broken out of the "tc-taprio offload for SJA1105 DSA"
series:
https://lore.kernel.org/netdev/20190902162544.24613-4-olteanv@gmail.com/
As such I have marked it as v2.

Changes in v2:
- Rebased on top of the new SPI API: sja1105_xfer_u32, sja1105_xfer_u64,
  sja1105_xfer_buf.
- Rebased on top of the PTP structures migration from sja1105_private to
  sja1105_ptp_data.
- Renamed ptpclk to ptpclkval, which is the register's name in
  UM10944.pdf.
- Do not discard SPI errors in sja1105_ptpclkval_read.
- Changed the 2nd paragraph of the commit message.

 drivers/net/dsa/sja1105/sja1105.h     |   3 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c | 218 +++++++++++++-------------
 drivers/net/dsa/sja1105/sja1105_ptp.h |  25 ++-
 drivers/net/dsa/sja1105/sja1105_spi.c |   6 +-
 4 files changed, 128 insertions(+), 124 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 0ef97a916707..397a49da35e4 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -33,9 +33,8 @@ struct sja1105_regs {
 	u64 config;
 	u64 rmii_pll1;
 	u64 ptp_control;
-	u64 ptpclk;
+	u64 ptpclkval;
 	u64 ptpclkrate;
-	u64 ptptsclk;
 	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
 	u64 pad_mii_id[SJA1105_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index b43096063cf4..783100397f8a 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -13,24 +13,6 @@
 #define SJA1105_MAX_ADJ_PPB		32000000
 #define SJA1105_SIZE_PTP_CMD		4
 
-/* Timestamps are in units of 8 ns clock ticks (equivalent to a fixed
- * 125 MHz clock) so the scale factor (MULT / SHIFT) needs to be 8.
- * Furthermore, wisely pick SHIFT as 28 bits, which translates
- * MULT into 2^31 (0x80000000).  This is the same value around which
- * the hardware PTPCLKRATE is centered, so the same ppb conversion
- * arithmetic can be reused.
- */
-#define SJA1105_CC_SHIFT		28
-#define SJA1105_CC_MULT			(8 << SJA1105_CC_SHIFT)
-
-/* Having 33 bits of cycle counter left until a 64-bit overflow during delta
- * conversion, we multiply this by the 8 ns counter resolution and arrive at
- * a comfortable 68.71 second refresh interval until the delta would cause
- * an integer overflow, in absence of any other readout.
- * Approximate to 1 minute.
- */
-#define SJA1105_REFRESH_INTERVAL	(HZ * 60)
-
 /*            This range is actually +/- SJA1105_MAX_ADJ_PPB
  *            divided by 1000 (ppb -> ppm) and with a 16-bit
  *            "fractional" part (actually fixed point).
@@ -41,7 +23,7 @@
  *
  * This forgoes a "ppb" numeric representation (up to NSEC_PER_SEC)
  * and defines the scaling factor between scaled_ppm and the actual
- * frequency adjustments (both cycle counter and hardware).
+ * frequency adjustments of the PHC.
  *
  *   ptpclkrate = scaled_ppm * 2^31 / (10^6 * 2^16)
  *   simplifies to
@@ -49,13 +31,15 @@
  */
 #define SJA1105_CC_MULT_NUM		(1 << 9)
 #define SJA1105_CC_MULT_DEM		15625
+#define SJA1105_CC_MULT			0x80000000
+
+enum sja1105_ptp_clk_mode {
+	PTP_ADD_MODE = 1,
+	PTP_SET_MODE = 0,
+};
 
 #define ptp_caps_to_data(d) \
 		container_of((d), struct sja1105_ptp_data, caps)
-#define cc_to_ptp_data(d) \
-		container_of((d), struct sja1105_ptp_data, tstamp_cc)
-#define dw_to_ptp_data(d) \
-		container_of((d), struct sja1105_ptp_data, refresh_work)
 #define ptp_data_to_sja1105(d) \
 		container_of((d), struct sja1105_private, ptp_data)
 
@@ -220,6 +204,8 @@ int sja1105et_ptp_cmd(const struct dsa_switch *ds,
 
 	sja1105_pack(buf, &valid,           31, 31, size);
 	sja1105_pack(buf, &cmd->resptp,      2,  2, size);
+	sja1105_pack(buf, &cmd->corrclk4ts,  1,  1, size);
+	sja1105_pack(buf, &cmd->ptpclkadd,   0,  0, size);
 
 	return sja1105_xfer_buf(priv, SPI_WRITE, regs->ptp_control, buf,
 				SJA1105_SIZE_PTP_CMD);
@@ -237,6 +223,8 @@ int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds,
 
 	sja1105_pack(buf, &valid,           31, 31, size);
 	sja1105_pack(buf, &cmd->resptp,      3,  3, size);
+	sja1105_pack(buf, &cmd->corrclk4ts,  2,  2, size);
+	sja1105_pack(buf, &cmd->ptpclkadd,   0,  0, size);
 
 	return sja1105_xfer_buf(priv, SPI_WRITE, regs->ptp_control, buf,
 				SJA1105_SIZE_PTP_CMD);
@@ -346,6 +334,22 @@ static int sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts)
 	return 0;
 }
 
+/* Caller must hold ptp_data->lock */
+static int sja1105_ptpclkval_read(struct sja1105_private *priv, u64 *ticks)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+
+	return sja1105_xfer_u64(priv, SPI_READ, regs->ptpclkval, ticks);
+}
+
+/* Caller must hold ptp_data->lock */
+static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 ticks)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+
+	return sja1105_xfer_u64(priv, SPI_WRITE, regs->ptpclkval, &ticks);
+}
+
 #define rxtstamp_to_tagger(d) \
 	container_of((d), struct sja1105_tagger_data, rxtstamp_work)
 #define tagger_to_sja1105(d) \
@@ -363,17 +367,22 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 
 	while ((skb = skb_dequeue(&tagger_data->skb_rxtstamp_queue)) != NULL) {
 		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
-		u64 now, ts;
+		u64 ticks, ts;
+		int rc;
 
-		now = ptp_data->tstamp_cc.read(&ptp_data->tstamp_cc);
+		rc = sja1105_ptpclkval_read(priv, &ticks);
+		if (rc < 0) {
+			dev_err(ds->dev, "Failed to read PTP clock: %d\n", rc);
+			kfree_skb(skb);
+			continue;
+		}
 
 		*shwt = (struct skb_shared_hwtstamps) {0};
 
 		ts = SJA1105_SKB_CB(skb)->meta_tstamp;
-		ts = sja1105_tstamp_reconstruct(ds, now, ts);
-		ts = timecounter_cyc2time(&ptp_data->tstamp_tc, ts);
+		ts = sja1105_tstamp_reconstruct(ds, ticks, ts);
 
-		shwt->hwtstamp = ns_to_ktime(ts);
+		shwt->hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(ts));
 		netif_rx_ni(skb);
 	}
 
@@ -427,9 +436,6 @@ int sja1105_ptp_reset(struct dsa_switch *ds)
 	dev_dbg(ds->dev, "Resetting PTP clock\n");
 	rc = priv->info->ptp_cmd(ds, &cmd);
 
-	timecounter_init(&ptp_data->tstamp_tc, &ptp_data->tstamp_cc,
-			 ktime_to_ns(ktime_get_real()));
-
 	mutex_unlock(&ptp_data->lock);
 
 	return rc;
@@ -439,112 +445,106 @@ static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
 			       struct timespec64 *ts)
 {
 	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
-	u64 ns;
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
+	u64 ticks = 0;
+	int rc;
 
 	mutex_lock(&ptp_data->lock);
-	ns = timecounter_read(&ptp_data->tstamp_tc);
+
+	rc = sja1105_ptpclkval_read(priv, &ticks);
+	*ts = ns_to_timespec64(sja1105_ticks_to_ns(ticks));
+
 	mutex_unlock(&ptp_data->lock);
 
-	*ts = ns_to_timespec64(ns);
+	return rc;
+}
 
-	return 0;
+/* Caller must hold ptp_data->lock */
+static int sja1105_ptp_mode_set(struct sja1105_private *priv,
+				enum sja1105_ptp_clk_mode mode)
+{
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+
+	if (ptp_data->cmd.ptpclkadd == mode)
+		return 0;
+
+	ptp_data->cmd.ptpclkadd = mode;
+
+	return priv->info->ptp_cmd(priv->ds, &ptp_data->cmd);
 }
 
+/* Write to PTPCLKVAL while PTPCLKADD is 0 */
 static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
 			       const struct timespec64 *ts)
 {
 	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
-	u64 ns = timespec64_to_ns(ts);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
+	u64 ticks = ns_to_sja1105_ticks(timespec64_to_ns(ts));
+	int rc;
 
 	mutex_lock(&ptp_data->lock);
-	timecounter_init(&ptp_data->tstamp_tc, &ptp_data->tstamp_cc, ns);
+
+	rc = sja1105_ptp_mode_set(priv, PTP_SET_MODE);
+	if (rc < 0) {
+		dev_err(priv->ds->dev, "Failed to put PTPCLK in set mode\n");
+		goto out;
+	}
+
+	rc = sja1105_ptpclkval_write(priv, ticks);
+out:
 	mutex_unlock(&ptp_data->lock);
 
-	return 0;
+	return rc;
 }
 
 static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
+	const struct sja1105_regs *regs = priv->info->regs;
+	u32 clkrate32;
 	s64 clkrate;
+	int rc;
 
 	clkrate = (s64)scaled_ppm * SJA1105_CC_MULT_NUM;
 	clkrate = div_s64(clkrate, SJA1105_CC_MULT_DEM);
 
-	mutex_lock(&ptp_data->lock);
+	/* Take a +/- value and re-center it around 2^31. */
+	clkrate = SJA1105_CC_MULT + clkrate;
+	WARN_ON(abs(clkrate) >= GENMASK_ULL(31, 0));
+	clkrate32 = clkrate;
 
-	/* Force a readout to update the timer *before* changing its frequency.
-	 *
-	 * This way, its corrected time curve can at all times be modeled
-	 * as a linear "A * x + B" function, where:
-	 *
-	 * - B are past frequency adjustments and offset shifts, all
-	 *   accumulated into the cycle_last variable.
-	 *
-	 * - A is the new frequency adjustments we're just about to set.
-	 *
-	 * Reading now makes B accumulate the correct amount of time,
-	 * corrected at the old rate, before changing it.
-	 *
-	 * Hardware timestamps then become simple points on the curve and
-	 * are approximated using the above function.  This is still better
-	 * than letting the switch take the timestamps using the hardware
-	 * rate-corrected clock (PTPCLKVAL) - the comparison in this case would
-	 * be that we're shifting the ruler at the same time as we're taking
-	 * measurements with it.
-	 *
-	 * The disadvantage is that it's possible to receive timestamps when
-	 * a frequency adjustment took place in the near past.
-	 * In this case they will be approximated using the new ppb value
-	 * instead of a compound function made of two segments (one at the old
-	 * and the other at the new rate) - introducing some inaccuracy.
-	 */
-	timecounter_read(&ptp_data->tstamp_tc);
+	mutex_lock(&ptp_data->lock);
 
-	ptp_data->tstamp_cc.mult = SJA1105_CC_MULT + clkrate;
+	rc = sja1105_xfer_u32(priv, SPI_WRITE, regs->ptpclkrate, &clkrate32);
 
 	mutex_unlock(&ptp_data->lock);
 
-	return 0;
+	return rc;
 }
 
+/* Write to PTPCLKVAL while PTPCLKADD is 1 */
 static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
-
-	mutex_lock(&ptp_data->lock);
-	timecounter_adjtime(&ptp_data->tstamp_tc, delta);
-	mutex_unlock(&ptp_data->lock);
-
-	return 0;
-}
-
-static u64 sja1105_ptptsclk_read(const struct cyclecounter *cc)
-{
-	struct sja1105_ptp_data *ptp_data = cc_to_ptp_data(cc);
 	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
-	const struct sja1105_regs *regs = priv->info->regs;
-	u64 ptptsclk = 0;
+	s64 ticks = ns_to_sja1105_ticks(delta);
 	int rc;
 
-	rc = sja1105_xfer_u64(priv, SPI_READ, regs->ptptsclk, &ptptsclk);
-	if (rc < 0)
-		dev_err_ratelimited(priv->ds->dev,
-				    "failed to read ptp cycle counter: %d\n",
-				    rc);
-	return ptptsclk;
-}
+	mutex_lock(&ptp_data->lock);
 
-static void sja1105_ptp_overflow_check(struct work_struct *work)
-{
-	struct delayed_work *dw = to_delayed_work(work);
-	struct sja1105_ptp_data *ptp_data = dw_to_ptp_data(dw);
-	struct timespec64 ts;
+	rc = sja1105_ptp_mode_set(priv, PTP_ADD_MODE);
+	if (rc < 0) {
+		dev_err(priv->ds->dev, "Failed to put PTPCLK in add mode\n");
+		goto out;
+	}
 
-	sja1105_ptp_gettime(&ptp_data->caps, &ts);
+	rc = sja1105_ptpclkval_write(priv, ticks);
 
-	schedule_delayed_work(&ptp_data->refresh_work,
-			      SJA1105_REFRESH_INTERVAL);
+out:
+	mutex_unlock(&ptp_data->lock);
+
+	return rc;
 }
 
 int sja1105_ptp_clock_register(struct dsa_switch *ds)
@@ -553,13 +553,6 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
-	/* Set up the cycle counter */
-	ptp_data->tstamp_cc = (struct cyclecounter) {
-		.read		= sja1105_ptptsclk_read,
-		.mask		= CYCLECOUNTER_MASK(64),
-		.shift		= SJA1105_CC_SHIFT,
-		.mult		= SJA1105_CC_MULT,
-	};
 	ptp_data->caps = (struct ptp_clock_info) {
 		.owner		= THIS_MODULE,
 		.name		= "SJA1105 PHC",
@@ -578,8 +571,8 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 	if (IS_ERR_OR_NULL(ptp_data->clock))
 		return PTR_ERR(ptp_data->clock);
 
-	INIT_DELAYED_WORK(&ptp_data->refresh_work, sja1105_ptp_overflow_check);
-	schedule_delayed_work(&ptp_data->refresh_work, SJA1105_REFRESH_INTERVAL);
+	ptp_data->cmd.corrclk4ts = true;
+	ptp_data->cmd.ptpclkadd = PTP_SET_MODE;
 
 	return sja1105_ptp_reset(ds);
 }
@@ -594,7 +587,6 @@ void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 
 	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
 	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
-	cancel_delayed_work_sync(&ptp_data->refresh_work);
 	ptp_clock_unregister(ptp_data->clock);
 	ptp_data->clock = NULL;
 }
@@ -605,14 +597,19 @@ void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct skb_shared_hwtstamps shwt = {0};
-	u64 now, ts;
+	u64 ticks, ts;
 	int rc;
 
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
 	mutex_lock(&ptp_data->lock);
 
-	now = ptp_data->tstamp_cc.read(&ptp_data->tstamp_cc);
+	rc = sja1105_ptpclkval_read(priv, &ticks);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to read PTP clock: %d\n", rc);
+		kfree_skb(skb);
+		goto out;
+	}
 
 	rc = sja1105_ptpegr_ts_poll(ds, slot, &ts);
 	if (rc < 0) {
@@ -621,10 +618,9 @@ void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
 		goto out;
 	}
 
-	ts = sja1105_tstamp_reconstruct(ds, now, ts);
-	ts = timecounter_cyc2time(&ptp_data->tstamp_tc, ts);
+	ts = sja1105_tstamp_reconstruct(ds, ticks, ts);
 
-	shwt.hwtstamp = ns_to_ktime(ts);
+	shwt.hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(ts));
 	skb_complete_tx_timestamp(skb, &shwt);
 
 out:
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 507107ffd6a3..ea80e479dc1c 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -6,21 +6,32 @@
 
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
 
+/* Timestamps are in units of 8 ns clock ticks (equivalent to
+ * a fixed 125 MHz clock).
+ */
+#define SJA1105_TICK_NS			8
+
+static inline s64 ns_to_sja1105_ticks(s64 ns)
+{
+	return ns / SJA1105_TICK_NS;
+}
+
+static inline s64 sja1105_ticks_to_ns(s64 ticks)
+{
+	return ticks * SJA1105_TICK_NS;
+}
+
 struct sja1105_ptp_cmd {
 	u64 resptp;		/* reset */
+	u64 corrclk4ts;		/* use the corrected clock for timestamps */
+	u64 ptpclkadd;		/* enum sja1105_ptp_clk_mode */
 };
 
 struct sja1105_ptp_data {
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
 	struct sja1105_ptp_cmd cmd;
-	/* The cycle counter translates the PTP timestamps (based on
-	 * a free-running counter) into a software time domain.
-	 */
-	struct cyclecounter tstamp_cc;
-	struct timecounter tstamp_tc;
-	struct delayed_work refresh_work;
-	/* Serializes all operations on the cycle counter */
+	/* Serializes all operations on the PTP hardware clock */
 	struct mutex lock;
 };
 
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index e25724d99594..ed02410a9366 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -516,9 +516,8 @@ static struct sja1105_regs sja1105et_regs = {
 	.rmii_ext_tx_clk = {0x100018, 0x10001F, 0x100026, 0x10002D, 0x100034},
 	.ptpegr_ts = {0xC0, 0xC2, 0xC4, 0xC6, 0xC8},
 	.ptp_control = 0x17,
-	.ptpclk = 0x18, /* Spans 0x18 to 0x19 */
+	.ptpclkval = 0x18, /* Spans 0x18 to 0x19 */
 	.ptpclkrate = 0x1A,
-	.ptptsclk = 0x1B, /* Spans 0x1B to 0x1C */
 };
 
 static struct sja1105_regs sja1105pqrs_regs = {
@@ -547,9 +546,8 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.qlevel = {0x604, 0x614, 0x624, 0x634, 0x644},
 	.ptpegr_ts = {0xC0, 0xC4, 0xC8, 0xCC, 0xD0},
 	.ptp_control = 0x18,
-	.ptpclk = 0x19,
+	.ptpclkval = 0x19,
 	.ptpclkrate = 0x1B,
-	.ptptsclk = 0x1C,
 };
 
 struct sja1105_info sja1105e_info = {
-- 
2.17.1

