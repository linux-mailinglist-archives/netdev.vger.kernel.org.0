Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F9D4A4758
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378400AbiAaMez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:34:55 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59550 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377753AbiAaMek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:34:40 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643632478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=45fS8vZOqc3z6GIbrRMqB22H177VtG9qYEYyo0HBgug=;
        b=s7WadyoZF5Sm9aaIEUp7kcaweY2hKcBKO88OOavIAopkRL10Nt7FOV5J+c23vnEm9z/o/V
        NY0FQv7nQoJnqUHyedftx6xK+BjgEnZv1lUidebwgEF8yfbwzhuQH6aeLDsMIByAjuBCa6
        Qsl2cNjhZ5tHzwi8dTpL7rPOdrFw/Iicfku5w+YCglwtxBQqCubQ7OMR8Q4Cu016Bw8px0
        AIeREKk2CwpO5uWITVZac8FKU+W/4X47EEyEx+SJ+92R5Ra67j+E5M8z95Rv7BAepyNiEn
        Y2kKvSlmlpCeWxZux585HWzFHAhckLmJlZd4ktSvL/PAf/G8zIU7tlo31EwSPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643632478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=45fS8vZOqc3z6GIbrRMqB22H177VtG9qYEYyo0HBgug=;
        b=N7JagwoELEftXltgPzO9ztt5Cb2k5Lk3suG9RV9lzuvY1GsaRGr3uEvMh+UpZduAJed78V
        4uxodkd49PAOXABg==
To:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 7/7] staging: greybus: gpio: Use generic_handle_irq_safe().
Date:   Mon, 31 Jan 2022 13:34:04 +0100
Message-Id: <20220131123404.175438-8-bigeasy@linutronix.de>
In-Reply-To: <20220131123404.175438-1-bigeasy@linutronix.de>
References: <20220131123404.175438-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of manually disabling interrupts before invoking use
generic_handle_irq_safe() which can be invoked with enabled and disabled
interrupts.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/staging/greybus/gpio.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/greybus/gpio.c b/drivers/staging/greybus/gpio.c
index 7e6347fe93f99..8a7cf1d0e9688 100644
--- a/drivers/staging/greybus/gpio.c
+++ b/drivers/staging/greybus/gpio.c
@@ -391,10 +391,7 @@ static int gb_gpio_request_handler(struct gb_operation=
 *op)
 		return -EINVAL;
 	}
=20
-	local_irq_disable();
-	ret =3D generic_handle_irq(irq);
-	local_irq_enable();
-
+	ret =3D generic_handle_irq_safe(irq);
 	if (ret)
 		dev_err(dev, "failed to invoke irq handler\n");
=20
--=20
2.34.1

