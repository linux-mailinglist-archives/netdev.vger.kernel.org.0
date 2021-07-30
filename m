Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8D63DB43A
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 09:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbhG3HFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 03:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbhG3HFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 03:05:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98E2C061798
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 00:05:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m9MaP-00066W-2Q
        for netdev@vger.kernel.org; Fri, 30 Jul 2021 09:05:37 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B8FF565B7C5
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:05:32 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 18C3165B794;
        Fri, 30 Jul 2021 07:05:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f8636b5d;
        Fri, 30 Jul 2021 07:05:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Skripkin <paskripkin@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Yasushi SHOJI <yasushi.shoji@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 3/6] can: mcba_usb_start(): add missing urb->transfer_dma initialization
Date:   Fri, 30 Jul 2021 09:05:23 +0200
Message-Id: <20210730070526.1699867-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730070526.1699867-1-mkl@pengutronix.de>
References: <20210730070526.1699867-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

Yasushi reported, that his Microchip CAN Analyzer stopped working
since commit 91c02557174b ("can: mcba_usb: fix memory leak in
mcba_usb"). The problem was in missing urb->transfer_dma
initialization.

In my previous patch to this driver I refactored mcba_usb_start() code
to avoid leaking usb coherent buffers. To archive it, I passed local
stack variable to usb_alloc_coherent() and then saved it to private
array to correctly free all coherent buffers on ->close() call. But I
forgot to initialize urb->transfer_dma with variable passed to
usb_alloc_coherent().

All of this was causing device to not work, since dma addr 0 is not
valid and following log can be found on bug report page, which points
exactly to problem described above.

| DMAR: [DMA Write] Request device [00:14.0] PASID ffffffff fault addr 0 [fault reason 05] PTE Write access is not set

Fixes: 91c02557174b ("can: mcba_usb: fix memory leak in mcba_usb")
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=990850
Link: https://lore.kernel.org/r/20210725103630.23864-1-paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: Yasushi SHOJI <yasushi.shoji@gmail.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Tested-by: Yasushi SHOJI <yashi@spacecubics.com>
[mkl: fixed typos in commit message - thanks Yasushi SHOJI]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/mcba_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index a45865bd7254..a1a154c08b7f 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -653,6 +653,8 @@ static int mcba_usb_start(struct mcba_priv *priv)
 			break;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, priv->udev,
 				  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
 				  buf, MCBA_USB_RX_BUFF_SIZE,
-- 
2.30.2


