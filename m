Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F0ED4AD6
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 01:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfJKXSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 19:18:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54718 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbfJKXS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 19:18:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so11882053wmp.4
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 16:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uGHPtJS6pZUs6I0TsPU50P+LXYegB6Iw9qExmiLpeDM=;
        b=Xq/AiBRgZqcgJzk4COeoLnNUsMPNOMsqk6E4NmS4DH2tuZivh2emB9HZPEtTL3RiB1
         10n4xcYO6SFTD6BHEGRwsv9L+sG1/2TeGzq91pEnzNf7JvhDXFwtFl8b321vPeXgAJJP
         mmQOkeUtz/DX3EHZjh3Tyllk57lSm8ldkJSDNyS7gve4x5z0zEz9AM7cZ9tY9qTLUpKP
         sb2BB2EKNCXP5G348J+PyxqGJNmKG4666YyshYDE6zU5LhGVnGpbt3QBDJ0fcoR32o5a
         HDVCJD/cbmJj5EVVRUcOr/cmSEMj6co4vO0WHUCr98MhwPsWWgamiAI/vNxhTZlLDqza
         ve6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uGHPtJS6pZUs6I0TsPU50P+LXYegB6Iw9qExmiLpeDM=;
        b=dENJpgVoH3NiGzIqS50ZkBZhuhibt7D9JjO5orHY+b+lrSNrnimgcA7NA7vuMkNlNS
         Czlh2wBcjCaqPhyk4zBJEhhwtXVKW0TD2ZEQeoA9lGT5hh6VDH9H0jXBsJ7VtG4qgOB5
         1Qt4QMK+8nLU9DZcn3LwcodTiZC+qXw/xVD3qerBP3xwjpeIGI3BZpdlFtQ7WDzc3RjM
         w57ELU3lW4XCxnayxlyLL0WNG7E4TklNYsGhCixUBCxtMfEhc8o10oXsFy81Y8RsHdDN
         ctDtcV1kCP43kor30X7kGUD/NP24V8o65d8N5ahXgeR/qZbWaNMa0BxE39gqTQ6GIDqp
         kAyw==
X-Gm-Message-State: APjAAAWq7C4HSHx+M2gf6I6Eg26J7+c8ghPd0braplBI/49hhg775SNm
        XhxVLYnOrvMW44l2eYOL/PGKfhVH
X-Google-Smtp-Source: APXvYqxi538UX5/gNRgltNKAF5RxrjfjIap1Px8025+dFGMnoXkEEY94KVdJN4J6QGc4nklHgeanKA==
X-Received: by 2002:a1c:4986:: with SMTP id w128mr4771404wma.69.1570835906481;
        Fri, 11 Oct 2019 16:18:26 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id 207sm17425853wme.17.2019.10.11.16.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 16:18:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/4] net: dsa: sja1105: Make all public PTP functions take dsa_switch as argument
Date:   Sat, 12 Oct 2019 02:18:14 +0300
Message-Id: <20191011231816.7888-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011231816.7888-1-olteanv@gmail.com>
References: <20191011231816.7888-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new rule (as already started for sja1105_tas.h) is for functions of
optional driver components (ones which may be disabled via Kconfig - PTP
and TAS) to take struct dsa_switch *ds instead of struct sja1105_private
*priv as first argument.

This is so that forward-declarations of struct sja1105_private can be
avoided.

So make sja1105_ptp.h the second user of this rule.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  2 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 11 +++++-----
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 30 +++++++++++++++-----------
 drivers/net/dsa/sja1105/sja1105_ptp.h  | 28 +++++++++++-------------
 drivers/net/dsa/sja1105/sja1105_spi.c  |  2 +-
 5 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index e57b21639225..7ae655670bab 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -71,7 +71,7 @@ struct sja1105_info {
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
-	int (*ptp_cmd)(const void *ctx, const void *data);
+	int (*ptp_cmd)(const struct dsa_switch *ds, const void *data);
 	int (*reset_cmd)(const void *ctx, const void *data);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
 	/* Prototypes from include/net/dsa.h */
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 6ce46d7e971a..586974687ba2 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1686,7 +1686,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 		return rc;
 	}
 
