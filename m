Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE1955C73
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfFYXkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51576 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFYXkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so225722wma.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cf9RftS2wGBV7Jjhy2XCkfAPVTMuIIwz4M5D/lRL+7g=;
        b=iyRr/zmlvb+HipsrKlS5RYay4lTrj7ub/ef3Gih5qAgdiM4H8WDh6TfN/IL6WFZK6C
         XkLvSXvJE0H/lkycKYbNJJsWcVj/7TAGqCWmoEHhCHqYGMANNOBsv5PMVuiqXFxT0ISh
         mDnNTL2KMi8qhL5drqtJjkDV1h0ad7snRc47hbxa1ZWaNhzWfUKka2nSKE3ViSUIonWJ
         pqn5TFsoGL+tAMiYiuu/aUiySfzYfZ3L9UsReO9yeqGR3XTH2XL4eySJNBPq3EDQW/W9
         3nwgCya1ef4ryx6gI1v8KGOBkuOM+dJPcB9ayo8I8ZkrBO30BrA+7GV7L+itAaV1lJPa
         NKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cf9RftS2wGBV7Jjhy2XCkfAPVTMuIIwz4M5D/lRL+7g=;
        b=mqi7QfdyfvUuVPRuope26zLsPwD7w+onBtVKUWBWnC6t/pIsJHtPSckriCL8CXml0C
         9kWIi+oDDQQS+xEx2p627fbseHJiaBiKza0x+GqcBkJ11R68kDYE3NQMgb/L9C2mJ73s
         EPzkpniXAbsck4ivdcRR5EIP2Owm294zZKqa0DNB98PpCveJUYe6XgmPZ8CGcs+wy5u3
         PdfzCjF4a3CJreOnfK+aAdnAWfIKJqCEJraGFgflob9l5CuAGNKXfeLX/bsOjZ5Zuic7
         zeHvGR2iUCbUJehKpCTqnqZGJCAw8oT8MarOODhlKKofdM+v5YDCWvjksbTzMLUK0Kw4
         Z2pA==
X-Gm-Message-State: APjAAAUAHUJ6ZvLlaYb9F146BPJ1aPLpYrk04YO4hDtgUyx/QmXXEBO8
        nF9yoki2OKpRQomC0OhlBQ3nbRrAy3hCTA==
X-Google-Smtp-Source: APXvYqw68qdcRproWwZM03mb97OpJBAZl0KISRIZRGceKOHGFt4d8lk05ezo/7mCzgAR7qvzOHSwog==
X-Received: by 2002:a1c:1a88:: with SMTP id a130mr202821wma.149.1561506004634;
        Tue, 25 Jun 2019 16:40:04 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 01/10] net: dsa: sja1105: Build PTP support in main DSA driver
Date:   Wed, 26 Jun 2019 02:39:33 +0300
Message-Id: <20190625233942.1946-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Arnd Bergmann pointed out in commit 78fe8a28fb96 ("net: dsa: sja1105:
fix ptp link error"), there is no point in having PTP support as a
separate loadable kernel module.

So remove the exported symbols and make sja1105.ko contain PTP support
or not based on CONFIG_NET_DSA_SJA1105_PTP.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/Makefile                |  2 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c           | 12 ------------
 drivers/net/dsa/sja1105/sja1105_spi.c           |  2 --
 drivers/net/dsa/sja1105/sja1105_static_config.c |  3 ---
 4 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index 9a22f68b39e9..4483113e6259 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -10,5 +10,5 @@ sja1105-objs := \
     sja1105_dynamic_config.o \
 
 ifdef CONFIG_NET_DSA_SJA1105_PTP
-obj-$(CONFIG_NET_DSA_SJA1105) += sja1105_ptp.o
+sja1105-objs += sja1105_ptp.o
 endif
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 3041cf9d5856..c7ce1edd8471 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -77,7 +77,6 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 	info->phc_index = ptp_clock_index(priv->clock);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(sja1105_get_ts_info);
 
 int sja1105et_ptp_cmd(const void *ctx, const void *data)
 {
@@ -95,7 +94,6 @@ int sja1105et_ptp_cmd(const void *ctx, const void *data)
 	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
 					   buf, SJA1105_SIZE_PTP_CMD);
 }
-EXPORT_SYMBOL_GPL(sja1105et_ptp_cmd);
 
 int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
 {
@@ -113,7 +111,6 @@ int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
 	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
 					   buf, SJA1105_SIZE_PTP_CMD);
 }
-EXPORT_SYMBOL_GPL(sja1105pqrs_ptp_cmd);
 
 /* The switch returns partial timestamps (24 bits for SJA1105 E/T, which wrap
  * around in 0.135 seconds, and 32 bits for P/Q/R/S, wrapping around in 34.35
@@ -146,7 +143,6 @@ u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
 
 	return ts_reconstructed;
 }
-EXPORT_SYMBOL_GPL(sja1105_tstamp_reconstruct);
 
 /* Reads the SPI interface for an egress timestamp generated by the switch
  * for frames sent using management routes.
@@ -219,7 +215,6 @@ int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(sja1105_ptpegr_ts_poll);
 
 int sja1105_ptp_reset(struct sja1105_private *priv)
 {
@@ -240,7 +235,6 @@ int sja1105_ptp_reset(struct sja1105_private *priv)
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(sja1105_ptp_reset);
 
 static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
 			       struct timespec64 *ts)
@@ -387,7 +381,6 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv)
 
 	return sja1105_ptp_reset(priv);
 }
-EXPORT_SYMBOL_GPL(sja1105_ptp_clock_register);
 
 void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
 {
@@ -397,8 +390,3 @@ void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
 	ptp_clock_unregister(priv->clock);
 	priv->clock = NULL;
 }
-EXPORT_SYMBOL_GPL(sja1105_ptp_clock_unregister);
-
-MODULE_AUTHOR("Vladimir Oltean <olteanv@gmail.com>");
-MODULE_DESCRIPTION("SJA1105 PHC Driver");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index f7e51debb930..84dc603138cf 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -100,7 +100,6 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(sja1105_spi_send_packed_buf);
 
 /* If @rw is:
  * - SPI_WRITE: creates and sends an SPI write message at absolute
@@ -136,7 +135,6 @@ int sja1105_spi_send_int(const struct sja1105_private *priv,
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(sja1105_spi_send_int);
 
 /* Should be used if a @packed_buf larger than SJA1105_SIZE_SPI_MSG_MAXLEN
  * must be sent/received. Splitting the buffer into chunks and assembling
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 58f273eaf1ea..242f001c59fe 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -35,7 +35,6 @@ void sja1105_pack(void *buf, const u64 *val, int start, int end, size_t len)
 	}
 	dump_stack();
 }
-EXPORT_SYMBOL_GPL(sja1105_pack);
 
 void sja1105_unpack(const void *buf, u64 *val, int start, int end, size_t len)
 {
@@ -53,7 +52,6 @@ void sja1105_unpack(const void *buf, u64 *val, int start, int end, size_t len)
 		       start, end);
 	dump_stack();
 }
-EXPORT_SYMBOL_GPL(sja1105_unpack);
 
 void sja1105_packing(void *buf, u64 *val, int start, int end,
 		     size_t len, enum packing_op op)
@@ -76,7 +74,6 @@ void sja1105_packing(void *buf, u64 *val, int start, int end,
 	}
 	dump_stack();
 }
-EXPORT_SYMBOL_GPL(sja1105_packing);
 
 /* Little-endian Ethernet CRC32 of data packed as big-endian u32 words */
 u32 sja1105_crc32(const void *buf, size_t len)
-- 
2.17.1

