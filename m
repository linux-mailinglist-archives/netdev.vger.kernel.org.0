Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D73CA2B9B
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfH3Aq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:46:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54772 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfH3Aqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:46:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id k2so4056879wmj.4
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hGWyi0Od8Y1ErBJF0hpItNPFaZTbueW2FEapaslMToY=;
        b=fuU9YGrJfPd8iGLL5RjHtx856Ys9usHh6VUm1TVXbmU+W4ZDPRp9m/vjcyc8OVxiOA
         5ZNs2v3/WK2L6r+cFIaJAMFYzPvvbRi2vDt84Ih+MIqC3zMBPCXNIjrfsxAAZdYXfv7Y
         GmN1Tox3QX8KJno8MlSPKQaztfE15IA7hAYrn8y3/67lp1k1M5cE7D116/HdDsDO7sa8
         bTnnJI594u74bSR0GJkDhy5blCPDKwwrZW8oPBCJiJ1qNZsTWmt90vZfxfIpZx+xyiCt
         mTjpV4n5pVLN/S7eyGTn95tkIw+jtGReDGP+AXst4SvwCJqT2gp7ZfPFZJf0+IkdI5kH
         JvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hGWyi0Od8Y1ErBJF0hpItNPFaZTbueW2FEapaslMToY=;
        b=O63azhKRJat5U3ko5lo7tat3SAp1a5gxnLQrc02kEf/3cEGgOPZxCPlJolCeNcQUp4
         gUfw0GZaKHP6rkLasHQvelxKMgnJC8FJIufAfKEnj25WY8h19QkUX4TNzCHc6RjjDs5e
         +BzDOGgX84D1o9tVD30xAUbIjNCocFyqG5f+PmcvvQw3AUdlh7W3wsyz3+ha4Cn5zz19
         phFHvbTO2HQsoSszaxNUI/0+bNGccWXfBcSM/Y1wM55KYHpEvbgOn57QV2vbhjVxeAFQ
         dByygtwvr4CHITIHkYNZ92CG8/ft3FSUbrq5V0y13Hb91oQifl1b9I5Tsj0/POKlGnNl
         vP8A==
X-Gm-Message-State: APjAAAUmjXi2QwjPdvXaBqrjcjZnag58M4lif0ysKtFUjGDOZCt3BaO/
        MNUsr8Z2IHJZ/gGEav8PBktfXeaBo/c=
X-Google-Smtp-Source: APXvYqypM85EdovMGJ94o2esm0rz8eyzZntgLZQuMYUg1ShgX+FLMxZq27mZR3gpe62DmQGy8y2vNw==
X-Received: by 2002:a7b:c952:: with SMTP id i18mr15473194wml.44.1567126011893;
        Thu, 29 Aug 2019 17:46:51 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:46:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 03/15] net: dsa: sja1105: Switch to hardware operations for PTP
Date:   Fri, 30 Aug 2019 03:46:23 +0300
Message-Id: <20190830004635.24863-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjusting the hardware clock (PTPCLKVAL, PTPCLKADD, PTPCLKRATE) is a
requirement for the auxiliary PTP functionality of the switch
(TTEthernet, PPS input, PPS output).

