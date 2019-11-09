Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE34F5EBF
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 12:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfKILdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 06:33:04 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34773 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfKILdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 06:33:04 -0500
Received: by mail-wm1-f65.google.com with SMTP id v3so9219548wmh.1
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 03:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=76I97ulel6GFS7SQHUmBknS1cMsxVD28fO1FUCW1LB4=;
        b=jTv0q0P23YDz5cQscs1+AULb2PGVmcDNp7MjeiMVM/C82Lz7wrnXZgVSN3pavYlcCR
         fHdhZTG+044m1WFmy4thw37wGCTo098bbM/pKnTjyeXhi+XNx+tlCmPLXomQog1NpWuF
         zCxmLn8MJ8BjUb7M7Ie3Le1Qk5kg/L8aHISxFGDc07XfMeORINJZPeBe3XJnZ+Qw8qyn
         en183sHYa8m7QNkCErYUgzoXAdxLHKjDkRxib4RUHFZn2T8+DlDP/NcGISrfae0xehXR
         AyhMfHwiLPctfa3Ek04oXsKD6CEvOTzTT9mYlFJFS825SRytMqoJJuA1deq7/ZlRfQ83
         BOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=76I97ulel6GFS7SQHUmBknS1cMsxVD28fO1FUCW1LB4=;
        b=r2Wk/dBihhsjp93FUQo1rgheGRzP4BPgGEgDAsqOz6YrcV3r971+sNHkpoOsHTaX+2
         YnsWoONK+NkrXo0f4YswvC3rrhQFs92A97ZfkPl74dnj1IXfd2HmLh7a5Pmm1lyDenjy
         AE2FxiuSwtzy75AAgVZf0jBFvMTnyj/AhNJYVlzDwafRyOnvdB8/ugkpCMwhDaRwpHV6
         k6AxCFEjIaXTBiFRiKYAseYOrWCu0cxYvxxmu3yVuSyxewbBLQ14/tlFxBx1mioYueN7
         kfsck8w8GWfT2YuDupULwLGcmiFbDdVdkm3C9WYOumCeJAKmaF3PIcZl5FQoLYPyixWq
         DCtg==
X-Gm-Message-State: APjAAAVhXT6xnlSxQnlHtTrqewg2hx/EaTBSyVUpGMycRRpdsj5mXjiQ
        uY/ll/70ZZ+arpmCgilL/Tw=
X-Google-Smtp-Source: APXvYqxJParjDBjB7ij+XItDUbBthfhu04hwpNBSrJCtooPooPsBWJf0otxHIgmwKG9YVknAh/aoKQ==
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr11898696wmi.107.1573299179599;
        Sat, 09 Nov 2019 03:32:59 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id w13sm8353512wrm.8.2019.11.09.03.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 03:32:59 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: sja1105: Restore PTP time after switch reset
Date:   Sat,  9 Nov 2019 13:32:23 +0200
Message-Id: <20191109113224.6495-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109113224.6495-1-olteanv@gmail.com>
References: <20191109113224.6495-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PTP time of the switch is not preserved when uploading a new static
configuration. Work around this hardware oddity by reading its PTP time
before a static config upload, and restoring it afterwards.

Static config changes are expected to occur at runtime even in scenarios
directly related to PTP, i.e. the Time-Aware Scheduler of the switch is
programmed in this way.

Perhaps the larger implication of this patch is that the PTP .gettimex64
and .settime functions need to be exposed to sja1105_main.c, where the
PTP lock needs to be held during this entire process. So their core
implementation needs to move to some common functions which get exposed
in sja1105_ptp.h.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 35 ++++++++++-
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 81 +++++++++++++++++++-------
 drivers/net/dsa/sja1105/sja1105_ptp.h  | 24 +++++++-
 drivers/net/dsa/sja1105/sja1105_spi.c  |  6 --
 4 files changed, 114 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d545edbbef9e..2b8919a25392 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1349,9 +1349,15 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
  */
 int sja1105_static_config_reload(struct sja1105_private *priv)
 {
+	struct ptp_system_timestamp ptp_sts_before;
+	struct ptp_system_timestamp ptp_sts_after;
 	struct sja1105_mac_config_entry *mac;
 	int speed_mbps[SJA1105_NUM_PORTS];
+	struct dsa_switch *ds = priv->ds;
+	s64 t1, t2, t3, t4;
+	s64 t12, t34;
 	int rc, i;
+	s64 now;
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
@@ -1365,10 +1371,37 @@ int sja1105_static_config_reload(struct sja1105_private *priv)
 		mac[i].speed = SJA1105_SPEED_AUTO;
 	}
 
