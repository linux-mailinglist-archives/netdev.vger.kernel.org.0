Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520FE8F80A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfHPApI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52138 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfHPApH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so2701238wma.1;
        Thu, 15 Aug 2019 17:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ptw/bFFXN1S9W/svdOMo/Pn4s5Bj9SUxy0+JBY/UKjA=;
        b=AOC8tqkkwCFQy4BU/226QPyEuP1Sw4Y/8Qp8oLYprNuvv1ALmWwV8iVXurVF8Mqh+4
         XpMwBCxh3lQnbF2E3ibL+31BAiRJK/HaOs1hZzj7V95TUDNQeGK80BA49YJ7shJmQCtO
         Ka4mQ9Gv2R2QV5sX3JA3BHOrSUkGzo5Q5SL1yHTOtw5ixAhCZW9ne9GE24cHvjpga75o
         BolLGPv7wXYuXJvaXxeDr3u44LYi80aLv9/oc6/eekg3oFJ+mi8fw56vIwCDzb/BlEso
         D1EYXri3G4wWgt+NVPYGdW65YPyp4TkMaDqllywXZcszvJUeuyX9zrluTV9cPHX6b6GE
         vM0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ptw/bFFXN1S9W/svdOMo/Pn4s5Bj9SUxy0+JBY/UKjA=;
        b=hFtQBH3wutA3leZAslnIQqbSizMaoGJL/dYvLWdPVzV7XRCgPSR52xi0n5vXGUNH57
         pgTkJ48EXoMPizhCug5yVFuUHv+n4zr7j6yhFYaGtyp9MipjdekcmwcXUJP9aMFEI1hi
         xDmRQFFOAcyU1FkCGTQkxrNlzI8J+AKRwc4W8EqeOXkdMBjjnKeFQu7alhUYjVkw7asd
         J536Y26Rcllg2IBdjsu5VGwaRFsr69XpC1Tijj5X4oiPc7XXRCB+NHte5fxZVp6gPhnE
         UrebyTEmzqHg+4q15XiRliMX6yuwmFSjBJrg5OM/2fDwf1Iyvg5dwDCLb9mWZE8Qa+zx
         s0/A==
X-Gm-Message-State: APjAAAVQNiavYjlZYtM75V2OSHyaEv3EPwRtk4BfFmi7a9rUX9806FtY
        w0WRIyyl8NssoAnEB1wmAVo=
X-Google-Smtp-Source: APXvYqwS6NO2z+9iL+cHk2tKKmALE53f0U74HpnDoOpHY/Hnayp+blMn3FuWEwbkvBIfdvinkG8NCQ==
X-Received: by 2002:a7b:c3d0:: with SMTP id t16mr4982084wmj.25.1565916304117;
        Thu, 15 Aug 2019 17:45:04 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 02/11] net: dsa: sja1105: Implement the .gettimex64 system call for PTP
Date:   Fri, 16 Aug 2019 03:44:40 +0300
Message-Id: <20190816004449.10100-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Through the PTP_SYS_OFFSET_EXTENDED ioctl, it is possible for userspace
applications (i.e. phc2sys) to compensate for the delays incurred while
reading the PHC's time.

Implement this ioctl by passing the PTP system timestamp to the switch's
SPI controller driver.

The 'read PTP time' message is a 12 byte structure, first 4 bytes of
which represent the SPI header, and the last 8 bytes represent the
64-bit PTP time. The switch itself starts processing the command
immediately after receiving the last bit of the address, i.e. at the
middle of byte 3 (last byte of header). The PTP time is shadowed to a
buffer register in the switch, and retrieved atomically during the
subsequent SPI frames.

