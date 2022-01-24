Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEC4498777
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244836AbiAXSAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244817AbiAXSAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:00:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FA7C061755
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:00:01 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nC3dI-0005BB-69
        for netdev@vger.kernel.org; Mon, 24 Jan 2022 19:00:00 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C4426210B0
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 55E1421089;
        Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c18f8ac8;
        Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        stable@vger.kernel.org, Matt Kline <matt@bitbashing.io>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Michael Anochin <anochin@photo-meter.com>
Subject: [PATCH net 3/5] can: m_can: m_can_fifo_{read,write}: don't read or write from/to FIFO if length is 0
Date:   Mon, 24 Jan 2022 18:59:53 +0100
Message-Id: <20220124175955.3464134-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124175955.3464134-1-mkl@pengutronix.de>
References: <20220124175955.3464134-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to optimize FIFO access, especially on m_can cores attached
to slow busses like SPI, in patch

| e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")

bulk read/write support has been added to the m_can_fifo_{read,write}
functions.

That change leads to the tcan driver to call
regmap_bulk_{read,write}() with a length of 0 (for CAN frames with 0
data length). regmap treats this as an error:

| tcan4x5x spi1.0 tcan4x5x0: FIFO write returned -22

This patch fixes the problem by not calling the
cdev->ops->{read,write)_fifo() in case of a 0 length read/write.

Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
Link: https://lore.kernel.org/all/20220114155751.2651888-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Cc: Matt Kline <matt@bitbashing.io>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Reported-by: Michael Anochin <anochin@photo-meter.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 5b47cd867783..1a4b56f6fa8c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -336,6 +336,9 @@ m_can_fifo_read(struct m_can_classdev *cdev,
 	u32 addr_offset = cdev->mcfg[MRAM_RXF0].off + fgi * RXF0_ELEMENT_SIZE +
 		offset;
 
+	if (val_count == 0)
+		return 0;
+
 	return cdev->ops->read_fifo(cdev, addr_offset, val, val_count);
 }
 
@@ -346,6 +349,9 @@ m_can_fifo_write(struct m_can_classdev *cdev,
 	u32 addr_offset = cdev->mcfg[MRAM_TXB].off + fpi * TXB_ELEMENT_SIZE +
 		offset;
 
+	if (val_count == 0)
+		return 0;
+
 	return cdev->ops->write_fifo(cdev, addr_offset, val, val_count);
 }
 
-- 
2.34.1


