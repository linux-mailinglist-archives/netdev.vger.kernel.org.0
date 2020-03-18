Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7F818A42E
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgCRUrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:47:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58399 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCRUrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:47:18 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jEfaJ-000666-4B; Wed, 18 Mar 2020 21:46:39 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id E74691040C9;
        Wed, 18 Mar 2020 21:46:35 +0100 (CET)
Message-Id: <20200318204407.793899611@linutronix.de>
User-Agent: quilt/0.65
Date:   Wed, 18 Mar 2020 21:43:06 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: [patch V2 04/15] orinoco_usb: Use the regular completion interfaces
References: <20200318204302.693307984@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The completion usage in this driver is interesting:

  - it uses a magic complete function which according to the comment was
    implemented by invoking complete() four times in a row because
    complete_all() was not exported at that time.

  - it uses an open coded wait/poll which checks completion:done. Only one wait
    side (device removal) uses the regular wait_for_completion() interface.

The rationale behind this is to prevent that wait_for_completion() consumes
completion::done which would prevent that all waiters are woken. This is not
necessary with complete_all() as that sets completion::done to UINT_MAX which
is left unmodified by the woken waiters.

Replace the magic complete function with complete_all() and convert the
open coded wait/poll to regular completion interfaces.

This changes the wait to exclusive wait mode. But that does not make any
difference because the wakers use complete_all() which ignores the
exclusive mode.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
V2: New patch to avoid conversion to swait functions later.
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c |   21 ++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -365,17 +365,6 @@ static struct request_context *ezusb_all
 	return ctx;
 }
 
-
-/* Hopefully the real complete_all will soon be exported, in the mean
- * while this should work. */
-static inline void ezusb_complete_all(struct completion *comp)
-{
-	complete(comp);
-	complete(comp);
-	complete(comp);
-	complete(comp);
-}
-
 static void ezusb_ctx_complete(struct request_context *ctx)
 {
 	struct ezusb_priv *upriv = ctx->upriv;
@@ -409,7 +398,7 @@ static void ezusb_ctx_complete(struct re
 
 			netif_wake_queue(dev);
 		}
-		ezusb_complete_all(&ctx->done);
+		complete_all(&ctx->done);
 		ezusb_request_context_put(ctx);
 		break;
 
@@ -419,7 +408,7 @@ static void ezusb_ctx_complete(struct re
 			/* This is normal, as all request contexts get flushed
 			 * when the device is disconnected */
 			err("Called, CTX not terminating, but device gone");
-			ezusb_complete_all(&ctx->done);
+			complete_all(&ctx->done);
 			ezusb_request_context_put(ctx);
 			break;
 		}
@@ -690,11 +679,11 @@ static void ezusb_req_ctx_wait(struct ez
 			 * get the chance to run themselves. So we make sure
 			 * that we don't sleep for ever */
 			int msecs = DEF_TIMEOUT * (1000 / HZ);
-			while (!ctx->done.done && msecs--)
+
+			while (!try_wait_for_completion(&ctx->done) && msecs--)
 				udelay(1000);
 		} else {
-			wait_event_interruptible(ctx->done.wait,
-						 ctx->done.done);
+			wait_for_completion(&ctx->done);
 		}
 		break;
 	default:

