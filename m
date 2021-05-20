Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A0938B8E0
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 23:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhETVS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 17:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhETVS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 17:18:28 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A161EC061574;
        Thu, 20 May 2021 14:17:06 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id c20so27481837ejm.3;
        Thu, 20 May 2021 14:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G6EnG++jASat6OrecSOupBpcUWQ9s4enAjVn4rOIlRU=;
        b=VKCxQuDQlrdwxlVipcVBgBpge+6Dbbj+Fl/IGktyapOJuk6q2dbdDCV4EW7HxnhhmA
         M69GnI0eOvYVf8ME3ivB+6R6moQc/XMh+IXoGBEm1soUK02kytxu8IsX4E+soJ2JzAsm
         /N0FJSwdWf3VZlCBd8xTEpaZFb7l2heVOdDRBB2aeKC/5jKXuCQywU2AEk3gBj7NgXoN
         hjCOKDSP8BaUfVixedNjHEZMHZTiYUO1hMElXInLhXBgA2vFFIAZtFP6WbKUonw48uUW
         LtINPYSvSuH1BHNBvZx2UO2QuYllL+jIOP6b0+o52KDsD7bv2b2UATt9BZa4CBvz52GA
         21VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G6EnG++jASat6OrecSOupBpcUWQ9s4enAjVn4rOIlRU=;
        b=Xepa0tACCtZdgoNqzKgoLbGlyDFBW9QerLmjUsy6DUNwAJahcQRtr+3FjQDvLsLF7i
         sqo7b7H1u7MMwOtzsC75YwPv1nZahotYHDTwaPu7q79/QqjJZzWZDEE2OEP8BastuO8v
         8/TKTfYM/cY3l5xx+AaOF2IyAYPCqC76Za+0BrZiOIH9OuzstgBC3QSu5Me4ZieMXxUd
         Eocx7jg6EC2WaUQZJCCKjHPhoY09DM+nzYQ/Je2skzmBVUUfgDO2JhR4zr0xhJjg37YA
         U95WTvGi+tXOfi5iKmFiMpYI4qi0LWFhYhUryVgZshctcehehN1rq9HzFscI/c2b8hAm
         1WSA==
X-Gm-Message-State: AOAM531s1lQPkvQWOAMwXuAwbcZj4xOi9vYf4I7jAvpwsxDpuoTDpRhj
        e1fLZ98l2BIPdF9LanbIGOg=
X-Google-Smtp-Source: ABdhPJzrx9DL6WTHChMJ94W6cPt/AQ+4OrYhT2PEnQQkiCZWBfyrK+KOeka4Igz1n5UsVhGGe50+nA==
X-Received: by 2002:a17:906:11cc:: with SMTP id o12mr6434216eja.547.1621545425267;
        Thu, 20 May 2021 14:17:05 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w10sm2084212ejq.48.2021.05.20.14.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 14:17:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 2/2] net: dsa: sja1105: adapt to a SPI controller with a limited max transfer size
Date:   Fri, 21 May 2021 00:16:57 +0300
Message-Id: <20210520211657.3451036-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520211657.3451036-1-olteanv@gmail.com>
References: <20210520211657.3451036-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The static config of the sja1105 switch is a long stream of bytes which
is programmed to the hardware in chunks (portions with the chip select
continuously asserted) of max 256 bytes each. Each chunk is a
spi_message composed of 2 spi_transfers: the buffer with the data and a
preceding buffer with the SPI access header.

Only that certain SPI controllers, such as the spi-sc18is602 I2C-to-SPI
bridge, cannot keep the chip select asserted for that long.
The spi_max_transfer_size() and spi_max_message_size() functions are how
the controller can impose its hardware limitations upon the SPI
peripheral driver.

For the sja1105 driver to work with these controllers, both buffers must
be smaller than the transfer limit, and their sum must be smaller than
the message limit.

