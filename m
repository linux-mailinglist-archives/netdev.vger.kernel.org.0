Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF71FDA1F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 02:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfD2ASh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 20:18:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33386 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfD2ASN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 20:18:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id s18so13323334wrp.0;
        Sun, 28 Apr 2019 17:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3mywIiFHc2+W1VIMBbrflgmjAz56y4bnA8MVXNfpG/g=;
        b=V7OouUDl6OM4Hj+oUVVBnK2Vnd6YV9lTwAduxkN4Pmn0fdxV1tDAHv5dRcQXyJU7WD
         c+XaJf/kQjn3PtP2dHzUMBvfOf2vKvK9kJUv2IdLkDTBEYoOts+0uklGbIYRy8zxWKeS
         Q0DP5VhOS7OXn1xkebU4WngDzMQYB/fTkBLVB0qMJP+wPqT5CyZgdqYiDOoVwUKJ8b/k
         AO5wst+qFXdn41daYWmI6scRne6yoJUExzSPs4z0ti7xYv7zLuORnxRKUChp8L83XKtQ
         liWB96LAU/WRcRP2QRUODBOwhHmysbsv7Zm8MybvBYAVwknANm8LZCarxdrf0qe2KS3t
         b0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3mywIiFHc2+W1VIMBbrflgmjAz56y4bnA8MVXNfpG/g=;
        b=tawwv8XUhYqfHgrsiZkdJvGLlHx/dm3Qjb7hgyiZs7nR9eJkRlUtzipf+qyoSedOvd
         v6vH7g3M9C2adBIwT+fZu/A8Wr6/A8ytuwIga+WdA2kpFEMgEQKu+LW0G+VzSKLSeqfw
         VjhgHUHsunytSF7GwcS003Vnkj9w/E2MNiUhxjgeTJQ1R9PaOzhqxAb5LZsUvGmvZTEX
         4auItBcYGOUTnn0BBS0pg8Hi/fEBLTPoMzWxztOs0ucLvGwcOxJ8FcAwgJxKA3mxuFi4
         R1WXlMr02Y8D1B7S1ZMnp/W30xQvNheiIP7bTBGy8w3v3euRA7JX9Yc36bDw+4nW5x/L
         HN5A==
X-Gm-Message-State: APjAAAXUFy0Eq26baEl3ZgGI5h8bpMgDkdyJespLTc1Xv4YpiQwvLf02
        PxMKvwilC29Y/CrE5TFYg6I=
X-Google-Smtp-Source: APXvYqzJci00loAHE2cgndP5fCLiJMOwJDZ+/rxkCzykOKJzYSoGBWIdZkjSXgJMEIxW1ghUrH+DTw==
X-Received: by 2002:adf:f70a:: with SMTP id r10mr22325379wrp.96.1556497090903;
        Sun, 28 Apr 2019 17:18:10 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id h16sm5098030wrb.31.2019.04.28.17.18.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 17:18:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 09/12] net: dsa: sja1105: Prevent PHY jabbering during switch reset
Date:   Mon, 29 Apr 2019 03:17:03 +0300
Message-Id: <20190429001706.7449-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190429001706.7449-1-olteanv@gmail.com>
References: <20190429001706.7449-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resetting the switch at runtime is currently done while changing the
vlan_filtering setting (due to the required TPID change).

But reset is asynchronous with packet egress, and the switch core will
not wait for egress to finish before carrying on with the reset
operation.

As a result, a connected PHY such as the BCM5464 would see an
unterminated Ethernet frame and start to jabber (repeat the last seen
Ethernet symbols - jabber is by definition an oversized Ethernet frame
with bad FCS). This behavior is strange in itself, but it also causes
the MACs of some link partners (such as the FRDM-LS1012A) to completely
lock up.