-	rc = sja1105_ptp_clock_register(priv);
+	rc = sja1105_ptp_clock_register(ds);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to register PTP clock: %d\n", rc);
 		return rc;
@@ -1730,7 +1730,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	sja1105_tas_teardown(ds);
 	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
 	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
-	sja1105_ptp_clock_unregister(priv);
+	sja1105_ptp_clock_unregister(ds);
 	sja1105_static_config_free(&priv->static_config);
 }
 
@@ -1852,14 +1852,14 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 
 	now = priv->tstamp_cc.read(&priv->tstamp_cc);
 
-	rc = sja1105_ptpegr_ts_poll(priv, slot, &ts);
+	rc = sja1105_ptpegr_ts_poll(ds, slot, &ts);
 	if (rc < 0) {
 		dev_err(ds->dev, "xmit: timed out polling for tstamp\n");
 		kfree_skb(clone);
 		goto out_unlock_ptp;
 	}
 
-	ts = sja1105_tstamp_reconstruct(priv, now, ts);
+	ts = sja1105_tstamp_reconstruct(ds, now, ts);
 	ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
 
 	shwt.hwtstamp = ns_to_ktime(ts);
@@ -2002,6 +2002,7 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 {
 	struct sja1105_tagger_data *data = to_tagger(work);
 	struct sja1105_private *priv = to_sja1105(data);
+	struct dsa_switch *ds = priv->ds;
 	struct sk_buff *skb;
 	u64 now;
 
@@ -2016,7 +2017,7 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 		*shwt = (struct skb_shared_hwtstamps) {0};
 
 		ts = SJA1105_SKB_CB(skb)->meta_tstamp;
-		ts = sja1105_tstamp_reconstruct(priv, now, ts);
+		ts = sja1105_tstamp_reconstruct(ds, now, ts);
 		ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
 
 		shwt->hwtstamp = ns_to_ktime(ts);
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 6b0bfa0444a2..d9cae68d544c 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -78,10 +78,10 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-int sja1105et_ptp_cmd(const void *ctx, const void *data)
+int sja1105et_ptp_cmd(const struct dsa_switch *ds, const void *data)
 {
+	const struct sja1105_private *priv = ds->priv;
 	const struct sja1105_ptp_cmd *cmd = data;
-	const struct sja1105_private *priv = ctx;
 	const struct sja1105_regs *regs = priv->info->regs;
 	const int size = SJA1105_SIZE_PTP_CMD;
 	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
@@ -95,10 +95,10 @@ int sja1105et_ptp_cmd(const void *ctx, const void *data)
 				SJA1105_SIZE_PTP_CMD);
 }
 
