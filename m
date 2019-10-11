Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97EF9D4A57
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 00:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfJKWcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 18:32:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45705 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfJKWcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 18:32:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id r5so13427019wrm.12
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 15:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dh+eDTnVb/KJIKAf9aVLwnRN07vNHWHJtgcNE1vvriM=;
        b=O3i+yFcHQ2DqD21qny2+VMCDpZLtw0Cbl0pnNLy5BRGZMIrS7j9tR2VvjWoyooPUob
         uekxoljHKoOBJ3+C7ucItAUz1x32KChwEulML5l/2hDvnXRX411XvMdVN+yE3Cssy+Ak
         Z05QJe+bssO/1CF73xfpU0+bUdyNbLw3uRz41zWvKzh9CMkJw9wotlOH/yW6s5i3EgiB
         rS+T51jxjCLF9ThVS1hCX9WbCWIY4jB2Y2fJUtZpdzPiwllY+YU/oURUS9JxapwI61Gd
         vZX7MvZMjchXlGO8yWadKfQNp9Pb/7929jOHwcuBKcvfswUZ3/hLN0326hAUTWTxZ/v0
         DwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dh+eDTnVb/KJIKAf9aVLwnRN07vNHWHJtgcNE1vvriM=;
        b=f+fW9EkHS3cxJAcNfGQEzMT8Wtoz47hsLRc7WGCXzB6W26UYmnLPDlQVpIVvQoaacn
         jeRID+jY3Ju4oOMPtmaRN3tC1lJI3Q+2b2YNT16iGNaG2PsopKQinG2w1D0rr7737gwL
         CDcavHRWOnCxVK6/QjpYCXN0bpNW8xIe7+7KL+IWQsUmOiwvOWmX6JOqdqB7EzUUbndU
         KACiEe3vcn47+xBHPZ2xDQIQMFyhGvEL68JwjCEQVwg+gPcV7+Z3hKRSNDrWSaqnhRAP
         yWWIFuHMeUZZPr+zkRj7pe/w7OeBC3sR68Va37nAw8xlr7Dn89JVFP7h9xJ0TqJNncGX
         bLiQ==
X-Gm-Message-State: APjAAAXmbntOdDznmdEfsI88Yss/Qn/gBL/bcb3LJkeeNdR8bMjSH/D5
        lr+eP4QL+FQyxCcafvDphZc=
X-Google-Smtp-Source: APXvYqwONdg3yP6j7Vq1C4FEd28XuDl2EMOXBSNfHyam9UwggUPXOfGuPgj7KqejQw2vOLkJLKcD/g==
X-Received: by 2002:a5d:6949:: with SMTP id r9mr11914705wrw.106.1570833135916;
        Fri, 11 Oct 2019 15:32:15 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id r27sm25549828wrc.55.2019.10.11.15.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 15:32:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: sja1105: Switch to scatter/gather API for SPI
Date:   Sat, 12 Oct 2019 01:31:15 +0300
Message-Id: <20191011223115.27197-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011223115.27197-1-olteanv@gmail.com>
References: <20191011223115.27197-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reworks the SPI transfer implementation to make use of more of the
SPI core features. The main benefit is to avoid the memcpy in
sja1105_xfer_buf().

The memcpy was only needed because the function was transferring a
single buffer at a time. So it needed to copy the caller-provided buffer
at buf + 4, to store the SPI message header in the "headroom" area.

But the SPI core supports scatter-gather messages, comprised of multiple
transfers. We can actually use those to break apart every SPI message
into 2 transfers: one for the header and one for the actual payload.

To keep the behavior the same regarding the chip select signal, it is
necessary to tell the SPI core to de-assert the chip select after each
chunk. This was not needed before, because each spi_message contained
only 1 single transfer.

The meaning of the per-transfer cs_change=1 is:

- If the transfer is the last one of the message, keep CS asserted
- Otherwise, deassert CS

We need to deassert CS in the "otherwise" case, which was implicit
before.

Avoiding the memcpy creates yet another opportunity. The device can't
process more than 256 bytes of SPI payload at a time, so the
sja1105_xfer_long_buf() function used to exist, to split the larger
caller buffer into chunks.

But these chunks couldn't be used as scatter/gather buffers for
spi_message until now, because of that memcpy (we would have needed more
memory for each chunk). So we can now remove the sja1105_xfer_long_buf()
function and have a single implementation for long and short buffers.

Another benefit is lower usage of stack memory. Previously we had to
store 2 SPI buffers for each chunk. Due to the elimination of the
memcpy, we can now send pointers to the actual chunks from the
caller-supplied buffer to the SPI core.

