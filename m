Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D701A4BB5B7
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 10:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiBRJfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 04:35:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbiBRJfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 04:35:06 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0029A5EDCF;
        Fri, 18 Feb 2022 01:34:49 -0800 (PST)
Date:   Fri, 18 Feb 2022 10:34:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645176887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gWoqdX5zqLOiYz+ioUEjfR9Jt4T4RTcUvaGkeWY1qs8=;
        b=xEXN1EQZu0kvnP7774SDbw51m03OImdPKGX8AUbKhlC8+rrz9LoLpBhtfuai9oG3yHnmDo
        Jefx41d7PD28uKjHI17E8kE0IZ6fBowNHFcodf2qziHwWAqqnMo98YtX5Kks7f2KpPYTnv
        O6JrARGcNaV7e/a1x16VGK8f+hcZ3DgQTZNouLACH4esvzNbWXHCoRoBBRedD5WI/VfCsS
        IzYPBDGRByP5Be3XDkSTk+6iE3UaNpZvn1dyQ7Hpf4QClDwQkf8JvZpJO3BT23gv0nM0IN
        ydBeOoThGXAsdvj5G9hUdQhLnnY6akphZroVo9KcFq1t1hzcRjo96GK0GlS8TQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645176887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gWoqdX5zqLOiYz+ioUEjfR9Jt4T4RTcUvaGkeWY1qs8=;
        b=T8omvmczgXOmiPz1UE4pGdYCnB8LWFuRiXS5lxVWWzizu0LUw1skF0A8+VO7lKewMAAHtY
        4vVmvIjU5wSustBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
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
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] net: Correct wrong BH disable in hard-interrupt.
Message-ID: <Yg9oNlF+YCot6WcO@linutronix.de>
References: <CGME20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08@eucas1p2.samsung.com>
 <Yg05duINKBqvnxUc@linutronix.de>
 <ce67e9c9-966e-3a08-e571-b7f1dacb3814@samsung.com>
 <c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-17 15:08:55 [+0100], Marek Szyprowski wrote:
> Hi All,
Hi,

> >> Marek, does this work for you?
> >
> > Yes, this fixed the issue. Thanks!
> >
> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>=20
> I've just noticed that there is one more issue left to fix (the $subject=
=20
> patch is already applied) - this one comes from threaded irq (if I got=20
> the stack trace right):

netif_rx() did only set the matching softirq bit and not more. Based on
that I don't see why NOHZ shouldn't complain about a pending softirq
once the CPU goes idle. Therefore I think the change I made is good
since it uncovered that.

> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 147 at kernel/softirq.c:363=20
> __local_bh_enable_ip+0xa8/0x1c0
=E2=80=A6
> CPU: 0 PID: 147 Comm: irq/150-dwc3 Not tainted 5.17.0-rc4-next-20220217+=
=20
> #4557
> Hardware name: Samsung TM2E board (DT)
> pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> pc : __local_bh_enable_ip+0xa8/0x1c0
> lr : netif_rx+0xa4/0x2c0
> ...
>=20
> Call trace:
>  =C2=A0__local_bh_enable_ip+0xa8/0x1c0
>  =C2=A0netif_rx+0xa4/0x2c0
>  =C2=A0rx_complete+0x214/0x250
>  =C2=A0usb_gadget_giveback_request+0x58/0x170
>  =C2=A0dwc3_gadget_giveback+0xe4/0x200
>  =C2=A0dwc3_gadget_endpoint_trbs_complete+0x100/0x388
>  =C2=A0dwc3_thread_interrupt+0x46c/0xe20

So dwc3_thread_interrupt() disables interrupts here. Felipe dropped it
and then added it back in
    e5f68b4a3e7b0 ("Revert "usb: dwc3: gadget: remove unnecessary _irqsave(=
)"")

I would suggest to revert it (the above commit) and fixing the lockdep
splat in the gadget driver and other. I don't see the g_ether warning
Felipe mentioned. It might come from f_ncm (since it uses a timer) or
something else in the network stack (that uses a timeout timer).
But not now.
As much as I hate it, I suggest:

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 183b90923f51b..a0c883f19a417 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4160,9 +4160,11 @@ static irqreturn_t dwc3_thread_interrupt(int irq, vo=
id *_evt)
 	unsigned long flags;
 	irqreturn_t ret =3D IRQ_NONE;
=20
+	local_bh_disable();
 	spin_lock_irqsave(&dwc->lock, flags);
 	ret =3D dwc3_process_event_buf(evt);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	local_bh_enable();
=20
 	return ret;
 }


In the long run I would drop that irqsave (along with bh_disable() since
netif_rx() covers that) and make sure the there is no lockdep warning
popping up.

Marek, could you please give it a try?

Sebastian
