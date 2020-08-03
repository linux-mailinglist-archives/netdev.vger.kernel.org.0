Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C436023ABE7
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgHCRzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgHCRzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:55:19 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20273C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 10:55:19 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id i26so24555499edv.4
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 10:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1glRHXz6VucZCXL3gQ0P6a8PIZGRMw+27l/QbpU1CQ=;
        b=CF4ldGnMVfSWzaAuuKH866Mt8U7rCfO781NssZWFDPkxYGtdT681t2i9EaHeYGkF3+
         s8u8tj4PII3J0tBDP1gd3NJFgZBci+d0pt+AWdUCH6j3tYAIm7hnTAju5kVeyh205x3V
         Ta9Yoj60S9fTlRgAuRCniOlDFA2+ShZMAe0cTeAZAwHYgG4ImclyPYFb3QZSwCSwxFoB
         VWpeh6yElpx4xp19QdWnNhGGixa5ohMNelMsLusTIIgvT8wfHyjf5Q2yTfTZY+PBl7wV
         bj63pUPoQO+Kz4qXAMcb/S5w/eBRZ0+71cgD5O8Xt1IF1G0Ki2d1E93UJBGTk5LgYuJp
         bb0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1glRHXz6VucZCXL3gQ0P6a8PIZGRMw+27l/QbpU1CQ=;
        b=M3IpSrSqF9P8KyjUSVCSYL9vC2FaFA4Edy5ulcUh3zmPa+nhZNsn7DnhcreGA8wUJ7
         3nWOnbLv71Gz+1YkV7PvG/7SHIufSqZ2tsnvFBi5YpuNowflpOK61HGtcWS6WX1ziAEy
         AnuzAd1SEt0GP5szYvoAta1mhsiZgSPNW+wt6p6J45FBE8gdZYMTGBLcL47Sqbt4LZkr
         6E0Kc7k50BouwZAe1JNRNj/pFCyMqCz9X3z/Sv9hl483OF3IDo6B3x+KfAR4VB7fa5uL
         97cfx8E/ItfPP1P9wdQjGs8BoWsX7V8npd8MbKSLj9W9eyNcogYF4sLS/4qQbMhjWHRg
         VouQ==
X-Gm-Message-State: AOAM532+CYmsprdYQ5KooTI3iUodmCyHAYgZ+vP1cPqkrSNKuXfwMLjX
        VQmRif8/NsFeipkrDzZTCAo=
X-Google-Smtp-Source: ABdhPJw6KTqgYfwGFz/tE0NrA8sLaHLjPV6Q7UqyDKm9+ac+Fi2bPXlFLDOZYBVt3pc1f2im1ItgFQ==
X-Received: by 2002:a50:fb06:: with SMTP id d6mr16354755edq.165.1596477317647;
        Mon, 03 Aug 2020 10:55:17 -0700 (PDT)
Received: from localhost.localdomain ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id i5sm16560931ejg.121.2020.08.03.10.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 10:55:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, richardcochran@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: sja1105: poll for extts events from a timer
Date:   Mon,  3 Aug 2020 20:51:58 +0300
Message-Id: <20200803175158.579532-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current poll interval is enough to ensure that rising and falling
edge events are not lost for a 1 PPS signal with 50% duty cycle.

