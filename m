Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01AAC40E5
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfJATSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:18:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52956 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbfJATSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:18:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id r19so4605165wmh.2
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 12:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rbyJqNCdXz2RFUhcSqrk7ULuC1dwk4W3nZOwlVkdZdc=;
        b=qtDnmWIr2/ZwcXHiwdeQb22ybJiij5Pu6gV3sOk68sO0gpCFtp5uvY02x6d7V2W1IV
         s1m2uL/RvIKTKnLZuI4TSvhWSlIjF2r4dy/S3rPLEGKMzJ9fN2sH3sDiwM7xttiIL09T
         LMxi9Ty0Myt0pOOA2BZuBs3Ll247daR5Otyli6TrTMTCmDLSVvjivf9wjdWTdvDJNfdh
         jY3h/D4jbFSlXhDLTWZiuJez7Fg5s6IPwiSoQnm0wTKtUHDSBXErkGwNS9bWvOTAZQR7
         XRf1dNNn31njxM6Mf4vSpkbmPq5cGr67wrOZRAnp9PZQug5O1hwhzues5E5whIly/dBA
         HqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rbyJqNCdXz2RFUhcSqrk7ULuC1dwk4W3nZOwlVkdZdc=;
        b=n2x71VvwOiL9cxR1rdIloGqFJHboHm1+Kgw78e42xYsYzgzA5jHM5+9kSb6C4i3k8O
         gWl5u+yzImDbbD/GBZlIP1TLlebN8i0gol7nTcMa202I4WGt1lswPNHUeJr0HNLxmXxB
         DZGU7FHIDJBhXj+b3CWRc03QhsetGSM+2UkoxUDA6jcv2H2oZ8FVvNhiEa1X66om85J/
         GAPs3nT5GeglqCj4JdG7pbPnei2bDyK7BDwHTcwx0rhRDtnFx2mBeKh2536Em3Obk80Z
         0aoW+ZGZ7ZC3QujH+2XB03Ke7tPEtbKAdhRf4CjR71Nti2+3kEBoxwjGF2PtIkpSAp+5
         vL2g==
X-Gm-Message-State: APjAAAUdh2XJX2rauFy5vV9R5djcLnBE5m9gYCngRILO5rtiRRHtRMsR
        7q72HBffgcIjd7jaOv2VpOw=
X-Google-Smtp-Source: APXvYqwD+O21QXQp5RqQPpDX4OzOyBo32l8qIhpw1JrwpbkEz4M1hH1rCTCtX+0dnupARwTqv0yr+Q==
X-Received: by 2002:a1c:d183:: with SMTP id i125mr5273409wmg.1.1569957507884;
        Tue, 01 Oct 2019 12:18:27 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id e6sm15214299wrp.91.2019.10.01.12.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:18:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: sja1105: Replace sja1105_spi_send_int with sja1105_xfer_{u32,u64}
Date:   Tue,  1 Oct 2019 22:18:00 +0300
Message-Id: <20191001191801.9130-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191001191801.9130-1-olteanv@gmail.com>
References: <20191001191801.9130-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having a function that takes a variable number of unpacked bytes which
it generically calls an "int" is confusing and makes auditing patches
next to impossible.

We only use spi_send_int with the int sizes of 32 and 64 bits. So just
make the spi_send_int function less generic and replace it with the
appropriate two explicit functions, which can now type-check the int
pointer type.

Note that there is still a small weirdness in the u32 function, which
has to convert it to a u64 temporary. This is because of how the packing
API works at the moment, but the weirdness is at least hidden from
callers of sja1105_xfer_u32 now.

Suggested-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  7 +--
 drivers/net/dsa/sja1105/sja1105_main.c |  7 ++-
 drivers/net/dsa/sja1105/sja1105_ptp.c  |  3 +-
 drivers/net/dsa/sja1105/sja1105_spi.c  | 62 ++++++++++++++++----------
 4 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index e53e494c22e0..cba0beb87d9c 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -130,9 +130,10 @@ int sja1105_static_config_reload(struct sja1105_private *priv);
 int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 				sja1105_spi_rw_mode_t rw, u64 reg_addr,
 				void *packed_buf, size_t size_bytes);
-int sja1105_spi_send_int(const struct sja1105_private *priv,
-			 sja1105_spi_rw_mode_t rw, u64 reg_addr,
-			 u64 *value, u64 size_bytes);
+int sja1105_xfer_u32(const struct sja1105_private *priv,
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u32 *value);
+int sja1105_xfer_u64(const struct sja1105_private *priv,
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u64 *value);
 int sja1105_spi_send_long_packed_buf(const struct sja1105_private *priv,
 				     sja1105_spi_rw_mode_t rw, u64 base_addr,
 				     void *packed_buf, u64 buf_len);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1127b7a51bc8..b95c7163ea5e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2112,17 +2112,16 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 	const struct sja1105_regs *regs = priv->info->regs;
 	u8 prod_id[SJA1105_SIZE_DEVICE_ID] = {0};
 	struct device *dev = &priv->spidev->dev;
