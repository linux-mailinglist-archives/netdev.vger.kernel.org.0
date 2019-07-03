Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F425DBB9
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfGCCRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbfGCCQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A962187F;
        Wed,  3 Jul 2019 02:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120203;
        bh=pPiZcTJu/nrgmFqqkCxRIWlc+nPoNE0A/A7YP8s1ZWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/n2fXsVygW8+FmBMbZ+99oeiSYLATLgtyx+h3zdEC75QfW1fJ9cBc9ZRP9Qp40RZ
         g99E2yjy/sef41IdBZvTyoa/2e5RhMlh5e74rIrn9e6mAl1zmd+Bfveyngz5iZjxoV
         iCH+azYVSgDpoCqxDdbVJWUSX748gTF5wrSDza98=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/26] sis900: fix TX completion
Date:   Tue,  2 Jul 2019 22:16:12 -0400
Message-Id: <20190703021625.18116-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021625.18116-1-sashal@kernel.org>
References: <20190703021625.18116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergej Benilov <sergej.benilov@googlemail.com>

[ Upstream commit 8ac8a01092b2added0749ef937037bf1912e13e3 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sis/sis900.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 4bb89f74742c..d5bcbc40a55f 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -1057,7 +1057,7 @@ sis900_open(struct net_device *net_dev)
 	sis900_set_mode(sis_priv, HW_SPEED_10_MBPS, FDX_CAPABLE_HALF_SELECTED);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
 	sw32(cr, RxENA | sr32(cr));
 	sw32(ier, IE);
 
@@ -1578,7 +1578,7 @@ static void sis900_tx_timeout(struct net_device *net_dev)
 	sw32(txdp, sis_priv->tx_ring_dma);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
 }
 
 /**
@@ -1618,7 +1618,7 @@ sis900_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 			spin_unlock_irqrestore(&sis_priv->lock, flags);
 			return NETDEV_TX_OK;
 	}
-	sis_priv->tx_ring[entry].cmdsts = (OWN | skb->len);
+	sis_priv->tx_ring[entry].cmdsts = (OWN | INTR | skb->len);
 	sw32(cr, TxENA | sr32(cr));
 
 	sis_priv->cur_tx ++;
@@ -1674,7 +1674,7 @@ static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
 	do {
 		status = sr32(isr);
 
-		if ((status & (HIBERR|TxURN|TxERR|TxIDLE|RxORN|RxERR|RxOK)) == 0)
+		if ((status & (HIBERR|TxURN|TxERR|TxIDLE|TxDESC|RxORN|RxERR|RxOK)) == 0)
 			/* nothing intresting happened */
 			break;
 		handled = 1;
@@ -1684,7 +1684,7 @@ static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
 			/* Rx interrupt */
 			sis900_rx(net_dev);
 
-		if (status & (TxURN | TxERR | TxIDLE))
+		if (status & (TxURN | TxERR | TxIDLE | TxDESC))
 			/* Tx interrupt */
 			sis900_finish_xmit(net_dev);
 
@@ -1896,8 +1896,8 @@ static void sis900_finish_xmit (struct net_device *net_dev)
 
 		if (tx_status & OWN) {
 			/* The packet is not transmitted yet (owned by hardware) !
-			 * Note: the interrupt is generated only when Tx Machine
-			 * is idle, so this is an almost impossible case */
+			 * Note: this is an almost impossible condition
+			 * in case of TxDESC ('descriptor interrupt') */
 			break;
 		}
 
@@ -2473,7 +2473,7 @@ static int sis900_resume(struct pci_dev *pci_dev)
 	sis900_set_mode(sis_priv, HW_SPEED_10_MBPS, FDX_CAPABLE_HALF_SELECTED);
 
 	/* Enable all known interrupts by setting the interrupt mask. */
-	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE);
+	sw32(imr, RxSOVR | RxORN | RxERR | RxOK | TxURN | TxERR | TxIDLE | TxDESC);
 	sw32(cr, RxENA | sr32(cr));
 	sw32(ier, IE);
 
-- 
2.20.1

