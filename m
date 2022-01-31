Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B07F4A474C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378168AbiAaMeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377777AbiAaMej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:34:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBBDC06173E;
        Mon, 31 Jan 2022 04:34:39 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643632478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=An8sejACWdvpFe+0xRHo7AseACg3JQzOaIfRXUshpP4=;
        b=BhXM3NIKleAXz7EGWrjwvCWxgHP1I7/JRcmil3tRIKBabUstjQSOcdpTUg/m1lF7oIrZ1h
        GJQLNmXozK1A5vIYoXb9v6UwJ+KBsJYrcfFqHHqs3Jlf4o0dVx3Tlx0AnT0+RwiHef/FLW
        oMURGOimO/W1lbtVUCoPppCqASjKnZW4wEWGjga/vAVPYkdg3nR3ugHAEHk5RML5kIVyMY
        Gty+/hsNQDZxptez8/F9kHJ9CIEhSlGtoStcscQndHdMqYawAVkTTVPavXkShJCe60pzjk
        57Ytrkn7GG824ZYP/vJ05PKC8JowBftEL1ohiaYtp/Yas8PUNYKV2mO/FZPpvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643632478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=An8sejACWdvpFe+0xRHo7AseACg3JQzOaIfRXUshpP4=;
        b=VXjZDiLALUI90SjNiUr6gENIIBLtiru6j97WSlG+HLfibjq+XKc+wXT5Hl2CyD+y6EqoQW
        lUdbLPTu09+heCCA==
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
Subject: [PATCH v2 6/7] net: usb: lan78xx: Use generic_handle_irq_safe().
Date:   Mon, 31 Jan 2022 13:34:03 +0100
Message-Id: <20220131123404.175438-7-bigeasy@linutronix.de>
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
 drivers/net/usb/lan78xx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index b8e20a3f2b84e..415f16662f88e 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1537,11 +1537,8 @@ static void lan78xx_status(struct lan78xx_net *dev, =
struct urb *urb)
 		netif_dbg(dev, link, dev->net, "PHY INTR: 0x%08x\n", intdata);
 		lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
=20
-		if (dev->domain_data.phyirq > 0) {
-			local_irq_disable();
-			generic_handle_irq(dev->domain_data.phyirq);
-			local_irq_enable();
-		}
+		if (dev->domain_data.phyirq > 0)
+			generic_handle_irq_safe(dev->domain_data.phyirq);
 	} else {
 		netdev_warn(dev->net,
 			    "unexpected interrupt: 0x%08x\n", intdata);
--=20
2.34.1