-	u64 device_id;
+	u32 device_id;
 	u64 part_no;
 	int rc;
 
-	rc = sja1105_spi_send_int(priv, SPI_READ, regs->device_id,
-				  &device_id, SJA1105_SIZE_DEVICE_ID);
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->device_id, &device_id);
 	if (rc < 0)
 		return rc;
 
 	if (device_id != priv->info->device_id) {
-		dev_err(dev, "Expected device ID 0x%llx but read 0x%llx\n",
+		dev_err(dev, "Expected device ID 0x%llx but read 0x%x\n",
 			priv->info->device_id, device_id);
 		return -ENODEV;
 	}
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index d8e8dd59f3d1..42cc698fcc90 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -327,8 +327,7 @@ static u64 sja1105_ptptsclk_read(const struct cyclecounter *cc)
 	u64 ptptsclk = 0;
 	int rc;
 
-	rc = sja1105_spi_send_int(priv, SPI_READ, regs->ptptsclk,
-				  &ptptsclk, 8);
+	rc = sja1105_xfer_u64(priv, SPI_READ, regs->ptptsclk, &ptptsclk);
 	if (rc < 0)
 		dev_err_ratelimited(priv->ds->dev,
 				    "failed to read ptp cycle counter: %d\n",
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 58dd37ecde17..a05d746510c0 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -7,7 +7,6 @@
 #include <linux/packing.h>
 #include "sja1105.h"
 
-#define SJA1105_SIZE_PORT_CTRL		4
 #define SJA1105_SIZE_RESET_CMD		4
 #define SJA1105_SIZE_SPI_MSG_HEADER	4
 #define SJA1105_SIZE_SPI_MSG_MAXLEN	(64 * 4)
@@ -103,35 +102,52 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 
 /* If @rw is:
  * - SPI_WRITE: creates and sends an SPI write message at absolute
- *		address reg_addr, taking size_bytes from *packed_buf
+ *		address reg_addr
  * - SPI_READ:  creates and sends an SPI read message from absolute
- *		address reg_addr, writing size_bytes into *packed_buf
+ *		address reg_addr
  *
  * The u64 *value is unpacked, meaning that it's stored in the native
  * CPU endianness and directly usable by software running on the core.
- *
- * This is a wrapper around sja1105_spi_send_packed_buf().
  */
-int sja1105_spi_send_int(const struct sja1105_private *priv,
-			 sja1105_spi_rw_mode_t rw, u64 reg_addr,
-			 u64 *value, u64 size_bytes)
+int sja1105_xfer_u64(const struct sja1105_private *priv,
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u64 *value)
 {
-	u8 packed_buf[SJA1105_SIZE_SPI_MSG_MAXLEN];
+	u8 packed_buf[8];
 	int rc;
 
-	if (size_bytes > SJA1105_SIZE_SPI_MSG_MAXLEN)
-		return -ERANGE;
-
 	if (rw == SPI_WRITE)
-		sja1105_pack(packed_buf, value, 8 * size_bytes - 1, 0,
-			     size_bytes);
+		sja1105_pack(packed_buf, value, 63, 0, 8);
 
-	rc = sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf,
-					 size_bytes);
+	rc = sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf, 8);
 
 	if (rw == SPI_READ)
-		sja1105_unpack(packed_buf, value, 8 * size_bytes - 1, 0,
-			       size_bytes);
+		sja1105_unpack(packed_buf, value, 63, 0, 8);
+
+	return rc;
+}
+
+/* Same as above, but transfers only a 4 byte word */
+int sja1105_xfer_u32(const struct sja1105_private *priv,
+		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u32 *value)
+{
+	u8 packed_buf[4];
+	u64 tmp;
+	int rc;
+
+	if (rw == SPI_WRITE) {
+		/* The packing API only supports u64 as CPU word size,
+		 * so we need to convert.
+		 */
+		tmp = *value;
+		sja1105_pack(packed_buf, &tmp, 31, 0, 4);
+	}
+
+	rc = sja1105_spi_send_packed_buf(priv, rw, reg_addr, packed_buf, 4);
+
+	if (rw == SPI_READ) {
+		sja1105_unpack(packed_buf, &tmp, 31, 0, 4);
+		*value = tmp;
+	}
 
 	return rc;
 }
@@ -287,11 +303,11 @@ int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		       unsigned long port_bitmap, bool tx_inhibited)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
-	u64 inhibit_cmd;
+	u32 inhibit_cmd;
 	int rc;
 
-	rc = sja1105_spi_send_int(priv, SPI_READ, regs->port_control,
-				  &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->port_control,
+			      &inhibit_cmd);
 	if (rc < 0)
 		return rc;
 
@@ -300,8 +316,8 @@ int sja1105_inhibit_tx(const struct sja1105_private *priv,
 	else
 		inhibit_cmd &= ~port_bitmap;
 
-	return sja1105_spi_send_int(priv, SPI_WRITE, regs->port_control,
-				    &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
+	return sja1105_xfer_u32(priv, SPI_WRITE, regs->port_control,
+				&inhibit_cmd);
 }
 
 struct sja1105_status {
-- 
2.17.1