Now that the sync precision issues have been identified (and fixed in
the spi-fsl-dspi driver), we can get rid of the timecounter/cyclecounter
implementation, which is reliant on the free-running PTPTSCLK.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  16 +--
 drivers/net/dsa/sja1105/sja1105_main.c |  18 ++-
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 181 ++++++++++++-------------
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  22 +++
 drivers/net/dsa/sja1105/sja1105_spi.c  |   2 -
 5 files changed, 122 insertions(+), 117 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d8a92646e80a..e4955a025e46 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -32,7 +32,6 @@ struct sja1105_regs {
 	u64 ptp_control;
 	u64 ptpclk;
 	u64 ptpclkrate;
-	u64 ptptsclk;
 	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
 	u64 pad_mii_id[SJA1105_NUM_PORTS];
@@ -50,8 +49,15 @@ struct sja1105_regs {
 	u64 qlevel[SJA1105_NUM_PORTS];
 };
 
+enum sja1105_ptp_clk_mode {
+	PTP_ADD_MODE = 1,
+	PTP_SET_MODE = 0,
+};
+
 struct sja1105_ptp_cmd {
 	u64 resptp;		/* reset */
+	u64 corrclk4ts;		/* use the corrected clock for timestamps */
+	u64 ptpclkadd;		/* enum sja1105_ptp_clk_mode */
 };
 
 struct sja1105_info {
@@ -96,13 +102,7 @@ struct sja1105_private {
 	struct sja1105_ptp_cmd ptp_cmd;
 	struct ptp_clock_info ptp_caps;
 	struct ptp_clock *clock;
-	/* The cycle counter translates the PTP timestamps (based on
-	 * a free-running counter) into a software time domain.
-	 */
-	struct cyclecounter tstamp_cc;
-	struct timecounter tstamp_tc;
-	struct delayed_work refresh_work;
-	/* Serializes all operations on the cycle counter */
+	/* Serializes all operations on the PTP hardware clock */
 	struct mutex ptp_lock;
 	/* Serializes transmission of management frames so that
 	 * the switch doesn't confuse them with one another.
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d8cff0107ec4..630f7e337fe9 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1813,7 +1813,7 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 	struct skb_shared_hwtstamps shwt = {0};
 	int slot = sp->mgmt_slot;
 	struct sk_buff *clone;
-	u64 now, ts;
+	u64 ticks, ts;
 	int rc;
 
 	/* The tragic fact about the switch having 4x2 slots for installing
@@ -1844,7 +1844,7 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 
 	mutex_lock(&priv->ptp_lock);
 
-	now = priv->tstamp_cc.read(&priv->tstamp_cc);
+	ticks = sja1105_ptpclkval_read(priv);
 
 	rc = sja1105_ptpegr_ts_poll(priv, slot, &ts);
 	if (rc < 0) {
@@ -1853,10 +1853,9 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 		goto out_unlock_ptp;
 	}
 
-	ts = sja1105_tstamp_reconstruct(priv, now, ts);
-	ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
+	ts = sja1105_tstamp_reconstruct(priv, ticks, ts);
 
-	shwt.hwtstamp = ns_to_ktime(ts);
+	shwt.hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(ts));
 	skb_complete_tx_timestamp(clone, &shwt);
 
 out_unlock_ptp:
@@ -1994,11 +1993,11 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 	struct sja1105_tagger_data *data = to_tagger(work);
 	struct sja1105_private *priv = to_sja1105(data);
 	struct sk_buff *skb;
-	u64 now;
+	u64 ticks;
 
 	mutex_lock(&priv->ptp_lock);
 
-	now = priv->tstamp_cc.read(&priv->tstamp_cc);
+	ticks = sja1105_ptpclkval_read(priv);
 
 	while ((skb = skb_dequeue(&data->skb_rxtstamp_queue)) != NULL) {
 		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
@@ -2007,10 +2006,9 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 		*shwt = (struct skb_shared_hwtstamps) {0};
 
 		ts = SJA1105_SKB_CB(skb)->meta_tstamp;
-		ts = sja1105_tstamp_reconstruct(priv, now, ts);
-		ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
+		ts = sja1105_tstamp_reconstruct(priv, ticks, ts);
 
-		shwt->hwtstamp = ns_to_ktime(ts);
+		shwt->hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(ts));
 		netif_rx_ni(skb);
 	}
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 13f9f5799e46..bcdfdda46b9c 100644
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
@@ -49,10 +31,9 @@
  */
 #define SJA1105_CC_MULT_NUM		(1 << 9)
 #define SJA1105_CC_MULT_DEM		15625
+#define SJA1105_CC_MULT			0x80000000
 
 #define ptp_to_sja1105(d) container_of((d), struct sja1105_private, ptp_caps)
-#define cc_to_sja1105(d) container_of((d), struct sja1105_private, tstamp_cc)
-#define dw_to_sja1105(d) container_of((d), struct sja1105_private, refresh_work)
 
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *info)
@@ -86,6 +67,8 @@ int sja1105et_ptp_cmd(const void *ctx, const void *data)
 
 	sja1105_pack(buf, &valid,           31, 31, size);
 	sja1105_pack(buf, &cmd->resptp,      2,  2, size);
+	sja1105_pack(buf, &cmd->corrclk4ts,  1,  1, size);
+	sja1105_pack(buf, &cmd->ptpclkadd,   0,  0, size);
 
 	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
 					   buf, SJA1105_SIZE_PTP_CMD);
@@ -103,6 +86,8 @@ int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
 
 	sja1105_pack(buf, &valid,           31, 31, size);
 	sja1105_pack(buf, &cmd->resptp,      3,  3, size);
+	sja1105_pack(buf, &cmd->corrclk4ts,  2,  2, size);
+	sja1105_pack(buf, &cmd->ptpclkadd,   0,  0, size);
 
 	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
 					   buf, SJA1105_SIZE_PTP_CMD);
