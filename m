Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9176638B802
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240093AbhETUEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbhETUEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 16:04:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB43C061574;
        Thu, 20 May 2021 13:02:42 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id k14so23715367eji.2;
        Thu, 20 May 2021 13:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MIwFKnwxsMP/w3Erd5eATPhdPWZJ+enLwYctyGA6yX4=;
        b=DH2SaswxTa+4eDazZmYb5XWuRAnU9klV7geQEUagDgxouYO5AG3vbApqFprWZz4/U1
         xSiO1DPuG0nLasiraUrVlxCPhAe2+GZJgjql0HdJSHmWu3Q43nmFbvkNIVojBrlVlmW0
         OWX7z6MlZkGoFBPFSe1VKrEZQrMrQStqna3nN9zuYo+yF7v/gkU7uN0yV4sEEhTifDRg
         Pl5BpsG0BTX7w8BEy+baAJtS7j04grwvnqRIXpR1hZN0LXLPVId1jcx9NWmfZQwffndC
         hYhRIbyxr5YgjwTF3HlKVROnY+XCjhVnrzThVMJdrfUBqyxlqfoy/5bOaZH+shkEO4v/
         0r8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MIwFKnwxsMP/w3Erd5eATPhdPWZJ+enLwYctyGA6yX4=;
        b=Djat5P31iGBAdNXkKsLJf1EqJpsBziCpAGeGlTjq2nOmVdMjgCC2DW+oZsfDdhqPef
         R5wciuqZbIWFKHvz+5INGcItIOkT5lnbjdtI7psL/9HoYq/2RTs9C6qe0Phzs0rV7Rqn
         swagp8AugNHmBWJY//4XI8oM5UI47qu4rZ4TevaT0YmoEGjP4WhNSwcuERpe9gpHQ3sh
         F3us2pcwpxJlKh2NCofUZl6V2stmNLlSb8Hs9sV7AgEZaW4EW4GpWk1VRQhx6+6ax1dn
         ivOsAihDM8M65NP402pI/oDCw8BcoIZ5Sx2ITUJBdiybicDob/leRjvWWplk1ePXrWvd
         Ji1g==
X-Gm-Message-State: AOAM530WeJAA9j+bII28GH1Quz0MySYh1Vb5V0lWHUgIbcaiknHYp7D5
        LVELt3Nln1yynJg4UIExJ7w=
X-Google-Smtp-Source: ABdhPJypqBkxe+bckqqa8/ZI0rgX8KAJWg4GHQOH3HR23DF4ITRQjNVpJVqLuQMEV8gdXbntKtrHnw==
X-Received: by 2002:a17:906:328c:: with SMTP id 12mr6376131ejw.361.1621540960726;
        Thu, 20 May 2021 13:02:40 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id y10sm1974288ejh.105.2021.05.20.13.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 13:02:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 2/2] net: dsa: sja1105: adapt to a SPI controller with a limited max transfer size
Date:   Thu, 20 May 2021 23:02:23 +0300
Message-Id: <20210520200223.3375421-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520200223.3375421-1-olteanv@gmail.com>
References: <20210520200223.3375421-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The static config of the sja1105 switch is a long stream of bytes which
is programmed to the hardware in chunks (portions with the chip select
continuously asserted) of max 256 bytes each.

Only that certain SPI controllers, such as the spi-sc18is602 I2C-to-SPI
bridge, cannot keep the chip select asserted for that long.
The spi_max_transfer_size() and spi_max_message_size() functions are how
the controller can impose its hardware limitations upon the SPI
peripheral driver.

The sja1105 sends its static config to the SPI master in chunks, and
each chunk is a spi_message composed of 2 spi_transfers: the buffer with
the data and a preceding buffer with the SPI access header. Both buffers
must be smaller than the transfer limit, and their sum must be smaller
than the message limit.

Regression-tested on a switch connected to a controller with no
limitations (spi-fsl-dspi) as well as with one with caps for both
max_transfer_size and max_message_size (spi-sc18is602).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 30 ++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 8746e3f158a0..7bcf2e419037 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -40,19 +40,35 @@ static int sja1105_xfer(const struct sja1105_private *priv,
 			size_t len, struct ptp_system_timestamp *ptp_sts)
 {
 	u8 hdr_buf[SJA1105_SIZE_SPI_MSG_HEADER] = {0};
-	struct sja1105_chunk chunk = {
-		.len = min_t(size_t, len, SJA1105_SIZE_SPI_MSG_MAXLEN),
-		.reg_addr = reg_addr,
-		.buf = buf,
-	};
 	struct spi_device *spi = priv->spidev;
 	struct spi_transfer xfers[2] = {0};
 	struct spi_transfer *chunk_xfer;
 	struct spi_transfer *hdr_xfer;
+	struct sja1105_chunk chunk;
+	ssize_t xfer_len;
 	int num_chunks;
 	int rc, i = 0;
 
-	num_chunks = DIV_ROUND_UP(len, SJA1105_SIZE_SPI_MSG_MAXLEN);
+	/* One spi_message is composed of two spi_transfers: a small one for
+	 * the message header and another one for the current chunk of the
+	 * packed buffer.
+	 * Check that the restrictions imposed by the SPI controller are
+	 * respected: the chunk buffer is smaller than the max transfer size,
+	 * and the total length of the chunk plus its message header is smaller
+	 * than the max message size.
+	 */
+	xfer_len = min_t(ssize_t, SJA1105_SIZE_SPI_MSG_MAXLEN,
+			 spi_max_transfer_size(spi));
+	xfer_len = min_t(ssize_t, SJA1105_SIZE_SPI_MSG_MAXLEN,
+			 spi_max_message_size(spi) - SJA1105_SIZE_SPI_MSG_HEADER);
+	if (xfer_len < 0)
+		return -ERANGE;
+
+	num_chunks = DIV_ROUND_UP(len, xfer_len);
+
+	chunk.reg_addr = reg_addr;
+	chunk.buf = buf;
+	chunk.len = min_t(size_t, len, xfer_len);
 
 	hdr_xfer = &xfers[0];
 	chunk_xfer = &xfers[1];
@@ -104,7 +120,7 @@ static int sja1105_xfer(const struct sja1105_private *priv,
 		chunk.buf += chunk.len;
 		chunk.reg_addr += chunk.len / 4;
 		chunk.len = min_t(size_t, (ptrdiff_t)(buf + len - chunk.buf),
-				  SJA1105_SIZE_SPI_MSG_MAXLEN);
+				  xfer_len);
 
 		rc = spi_sync_transfer(spi, xfers, 2);
 		if (rc < 0) {
-- 
2.25.1

