Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD8E4A474E
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378237AbiAaMes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377723AbiAaMej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:34:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0537C061714;
        Mon, 31 Jan 2022 04:34:38 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643632476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/cEQ+7C4ff0CH04JiPwSBP6tluhPY4Bc2prPBUnnOrc=;
        b=cpV3waOZkpC/BeIBHIZjp7NWYUbfHtuFlULP2WIZiB4hHZ6aqEcKGZ5GgoagpSJ9aIhCg1
        mMGoP+MzZ8MJVAVEzqrQ1JfNMFuOrCjbaHBAnZVfY+DsDUZaUb9dwXfvqHg4jwydC+RfCG
        Xer3/M0OPKNM3sDVymxeHMFJn83zb/JQLnTXvOsCMEMMpDXUZgNCfmiOE3y1uVlIL6r9l/
        UbVLssQQyZ+ubitz1h15ukhmTCtLm2KmU9fBq1+tjggwraS9dvT8yEgO7DBEzWQhW0L5Xi
        S9wMESKt/QyEiCTgnVt3jZqQJgnNkCmoRewDZaBDdXaOuMJxpAEdDbVo5LYkDQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643632476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/cEQ+7C4ff0CH04JiPwSBP6tluhPY4Bc2prPBUnnOrc=;
        b=ElZnF6uYUf0P1O7Ajng3KcHoOXyiIm1m/k9ByRpFArmJev9h9MWPZbTuM+gXeF8kfVtXaC
        5GAKDZOoXOrKzKDw==
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
Subject: [PATCH v2 3/7] i2c: cht-wc: Use generic_handle_irq_safe().
Date:   Mon, 31 Jan 2022 13:34:00 +0100
Message-Id: <20220131123404.175438-4-bigeasy@linutronix.de>
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
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Wolfram Sang <wsa@kernel.org>
---
 drivers/i2c/busses/i2c-cht-wc.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cht-wc.c b/drivers/i2c/busses/i2c-cht-w=
c.c
index 1cf68f85b2e11..8ccf0c928bb44 100644
--- a/drivers/i2c/busses/i2c-cht-wc.c
+++ b/drivers/i2c/busses/i2c-cht-wc.c
@@ -99,15 +99,8 @@ static irqreturn_t cht_wc_i2c_adap_thread_handler(int id=
, void *data)
 	 * interrupt handler as well, so running the client irq handler from
 	 * this thread will cause things to lock up.
 	 */
-	if (reg & CHT_WC_EXTCHGRIRQ_CLIENT_IRQ) {
-		/*
-		 * generic_handle_irq expects local IRQs to be disabled
-		 * as normally it is called from interrupt context.
-		 */
-		local_irq_disable();
-		generic_handle_irq(adap->client_irq);
-		local_irq_enable();
-	}
+	if (reg & CHT_WC_EXTCHGRIRQ_CLIENT_IRQ)
+		generic_handle_irq_safe(adap->client_irq);
=20
 	return IRQ_HANDLED;
 }
--=20
2.34.1

