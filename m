Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5854149E121
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240592AbiA0LdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240493AbiA0LdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:33:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6110C061747;
        Thu, 27 Jan 2022 03:33:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643283197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kVlPTMDntv41BuaIBVh4q/kKYYaaoCfGMJweU6kQ6GM=;
        b=1lx9niiI8RRioyHNdrmVhjrW1KCB/zoquFCf9TJgs2Uq21WSsw28rWdIvFUxceQvO6pJKF
        UiFUea6uHg2UdxjqRDa0qej1X8oQAfysrkyvWiYfq+TQgc2jWSXssQJm7sdYqPOj+n9oVD
        NajTw7lyWg33dfO29HLLLi3oSNpQMwI3rDam34WHPjIrnEuVJ/12Qys7Z0dn7PCA5iXbjx
        7KmYPa05CPQLX6xcxxXjcWGUk+twV/+l24UZN68nisyKE/CFXdCyuxwFKgA8+pooy32TSs
        Zme9QX79lV694NSsLuR8bWGZhEXT/AUxl2H/QOvKEi7eXWOSw+7VroIIIZjndQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643283197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kVlPTMDntv41BuaIBVh4q/kKYYaaoCfGMJweU6kQ6GM=;
        b=Ez758sB8dJOJPOxiDBVk13iEEcMxNSfJ4V1ID+WIb76mNC9VLRRakMKQoXDdneK8cXd8R5
        UT5PsJEZNEqX3FBA==
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
Subject: [PATCH 6/7] net: usb: lan78xx: Use generic_handle_irq_safe().
Date:   Thu, 27 Jan 2022 12:33:02 +0100
Message-Id: <20220127113303.3012207-7-bigeasy@linutronix.de>
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

