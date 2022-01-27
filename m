Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C0849E10A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240486AbiA0LdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:33:18 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35704 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240451AbiA0LdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:33:17 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643283196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MR4X9UKHf1r8ieV+0lFTTx2PgZLCHrXa68VMogEztJs=;
        b=SZN2cn8pYKspbLVLrE1AWhP0QZlFzMa1kSc2wRo5nufNpB7oLTIoWmyd7jC4YxCAncF0d7
        L35AEyiY093moR/PaUexrYD5l/DpcAfXS0qG3THsCciiTd9Kbo07Av+aKstCIHk8a8hgCt
        31ziLpMIrVzNNVUu8hXsKcGoCrY4yVAe4dR6sfFLbKVZyxc+NwdFdUlONQnCdFyLSEwLt3
        lBCGEzj0OdoDKkDRkcw6GBqSIMPNhdaoHnv1fkfcdHVCeDg8JTbveS/hNMv9ZqCb4IO8Tt
        rKT7IpSLsgWalteG1Ps1NbZw80/PUizRPeS/UaU0cO0d5FfGuBsgrdnaCUM1Fw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643283196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MR4X9UKHf1r8ieV+0lFTTx2PgZLCHrXa68VMogEztJs=;
        b=YhfnlrwVkGRk+5D+PDPwd73x0HRXprjUYnAYwqpeK00NGcoL8xakrV759EewxjNGr4gioo
        gbM+XI9TbsrBn1Aw==
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
Subject: [PATCH 3/7] i2c: cht-wc: Use generic_handle_irq_safe().
Date:   Thu, 27 Jan 2022 12:32:59 +0100
Message-Id: <20220127113303.3012207-4-bigeasy@linutronix.de>
In-Reply-To: <20220127113303.3012207-1-bigeasy@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of manually disabling interrupts before invoking use
generic_handle_irq() which can be invoked with enabled and disabled
interrupts.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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

