Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976CC38B06C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 15:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbhETNwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 09:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237905AbhETNwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 09:52:01 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8796DC061574;
        Thu, 20 May 2021 06:50:38 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l4so25392148ejc.10;
        Thu, 20 May 2021 06:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1+eek7zhSyb7W9IYs1NtRILlzr2B7O19v2tlO+UoAKM=;
        b=CdGvOrZxUJMA9XNbmkPXsNUkNe7t82jrEOBjhPv3yi+0mItYOC0EeuCe54Wkie8nRn
         XUKWR2kLmKA4yKmZWYOQ+2zUgR0o1BL1QbXd8L/eNj1Hf068tDszREx0e+04wVNWbA2T
         hlhuVLFIkNzbfyycdc7yAKj7+Qwmp8LcAR74j1ryR7s2SakmhyCrK+i99AfolUj1ech3
         tFjlZITW1zwFkpub7HQ4KM4JlX4KCjJmNunVvYmniAOf2Oxq9nnpfemg+k3rV9KiR6VO
         n64hQ150b3lRA1hGJUhHNAWuXDGNYkdNMFFrscMgZBlyIGmirZvjjFNNC5iaIkiWiAeV
         pkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1+eek7zhSyb7W9IYs1NtRILlzr2B7O19v2tlO+UoAKM=;
        b=T2jOFn5RKCr28oIv45B0uIqOzLNdZbsN98F23vhHrbqbj5ZSV5+S3FDijg4FwZSEY2
         CbigxwAJeTsAl0aOEMyNKOpg/RF68pXp5Shp2yD0VTiYuufd/+Rlm7LyKdntLd4bSgq1
         GPtAjEEyPCU6r4Ibh1kUXMfGuSe0wZ1vZ9Qg52AnDbpUkVeB6emqjNk3dRxQbrA27UDs
         E/l5beenhQfq9FprRIsauW38y1Sp4zm4EfT+AV1lzilx/OlsQyg9yw/6xFlUZ5QTDTa7
         c/NBl23mFfDUQAI1VOpGcTimDp/ISrSFJ3YtdCmTFl8NaIdDm8grfAd6Rpr0p4/HOW8/
         weIw==
X-Gm-Message-State: AOAM532rje+Yx4Yrd+0hx7MTM1Ln8k5E2TG1EMfiBMzBpAtuJJCBnvgF
        uWh5/8kROdbzXav8D1SsD0I=
X-Google-Smtp-Source: ABdhPJxFrSEodLlVHixLQEIfbcVius+bROx7qOBF0VbE/3yls66rzYXs6DreJyE6BnpziKKMH/dnvA==
X-Received: by 2002:a17:906:9159:: with SMTP id y25mr4840324ejw.144.1621518637176;
        Thu, 20 May 2021 06:50:37 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm1449281ejr.63.2021.05.20.06.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 06:50:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: sja1105: adapt to a SPI controller with a limited max transfer size
Date:   Thu, 20 May 2021 16:50:31 +0300
Message-Id: <20210520135031.2969183-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
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

The sja1105 sends its static config to the SPI master as a huge
scatter/gather spi_message - commit 08839c06e96f ("net: dsa: sja1105:
Switch to scatter/gather API for SPI") contains a description of that.
That spi_message contains the following list of spi_transfers:

                |                         |      cs_change
 spi_transfer # |       Contents          | (deassert chip select)
 ---------------|-------------------------|-----------------------
       1        |   SPI message header 1  |         no
       2        |  Static config chunk 1  |         yes
       3        |   SPI message header 2  |         no
       4        |  Static config chunk 2  |         yes
      ...       |           ...           |         ...

Since what the SPI master does not support is keeping the CS asserted
for more than, say, 200 bytes, we must limit the summed length of the
spi_transfers with cs_change deasserted (1+2, 3+4 etc) lower than 200.

This is a bit fuzzy, but I think the proper way to handle this is to
just look at the spi_max_transfer_size() reported by the master, and
adapt to that. We can disregard the spi_max_message_size() limit since I
suppose that assumes no cs_change - but then again, spi_max_transfer_size
is itself capped by spi_max_message_size, which makes sense.

Regression-tested on a switch connected to a controller with no
limitations (spi-fsl-dspi) as well as with one with caps for both
max_transfer_size and max_message_size (spi-sc18is602).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index f7a1514f81e8..ac766def45c8 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -46,18 +46,22 @@ static int sja1105_xfer(const struct sja1105_private *priv,
 			sja1105_spi_rw_mode_t rw, u64 reg_addr, u8 *buf,
 			size_t len, struct ptp_system_timestamp *ptp_sts)
 {
+	struct spi_device *spi = priv->spidev;
 	struct sja1105_chunk chunk = {
-		.len = min_t(size_t, len, SJA1105_SIZE_SPI_MSG_MAXLEN),
 		.reg_addr = reg_addr,
 		.buf = buf,
 	};
-	struct spi_device *spi = priv->spidev;
 	struct spi_transfer *xfers;
+	size_t xfer_len;
 	int num_chunks;
 	int rc, i = 0;
 	u8 *hdr_bufs;
 
-	num_chunks = DIV_ROUND_UP(len, SJA1105_SIZE_SPI_MSG_MAXLEN);
+	xfer_len = min_t(size_t, SJA1105_SIZE_SPI_MSG_MAXLEN,
+			 spi_max_transfer_size(spi) - SJA1105_SIZE_SPI_MSG_HEADER);
+
+	num_chunks = DIV_ROUND_UP(len, xfer_len);
+	chunk.len = min(len, xfer_len);
 
 	/* One transfer for each message header, one for each message
 	 * payload (chunk).
@@ -127,7 +131,7 @@ static int sja1105_xfer(const struct sja1105_private *priv,
 		chunk.buf += chunk.len;
 		chunk.reg_addr += chunk.len / 4;
 		chunk.len = min_t(size_t, (ptrdiff_t)(buf + len - chunk.buf),
-				  SJA1105_SIZE_SPI_MSG_MAXLEN);
+				  xfer_len);
 
 		/* De-assert the chip select after each chunk. */
 		if (chunk.len)
-- 
2.25.1

