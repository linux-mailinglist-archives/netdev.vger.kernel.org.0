Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006BB753B6
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 18:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387572AbfGYQSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 12:18:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41398 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfGYQSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 12:18:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so48200288wrm.8
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 09:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6c11XBSlxlpUPDTeDcCA+gOyKsJ/Qa7ZVxOca+/QVnw=;
        b=hKjWQy7vJFRKo3qabGsH4/EofrHv1M3cn/zFDZAPwLAcAnFxAJSxW+AzZ1xsLhRB4m
         XF6dlugbBF4OcBAlCOgIHHpMD3ndtJ8BKtWE/ZMgZ2qG/M92ItflwTzWb0H1OGnZcBv/
         JKrvLFDkT5jyyqPF356lt6lY0QlNGmIbmXnvzRW5NXZHQVSpmq/1tmiOa17KKAQ49rRf
         s3s0MskKC8qsp9B/athy7udRm9HXaUMRVQ3kzKGNXO2vTifThcZ+8RQA4igTFzzBXmto
         omh6TemUDvtwzL4kTznaY3Bb5AeTeF+VEtZiAK6lqx1stXTkHAX0YrdTGK5XrW8egApS
         7LNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6c11XBSlxlpUPDTeDcCA+gOyKsJ/Qa7ZVxOca+/QVnw=;
        b=Ij8OnERWDw6dBPhpUDXod8RG3Ttq2hqiBT7OdpO531G4usxU5v2pt7InU+Zia7/e/S
         73NjWo9XiMLba0yK2BqvGACrLNpiRFwOnKL2r3zXNn5nyKJEP66uDMQbEkqSGmBhB3b/
         5PSUbbkrp2uDy/F72PkN4aJrwTyN2HDPKZab9Zfo9dYSst/5fNmf++gpOWfcGjsPbz5Y
         n90TpmtgAlrShqOyvBlKcThYfNi4e/zx9jBwcJ/QqaJQM2R/JAqqNFD5aFW4sHHh+M3W
         gcPRBU2Q2DZlmhlo2+0YUfArDQDgJhajD/QW6gp/f9iGgKZOX+cEZ9Ggrbp6Ad7vmHg6
         Fndg==
X-Gm-Message-State: APjAAAVf6nqfJZ8jBvZZzYQc5JdmhzeHmqDxHR3Z4Lffm/969e8DzWol
        iA16cyuwiPkV/Q==
X-Google-Smtp-Source: APXvYqyGRcfkQlxgqx0ugx5dDS9W34Dv3AeniIpSfFOJmNJLB1Wg7LVL2cXdgQEkwPSedElPROaegA==
X-Received: by 2002:a5d:4108:: with SMTP id l8mr94191385wrp.113.1564071502328;
        Thu, 25 Jul 2019 09:18:22 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-178-201-112-148.hsi08.unitymediagroup.de. [178.201.112.148])
        by smtp.gmail.com with ESMTPSA id y16sm50576811wrw.33.2019.07.25.09.18.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 09:18:21 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     venza@brownhat.org, netdev@vger.kernel.org, andrew@lunn.ch
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] sis900: add support for ethtool --eeprom-dump
Date:   Thu, 25 Jul 2019 18:18:09 +0200
Message-Id: <20190725161809.14650-1-sergej.benilov@googlemail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement ethtool's EEPROM dump command (ethtool -e|--eeprom-dump).

Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
---
 drivers/net/ethernet/sis/sis900.c | 68 +++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 6e07f5ebacfc..cf9d75ffefc9 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -191,6 +191,8 @@ struct sis900_private {
 	unsigned int tx_full; /* The Tx queue is full. */
 	u8 host_bridge_rev;
 	u8 chipset_rev;
+	/* EEPROM data */
+	int eeprom_size;
 };
 
 MODULE_AUTHOR("Jim Huang <cmhuang@sis.com.tw>, Ollie Lho <ollie@sis.com.tw>");
@@ -475,6 +477,8 @@ static int sis900_probe(struct pci_dev *pci_dev,
 	sis_priv->pci_dev = pci_dev;
 	spin_lock_init(&sis_priv->lock);
 
+	sis_priv->eeprom_size = 24;
+
 	pci_set_drvdata(pci_dev, net_dev);
 
 	ring_space = pci_alloc_consistent(pci_dev, TX_TOTAL_SIZE, &ring_dma);
@@ -2122,6 +2126,68 @@ static void sis900_get_wol(struct net_device *net_dev, struct ethtool_wolinfo *w
 	wol->supported = (WAKE_PHY | WAKE_MAGIC);
 }
 
+static int sis900_get_eeprom_len(struct net_device *dev)
+{
+	struct sis900_private *sis_priv = netdev_priv(dev);
+
+	return sis_priv->eeprom_size;
+}
+
+static int sis900_read_eeprom(struct net_device *net_dev, u8 *buf)
+{
+	struct sis900_private *sis_priv = netdev_priv(net_dev);
+	void __iomem *ioaddr = sis_priv->ioaddr;
+	int wait, ret = -EAGAIN;
+	u16 signature;
+	u16 *ebuf = (u16 *)buf;
+	int i;
+
+	if (sis_priv->chipset_rev == SIS96x_900_REV) {
+		sw32(mear, EEREQ);
+		for (wait = 0; wait < 2000; wait++) {
+			if (sr32(mear) & EEGNT) {
+				/* read 16 bits, and index by 16 bits */
+				for (i = 0; i < sis_priv->eeprom_size / 2; i++)
+					ebuf[i] = (u16)read_eeprom(ioaddr, i);
+			ret = 0;
+			break;
+			}
+		udelay(1);
+		}
+	sw32(mear, EEDONE);
+	} else {
+		signature = (u16)read_eeprom(ioaddr, EEPROMSignature);
+		if (signature != 0xffff && signature != 0x0000) {
+			/* read 16 bits, and index by 16 bits */
+			for (i = 0; i < sis_priv->eeprom_size / 2; i++)
+				ebuf[i] = (u16)read_eeprom(ioaddr, i);
+			ret = 0;
+		}
+	}
+	return ret;
+}
+
+#define SIS900_EEPROM_MAGIC	0xBABE
+static int sis900_get_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom, u8 *data)
+{
+	struct sis900_private *sis_priv = netdev_priv(dev);
+	u8 *eebuf;
+	int res;
+
+	eebuf = kmalloc(sis_priv->eeprom_size, GFP_KERNEL);
+	if (!eebuf)
+		return -ENOMEM;
+
+	eeprom->magic = SIS900_EEPROM_MAGIC;
+	spin_lock_irq(&sis_priv->lock);
+	res = sis900_read_eeprom(dev, eebuf);
+	spin_unlock_irq(&sis_priv->lock);
+	if (!res)
+		memcpy(data, eebuf + eeprom->offset, eeprom->len);
+	kfree(eebuf);
+	return res;
+}
+
 static const struct ethtool_ops sis900_ethtool_ops = {
 	.get_drvinfo 	= sis900_get_drvinfo,
 	.get_msglevel	= sis900_get_msglevel,
@@ -2132,6 +2198,8 @@ static const struct ethtool_ops sis900_ethtool_ops = {
 	.set_wol	= sis900_set_wol,
 	.get_link_ksettings = sis900_get_link_ksettings,
 	.set_link_ksettings = sis900_set_link_ksettings,
+	.get_eeprom_len = sis900_get_eeprom_len,
+	.get_eeprom = sis900_get_eeprom,
 };
 
 /**
-- 
2.17.1

