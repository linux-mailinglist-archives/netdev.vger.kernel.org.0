Return-Path: <netdev+bounces-3525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EB2A707B0C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FDE11C2105B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948D52A9EB;
	Thu, 18 May 2023 07:33:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE52B3C2F
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:33:16 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E24330C4
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:32:58 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pzY7z-00013T-P2
	for netdev@vger.kernel.org; Thu, 18 May 2023 09:32:47 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id 8D3EB1C7A38
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:32:46 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 32F721C7A05;
	Thu, 18 May 2023 07:32:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c2eb8f26;
	Thu, 18 May 2023 07:32:42 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de,
	Jimmy Assarsson <extja@kvaser.com>,
	stable@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 5/7] can: kvaser_pciefd: Do not send EFLUSH command on TFD interrupt
Date: Thu, 18 May 2023 09:32:39 +0200
Message-Id: <20230518073241.1110453-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230518073241.1110453-1-mkl@pengutronix.de>
References: <20230518073241.1110453-1-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jimmy Assarsson <extja@kvaser.com>

Under certain circumstances we send two EFLUSH commands, resulting in two
EFLUSH ack packets, while only expecting a single EFLUSH ack.
This can cause the driver Tx flush completion to get out of sync.

To avoid this problem, don't enable the "Transmit buffer flush done" (TFD)
interrupt and remove the code handling it.
Now we only send EFLUSH command after receiving status packet with
"Init detected" (IDET) bit set.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20230516134318.104279-6-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/kvaser_pciefd.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 0e03c1cd47b3..4fafb7658349 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -531,7 +531,7 @@ static int kvaser_pciefd_set_tx_irq(struct kvaser_pciefd_can *can)
 	      KVASER_PCIEFD_KCAN_IRQ_TOF | KVASER_PCIEFD_KCAN_IRQ_ABD |
 	      KVASER_PCIEFD_KCAN_IRQ_TAE | KVASER_PCIEFD_KCAN_IRQ_TAL |
 	      KVASER_PCIEFD_KCAN_IRQ_FDIC | KVASER_PCIEFD_KCAN_IRQ_BPP |
-	      KVASER_PCIEFD_KCAN_IRQ_TAR | KVASER_PCIEFD_KCAN_IRQ_TFD;
+	      KVASER_PCIEFD_KCAN_IRQ_TAR;
 
 	iowrite32(msk, can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 
@@ -579,7 +579,7 @@ static void kvaser_pciefd_start_controller_flush(struct kvaser_pciefd_can *can)
 
 	spin_lock_irqsave(&can->lock, irq);
 	iowrite32(-1, can->reg_base + KVASER_PCIEFD_KCAN_IRQ_REG);
-	iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD | KVASER_PCIEFD_KCAN_IRQ_TFD,
+	iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD,
 		  can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 
 	status = ioread32(can->reg_base + KVASER_PCIEFD_KCAN_STAT_REG);
@@ -622,7 +622,7 @@ static int kvaser_pciefd_bus_on(struct kvaser_pciefd_can *can)
 	iowrite32(0, can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 	iowrite32(-1, can->reg_base + KVASER_PCIEFD_KCAN_IRQ_REG);
 
-	iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD | KVASER_PCIEFD_KCAN_IRQ_TFD,
+	iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD,
 		  can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 
 	mode = ioread32(can->reg_base + KVASER_PCIEFD_KCAN_MODE_REG);
@@ -1015,8 +1015,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		SET_NETDEV_DEV(netdev, &pcie->pci->dev);
 
 		iowrite32(-1, can->reg_base + KVASER_PCIEFD_KCAN_IRQ_REG);
-		iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD |
-			  KVASER_PCIEFD_KCAN_IRQ_TFD,
+		iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD,
 			  can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 
 		pcie->can[i] = can;
@@ -1443,9 +1442,6 @@ static int kvaser_pciefd_handle_status_packet(struct kvaser_pciefd *pcie,
 		cmd = KVASER_PCIEFD_KCAN_CMD_AT;
 		cmd |= ++can->cmd_seq << KVASER_PCIEFD_KCAN_CMD_SEQ_SHIFT;
 		iowrite32(cmd, can->reg_base + KVASER_PCIEFD_KCAN_CMD_REG);
-
-		iowrite32(KVASER_PCIEFD_KCAN_IRQ_TFD,
-			  can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 	} else if (p->header[0] & KVASER_PCIEFD_SPACK_IDET &&
 		   p->header[0] & KVASER_PCIEFD_SPACK_IRM &&
 		   cmdseq == (p->header[1] & KVASER_PCIEFD_PACKET_SEQ_MSK) &&
@@ -1732,15 +1728,6 @@ static int kvaser_pciefd_transmit_irq(struct kvaser_pciefd_can *can)
 	if (irq & KVASER_PCIEFD_KCAN_IRQ_TOF)
 		netdev_err(can->can.dev, "Tx FIFO overflow\n");
 
-	if (irq & KVASER_PCIEFD_KCAN_IRQ_TFD) {
-		u8 count = ioread32(can->reg_base +
-				    KVASER_PCIEFD_KCAN_TX_NPACKETS_REG) & 0xff;
-
-		if (count == 0)
-			iowrite32(KVASER_PCIEFD_KCAN_CTRL_EFLUSH,
-				  can->reg_base + KVASER_PCIEFD_KCAN_CTRL_REG);
-	}
-
 	if (irq & KVASER_PCIEFD_KCAN_IRQ_BPP)
 		netdev_err(can->can.dev,
 			   "Fail to change bittiming, when not in reset mode\n");
-- 
2.39.2