But when we deliver the events to user space, it will try to infer if
they were corresponding to a rising or to a falling edge (the kernel
driver doesn't know that either). User space will try to make that
inference based on the time at which the PPS master had emitted the
pulse (i.e. if it's a .0 time, it's rising edge, if it's .5 time, it's
falling edge).

But there is no in-kernel API for retrieving the precise timestamp
corresponding to a PPS master (aka perout) pulse. So user space has to
guess even that. It will read the PTP time on the PPS master right after
we've delivered the extts event, and declare that the PPS master time
was just the closest integer second, based on 2 thresholds (lower than
.25, or higher than .75, and ignore anything else).

Except that, if we poll for extts events (and our hardware doesn't
really help us, by not providing an interrupt), then there is a risk
that the poll period (and therefore the time at which the event is
delivered) might confuse user space.

Because we are always scheduling the next extts poll at
SJA1105_EXTTS_INTERVAL "from now" (that's the only thing that the
schedule_delayed_work() API gives us), it means that the start time of
the next delayed workqueue will always be shifted to the right a little
bit (shifted with the SPI access duration of this workqueue run).
In turn, because user space sees extts events that are non-periodic
compared to the PPS master's time, this means that it might start making
wrong guesses about rising/falling edge.

To understand the effect, here is the output of ts2phc currently. Notice
the 'src' timestamps of the 'SKIP extts' events, and how they have a
large wander. They keep increasing until the upper limit for the ignore
threshold (.75 seconds), after which the application starts ignoring the
_other_ edge.

ts2phc[26.624]: /dev/ptp3 SKIP extts index 0 at 21.449898912 src 21.657784518
ts2phc[27.133]: adding tstamp 21.949894240 to clock /dev/ptp3
ts2phc[27.133]: adding tstamp 22.000000000 to clock /dev/ptp1
ts2phc[27.133]: /dev/ptp3 offset        640 s2 freq   +5112
ts2phc[27.636]: /dev/ptp3 SKIP extts index 0 at 22.449889360 src 22.669398022
ts2phc[28.140]: adding tstamp 22.949884376 to clock /dev/ptp3
ts2phc[28.140]: adding tstamp 23.000000000 to clock /dev/ptp1
ts2phc[28.140]: /dev/ptp3 offset         96 s2 freq   +4760
ts2phc[28.644]: /dev/ptp3 SKIP extts index 0 at 23.449879504 src 23.677420422
ts2phc[29.153]: adding tstamp 23.949874704 to clock /dev/ptp3
ts2phc[29.153]: adding tstamp 24.000000000 to clock /dev/ptp1
ts2phc[29.153]: /dev/ptp3 offset       -264 s2 freq   +4429
ts2phc[29.656]: /dev/ptp3 SKIP extts index 0 at 24.449870008 src 24.689407238
ts2phc[30.160]: adding tstamp 24.949865376 to clock /dev/ptp3
ts2phc[30.160]: adding tstamp 25.000000000 to clock /dev/ptp1
ts2phc[30.160]: /dev/ptp3 offset       -280 s2 freq   +4334
ts2phc[30.664]: /dev/ptp3 SKIP extts index 0 at 25.449860760 src 25.697449926
ts2phc[31.168]: adding tstamp 25.949856176 to clock /dev/ptp3
ts2phc[31.168]: adding tstamp 26.000000000 to clock /dev/ptp1
ts2phc[31.168]: /dev/ptp3 offset       -176 s2 freq   +4354
ts2phc[31.672]: /dev/ptp3 SKIP extts index 0 at 26.449851584 src 26.705433606
ts2phc[32.180]: adding tstamp 26.949846992 to clock /dev/ptp3
ts2phc[32.180]: adding tstamp 27.000000000 to clock /dev/ptp1
ts2phc[32.180]: /dev/ptp3 offset        -80 s2 freq   +4397
ts2phc[32.684]: /dev/ptp3 SKIP extts index 0 at 27.449842384 src 27.717415110
ts2phc[33.192]: adding tstamp 27.949837768 to clock /dev/ptp3
ts2phc[33.192]: adding tstamp 28.000000000 to clock /dev/ptp1
ts2phc[33.192]: /dev/ptp3 offset          0 s2 freq   +4453
ts2phc[33.696]: /dev/ptp3 SKIP extts index 0 at 28.449833128 src 28.729412902
ts2phc[34.200]: adding tstamp 28.949828472 to clock /dev/ptp3
ts2phc[34.200]: adding tstamp 29.000000000 to clock /dev/ptp1
ts2phc[34.200]: /dev/ptp3 offset          8 s2 freq   +4461
ts2phc[34.704]: /dev/ptp3 SKIP extts index 0 at 29.449823816 src 29.737416038
ts2phc[35.208]: adding tstamp 29.949819152 to clock /dev/ptp3
ts2phc[35.208]: adding tstamp 30.000000000 to clock /dev/ptp1
ts2phc[35.208]: /dev/ptp3 offset         -8 s2 freq   +4447
ts2phc[35.712]: /dev/ptp3 SKIP extts index 0 at 30.449814496 src 30.745554982
ts2phc[36.216]: adding tstamp 30.949809840 to clock /dev/ptp3
ts2phc[36.216]: adding tstamp 31.000000000 to clock /dev/ptp1
ts2phc[36.216]: /dev/ptp3 offset         -8 s2 freq   +4445
ts2phc[36.468]: /dev/ptp3 SKIP extts index 0 at 31.449805184 src 31.501109446
ts2phc[36.972]: adding tstamp 31.949800536 to clock /dev/ptp3
ts2phc[36.972]: adding tstamp 32.000000000 to clock /dev/ptp1
ts2phc[36.972]: /dev/ptp3 offset         -8 s2 freq   +4442
ts2phc[37.480]: /dev/ptp3 SKIP extts index 0 at 32.449795896 src 32.513320070
ts2phc[37.984]: adding tstamp 32.949791248 to clock /dev/ptp3
ts2phc[37.984]: adding tstamp 33.000000000 to clock /dev/ptp1
ts2phc[37.984]: /dev/ptp3 offset          0 s2 freq   +4448

Fix that by taking the following measures:
- Schedule the poll from a timer. Because we are really scheduling the
  timer periodically, the extts events delivered to user space are
  periodic too, and don't suffer from the "shift-to-the-right" effect.
- Increase the poll period to 6 times a second. This imposes a smaller
  upper bound to the shift that can occur to the delivery time of extts
  events, and makes user space (ts2phc) to always interpret correctly
  which events should be skipped and which shouldn't.
- Move the SPI readout itself to the main PTP kernel thread, instead of
  the generic workqueue. This is because the timer runs in atomic
  context, but is also better than before, because if needed, we can
  chrt & taskset this kernel thread, to ensure it gets enough priority
  under load.

After this patch, one can notice that the wander is greatly reduced, and
that the latencies of one extts poll are not propagated to the next. The
'src' timestamp that is skipped is never larger than .65 seconds (which
means .15 seconds larger than the time at which the real event occurred
at, and .10 seconds smaller than the .75 upper threshold for ignoring
the falling edge):

ts2phc[40.076]: adding tstamp 34.949261296 to clock /dev/ptp3
ts2phc[40.076]: adding tstamp 35.000000000 to clock /dev/ptp1
ts2phc[40.076]: /dev/ptp3 offset         48 s2 freq   +4631
ts2phc[40.568]: /dev/ptp3 SKIP extts index 0 at 35.449256496 src 35.595791078
ts2phc[41.064]: adding tstamp 35.949251744 to clock /dev/ptp3
ts2phc[41.064]: adding tstamp 36.000000000 to clock /dev/ptp1
ts2phc[41.064]: /dev/ptp3 offset       -224 s2 freq   +4374
ts2phc[41.552]: /dev/ptp3 SKIP extts index 0 at 36.449247088 src 36.579825574
ts2phc[42.044]: adding tstamp 36.949242456 to clock /dev/ptp3
ts2phc[42.044]: adding tstamp 37.000000000 to clock /dev/ptp1
ts2phc[42.044]: /dev/ptp3 offset       -240 s2 freq   +4290
ts2phc[42.536]: /dev/ptp3 SKIP extts index 0 at 37.449237848 src 37.563828774
ts2phc[43.028]: adding tstamp 37.949233264 to clock /dev/ptp3
ts2phc[43.028]: adding tstamp 38.000000000 to clock /dev/ptp1
ts2phc[43.028]: /dev/ptp3 offset       -144 s2 freq   +4314
ts2phc[43.520]: /dev/ptp3 SKIP extts index 0 at 38.449228656 src 38.547823238
ts2phc[44.012]: adding tstamp 38.949224048 to clock /dev/ptp3
ts2phc[44.012]: adding tstamp 39.000000000 to clock /dev/ptp1
ts2phc[44.012]: /dev/ptp3 offset        -80 s2 freq   +4335
ts2phc[44.508]: /dev/ptp3 SKIP extts index 0 at 39.449219432 src 39.535846118
ts2phc[44.996]: adding tstamp 39.949214816 to clock /dev/ptp3
ts2phc[44.996]: adding tstamp 40.000000000 to clock /dev/ptp1
ts2phc[44.996]: /dev/ptp3 offset        -32 s2 freq   +4359
ts2phc[45.488]: /dev/ptp3 SKIP extts index 0 at 40.449210192 src 40.515824678
ts2phc[45.980]: adding tstamp 40.949205568 to clock /dev/ptp3
ts2phc[45.980]: adding tstamp 41.000000000 to clock /dev/ptp1
ts2phc[45.980]: /dev/ptp3 offset          8 s2 freq   +4390
ts2phc[46.636]: /dev/ptp3 SKIP extts index 0 at 41.449200928 src 41.664176902
ts2phc[47.132]: adding tstamp 41.949196288 to clock /dev/ptp3
ts2phc[47.132]: adding tstamp 42.000000000 to clock /dev/ptp1
ts2phc[47.132]: /dev/ptp3 offset          0 s2 freq   +4384
ts2phc[47.620]: /dev/ptp3 SKIP extts index 0 at 42.449191656 src 42.648117190
ts2phc[48.112]: adding tstamp 42.949187016 to clock /dev/ptp3
ts2phc[48.112]: adding tstamp 43.000000000 to clock /dev/ptp1
ts2phc[48.112]: /dev/ptp3 offset          0 s2 freq   +4384
ts2phc[48.604]: /dev/ptp3 SKIP extts index 0 at 43.449182384 src 43.632112582
ts2phc[49.100]: adding tstamp 43.949177736 to clock /dev/ptp3
ts2phc[49.100]: adding tstamp 44.000000000 to clock /dev/ptp1
ts2phc[49.100]: /dev/ptp3 offset         -8 s2 freq   +4376
ts2phc[49.588]: /dev/ptp3 SKIP extts index 0 at 44.449173096 src 44.616136774
ts2phc[50.080]: adding tstamp 44.949168464 to clock /dev/ptp3
ts2phc[50.080]: adding tstamp 45.000000000 to clock /dev/ptp1
ts2phc[50.080]: /dev/ptp3 offset          8 s2 freq   +4390
ts2phc[50.572]: /dev/ptp3 SKIP extts index 0 at 45.449163816 src 45.600134662
ts2phc[51.064]: adding tstamp 45.949159160 to clock /dev/ptp3
ts2phc[51.064]: adding tstamp 46.000000000 to clock /dev/ptp1
ts2phc[51.064]: /dev/ptp3 offset         -8 s2 freq   +4376
ts2phc[51.556]: /dev/ptp3 SKIP extts index 0 at 46.449154528 src 46.584588550
ts2phc[52.048]: adding tstamp 46.949149896 to clock /dev/ptp3
ts2phc[52.048]: adding tstamp 47.000000000 to clock /dev/ptp1
ts2phc[52.048]: /dev/ptp3 offset          0 s2 freq   +4382
ts2phc[52.540]: /dev/ptp3 SKIP extts index 0 at 47.449145256 src 47.568132198
ts2phc[53.032]: adding tstamp 47.949140616 to clock /dev/ptp3
ts2phc[53.032]: adding tstamp 48.000000000 to clock /dev/ptp1
ts2phc[53.032]: /dev/ptp3 offset          0 s2 freq   +4382
ts2phc[53.524]: /dev/ptp3 SKIP extts index 0 at 48.449135968 src 48.552121446
ts2phc[54.016]: adding tstamp 48.949131320 to clock /dev/ptp3
ts2phc[54.016]: adding tstamp 49.000000000 to clock /dev/ptp1
ts2phc[54.016]: /dev/ptp3 offset          0 s2 freq   +4382
ts2phc[54.512]: /dev/ptp3 SKIP extts index 0 at 49.449126680 src 49.540147014
ts2phc[55.000]: adding tstamp 49.949122040 to clock /dev/ptp3
ts2phc[55.000]: adding tstamp 50.000000000 to clock /dev/ptp1
ts2phc[55.000]: /dev/ptp3 offset          0 s2 freq   +4382
ts2phc[55.492]: /dev/ptp3 SKIP extts index 0 at 50.449117400 src 50.520119078
ts2phc[55.988]: adding tstamp 50.949112768 to clock /dev/ptp3
ts2phc[55.988]: adding tstamp 51.000000000 to clock /dev/ptp1
ts2phc[55.988]: /dev/ptp3 offset          8 s2 freq   +4390
ts2phc[56.476]: /dev/ptp3 SKIP extts index 0 at 51.449108120 src 51.504175910
ts2phc[57.132]: adding tstamp 51.949103480 to clock /dev/ptp3
ts2phc[57.132]: adding tstamp 52.000000000 to clock /dev/ptp1
ts2phc[57.132]: /dev/ptp3 offset          0 s2 freq   +4384
ts2phc[57.624]: /dev/ptp3 SKIP extts index 0 at 52.449098840 src 52.651833574
ts2phc[58.116]: adding tstamp 52.949094200 to clock /dev/ptp3
ts2phc[58.116]: adding tstamp 53.000000000 to clock /dev/ptp1
ts2phc[58.116]: /dev/ptp3 offset          8 s2 freq   +4392
ts2phc[58.612]: /dev/ptp3 SKIP extts index 0 at 53.449089560 src 53.639826918
ts2phc[59.100]: adding tstamp 53.949084920 to clock /dev/ptp3
ts2phc[59.100]: adding tstamp 54.000000000 to clock /dev/ptp1
ts2phc[59.100]: /dev/ptp3 offset          8 s2 freq   +4394
ts2phc[59.592]: /dev/ptp3 SKIP extts index 0 at 54.449080272 src 54.619842278
ts2phc[60.084]: adding tstamp 54.949075624 to clock /dev/ptp3
ts2phc[60.084]: adding tstamp 55.000000000 to clock /dev/ptp1
ts2phc[60.084]: /dev/ptp3 offset          8 s2 freq   +4397
ts2phc[60.576]: /dev/ptp3 SKIP extts index 0 at 55.449070968 src 55.603885542
ts2phc[61.068]: adding tstamp 55.949066312 to clock /dev/ptp3
ts2phc[61.068]: adding tstamp 56.000000000 to clock /dev/ptp1
ts2phc[61.068]: /dev/ptp3 offset          0 s2 freq   +4391
ts2phc[61.560]: /dev/ptp3 SKIP extts index 0 at 56.449061680 src 56.587885798
ts2phc[62.052]: adding tstamp 56.949057032 to clock /dev/ptp3
ts2phc[62.052]: adding tstamp 57.000000000 to clock /dev/ptp1
ts2phc[62.052]: /dev/ptp3 offset         -8 s2 freq   +4383

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 79 ++++++++++++++++-----------
 drivers/net/dsa/sja1105/sja1105_ptp.h |  5 +-
 2 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 177134596458..1b90570b257b 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -24,7 +24,7 @@
  * this hardware can do (but may be enough for some setups). Anything of higher
  * frequency than 1 Hz will be lost, since there is no timestamp FIFO.
  */
-#define SJA1105_EXTTS_INTERVAL		(HZ / 4)
+#define SJA1105_EXTTS_INTERVAL		(HZ / 6)
 
 /*            This range is actually +/- SJA1105_MAX_ADJ_PPB
  *            divided by 1000 (ppb -> ppm) and with a 16-bit
@@ -51,8 +51,8 @@ enum sja1105_ptp_clk_mode {
 	PTP_SET_MODE = 0,
 };
 
-#define extts_to_data(d) \
-		container_of((d), struct sja1105_ptp_data, extts_work)
+#define extts_to_data(t) \
+		container_of((t), struct sja1105_ptp_data, extts_timer)
 #define ptp_caps_to_data(d) \
 		container_of((d), struct sja1105_ptp_data, caps)
 #define ptp_data_to_sja1105(d) \
@@ -350,6 +350,30 @@ static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 ticks,
 				ptp_sts);
 }
 
+static void sja1105_extts_poll(struct sja1105_private *priv)
+{
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	const struct sja1105_regs *regs = priv->info->regs;
+	struct ptp_clock_event event;
+	u64 ptpsyncts = 0;
+	int rc;
+
+	rc = sja1105_xfer_u64(priv, SPI_READ, regs->ptpsyncts, &ptpsyncts,
+			      NULL);
+	if (rc < 0)
+		dev_err_ratelimited(priv->ds->dev,
+				    "Failed to read PTPSYNCTS: %d\n", rc);
+
+	if (ptpsyncts && ptp_data->ptpsyncts != ptpsyncts) {
+		event.index = 0;
+		event.type = PTP_CLOCK_EXTTS;
+		event.timestamp = ns_to_ktime(sja1105_ticks_to_ns(ptpsyncts));
+		ptp_clock_event(ptp_data->clock, &event);
+
+		ptp_data->ptpsyncts = ptpsyncts;
+	}
+}
+
 static long sja1105_rxtstamp_work(struct ptp_clock_info *ptp)
 {
 	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
@@ -380,6 +404,9 @@ static long sja1105_rxtstamp_work(struct ptp_clock_info *ptp)
 		netif_rx_ni(skb);
 	}
 
+	if (ptp_data->extts_enabled)
+		sja1105_extts_poll(priv);
+
 	mutex_unlock(&ptp_data->lock);
 
 	/* Don't restart */
@@ -595,36 +622,21 @@ static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return rc;
 }
 
