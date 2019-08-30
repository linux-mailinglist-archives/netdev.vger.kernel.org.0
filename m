Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C66DA2BA5
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfH3Aq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:46:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42762 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfH3Aq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:46:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id b16so5178951wrq.9
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4KM1VoqrfvMIwtYD1uU4m6otb3Yxko8K5pGuKaNKqIM=;
        b=QwCw97wIzyJnb5SWEib83WdZ0eL7dXFl4b0rrEeiNkIYMy5xgf7q9NOt6w7H/OvRSQ
         OkDk4XnhSij0g/+C75Mgks7rQNSk9D0RZF8riIdnxRuh9AYxNoH0ibwcH6GXmw8Ex5sP
         mkNztepvv+sZRENRCyb9Mvs4O3b903W/xBxvIYrFcYNNYcFyJaqzAacOTLTxIHddaiwN
         nAdIlHj+9eW48VT7RaKt2uC8ssQuKpo75JghJ2VYVQ7unMT4Fvo3sLtsRnrwkPIYA+1j
         xniauNwsgJQ6Bi8ufjOFhYskOUthA2bIjRLa+HzsYs+ENgsw0EDgODxv243A8JJFFjRB
         PpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4KM1VoqrfvMIwtYD1uU4m6otb3Yxko8K5pGuKaNKqIM=;
        b=LPrUhfElulB5EhbEytgb7qIxwGHNFI22t2/Yb+M6icOkIoOjukPtjPWbzCYqlju8UP
         1QDqXbtLijlDeWb2NKNcem8i/Dl3Av8udHim7MRy1ZpEE6EpyTUc8HIrY6OYgBw6tMo+
         z7+Rq1ROblI8AaiFWqNHTo7pL5JoWzVzc8UKZa7Y/3TcWgXaIO4jQZKgqgeKuBJkemz9
         NLNb9CZ5xWN3ElaJ2Xh6QPUWreiDroCxlfAPthlo09jkquaQWSPA7JBflxPAgftSwP8m
         eEabX6M3GsiCqBjxHHxNq7xUDKkr+FCu5XA+yxjBcqCgOR1l25W2AYgZglCrPeJjvuq+
         uNZg==
X-Gm-Message-State: APjAAAUnel173471WK4ZS2L0ArhsNwUgDoysA4TsEIi5Kng6TRYbulOD
        wYRn1eNBeLl3EnioDalef1g=
X-Google-Smtp-Source: APXvYqwdrnRDKer/eclSfWaEW3xygD4Tlb1HABNhlnnxfsnwUSw8IM376wttNO2agG3NLsnZ7i+P1Q==
X-Received: by 2002:a5d:63c8:: with SMTP id c8mr9375394wrw.21.1567126017213;
        Thu, 29 Aug 2019 17:46:57 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:46:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 07/15] net: dsa: sja1105: Move PTP data to its own private structure
Date:   Fri, 30 Aug 2019 03:46:27 +0300
Message-Id: <20190830004635.24863-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce the size of the sja1105_private structure when
CONFIG_NET_DSA_SJA1105_PTP is not enabled. Also make the PTP code a
little bit more self-contained.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      | 20 +------
 drivers/net/dsa/sja1105/sja1105_main.c | 12 ++--
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 81 +++++++++++++++-----------
 drivers/net/dsa/sja1105/sja1105_ptp.h  | 29 +++++++++
 4 files changed, 84 insertions(+), 58 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index c80be59dafbd..3ca0b87aa3e4 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -20,6 +20,8 @@
  */
 #define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
 
