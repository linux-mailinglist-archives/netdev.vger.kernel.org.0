Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289C8D4A56
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 00:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfJKWcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 18:32:17 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46887 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfJKWcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 18:32:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so13424835wrv.13
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 15:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5WmdY21g652vPXHe1ajukC9jzM/szMXOlb03Vp61AEE=;
        b=l9Li//CTRCq87wsSFWS8qbJ2e1pZ6Yz5KNKIy1T3veEjq94s2KpXUfQUHjhMZHGIyh
         WQ2bcVDOETtdaXR7W+MLcs0HvrHs61kyqI9y/izKZbAhaLTo0eWoyUvlmmh/f4crEpOX
         bs57JZ4ri7q4d/WkfxOnk4wvX1WAR334gvXUw3ve8Ym5ztPJH1MDJwRvACDNd02jDPil
         6L52v3jdQjY4epsAhJj5EJFBfnbC6dH5lp5DnQ7bW1BCS93oUVggnHdHDHJheI20wviv
         EvNuU8APkKeFGP13lk/guScRVvAvH2RQBbV5izrJ1PjVfa7NmLI1BpwoXaSQIxC06Wrw
         Ue9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5WmdY21g652vPXHe1ajukC9jzM/szMXOlb03Vp61AEE=;
        b=XxznnMwQeLVjKIpj+IsgJH4AWkMSDZWX9RvEuaUeW/ZJmxUOiQq5G7mkqrqhMLbFmR
         KP5JlA+mZ32QHOGhKj6UUaUkZwtyISPyzmdSmO7wNN9rgWSdOsnDhiS3SXvCpj6x9euX
         ddWGLwHx9eQkqVFExftYcnoRT98y9Q5hQu80Qqv4ZpHPOtzF31j9xRMt2VrGSmb/pP6v
         HEmDWuC+Ba47lN/MSz3wFDke9WNytQh3HyoYIMgwXhf4DUHycaaQB3fhuP5MulRUv1Ek
         lVNimbqi1qgn5B1w1Kb1F3RsfIxzRcuC9ws9OYyKpWcSAjz9FsASXcj6l+73g23dN/0A
         0WLA==
X-Gm-Message-State: APjAAAU/2/gSdG9CCPVXrUDYUrDDQ4EPFwQ9FzXTkZGV3JgIVZvkcslX
        3h65Rr7hIRv19JMNrl+tJEg=
X-Google-Smtp-Source: APXvYqwnc2f1bpVQmUU74kGIyRB6dCyG0KU5c6E5FMdl3h21eF6ctxSUnKSZAQ/hTnqUo3PcFU38Mw==
X-Received: by 2002:a5d:488f:: with SMTP id g15mr657708wrq.9.1570833134871;
        Fri, 11 Oct 2019 15:32:14 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id r27sm25549828wrc.55.2019.10.11.15.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 15:32:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: sja1105: Move sja1105_spi_transfer into sja1105_xfer
Date:   Sat, 12 Oct 2019 01:31:14 +0300
Message-Id: <20191011223115.27197-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011223115.27197-1-olteanv@gmail.com>
References: <20191011223115.27197-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic patch that reduces some boilerplate in the SPI
interaction of the driver.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 48 +++++++++------------------
 1 file changed, 15 insertions(+), 33 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index b224b1a55695..831ac009bb30 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -13,36 +13,6 @@
 #define SJA1105_SIZE_SPI_TRANSFER_MAX	\
 	(SJA1105_SIZE_SPI_MSG_HEADER + SJA1105_SIZE_SPI_MSG_MAXLEN)
 
-static int sja1105_spi_transfer(const struct sja1105_private *priv,
-				const void *tx, void *rx, int size)
-{
-	struct spi_device *spi = priv->spidev;
-	struct spi_transfer transfer = {
-		.tx_buf = tx,
-		.rx_buf = rx,
-		.len = size,
-	};
-	struct spi_message msg;
-	int rc;
-
-	if (size > SJA1105_SIZE_SPI_TRANSFER_MAX) {
-		dev_err(&spi->dev, "SPI message (%d) longer than max of %d\n",
-			size, SJA1105_SIZE_SPI_TRANSFER_MAX);
-		return -EMSGSIZE;
-	}
-
-	spi_message_init(&msg);
-	spi_message_add_tail(&transfer, &msg);
-
-	rc = spi_sync(spi, &msg);
-	if (rc < 0) {
-		dev_err(&spi->dev, "SPI transfer failed: %d\n", rc);
-		return rc;
-	}
-
-	return rc;
-}
-
 static void
 sja1105_spi_message_pack(void *buf, const struct sja1105_spi_message *msg)
 {
@@ -69,10 +39,17 @@ int sja1105_xfer_buf(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
 		     void *packed_buf, size_t size_bytes)
 {
+	const int msg_len = size_bytes + SJA1105_SIZE_SPI_MSG_HEADER;
 	u8 tx_buf[SJA1105_SIZE_SPI_TRANSFER_MAX] = {0};
 	u8 rx_buf[SJA1105_SIZE_SPI_TRANSFER_MAX] = {0};
-	const int msg_len = size_bytes + SJA1105_SIZE_SPI_MSG_HEADER;
+	struct spi_device *spi = priv->spidev;
 	struct sja1105_spi_message msg = {0};
+	struct spi_transfer xfer = {
+		.tx_buf = tx_buf,
+		.rx_buf = rx_buf,
+		.len = msg_len,
+	};
+	struct spi_message m;
 	int rc;
 
 	if (msg_len > SJA1105_SIZE_SPI_TRANSFER_MAX)
@@ -89,9 +66,14 @@ int sja1105_xfer_buf(const struct sja1105_private *priv,
 		memcpy(tx_buf + SJA1105_SIZE_SPI_MSG_HEADER,
 		       packed_buf, size_bytes);
 
-	rc = sja1105_spi_transfer(priv, tx_buf, rx_buf, msg_len);
-	if (rc < 0)
+	spi_message_init(&m);
+	spi_message_add_tail(&xfer, &m);
+
+	rc = spi_sync(spi, &m);
+	if (rc < 0) {
+		dev_err(&spi->dev, "SPI transfer failed: %d\n", rc);
 		return rc;
+	}
 
 	if (rw == SPI_READ)
 		memcpy(packed_buf, rx_buf + SJA1105_SIZE_SPI_MSG_HEADER,
-- 
2.17.1