So as a remedy for this situation, when switch reset is required, simply
inhibit Tx on all ports, and wait for the necessary time for the
eventual one frame left in the egress queue (not even the Tx inhibit
command is instantaneous) to be flushed.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v4:
Changed SIZE_PORT_CTRL to SJA1105_SIZE_PORT_CTRL.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/dsa/sja1105/sja1105.h     |  1 +
 drivers/net/dsa/sja1105/sja1105_spi.c | 37 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d91586a6f83e..8722fc88d2cb 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -22,6 +22,7 @@ struct sja1105_regs {
 	u64 device_id;
 	u64 prod_id;
 	u64 status;
+	u64 port_control;
 	u64 rgu;
 	u64 config;
 	u64 rmii_pll1;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index c0b0057b09b3..447014234359 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -7,6 +7,7 @@
 #include <linux/packing.h>
 #include "sja1105.h"
 
+#define SJA1105_SIZE_PORT_CTRL		4
 #define SJA1105_SIZE_RESET_CMD		4
 #define SJA1105_SIZE_SPI_MSG_HEADER	4
 #define SJA1105_SIZE_SPI_MSG_MAXLEN	(64 * 4)
@@ -282,6 +283,25 @@ static int sja1105_cold_reset(const struct sja1105_private *priv)
 	return priv->info->reset_cmd(priv, &reset);
 }
 
+static int sja1105_inhibit_tx(const struct sja1105_private *priv,
+			      const unsigned long *port_bitmap)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u64 inhibit_cmd;
+	int port, rc;
+
+	rc = sja1105_spi_send_int(priv, SPI_READ, regs->port_control,
+				  &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
+	if (rc < 0)
+		return rc;
+
+	for_each_set_bit(port, port_bitmap, SJA1105_NUM_PORTS)
+		inhibit_cmd |= BIT(port);
+
+	return sja1105_spi_send_int(priv, SPI_WRITE, regs->port_control,
+				    &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
+}
+
 struct sja1105_status {
 	u64 configs;
 	u64 crcchkl;
@@ -370,6 +390,7 @@ static_config_buf_prepare_for_upload(struct sja1105_private *priv,
 
 int sja1105_static_config_upload(struct sja1105_private *priv)
 {
+	unsigned long port_bitmap = GENMASK_ULL(SJA1105_NUM_PORTS - 1, 0);
 	struct sja1105_static_config *config = &priv->static_config;
 	const struct sja1105_regs *regs = priv->info->regs;
 	struct device *dev = &priv->spidev->dev;
@@ -388,6 +409,20 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 		dev_err(dev, "Invalid config, cannot upload\n");
 		return -EINVAL;
 	}
+	/* Prevent PHY jabbering during switch reset by inhibiting
+	 * Tx on all ports and waiting for current packet to drain.
+	 * Otherwise, the PHY will see an unterminated Ethernet packet.
+	 */
+	rc = sja1105_inhibit_tx(priv, &port_bitmap);
+	if (rc < 0) {
+		dev_err(dev, "Failed to inhibit Tx on ports\n");
+		return -ENXIO;
+	}
+	/* Wait for an eventual egress packet to finish transmission
+	 * (reach IFG). It is guaranteed that a second one will not
+	 * follow, and that switch cold reset is thus safe
+	 */
+	usleep_range(500, 1000);
 	do {
 		/* Put the SJA1105 in programming mode */
 		rc = sja1105_cold_reset(priv);
@@ -452,6 +487,7 @@ struct sja1105_regs sja1105et_regs = {
 	.device_id = 0x0,
 	.prod_id = 0x100BC3,
 	.status = 0x1,
+	.port_control = 0x11,
 	.config = 0x020000,
 	.rgu = 0x100440,
 	.pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
@@ -476,6 +512,7 @@ struct sja1105_regs sja1105pqrs_regs = {
 	.device_id = 0x0,
 	.prod_id = 0x100BC3,
 	.status = 0x1,
+	.port_control = 0x12,
 	.config = 0x020000,
 	.rgu = 0x100440,
 	.pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
-- 
2.17.1

