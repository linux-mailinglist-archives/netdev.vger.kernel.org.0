Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824FA46AF1F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378393AbhLGA3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:29:31 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:55754 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348616AbhLGA3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=17BlQ0Nc/a+f1SmI1dQY55iIXTlU1Vab0be80pxxgjc=;
        b=BCwU9Dx7kFHgDgSQb3fZmq8HYm8wg0LcmxrL4LV9E/RRxGKEwHQycLLOfeiou0kndDHv
        nrwh8+mcaqcwu+eQdZq6wNlnfsEVIBL2HGfX9AmqFrlpRYbugyjAmd86lH0/FGLSPyMWuk
        gu3aWLUtPgraK3NQWgGa+jOcC2uLM6mqfjYOtR4BG27FQ7IdqAZ0ahcDfgQSRE8G6nvfiP
        DKfCRkyJswpD1GMg/Xh4lvD4ih/uZ7MiDeFblJJYBAQ28GGbdAbQHnmEn7Meqv4eSRT/fp
        bnI21MlVUJLVPXSLFZzKnsRx0pqPG6xMXK88SqxFy8iboK4OLvYA+2C36GZRHxGw==
Received: by filterdrecv-canary-dcfc8db9-hnrtr with SMTP id filterdrecv-canary-dcfc8db9-hnrtr-1-61AEAA19-13
        2021-12-07 00:26:01.36851827 +0000 UTC m=+8383258.497984442
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-1 (SG)
        with ESMTP
        id qnwCZ_EJQvyS1gCHRjon5w
        Tue, 07 Dec 2021 00:26:01.127 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 7CA9B70016C; Mon,  6 Dec 2021 17:25:59 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH] wilc1000: Remove misleading USE_SPI_DMA macro
Date:   Tue, 07 Dec 2021 00:26:01 +0000 (UTC)
Message-Id: <20211207002453.3193737-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvP7RECUpeCnGI29Sb?=
 =?us-ascii?Q?wPu+Fjg3RkyFVa+cuNilBksvlON6kjOTr6b8xFt?=
 =?us-ascii?Q?+3LSe5HkXQt67nxkaYhXbmKjnXXIdnOK5dXfEr7?=
 =?us-ascii?Q?wt2noCFVXY4CSx7g8=2FV5WW0ZoRuK7hgRp1Jx5sX?=
 =?us-ascii?Q?RfP0dZ86wnXopoWm5alFPxvD32miihYPSGQzd0+?=
 =?us-ascii?Q?=2FFNwbXJDXYTo6Hr3mYywA=3D=3D?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The USE_SPI_DMA macro name suggests that it could be set to 1 to
control whether or not SPI DMA should be used.  However, that's not
what it does.  If set to 1, it'll set the SPI messages'
"is_dma_mapped" flag to true, even though the tx/rx buffers aren't
actually DMA mapped by the driver.  In other words, setting this flag
to 1 will break the driver.

Best to clean up this confusion by removing the macro altogether.
There is no need to explicitly initialize "is_dma_mapped" because the
message is cleared to zero anyhow, so "is_dma_mapped" is set to false
by default.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 640850f989dd..1856525b9834 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -99,8 +99,6 @@ static int wilc_spi_reset(struct wilc *wilc);
 #define DATA_PKT_LOG_SZ				DATA_PKT_LOG_SZ_MAX
 #define DATA_PKT_SZ				(1 << DATA_PKT_LOG_SZ)
 
-#define USE_SPI_DMA				0
-
 #define WILC_SPI_COMMAND_STAT_SUCCESS		0
 #define WILC_GET_RESP_HDR_START(h)		(((h) >> 4) & 0xf)
 
@@ -240,7 +238,6 @@ static int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len)
 		memset(&msg, 0, sizeof(msg));
 		spi_message_init(&msg);
 		msg.spi = spi;
-		msg.is_dma_mapped = USE_SPI_DMA;
 		spi_message_add_tail(&tr, &msg);
 
 		ret = spi_sync(spi, &msg);
@@ -284,7 +281,6 @@ static int wilc_spi_rx(struct wilc *wilc, u8 *rb, u32 rlen)
 		memset(&msg, 0, sizeof(msg));
 		spi_message_init(&msg);
 		msg.spi = spi;
-		msg.is_dma_mapped = USE_SPI_DMA;
 		spi_message_add_tail(&tr, &msg);
 
 		ret = spi_sync(spi, &msg);
@@ -323,7 +319,6 @@ static int wilc_spi_tx_rx(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen)
 		memset(&msg, 0, sizeof(msg));
 		spi_message_init(&msg);
 		msg.spi = spi;
-		msg.is_dma_mapped = USE_SPI_DMA;
 
 		spi_message_add_tail(&tr, &msg);
 		ret = spi_sync(spi, &msg);
-- 
2.25.1

