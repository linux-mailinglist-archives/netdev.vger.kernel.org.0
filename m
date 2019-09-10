Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89BBAE1F3
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 03:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392422AbfIJBfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 21:35:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43518 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392385AbfIJBfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 21:35:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id q17so12009785wrx.10
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 18:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5mChRU/rF2LQTq5Fx7omhohJ4VJAISgDSJt0ZTXvcng=;
        b=uoU5+Wojy8ML7NTx+MF7gXbDRiLNq/2dcD8BGCLuPIkrN1vLSA9YKDG1aLo6R4B1Qu
         pKb1DfynWvC8eVya9A/RWH81X4HhWcz+WUjzqUBlczkNrIwBGTl8+AuNzGVInFcDfVpO
         eZPj4Tov8eAGambNIlLOb6iGS3CohG/iPeHSzt9sq6lHkE+Y5r94hvJgXPCUjkFRpekx
         FM1tdATReiQI7UFgH3l8ATo6PI5gNHE8ZWEi4TiJ/JiXfOtzWKtytpg+pXPuDdpFe7mR
         sRfOZP2HWasIhTTxSK0QSabXYTJDPFOECz6sYdAz+Eh5BpThXSjNeMJGqliSz9NOTjKj
         Oxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5mChRU/rF2LQTq5Fx7omhohJ4VJAISgDSJt0ZTXvcng=;
        b=Kl2UGPLXWIxMc5c+m3wLbCnzaD3iMDtYhFh4ybZdIECgqoqvHUIPEPcIabXJVc6tXW
         1wdsyFNOzKVtGP8BnRBY4gQKg7qruYzsNfm+x9S8jeiin0lGe7fpV3Jgj1DhwH3VOiCk
         qLYc4j/tIkn5jUFMqXBKer402kAnFUORJ/N/+DPIbMuOss3N0OTLgkAXWYeDZL8ZloEr
         X1bNApuhzgLKftIdCzDU36IPRS4B+JOjJZvm1BAQHCxCrgI1sTJxauMJCKEmaGlaiHGR
         n3mAAzNEWmxDKTuSEyKuay9c+2SEHiBi8C5yu8t1uv7j4VefBD0OrtXE9YYVyKsJIMtH
         2OZw==
X-Gm-Message-State: APjAAAWrJ7RH/wndxJWaL+DiKvYxI9gzLfeG5SyZZbp6PPDkuQy/0atC
        vncp9yQQ41rvRgk92dDnquo=
X-Google-Smtp-Source: APXvYqzbwakNP73vxdOeKpU9dJwi61H9tDbF6nrgIVgKVZkyWxNEug9QMS8oqjRM+/KBrgw3kJ+bvw==
X-Received: by 2002:a5d:4402:: with SMTP id z2mr22106234wrq.183.1568079341985;
        Mon, 09 Sep 2019 18:35:41 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id b1sm1254597wmj.4.2019.09.09.18.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 18:35:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 4/7] net: dsa: sja1105: Implement the .gettimex64 system call for PTP
Date:   Tue, 10 Sep 2019 04:34:58 +0300
Message-Id: <20190910013501.3262-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190910013501.3262-1-olteanv@gmail.com>
References: <20190910013501.3262-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Through the PTP_SYS_OFFSET_EXTENDED ioctl, it is possible for userspace
applications (i.e. phc2sys) to compensate for the delays incurred while
reading the PHC's time.

For now implement this ioctl in the driver, although the performance
improvements are minimal. The goal with this patch is to rework the
infrastructure in the driver for SPI transfers to be timestamped. Other
patches depend on this change.

The "performance" implementation of this ioctl will come later, once the
API in the SPI subsystem is agreed upon. The change in the sja1105
driver will be minimal then.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  3 ++-
 drivers/net/dsa/sja1105/sja1105_main.c |  8 +++---
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 20 ++++++++------
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  6 +++--
 drivers/net/dsa/sja1105/sja1105_spi.c  | 36 +++++++++++++++++++-------
 5 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index e4955a025e46..c80be59dafbd 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -131,7 +131,8 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 				void *packed_buf, size_t size_bytes);
 int sja1105_spi_send_int(const struct sja1105_private *priv,
 			 sja1105_spi_rw_mode_t rw, u64 reg_addr,
-			 u64 *value, u64 size_bytes);
+			 u64 *value, u64 size_bytes,
+			 struct ptp_system_timestamp *ptp_sts);
 int sja1105_spi_send_long_packed_buf(const struct sja1105_private *priv,
 				     sja1105_spi_rw_mode_t rw, u64 base_addr,
 				     void *packed_buf, u64 buf_len);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c92326871fec..b886e1a09dfb 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1849,7 +1849,7 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 
 	mutex_lock(&priv->ptp_lock);
 
