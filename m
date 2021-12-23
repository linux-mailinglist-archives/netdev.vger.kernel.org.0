Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BBB47DD21
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346708AbhLWBQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:03 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27408 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346249AbhLWBOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=yps8dWzMUKU9RpPhjdHxIE2MYXvMyKmHNVpEu8C+Av8=;
        b=YDmkak+OJEFHYXe/bj0Hi6XL2ELKUc4fCQN0z5nFM2oYV6GPyJxBnSq9OPl6vD1wKRHA
        cOcYfPSCr3Eckn5sQ4WMg/PwZIf6yjIPG9KgH8qSbL3TfcKGTfo3mIrcm/KuaUg+Fww3ch
        M03YDD0sBTbfHuCZFpFHard5V3ByPZK66/6RACPSdLgc6lgNBuBOu38VdUbEfrIUR4jNXc
        WVC+ivPgLdV6s7LL1FPa1EHQ5Pu05r+Ry5C7lBNumIwlMeHLccJ7hl0A1x2uon7n6DF4ZP
        vlRBywOeK3Atj11UpaYoWdlKgueDtgXMsgbDFpwAzU9oVNjYWTRd9iiBK9jUQG2Q==
Received: by filterdrecv-656998cfdd-phncc with SMTP id filterdrecv-656998cfdd-phncc-1-61C3CD5F-4
        2021-12-23 01:14:07.130091855 +0000 UTC m=+7955208.316338637
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id cnVlM2Y7Qw-Hv8JFSNpx_A
        Thu, 23 Dec 2021 01:14:06.990 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 20C9E700BFC; Wed, 22 Dec 2021 18:14:06 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 50/50] wilc1000: add module parameter
 "disable_zero_copy_tx" to SPI driver
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-51-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvNU=2FAiSwPXGwNeF4R?=
 =?us-ascii?Q?8pktv6qIQV9=2FvaYSYgd73qzUc+WcF+3KTLAn0Dz?=
 =?us-ascii?Q?BHXeSqbDC7G4R7ZfYu1EAHyy3Sq2tG4ZV5WlYOQ?=
 =?us-ascii?Q?9WcEpI8mc=2FcJxod2R537Lha1AodTa5W6TVWmKjK?=
 =?us-ascii?Q?rtnn5DEaNrWz5M6RHqHuhGYx03zVkgXBQHsPUR?=
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

Add a module parameter to disable the zero-copy transmit path.  This
is useful for testing and performance measurement, for example.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 8d94f111ffc49..588cec326a74b 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -31,6 +31,11 @@ MODULE_PARM_DESC(enable_crc16,
 		 "\t\t\tData transfers can be large and the CPU-cycle cost\n"
 		 "\t\t\tof enabling this may be substantial.");
 
+static bool disable_zero_copy_tx;
+module_param(disable_zero_copy_tx, bool, 0644);
+MODULE_PARM_DESC(disable_zero_copy_tx,
+		 "Disable zero-copy when sending packets.");
+
 /*
  * For CMD_SINGLE_READ and CMD_INTERNAL_READ, WILC may insert one or
  * more zero bytes between the command response and the DATA Start tag
@@ -41,7 +46,7 @@ MODULE_PARM_DESC(enable_crc16,
  */
 #define WILC_SPI_RSP_HDR_EXTRA_DATA	8
 
-static const struct wilc_hif_func wilc_hif_spi;
+static struct wilc_hif_func wilc_hif_spi;
 
 static int wilc_spi_reset(struct wilc *wilc);
 static int wilc_spi_write_sk_buffs(struct wilc *wilc, u32 addr,
@@ -254,6 +259,9 @@ static int wilc_bus_probe(struct spi_device *spi)
 	if (!spi_priv)
 		return -ENOMEM;
 
+	if (!disable_zero_copy_tx)
+		wilc_hif_spi.hif_sk_buffs_tx = wilc_spi_write_sk_buffs;
+
 	ret = wilc_cfg80211_init(&wilc, &spi->dev, WILC_HIF_SPI, &wilc_hif_spi);
 	if (ret)
 		goto free;
@@ -1424,7 +1432,7 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 }
 
 /* Global spi HIF function table */
-static const struct wilc_hif_func wilc_hif_spi = {
+static struct wilc_hif_func wilc_hif_spi = {
 	.hif_init = wilc_spi_init,
 	.hif_deinit = wilc_spi_deinit,
 	.hif_read_reg = wilc_spi_read_reg,
@@ -1436,7 +1444,6 @@ static const struct wilc_hif_func wilc_hif_spi = {
 	.hif_read_size = wilc_spi_read_size,
 	.hif_block_tx_ext = wilc_spi_write,
 	.hif_block_rx_ext = wilc_spi_read,
-	.hif_sk_buffs_tx = wilc_spi_write_sk_buffs,
 	.hif_sync_ext = wilc_spi_sync_ext,
 	.hif_reset = wilc_spi_reset,
 };
-- 
2.25.1