Regression-tested on a switch connected to a controller with no
limitations (spi-fsl-dspi) as well as with one with caps for both
max_transfer_size and max_message_size (spi-sc18is602).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h             |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 28 +++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c         | 16 +++++------
 .../net/dsa/sja1105/sja1105_static_config.h   |  2 ++
 4 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index f9e87fb33da0..7ec40c4b2d5a 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -209,6 +209,7 @@ struct sja1105_private {
 	unsigned long ucast_egress_floods;
 	unsigned long bcast_egress_floods;
 	const struct sja1105_info *info;
+	size_t max_xfer_len;
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1d2d34d40f84..585142caa5b0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3563,6 +3563,7 @@ static int sja1105_probe(struct spi_device *spi)
 	struct sja1105_tagger_data *tagger_data;
 	struct device *dev = &spi->dev;
 	struct sja1105_private *priv;
+	size_t max_xfer, max_msg;
 	struct dsa_switch *ds;
 	int rc, port;
 
@@ -3596,6 +3597,33 @@ static int sja1105_probe(struct spi_device *spi)
 		return rc;
 	}
 
+	/* In sja1105_xfer, we send spi_messages composed of two spi_transfers:
+	 * a small one for the message header and another one for the current
+	 * chunk of the packed buffer.
+	 * Check that the restrictions imposed by the SPI controller are
+	 * respected: the chunk buffer is smaller than the max transfer size,
+	 * and the total length of the chunk plus its message header is smaller
+	 * than the max message size.
+	 * We do that during probe time since the maximum transfer size is a
+	 * runtime invariant.
+	 */
+	max_xfer = spi_max_transfer_size(spi);
+	max_msg = spi_max_message_size(spi);
+
+	/* We need to send at least one 64-bit word of SPI payload per message
+	 * in order to be able to make useful progress.
+	 */
+	if (max_msg < SJA1105_SIZE_SPI_MSG_HEADER + 8) {
+		dev_err(dev, "SPI master cannot send large enough buffers, aborting\n");
+		return -EINVAL;
+	}
+
+	priv->max_xfer_len = SJA1105_SIZE_SPI_MSG_MAXLEN;
+	if (priv->max_xfer_len > max_xfer)
+		priv->max_xfer_len = max_xfer;
+	if (priv->max_xfer_len > max_msg - SJA1105_SIZE_SPI_MSG_HEADER)
+		priv->max_xfer_len = max_msg - SJA1105_SIZE_SPI_MSG_HEADER;
+
 	priv->info = of_device_get_match_data(dev);
 
 	/* Detect hardware device */
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 8746e3f158a0..5a7b404bf3ce 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -8,8 +8,6 @@
 #include "sja1105.h"
 
 #define SJA1105_SIZE_RESET_CMD		4
-#define SJA1105_SIZE_SPI_MSG_HEADER	4
-#define SJA1105_SIZE_SPI_MSG_MAXLEN	(64 * 4)
 
 struct sja1105_chunk {
 	u8	*buf;
@@ -40,19 +38,19 @@ static int sja1105_xfer(const struct sja1105_private *priv,
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
 	int num_chunks;
 	int rc, i = 0;
 
-	num_chunks = DIV_ROUND_UP(len, SJA1105_SIZE_SPI_MSG_MAXLEN);
+	num_chunks = DIV_ROUND_UP(len, priv->max_xfer_len);
+
+	chunk.reg_addr = reg_addr;
+	chunk.buf = buf;
+	chunk.len = min_t(size_t, len, priv->max_xfer_len);
 
 	hdr_xfer = &xfers[0];
 	chunk_xfer = &xfers[1];
@@ -104,7 +102,7 @@ static int sja1105_xfer(const struct sja1105_private *priv,
 		chunk.buf += chunk.len;
 		chunk.reg_addr += chunk.len / 4;
 		chunk.len = min_t(size_t, (ptrdiff_t)(buf + len - chunk.buf),
-				  SJA1105_SIZE_SPI_MSG_MAXLEN);
+				  priv->max_xfer_len);
 
 		rc = spi_sync_transfer(spi, xfers, 2);
 		if (rc < 0) {
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index bc7606899289..779eb6840f05 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -9,6 +9,8 @@
 #include <linux/types.h>
 #include <asm/types.h>
 
+#define SJA1105_SIZE_SPI_MSG_HEADER			4
+#define SJA1105_SIZE_SPI_MSG_MAXLEN			(64 * 4)
 #define SJA1105_SIZE_DEVICE_ID				4
 #define SJA1105_SIZE_TABLE_HEADER			12
 #define SJA1105_SIZE_SCHEDULE_ENTRY			8
-- 
2.25.1

