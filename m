Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBC9A2B9C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfH3ArA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:47:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46853 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbfH3Aq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:46:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id h7so3867725wrt.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bHjssYXNt7YExpDa379zkscq2PtpufAIzUFeKm02Xec=;
        b=P41xQBrc5LE6KRxFAbQQ9knw64u99udZm28FYlT69HJlitUkusB8RrOmeGNZfwxiqJ
         TaHbPw8fMaMN7tZGTlU6AyUyvaUTQcqJjKEPMpFHd2v1VW0xB/FWgaZVaOu7AWLb5yvc
         ZqB4+SEPzTeYTqqb6oU/8QHDTqQcbhtcAqU+vr8MP1MtVPbbsyiGxBJGg0TNdMUnNLKE
         Gdmz3cid6k/JxnLeeybLemhZoaL4A1q4tJxpSz0B1TpBmbhp7FGypvyMpOk3gNIL9j9S
         tq6LkrDJJ1lezQJqtjypIrsAmOSKQeG6a/UUfmx53ErPOevmzen71vnlZwhUsVMmWi8q
         BKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bHjssYXNt7YExpDa379zkscq2PtpufAIzUFeKm02Xec=;
        b=Un/X1FhyMEOfaaL/HGL03fv3cALyKc64ydlgTBb76hJpQ1j5vrn+d/zvf0s/XZTbBa
         G0ElXkLRniz5SIZFs+8Z+li5RTvGVAC8m4IuJMUj58MevqYClkya/vHQfdzfmcShQqmL
         +9+8w8UjBHSaGlLz8jDgpbasQZoX7PeSvHLIl1pnlxa3kog7ezedDRri+MueI8/CilK1
         5WPy8BxRomYcvh5N3NpNyh7KxVvyRCf1eStJ8pO0mchQDwYxatb8yKyTJ0l0QKS7iBtf
         XqFuIWnyvcIIAjWEckwz/+pVaym824OsCopPCyiMrL1CaT/VnYxEi1NgKCzD/jEKXO46
         UPxg==
X-Gm-Message-State: APjAAAU6hazWDGtep3hFthDTbvM+EbHakIdxLzzfTVSbRQ7jeY8fPmY8
        FjFa3HiMcSp+KTM1CoIRHsU=
X-Google-Smtp-Source: APXvYqyyQzEilZbRkitzgBJTzaIui//LmVdddLAoKjQ8Ezok5b6jXWTXYjw5avE+DgqJTgvhX8+yDg==
X-Received: by 2002:adf:b612:: with SMTP id f18mr12926315wre.97.1567126014440;
        Thu, 29 Aug 2019 17:46:54 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:46:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 05/15] net: dsa: sja1105: Restore PTP time after switch reset
Date:   Fri, 30 Aug 2019 03:46:25 +0300
Message-Id: <20190830004635.24863-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
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

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 32 ++++++++++++-
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 66 ++++++++++++++++++--------
 drivers/net/dsa/sja1105/sja1105_ptp.h  | 25 ++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c  |  4 --
 4 files changed, 101 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f7f03d486499..abb22f0a9884 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1382,8 +1382,13 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
  */
 static int sja1105_static_config_reload(struct sja1105_private *priv)
 {
+	struct ptp_system_timestamp ptp_sts_before;
+	struct ptp_system_timestamp ptp_sts_after;
 	struct sja1105_mac_config_entry *mac;
 	int speed_mbps[SJA1105_NUM_PORTS];
+	s64 t1, t2, t3, t4;
+	s64 ptpclkval;
+	s64 t12, t34;
 	int rc, i;
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
@@ -1398,10 +1403,35 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 		mac[i].speed = SJA1105_SPEED_AUTO;
 	}
 
+	/* No PTP operations can run right now */
+	mutex_lock(&priv->ptp_lock);
+
+	ptpclkval = __sja1105_ptp_gettimex(priv, &ptp_sts_before);
+
 	/* Reset switch and send updated static configuration */
 	rc = sja1105_static_config_upload(priv);
 	if (rc < 0)