+	/* No PTP operations can run right now */
+	mutex_lock(&priv->ptp_data.lock);
+
+	rc = __sja1105_ptp_gettimex(ds, &now, &ptp_sts_before);
+	if (rc < 0)
+		goto out_unlock_ptp;
+
 	/* Reset switch and send updated static configuration */
 	rc = sja1105_static_config_upload(priv);
 	if (rc < 0)
-		goto out;
+		goto out_unlock_ptp;
+
+	rc = __sja1105_ptp_settime(ds, 0, &ptp_sts_after);
+	if (rc < 0)
+		goto out_unlock_ptp;
+
+	t1 = timespec64_to_ns(&ptp_sts_before.pre_ts);
+	t2 = timespec64_to_ns(&ptp_sts_before.post_ts);
+	t3 = timespec64_to_ns(&ptp_sts_after.pre_ts);
+	t4 = timespec64_to_ns(&ptp_sts_after.post_ts);
+	/* Mid point, corresponds to pre-reset PTPCLKVAL */
+	t12 = t1 + (t2 - t1) / 2;
+	/* Mid point, corresponds to post-reset PTPCLKVAL, aka 0 */
+	t34 = t3 + (t4 - t3) / 2;
+	/* Advance PTPCLKVAL by the time it took since its readout */
+	now += (t34 - t12);
+
+	__sja1105_ptp_adjtime(ds, now);
+
+out_unlock_ptp:
+	mutex_unlock(&priv->ptp_data.lock);
 
 	/* Configure the CGU (PLLs) for MII and RMII PHYs.
 	 * For these interfaces there is no dynamic configuration
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index fac72af24baf..0a35813f9328 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -346,12 +346,13 @@ static int sja1105_ptpclkval_read(struct sja1105_private *priv, u64 *ticks,
 }
 
 /* Caller must hold ptp_data->lock */
-static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 ticks)
+static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 ticks,
+				   struct ptp_system_timestamp *ptp_sts)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 
 	return sja1105_xfer_u64(priv, SPI_WRITE, regs->ptpclkval, &ticks,
-				NULL);
+				ptp_sts);
 }
 
 #define rxtstamp_to_tagger(d) \
@@ -427,7 +428,7 @@ bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
 	return true;
 }
 
-int sja1105_ptp_reset(struct dsa_switch *ds)
+static int sja1105_ptp_reset(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
@@ -445,19 +446,38 @@ int sja1105_ptp_reset(struct dsa_switch *ds)
 	return rc;
 }
 
+/* Caller must hold ptp_data->lock */
+int __sja1105_ptp_gettimex(struct dsa_switch *ds, u64 *ns,
+			   struct ptp_system_timestamp *ptp_sts)
+{
+	struct sja1105_private *priv = ds->priv;
+	u64 ticks;
+	int rc;
+
+	rc = sja1105_ptpclkval_read(priv, &ticks, ptp_sts);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to read PTP clock: %d\n", rc);
+		return rc;
+	}
+
+	*ns = sja1105_ticks_to_ns(ticks);
+
+	return 0;
+}
+
 static int sja1105_ptp_gettimex(struct ptp_clock_info *ptp,
 				struct timespec64 *ts,
 				struct ptp_system_timestamp *ptp_sts)
 {
 	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
-	u64 ticks = 0;
+	u64 now = 0;
 	int rc;
 
 	mutex_lock(&ptp_data->lock);
 
-	rc = sja1105_ptpclkval_read(priv, &ticks, ptp_sts);
-	*ts = ns_to_timespec64(sja1105_ticks_to_ns(ticks));
+	rc = __sja1105_ptp_gettimex(priv->ds, &now, ptp_sts);
+	*ts = ns_to_timespec64(now);
 
 	mutex_unlock(&ptp_data->lock);
 
@@ -479,24 +499,34 @@ static int sja1105_ptp_mode_set(struct sja1105_private *priv,
 }
 
 /* Write to PTPCLKVAL while PTPCLKADD is 0 */
+int __sja1105_ptp_settime(struct dsa_switch *ds, u64 ns,
+			  struct ptp_system_timestamp *ptp_sts)
+{
+	struct sja1105_private *priv = ds->priv;
+	u64 ticks = ns_to_sja1105_ticks(ns);
+	int rc;
+
+	rc = sja1105_ptp_mode_set(priv, PTP_SET_MODE);
+	if (rc < 0) {
+		dev_err(priv->ds->dev, "Failed to put PTPCLK in set mode\n");
+		return rc;
+	}
+
+	return sja1105_ptpclkval_write(priv, ticks, ptp_sts);
+}
+
 static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
 			       const struct timespec64 *ts)
 {
 	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
-	u64 ticks = ns_to_sja1105_ticks(timespec64_to_ns(ts));
+	u64 ns = timespec64_to_ns(ts);
 	int rc;
 
 	mutex_lock(&ptp_data->lock);
 
-	rc = sja1105_ptp_mode_set(priv, PTP_SET_MODE);
-	if (rc < 0) {
-		dev_err(priv->ds->dev, "Failed to put PTPCLK in set mode\n");
-		goto out;
-	}
+	rc = __sja1105_ptp_settime(priv->ds, ns, NULL);
 
-	rc = sja1105_ptpclkval_write(priv, ticks);
-out:
 	mutex_unlock(&ptp_data->lock);
 
 	return rc;
@@ -530,24 +560,31 @@ static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 }
 
 /* Write to PTPCLKVAL while PTPCLKADD is 1 */