@@ -215,17 +200,14 @@ int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
 int sja1105_ptp_reset(struct sja1105_private *priv)
 {
 	struct sja1105_ptp_cmd cmd = priv->ptp_cmd;
-	struct dsa_switch *ds = priv->ds;
 	int rc;
 
 	mutex_lock(&priv->ptp_lock);
 
 	cmd.resptp = 1;
-	dev_dbg(ds->dev, "Resetting PTP clock\n");
-	rc = priv->info->ptp_cmd(priv, &cmd);
 
-	timecounter_init(&priv->tstamp_tc, &priv->tstamp_cc,
-			 ktime_to_ns(ktime_get_real()));
+	dev_dbg(priv->ds->dev, "Resetting PTP clock\n");
+	rc = priv->info->ptp_cmd(priv, &cmd);
 
 	mutex_unlock(&priv->ptp_lock);
 
@@ -236,124 +218,130 @@ static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
 			       struct timespec64 *ts)
 {
 	struct sja1105_private *priv = ptp_to_sja1105(ptp);
-	u64 ns;
+	u64 ticks;
 
 	mutex_lock(&priv->ptp_lock);
-	ns = timecounter_read(&priv->tstamp_tc);
-	mutex_unlock(&priv->ptp_lock);
 
-	*ts = ns_to_timespec64(ns);
+	ticks = sja1105_ptpclkval_read(priv);
+	*ts = ns_to_timespec64(sja1105_ticks_to_ns(ticks));
+
+	mutex_unlock(&priv->ptp_lock);
 
 	return 0;
 }
 
+/* Caller must hold priv->ptp_lock */
+static int sja1105_ptp_mode_set(struct sja1105_private *priv,
+				enum sja1105_ptp_clk_mode mode)
+{
+	if (priv->ptp_cmd.ptpclkadd == mode)
+		return 0;
+
+	priv->ptp_cmd.ptpclkadd = mode;
+
+	return priv->info->ptp_cmd(priv, &priv->ptp_cmd);
+}
+
+/* Caller must hold priv->ptp_lock */
+static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 val)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+
+	return sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclk, &val, 8);
+}
+
+/* Write to PTPCLKVAL while PTPCLKADD is 0 */
 static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
 			       const struct timespec64 *ts)
 {
+	u64 ticks = ns_to_sja1105_ticks(timespec64_to_ns(ts));
 	struct sja1105_private *priv = ptp_to_sja1105(ptp);
-	u64 ns = timespec64_to_ns(ts);
+	int rc;
 
 	mutex_lock(&priv->ptp_lock);
-	timecounter_init(&priv->tstamp_tc, &priv->tstamp_cc, ns);
+
+	rc = sja1105_ptp_mode_set(priv, PTP_SET_MODE);
+	if (rc < 0) {
+		dev_err(priv->ds->dev, "Failed to put PTPCLK in set mode\n");
+		goto out;
+	}
+
+	rc = sja1105_ptpclkval_write(priv, ticks);
+
+out:
 	mutex_unlock(&priv->ptp_lock);
 
-	return 0;
+	return rc;
 }
 
 static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	const struct sja1105_regs *regs = priv->info->regs;
 	s64 clkrate;
+	int rc;
 
 	clkrate = (s64)scaled_ppm * SJA1105_CC_MULT_NUM;
 	clkrate = div_s64(clkrate, SJA1105_CC_MULT_DEM);
 
-	mutex_lock(&priv->ptp_lock);
-
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
-	timecounter_read(&priv->tstamp_tc);
-
-	priv->tstamp_cc.mult = SJA1105_CC_MULT + clkrate;
+	/* Take a +/- value and re-center it around 2^31. */
+	clkrate = SJA1105_CC_MULT + clkrate;
+	clkrate &= GENMASK_ULL(31, 0);
 
-	mutex_unlock(&priv->ptp_lock);
-
-	return 0;
-}
+	mutex_lock(&priv->ptp_lock);
 
-static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
-{
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	rc = sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclkrate,
+				  &clkrate, 4);
 
-	mutex_lock(&priv->ptp_lock);
-	timecounter_adjtime(&priv->tstamp_tc, delta);
 	mutex_unlock(&priv->ptp_lock);
 
-	return 0;
+	return rc;
 }
 
