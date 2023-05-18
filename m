Return-Path: <netdev+bounces-3524-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E85C707B05
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F788281819
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C80732A9E6;
	Thu, 18 May 2023 07:33:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E1F2A9E5
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:33:15 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB932D7B
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:32:56 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pzY7z-00011R-At
	for netdev@vger.kernel.org; Thu, 18 May 2023 09:32:47 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id B75971C7A2A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:32:45 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 0ED3B1C7A01;
	Thu, 18 May 2023 07:32:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 01b74c09;
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
Subject: [PATCH net 4/7] can: kvaser_pciefd: Empty SRB buffer in probe
Date: Thu, 18 May 2023 09:32:38 +0200
Message-Id: <20230518073241.1110453-5-mkl@pengutronix.de>
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

Empty the "Shared receive buffer" (SRB) in probe, to assure we start in a
known state, and don't process any irrelevant packets.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20230516134318.104279-5-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/kvaser_pciefd.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 4b8591d48735..0e03c1cd47b3 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -71,10 +71,12 @@ MODULE_DESCRIPTION("CAN driver for Kvaser CAN/PCIe devices");
 #define KVASER_PCIEFD_SYSID_BUILD_REG (KVASER_PCIEFD_SYSID_BASE + 0x14)
 /* Shared receive buffer registers */
 #define KVASER_PCIEFD_SRB_BASE 0x1f200
+#define KVASER_PCIEFD_SRB_FIFO_LAST_REG (KVASER_PCIEFD_SRB_BASE + 0x1f4)
 #define KVASER_PCIEFD_SRB_CMD_REG (KVASER_PCIEFD_SRB_BASE + 0x200)
 #define KVASER_PCIEFD_SRB_IEN_REG (KVASER_PCIEFD_SRB_BASE + 0x204)
 #define KVASER_PCIEFD_SRB_IRQ_REG (KVASER_PCIEFD_SRB_BASE + 0x20c)
 #define KVASER_PCIEFD_SRB_STAT_REG (KVASER_PCIEFD_SRB_BASE + 0x210)
+#define KVASER_PCIEFD_SRB_RX_NR_PACKETS_REG (KVASER_PCIEFD_SRB_BASE + 0x214)
 #define KVASER_PCIEFD_SRB_CTRL_REG (KVASER_PCIEFD_SRB_BASE + 0x218)
 /* EPCS flash controller registers */
 #define KVASER_PCIEFD_SPI_BASE 0x1fc00
@@ -111,6 +113,9 @@ MODULE_DESCRIPTION("CAN driver for Kvaser CAN/PCIe devices");
 /* DMA support */
 #define KVASER_PCIEFD_SRB_STAT_DMA BIT(24)
 
+/* SRB current packet level */
+#define KVASER_PCIEFD_SRB_RX_NR_PACKETS_MASK 0xff
+
 /* DMA Enable */
 #define KVASER_PCIEFD_SRB_CTRL_DMA_ENABLE BIT(0)
 
@@ -1061,6 +1066,7 @@ static int kvaser_pciefd_setup_dma(struct kvaser_pciefd *pcie)
 {
 	int i;
 	u32 srb_status;
+	u32 srb_packet_count;
 	dma_addr_t dma_addr[KVASER_PCIEFD_DMA_COUNT];
 
 	/* Disable the DMA */
@@ -1088,6 +1094,15 @@ static int kvaser_pciefd_setup_dma(struct kvaser_pciefd *pcie)
 		  KVASER_PCIEFD_SRB_CMD_RDB1,
 		  pcie->reg_base + KVASER_PCIEFD_SRB_CMD_REG);
 
+	/* Empty Rx FIFO */
+	srb_packet_count = ioread32(pcie->reg_base + KVASER_PCIEFD_SRB_RX_NR_PACKETS_REG) &
+			   KVASER_PCIEFD_SRB_RX_NR_PACKETS_MASK;
+	while (srb_packet_count) {
+		/* Drop current packet in FIFO */
+		ioread32(pcie->reg_base + KVASER_PCIEFD_SRB_FIFO_LAST_REG);
+		srb_packet_count--;
+	}
+
 	srb_status = ioread32(pcie->reg_base + KVASER_PCIEFD_SRB_STAT_REG);
 	if (!(srb_status & KVASER_PCIEFD_SRB_STAT_DI)) {
 		dev_err(&pcie->pci->dev, "DMA not idle before enabling\n");
-- 
2.39.2



