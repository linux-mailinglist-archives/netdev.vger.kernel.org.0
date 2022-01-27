Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E4349E10C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbiA0LdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:33:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35678 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240452AbiA0LdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:33:17 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643283195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wTKjbYOxuRFcL31Sy6LSHpAHIAEA5Do9fBb8rIU2B/A=;
        b=JKVRy6jNueSrYIN6Xe3JiWap0sunJm+2QdxKeILRU59BwtyBatJK0iWtQj5t285PKHOt3B
        LZSJvksiOCnCmb1pWYwjpZ3dS05Jo9hnhL0mD/hbbXU9b6PU9/6DScg3Zo5PM6d1rQNiJu
        FZ1npFIuC9ZY0NjZPIk1w82UUoVxX+NHar9HUAqz1J5b5QPCof71pawdcrrGcz9DsoU1W7
        +ZQi4p7ESLBqUHelgD7ClXhI45Rycs+0aSgLSysa5IvNkvyuj2ZPs7Gbbw7gfabX6tBEUE
        jeogssDZhf4C2eP0LgUBx8YMwwXRrY7Eqz6tQ99PfaJ4JyFfTWgFF/yeGh1kVw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643283195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wTKjbYOxuRFcL31Sy6LSHpAHIAEA5Do9fBb8rIU2B/A=;
        b=VgquP+WkCVhYqSRx0+UG+vW3EM3AWP3WCFrN8rLQ5teC06FJyBDBteYWgyOe75HAEiL3oq
        GxNJ2dKiRYy6CIAg==
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
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 2/7] i2c: core: Use generic_handle_irq_safe() in i2c_handle_smbus_host_notify().
Date:   Thu, 27 Jan 2022 12:32:58 +0100
Message-Id: <20220127113303.3012207-3-bigeasy@linutronix.de>
In-Reply-To: <20220127113303.3012207-1-bigeasy@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The i2c-i801 driver invokes i2c_handle_smbus_host_notify() from his
interrupt service routine. On PREEMPT_RT i2c-i801's handler is forced
threaded with enabled interrupts which leads to a warning by
handle_irq_event_percpu() assuming that irq_default_primary_handler()
enabled interrupts.

i2c-i801's interrupt handler can't be made non-threaded because the
interrupt line is shared with other devices.

Use generic_handle_irq_safe() which can invoked with disabled and enabled
interrupts.

Reported-by: Michael Below <below@judiz.de>
Link: https://bugs.debian.org/1002537
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/i2c/i2c-core-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 2c59dd748a49f..3f9e5303b6163 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1424,7 +1424,7 @@ int i2c_handle_smbus_host_notify(struct i2c_adapter *=
adap, unsigned short addr)
 	if (irq <=3D 0)
 		return -ENXIO;
=20
-	generic_handle_irq(irq);
+	generic_handle_irq_safe(irq);
=20
 	return 0;
 }
--=20
2.34.1

