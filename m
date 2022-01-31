Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407FC4A4742
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbiAaMel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377708AbiAaMei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:34:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0728C06173B;
        Mon, 31 Jan 2022 04:34:38 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643632476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Cnx2U3ehecH1EXxHKkd2xHBgTX+RcdbAsjgFaXCm/o=;
        b=fU93pza/ZNETYaCsug8jceTgh74lN4xCg7XEi6i9wyj4TmQkCQnwaKQyFD/Bje8g4LhfYq
        ivMLGxUfvDv8qwlaLLeLIckp6c2YdKOsfOTCa/Uo7nMnLgt8LcuMwCFIrgizaqdqjokJJC
        oApPa4uFKZx2ulwkblGpZerv7rOq3RNAe8MHFLT5G4BUIzIyta1SLVEU2mxs3odpF1XUlI
        HTdK/lXvMXfSjut0vo0beBmZe29Ii4tx4v9HE90JGDtofhLQI9amjERww7YAFUgYPhacrc
        aMevfhtwGd0ObY29eFr6iVCyeQgJm+imvwLXqNpTq+42ODVzNqbZYSLbqzfdvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643632476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Cnx2U3ehecH1EXxHKkd2xHBgTX+RcdbAsjgFaXCm/o=;
        b=E3vfHQTM7BzQ+R1R6RodJ9z8eBL9l02WqeF9xkbXHZrnawkMLcEQpWWcGMb3Vxa+JcMgcv
        2y9smJBQm+7Rq1CA==
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
        Salvatore Bonaccorso <carnil@debian.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH v2 2/7] i2c: core: Use generic_handle_irq_safe() in i2c_handle_smbus_host_notify().
Date:   Mon, 31 Jan 2022 13:33:59 +0100
Message-Id: <20220131123404.175438-3-bigeasy@linutronix.de>
In-Reply-To: <20220131123404.175438-1-bigeasy@linutronix.de>
References: <20220131123404.175438-1-bigeasy@linutronix.de>
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
Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Wolfram Sang <wsa@kernel.org>
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