+#include "sja1105_ptp.h"
+
 /* Keeps the different addresses between E/T and P/Q/R/S */
 struct sja1105_regs {
 	u64 device_id;
@@ -49,17 +51,6 @@ struct sja1105_regs {
 	u64 qlevel[SJA1105_NUM_PORTS];
 };
 
-enum sja1105_ptp_clk_mode {
-	PTP_ADD_MODE = 1,
-	PTP_SET_MODE = 0,
-};
-
-struct sja1105_ptp_cmd {
-	u64 resptp;		/* reset */
-	u64 corrclk4ts;		/* use the corrected clock for timestamps */
-	u64 ptpclkadd;		/* enum sja1105_ptp_clk_mode */
-};
-
 struct sja1105_info {
 	u64 device_id;
 	/* Needed for distinction between P and R, and between Q and S
@@ -99,20 +90,15 @@ struct sja1105_private {
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
-	struct sja1105_ptp_cmd ptp_cmd;
-	struct ptp_clock_info ptp_caps;
-	struct ptp_clock *clock;
-	/* Serializes all operations on the PTP hardware clock */
-	struct mutex ptp_lock;
 	/* Serializes transmission of management frames so that
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
 	struct sja1105_tagger_data tagger_data;
+	struct sja1105_ptp_data ptp_data;
 };
 
 #include "sja1105_dynamic_config.h"
-#include "sja1105_ptp.h"
 
 struct sja1105_spi_message {
 	u64 access;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d92f15b3aea9..670c069722d5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1406,7 +1406,7 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 	}
 
 	/* No PTP operations can run right now */
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&priv->ptp_data.lock);
 
 	ptpclkval = __sja1105_ptp_gettimex(priv, &ptp_sts_before);
 
@@ -1433,7 +1433,7 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 	__sja1105_ptp_adjtime(priv, ptpclkval);
 
 out_unlock_ptp:
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&priv->ptp_data.lock);
 
 	/* Configure the CGU (PLLs) for MII and RMII PHYs.
 	 * For these interfaces there is no dynamic configuration
@@ -1876,7 +1876,7 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 
 	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
 
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&priv->ptp_data.lock);
 
 	ticks = sja1105_ptpclkval_read(priv, NULL);
 
@@ -1893,7 +1893,7 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 	skb_complete_tx_timestamp(clone, &shwt);
 
 out_unlock_ptp:
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&priv->ptp_data.lock);
 out:
 	mutex_unlock(&priv->mgmt_lock);
 	return NETDEV_TX_OK;
@@ -2029,7 +2029,7 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 	struct sk_buff *skb;
 	u64 ticks;
 
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&priv->ptp_data.lock);
 
 	ticks = sja1105_ptpclkval_read(priv, NULL);
 
@@ -2046,7 +2046,7 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 		netif_rx_ni(skb);
 	}
 
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&priv->ptp_data.lock);
 }
 
 /* Called from dsa_skb_defer_rx_timestamp */
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index a7722c0944fb..f85f44bdab31 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -34,7 +34,10 @@
 #define SJA1105_CC_MULT_DEM		15625
 #define SJA1105_CC_MULT			0x80000000
 
-#define ptp_to_sja1105(d) container_of((d), struct sja1105_private, ptp_caps)
+#define ptp_to_sja1105_data(d) \
+		container_of((d), struct sja1105_ptp_data, caps)
+#define ptp_data_to_sja1105(d) \
+		container_of((d), struct sja1105_private, ptp_data)
 
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *info)
@@ -42,7 +45,7 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 	struct sja1105_private *priv = ds->priv;
 
 	/* Called during cleanup */
-	if (!priv->clock)
+	if (!priv->ptp_data.clock)
 		return -ENODEV;
 
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
@@ -52,7 +55,7 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			 (1 << HWTSTAMP_TX_ON);
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
 			   (1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT);
-	info->phc_index = ptp_clock_index(priv->clock);
+	info->phc_index = ptp_clock_index(priv->ptp_data.clock);
 	return 0;
 }
 
@@ -200,22 +203,23 @@ int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
 
 int sja1105_ptp_reset(struct sja1105_private *priv)
 {
-	struct sja1105_ptp_cmd cmd = priv->ptp_cmd;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	struct sja1105_ptp_cmd cmd = ptp_data->cmd;
 	int rc;
 
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&ptp_data->lock);
 
 	cmd.resptp = 1;
 
 	dev_dbg(priv->ds->dev, "Resetting PTP clock\n");
 	rc = priv->info->ptp_cmd(priv, &cmd);
 
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&ptp_data->lock);
 
 	return rc;
 }
 
-/* Caller must hold priv->ptp_lock */
+/* Caller must hold priv->ptp_data.lock */
 u64 __sja1105_ptp_gettimex(struct sja1105_private *priv,
 			   struct ptp_system_timestamp *sts)
 {
@@ -230,30 +234,31 @@ static int sja1105_ptp_gettimex(struct ptp_clock_info *ptp,
 				struct timespec64 *ts,
 				struct ptp_system_timestamp *sts)
 {
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	struct sja1105_ptp_data *ptp_data = ptp_to_sja1105_data(ptp);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
 
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&ptp_data->lock);
 
 	*ts = ns_to_timespec64(__sja1105_ptp_gettimex(priv, sts));
 
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&ptp_data->lock);
 
 	return 0;
 }
 
-/* Caller must hold priv->ptp_lock */
+/* Caller must hold priv->ptp_data.lock */
 static int sja1105_ptp_mode_set(struct sja1105_private *priv,
 				enum sja1105_ptp_clk_mode mode)
 {
-	if (priv->ptp_cmd.ptpclkadd == mode)
+	if (priv->ptp_data.cmd.ptpclkadd == mode)
 		return 0;
 
-	priv->ptp_cmd.ptpclkadd = mode;
+	priv->ptp_data.cmd.ptpclkadd = mode;
 
-	return priv->info->ptp_cmd(priv, &priv->ptp_cmd);
+	return priv->info->ptp_cmd(priv, &priv->ptp_data.cmd);
 }
 
