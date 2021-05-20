Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1AB38B803
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240152AbhETUEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237551AbhETUEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 16:04:04 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3044DC061761;
        Thu, 20 May 2021 13:02:41 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y7so3290344eda.2;
        Thu, 20 May 2021 13:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FHUJtBq9iJ9xTw4W3wJ7q5IXipUFvoldRp8Yq4IjtY4=;
        b=FXbDVMvnvTYdQA26aNNwxZnQEBqU+sXeFiVKTC/zSjlrZ1k3A5FerLTxVjqSaIlsPb
         dDsMj/BZK+lhUfs/Nsb4C4Y3N4W1t91mm/S3UkzKa6bmwrk9A5krW0ykHoisP8J7z6Pj
         aBt4pf12jKYYSlc1ev7F96IZMIlnDJdiuASaz1bhmG2cahIcnBbGRMYRg8+V9hIzsYe1
         NC64bQwLH3+rVIoMFws5pqgdoe5lsdG1sOFv6GaeuW2z/yWajk8GGFJK+HAmsQNZZeKo
         VWFAnDYHMQ6seNqtP/vhFnTeXi53rSV5wYovYGiuP1KAO3kj13Bd/BqzeyzoTtejMWD4
         xduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FHUJtBq9iJ9xTw4W3wJ7q5IXipUFvoldRp8Yq4IjtY4=;
        b=HOZCT+B7Rlb0uKzoD9k1taoU2m6KKvH6rLFpZo3JPCxVF/2yVLXVVM3CBqb6tWtQVm
         mrPMTdRZiL5fvsgk8LaYqCnXcrq6Ji77QqZnAhg8kbXLU7Rui4x2l9T9jYPlMVCGL5Hf
         WquYIfAcPa1obPOcyn7KydlKyTLAeD5F0K7KYdzTiER6FlxzDYmcO/VlQTnZkJk2LD/i
         NbNW81N3dF+SMYSEnZDoHvcLWDzs72WByzR1Ivl9IO+ZpVZz9P11ya4rJCYD+HEF24ft
         SMQXyf3LbO4GPfNkR5RGDK0vJHnl0Yw6/Mp6cms3JMPPGHZ5Jut24QmQwFMdMn4A6VZk
         OXlQ==
X-Gm-Message-State: AOAM532IOgTwaKEm9W4MSb5sTNdoFlx14N3uxF1Gr0HpVK9i0wy++M0i
        PUXIMGOTtkv0ksFYX+dh4J0=
X-Google-Smtp-Source: ABdhPJw7PJfpxXjaxM6+ou8m8BPWeNrRx1W+DAFZoYct+WXm2enQNXeOEAuj7aPDIPSrcF1LFeoGNA==
X-Received: by 2002:a05:6402:657:: with SMTP id u23mr6798799edx.225.1621540959751;
        Thu, 20 May 2021 13:02:39 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id y10sm1974288ejh.105.2021.05.20.13.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 13:02:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 1/2] net: dsa: sja1105: send multiple spi_messages instead of using cs_change
Date:   Thu, 20 May 2021 23:02:22 +0300
Message-Id: <20210520200223.3375421-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520200223.3375421-1-olteanv@gmail.com>
References: <20210520200223.3375421-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105 driver has been described by Mark Brown as "not using the
[ SPI ] API at all idiomatically" due to the use of cs_change:
https://patchwork.kernel.org/project/netdevbpf/patch/20210520135031.2969183-1-olteanv@gmail.com/

According to include/linux/spi/spi.h, the chip select is supposed to be
asserted for the entire length of a SPI message, as long as cs_change is
false for all member transfers. The cs_change flag changes the following:

(i) When a non-final SPI transfer has cs_change = true, the chip select
    should temporarily deassert and then reassert starting with the next
    transfer.
(ii) When a final SPI transfer has cs_change = true, the chip select
     should remain asserted until the following SPI message.

The sja1105 driver only uses cs_change for its first property, to form a
single SPI message whose layout can be seen below:

                                             this is an entire, single spi_message
           _______________________________________________________________________________________________
          /                                                                                               \
          +-------------+---------------+-------------+---------------+ ... +-------------+---------------+
          | hdr_xfer[0] | chunk_xfer[0] | hdr_xfer[1] | chunk_xfer[1] |     | hdr_xfer[n] | chunk_xfer[n] |
          +-------------+---------------+-------------+---------------+ ... +-------------+---------------+
cs_change      false          true           false           true                false          false

           ____________________________  _____________________________       _____________________________
CS line __/                            \/                             \ ... /                             \__

The fact of the matter is that spi_max_message_size() has an ambiguous
meaning if any non-final transfer has cs_change = true.

If the SPI master has a limitation in that it cannot keep the chip
select asserted for more than, say, 200 bytes (like the spi-sc18is602),
the normal thing for it to do is to implement .max_transfer_size and
.max_message_size, and limit both to 200: in the "worst case" where
cs_change is always false, then the controller can, indeed, not send
messages larger than 200 bytes.

But the fact that the SPI controller's max_message_size does not
necessarily mean that we cannot send messages larger than that.
Notably, if the SPI master special-cases the transfers with cs_change
and treats every chip select toggling as an entirely new transaction,
then a SPI message can easily exceed that limit. So there is a
temptation to ignore the controller's reported max_message_size when
using cs_change = true in non-final transfers.

