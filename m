Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493C04F557
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 12:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfFVKqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 06:46:22 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50239 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfFVKqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 06:46:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id c66so8457723wmf.0
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 03:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2Nrlxsx+Gz/SixwTHGIo/kJmiDEFkscBqwJrwGCY8Qg=;
        b=IhoSuUEz99LHBbk0+osJF4XpdaIoYd6Qs2QXEpYMVETDpTQ+b1+8etOYXFb415r864
         iXO67j91qoHoi2Do4Lnenrz5TN/I5PsFCFo4KgpcQ+C0bjkXoDEB3IMbB80GhTwZJfCr
         gD7DCJIONF2hvGabebe6VOAbmbv0ZDIp0u71m2zG6rKYofoIRgAoBEUpFNhCbAWo41N7
         f8NrSzX+xK+y4438O5rHtWZeJxk+vuynOwV4cZFMliM8/IBP87/iVqmRSzFKUt1LyQoH
         wVLkWPrUH6xhMNWBHUZLtkNg2UbGXU/FojS182eX0Ii1gLHWPzDckbxyCyzHJhCLT1Cr
         /HMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2Nrlxsx+Gz/SixwTHGIo/kJmiDEFkscBqwJrwGCY8Qg=;
        b=ZMAEK+hYcH97IKl9CFVX44oafVjEuTrCCFyIvSTBZaZNQFK7DlWaj1j8GRzEW3JMNx
         YZVWxqo5VPypbmSZd8ESXoVUIGZQxyBPO6vv64ATzjTC7Zgi+T34dTM7CS8lom3phyMH
         JxncXtfYljnJxuzuVp7+YGxMFncQg8vT0JHpLQaGE6zc1rnN9ByOaFiHukf8qfmIRyc7
         rlI5wlySiMRtpMCCFBB3ifXzrp0ZxaJZ5+1Bp5WVxd2zUDceMSJTQNSED3wmzDJybeuj
         megR7tBsCv5g2Hl1F5TlZaRZ4rNkbD/gp/pK2EHNo10AGnspbuHmqZtOaH8GYS3Y0ByY
         0l/w==
X-Gm-Message-State: APjAAAU/aImn1//6HlhUnVMTI9tmBnXhYk/Q8TmjnAu3WyIb8IUz5hiR
        g2SvcJD+VusGgw==
