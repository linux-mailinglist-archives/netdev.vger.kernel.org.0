Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE8751D02
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfFXVVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:21:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52360 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXVVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:21:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so713210wms.2
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iwtvItmMkFs25cjMLuwyr8zqKx9AmYokRwhDp53U1+0=;
        b=P5ylBfQDUAvHvIlGvR5DYrajnHjfNdj8j3JL/aINoAhI386XAbanj08DPErt95wl7w
         dz1RhabuCxMQvUfG8maS1ouT2G2f8BxUBunXAhe/52WnF1JKDTiuBPq7FaKufW6oOnbf
         3bZ5hm/mXouDAMx1axKgp9Es/vIQNB1UaYNd95r3ZSFc1YkOOZt0jbXazkGBwRaAMWfN
         2rIiOD4mfOs2XjxFa87ed9eufTICKz/xAZwTj7NQG7udw94j2Gju6NQjqd0YWqMIIxf9
         8rszJI1E4JpCxsS0YA766eJtxOfKUIV19+5QhDHKyb7LYKaxmoqI87hRSajX+jzBY4HO
         gqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iwtvItmMkFs25cjMLuwyr8zqKx9AmYokRwhDp53U1+0=;
        b=XfTPmU/gqBKIn0/WEt0bYGyZngDItVT5FaMPxaLnk6olMGTJ9pGlLgD8uJMZ9kj0FG
         jylYpA0T2/4WzknWfOVGq+KAjsFTQS4f//1SFZgXoAoASOAHRkyDB//fPS6F1K0i2bhO
         SuwecLHswiRLC9SuBtYCNcC8HajBm/bBPRaSHZdnGPcYXshjELLiAUzCT5RNAkfedmWQ
         OBJugrcafNBWJfFcmvXzHKciWcvsKM2ZUSgB5DuzHbD2OtSHAA1/CWw9WT9cnpOcNLX8
         e4swiB3sIsQ+yRNBPN7gxBN227kZuxG+rJf/yfyrf5JvbiVFlJi9RYdjuTh8tLsnaokk
         RheQ==
X-Gm-Message-State: APjAAAUEmPuyYefipzWC7GsP+i3z+UmEhB75mScDRBHc5xh7yWYdV1j0
        LLzFWkNCKzG8AP1gKe8=
X-Google-Smtp-Source: APXvYqxZgOChFZvD/8m1zu4jwZr/RrVyECqddpD/vZDEnyXEqYX3770IrmRJkIeUzpFKhQCm7CXjRg==
X-Received: by 2002:a1c:e709:: with SMTP id e9mr16633797wmh.144.1561411305473;
        Mon, 24 Jun 2019 14:21:45 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-95-223-112-76.hsi16.unitymediagroup.de. [95.223.112.76])
        by smtp.gmail.com with ESMTPSA id y44sm11295770wrd.13.2019.06.24.14.21.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 14:21:44 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     venza@brownhat.org, netdev@vger.kernel.org
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] sis900: remove TxIDLE
Date:   Mon, 24 Jun 2019 23:21:02 +0200
Message-Id: <20190624212102.15844-1-sergej.benilov@googlemail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before "sis900: fix TX completion" patch, TX completion was done on TxIDLE interrupt.
TX completion also was the only thing done on TxIDLE interrupt.
Since "sis900: fix TX completion", TX completion is done on TxDESC interrupt.
So it is not necessary any more to set and to check for TxIDLE.

