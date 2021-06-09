Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDCD3A1F90
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhFIWAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhFIWAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:00:45 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08BBC061574;
        Wed,  9 Jun 2021 14:58:37 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id c11so1802475ljd.6;
        Wed, 09 Jun 2021 14:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=szIH5XmBD8gBJtERHlpOkSnME50sJ1/XS/4Dv/VOoFQ=;
        b=lDY6B4Msxh/CS2Z2CiZCDh/XeW2xwQAO7cDPG9t33BfHmYHTzXJZsagZgXBe5646Ma
         sVsWURHsL2PoBdYqaDbLznGgVVEzQuJotk9/GFjKPW/W2SqJ/UuERzdSLEtJd2a1XX6Q
         zrPjDa0pbZC8kvNf5p7Xajjaj3wcGnxK0ItYUIB0I0QLGJ3RgAgIVlz8s96MQaTAUKmL
         uXz8i/kn85KER//jkjtVteWNuuj7sowX0efVSa58S9NkHJupoXYEoZ9xFXt8y6VXgb7K
         GDEezj0wjwTMQHDqjX0uj+xeAuJWx7vEc5825XedITxDQKKzGKt9/9tkP1JXFS3WqIaD
         KoHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=szIH5XmBD8gBJtERHlpOkSnME50sJ1/XS/4Dv/VOoFQ=;
        b=CsX4WtSVEREw0n2tzxZWBGtzfPAsgeX+0x5Yqctc6usT43f1JS7yVX5w88GjqtHuy4
         ZpJm2ybKkJbBYyyxXBQA/d1T4QHWmdXwR6RPGv24GQuiLanSeUSyFB/Hh+IIrZuegfCz
         piwzQuJM9Ck3SoX99rmlGXhUZoc44Gix/LUGSDaHKWQwyGeHemnydns/qsb3uURM0gvO
         PKDbuOlGHuwGrlsVg84zsBkVWssVcmcqW+u+cPhp8bu8KzfzkJd4BprT96DtqrMbPioF
         jmoTxQdh4F6CSKtxPOK536S42kAfbmNaY+J/cKFVUhxkjiYH/E4pqy/3+DWsptfxKkE8
         zcEg==
X-Gm-Message-State: AOAM533t/aCwRt0SV6dsaDkWpQU/tWSZDYj2ZiJZkTgdUUJsSZt/PG2M
        ddQrkmpNSivsEOpM8vMkn8o8HSN3QC8=
X-Google-Smtp-Source: ABdhPJyuck5vx8roOEOOGjGiMZn6D89QrZAx15YFV9AY56fGOrnVMpyMwdlgbHhm1r1mGKvlaDuJYA==
X-Received: by 2002:a2e:3c0c:: with SMTP id j12mr1391782lja.131.1623275916242;
        Wed, 09 Jun 2021 14:58:36 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id v26sm117156lfp.0.2021.06.09.14.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 14:58:35 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+57281c762a3922e14dfe@syzkaller.appspotmail.com
Subject: [PATCH] can: mcba_usb: fix memory leak in mcba_usb
Date:   Thu, 10 Jun 2021 00:58:33 +0300
Message-Id: <20210609215833.30393-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in SocketCAN driver
for Microchip CAN BUS Analyzer Tool. The problem
was in unfreed usb_coherent.

In mcba_usb_start() 20 coherent buffers are allocated
and there is nothing, that frees them:

	1) In callback function the urb is resubmitted and that's all
	2) In disconnect function urbs are simply killed, but
	   URB_FREE_BUFFER is not set (see mcba_usb_start)
           and this flag cannot be used with coherent buffers.

Fail log:
[ 1354.053291][ T8413] mcba_usb 1-1:0.0 can0: device disconnected
[ 1367.059384][ T8420] kmemleak: 20 new suspected memory leaks (see /sys/kernel/debug/kmem)

So, all allocated buffers should be freed with usb_free_coherent()
explicitly

NOTE:
The same pattern for allocating and freeing coherent buffers
is used in drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Reported-and-tested-by: syzbot+57281c762a3922e14dfe@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/can/usb/mcba_usb.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 029e77dfa773..a45865bd7254 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -82,6 +82,8 @@ struct mcba_priv {
 	bool can_ka_first_pass;
 	bool can_speed_check;
 	atomic_t free_ctx_cnt;
+	void *rxbuf[MCBA_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MCBA_MAX_RX_URBS];
 };
 
 /* CAN frame */
@@ -633,6 +635,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 	for (i = 0; i < MCBA_MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -642,7 +645,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 		}
 
 		buf = usb_alloc_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
-					 GFP_KERNEL, &urb->transfer_dma);
+					 GFP_KERNEL, &buf_dma);
 		if (!buf) {
 			netdev_err(netdev, "No memory left for USB buffer\n");
 			usb_free_urb(urb);
@@ -661,11 +664,14 @@ static int mcba_usb_start(struct mcba_priv *priv)
 		if (err) {
 			usb_unanchor_urb(urb);
 			usb_free_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
-					  buf, urb->transfer_dma);
+					  buf, buf_dma);
 			usb_free_urb(urb);
 			break;
 		}
 
+		priv->rxbuf[i] = buf;
+		priv->rxbuf_dma[i] = buf_dma;
+
 		/* Drop reference, USB core will take care of freeing it */
 		usb_free_urb(urb);
 	}
@@ -708,7 +714,14 @@ static int mcba_usb_open(struct net_device *netdev)
 
 static void mcba_urb_unlink(struct mcba_priv *priv)
 {
+	int i;
+
 	usb_kill_anchored_urbs(&priv->rx_submitted);
+
+	for (i = 0; i < MCBA_MAX_RX_URBS; ++i)
+		usb_free_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
+				  priv->rxbuf[i], priv->rxbuf_dma[i]);
+
 	usb_kill_anchored_urbs(&priv->tx_submitted);
 }
 
-- 
2.31.1

