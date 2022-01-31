Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953E14A4746
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378072AbiAaMeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377728AbiAaMej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:34:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24481C06173D;
        Mon, 31 Jan 2022 04:34:39 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643632477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Rf56x1+Ad9rEt91/emuxS1F2pB4aiqCl6htULN1OW8=;
        b=NItl7Sm8Sv5ZaZ5pyGetxkOE/XosAyw1Dhafd35BWYF3AZ2wlMF0JlE014D8ZkIWfl13cz
        rcS815gCwV/KsKUNNBwuB0iGRs2ZpGX0NJyyYTxZLtGSrqQYVOio1CabZXCdYcRkMp3PWo
        iZFVXBfcJbKCc9drgMh1h8oUD7jS/7Ys12c7yOm0WNjcegWdJtPUy2CklxnxxJgZBnPFgp
        ZKE6I7MFgk2a8cbEuOHg+JZHgyNMqxfaOkiF0BVcHv9aE8aHwy7H7YCJC0Yq+sViS6aABI
        9QESDEJ5YTamladmXXncEIluMmNgNr5ZdTyfIOYxSeLV6CR/8K2XLP1WWd4+uQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643632477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Rf56x1+Ad9rEt91/emuxS1F2pB4aiqCl6htULN1OW8=;
        b=sM8TDHdyAIVrrUiRyNvRG/FFsmdPiet8KBnHDjkQYPlM/VPUyDAcs0VgIPboQLk4/Zp2ED
        Sl8ssbU1jFbAFPBw==
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
Subject: [PATCH v2 5/7] mfd: ezx-pcap: Use generic_handle_irq_safe().
Date:   Mon, 31 Jan 2022 13:34:02 +0100
Message-Id: <20220131123404.175438-6-bigeasy@linutronix.de>
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