But that can lead to false conclusions. As Mark points out, the SPI
controller might have a different kind of limitation with the max
message size, that has nothing at all to do with how long it can keep
the chip select asserted.
For example, that might be the case if the device is able to offload the
chip select changes to the hardware as part of the data stream, and it
packs the entire stream of commands+data (corresponding to a SPI
message) into a single DMA transfer that is itself limited in size.

So the only thing we can do is avoid ambiguity by not using cs_change at
all. Instead of sending a single spi_message, we now send multiple SPI
messages as follows:

                  spi_message 0                 spi_message 1                       spi_message n
           ____________________________   ___________________________        _____________________________
          /                            \ /                           \      /                             \
          +-------------+---------------+-------------+---------------+ ... +-------------+---------------+
          | hdr_xfer[0] | chunk_xfer[0] | hdr_xfer[1] | chunk_xfer[1] |     | hdr_xfer[n] | chunk_xfer[n] |
          +-------------+---------------+-------------+---------------+ ... +-------------+---------------+
cs_change      false          true           false           true                false          false

           ____________________________  _____________________________       _____________________________
CS line __/                            \/                             \ ... /                             \__

which is clearer because the max_message_size limit is now easier to
enforce. What is transmitted on the wire stays, of course, the same.

Additionally, because we send no more than 2 transfers at a time, we now
avoid dynamic memory allocation too, which might be seen as an
improvement by some.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 52 +++++++--------------------
 1 file changed, 12 insertions(+), 40 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index f7a1514f81e8..8746e3f158a0 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -29,13 +29,6 @@ sja1105_spi_message_pack(void *buf, const struct sja1105_spi_message *msg)
 	sja1105_pack(buf, &msg->address,    24,  4, size);
 }
 
-#define sja1105_hdr_xfer(xfers, chunk) \
-	((xfers) + 2 * (chunk))
-#define sja1105_chunk_xfer(xfers, chunk) \
-	((xfers) + 2 * (chunk) + 1)
-#define sja1105_hdr_buf(hdr_bufs, chunk) \
-	((hdr_bufs) + (chunk) * SJA1105_SIZE_SPI_MSG_HEADER)
-
 /* If @rw is:
  * - SPI_WRITE: creates and sends an SPI write message at absolute
  *		address reg_addr, taking @len bytes from *buf
@@ -46,41 +39,25 @@ static int sja1105_xfer(const struct sja1105_private *priv,
 			sja1105_spi_rw_mode_t rw, u64 reg_addr, u8 *buf,
 			size_t len, struct ptp_system_timestamp *ptp_sts)
 {
+	u8 hdr_buf[SJA1105_SIZE_SPI_MSG_HEADER] = {0};
 	struct sja1105_chunk chunk = {
 		.len = min_t(size_t, len, SJA1105_SIZE_SPI_MSG_MAXLEN),
 		.reg_addr = reg_addr,
 		.buf = buf,
 	};
 	struct spi_device *spi = priv->spidev;
-	struct spi_transfer *xfers;
+	struct spi_transfer xfers[2] = {0};
+	struct spi_transfer *chunk_xfer;
+	struct spi_transfer *hdr_xfer;
 	int num_chunks;
 	int rc, i = 0;
-	u8 *hdr_bufs;
 
 	num_chunks = DIV_ROUND_UP(len, SJA1105_SIZE_SPI_MSG_MAXLEN);
 
-	/* One transfer for each message header, one for each message
-	 * payload (chunk).
-	 */
-	xfers = kcalloc(2 * num_chunks, sizeof(struct spi_transfer),
-			GFP_KERNEL);
-	if (!xfers)
-		return -ENOMEM;
-
-	/* Packed buffers for the num_chunks SPI message headers,
-	 * stored as a contiguous array
-	 */
-	hdr_bufs = kcalloc(num_chunks, SJA1105_SIZE_SPI_MSG_HEADER,
-			   GFP_KERNEL);
-	if (!hdr_bufs) {
-		kfree(xfers);
-		return -ENOMEM;
-	}
+	hdr_xfer = &xfers[0];
+	chunk_xfer = &xfers[1];
 
 	for (i = 0; i < num_chunks; i++) {
-		struct spi_transfer *chunk_xfer = sja1105_chunk_xfer(xfers, i);
-		struct spi_transfer *hdr_xfer = sja1105_hdr_xfer(xfers, i);
-		u8 *hdr_buf = sja1105_hdr_buf(hdr_bufs, i);
 		struct spi_transfer *ptp_sts_xfer;
 		struct sja1105_spi_message msg;
 
@@ -129,19 +106,14 @@ static int sja1105_xfer(const struct sja1105_private *priv,
 		chunk.len = min_t(size_t, (ptrdiff_t)(buf + len - chunk.buf),
 				  SJA1105_SIZE_SPI_MSG_MAXLEN);
 
-		/* De-assert the chip select after each chunk. */
-		if (chunk.len)
-			chunk_xfer->cs_change = 1;
+		rc = spi_sync_transfer(spi, xfers, 2);
+		if (rc < 0) {
+			dev_err(&spi->dev, "SPI transfer failed: %d\n", rc);
+			return rc;
+		}
 	}
 
-	rc = spi_sync_transfer(spi, xfers, 2 * num_chunks);
-	if (rc < 0)
-		dev_err(&spi->dev, "SPI transfer failed: %d\n", rc);
-
-	kfree(hdr_bufs);
-	kfree(xfers);
-
-	return rc;
+	return 0;
 }
 
 int sja1105_xfer_buf(const struct sja1105_private *priv,
-- 
2.25.1