-static u64 sja1105_ptptsclk_read(const struct cyclecounter *cc)
+/* Caller must hold priv->ptp_lock */
+u64 sja1105_ptpclkval_read(struct sja1105_private *priv)
 {
-	struct sja1105_private *priv = cc_to_sja1105(cc);
 	const struct sja1105_regs *regs = priv->info->regs;
-	u64 ptptsclk = 0;
+	u64 ptpclkval = 0;
 	int rc;
 
-	rc = sja1105_spi_send_int(priv, SPI_READ, regs->ptptsclk,
-				  &ptptsclk, 8);
+	rc = sja1105_spi_send_int(priv, SPI_READ, regs->ptpclk,
+				  &ptpclkval, 8);
 	if (rc < 0)
 		dev_err_ratelimited(priv->ds->dev,
-				    "failed to read ptp cycle counter: %d\n",
+				    "failed to read ptp time: %d\n",
 				    rc);
-	return ptptsclk;
+
+	return ptpclkval;
 }
 
-static void sja1105_ptp_overflow_check(struct work_struct *work)
+/* Write to PTPCLKVAL while PTPCLKADD is 1 */
+static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	struct delayed_work *dw = to_delayed_work(work);
-	struct sja1105_private *priv = dw_to_sja1105(dw);
-	struct timespec64 ts;
+	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	s64 ticks = ns_to_sja1105_ticks(delta);
+	int rc;
 
-	sja1105_ptp_gettime(&priv->ptp_caps, &ts);
+	mutex_lock(&priv->ptp_lock);
 
-	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
+	rc = sja1105_ptp_mode_set(priv, PTP_ADD_MODE);
+	if (rc < 0) {
+		dev_err(priv->ds->dev, "Failed to put PTPCLK in add mode\n");
+		goto out;
+	}
+
+	rc = sja1105_ptpclkval_write(priv, ticks);
+
+out:
+	mutex_unlock(&priv->ptp_lock);
+
+	return rc;
 }
 
 int sja1105_ptp_clock_register(struct sja1105_private *priv)
 {
 	struct dsa_switch *ds = priv->ds;
 
-	/* Set up the cycle counter */
-	priv->tstamp_cc = (struct cyclecounter) {
-		.read		= sja1105_ptptsclk_read,
-		.mask		= CYCLECOUNTER_MASK(64),
-		.shift		= SJA1105_CC_SHIFT,
-		.mult		= SJA1105_CC_MULT,
-	};
 	priv->ptp_caps = (struct ptp_clock_info) {
 		.owner		= THIS_MODULE,
 		.name		= "SJA1105 PHC",
@@ -370,8 +358,8 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv)
 	if (IS_ERR_OR_NULL(priv->clock))
 		return PTR_ERR(priv->clock);
 
-	INIT_DELAYED_WORK(&priv->refresh_work, sja1105_ptp_overflow_check);
-	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
+	priv->ptp_cmd.corrclk4ts = true;
+	priv->ptp_cmd.ptpclkadd = PTP_SET_MODE;
 
 	return sja1105_ptp_reset(priv);
 }
@@ -381,7 +369,6 @@ void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
 	if (IS_ERR_OR_NULL(priv->clock))
 		return;
 
-	cancel_delayed_work_sync(&priv->refresh_work);
 	ptp_clock_unregister(priv->clock);
 	priv->clock = NULL;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index af456b0a4d27..51e21d951548 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -4,6 +4,21 @@
 #ifndef _SJA1105_PTP_H
 #define _SJA1105_PTP_H
 
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
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
 
 int sja1105_ptp_clock_register(struct sja1105_private *priv);
@@ -24,6 +39,8 @@ u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
 
 int sja1105_ptp_reset(struct sja1105_private *priv);
 
+u64 sja1105_ptpclkval_read(struct sja1105_private *priv);
+
 #else
 
 static inline int sja1105_ptp_clock_register(struct sja1105_private *priv)
@@ -53,6 +70,11 @@ static inline int sja1105_ptp_reset(struct sja1105_private *priv)
 	return 0;
 }
 
+static inline u64 sja1105_ptpclkval_read(struct sja1105_private *priv)
+{
+	return 0;
+}
+
 #define sja1105et_ptp_cmd NULL
 
 #define sja1105pqrs_ptp_cmd NULL
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 84dc603138cf..1953d8c54af6 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -517,7 +517,6 @@ static struct sja1105_regs sja1105et_regs = {
 	.ptp_control = 0x17,
 	.ptpclk = 0x18, /* Spans 0x18 to 0x19 */
 	.ptpclkrate = 0x1A,
-	.ptptsclk = 0x1B, /* Spans 0x1B to 0x1C */
 };
 
 static struct sja1105_regs sja1105pqrs_regs = {
@@ -548,7 +547,6 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.ptp_control = 0x18,
 	.ptpclk = 0x19,
 	.ptpclkrate = 0x1B,
-	.ptptsclk = 0x1C,
 };
 
 struct sja1105_info sja1105e_info = {
-- 
2.17.1

