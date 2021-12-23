Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDE647DD13
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346631AbhLWBPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:47 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27460 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346268AbhLWBOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=xddQg0IvMbQSPuAc5H694hthTJIRjKrXhZw1xq1hEks=;
        b=Wrmx8l0su8dp9ndnFNO6sOW5lBaz+uiSFn7IMZNva52x3OVqh2+M/sZoOYrQVQTYyRs8
        Md/+jjaQSKOr8aoFyr6TuKZsXSXEMia5qHZsgwWiDmnGAen0fPe1z+f3jjOQArqNr1dsT5
        FnGMg9TlUXC3+VHoFrFYzpd7WxFc1I1umCcCnBPmcCXIMxJhmn7CJPF6Lcv9DJz0MfbSr9
        1ZD5xWt5xk86qtbENBu5Oz6SogHrZ1GNfgSqsYi9Ntw+gnUg3xB3K7VIRXMRHOycOwW5Kk
        Yh9HSkAtrTOkCyIHSAztMVeWqXQvdI7AEJTRYhkXwph7WSPBrZK3FGmz4I9fxNag==
Received: by filterdrecv-7bf5c69d5-5zdgz with SMTP id filterdrecv-7bf5c69d5-5zdgz-1-61C3CD5F-9
        2021-12-23 01:14:07.092312815 +0000 UTC m=+9687226.301035880
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-0 (SG)
        with ESMTP
        id VtsPa1YnRSSp8kNi4WOeEw
        Thu, 23 Dec 2021 01:14:06.971 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 03A30701537; Wed, 22 Dec 2021 18:14:06 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 47/50] wilc1000: factor SPI DMA command initialization code
 into a function
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-48-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvANxWyaBzmrT8i6kB?=
 =?us-ascii?Q?IwcOApodCCbwNMcx6CCkJweUuGfzFJsSRyTzgz3?=
 =?us-ascii?Q?Qq5GQeAeySg3GXqJwB66FAOqWelVjAijR0CtrPb?=
 =?us-ascii?Q?zGHOys2MvxM1yipj39z=2F7vjDeqxd=2FQrkC+jt1cU?=
 =?us-ascii?Q?dssIikBscTxUZ2K8RXiAYiBAAReEJ=2FmuiZ3kP4?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
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

Introduce wilc_spi_dma_init_cmd() as a helper function as this will
come in handy later.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 41 +++++++++++++------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 189907580d921..3e2022b43ee70 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -650,21 +650,14 @@ static int wilc_spi_write_cmd(struct wilc *wilc, u8 cmd, u32 adr, u32 data,
 	return 0;
 }
 
-static int wilc_spi_dma_rw(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz)
+static int wilc_spi_dma_init_cmd(struct wilc *wilc, struct wilc_spi_cmd *c,
+				 u8 cmd, u32 adr, u32 sz)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	struct wilc_spi *spi_priv = wilc->bus_data;
-	u16 crc_recv, crc_calc;
-	u8 wb[32], rb[32];
-	int cmd_len, resp_len;
-	int retry, ix = 0;
-	u8 crc[2], *crc7;
-	struct wilc_spi_cmd *c;
-	struct wilc_spi_rsp_data *r;
+	int cmd_len;
+	u8 *crc7;
 
-	memset(wb, 0x0, sizeof(wb));
-	memset(rb, 0x0, sizeof(rb));
-	c = (struct wilc_spi_cmd *)wb;
 	c->cmd_type = cmd;
 	if (cmd == CMD_DMA_WRITE || cmd == CMD_DMA_READ) {
 		c->u.dma_cmd.addr[0] = adr >> 16;
@@ -687,10 +680,32 @@ static int wilc_spi_dma_rw(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz)
 		return -EINVAL;
 	}
 	if (spi_priv->crc7_enabled) {
-		crc7 = wb + cmd_len;
-		*crc7 = wilc_get_crc7(wb, cmd_len);
+		crc7 = (u8 *)c + cmd_len;
+		*crc7 = wilc_get_crc7((u8 *)c, cmd_len);
 		cmd_len += 1;
 	}
+	return cmd_len;
+}
+
+static int wilc_spi_dma_rw(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz)
+{
+	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
+	u16 crc_recv, crc_calc;
+	u8 wb[32], rb[32];
+	int cmd_len, resp_len;
+	int retry, ix = 0;
+	u8 crc[2];
+	struct wilc_spi_cmd *c;
+	struct wilc_spi_rsp_data *r;
+
+	memset(wb, 0x0, sizeof(wb));
+	memset(rb, 0x0, sizeof(rb));
+	c = (struct wilc_spi_cmd *)wb;
+
+	cmd_len = wilc_spi_dma_init_cmd(wilc, c, cmd, adr, sz);
+	if (cmd_len < 0)
+		return -EINVAL;
 
 	resp_len = sizeof(*r);
 
-- 
2.25.1

