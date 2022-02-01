Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0584A59D5
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 11:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiBAKTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 05:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiBAKTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 05:19:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42915C061714;
        Tue,  1 Feb 2022 02:19:35 -0800 (PST)
Date:   Tue, 1 Feb 2022 11:19:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643710772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zVdXAdiNqZMNia/PwsDvpt2M8XBenqRQG89XO/wiab4=;
        b=KXw/EDrVIZ/6ANYE1s/ntwpB5rm6HXp5v29EJvDmBXlD3E5ckVQCfM9INzRPucFx+J0QrR
        /C6MHGFj9Do7dLjR2XrJweA6K2W82N5K/Y7y56ENVZVVz+xnhVYmhHZ53gmo/IM/zcPcvq
        4OXstFQir5GZip47n3IUb1bqooBwxqc/daBEjLcPc3jMhlpXDR/ji8HTPI/7XpHhOqPDXv
        6GJWngijUjNffZyBKv1Uyl9sIh8BugZvfKyCj+nCYpEsoTWEAbIuz5Q+DT0i6MUceHKBeu
        rBOItXhzwZeSFO7nVTkVO03lWctqUhnc9WJORnRcMtrqITmiyPcidcQSnsEz/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643710772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zVdXAdiNqZMNia/PwsDvpt2M8XBenqRQG89XO/wiab4=;
        b=a4oNUHgytQlrI+TzuXy04pTpxNHDI9KwLTajCUbChXnHl8pdfUAmf7J1XQs8E/HCP9gXo4
        2ECBoqyJhI1D+iDg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH v2.1 4/7] misc: hi6421-spmi-pmic: Use
 generic_handle_irq_safe().
Message-ID: <YfkJMtW3Cc1ixGtS@linutronix.de>
References: <20220131123404.175438-1-bigeasy@linutronix.de>
 <20220131123404.175438-5-bigeasy@linutronix.de>
 <YfgGG0v/zhQp41tr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfgGG0v/zhQp41tr@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

generic_handle_irq() is invoked from a regular interrupt service
routine. This handler will become a forced-threaded handler on
PREEMPT_RT and will be invoked with enabled interrupts. The
generic_handle_irq() must be invoked with disabled interrupts in order
to avoid deadlocks.

Instead of manually disabling interrupts before invoking use
generic_handle_irq_safe() which can be invoked with enabled and disabled
interrupts.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/misc/hi6421v600-irq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/hi6421v600-irq.c b/drivers/misc/hi6421v600-irq.c
index 1c763796cf1fa..caa3de37698b0 100644
--- a/drivers/misc/hi6421v600-irq.c
+++ b/drivers/misc/hi6421v600-irq.c
@@ -117,8 +117,8 @@ static irqreturn_t hi6421v600_irq_handler(int irq, void *__priv)
 			 * If both powerkey down and up IRQs are received,
 			 * handle them at the right order
 			 */
-			generic_handle_irq(priv->irqs[POWERKEY_DOWN]);
-			generic_handle_irq(priv->irqs[POWERKEY_UP]);
+			generic_handle_irq_safe(priv->irqs[POWERKEY_DOWN]);
+			generic_handle_irq_safe(priv->irqs[POWERKEY_UP]);
 			pending &= ~HISI_IRQ_POWERKEY_UP_DOWN;
 		}
 
@@ -126,7 +126,7 @@ static irqreturn_t hi6421v600_irq_handler(int irq, void *__priv)
 			continue;
 
 		for_each_set_bit(offset, &pending, BITS_PER_BYTE) {
-			generic_handle_irq(priv->irqs[offset + i * BITS_PER_BYTE]);
+			generic_handle_irq_safe(priv->irqs[offset + i * BITS_PER_BYTE]);
 		}
 	}
 
-- 
2.34.1

