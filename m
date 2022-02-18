Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94F94BBE75
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 18:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbiBRRdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 12:33:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbiBRRdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 12:33:06 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAFC2B4D9A;
        Fri, 18 Feb 2022 09:32:49 -0800 (PST)
Date:   Fri, 18 Feb 2022 18:32:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645205567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=g2CWKBvUgnW8+rhv+YuxoDA1gTBduF4DcHc2yTMdEzA=;
        b=0Q0L8bxs+BmGckvx/nkNo81zL4oRAgOtitETMEuGBvmyUbb/N9wBwRdnZS/sIsH8Rm5ddM
        fZ6xQ2gbq6pPc202A9jbw6/tIZ1ZZsnyoIGJeUudZ3X8YZLN4R0IrmG4oYaStVgkwNoVXA
        TV29qJdP6Jcp4NOe3d91G7sQCdqUZ/AbbOPLR+IglVXAFf5igATeCG58d7Wes+Hb1Hx73P
        UT78YS9aPGwD2bVGlbkMaLKaW/hkDugyeixWQiE8Oh6dJ1mZgjbkmD6NkNE2hJL+/KVA2r
        lGJOM1JE25ZgDoQtgmhFc9A5XDF7NDIqz7YgJhKe6sDm6BRDCbamOCnUlmrMQA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645205567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=g2CWKBvUgnW8+rhv+YuxoDA1gTBduF4DcHc2yTMdEzA=;
        b=zOTVEQFe+owllU86mgiL+jBSRUVoYjZY/iNPrDE0Y1+oHyWl4kCbVc3/kb0vhd+fHCj42Q
        Mry87Li7RjxKFLDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] usb: dwc3: gadget: Let the interrupt handler disable bottom
 halves.
Message-ID: <Yg/YPejVQH3KkRVd@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The interrupt service routine registered for the gadget is a primary
handler which mask the interrupt source and a threaded handler which
handles the source of the interrupt. Since the threaded handler is
voluntary threaded, the IRQ-core does not disable bottom halves before
invoke the handler like it does for the forced-threaded handler.

Due to changes in networking it became visible that a network gadget's
completions handler may schedule a softirq which remains unprocessed.
The gadget's completion handler is usually invoked either in hard-IRQ or
soft-IRQ context. In this context it is enough to just raise the softirq
because the softirq itself will be handled once that context is left.
In the case of the voluntary threaded handler, there is nothing that
will process pending softirqs. Which means it remain queued until
another random interrupt (on this CPU) fires and handles it on its exit
path or another thread locks and unlocks a lock with the bh suffix.
Worst case is that the CPU goes idle and the NOHZ complains about
unhandled softirqs.

Disable bottom halves before acquiring the lock (and disabling
interrupts) and enable them after dropping the lock. This ensures that
any pending softirqs will handled right away.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lkml.kernel.org/r/c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com
Fixes: e5f68b4a3e7b0 ("Revert "usb: dwc3: gadget: remove unnecessary _irqsave()"")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/dwc3/gadget.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 183b90923f51b..a0c883f19a417 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4160,9 +4160,11 @@ static irqreturn_t dwc3_thread_interrupt(int irq, void *_evt)
 	unsigned long flags;
 	irqreturn_t ret = IRQ_NONE;
 
+	local_bh_disable();
 	spin_lock_irqsave(&dwc->lock, flags);
 	ret = dwc3_process_event_buf(evt);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	local_bh_enable();
 
 	return ret;
 }
-- 
2.34.1