Since the patch merges two functions into a rewritten implementation,
the function prototype was also changed, mainly for cosmetic consistency
with the structures used within it.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h     |   2 +-
 drivers/net/dsa/sja1105/sja1105_spi.c | 164 +++++++++++++-------------
 2 files changed, 85 insertions(+), 81 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 8681ff9d1a76..e57b21639225 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -129,7 +129,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv);
 /* From sja1105_spi.c */
 int sja1105_xfer_buf(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
-		     void *packed_buf, size_t size_bytes);
+		     u8 *buf, size_t len);
 int sja1105_xfer_u32(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u32 *value);
 int sja1105_xfer_u64(const struct sja1105_private *priv,
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 831ac009bb30..d96379a8ecf5 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -10,8 +10,12 @@
 #define SJA1105_SIZE_RESET_CMD		4
 #define SJA1105_SIZE_SPI_MSG_HEADER	4
 #define SJA1105_SIZE_SPI_MSG_MAXLEN	(64 * 4)
-#define SJA1105_SIZE_SPI_TRANSFER_MAX	\
-	(SJA1105_SIZE_SPI_MSG_HEADER + SJA1105_SIZE_SPI_MSG_MAXLEN)
+
+struct sja1105_chunk {
+	u8	*buf;
+	size_t	len;
+	u64	reg_addr;
+};
 
 static void
 sja1105_spi_message_pack(void *buf, const struct sja1105_spi_message *msg)
@@ -25,61 +29,98 @@ sja1105_spi_message_pack(void *buf, const struct sja1105_spi_message *msg)
 	sja1105_pack(buf, &msg->address,    24,  4, size);
 }
 
