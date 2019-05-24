Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC5E29560
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390457AbfEXKGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:06:10 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:50655 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390437AbfEXKGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:06:08 -0400
X-Originating-IP: 90.88.147.134
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 3639F40003;
        Fri, 24 May 2019 10:06:04 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alan Winkowski <walan@marvell.com>
Subject: [PATCH net-next 2/5] net: mvpp2: cls: Bypass C2 internals FIFOs at init
Date:   Fri, 24 May 2019 12:05:51 +0200
Message-Id: <20190524100554.8606-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The C2 TCAM has internal FIFOs that are only useful for the built-in
self-tests. Disable these FIFOS at init, as recommended in the
functionnal specs.

Suggested-by: Alan Winkowski <walan@marvell.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h     | 2 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index d5df813e08c4..bb466af9434b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -148,6 +148,8 @@
 #define MVPP22_CLS_C2_ATTR2			0x1b6c
 #define     MVPP22_CLS_C2_ATTR2_RSS_EN		BIT(30)
 #define MVPP22_CLS_C2_ATTR3			0x1b70
+#define MVPP22_CLS_C2_TCAM_CTRL			0x1b90
+#define     MVPP22_CLS_C2_TCAM_BYPASS_FIFO	BIT(0)
 
 /* Descriptor Manager Top Registers */
 #define MVPP2_RXQ_NUM_REG			0x2040
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 9ce73297276e..d549e9a29d9a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -923,6 +923,12 @@ void mvpp2_cls_init(struct mvpp2 *priv)
 		mvpp2_cls_c2_write(priv, &c2);
 	}
 
+	/* Disable the FIFO stages in C2 engine, which are only used in BIST
+	 * mode
+	 */
+	mvpp2_write(priv, MVPP22_CLS_C2_TCAM_CTRL,
+		    MVPP22_CLS_C2_TCAM_BYPASS_FIFO);
+
 	mvpp2_cls_port_init_flows(priv);
 }
 
-- 
2.20.1

