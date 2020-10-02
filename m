Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB78D2810A1
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 12:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbgJBKfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 06:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBKfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 06:35:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E46C0613D0;
        Fri,  2 Oct 2020 03:35:20 -0700 (PDT)
Date:   Fri, 2 Oct 2020 12:35:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601634918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CeDJ1dXLme679M/bPGlRbCUFKCuFkyI8moFOBFkwQtM=;
        b=Oiv80LLEtF21HuKEaTpvbjRgw5+l7EOAcB/SOXXKTYcbou07z3rJbr4MB0bYSGcA2WJJNa
        1Nv0EKGxpPyQiztkzJb9aM2oTAOnevTd1Lz5Qk5YVsEO7Cf2Q2q+LeBBwSepc2f9hOAuH3
        qp7N66HZyRdoSb/HV+p63t8D7iEOOAa2aZuuzyLEsORPQkKCG3HYL87gJM8ToGDGBjRzFr
        kCrGGHcsr1L5C+cr7z6bw8OtnZofxSg5cHB6Z9qSs1ijtF+7FyN2SQboPT4yr33mbC2CyD
        dW0xpXTeouJtrVMFvtYmsIf9x6yykUyy9ichRfpWbc5VOan4pcPYXUu84qK0GA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601634918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CeDJ1dXLme679M/bPGlRbCUFKCuFkyI8moFOBFkwQtM=;
        b=3//r+E4PAS6xtqgqLaHydxvPAjbLIRQymyWCJwefulBoiGjQ02eQLJ3lMuh0vBAITCfvRA
        RBMIj5yxxTGKH4Bw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC] Status of orinoco_usb
Message-ID: <20201002103517.fhsi5gaepzbzo2s4@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was trying to get rid of the in in_softirq() in ezusb_req_ctx_wait()
within the orinoco usb driver,
drivers/net/wireless/intersil/orinoco/orinoco_usb.c. A small snippet:

| static void ezusb_req_ctx_wait(struct ezusb_priv *upriv,
|                                struct request_context *ctx)
=E2=80=A6
|                 if (in_softirq()) {
|                         /* If we get called from a timer, timeout timers =
don't
|                          * get the chance to run themselves. So we make s=
ure
|                          * that we don't sleep for ever */
|                         int msecs =3D DEF_TIMEOUT * (1000 / HZ);
|=20
|                         while (!try_wait_for_completion(&ctx->done) && ms=
ecs--)
|                                 udelay(1000);
|                 } else {
|                         wait_for_completion(&ctx->done);
=E2=80=A6
| }

This is broken. The EHCI and XHCI HCD will complete the URB in
BH/tasklet. Should we ever get here in_softirq() then we will spin
here/wait here until the timeout passes because the tasklet won't be
able to run. OHCI/UHCI HCDs still complete in hard-IRQ so it would work
here.

Is it possible to end up here in softirq context or is this a relic?
Well I have no hardware but I see this:

  orinoco_set_monitor_channel() [I assume that this is fully preemtible]
  -> orinoco_lock() [this should point to ezusb_lock_irqsave() which
                     does spin_lock_bh(lock), so from here on
		     in_softirq() returns true]
  -> hw->ops->cmd_wait() [-> ezusb_docmd_wait()]
  -> ezusb_alloc_ctx() [ sets ctx->in_rid to EZUSB_RID_ACK/0x0710 ]
  -> ezusb_access_ltv()
     -> if (ctx->in_rid)
       -> ezusb_req_ctx_wait(upriv, ctx);
	 -> ctx->state should be EZUSB_CTX_REQ_COMPLETE so we end up in
	    the while loop above. So we udelay() 3 * 1000 * 1ms =3D 3sec.
	 -> Then ezusb_access_ltv() should return with an error due to
	    timeout.

This isn't limited to exotic features like monitor mode. orinoco_open()
does orinoco_lock() followed by orinoco_hw_program_rids() which in the
end invokes ezusb_write_ltv(,, EZUSB_RID_ACK) which is non-zero and also
would block (ezusb_xmit() would use 0 as the last argument so it won't
block).

I don't see how this driver can work on EHCI/XHCI HCD as of today.
The driver is an orphan since commit
   3a59babbee409 ("orinoco: update status in MAINTAINERS")

which is ten years ago. If I replace in_softirq() with a `may_sleep'
argument then it is still broken.
Should it be removed?

Sebastian
