Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00932396803
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 20:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhEaSml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 14:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230523AbhEaSmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 14:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA8856124B
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 18:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622486459;
        bh=FOkUz+eJAED1xq7OXHJPHzVaiNNqineSt+GPHZeSjD0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QVdsaGIn6viLkj8qkFaD0K6C+38tqM8wlI/MPMRTnmNKfJIRW/sd3Ea5NTAIocDSF
         Muc3oEuNX71MYkHBtKIfmW5hoL4JdZQ6kkCyuLJYfGJVpyyMnvrGK/Kf6FgcP9KJKj
         sxf6EOSEypoUkP/aXDPHVelKlhiIz6ET1QPOeV731zLj8FOf6iKj797FWluYSDRatK
         aV37e/euqODYMGaeyEAp8wiHBJ6L39nNPEbfjSDI99RlunYhIwZgd6ffMmA4N22gv5
         4qtV4baUJIlO5OQsMfmLjKiwXZzpaq2FSbJWnMHnodaOlsoW+3Har6aKtiJtgG9Q6b
         l7vRrvPiKSmOw==
Received: by mail-wm1-f51.google.com with SMTP id z19-20020a7bc7d30000b029017521c1fb75so94301wmk.0
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 11:40:59 -0700 (PDT)
X-Gm-Message-State: AOAM531op0RMM32o90eHjbVZMZ3yapf6suYay+oddQOCHEfSPFyX5j8k
        L5zIoN0GQTgxHLOkjYI7uMxbpQ+6MLU/8fuC5/U=
X-Google-Smtp-Source: ABdhPJxx6Rv/UR15RdGaJ7DgnXpz+3vtHdQUXwuizcWQhjNdfai486UKgWgI05qsnbrGOK0HCUFf10xuBhGcA8oju8M=
X-Received: by 2002:a1c:8016:: with SMTP id b22mr21997980wmd.43.1622486458548;
 Mon, 31 May 2021 11:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com>
In-Reply-To: <60B514A0.1020701@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 31 May 2021 20:39:22 +0200
X-Gmail-Original-Message-ID: <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
Message-ID: <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 7:35 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
> @@ -2169,8 +2162,14 @@
>         if (ackstat)
>                 RTL_W16 (IntrStatus, ackstat);
>
> -       if (netif_running (dev) && (status & RxAckBits))
> -               rtl8139_rx (dev, tp, 1000000000);
> +       /* Receive packets are processed by poll routine.
> +          If not running start it now. */
> +       if (status & RxAckBits){
> +               if (netif_rx_schedule_prep(dev)) {
> +                       RTL_W16_F (IntrMask, rtl8139_norx_intr_mask);
> +                       __netif_rx_schedule (dev);
> +               }
> +       }

Ok, so what you observe is that you get fewer interrupts because of NAPI,
and that TX times out, which points to a missing TX interrupt.

I looked at how the irq status and mask registers are handled, and did not
spot an obvious mistake there that would e.g. lead to the TX interrupts
being disabled or not acked while RX interrupts are disabled. (it does
seem odd that it both disables and defers the ack of the RX interrupts,
but that is probably harmless).

One possible issue is that the "RTL_W16 (IntrStatus, TxErr)" can
leak out of the spinlock unless it is changed to RTL_W16_F(), but
I don't see how that would cause your problem. This is probably
not the issue here, but it can't hurt to change that. Similarly,
the "RTL_W16 (IntrStatus, ackstat)" would need the same _F
to ensure that a  normal TX-only interrupt gets acked before the
spinlock.

Another observation I have is that the loop used to be around
"RTL_R16(IntrStatus); rtl8139_rx(); rtl8139_tx_interrupt()", so
removing the loop also means that the tx handler is only called
once when it used to be called for every loop iteration.
If this is what triggers the problem, you should be able to break
it the same way by moving the rtl8139_tx_interrupt() ahead of the
loop, and adjusting the RTL_W16 (IntrStatus, ackstat) accordingly
so you only Ack the TX before calling rtl8139_tx_interrupt().

       Arnd
