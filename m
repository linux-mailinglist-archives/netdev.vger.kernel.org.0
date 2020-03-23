Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D07190178
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCWW7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:59:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40892 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgCWW7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:59:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id f3so19234468wrw.7
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 15:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NRqsm+48RzioreB5D+XOKubHEqsVzwK7Oq1Ng2gHD2s=;
        b=GkyCORjrl2pWwWXkcF/uPxYqelBnN20BTtxl80uXfM2Ysys+0HMotwqBUi3MHl27Mg
         9C8qK+2dyc8HY0Z1egHwMfvOMenUcdfE1TRYqvkOogNEcPhOcmwSxyOq8gXjsAftZCN2
         nYG2Kv39fbNnCyG/sJrb3oZd8GzQyY1pCc7Ue7w8flqNhhxML8xX95UZS+Fy2ltiCixg
         Gd32WIUEJGbJoX7magxCueQKVPUvZTXlEci8oh14Nc929SrZx41Q52YlIftjWYgDzlca
         ovhua4+JjRdx8g3ktSpIKb0KP0qEa13LlEhSmyWDEiD23QOaWTVB3gu6vXOwrxMjkV1N
         IOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NRqsm+48RzioreB5D+XOKubHEqsVzwK7Oq1Ng2gHD2s=;
        b=i0CLsFFkx7l4cOVJAIwHyjBWvAY7IlnFcKNm+NLip1LSp189xLp8+KwcZ10gZVWc5c
         w2elALYvUYJq74D2KBKQRHbmSQ7e8nmtiwYyKLkztZtFVf1gMo9Z904912eTz2tIPV12
         SxnrvSQ3DPMeyRxZvv5ZkhPCuljIxf5/H6rSQBK494o9DHJLmq6ZPBK5r1ptfE0TT5gW
         aaM9E0c+0w39rLdOUsurU7yvYr2n9FRY+179GiGeD/ub5QTHot/uBkOCAiU18ClP1xpr
         m+fw+vlB56JqaBzR8tTJ/aasrZIQU7/Q5hd04YGmH3tnyf9yyjjD12NiN7v+WvSScWJq
         8qfw==
X-Gm-Message-State: ANhLgQ1UK40PR1JZOxXBU8yJg3qXW6b10780kwIiSlqnH7JspDnyrPc5
        GPf/VhNdKRfZ2H83rg6h6uk=
X-Google-Smtp-Source: ADFU+vuxb2Xa7qoi4hP9yPal4Gp53TUrMFPla3jPRB6OW2VVpykWNShutmehQMIDVuYl4JHG1wmiSA==
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr34460176wrp.403.1585004375814;
        Mon, 23 Mar 2020 15:59:35 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id r3sm26332912wrm.35.2020.03.23.15.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 15:59:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, richardcochran@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        christian.herber@nxp.com, yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: dsa: sja1105: configure the PTP_CLK pin as EXT_TS or PER_OUT
Date:   Tue, 24 Mar 2020 00:59:24 +0200
Message-Id: <20200323225924.14347-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323225924.14347-1-olteanv@gmail.com>
References: <20200323225924.14347-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1105 switch family has a PTP_CLK pin which emits a signal with
fixed 50% duty cycle, but variable frequency and programmable start time.

On the second generation (P/Q/R/S) switches, this pin supports even more
functionality. The use case described by the hardware documents talks
about synchronization via oneshot pulses: given 2 sja1105 switches,
arbitrarily designated as a master and a slave, the master emits a
single pulse on PTP_CLK, while the slave is configured to timestamp this
pulse received on its PTP_CLK pin (which must obviously be configured as
input). The difference between the timestamps then exactly becomes the
slave offset to the master.

The only trouble with the above is that the hardware is very much tied
into this use case only, and not very generic beyond that:
 - When emitting a oneshot pulse, instead of being told when to emit it,
   the switch just does it "now" and tells you later what time it was,
   via the PTPSYNCTS register. [ Incidentally, this is the same register
   that the slave uses to collect the ext_ts timestamp from, too. ]
 - On the sync slave, there is no interrupt mechanism on reception of a
   new extts, and no FIFO to buffer them, because in the foreseen use
   case, software is in control of both the master and the slave pins,
   so it "knows" when there's something to collect.