-		goto out;
+		goto out_unlock_ptp;
+
+	rc = __sja1105_ptp_settime(priv, 0, &ptp_sts_after);
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
+	ptpclkval += (t34 - t12);
+
+	__sja1105_ptp_adjtime(priv, ptpclkval);
+
+out_unlock_ptp:
+	mutex_unlock(&priv->ptp_lock);
 
 	/* Configure the CGU (PLLs) for MII and RMII PHYs.
 	 * For these interfaces there is no dynamic configuration
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 04693c702b09..a7722c0944fb 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -215,17 +215,26 @@ int sja1105_ptp_reset(struct sja1105_private *priv)
 	return rc;
 }
 
+/* Caller must hold priv->ptp_lock */
+u64 __sja1105_ptp_gettimex(struct sja1105_private *priv,
+			   struct ptp_system_timestamp *sts)
+{
+	u64 ticks;
+
+	ticks = sja1105_ptpclkval_read(priv, sts);
+
+	return sja1105_ticks_to_ns(ticks);
+}
+
 static int sja1105_ptp_gettimex(struct ptp_clock_info *ptp,
 				struct timespec64 *ts,
 				struct ptp_system_timestamp *sts)
 {
 	struct sja1105_private *priv = ptp_to_sja1105(ptp);
-	u64 ticks;
 
 	mutex_lock(&priv->ptp_lock);
 
-	ticks = sja1105_ptpclkval_read(priv, sts);
-	*ts = ns_to_timespec64(sja1105_ticks_to_ns(ticks));
+	*ts = ns_to_timespec64(__sja1105_ptp_gettimex(priv, sts));
 
 	mutex_unlock(&priv->ptp_lock);
 
@@ -245,33 +254,42 @@ static int sja1105_ptp_mode_set(struct sja1105_private *priv,
 }
 
 /* Caller must hold priv->ptp_lock */
-static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 val)
+static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 val,
+				   struct ptp_system_timestamp *ptp_sts)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 
 	return sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclk, &val, 8,
-				    NULL);
+				    ptp_sts);
 }
 
 /* Write to PTPCLKVAL while PTPCLKADD is 0 */
-static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
-			       const struct timespec64 *ts)
+int __sja1105_ptp_settime(struct sja1105_private *priv, u64 ns,
+			  struct ptp_system_timestamp *ptp_sts)
 {
-	u64 ticks = ns_to_sja1105_ticks(timespec64_to_ns(ts));
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	u64 ticks = ns_to_sja1105_ticks(ns);
 	int rc;
 
-	mutex_lock(&priv->ptp_lock);
-
 	rc = sja1105_ptp_mode_set(priv, PTP_SET_MODE);
 	if (rc < 0) {
 		dev_err(priv->ds->dev, "Failed to put PTPCLK in set mode\n");
-		goto out;
+		return rc;
 	}
 
-	rc = sja1105_ptpclkval_write(priv, ticks);
+	return sja1105_ptpclkval_write(priv, ticks, ptp_sts);
+}
+
+static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
+			       const struct timespec64 *ts)
+{
+	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	u64 ns = timespec64_to_ns(ts);
+	int rc;
+
+	mutex_lock(&priv->ptp_lock);
+
+	rc = __sja1105_ptp_settime(priv, ns, NULL);
 
-out:
 	mutex_unlock(&priv->ptp_lock);
 
 	return rc;
@@ -320,23 +338,29 @@ u64 sja1105_ptpclkval_read(struct sja1105_private *priv,
 }
 
 /* Write to PTPCLKVAL while PTPCLKADD is 1 */
-static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta)
 {
-	struct sja1105_private *priv = ptp_to_sja1105(ptp);
 	s64 ticks = ns_to_sja1105_ticks(delta);
 	int rc;
 
-	mutex_lock(&priv->ptp_lock);
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
+	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	int rc;
+
+	mutex_lock(&priv->ptp_lock);
+
+	rc = __sja1105_ptp_adjtime(priv, delta);
 
-out:
 	mutex_unlock(&priv->ptp_lock);
 
 	return rc;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 80c33e5e4503..c699611e585d 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -42,6 +42,14 @@ int sja1105_ptp_reset(struct sja1105_private *priv);
 u64 sja1105_ptpclkval_read(struct sja1105_private *priv,
 			   struct ptp_system_timestamp *sts);
 
+u64 __sja1105_ptp_gettimex(struct sja1105_private *priv,
+			   struct ptp_system_timestamp *sts);
+
+int __sja1105_ptp_settime(struct sja1105_private *priv, u64 ns,
+			  struct ptp_system_timestamp *ptp_sts);
+
+int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta);
+
 #else
 
 static inline int sja1105_ptp_clock_register(struct sja1105_private *priv)
@@ -77,6 +85,23 @@ static inline u64 sja1105_ptpclkval_read(struct sja1105_private *priv,
 	return 0;
 }
 
+static inline u64 __sja1105_ptp_gettimex(struct sja1105_private *priv,
+					 struct ptp_system_timestamp *sts)
+{
+	return 0;
+}
+
+static inline int __sja1105_ptp_settime(struct sja1105_private *priv, u64 ns,
+					struct ptp_system_timestamp *ptp_sts)
+{
+	return 0;
+}
+
+static inline int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta)
+{
+	return 0;
+}
+
 #define sja1105et_ptp_cmd NULL
 
 #define sja1105pqrs_ptp_cmd NULL
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 26985f1209ad..eae9c9baa189 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -496,10 +496,6 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 		dev_info(dev, "Succeeded after %d tried\n", RETRIES - retries);
 	}
 
-	rc = sja1105_ptp_reset(priv);
-	if (rc < 0)
-		dev_err(dev, "Failed to reset PTP clock: %d\n", rc);
-
 	dev_info(dev, "Reset switch and programmed static config\n");
 
 out:
-- 
2.17.1