-/* Caller must hold priv->ptp_lock */
+/* Caller must hold priv->ptp_data.lock */
 static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 val,
 				   struct ptp_system_timestamp *ptp_sts)
 {
@@ -282,22 +287,24 @@ int __sja1105_ptp_settime(struct sja1105_private *priv, u64 ns,
 static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
 			       const struct timespec64 *ts)
 {
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	struct sja1105_ptp_data *ptp_data = ptp_to_sja1105_data(ptp);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
 	u64 ns = timespec64_to_ns(ts);
 	int rc;
 
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&ptp_data->lock);
 
 	rc = __sja1105_ptp_settime(priv, ns, NULL);
 
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&ptp_data->lock);
 
 	return rc;
 }
 
 static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	struct sja1105_ptp_data *ptp_data = ptp_to_sja1105_data(ptp);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
 	const struct sja1105_regs *regs = priv->info->regs;
 	s64 clkrate;
 	int rc;
@@ -309,17 +316,17 @@ static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	clkrate = SJA1105_CC_MULT + clkrate;
 	clkrate &= GENMASK_ULL(31, 0);
 
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&priv->ptp_data.lock);
 
 	rc = sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclkrate,
 				  &clkrate, 4, NULL);
 
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&priv->ptp_data.lock);
 
 	return rc;
 }
 
-/* Caller must hold priv->ptp_lock */
+/* Caller must hold priv->ptp_data.lock */
 u64 sja1105_ptpclkval_read(struct sja1105_private *priv,
 			   struct ptp_system_timestamp *sts)
 {
@@ -354,23 +361,25 @@ int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta)
 
 static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	struct sja1105_ptp_data *ptp_data = ptp_to_sja1105_data(ptp);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
 	int rc;
 
-	mutex_lock(&priv->ptp_lock);
+	mutex_lock(&ptp_data->lock);
 
 	rc = __sja1105_ptp_adjtime(priv, delta);
 
-	mutex_unlock(&priv->ptp_lock);
+	mutex_unlock(&ptp_data->lock);
 
 	return rc;
 }
 
 int sja1105_ptp_clock_register(struct sja1105_private *priv)
 {
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct dsa_switch *ds = priv->ds;
 
-	priv->ptp_caps = (struct ptp_clock_info) {
+	ptp_data->caps = (struct ptp_clock_info) {
 		.owner		= THIS_MODULE,
 		.name		= "SJA1105 PHC",
 		.adjfine	= sja1105_ptp_adjfine,
@@ -380,23 +389,25 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv)
 		.max_adj	= SJA1105_MAX_ADJ_PPB,
 	};
 
-	mutex_init(&priv->ptp_lock);
+	mutex_init(&ptp_data->lock);
 
-	priv->clock = ptp_clock_register(&priv->ptp_caps, ds->dev);
-	if (IS_ERR_OR_NULL(priv->clock))
-		return PTR_ERR(priv->clock);
+	ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
+	if (IS_ERR_OR_NULL(ptp_data->clock))
+		return PTR_ERR(ptp_data->clock);
 
-	priv->ptp_cmd.corrclk4ts = true;
-	priv->ptp_cmd.ptpclkadd = PTP_SET_MODE;
+	ptp_data->cmd.corrclk4ts = true;
+	ptp_data->cmd.ptpclkadd = PTP_SET_MODE;
 
 	return sja1105_ptp_reset(priv);
 }
 
 void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
 {
-	if (IS_ERR_OR_NULL(priv->clock))
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+
+	if (IS_ERR_OR_NULL(ptp_data->clock))
 		return;
 
-	ptp_clock_unregister(priv->clock);
-	priv->clock = NULL;
+	ptp_clock_unregister(ptp_data->clock);
+	ptp_data->clock = NULL;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index c699611e585d..dfe856200394 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -19,8 +19,29 @@ static inline s64 sja1105_ticks_to_ns(s64 ticks)
 	return ticks * SJA1105_TICK_NS;
 }
 
+struct sja1105_private;
+
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
 
+enum sja1105_ptp_clk_mode {
+	PTP_ADD_MODE = 1,
+	PTP_SET_MODE = 0,
+};
+
+struct sja1105_ptp_cmd {
+	u64 resptp;		/* reset */
+	u64 corrclk4ts;		/* use the corrected clock for timestamps */
+	u64 ptpclkadd;		/* enum sja1105_ptp_clk_mode */
+};
+
+struct sja1105_ptp_data {
+	struct sja1105_ptp_cmd cmd;
+	struct ptp_clock_info caps;
+	struct ptp_clock *clock;
+	/* Serializes all operations on the PTP hardware clock */
+	struct mutex lock;
+};
+
 int sja1105_ptp_clock_register(struct sja1105_private *priv);
 
 void sja1105_ptp_clock_unregister(struct sja1105_private *priv);
@@ -52,6 +73,14 @@ int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta);
 
 #else
 
+/* Structures cannot be empty in C. Bah!
+ * Keep the mutex as the only element, which is a bit more difficult to
+ * refactor out of sja1105_main.c anyway.
+ */
+struct sja1105_ptp_data {
+	struct mutex lock;
+};
+
 static inline int sja1105_ptp_clock_register(struct sja1105_private *priv)
 {
 	return 0;
-- 
2.17.1

