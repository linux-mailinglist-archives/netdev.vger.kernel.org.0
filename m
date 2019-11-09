Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E88DF5EBD
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 12:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfKILdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 06:33:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35697 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfKILdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 06:33:02 -0500
Received: by mail-wm1-f68.google.com with SMTP id 8so8780216wmo.0
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 03:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cNpuFwkBot0QanqM+8oGh/xboHfp3cFPGjVYVlItv5A=;
        b=k9oCLmWWoGpMqZg0mp/vRtn7X2M7LPE3zrsA893GA3cyDpu9+cPw4WaPyy1GCwTudm
         aZBwvWMH1tGqeHf8ClyUG2/s7PFQMpSagTXkiSK9/ONxeMK0UKRxvwD4WzgQQ39yX76h
         PwtL8RhZYRQQ4t5ltZAQI3i9P/vTsqORB85b81Fwk3mjlgOiUCh4mQPvcbfgk3HFi4ir
         t7mB7M0tQkcLf7zOAnh0fdRygwiV2ruxVG/5AWHeAxSnJCogfr+qMFQOEiwF9imhnQg5
         ZVIhi70eWSPj/zSdB0aoyp1oy61AFtZZSB+DO8lCboznmfbUw2aIFY+to/PoJ9xHyMP+
         LgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cNpuFwkBot0QanqM+8oGh/xboHfp3cFPGjVYVlItv5A=;
        b=CUuKq5sgBI7gIuNC5NJ7hc/E4dO/QHzFLWLo1JiTFq5V/EtMg/SgBrfsQ61ZwNDJIh
         ctUxqmexNR/qoGZ14FswnSQBbZotmkbOpMwRBmVPREfll0zjDR0lWcSvY5I0AaDtfnH5
         EV9+g5fm68wcWBAskB9Fnp0JD5dR3DodueAfgZZRRavzCBwGN9L9cOe4fLwZDF/7WppN
         XeJC4GzUcbvOtalJyt6vd0E/jMU+kS/VjCNW63G77I+81XqgSDJ3yJoQcCzm+Pto+fIb
         nXnEZOr5+QU3Ms3wKLBL3hDlLAAHfGTmcHTIoE5uIioNHRCGQKVx2jLSa4NqnhN493b3
         rB1Q==
X-Gm-Message-State: APjAAAWnx9bqK8sGHwMR403Y+vsl3NhIXlhNILscEgVYUJd0rBEqBikR
        cu42RK9epTyFk1dHdyaqE3I=
X-Google-Smtp-Source: APXvYqwfMN0+SudmzjzHZ3Z7Z9RM2KJ5dyZcgJdvL+Tb3+KYt72sbVCDtIPQxTqb6c7VCyZ1qMlJ+g==
X-Received: by 2002:a1c:7f94:: with SMTP id a142mr11924117wmd.33.1573299178017;
        Sat, 09 Nov 2019 03:32:58 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id w13sm8353512wrm.8.2019.11.09.03.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 03:32:57 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: sja1105: Implement the .gettimex64 system call for PTP
Date:   Sat,  9 Nov 2019 13:32:22 +0200
Message-Id: <20191109113224.6495-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109113224.6495-1-olteanv@gmail.com>
References: <20191109113224.6495-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Through the PTP_SYS_OFFSET_EXTENDED ioctl, it is possible for userspace
applications (i.e. phc2sys) to compensate for the delays incurred while
reading the PHC's time.

The task itself of taking the software timestamp is delegated to the SPI
subsystem, through the newly introduced API in struct spi_transfer. The
goal is to cross-timestamp I/O operations on the switch's PTP clock with
values in the local system clock (CLOCK_REALTIME). For that we need to
understand a bit of the hardware internals.

The 'read PTP time' message is a 12 byte structure, first 4 bytes of
which represent the SPI header, and the last 8 bytes represent the
64-bit PTP time. The switch itself starts processing the command
immediately after receiving the last bit of the address, i.e. at the
middle of byte 3 (last byte of header). The PTP time is shadowed to a
buffer register in the switch, and retrieved atomically during the
subsequent SPI frames.

A similar thing goes on for the 'write PTP time' message, although in
that case the switch waits until the 64-bit PTP time becomes fully
available before taking any action. So the byte that needs to be
software-timestamped is byte 11 (last) of the transfer.

The patch creates a common (and local) sja1105_xfer implementation for
the SPI I/O, and offers 3 front-ends:

- sja1105_xfer_u32 and sja1105_xfer_u64: these are capable of optionally
  requesting a PTP timestamp