These 2 problems mean that:
 - We don't support (at least yet) the quirky oneshot mode exposed by
   the hardware, just normal periodic output.
 - We abuse the hardware a little bit when we expose generic extts.
   Because there's no interrupt mechanism, we need to poll at double the
   frequency we expect to receive a pulse. Currently that means a
   non-configurable "twice a second".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h             |   3 +
 drivers/net/dsa/sja1105/sja1105_main.c        |   8 +
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 247 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.h         |   4 +
 drivers/net/dsa/sja1105/sja1105_spi.c         |   5 +
 .../net/dsa/sja1105/sja1105_static_config.c   |   1 +
 .../net/dsa/sja1105/sja1105_static_config.h   |   1 +
 7 files changed, 269 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 5bc40175ee0d..a358fc89a6db 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -38,10 +38,13 @@ struct sja1105_regs {
 	u64 config;
 	u64 sgmii;
 	u64 rmii_pll1;
+	u64 ptppinst;
+	u64 ptppindur;
 	u64 ptp_control;
 	u64 ptpclkval;
 	u64 ptpclkrate;
 	u64 ptpclkcorp;
+	u64 ptpsyncts;
 	u64 ptpschtm;
 	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4d182293ca1f..e0c99bb63cdf 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -504,6 +504,14 @@ static int sja1105_init_avb_params(struct sja1105_private *priv)
 	/* Configure the MAC addresses for meta frames */
 	avb->destmeta = SJA1105_META_DMAC;
 	avb->srcmeta  = SJA1105_META_SMAC;
+	/* On P/Q/R/S, configure the direction of the PTP_CLK pin as input by
+	 * default. This is because there might be boards with a hardware
+	 * layout where enabling the pin as output might cause an electrical
+	 * clash. On E/T the pin is always an output, which the board designers
+	 * probably already knew, so even if there are going to be electrical
+	 * issues, there's nothing we can do.
+	 */
+	avb->cas_master = false;
 
 	return 0;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index a07aaf55068f..a22f8e3fc06b 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -14,6 +14,17 @@
 #define SJA1105_MAX_ADJ_PPB		32000000
 #define SJA1105_SIZE_PTP_CMD		4
 
+/* PTPSYNCTS has no interrupt or update mechanism, because the intended
+ * hardware use case is for the timestamp to be collected synchronously,
+ * immediately after the CAS_MASTER SJA1105 switch has triggered a CASSYNC
+ * pulse on the PTP_CLK pin. When used as a generic extts source, it needs
+ * polling and a comparison with the old value. The polling interval is just
+ * the Nyquist rate of a canonical PPS input (e.g. from a GPS module).
+ * Anything of higher frequency than 1 Hz will be lost, since there is no
+ * timestamp FIFO.
+ */
+#define SJA1105_EXTTS_INTERVAL		(HZ / 2)
+
 /*            This range is actually +/- SJA1105_MAX_ADJ_PPB
  *            divided by 1000 (ppb -> ppm) and with a 16-bit
  *            "fractional" part (actually fixed point).
@@ -39,6 +50,8 @@ enum sja1105_ptp_clk_mode {
 	PTP_SET_MODE = 0,
 };
 
+#define extts_to_data(d) \
+		container_of((d), struct sja1105_ptp_data, extts_work)
 #define ptp_caps_to_data(d) \
 		container_of((d), struct sja1105_ptp_data, caps)
 #define ptp_data_to_sja1105(d) \
@@ -168,6 +181,8 @@ void sja1105et_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
 	sja1105_packing(buf, &valid,           31, 31, size, op);
 	sja1105_packing(buf, &cmd->ptpstrtsch, 30, 30, size, op);
 	sja1105_packing(buf, &cmd->ptpstopsch, 29, 29, size, op);
+	sja1105_packing(buf, &cmd->startptpcp, 28, 28, size, op);
+	sja1105_packing(buf, &cmd->stopptpcp,  27, 27, size, op);
 	sja1105_packing(buf, &cmd->resptp,      2,  2, size, op);
 	sja1105_packing(buf, &cmd->corrclk4ts,  1,  1, size, op);
 	sja1105_packing(buf, &cmd->ptpclkadd,   0,  0, size, op);
@@ -183,6 +198,8 @@ void sja1105pqrs_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
 	sja1105_packing(buf, &valid,           31, 31, size, op);
 	sja1105_packing(buf, &cmd->ptpstrtsch, 30, 30, size, op);
 	sja1105_packing(buf, &cmd->ptpstopsch, 29, 29, size, op);
+	sja1105_packing(buf, &cmd->startptpcp, 28, 28, size, op);
+	sja1105_packing(buf, &cmd->stopptpcp,  27, 27, size, op);
 	sja1105_packing(buf, &cmd->resptp,      3,  3, size, op);
 	sja1105_packing(buf, &cmd->corrclk4ts,  2,  2, size, op);
 	sja1105_packing(buf, &cmd->ptpclkadd,   0,  0, size, op);
@@ -577,6 +594,227 @@ static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return rc;
 }
 
+static void sja1105_ptp_extts_work(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct sja1105_ptp_data *ptp_data = extts_to_data(dw);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
+	const struct sja1105_regs *regs = priv->info->regs;
+	struct ptp_clock_event event;
+	u64 ptpsyncts = 0;
+	int rc;
+
+	mutex_lock(&ptp_data->lock);
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
+
+	mutex_unlock(&ptp_data->lock);
+
+	schedule_delayed_work(&ptp_data->extts_work, SJA1105_EXTTS_INTERVAL);
+}
+
+static int sja1105_change_ptp_clk_pin_func(struct sja1105_private *priv,
+					   enum ptp_pin_function func)
+{
+	struct sja1105_avb_params_entry *avb;
+	enum ptp_pin_function old_func;
+
+	avb = priv->static_config.tables[BLK_IDX_AVB_PARAMS].entries;
+
+	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
+	    priv->info->device_id == SJA1105T_DEVICE_ID ||
+	    avb->cas_master)
+		old_func = PTP_PF_PEROUT;
+	else
+		old_func = PTP_PF_EXTTS;
+
+	if (func == old_func)
+		return 0;
+
+	avb->cas_master = (func == PTP_PF_PEROUT);
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_AVB_PARAMS, 0, avb,
+					    true);
+}
+
+/* The PTP_CLK pin may be configured to toggle with a 50% duty cycle and a
+ * frequency f:
+ *
+ *           NSEC_PER_SEC
+ * f = ----------------------
+ *     (PTPPINDUR * 8 ns) * 2
+ */
+static int sja1105_per_out_enable(struct sja1105_private *priv,
+				  struct ptp_perout_request *perout,
+				  bool on)
+{
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	const struct sja1105_regs *regs = priv->info->regs;
+	struct sja1105_ptp_cmd cmd = ptp_data->cmd;
+	int rc;
+
+	/* We only support one channel */
+	if (perout->index != 0)
+		return -EOPNOTSUPP;
+
+	/* Reject requests with unsupported flags */
+	if (perout->flags)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&ptp_data->lock);
+
+	rc = sja1105_change_ptp_clk_pin_func(priv, PTP_PF_PEROUT);
+	if (rc)
+		goto out;
+
+	if (on) {
+		struct timespec64 pin_duration_ts = {
+			.tv_sec = perout->period.sec,
+			.tv_nsec = perout->period.nsec,
+		};
+		struct timespec64 pin_start_ts = {
+			.tv_sec = perout->start.sec,
+			.tv_nsec = perout->start.nsec,
+		};
+		u64 pin_duration = timespec64_to_ns(&pin_duration_ts);
+		u64 pin_start = timespec64_to_ns(&pin_start_ts);
+		u32 pin_duration32;
+		u64 now;
+
+		/* ptppindur: 32 bit register which holds the interval between
+		 * 2 edges on PTP_CLK. So check for truncation which happens
+		 * at periods larger than around 68.7 seconds.
+		 */
+		pin_duration = ns_to_sja1105_ticks(pin_duration / 2);
+		if (pin_duration > U32_MAX) {
+			rc = -ERANGE;
+			goto out;
+		}
+		pin_duration32 = pin_duration;
+
+		/* ptppins: 64 bit register which needs to hold a PTP time
+		 * larger than the current time, otherwise the startptpcp
+		 * command won't do anything. So advance the current time
+		 * by a number of periods in a way that won't alter the
+		 * phase offset.
+		 */
+		rc = __sja1105_ptp_gettimex(priv->ds, &now, NULL);
+		if (rc < 0)
+			goto out;
+
+		pin_start = future_base_time(pin_start, pin_duration,
+					     now + 1ull * NSEC_PER_SEC);
+		pin_start = ns_to_sja1105_ticks(pin_start);
+
+		rc = sja1105_xfer_u64(priv, SPI_WRITE, regs->ptppinst,
+				      &pin_start, NULL);
+		if (rc < 0)
+			goto out;
+
+		rc = sja1105_xfer_u32(priv, SPI_WRITE, regs->ptppindur,
+				      &pin_duration32, NULL);
+		if (rc < 0)
+			goto out;
+	}
+
+	if (on)
+		cmd.startptpcp = true;
+	else
+		cmd.stopptpcp = true;
+
+	rc = sja1105_ptp_commit(priv->ds, &cmd, SPI_WRITE);
+
+out:
+	mutex_unlock(&ptp_data->lock);
+
+	return rc;
+}
+
+static int sja1105_extts_enable(struct sja1105_private *priv,
+				struct ptp_extts_request *extts,
+				bool on)
+{
+	int rc;
+
+	/* We only support one channel */
+	if (extts->index != 0)
+		return -EOPNOTSUPP;
+
+	/* Reject requests with unsupported flags */
+	if (extts->flags)
+		return -EOPNOTSUPP;
+
+	rc = sja1105_change_ptp_clk_pin_func(priv, PTP_PF_EXTTS);
+	if (rc)
+		return rc;
+
+	if (on)
+		schedule_delayed_work(&priv->ptp_data.extts_work,
+				      SJA1105_EXTTS_INTERVAL);
+	else
+		cancel_delayed_work_sync(&priv->ptp_data.extts_work);
+
+	return 0;
+}
+
+static int sja1105_ptp_enable(struct ptp_clock_info *ptp,
+			      struct ptp_clock_request *req, int on)
+{
+	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
+	int rc = -EOPNOTSUPP;
+
+	if (req->type == PTP_CLK_REQ_PEROUT)
+		rc = sja1105_per_out_enable(priv, &req->perout, on);
+	else if (req->type == PTP_CLK_REQ_EXTTS)
+		rc = sja1105_extts_enable(priv, &req->extts, on);
+
+	return rc;
+}
+
+static int sja1105_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+				  enum ptp_pin_function func, unsigned int chan)
+{
+	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
+
+	if (chan != 0 || pin != 0)
+		return -1;
+
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+		break;
+	case PTP_PF_EXTTS:
+		if (priv->info->device_id == SJA1105E_DEVICE_ID ||
+		    priv->info->device_id == SJA1105T_DEVICE_ID)
+			return -1;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static struct ptp_pin_desc sja1105_ptp_pin = {
+	.name = "ptp_clk",
+	.index = 0,
+	.func = PTP_PF_NONE,
+};
+
 int sja1105_ptp_clock_register(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
@@ -590,8 +828,14 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 		.adjtime	= sja1105_ptp_adjtime,
 		.gettimex64	= sja1105_ptp_gettimex,
 		.settime64	= sja1105_ptp_settime,
+		.enable		= sja1105_ptp_enable,
+		.verify		= sja1105_ptp_verify_pin,
 		.do_aux_work	= sja1105_rxtstamp_work,
 		.max_adj	= SJA1105_MAX_ADJ_PPB,
+		.pin_config	= &sja1105_ptp_pin,
+		.n_pins		= 1,
+		.n_ext_ts	= 1,
+		.n_per_out	= 1,
 	};
 
 	skb_queue_head_init(&ptp_data->skb_rxtstamp_queue);
@@ -604,6 +848,8 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 	ptp_data->cmd.corrclk4ts = true;
 	ptp_data->cmd.ptpclkadd = PTP_SET_MODE;
 
+	INIT_DELAYED_WORK(&ptp_data->extts_work, sja1105_ptp_extts_work);
+
 	return sja1105_ptp_reset(ds);
 }
 