-	ticks = sja1105_ptpclkval_read(priv);
+	ticks = sja1105_ptpclkval_read(priv, NULL);
 
 	rc = sja1105_ptpegr_ts_poll(priv, slot, &ts);
 	if (rc < 0) {
@@ -2002,7 +2002,7 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 
 	mutex_lock(&priv->ptp_lock);
 
-	ticks = sja1105_ptpclkval_read(priv);
+	ticks = sja1105_ptpclkval_read(priv, NULL);
 
 	while ((skb = skb_dequeue(&data->skb_rxtstamp_queue)) != NULL) {
 		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
@@ -2097,8 +2097,8 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 	u64 part_no;
 	int rc;
 
-	rc = sja1105_spi_send_int(priv, SPI_READ, regs->device_id,
-				  &device_id, SJA1105_SIZE_DEVICE_ID);
+	rc = sja1105_spi_send_int(priv, SPI_READ, regs->device_id, &device_id,
+				  SJA1105_SIZE_DEVICE_ID, NULL);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index bcdfdda46b9c..04693c702b09 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
+#include <linux/spi/spi.h>
 #include "sja1105.h"
 
 /* The adjfine API clamps ppb between [-32,768,000, 32,768,000], and
@@ -214,15 +215,16 @@ int sja1105_ptp_reset(struct sja1105_private *priv)
 	return rc;
 }
 
-static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
-			       struct timespec64 *ts)
+static int sja1105_ptp_gettimex(struct ptp_clock_info *ptp,
+				struct timespec64 *ts,
+				struct ptp_system_timestamp *sts)
 {
 	struct sja1105_private *priv = ptp_to_sja1105(ptp);
 	u64 ticks;
 
 	mutex_lock(&priv->ptp_lock);
 
-	ticks = sja1105_ptpclkval_read(priv);
+	ticks = sja1105_ptpclkval_read(priv, sts);
 	*ts = ns_to_timespec64(sja1105_ticks_to_ns(ticks));
 
 	mutex_unlock(&priv->ptp_lock);
@@ -247,7 +249,8 @@ static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 val)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 
-	return sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclk, &val, 8);
+	return sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclk, &val, 8,
+				    NULL);
 }
 
 /* Write to PTPCLKVAL while PTPCLKADD is 0 */
@@ -291,7 +294,7 @@ static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	mutex_lock(&priv->ptp_lock);
 
 	rc = sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclkrate,
-				  &clkrate, 4);
+				  &clkrate, 4, NULL);
 
 	mutex_unlock(&priv->ptp_lock);
 
@@ -299,14 +302,15 @@ static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 }
 
 /* Caller must hold priv->ptp_lock */
-u64 sja1105_ptpclkval_read(struct sja1105_private *priv)
+u64 sja1105_ptpclkval_read(struct sja1105_private *priv,
+			   struct ptp_system_timestamp *sts)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 	u64 ptpclkval = 0;
 	int rc;
 
 	rc = sja1105_spi_send_int(priv, SPI_READ, regs->ptpclk,
-				  &ptpclkval, 8);
+				  &ptpclkval, 8, sts);
 	if (rc < 0)
 		dev_err_ratelimited(priv->ds->dev,
 				    "failed to read ptp time: %d\n",
@@ -347,7 +351,7 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv)
 		.name		= "SJA1105 PHC",
 		.adjfine	= sja1105_ptp_adjfine,
 		.adjtime	= sja1105_ptp_adjtime,
-		.gettime64	= sja1105_ptp_gettime,
+		.gettimex64	= sja1105_ptp_gettimex,
 		.settime64	= sja1105_ptp_settime,
 		.max_adj	= SJA1105_MAX_ADJ_PPB,
 	};
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 51e21d951548..80c33e5e4503 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -39,7 +39,8 @@ u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
 
 int sja1105_ptp_reset(struct sja1105_private *priv);
 
-u64 sja1105_ptpclkval_read(struct sja1105_private *priv);
+u64 sja1105_ptpclkval_read(struct sja1105_private *priv,
+			   struct ptp_system_timestamp *sts);
 
 #else
 
@@ -70,7 +71,8 @@ static inline int sja1105_ptp_reset(struct sja1105_private *priv)
 	return 0;
 }
 