As such, specify to the SPI controller that we want byte 3 to be the one
that gets software-timestamped.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  4 ++-
 drivers/net/dsa/sja1105/sja1105_main.c |  4 +--
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 21 ++++++++++------
 drivers/net/dsa/sja1105/sja1105_spi.c  | 34 ++++++++++++++++++--------
 4 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index e6371b2c2df1..18c4f2f808e4 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -93,6 +93,7 @@ struct sja1105_private {
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
+	struct ptp_system_timestamp *ptp_sts;
 	struct ptp_clock_info ptp_caps;
 	struct ptp_clock *clock;
 	/* The cycle counter translates the PTP timestamps (based on
@@ -136,7 +137,8 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
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
index 82bdc2da8f8f..c4df2cef89cd 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2100,8 +2100,8 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 	u64 part_no;
 	int rc;
 
-	rc = sja1105_spi_send_int(priv, SPI_READ, regs->device_id,
-				  &device_id, SJA1105_SIZE_DEVICE_ID);
+	rc = sja1105_spi_send_int(priv, SPI_READ, regs->device_id, &device_id,
+				  SJA1105_SIZE_DEVICE_ID, NULL);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 51a0014369fc..ee7d1065d745 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
+#include <linux/spi/spi.h>
 #include "sja1105.h"
 
 /* The adjfine API clamps ppb between [-32,768,000, 32,768,000], and
@@ -262,14 +263,17 @@ int sja1105_ptp_reset(struct sja1105_private *priv)
 	return rc;
 }
 
-static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
-			       struct timespec64 *ts)
+static int sja1105_ptp_gettimex(struct ptp_clock_info *ptp,
+				struct timespec64 *ts,
+				struct ptp_system_timestamp *sts)
 {
 	struct sja1105_private *priv = ptp_to_sja1105(ptp);
 	u64 ns;
 
 	mutex_lock(&priv->ptp_lock);
+	priv->ptp_sts = sts;
 	ns = timecounter_read(&priv->tstamp_tc);
+	priv->ptp_sts = NULL;
 	mutex_unlock(&priv->ptp_lock);
 
 	*ts = ns_to_timespec64(ns);
@@ -355,7 +359,7 @@ static u64 sja1105_ptptsclk_read(const struct cyclecounter *cc)
 
 	sja1105_debug_gpio(priv, 1);
 	rc = sja1105_spi_send_int(priv, SPI_READ, regs->ptptsclk,
-				  &ptptsclk, 8);
+				  &ptptsclk, 8, priv->ptp_sts);
 	sja1105_debug_gpio(priv, 0);
 	if (rc < 0)
 		dev_err_ratelimited(priv->ds->dev,
@@ -368,9 +372,10 @@ static void sja1105_ptp_overflow_check(struct work_struct *work)
 {
 	struct delayed_work *dw = to_delayed_work(work);
 	struct sja1105_private *priv = rw_to_sja1105(dw);
+	struct ptp_system_timestamp dummy;
 	struct timespec64 ts;
 
-	sja1105_ptp_gettime(&priv->ptp_caps, &ts);
+	sja1105_ptp_gettimex(&priv->ptp_caps, &ts, &dummy);
 
 	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
 }
@@ -387,7 +392,7 @@ static void sja1105_ptp_extts_work(struct work_struct *work)
 	mutex_lock(&priv->ptp_lock);
 
 	rc = sja1105_spi_send_int(priv, SPI_READ, regs->ptpsyncts,
-				  &ptpsyncts, 8);
+				  &ptpsyncts, 8, NULL);
 	if (rc < 0)
 		dev_err(priv->ds->dev, "Failed to read PTPSYNCTS: %d\n", rc);
 
@@ -433,12 +438,12 @@ static int sja1105_pps_enable(struct sja1105_private *priv, bool on)
 		ptp_pin_duration = SJA1105_HZ_TO_PIN_DURATION(1);
 
 		rc = sja1105_spi_send_int(priv, SPI_WRITE, regs->ptppinst,
-					  &ptp_pin_start, 8);
+					  &ptp_pin_start, 8, NULL);
 		if (rc < 0)
 			return rc;
 
 		rc = sja1105_spi_send_int(priv, SPI_WRITE, regs->ptppindur,
-					  &ptp_pin_duration, 4);
+					  &ptp_pin_duration, 4, NULL);
 		if (rc < 0)
 			return rc;
 	}
@@ -500,7 +505,7 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv)
 		.name		= "SJA1105 PHC",
 		.adjfine	= sja1105_ptp_adjfine,
 		.adjtime	= sja1105_ptp_adjtime,
-		.gettime64	= sja1105_ptp_gettime,
+		.gettimex64	= sja1105_ptp_gettimex,
 		.settime64	= sja1105_ptp_settime,
 		.enable		= sja1105_ptp_enable,
 		.max_adj	= SJA1105_MAX_ADJ_PPB,
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index e33c85569882..a3486a40e0fb 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -15,10 +15,13 @@
 	(SJA1105_SIZE_SPI_MSG_HEADER + SJA1105_SIZE_SPI_MSG_MAXLEN)
 
 static int sja1105_spi_transfer(const struct sja1105_private *priv,
-				const void *tx, void *rx, int size)
+				const void *tx, void *rx, int size,
+				struct ptp_system_timestamp *ptp_sts)
 {
 	struct spi_device *spi = priv->spidev;
 	struct spi_transfer transfer = {
+		.ptp_sts_word_offset = 3,
+		.ptp_sts = ptp_sts,
 		.tx_buf = tx,
 		.rx_buf = rx,
 		.len = size,
@@ -66,9 +69,11 @@ sja1105_spi_message_pack(void *buf, const struct sja1105_spi_message *msg)
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
@@ -90,7 +95,7 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 		memcpy(tx_buf + SJA1105_SIZE_SPI_MSG_HEADER,
 		       packed_buf, size_bytes);
 
-	rc = sja1105_spi_transfer(priv, tx_buf, rx_buf, msg_len);
+	rc = sja1105_spi_transfer(priv, tx_buf, rx_buf, msg_len, ptp_sts);
 	if (rc < 0)
 		return rc;
 
@@ -101,6 +106,14 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
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
@@ -114,7 +127,8 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
  */
 int sja1105_spi_send_int(const struct sja1105_private *priv,
 			 sja1105_spi_rw_mode_t rw, u64 reg_addr,
-			 u64 *value, u64 size_bytes)
+			 u64 *value, u64 size_bytes,
+			 struct ptp_system_timestamp *ptp_sts)
 {
 	u8 packed_buf[SJA1105_SIZE_SPI_MSG_MAXLEN];
 	int rc;
@@ -126,8 +140,8 @@ int sja1105_spi_send_int(const struct sja1105_private *priv,
 		sja1105_pack(packed_buf, value, 8 * size_bytes - 1, 0,
 			     size_bytes);
 
-	rc = sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf,
-					 size_bytes);
+	rc = __sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf,
+					   size_bytes, ptp_sts);
 
 	if (rw == SPI_READ)
 		sja1105_unpack(packed_buf, value, 8 * size_bytes - 1, 0,
@@ -291,7 +305,7 @@ int sja1105_inhibit_tx(const struct sja1105_private *priv,
 	int rc;
 
 	rc = sja1105_spi_send_int(priv, SPI_READ, regs->port_control,
-				  &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
+				  &inhibit_cmd, SJA1105_SIZE_PORT_CTRL, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -301,7 +315,7 @@ int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		inhibit_cmd &= ~port_bitmap;
 
 	return sja1105_spi_send_int(priv, SPI_WRITE, regs->port_control,
-				    &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
+				    &inhibit_cmd, SJA1105_SIZE_PORT_CTRL, NULL);
 }
 
 struct sja1105_status {
-- 
2.17.1