@@ -615,6 +861,7 @@ void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 	if (IS_ERR_OR_NULL(ptp_data->clock))
 		return;
 
+	cancel_delayed_work_sync(&ptp_data->extts_work);
 	ptp_cancel_worker_sync(ptp_data->clock);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 	ptp_clock_unregister(ptp_data->clock);
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 119e345b40fc..43480b24f1f0 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -49,6 +49,8 @@ static inline s64 future_base_time(s64 base_time, s64 cycle_time, s64 now)
 }
 
 struct sja1105_ptp_cmd {
+	u64 startptpcp;		/* start toggling PTP_CLK pin */
+	u64 stopptpcp;		/* stop toggling PTP_CLK pin */
 	u64 ptpstrtsch;		/* start schedule */
 	u64 ptpstopsch;		/* stop schedule */
 	u64 resptp;		/* reset */
@@ -57,12 +59,14 @@ struct sja1105_ptp_cmd {
 };
 
 struct sja1105_ptp_data {
+	struct delayed_work extts_work;
 	struct sk_buff_head skb_rxtstamp_queue;
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
 	struct sja1105_ptp_cmd cmd;
 	/* Serializes all operations on the PTP hardware clock */
 	struct mutex lock;
+	u64 ptpsyncts;
 };
 
 int sja1105_ptp_clock_register(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 45da162ba268..fef2c50cd3f6 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -458,6 +458,8 @@ static struct sja1105_regs sja1105et_regs = {
 	.rmii_ext_tx_clk = {0x100018, 0x10001F, 0x100026, 0x10002D, 0x100034},
 	.ptpegr_ts = {0xC0, 0xC2, 0xC4, 0xC6, 0xC8},
 	.ptpschtm = 0x12, /* Spans 0x12 to 0x13 */
+	.ptppinst = 0x14,
+	.ptppindur = 0x16,
 	.ptp_control = 0x17,
 	.ptpclkval = 0x18, /* Spans 0x18 to 0x19 */
 	.ptpclkrate = 0x1A,
@@ -491,10 +493,13 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.qlevel = {0x604, 0x614, 0x624, 0x634, 0x644},
 	.ptpegr_ts = {0xC0, 0xC4, 0xC8, 0xCC, 0xD0},
 	.ptpschtm = 0x13, /* Spans 0x13 to 0x14 */
+	.ptppinst = 0x15,
+	.ptppindur = 0x17,
 	.ptp_control = 0x18,
 	.ptpclkval = 0x19,
 	.ptpclkrate = 0x1B,
 	.ptpclkcorp = 0x1E,
+	.ptpsyncts = 0x1F,
 };
 
 struct sja1105_info sja1105e_info = {
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index fccc9c4d6b35..bbfe034910a0 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -108,6 +108,7 @@ size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
 	const size_t size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY;
 	struct sja1105_avb_params_entry *entry = entry_ptr;
 
+	sja1105_packing(buf, &entry->cas_master, 126, 126, size, op);
 	sja1105_packing(buf, &entry->destmeta,   125,  78, size, op);
 	sja1105_packing(buf, &entry->srcmeta,     77,  30, size, op);
 	return size;
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index f4a5c5c04311..8afafb6aef12 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -230,6 +230,7 @@ struct sja1105_l2_policing_entry {
 };
 
 struct sja1105_avb_params_entry {
+	u64 cas_master;
 	u64 destmeta;
 	u64 srcmeta;
 };
-- 
2.17.1