-static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+int __sja1105_ptp_adjtime(struct dsa_switch *ds, s64 delta)
 {
-	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
-	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
+	struct sja1105_private *priv = ds->priv;
 	s64 ticks = ns_to_sja1105_ticks(delta);
 	int rc;
 
-	mutex_lock(&ptp_data->lock);
-
 	rc = sja1105_ptp_mode_set(priv, PTP_ADD_MODE);
 	if (rc < 0) {
 		dev_err(priv->ds->dev, "Failed to put PTPCLK in add mode\n");
-		goto out;
+		return rc;
 	}
 
-	rc = sja1105_ptpclkval_write(priv, ticks);
+	return sja1105_ptpclkval_write(priv, ticks, NULL);
+}
+
+static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
+	int rc;
+
+	mutex_lock(&ptp_data->lock);
+
+	rc = __sja1105_ptp_adjtime(priv->ds, delta);
 
-out:
 	mutex_unlock(&ptp_data->lock);
 
 	return rc;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 243f130374d2..19e707db7e8c 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -51,8 +51,6 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
 			      struct sk_buff *clone);
 
-int sja1105_ptp_reset(struct dsa_switch *ds);
-
 bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 			   struct sk_buff *skb, unsigned int type);
 
@@ -63,6 +61,14 @@ int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 
 int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
 
+int __sja1105_ptp_gettimex(struct dsa_switch *ds, u64 *ns,
+			   struct ptp_system_timestamp *sts);
+
+int __sja1105_ptp_settime(struct dsa_switch *ds, u64 ns,
+			  struct ptp_system_timestamp *ptp_sts);
+
+int __sja1105_ptp_adjtime(struct dsa_switch *ds, s64 delta);
+
 #else
 
 struct sja1105_ptp_cmd;
@@ -87,7 +93,19 @@ static inline void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
 {
 }
 
-static inline int sja1105_ptp_reset(struct dsa_switch *ds)
+static inline int __sja1105_ptp_gettimex(struct dsa_switch *ds, u64 *ns,
+					 struct ptp_system_timestamp *sts)
+{
+	return 0;
+}
+
+static inline int __sja1105_ptp_settime(struct dsa_switch *ds, u64 ns,
+					struct ptp_system_timestamp *ptp_sts)
+{
+	return 0;
+}
+
+static inline int __sja1105_ptp_adjtime(struct dsa_switch *ds, s64 delta)
 {
 	return 0;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 691cd250e50a..cb48e77f63fd 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -511,12 +511,6 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 		dev_info(dev, "Succeeded after %d tried\n", RETRIES - retries);
 	}
 
-	rc = sja1105_ptp_reset(priv->ds);
-	if (rc < 0)
-		dev_err(dev, "Failed to reset PTP clock: %d\n", rc);
-
-	dev_info(dev, "Reset switch and programmed static config\n");
-
 out:
 	kfree(config_buf);
 	return rc;
-- 
2.17.1

