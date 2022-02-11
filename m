Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344CD4B2C7F
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352556AbiBKSP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:15:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352501AbiBKSPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:15:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8727CEC;
        Fri, 11 Feb 2022 10:15:17 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644603316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Rf56x1+Ad9rEt91/emuxS1F2pB4aiqCl6htULN1OW8=;
        b=LchHan5TX6agjdim4dt+UPKaRjNJpZCZdn17aiPGBGe97pGsT3FtcRNNhlF3GC/cXHKCpw
        Z9C3ha2WLtqm2BUN5hLJoh1FCyXnvy/pXO0PuHAN47g8EksqwkNJElM2DBNG3Wm1sBuatm
        GdNGfnaZ8BMNCaCWC659M+ZxWLQfZCxc9CuYx9cGxQGS0VfRaJqBtew87tHT65RXckjiPX
        BdN7dV4yVaWjwpPkMSkBZ0C2i2pgMRXdifeFbiX4Q6xDs7J1nQfNmrAs8zCFRFUg1Egztu
        5UHdFHcxuBZN9ngMFATPIZEvkaYT3obAGepyZRT46XRqJfHqFp51vvFuu15qtA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644603316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Rf56x1+Ad9rEt91/emuxS1F2pB4aiqCl6htULN1OW8=;
        b=3KjVfpW7VDjW0vSYVcWiBhYkT1kUMMT3/hcg6t0USTDFn6O02udQdcj7IiM1Q3ZhUFNgAc
        4sOF6cXimOuRYZAQ==
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
Subject: [PATCH v4 5/7] mfd: ezx-pcap: Use generic_handle_irq_safe().
Date:   Fri, 11 Feb 2022 19:14:58 +0100
Message-Id: <20220211181500.1856198-6-bigeasy@linutronix.de>
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
---
 drivers/mfd/ezx-pcap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 70fa18b04ad2b..b14d3f98e1ebd 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -193,13 +193,11 @@ static void pcap_isr_work(struct work_struct *work)
 		ezx_pcap_write(pcap, PCAP_REG_MSR, isr | msr);
 		ezx_pcap_write(pcap, PCAP_REG_ISR, isr);
=20
-		local_irq_disable();
 		service =3D isr & ~msr;
 		for (irq =3D pcap->irq_base; service; service >>=3D 1, irq++) {
 			if (service & 1)
-				generic_handle_irq(irq);
+				generic_handle_irq_safe(irq);
 		}
-		local_irq_enable();
 		ezx_pcap_write(pcap, PCAP_REG_MSR, pcap->msr);
 	} while (gpio_get_value(pdata->gpio));
 }
--=20
2.34.1