-static void sja1105_ptp_extts_work(struct work_struct *work)
+static void sja1105_ptp_extts_setup_timer(struct sja1105_ptp_data *ptp_data)
 {
-	struct delayed_work *dw = to_delayed_work(work);
-	struct sja1105_ptp_data *ptp_data = extts_to_data(dw);
-	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
-	const struct sja1105_regs *regs = priv->info->regs;
-	struct ptp_clock_event event;
-	u64 ptpsyncts = 0;
-	int rc;
-
-	mutex_lock(&ptp_data->lock);
-
-	rc = sja1105_xfer_u64(priv, SPI_READ, regs->ptpsyncts, &ptpsyncts,
-			      NULL);
-	if (rc < 0)
-		dev_err_ratelimited(priv->ds->dev,
-				    "Failed to read PTPSYNCTS: %d\n", rc);
+	unsigned long expires = ((jiffies / SJA1105_EXTTS_INTERVAL) + 1) *
+				SJA1105_EXTTS_INTERVAL;
 
-	if (ptpsyncts && ptp_data->ptpsyncts != ptpsyncts) {
-		event.index = 0;
-		event.type = PTP_CLOCK_EXTTS;
-		event.timestamp = ns_to_ktime(sja1105_ticks_to_ns(ptpsyncts));
-		ptp_clock_event(ptp_data->clock, &event);
+	mod_timer(&ptp_data->extts_timer, expires);
+}
 
-		ptp_data->ptpsyncts = ptpsyncts;
-	}
+static void sja1105_ptp_extts_timer(struct timer_list *t)
+{
+	struct sja1105_ptp_data *ptp_data = extts_to_data(t);
 
-	mutex_unlock(&ptp_data->lock);
+	ptp_schedule_worker(ptp_data->clock, 0);
 
-	schedule_delayed_work(&ptp_data->extts_work, SJA1105_EXTTS_INTERVAL);
+	sja1105_ptp_extts_setup_timer(ptp_data);
 }
 
 static int sja1105_change_ptp_clk_pin_func(struct sja1105_private *priv,
@@ -771,11 +783,12 @@ static int sja1105_extts_enable(struct sja1105_private *priv,
 	if (rc)
 		return rc;
 
+	priv->ptp_data.extts_enabled = on;
+
 	if (on)
-		schedule_delayed_work(&priv->ptp_data.extts_work,
-				      SJA1105_EXTTS_INTERVAL);
+		sja1105_ptp_extts_setup_timer(&priv->ptp_data);
 	else
-		cancel_delayed_work_sync(&priv->ptp_data.extts_work);
+		del_timer_sync(&priv->ptp_data.extts_timer);
 
 	return 0;
 }
@@ -858,7 +871,7 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 	ptp_data->cmd.corrclk4ts = true;
 	ptp_data->cmd.ptpclkadd = PTP_SET_MODE;
 
-	INIT_DELAYED_WORK(&ptp_data->extts_work, sja1105_ptp_extts_work);
+	timer_setup(&ptp_data->extts_timer, sja1105_ptp_extts_timer, 0);
 
 	return sja1105_ptp_reset(ds);
 }
@@ -871,7 +884,7 @@ void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 	if (IS_ERR_OR_NULL(ptp_data->clock))
 		return;
 
-	cancel_delayed_work_sync(&ptp_data->extts_work);
+	del_timer_sync(&ptp_data->extts_timer);
 	ptp_cancel_worker_sync(ptp_data->clock);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 	ptp_clock_unregister(ptp_data->clock);
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 6408d1158f2d..3daa33e98e77 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -4,6 +4,8 @@
 #ifndef _SJA1105_PTP_H
 #define _SJA1105_PTP_H
 
+#include <linux/timer.h>
+
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
 
 /* Timestamps are in units of 8 ns clock ticks (equivalent to
@@ -72,13 +74,14 @@ struct sja1105_ptp_cmd {
 };
 
 struct sja1105_ptp_data {
-	struct delayed_work extts_work;
+	struct timer_list extts_timer;
 	struct sk_buff_head skb_rxtstamp_queue;
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
 	struct sja1105_ptp_cmd cmd;
 	/* Serializes all operations on the PTP hardware clock */
 	struct mutex lock;
+	bool extts_enabled;
 	u64 ptpsyncts;
 };
 
-- 
2.25.1

