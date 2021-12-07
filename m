Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9054046B8E9
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhLGK2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbhLGK20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:28:26 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E79C061748
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:24:56 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muXeY-0003OA-EF
        for netdev@vger.kernel.org; Tue, 07 Dec 2021 11:24:54 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 43E936BE8F0
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 10:24:47 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7044E6BE8A9;
        Tue,  7 Dec 2021 10:24:43 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5d18fbf2;
        Tue, 7 Dec 2021 10:24:27 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        stable@vger.kernel.org, Matt Kline <matt@bitbashing.io>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 5/9] can: m_can: pci: fix iomap_read_fifo() and iomap_write_fifo()
Date:   Tue,  7 Dec 2021 11:24:16 +0100
Message-Id: <20211207102420.120131-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211207102420.120131-1-mkl@pengutronix.de>
References: <20211207102420.120131-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

The same fix that was previously done in m_can_platform in commit
99d173fbe894 ("can: m_can: fix iomap_read_fifo() and iomap_write_fifo()")
is required in m_can_pci as well to make iomap_read_fifo() and
iomap_write_fifo() work for val_count > 1.

Fixes: 812270e5445b ("can: m_can: Batch FIFO writes during CAN transmit")
Fixes: 1aa6772f64b4 ("can: m_can: Batch FIFO reads during CAN receive")
Link: https://lore.kernel.org/all/20211118144011.10921-1-matthias.schiffer@ew.tq-group.com
Cc: stable@vger.kernel.org
Cc: Matt Kline <matt@bitbashing.io>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_pci.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 89cc3d41e952..d72c294ac4d3 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -42,8 +42,13 @@ static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
 static int iomap_read_fifo(struct m_can_classdev *cdev, int offset, void *val, size_t val_count)
 {
 	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
+	void __iomem *src = priv->base + offset;
 
-	ioread32_rep(priv->base + offset, val, val_count);
+	while (val_count--) {
+		*(unsigned int *)val = ioread32(src);
+		val += 4;
+		src += 4;
+	}
 
 	return 0;
 }
@@ -61,8 +66,13 @@ static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
 			    const void *val, size_t val_count)
 {
 	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
+	void __iomem *dst = priv->base + offset;
 
-	iowrite32_rep(priv->base + offset, val, val_count);
+	while (val_count--) {
+		iowrite32(*(unsigned int *)val, dst);
+		val += 4;
+		dst += 4;
+	}
 
 	return 0;
 }
-- 
2.33.0


