Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A7B4B2C89
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352530AbiBKSPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:15:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352488AbiBKSPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:15:18 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AF3CEC;
        Fri, 11 Feb 2022 10:15:17 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644603315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/cEQ+7C4ff0CH04JiPwSBP6tluhPY4Bc2prPBUnnOrc=;
        b=weBCzzVhJQjCmYj0xLAI3somZLYH4QpKQlgEOxVQBc+SD8Wgzy7l7Kbsyv//QeoM89S/Dt
        E5ckfmqE0z+sKdYjI0lWRLtd4mIlp/3oHwWJROPZT8F9kzoj4QflW6cilM4Lz8A2LbtGb5
        YG/T7BoTnHibARGZwuu6t7u5pPesQIhnleGDl33VGz3TpXJpznzGALWkgWprZ6CVEBXSFV
        cMyKC5tZxzVT1uYV3p4vXWuiw9Ky0AKDm5UEnUZgEGW3a5QwzBYAvi+eXEF1PFBu9N0T03
        SBXQBduDCPl29NlMr3f1ZYmFZUsnRNeBjEUf3zM8Oca9moOptl5OLd3tpvsMvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644603315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/cEQ+7C4ff0CH04JiPwSBP6tluhPY4Bc2prPBUnnOrc=;
        b=HcAxfRxChi+//Wx9GScSFQ55hBZQKs0AiX+S0bDe4Y0S8I8f9fSV5HiaTTjcHIO8Vc5PlK
        Tk51jIO2m301h8DQ==
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
Subject: [PATCH v4 3/7] i2c: cht-wc: Use generic_handle_irq_safe().
Date:   Fri, 11 Feb 2022 19:14:56 +0100
Message-Id: <20220211181500.1856198-4-bigeasy@linutronix.de>
In-Reply-To: <20220211181500.1856198-1-bigeasy@linutronix.de>
References: <20220211181500.1856198-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

