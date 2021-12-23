Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA7047DD0A
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345922AbhLWBPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:39 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27544 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346279AbhLWBOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=K3gvUb3OfxsaOhe9tlq0tGnjjw1iUXxBhXljWscLEpA=;
        b=EyL6nlfgr9jVdtVhMT6au8qt34Za+LdjzKKipZCKpqlgz6G1wl5F3+25Hbw0xEDLe2wu
        FrihvBjOH6zXmTgA3DRnJftUG5FCjuj5rCxeHcC251pZQuyGFJCwfV5v7gDc1e/y/avUCB
        0UO1lhho1nSvG87xayM8xWqixfBePLN9481Ei9NJQ53z6p07N2K4bk1XHoWIKjhnDSnikd
        6bOlQ5ulnfrVrLW5DvvVKo4ESFryeS2RHRZcYuHoU/LyoDffXjFEEavVG+/Ri/6snSR7Ul
        NGt1Q+S0RbMcoGGgtYpyydfsRRVmyTHAieajpg3t3EgvBkqMFC0e4bMSQph529TA==
Received: by filterdrecv-75ff7b5ffb-ndqvq with SMTP id filterdrecv-75ff7b5ffb-ndqvq-1-61C3CD5F-F
        2021-12-23 01:14:07.170941284 +0000 UTC m=+9687225.771336929
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-0 (SG)
        with ESMTP
        id IA6WsOnwRGSzJ75Zl9-9BQ
        Thu, 23 Dec 2021 01:14:07.020 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id EE86B70152F; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 46/50] wilc1000: remove duplicate CRC calculation code
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-47-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvCNKwj+DYMFZnlIhP?=
 =?us-ascii?Q?R3K1iY1ejP=2F1ZZy1gRWB3YD8=2FXZCKVGtzkSucLw?=
 =?us-ascii?Q?WRtW7fomsuWltgqRjiEBKbxvD+9e=2Fp132d6pwH6?=
 =?us-ascii?Q?1Qao59pVs+WRvAZYsHo7cuhrDvbvOIpCz4NSaqQ?=
 =?us-ascii?Q?f3D=2FiC1tSuShhdzeShsLBv4nScpyWhQ5Nld97u?=
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

Factor two copies of the same calculation into a single instance.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 5f73b3d2d2112..189907580d921 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -658,7 +658,7 @@ static int wilc_spi_dma_rw(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz)
 	u8 wb[32], rb[32];
 	int cmd_len, resp_len;
 	int retry, ix = 0;
-	u8 crc[2];
+	u8 crc[2], *crc7;
 	struct wilc_spi_cmd *c;
 	struct wilc_spi_rsp_data *r;
 
@@ -673,8 +673,6 @@ static int wilc_spi_dma_rw(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz)
 		c->u.dma_cmd.size[0] = sz >> 8;
 		c->u.dma_cmd.size[1] = sz;
 		cmd_len = offsetof(struct wilc_spi_cmd, u.dma_cmd.crc);
-		if (spi_priv->crc7_enabled)
-			c->u.dma_cmd.crc[0] = wilc_get_crc7(wb, cmd_len);
 	} else if (cmd == CMD_DMA_EXT_WRITE || cmd == CMD_DMA_EXT_READ) {
 		c->u.dma_cmd_ext.addr[0] = adr >> 16;
 		c->u.dma_cmd_ext.addr[1] = adr >> 8;
@@ -683,15 +681,16 @@ static int wilc_spi_dma_rw(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz)
 		c->u.dma_cmd_ext.size[1] = sz >> 8;
 		c->u.dma_cmd_ext.size[2] = sz;
 		cmd_len = offsetof(struct wilc_spi_cmd, u.dma_cmd_ext.crc);
-		if (spi_priv->crc7_enabled)
-			c->u.dma_cmd_ext.crc[0] = wilc_get_crc7(wb, cmd_len);
 	} else {
 		dev_err(&spi->dev, "dma read write cmd [%x] not supported\n",
 			cmd);
 		return -EINVAL;
 	}
-	if (spi_priv->crc7_enabled)
+	if (spi_priv->crc7_enabled) {
+		crc7 = wb + cmd_len;
+		*crc7 = wilc_get_crc7(wb, cmd_len);
 		cmd_len += 1;
+	}
 
 	resp_len = sizeof(*r);
 
-- 
2.25.1