X-Google-Smtp-Source: APXvYqyQs8sOB1JD3VCGUkbLwFEQHknIKywydRmFLmLenRjhS1eLH4YOl9gse8v4ZG+L49EXteYdlQ==
X-Received: by 2002:a1c:c583:: with SMTP id v125mr7357635wmf.158.1561200379261;
        Sat, 22 Jun 2019 03:46:19 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-95-223-112-76.hsi16.unitymediagroup.de. [95.223.112.76])
        by smtp.gmail.com with ESMTPSA id o8sm4840695wrj.71.2019.06.22.03.46.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 22 Jun 2019 03:46:18 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     venza@brownhat.org, netdev@vger.kernel.org
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] sis900: remove TxIDLE
Date:   Sat, 22 Jun 2019 12:43:58 +0200
Message-Id: <20190622104358.19782-1-sergej.benilov@googlemail.com>
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
 drivers/net/ethernet/sis/sis900.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index dff5b567..abb9b42e 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -176,7 +176,7 @@ struct sis900_private {
 
 	u32 msg_enable;
 
-	unsigned int cur_rx, dirty_rx; /* producer/comsumer pointers for Tx/Rx ring */
+	unsigned int cur_rx, dirty_rx; /* producer/consumer pointers for Tx/Rx ring */
 	unsigned int cur_tx, dirty_tx;
 
 	/* The saved address of a sent/receive-in-place packet buffer */
@@ -360,8 +360,8 @@ static int sis635_get_mac_addr(struct pci_dev *pci_dev,
  *	SiS962 or SiS963 model, use EEPROM to store MAC address. And EEPROM
  *	is shared by
  *	LAN and 1394. When access EEPROM, send EEREQ signal to hardware first
- *	and wait for EEGNT. If EEGNT is ON, EEPROM is permitted to be access
- *	by LAN, otherwise is not. After MAC address is read from EEPROM, send
+ *	and wait for EEGNT. If EEGNT is ON, EEPROM is permitted to be accessed
+ *	by LAN, otherwise it is not. After MAC address is read from EEPROM, send
  *	EEDONE signal to refuse EEPROM access by LAN.
  *	The EEPROM map of SiS962 or SiS963 is different to SiS900.
  *	The signature field in SiS962 or SiS963 spec is meaningless.
@@ -883,7 +883,7 @@ static void mdio_reset(struct sis900_private *sp)
  *	mdio_read - read MII PHY register
  *	@net_dev: the net device to read
  *	@phy_id: the phy address to read
- *	@location: the phy regiester id to read
+ *	@location: the phy register id to read
  *
  *	Read MII registers through MDIO and MDC
  *	using MDIO management frame structure and protocol(defined by ISO/IEC).
@@ -927,7 +927,7 @@ static int mdio_read(struct net_device *net_dev, int phy_id, int location)
  *	mdio_write - write MII PHY register
  *	@net_dev: the net device to write
  *	@phy_id: the phy address to write
- *	@location: the phy regiester id to write
+ *	@location: the phy register id to write
  *	@value: the register value to write with
  *
  *	Write MII registers with @value through MDIO and MDC
@@ -1058,7 +1058,7 @@ sis900_open(struct net_device *net_dev)
 	sis900_set_mode(sis_priv, HW_SPEED_10_MBPS, FDX_CAPABLE_HALF_SELECTED);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxDESC);
 	sw32(cr, RxENA | sr32(cr));
 	sw32(ier, IE);
 
@@ -1104,7 +1104,7 @@ sis900_init_rxfilter (struct net_device * net_dev)
 		sw32(rfdr, w);
 
 		if (netif_msg_hw(sis_priv)) {
-			printk(KERN_DEBUG "%s: Receive Filter Addrss[%d]=%x\n",
+			printk(KERN_DEBUG "%s: Receive Filter Address[%d]=%x\n",
 			       net_dev->name, i, sr32(rfdr));
 		}
 	}
@@ -1151,7 +1151,7 @@ sis900_init_tx_ring(struct net_device *net_dev)
  *	@net_dev: the net device to initialize for
  *
  *	Initialize the Rx descriptor ring,
- *	and pre-allocate recevie buffers (socket buffer)
+ *	and pre-allocate receive buffers (socket buffer)
  */
 
 static void
@@ -1581,7 +1581,7 @@ static void sis900_tx_timeout(struct net_device *net_dev)
 	sw32(txdp, sis_priv->tx_ring_dma);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxDESC);
 }
 
 /**
@@ -1677,7 +1677,7 @@ static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
 	do {
 		status = sr32(isr);
 
-		if ((status & (HIBERR|TxURN|TxERR|TxIDLE|TxDESC|RxORN|RxERR|RxOK)) == 0)
+		if ((status & (HIBERR|TxURN|TxERR|TxDESC|RxORN|RxERR|RxOK)) == 0)
 			/* nothing intresting happened */
 			break;
 		handled = 1;
@@ -1687,7 +1687,7 @@ static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
 			/* Rx interrupt */
 			sis900_rx(net_dev);
 
-		if (status & (TxURN | TxERR | TxIDLE | TxDESC))
+		if (status & (TxURN | TxERR | TxDESC))
 			/* Tx interrupt */
 			sis900_finish_xmit(net_dev);
 
@@ -1900,7 +1900,7 @@ static void sis900_finish_xmit (struct net_device *net_dev)
 		if (tx_status & OWN) {
 			/* The packet is not transmitted yet (owned by hardware) !
 			 * Note: this is an almost impossible condition
-			 * in case of TxDESC ('descriptor interrupt') */
+			 * on TxDESC interrupt ('descriptor interrupt') */
 			break;
 		}
 
@@ -2476,7 +2476,7 @@ static int sis900_resume(struct pci_dev *pci_dev)
 	sis900_set_mode(sis_priv, HW_SPEED_10_MBPS, FDX_CAPABLE_HALF_SELECTED);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxDESC);
 	sw32(cr, RxENA | sr32(cr));
 	sw32(ier, IE);
 
-- 
2.17.1

