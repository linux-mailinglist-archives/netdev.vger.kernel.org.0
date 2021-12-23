Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B7847DD1F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346695AbhLWBQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:01 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27416 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346251AbhLWBOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=xa4Us+PL63HXTtD7NxFyiz9UQq8xrKpb1fAV6hO+Qos=;
        b=WiZqrxgJlOKay0jg9TQu/g1baC7D/NHFCmEBfBMFkyg2Y/etuV58hyWZC1NZspf9lXvi
        f/jbkAQqQ85c1JPaBNTUTKfyzpKvp8/hrhdK0FQ6zM9aU6x6UaII3FO8FBWU24e5QecB7Y
        7bIYYro2Bc9OBEWb3px/lQv2rb07DekYdzV6yUktA2Zn1cft2a5mThYNtCoFrrnDx7Gve3
        90zLzkaEh/l3Jkug+xb6kRY+zKClA1e91wxm+uBSS0N0T2QEpCK/h3npFW1Yfdq15Cynx6
        C6NgCT0pnOr/k43D0G1uleBotenNddXjH4pYkftOpD8MQ26k0VRwwAWl+WkMJKqg==
Received: by filterdrecv-656998cfdd-gwqfx with SMTP id filterdrecv-656998cfdd-gwqfx-1-61C3CD5F-8
        2021-12-23 01:14:07.173124434 +0000 UTC m=+7955180.579837087
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-0 (SG)
        with ESMTP
        id qmYqcDsPSkiR11jDDKCxIg
        Thu, 23 Dec 2021 01:14:07.006 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 0D143701564; Wed, 22 Dec 2021 18:14:06 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 48/50] wilc1000: introduce function to find and check DMA
 response
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-49-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvHaV6O7GMUw=2FW4PJd?=
 =?us-ascii?Q?G4gRHrkryCd=2F53ygKA8OXI7MLM8aSLx7D5aeIlN?=
 =?us-ascii?Q?Edbxks55dlrMYbZ9kHO1bo7vRbn7Y8cDdl2IjRb?=
 =?us-ascii?Q?Zz=2F=2F5QKRcR2xMFKeSMKtXISTHMalO=2FiR9gxhWKJ?=
 =?us-ascii?Q?RaRJxdbe40XWCZxhDEXaGaDaC99ihHTnd410DW?=
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

Refactor DMA response checking from spi_data_rsp() into its own
function spi_data_check_rsp() as that will come in handy later.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 52 +++++++++++--------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 3e2022b43ee70..8951202ed76e2 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -80,6 +80,18 @@ static int wilc_spi_reset(struct wilc *wilc);
 #define PROTOCOL_REG_CRC16_MASK			GENMASK(3, 3)
 #define PROTOCOL_REG_CRC7_MASK			GENMASK(2, 2)
 
+/* The response to data packets is two bytes long.  For efficiency's
+ * sake, when DMAing data to WILC, we ignore the responses for all
+ * data packets except the final one.  The downside of this
+ * optimization is that when the final data packet is short, we may
+ * receive (part of) the response to the second-to-last packet before
+ * the one for the final packet.  To handle this, we always read 4
+ * bytes and then search for the last byte that contains the "Response
+ * Start" code (0xc in the top 4 bits).  We then know that this byte
+ * is the first response byte of the final data packet.
+ */
+#define WILC_SPI_DATA_RSP_BYTES	4
+
 /*
  * The SPI data packet size may be any integer power of two in the
  * range from 256 to 8192 bytes.
@@ -950,31 +962,13 @@ static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 	return 0;
 }
 
-static int spi_data_rsp(struct wilc *wilc, u8 cmd)
+static int spi_data_check_rsp(struct wilc *wilc,
+			      u8 rsp[WILC_SPI_DATA_RSP_BYTES])
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
-	int result, i;
-	u8 rsp[4];
-
-	/*
-	 * The response to data packets is two bytes long.  For
-	 * efficiency's sake, wilc_spi_write() wisely ignores the
-	 * responses for all packets but the final one.  The downside
-	 * of that optimization is that when the final data packet is
-	 * short, we may receive (part of) the response to the
-	 * second-to-last packet before the one for the final packet.
-	 * To handle this, we always read 4 bytes and then search for
-	 * the last byte that contains the "Response Start" code (0xc
-	 * in the top 4 bits).  We then know that this byte is the
-	 * first response byte of the final data packet.
-	 */
-	result = wilc_spi_rx(wilc, rsp, sizeof(rsp));
-	if (result) {
-		dev_err(&spi->dev, "Failed bus error...\n");
-		return result;
-	}
+	int i;
 
-	for (i = sizeof(rsp) - 2; i >= 0; --i)
+	for (i = WILC_SPI_DATA_RSP_BYTES - 2; i >= 0; --i)
 		if (FIELD_GET(RSP_START_FIELD, rsp[i]) == RSP_START_TAG)
 			break;
 
@@ -996,6 +990,20 @@ static int spi_data_rsp(struct wilc *wilc, u8 cmd)
 	return 0;
 }
 
+static int spi_data_rsp(struct wilc *wilc, u8 cmd)
+{
+	struct spi_device *spi = to_spi_device(wilc->dev);
+	u8 rsp[WILC_SPI_DATA_RSP_BYTES];
+	int result;
+
+	result = wilc_spi_rx(wilc, rsp, sizeof(rsp));
+	if (result) {
+		dev_err(&spi->dev, "Failed bus error...\n");
+		return result;
+	}
+	return spi_data_check_rsp(wilc, rsp);
+}
+
 static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
-- 
2.25.1