-static inline u64 sja1105_ptpclkval_read(struct sja1105_private *priv)
+static inline u64 sja1105_ptpclkval_read(struct sja1105_private *priv,
+					 struct ptp_system_timestamp *sts)
 {
 	return 0;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 1953d8c54af6..26985f1209ad 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -15,7 +15,8 @@
 	(SJA1105_SIZE_SPI_MSG_HEADER + SJA1105_SIZE_SPI_MSG_MAXLEN)
 
 static int sja1105_spi_transfer(const struct sja1105_private *priv,
-				const void *tx, void *rx, int size)
+				const void *tx, void *rx, int size,
+				struct ptp_system_timestamp *ptp_sts)
 {
 	struct spi_device *spi = priv->spidev;
 	struct spi_transfer transfer = {
@@ -35,12 +36,16 @@ static int sja1105_spi_transfer(const struct sja1105_private *priv,
 	spi_message_init(&msg);
 	spi_message_add_tail(&transfer, &msg);
 
+	ptp_read_system_prets(ptp_sts);
+
 	rc = spi_sync(spi, &msg);
 	if (rc < 0) {
 		dev_err(&spi->dev, "SPI transfer failed: %d\n", rc);
 		return rc;
 	}
 
+	ptp_read_system_postts(ptp_sts);
+
 	return rc;
 }
 
@@ -66,9 +71,11 @@ sja1105_spi_message_pack(void *buf, const struct sja1105_spi_message *msg)
  * @size_bytes is smaller than SIZE_SPI_MSG_MAXLEN. Larger packed buffers
  * are chunked in smaller pieces by sja1105_spi_send_long_packed_buf below.
  */
-int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
-				sja1105_spi_rw_mode_t rw, u64 reg_addr,
-				void *packed_buf, size_t size_bytes)
+static int
+__sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
+			      sja1105_spi_rw_mode_t rw, u64 reg_addr,
+			      void *packed_buf, size_t size_bytes,
+			      struct ptp_system_timestamp *ptp_sts)
 {
 	u8 tx_buf[SJA1105_SIZE_SPI_TRANSFER_MAX] = {0};
 	u8 rx_buf[SJA1105_SIZE_SPI_TRANSFER_MAX] = {0};
@@ -90,7 +97,7 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 		memcpy(tx_buf + SJA1105_SIZE_SPI_MSG_HEADER,
 		       packed_buf, size_bytes);
 
-	rc = sja1105_spi_transfer(priv, tx_buf, rx_buf, msg_len);
+	rc = sja1105_spi_transfer(priv, tx_buf, rx_buf, msg_len, ptp_sts);
 	if (rc < 0)
 		return rc;
 
@@ -101,6 +108,14 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 	return 0;
 }
 
+int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
+				sja1105_spi_rw_mode_t rw, u64 reg_addr,
+				void *packed_buf, size_t size_bytes)
+{
+	return __sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf,
+					     size_bytes, NULL);
+}
+
 /* If @rw is:
  * - SPI_WRITE: creates and sends an SPI write message at absolute
  *		address reg_addr, taking size_bytes from *packed_buf
@@ -114,7 +129,8 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
  */
 int sja1105_spi_send_int(const struct sja1105_private *priv,
 			 sja1105_spi_rw_mode_t rw, u64 reg_addr,
-			 u64 *value, u64 size_bytes)
+			 u64 *value, u64 size_bytes,
+			 struct ptp_system_timestamp *ptp_sts)
 {
 	u8 packed_buf[SJA1105_SIZE_SPI_MSG_MAXLEN];
 	int rc;
@@ -126,8 +142,8 @@ int sja1105_spi_send_int(const struct sja1105_private *priv,
 		sja1105_pack(packed_buf, value, 8 * size_bytes - 1, 0,
 			     size_bytes);
 
-	rc = sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf,
-					 size_bytes);
+	rc = __sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf,
+					   size_bytes, ptp_sts);
 
 	if (rw == SPI_READ)
 		sja1105_unpack(packed_buf, value, 8 * size_bytes - 1, 0,
@@ -291,7 +307,7 @@ int sja1105_inhibit_tx(const struct sja1105_private *priv,
 	int rc;
 
 	rc = sja1105_spi_send_int(priv, SPI_READ, regs->port_control,
-				  &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
+				  &inhibit_cmd, SJA1105_SIZE_PORT_CTRL, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -301,7 +317,7 @@ int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		inhibit_cmd &= ~port_bitmap;
 
 	return sja1105_spi_send_int(priv, SPI_WRITE, regs->port_control,
-				    &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
+				    &inhibit_cmd, SJA1105_SIZE_PORT_CTRL, NULL);
 }
 
 struct sja1105_status {
-- 
2.17.1

