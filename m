Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C74C78F806
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfHPApF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36443 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfHPApF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so2712372wme.1;
        Thu, 15 Aug 2019 17:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3Yah3t8T/mdnhruvEQWfJHJ+vipP6Z4GFtySPkMXZTc=;
        b=SmC+i7b7wbUeHt8kIDYSYG72/7QXm9e+r5ihtHbyCx2WELyWTvZ/40gRq3tZhjH/M1
         DFmD6E50R+urdtwLfxj52GdriDzYZZZmeHLnqxsI9L+0zE7kRe7L8fdflL82tdhfWYpC
         I5IhiGgErSVR25/L71ITrHPqsAEF078KMQ8scxKlUYTIaclG/UMnxXJix+TPAw1nAi1c
         PY+LjyRkAJkQ9gbY4Q+U4HNDVb50PekjTiuDJFqacXF9LQq+yd3Oi1SuIH0PjJZQOd5G
         Wd7k/SX+qH0U/7FbP6aS8+D8EufTEQMssE+p0Wp+lYXZEHheOih/8hksUdn8y9ceRUVL
         snPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3Yah3t8T/mdnhruvEQWfJHJ+vipP6Z4GFtySPkMXZTc=;
        b=MhtSJbaBaucKgPYamZce1jlgrrW0O2Ayb43ty4k6K1pncZxRunNBaL0zNku1Sj4KxA
         xuE7qL/JUNDaUVnsw6nfjycSHA7IP7QtFdXX+E/Ratahn7uylWG5p0I38WPR75O7ZJo5
         nY33jgoatujnFEfV/iP2hHpy4PZsAs+/1TvMpYZdeeohy2uVpPseZhHKH2fTuzlJTF+V
         bRRWEneC2PT0edUczXcFpZdAR0k2Pq2oIHSsB7gR3fKsgAEfOq0Kp7hXnW0MOit7zhvq
         hm9I85CSNpc191+FEL5yxAERoAmiGvBowSRS9UfE8FoPM+3Xx7xb18OyWB3Fhg/1uPkJ
         Y8Yw==
X-Gm-Message-State: APjAAAXJkWj+56nk5b1Ja9jPorULBe4Ih135VxQQCfb44PkdhOAFFPuY
        nDQjmLLO5vJ0MGOLE2V1U+g=
X-Google-Smtp-Source: APXvYqwW4HQLALGalVnF1heGI0MXhLgK1vo5hg0gQ44Fgp22KMLxqOknA4XHUea8kOzPDaLHombfRg==
X-Received: by 2002:a05:600c:254c:: with SMTP id e12mr4542046wma.72.1565916303130;
        Thu, 15 Aug 2019 17:45:03 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 01/11] net: dsa: sja1105: Add a debugging GPIO for monitoring SPI latency
Date:   Fri, 16 Aug 2019 03:44:39 +0300
Message-Id: <20190816004449.10100-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am using this to monitor the gettimex64 callback jitter, i.e. the
time it takes for the SPI controller to retrieve the PTP time from the
switch, and therefore the uncertainty in the time that has just been
read.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  4 ++++
 drivers/net/dsa/sja1105/sja1105_main.c | 11 +++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.c  |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 3dbfe41b370e..e6371b2c2df1 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -89,6 +89,7 @@ struct sja1105_private {
 	bool rgmii_tx_delay[SJA1105_NUM_PORTS];
 	const struct sja1105_info *info;
 	struct gpio_desc *reset_gpio;
+	struct gpio_desc *debug_gpio;
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
@@ -126,6 +127,9 @@ typedef enum {
 	SPI_WRITE = 1,
 } sja1105_spi_rw_mode_t;
 
+/* From sja1105_main.c */
+void sja1105_debug_gpio(struct sja1105_private *priv, bool enabled);
+
 /* From sja1105_spi.c */
 int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 				sja1105_spi_rw_mode_t rw, u64 reg_addr,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 17b917d1e6be..82bdc2da8f8f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -23,6 +23,15 @@
 #include <linux/dsa/8021q.h>
 #include "sja1105.h"
 
+void sja1105_debug_gpio(struct sja1105_private *priv, bool enabled)
+{
+	if (IS_ERR(priv->debug_gpio)) {
+		dev_err(priv->ds->dev, "Bad debug GPIO!\n");
+		return;
+	}
+	gpiod_set_value_cansleep(priv->debug_gpio, enabled);
+}
+
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
 			     unsigned int startup_delay)
 {
@@ -2142,6 +2151,8 @@ static int sja1105_probe(struct spi_device *spi)
 	else
 		sja1105_hw_reset(priv->reset_gpio, 1, 1);
 
+	priv->debug_gpio = devm_gpiod_get(dev, "debug", GPIOD_OUT_HIGH);
+
 	/* Populate our driver private structure (priv) based on
 	 * the device tree node that was probed (spi)
 	 */
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 90a595cc596d..51a0014369fc 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -353,8 +353,10 @@ static u64 sja1105_ptptsclk_read(const struct cyclecounter *cc)
 	u64 ptptsclk = 0;
 	int rc;
 
+	sja1105_debug_gpio(priv, 1);
 	rc = sja1105_spi_send_int(priv, SPI_READ, regs->ptptsclk,
 				  &ptptsclk, 8);
+	sja1105_debug_gpio(priv, 0);
 	if (rc < 0)
 		dev_err_ratelimited(priv->ds->dev,
 				    "failed to read ptp cycle counter: %d\n",
-- 
2.17.1