-int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
+int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds, const void *data)
 {
+	const struct sja1105_private *priv = ds->priv;
 	const struct sja1105_ptp_cmd *cmd = data;
-	const struct sja1105_private *priv = ctx;
 	const struct sja1105_regs *regs = priv->info->regs;
 	const int size = SJA1105_SIZE_PTP_CMD;
 	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
@@ -126,9 +126,10 @@ int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
  * Must be called within one wraparound period of the partial timestamp since
  * it was generated by the MAC.
  */
-u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
+u64 sja1105_tstamp_reconstruct(struct dsa_switch *ds, u64 now,
 			       u64 ts_partial)
 {
+	struct sja1105_private *priv = ds->priv;
 	u64 partial_tstamp_mask = CYCLECOUNTER_MASK(priv->info->ptp_ts_bits);
 	u64 ts_reconstructed;
 
@@ -170,8 +171,9 @@ u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
  * To have common code for E/T and P/Q/R/S for reading the timestamp,
  * we need to juggle with the offset and the bit indices.
  */
-int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
+int sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts)
 {
+	struct sja1105_private *priv = ds->priv;
 	const struct sja1105_regs *regs = priv->info->regs;
 	int tstamp_bit_start, tstamp_bit_end;
 	int timeout = 10;
@@ -214,9 +216,9 @@ int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
 	return 0;
 }
 
-int sja1105_ptp_reset(struct sja1105_private *priv)
+int sja1105_ptp_reset(struct dsa_switch *ds)
 {
-	struct dsa_switch *ds = priv->ds;
+	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_cmd cmd = {0};
 	int rc;
 
@@ -224,7 +226,7 @@ int sja1105_ptp_reset(struct sja1105_private *priv)
 
 	cmd.resptp = 1;
 	dev_dbg(ds->dev, "Resetting PTP clock\n");
-	rc = priv->info->ptp_cmd(priv, &cmd);
+	rc = priv->info->ptp_cmd(ds, &cmd);
 
 	timecounter_init(&priv->tstamp_tc, &priv->tstamp_cc,
 			 ktime_to_ns(ktime_get_real()));
@@ -344,9 +346,9 @@ static void sja1105_ptp_overflow_check(struct work_struct *work)
 	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
 }
 
-int sja1105_ptp_clock_register(struct sja1105_private *priv)
+int sja1105_ptp_clock_register(struct dsa_switch *ds)
 {
-	struct dsa_switch *ds = priv->ds;
+	struct sja1105_private *priv = ds->priv;
 
 	/* Set up the cycle counter */
 	priv->tstamp_cc = (struct cyclecounter) {
@@ -374,11 +376,13 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv)
 	INIT_DELAYED_WORK(&priv->refresh_work, sja1105_ptp_overflow_check);
 	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
 
-	return sja1105_ptp_reset(priv);
+	return sja1105_ptp_reset(ds);
 }
 
-void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
+void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 {
+	struct sja1105_private *priv = ds->priv;
+
 	if (IS_ERR_OR_NULL(priv->clock))
 		return;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index af456b0a4d27..65d3d51da9ad 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -6,49 +6,45 @@
 
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
 
-int sja1105_ptp_clock_register(struct sja1105_private *priv);
+int sja1105_ptp_clock_register(struct dsa_switch *ds);
 
-void sja1105_ptp_clock_unregister(struct sja1105_private *priv);
+void sja1105_ptp_clock_unregister(struct dsa_switch *ds);
 
-int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts);
+int sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts);
 
-int sja1105et_ptp_cmd(const void *ctx, const void *data);
+int sja1105et_ptp_cmd(const struct dsa_switch *ds, const void *data);
 
-int sja1105pqrs_ptp_cmd(const void *ctx, const void *data);
+int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds, const void *data);
 
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *ts);
 
-u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
-			       u64 ts_partial);
+u64 sja1105_tstamp_reconstruct(struct dsa_switch *ds, u64 now, u64 ts_partial);
 
-int sja1105_ptp_reset(struct sja1105_private *priv);
+int sja1105_ptp_reset(struct dsa_switch *ds);
 
 #else
 
-static inline int sja1105_ptp_clock_register(struct sja1105_private *priv)
+static inline int sja1105_ptp_clock_register(struct dsa_switch *ds)
 {
 	return 0;
 }
 
-static inline void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
-{
-	return;
-}
+static inline void sja1105_ptp_clock_unregister(struct dsa_switch *ds) { }
 
 static inline int
-sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
+sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts)
 {
 	return 0;
 }
 
-static inline u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv,
+static inline u64 sja1105_tstamp_reconstruct(struct dsa_switch *ds,
 					     u64 now, u64 ts_partial)
 {
 	return 0;
 }
 
-static inline int sja1105_ptp_reset(struct sja1105_private *priv)
+static inline int sja1105_ptp_reset(struct dsa_switch *ds)
 {
 	return 0;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index d96379a8ecf5..e25724d99594 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -481,7 +481,7 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 		dev_info(dev, "Succeeded after %d tried\n", RETRIES - retries);
 	}
 
-	rc = sja1105_ptp_reset(priv);
+	rc = sja1105_ptp_reset(priv->ds);
 	if (rc < 0)
 		dev_err(dev, "Failed to reset PTP clock: %d\n", rc);
 
-- 
2.17.1