Eliminate TxIDLE from sis900.
Correct some typos, too.

Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
---
 drivers/net/ethernet/sis/sis900.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 9b036c857..aba6eea72 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -360,7 +360,7 @@ static int sis635_get_mac_addr(struct pci_dev *pci_dev,
  *	SiS962 or SiS963 model, use EEPROM to store MAC address. And EEPROM
  *	is shared by
  *	LAN and 1394. When access EEPROM, send EEREQ signal to hardware first
- *	and wait for EEGNT. If EEGNT is ON, EEPROM is permitted to be access
+ *	and wait for EEGNT. If EEGNT is ON, EEPROM is permitted to be accessed
  *	by LAN, otherwise is not. After MAC address is read from EEPROM, send
  *	EEDONE signal to refuse EEPROM access by LAN.
  *	The EEPROM map of SiS962 or SiS963 is different to SiS900.
@@ -882,7 +882,7 @@ static void mdio_reset(struct sis900_private *sp)
  *	mdio_read - read MII PHY register
  *	@net_dev: the net device to read
  *	@phy_id: the phy address to read
- *	@location: the phy regiester id to read
+ *	@location: the phy register id to read
  *
  *	Read MII registers through MDIO and MDC
  *	using MDIO management frame structure and protocol(defined by ISO/IEC).
@@ -926,7 +926,7 @@ static int mdio_read(struct net_device *net_dev, int phy_id, int location)
  *	mdio_write - write MII PHY register
  *	@net_dev: the net device to write
  *	@phy_id: the phy address to write
- *	@location: the phy regiester id to write
+ *	@location: the phy register id to write
  *	@value: the register value to write with
  *
  *	Write MII registers with @value through MDIO and MDC
@@ -1057,7 +1057,7 @@ sis900_open(struct net_device *net_dev)
 	sis900_set_mode(sis_priv, HW_SPEED_10_MBPS, FDX_CAPABLE_HALF_SELECTED);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxDESC);
 	sw32(cr, RxENA | sr32(cr));
 	sw32(ier, IE);
 
@@ -1101,7 +1101,7 @@ sis900_init_rxfilter (struct net_device * net_dev)
 		sw32(rfdr, w);
 
 		if (netif_msg_hw(sis_priv)) {
-			printk(KERN_DEBUG "%s: Receive Filter Addrss[%d]=%x\n",
+			printk(KERN_DEBUG "%s: Receive Filter Address[%d]=%x\n",
 			       net_dev->name, i, sr32(rfdr));
 		}
 	}
@@ -1148,7 +1148,7 @@ sis900_init_tx_ring(struct net_device *net_dev)
  *	@net_dev: the net device to initialize for
  *
  *	Initialize the Rx descriptor ring,
- *	and pre-allocate recevie buffers (socket buffer)
+ *	and pre-allocate receive buffers (socket buffer)
  */
 
 static void
@@ -1578,7 +1578,7 @@ static void sis900_tx_timeout(struct net_device *net_dev)
 	sw32(txdp, sis_priv->tx_ring_dma);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxDESC);
 }
 
 /**
@@ -1674,8 +1674,8 @@ static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
 	do {
 		status = sr32(isr);
 
-		if ((status & (HIBERR|TxURN|TxERR|TxIDLE|TxDESC|RxORN|RxERR|RxOK)) == 0)
-			/* nothing intresting happened */
+		if ((status & (HIBERR|TxURN|TxERR|TxDESC|RxORN|RxERR|RxOK)) == 0)
+			/* nothing interesting happened */
 			break;
 		handled = 1;
 
@@ -1684,7 +1684,7 @@ static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
 			/* Rx interrupt */
 			sis900_rx(net_dev);
 
-		if (status & (TxURN | TxERR | TxIDLE | TxDESC))
+		if (status & (TxURN | TxERR | TxDESC))
 			/* Tx interrupt */
 			sis900_finish_xmit(net_dev);
 
@@ -1897,7 +1897,7 @@ static void sis900_finish_xmit (struct net_device *net_dev)
 		if (tx_status & OWN) {
 			/* The packet is not transmitted yet (owned by hardware) !
 			 * Note: this is an almost impossible condition
-			 * in case of TxDESC ('descriptor interrupt') */
+			 * on TxDESC interrupt ('descriptor interrupt') */
 			break;
 		}
 
@@ -2473,7 +2473,7 @@ static int sis900_resume(struct pci_dev *pci_dev)
 	sis900_set_mode(sis_priv, HW_SPEED_10_MBPS, FDX_CAPABLE_HALF_SELECTED);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxDESC);
 	sw32(cr, RxENA | sr32(cr));
 	sw32(ier, IE);
 
-- 
2.17.1