+#define sja1105_hdr_xfer(xfers, chunk) \
+	((xfers) + 2 * (chunk))
+#define sja1105_chunk_xfer(xfers, chunk) \
+	((xfers) + 2 * (chunk) + 1)
+#define sja1105_hdr_buf(hdr_bufs, chunk) \
+	((hdr_bufs) + (chunk) * SJA1105_SIZE_SPI_MSG_HEADER)
+
 /* If @rw is:
  * - SPI_WRITE: creates and sends an SPI write message at absolute
- *		address reg_addr, taking size_bytes from *packed_buf
+ *		address reg_addr, taking @len bytes from *buf
  * - SPI_READ:  creates and sends an SPI read message from absolute
- *		address reg_addr, writing size_bytes into *packed_buf
- *
- * This function should only be called if it is priorly known that
- * @size_bytes is smaller than SIZE_SPI_MSG_MAXLEN. Larger packed buffers
- * are chunked in smaller pieces by sja1105_xfer_long_buf below.
+ *		address reg_addr, writing @len bytes into *buf
  */
 int sja1105_xfer_buf(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
-		     void *packed_buf, size_t size_bytes)
+		     u8 *buf, size_t len)
 {
-	const int msg_len = size_bytes + SJA1105_SIZE_SPI_MSG_HEADER;
-	u8 tx_buf[SJA1105_SIZE_SPI_TRANSFER_MAX] = {0};
-	u8 rx_buf[SJA1105_SIZE_SPI_TRANSFER_MAX] = {0};
-	struct spi_device *spi = priv->spidev;
-	struct sja1105_spi_message msg = {0};
-	struct spi_transfer xfer = {
-		.tx_buf = tx_buf,
-		.rx_buf = rx_buf,
-		.len = msg_len,
+	struct sja1105_chunk chunk = {
+		.len = min_t(size_t, len, SJA1105_SIZE_SPI_MSG_MAXLEN),
+		.reg_addr = reg_addr,
+		.buf = buf,
 	};
-	struct spi_message m;
-	int rc;
-
-	if (msg_len > SJA1105_SIZE_SPI_TRANSFER_MAX)
-		return -ERANGE;
+	struct spi_device *spi = priv->spidev;
+	struct spi_transfer *xfers;
+	int num_chunks;
+	int rc, i = 0;
+	u8 *hdr_bufs;
 
-	msg.access = rw;
-	msg.address = reg_addr;
-	if (rw == SPI_READ)
-		msg.read_count = size_bytes / 4;
+	num_chunks = DIV_ROUND_UP(len, SJA1105_SIZE_SPI_MSG_MAXLEN);
 
-	sja1105_spi_message_pack(tx_buf, &msg);
+	/* One transfer for each message header, one for each message
+	 * payload (chunk).
+	 */
+	xfers = kcalloc(2 * num_chunks, sizeof(struct spi_transfer),
+			GFP_KERNEL);
+	if (!xfers)
+		return -ENOMEM;
 
-	if (rw == SPI_WRITE)
-		memcpy(tx_buf + SJA1105_SIZE_SPI_MSG_HEADER,
-		       packed_buf, size_bytes);
+	/* Packed buffers for the num_chunks SPI message headers,
+	 * stored as a contiguous array
+	 */
+	hdr_bufs = kcalloc(num_chunks, SJA1105_SIZE_SPI_MSG_HEADER,
+			   GFP_KERNEL);
+	if (!hdr_bufs) {
+		kfree(xfers);
+		return -ENOMEM;
+	}
 
-	spi_message_init(&m);
-	spi_message_add_tail(&xfer, &m);
+	for (i = 0; i < num_chunks; i++) {
+		struct spi_transfer *chunk_xfer = sja1105_chunk_xfer(xfers, i);
+		struct spi_transfer *hdr_xfer = sja1105_hdr_xfer(xfers, i);
+		u8 *hdr_buf = sja1105_hdr_buf(hdr_bufs, i);
+		struct sja1105_spi_message msg;
+
+		/* Populate the transfer's header buffer */
+		msg.address = chunk.reg_addr;
+		msg.access = rw;
+		if (rw == SPI_READ)
+			msg.read_count = chunk.len / 4;
+		else
+			/* Ignored */
+			msg.read_count = 0;
+		sja1105_spi_message_pack(hdr_buf, &msg);
+		hdr_xfer->tx_buf = hdr_buf;
+		hdr_xfer->len = SJA1105_SIZE_SPI_MSG_HEADER;
+
+		/* Populate the transfer's data buffer */
+		if (rw == SPI_READ)
+			chunk_xfer->rx_buf = chunk.buf;
+		else
+			chunk_xfer->tx_buf = chunk.buf;
+		chunk_xfer->len = chunk.len;
+
+		/* Calculate next chunk */
+		chunk.buf += chunk.len;
+		chunk.reg_addr += chunk.len / 4;
+		chunk.len = min_t(size_t, (ptrdiff_t)(buf + len - chunk.buf),
+				  SJA1105_SIZE_SPI_MSG_MAXLEN);
+
+		/* De-assert the chip select after each chunk. */
+		if (chunk.len)
+			chunk_xfer->cs_change = 1;
+	}
 
-	rc = spi_sync(spi, &m);
-	if (rc < 0) {
+	rc = spi_sync_transfer(spi, xfers, 2 * num_chunks);
+	if (rc < 0)
 		dev_err(&spi->dev, "SPI transfer failed: %d\n", rc);
-		return rc;
-	}
 
-	if (rw == SPI_READ)
-		memcpy(packed_buf, rx_buf + SJA1105_SIZE_SPI_MSG_HEADER,
-		       size_bytes);
+	kfree(hdr_bufs);
+	kfree(xfers);
 
-	return 0;
+	return rc;
 }
 
 /* If @rw is:
@@ -134,43 +175,6 @@ int sja1105_xfer_u32(const struct sja1105_private *priv,
 	return rc;
 }
 
-/* Should be used if a @packed_buf larger than SJA1105_SIZE_SPI_MSG_MAXLEN
- * must be sent/received. Splitting the buffer into chunks and assembling
- * those into SPI messages is done automatically by this function.
- */
-static int sja1105_xfer_long_buf(const struct sja1105_private *priv,
-				 sja1105_spi_rw_mode_t rw, u64 base_addr,
-				 void *packed_buf, u64 buf_len)
-{
-	struct chunk {
-		void *buf_ptr;
-		int len;
-		u64 spi_address;
-	} chunk;
-	int distance_to_end;
-	int rc;
-
-	/* Initialize chunk */
-	chunk.buf_ptr = packed_buf;
-	chunk.spi_address = base_addr;
-	chunk.len = min_t(int, buf_len, SJA1105_SIZE_SPI_MSG_MAXLEN);
-
-	while (chunk.len) {
-		rc = sja1105_xfer_buf(priv, rw, chunk.spi_address,
-				      chunk.buf_ptr, chunk.len);
-		if (rc < 0)
-			return rc;
-
-		chunk.buf_ptr += chunk.len;
-		chunk.spi_address += chunk.len / 4;
-		distance_to_end = (uintptr_t)(packed_buf + buf_len -
-					      chunk.buf_ptr);
-		chunk.len = min(distance_to_end, SJA1105_SIZE_SPI_MSG_MAXLEN);
-	}
-
-	return 0;
-}
-
 /* Back-ported structure from UM11040 Table 112.
  * Reset control register (addr. 100440h)
  * In the SJA1105 E/T, only warm_rst and cold_rst are
@@ -433,8 +437,8 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 		/* Wait for the switch to come out of reset */
 		usleep_range(1000, 5000);
 		/* Upload the static config to the device */
-		rc = sja1105_xfer_long_buf(priv, SPI_WRITE, regs->config,
-					   config_buf, buf_len);
+		rc = sja1105_xfer_buf(priv, SPI_WRITE, regs->config,
+				      config_buf, buf_len);
 		if (rc < 0) {
 			dev_err(dev, "Failed to upload config, retrying...\n");
 			continue;
-- 
2.17.1