- sja1105_xfer_buf: this is for large transfers (e.g. the static config
  buffer) and other misc data, and there is no point in giving
  timestamping capabilities to this.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  6 ++--
 drivers/net/dsa/sja1105/sja1105_main.c |  3 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 26 ++++++++------
 drivers/net/dsa/sja1105/sja1105_spi.c  | 48 +++++++++++++++++++++-----
 4 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 91063ed3ef1b..64b3ee7b9771 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -122,9 +122,11 @@ int sja1105_xfer_buf(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
 		     u8 *buf, size_t len);
 int sja1105_xfer_u32(const struct sja1105_private *priv,
-		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u32 *value);
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u32 *value,
+		     struct ptp_system_timestamp *ptp_sts);
 int sja1105_xfer_u64(const struct sja1105_private *priv,
-		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u64 *value);
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u64 *value,
+		     struct ptp_system_timestamp *ptp_sts);
 int sja1105_static_config_upload(struct sja1105_private *priv);
 int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		       unsigned long port_bitmap, bool tx_inhibited);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d5dfda335aa1..d545edbbef9e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1973,7 +1973,8 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 	u64 part_no;
 	int rc;
 
-	rc = sja1105_xfer_u32(priv, SPI_READ, regs->device_id, &device_id);
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->device_id, &device_id,
+			      NULL);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 783100397f8a..fac72af24baf 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
+#include <linux/spi/spi.h>
 #include "sja1105.h"
 
 /* The adjfine API clamps ppb between [-32,768,000, 32,768,000], and
@@ -335,11 +336,13 @@ static int sja1105_ptpegr_ts_poll(struct dsa_switch *ds, int port, u64 *ts)
 }
 
 /* Caller must hold ptp_data->lock */
-static int sja1105_ptpclkval_read(struct sja1105_private *priv, u64 *ticks)
+static int sja1105_ptpclkval_read(struct sja1105_private *priv, u64 *ticks,
+				  struct ptp_system_timestamp *ptp_sts)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 
-	return sja1105_xfer_u64(priv, SPI_READ, regs->ptpclkval, ticks);
+	return sja1105_xfer_u64(priv, SPI_READ, regs->ptpclkval, ticks,
+				ptp_sts);
 }
 
 /* Caller must hold ptp_data->lock */
@@ -347,7 +350,8 @@ static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 ticks)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 
-	return sja1105_xfer_u64(priv, SPI_WRITE, regs->ptpclkval, &ticks);
+	return sja1105_xfer_u64(priv, SPI_WRITE, regs->ptpclkval, &ticks,
+				NULL);
 }
 
 #define rxtstamp_to_tagger(d) \
@@ -370,7 +374,7 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 		u64 ticks, ts;
 		int rc;
 
-		rc = sja1105_ptpclkval_read(priv, &ticks);
+		rc = sja1105_ptpclkval_read(priv, &ticks, NULL);
 		if (rc < 0) {
 			dev_err(ds->dev, "Failed to read PTP clock: %d\n", rc);
 			kfree_skb(skb);
@@ -441,8 +445,9 @@ int sja1105_ptp_reset(struct dsa_switch *ds)
 	return rc;
 }
 
-static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
-			       struct timespec64 *ts)
+static int sja1105_ptp_gettimex(struct ptp_clock_info *ptp,
+				struct timespec64 *ts,
+				struct ptp_system_timestamp *ptp_sts)
 {
 	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
@@ -451,7 +456,7 @@ static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
 
 	mutex_lock(&ptp_data->lock);
 
-	rc = sja1105_ptpclkval_read(priv, &ticks);
+	rc = sja1105_ptpclkval_read(priv, &ticks, ptp_sts);
 	*ts = ns_to_timespec64(sja1105_ticks_to_ns(ticks));
 
 	mutex_unlock(&ptp_data->lock);
@@ -516,7 +521,8 @@ static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 
 	mutex_lock(&ptp_data->lock);
 
-	rc = sja1105_xfer_u32(priv, SPI_WRITE, regs->ptpclkrate, &clkrate32);
+	rc = sja1105_xfer_u32(priv, SPI_WRITE, regs->ptpclkrate, &clkrate32,
+			      NULL);
 
 	mutex_unlock(&ptp_data->lock);
 
@@ -558,7 +564,7 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 		.name		= "SJA1105 PHC",
 		.adjfine	= sja1105_ptp_adjfine,
 		.adjtime	= sja1105_ptp_adjtime,
-		.gettime64	= sja1105_ptp_gettime,
+		.gettimex64	= sja1105_ptp_gettimex,
 		.settime64	= sja1105_ptp_settime,
 		.max_adj	= SJA1105_MAX_ADJ_PPB,
 	};
@@ -604,7 +610,7 @@ void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
 
 	mutex_lock(&ptp_data->lock);
 
-	rc = sja1105_ptpclkval_read(priv, &ticks);
+	rc = sja1105_ptpclkval_read(priv, &ticks, NULL);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to read PTP clock: %d\n", rc);
 		kfree_skb(skb);
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index ed02410a9366..691cd250e50a 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -42,9 +42,9 @@ sja1105_spi_message_pack(void *buf, const struct sja1105_spi_message *msg)
  * - SPI_READ:  creates and sends an SPI read message from absolute
  *		address reg_addr, writing @len bytes into *buf
  */
