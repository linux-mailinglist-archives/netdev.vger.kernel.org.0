Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731DF4D73DF
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 09:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiCMIxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 04:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbiCMIxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 04:53:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA5488B0B
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 00:51:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTJx6-0000Z0-FQ
        for netdev@vger.kernel.org; Sun, 13 Mar 2022 09:51:48 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7511D49B7C
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:51:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 333A249B6D;
        Sun, 13 Mar 2022 08:51:40 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3ac87b77;
        Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/13] can: mcp251xfd: ring: increase number of RX-FIFOs to 3 and increase max TX-FIFO depth to 16
Date:   Sun, 13 Mar 2022 09:51:38 +0100
Message-Id: <20220313085138.507062-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313085138.507062-1-mkl@pengutronix.de>
References: <20220313085138.507062-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch increases the number of RX-FIFOs to 3 and the max TX-FIFO
depth to 16. This leads to the following default ring configuration.

CAN-2.0 mode:

| FIFO setup: TEF:         0x400:  8*12 bytes =   96 bytes
| FIFO setup: RX-0: FIFO 1/0x460: 32*20 bytes =  640 bytes
| FIFO setup: RX-1: FIFO 2/0x6e0: 32*20 bytes =  640 bytes
| FIFO setup: RX-2: FIFO 3/0x960: 16*20 bytes =  320 bytes
| FIFO setup: TX:   FIFO 4/0xaa0:  8*16 bytes =  128 bytes
| FIFO setup: free:                              224 bytes

CAN-FD mode:

| FIFO setup: TEF:         0x400:  4*12 bytes =   48 bytes
| FIFO setup: RX-0: FIFO 1/0x430: 16*76 bytes = 1216 bytes
| FIFO setup: RX-1: FIFO 2/0x8f0:  4*76 bytes =  304 bytes
| FIFO setup: TX:   FIFO 3/0xa20:  4*72 bytes =  288 bytes
| FIFO setup: free:                              192 bytes

With the previously added ethtool ring configuration support the RAM
on the chip can now be runtime configured between RX and TX buffers.

Link: https://lore.kernel.org/20220313083640.501791-13-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index c6cb8c3391b3..9cb6b5ad8dda 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -398,7 +398,7 @@ static_assert(MCP251XFD_TIMESTAMP_WORK_DELAY_SEC <
 
 /* FIFO and Ring */
 #define MCP251XFD_FIFO_TEF_NUM 1U
-#define MCP251XFD_FIFO_RX_NUM 1U
+#define MCP251XFD_FIFO_RX_NUM 3U
 #define MCP251XFD_FIFO_TX_NUM 1U
 
 #define MCP251XFD_FIFO_DEPTH 32U
@@ -409,7 +409,7 @@ static_assert(MCP251XFD_TIMESTAMP_WORK_DELAY_SEC <
 #define MCP251XFD_RX_FIFO_DEPTH_COALESCE_MIN 8U
 
 #define MCP251XFD_TX_OBJ_NUM_MIN 2U
-#define MCP251XFD_TX_OBJ_NUM_MAX 8U
+#define MCP251XFD_TX_OBJ_NUM_MAX 16U
 #define MCP251XFD_TX_OBJ_NUM_CAN_DEFAULT 8U
 #define MCP251XFD_TX_OBJ_NUM_CANFD_DEFAULT 4U
 #define MCP251XFD_TX_FIFO_DEPTH_MIN 2U
-- 
2.35.1


