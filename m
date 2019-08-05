Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183638163F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 12:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfHEKCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 06:02:08 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37429 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfHEKCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 06:02:08 -0400
Received: by mail-lf1-f66.google.com with SMTP id c9so57389589lfh.4;
        Mon, 05 Aug 2019 03:02:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=li7rAXwzGIseE3k6zJ4TEp7sKBdJ70w/9wU60C+koC0=;
        b=LfRfNqEeTfHw0NHOa3++OwT+jaktCDOWXpGsuKcL0eXwedve86mzTxi1+PqVOF24v5
         omN+7m0tSud+MaaWRS+6WXJ+okxNjwBz3/Wyx/zd+q33YU+vG9jxF9cWQkaMhWdgipsc
         /eUDj7KjGIqmBzbENrkwyiO2DE57wAC/VCeU9RVmxkCwKkqp5uidt1PdklXZPBbFH2RN
         2A7oAWHBVhIB+/GWU+QMYn9mSfACxVKCZXPd+WExq+TbTslY8I/ICifETuWrND34ovI6
         Yu0CQyogerfrfc6WF8Fxqqbc9AHbN4sUM/GI+sJwr+XqYVZ9uuWgcvFab38DI8PrXclC
         7E7g==
X-Gm-Message-State: APjAAAUpdLTmuhl6J7ADDLjHpPX5dKjcUAwNhJGpcZ0YKjo+/F9hmI3q
        lML+BUUwcRkNt76n1RGt4XP2Ian3TzI=
X-Google-Smtp-Source: APXvYqyZ2HhoG5S0/h1MUvxqxPEHIwE0R6bU/2rM+TH4csl1FppMShqCGDVL3IVgpPzpDs7MAvkO/g==
X-Received: by 2002:a19:6557:: with SMTP id c23mr28622087lfj.12.1564999325428;
        Mon, 05 Aug 2019 03:02:05 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id j30sm1254982lfk.48.2019.08.05.03.02.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 03:02:04 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92)
        (envelope-from <johan@xi.terra>)
        id 1huZoZ-0002il-Ca; Mon, 05 Aug 2019 12:02:03 +0200
From:   Johan Hovold <johan@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Vincent Cuissard <cuissard@marvell.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+cf35b76f35e068a1107f@syzkaller.appspotmail.com
Subject: [PATCH] NFC: nfcmrvl: fix gpio-handling regression
Date:   Mon,  5 Aug 2019 12:00:55 +0200
Message-Id: <20190805100055.10398-1-johan@kernel.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two reset-gpio sanity checks which were never converted to use
gpio_is_valid(), and make sure to use -EINVAL to indicate a missing
reset line also for the UART-driver module parameter and for the USB
driver.

This specifically prevents the UART and USB drivers from incidentally
trying to request and use gpio 0, and also avoids triggering a WARN() in
gpio_to_desc() during probe when no valid reset line has been specified.

Fixes: e33a3f84f88f ("NFC: nfcmrvl: allow gpio 0 for reset signalling")
Cc: stable <stable@vger.kernel.org>	# 4.13
Reported-by: syzbot+cf35b76f35e068a1107f@syzkaller.appspotmail.com
Tested-by: syzbot+cf35b76f35e068a1107f@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/nfc/nfcmrvl/main.c | 4 ++--
 drivers/nfc/nfcmrvl/uart.c | 4 ++--
 drivers/nfc/nfcmrvl/usb.c  | 1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index e65d027b91fa..529be35ac178 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -244,7 +244,7 @@ void nfcmrvl_chip_reset(struct nfcmrvl_private *priv)
 	/* Reset possible fault of previous session */
 	clear_bit(NFCMRVL_PHY_ERROR, &priv->flags);
 
-	if (priv->config.reset_n_io) {
+	if (gpio_is_valid(priv->config.reset_n_io)) {
 		nfc_info(priv->dev, "reset the chip\n");
 		gpio_set_value(priv->config.reset_n_io, 0);
 		usleep_range(5000, 10000);
@@ -255,7 +255,7 @@ void nfcmrvl_chip_reset(struct nfcmrvl_private *priv)
 
 void nfcmrvl_chip_halt(struct nfcmrvl_private *priv)
 {
-	if (priv->config.reset_n_io)
+	if (gpio_is_valid(priv->config.reset_n_io))
 		gpio_set_value(priv->config.reset_n_io, 0);
 }
 
diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
index 9a22056e8d9e..e5a622ce4b95 100644
--- a/drivers/nfc/nfcmrvl/uart.c
+++ b/drivers/nfc/nfcmrvl/uart.c
@@ -26,7 +26,7 @@
 static unsigned int hci_muxed;
 static unsigned int flow_control;
 static unsigned int break_control;
-static unsigned int reset_n_io;
+static int reset_n_io = -EINVAL;
 
 /*
 ** NFCMRVL NCI OPS
@@ -231,5 +231,5 @@ MODULE_PARM_DESC(break_control, "Tell if UART driver must drive break signal.");
 module_param(hci_muxed, uint, 0);
 MODULE_PARM_DESC(hci_muxed, "Tell if transport is muxed in HCI one.");
 
-module_param(reset_n_io, uint, 0);
+module_param(reset_n_io, int, 0);
 MODULE_PARM_DESC(reset_n_io, "GPIO that is wired to RESET_N signal.");
diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index 945cc903d8f1..888e298f610b 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -305,6 +305,7 @@ static int nfcmrvl_probe(struct usb_interface *intf,
 
 	/* No configuration for USB */
 	memset(&config, 0, sizeof(config));
+	config.reset_n_io = -EINVAL;
 
 	nfc_info(&udev->dev, "intf %p id %p\n", intf, id);
 
-- 
2.22.0