-int sja1105_xfer_buf(const struct sja1105_private *priv,
-		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
-		     u8 *buf, size_t len)
+static int sja1105_xfer(const struct sja1105_private *priv,
+			sja1105_spi_rw_mode_t rw, u64 reg_addr, u8 *buf,
+			size_t len, struct ptp_system_timestamp *ptp_sts)
 {
 	struct sja1105_chunk chunk = {
 		.len = min_t(size_t, len, SJA1105_SIZE_SPI_MSG_MAXLEN),
@@ -81,6 +81,7 @@ int sja1105_xfer_buf(const struct sja1105_private *priv,
 		struct spi_transfer *chunk_xfer = sja1105_chunk_xfer(xfers, i);
 		struct spi_transfer *hdr_xfer = sja1105_hdr_xfer(xfers, i);
 		u8 *hdr_buf = sja1105_hdr_buf(hdr_bufs, i);
+		struct spi_transfer *ptp_sts_xfer;
 		struct sja1105_spi_message msg;
 
 		/* Populate the transfer's header buffer */
@@ -102,6 +103,26 @@ int sja1105_xfer_buf(const struct sja1105_private *priv,
 			chunk_xfer->tx_buf = chunk.buf;
 		chunk_xfer->len = chunk.len;
 
+		/* Request timestamping for the transfer. Instead of letting
+		 * callers specify which byte they want to timestamp, we can
+		 * make certain assumptions:
+		 * - A read operation will request a software timestamp when
+		 *   what's being read is the PTP time. That is snapshotted by
+		 *   the switch hardware at the end of the command portion
+		 *   (hdr_xfer).
+		 * - A write operation will request a software timestamp on
+		 *   actions that modify the PTP time. Taking clock stepping as
+		 *   an example, the switch writes the PTP time at the end of
+		 *   the data portion (chunk_xfer).
+		 */
+		if (rw == SPI_READ)
+			ptp_sts_xfer = hdr_xfer;
+		else
+			ptp_sts_xfer = chunk_xfer;
+		ptp_sts_xfer->ptp_sts_word_pre = ptp_sts_xfer->len - 1;
+		ptp_sts_xfer->ptp_sts_word_post = ptp_sts_xfer->len - 1;
+		ptp_sts_xfer->ptp_sts = ptp_sts;
+
 		/* Calculate next chunk */
 		chunk.buf += chunk.len;
 		chunk.reg_addr += chunk.len / 4;
@@ -123,6 +144,13 @@ int sja1105_xfer_buf(const struct sja1105_private *priv,
 	return rc;
 }
 
+int sja1105_xfer_buf(const struct sja1105_private *priv,
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
+		     u8 *buf, size_t len)
+{
+	return sja1105_xfer(priv, rw, reg_addr, buf, len, NULL);
+}
+
 /* If @rw is:
  * - SPI_WRITE: creates and sends an SPI write message at absolute
  *		address reg_addr
@@ -133,7 +161,8 @@ int sja1105_xfer_buf(const struct sja1105_private *priv,
  * CPU endianness and directly usable by software running on the core.
  */
 int sja1105_xfer_u64(const struct sja1105_private *priv,
-		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u64 *value)
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u64 *value,
+		     struct ptp_system_timestamp *ptp_sts)
 {
 	u8 packed_buf[8];
 	int rc;
@@ -141,7 +170,7 @@ int sja1105_xfer_u64(const struct sja1105_private *priv,
 	if (rw == SPI_WRITE)
 		sja1105_pack(packed_buf, value, 63, 0, 8);
 
-	rc = sja1105_xfer_buf(priv, rw, reg_addr, packed_buf, 8);
+	rc = sja1105_xfer(priv, rw, reg_addr, packed_buf, 8, ptp_sts);
 
 	if (rw == SPI_READ)
 		sja1105_unpack(packed_buf, value, 63, 0, 8);
@@ -151,7 +180,8 @@ int sja1105_xfer_u64(const struct sja1105_private *priv,
 
 /* Same as above, but transfers only a 4 byte word */
 int sja1105_xfer_u32(const struct sja1105_private *priv,
-		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u32 *value)
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u32 *value,
+		     struct ptp_system_timestamp *ptp_sts)
 {
 	u8 packed_buf[4];
 	u64 tmp;
@@ -165,7 +195,7 @@ int sja1105_xfer_u32(const struct sja1105_private *priv,
 		sja1105_pack(packed_buf, &tmp, 31, 0, 4);
 	}
 
-	rc = sja1105_xfer_buf(priv, rw, reg_addr, packed_buf, 4);
+	rc = sja1105_xfer(priv, rw, reg_addr, packed_buf, 4, ptp_sts);
 
 	if (rw == SPI_READ) {
 		sja1105_unpack(packed_buf, &tmp, 31, 0, 4);
@@ -293,7 +323,7 @@ int sja1105_inhibit_tx(const struct sja1105_private *priv,
 	int rc;
 
 	rc = sja1105_xfer_u32(priv, SPI_READ, regs->port_control,
-			      &inhibit_cmd);
+			      &inhibit_cmd, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -303,7 +333,7 @@ int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		inhibit_cmd &= ~port_bitmap;
 
 	return sja1105_xfer_u32(priv, SPI_WRITE, regs->port_control,
-				&inhibit_cmd);
+				&inhibit_cmd, NULL);
 }
 
 struct sja1105_status {
-- 
2.17.1

