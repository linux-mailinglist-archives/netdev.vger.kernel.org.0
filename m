Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37D44CA30
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 11:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbfFTJCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 05:02:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40716 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbfFTJCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 05:02:40 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so2162474wre.7
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 02:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H3f+Gbu3ZphTI08lq/1MCi2N3aTwRJaSw4Xo248eExg=;
        b=Gb3bLdsB8zKT0i0zjSm6O1nYp4FbbrXdDdf0yLhCXzQv9Ym8uds/8r0VB74l/6NpwH
         P3F1xHtwiGhs8O8J4f06XBMbAWQXma24XyR0UHv+s3olTYYAgDlx8t73FwTfsXSDuaSR
         4Yc+W9VkgwvRJvtm6w3Ew60csY5HUMXGDyjlE9phXwyk3IWHYiYYTTnDpW3+VujR5mXR
         G6MgOv8S7Cj4pWlvsPKraWZ0oTl7zsRJdlIXbIbN7gnASAvfr8sceLRyyf2iaKbu3h42
         LjHtx3VETfmcalGj+C0bgdhCrM2ppWn5eJRt/Pn1OAjykKIqmZ9l0Vfu+kn5DUOJOVbP
         tXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H3f+Gbu3ZphTI08lq/1MCi2N3aTwRJaSw4Xo248eExg=;
        b=uaK82/29vhcHOY+4ebN1igu6ELGfrTAovEyu2EFSCcN+fg/1ca0y89lBH55aEIjYVq
         VQDuxvSkuH1oSdwdVfNrkWsnjAe2Ferc7ejtbzWc9widsiufhiRjxnF7WRF8GY407dZy
         EGwi9FtmIfyX4IIyEpHzntUzO0kZr8G6L/w0zdUN80V1Y2tXa1Kl0J8mKwcP/CeyBdXa
         oYVp8n6lvnOMxmnpFmmJxsW9fgbWrWk2j7wagVqT4Gk5yZABqR2Y2E1fNM3fXW0NbSRa
         M78Cxx5M7U5Vx35zOvxELR8k9PAnGibbjOLi2+tddA0WhVJRwQjI+RIjCZiM4OmX8LzC
         /IBw==
X-Gm-Message-State: APjAAAWv+Eh/yhNbY27wqxbe8OBf8WEh8eDVlA0tQlgUHCOJVB6roQuB
        JrZ4yXNwZRfMmA==
X-Google-Smtp-Source: APXvYqzix/XftpVqfP/1S2AGVPEPNRm+lhnNrwEDfsYscMlbPjLX/Z6h9VcywpZrcOoym8IDOFJJkQ==
X-Received: by 2002:a5d:6443:: with SMTP id d3mr9894862wrw.279.1561021358050;
        Thu, 20 Jun 2019 02:02:38 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-95-223-112-76.hsi16.unitymediagroup.de. [95.223.112.76])
        by smtp.gmail.com with ESMTPSA id x11sm3659289wmg.23.2019.06.20.02.02.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 02:02:37 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     venza@brownhat.org, netdev@vger.kernel.org
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] sis900: fix TX completion
Date:   Thu, 20 Jun 2019 11:02:18 +0200
Message-Id: <20190620090218.11549-1-sergej.benilov@googlemail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 605ad7f184b60cfaacbc038aa6c55ee68dee3c89 "tcp: refine TSO autosizing",
outbound throughput is dramatically reduced for some connections, as sis900
is doing TX completion within idle states only.

Make TX completion happen after every transmitted packet.

Test:
netperf

before patch:
> netperf -H remote -l -2000000 -- -s 1000000
MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to 95.223.112.76 () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380 327680 327680    253.44      0.06

after patch:
> netperf -H remote -l -10000000 -- -s 1000000
MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to 95.223.112.76 () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380 327680 327680    5.38       14.89

Thx to Dave Miller and Eric Dumazet for helpful hints

Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
---
 drivers/net/ethernet/sis/sis900.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index fd812d2e..dff5b567 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -1058,7 +1058,7 @@ sis900_open(struct net_device *net_dev)
 	sis900_set_mode(sis_priv, HW_SPEED_10_MBPS, FDX_CAPABLE_HALF_SELECTED);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
 	sw32(cr, RxENA | sr32(cr));
 	sw32(ier, IE);
 
@@ -1581,7 +1581,7 @@ static void sis900_tx_timeout(struct net_device *net_dev)
 	sw32(txdp, sis_priv->tx_ring_dma);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
 }
 
 /**
@@ -1621,7 +1621,7 @@ sis900_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 			spin_unlock_irqrestore(&sis_priv->lock, flags);
 			return NETDEV_TX_OK;
 	}
-	sis_priv->tx_ring[entry].cmdsts = (OWN | skb->len);
+	sis_priv->tx_ring[entry].cmdsts = (OWN | INTR | skb->len);
 	sw32(cr, TxENA | sr32(cr));
 
 	sis_priv->cur_tx ++;
@@ -1677,7 +1677,7 @@ static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
 	do {
 		status = sr32(isr);
 
-		if ((status & (HIBERR|TxURN|TxERR|TxIDLE|RxORN|RxERR|RxOK)) == 0)
+		if ((status & (HIBERR|TxURN|TxERR|TxIDLE|TxDESC|RxORN|RxERR|RxOK)) == 0)
 			/* nothing intresting happened */
 			break;
 		handled = 1;
@@ -1687,7 +1687,7 @@ static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
 			/* Rx interrupt */
 			sis900_rx(net_dev);
 
-		if (status & (TxURN | TxERR | TxIDLE))
+		if (status & (TxURN | TxERR | TxIDLE | TxDESC))
 			/* Tx interrupt */
 			sis900_finish_xmit(net_dev);
 
@@ -1899,8 +1899,8 @@ static void sis900_finish_xmit (struct net_device *net_dev)
 
 		if (tx_status & OWN) {
 			/* The packet is not transmitted yet (owned by hardware) !
-			 * Note: the interrupt is generated only when Tx Machine
-			 * is idle, so this is an almost impossible case */
+			 * Note: this is an almost impossible condition
+			 * in case of TxDESC ('descriptor interrupt') */
 			break;
 		}
 
@@ -2476,7 +2476,7 @@ static int sis900_resume(struct pci_dev *pci_dev)
 	sis900_set_mode(sis_priv, HW_SPEED_10_MBPS, FDX_CAPABLE_HALF_SELECTED);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
 	sw32(cr, RxENA | sr32(cr));
 	sw32(ier, IE);
 
-- 
2.17.1

