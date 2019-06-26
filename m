Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E20D55CD6
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 02:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFZALs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 20:11:48 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36239 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFZALr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 20:11:47 -0400
Received: by mail-yb1-f194.google.com with SMTP id e197so283042ybb.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 17:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tyKkssbXYjknYOtcNy9n1nYmLXLb/WwtBKaNgoXk/VE=;
        b=ZQjNvwnKz6iNv4oJUG+hAXE77JYsuzMOV/Fe5M/Kq/Y7WURhRRc5Q4H7GrFElMzA42
         jchKNkJia9hZc3IARB2eq13TQwpQyM6fofQC/CxOJoCenWkSKMktgflGqSczsrsXeDgq
         VvVr/8Fq8RrXPee5a9QjMP7lwKNNg5993nhMZ/PBv0LcDq5R3H/s+E6QhBUc7CFMJA/6
         IpN9GPsgDdmGV15I2Qoxbc4P8DbqChW4W0uh7PwN7ZVHdNCdxpLK9aElL7jMt38HniVv
         fErTFkrEaP/7LfZpyz6XIBzqnwrVVApO0db6rpGnptOOZPLYLXzoL9MRCEHHYx+dfeqG
         DMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tyKkssbXYjknYOtcNy9n1nYmLXLb/WwtBKaNgoXk/VE=;
        b=ZYLyUo82hq5xsJw2jeVbEGu1OLRwqKTDt7LWIAaU2l/P4zZuw2UoVO3/bLPwNAxhQW
         c+mvAqI7p4wkz1FC2Yt34aIe8aejvXcbkwcIvrqLZLpeIgUlyzil2KPdKisO64Qzb/hD
         U2BTexXkgaGReCxa3lpRDcMNhWTwtN/Fe5XuUdcwqT4zsId5+V3kEcolVV4HweXemH7c
         OG+Cjz0DuyGeoOaTgv//39dpLtsxMNWzn0FSqVtPlrQKrBGmBM+P7hnLbbn5J9zKc+FR
         MRelfe5akxO38Z21JF/Ydk2zlQIfwKD2CCk8ManqJs+qocHBfWv8jj8wjoxxPrCf6JkR
         PDrg==
X-Gm-Message-State: APjAAAXyTomAmFrAGqTuRROd2E38PpBK8Lj7xJeo6HDhfag0BWFewT23
        pR/aWYTUB1LYFZ3V2ioPbcXl9B2LVf9ba9wUBU00+Q==
X-Google-Smtp-Source: APXvYqzUWc5rmfZSQHNESPO4wdYEqEvqnuswOY2dOKuTYYyg7XTna6Kblo6r3gic88WzO29sh/JgN25X2eiRJXFgloo=
X-Received: by 2002:a25:738e:: with SMTP id o136mr787414ybc.235.1561507906342;
 Tue, 25 Jun 2019 17:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190625233942.1946-1-olteanv@gmail.com> <20190625233942.1946-3-olteanv@gmail.com>
In-Reply-To: <20190625233942.1946-3-olteanv@gmail.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Tue, 25 Jun 2019 20:11:10 -0400
Message-ID: <CA+FuTSc-dJuDdij6nLrP1SxH2cCEHb8Ja=b40Ba3Q08p3wrgYg@mail.gmail.com>
Subject: Re: [PATCH net-next 02/10] net: dsa: sja1105: Cancel PTP delayed work
 on unregister
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 7:40 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Currently when the driver unloads and PTP is enabled, the delayed work
> that prevents the timecounter from expiring becomes a ticking time bomb.
> The kernel will schedule the work thread within 60 seconds of driver
> removal, but the work handler is no longer there, leading to this
> strange and inconclusive stack trace:
>
> [   64.473112] Unable to handle kernel paging request at virtual address 79746970
> [   64.480340] pgd = 008c4af9
> [   64.483042] [79746970] *pgd=00000000
> [   64.486620] Internal error: Oops: 80000005 [#1] SMP ARM
> [   64.491820] Modules linked in:
> [   64.494871] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.2.0-rc5-01634-ge3a2773ba9e5 #1246
> [   64.503007] Hardware name: Freescale LS1021A
> [   64.507259] PC is at 0x79746970
> [   64.510393] LR is at call_timer_fn+0x3c/0x18c
> [   64.514729] pc : [<79746970>]    lr : [<c03bd734>]    psr: 60010113
> [   64.520965] sp : c1901de0  ip : 00000000  fp : c1903080
> [   64.526163] r10: c1901e38  r9 : ffffe000  r8 : c19064ac
> [   64.531363] r7 : 79746972  r6 : e98dd260  r5 : 00000100  r4 : c1a9e4a0
> [   64.537859] r3 : c1900000  r2 : ffffa400  r1 : 79746972  r0 : e98dd260
> [   64.544359] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [   64.551460] Control: 10c5387d  Table: a8a2806a  DAC: 00000051
> [   64.557176] Process swapper/0 (pid: 0, stack limit = 0x1ddb27f0)
> [   64.563147] Stack: (0xc1901de0 to 0xc1902000)
> [   64.567481] 1de0: eb6a4918 3d60d7c3 c1a9e554 e98dd260 eb6a34c0 c1a9e4a0 ffffa400 c19064ac
> [   64.575616] 1e00: ffffe000 c03bd95c c1901e34 c1901e34 eb6a34c0 c1901e30 c1903d00 c186f4c0
> [   64.583751] 1e20: c1906488 29e34000 c1903080 c03bdca4 00000000 eaa6f218 00000000 eb6a45c0
> [   64.591886] 1e40: eb6a45c0 20010193 00000003 c03c0a68 20010193 3f7231be c1903084 00000002
> [   64.600022] 1e60: 00000082 00000001 ffffe000 c1a9e0a4 00000100 c0302298 02b64722 0000000f
> [   64.608157] 1e80: c186b3c8 c1877540 c19064ac 0000000a c186b350 ffffa401 c1903d00 c1107348
> [   64.616292] 1ea0: 00200102 c0d87a14 ea823c00 ffffe000 00000012 00000000 00000000 ea810800
> [   64.624427] 1ec0: f0803000 c1876ba8 00000000 c034c784 c18774b8 c039fb50 c1906c90 c1978aac
> [   64.632562] 1ee0: f080200c f0802000 c1901f10 c0709ca8 c03091a0 60010013 ffffffff c1901f44
> [   64.640697] 1f00: 00000000 c1900000 c1876ba8 c0301a8c 00000000 000070a0 eb6ac1a0 c031da60
> [   64.648832] 1f20: ffffe000 c19064ac c19064f0 00000001 00000000 c1906488 c1876ba8 00000000
> [   64.656967] 1f40: ffffffff c1901f60 c030919c c03091a0 60010013 ffffffff 00000051 00000000
> [   64.665102] 1f60: ffffe000 c0376aa4 c1a9da37 ffffffff 00000037 3f7231be c1ab20c0 000000cc
> [   64.673238] 1f80: c1906488 c1906480 ffffffff 00000037 c1ab20c0 c1ab20c0 00000001 c0376e1c
> [   64.681373] 1fa0: c1ab2118 c1700ea8 ffffffff ffffffff 00000000 c1700754 c17dfa40 ebfffd80
> [   64.689509] 1fc0: 00000000 c17dfa40 3f7733be 00000000 00000000 c1700330 00000051 10c0387d
> [   64.697644] 1fe0: 00000000 8f000000 410fc075 10c5387d 00000000 00000000 00000000 00000000
> [   64.705788] [<c03bd734>] (call_timer_fn) from [<c03bd95c>] (expire_timers+0xd8/0x144)
> [   64.713579] [<c03bd95c>] (expire_timers) from [<c03bdca4>] (run_timer_softirq+0xe4/0x1dc)
> [   64.721716] [<c03bdca4>] (run_timer_softirq) from [<c0302298>] (__do_softirq+0x130/0x3c8)
> [   64.729854] [<c0302298>] (__do_softirq) from [<c034c784>] (irq_exit+0xbc/0xd8)
> [   64.737040] [<c034c784>] (irq_exit) from [<c039fb50>] (__handle_domain_irq+0x60/0xb4)
> [   64.744833] [<c039fb50>] (__handle_domain_irq) from [<c0709ca8>] (gic_handle_irq+0x58/0x9c)
> [   64.753143] [<c0709ca8>] (gic_handle_irq) from [<c0301a8c>] (__irq_svc+0x6c/0x90)
> [   64.760583] Exception stack(0xc1901f10 to 0xc1901f58)
> [   64.765605] 1f00:                                     00000000 000070a0 eb6ac1a0 c031da60
> [   64.773740] 1f20: ffffe000 c19064ac c19064f0 00000001 00000000 c1906488 c1876ba8 00000000
> [   64.781873] 1f40: ffffffff c1901f60 c030919c c03091a0 60010013 ffffffff
> [   64.788456] [<c0301a8c>] (__irq_svc) from [<c03091a0>] (arch_cpu_idle+0x38/0x3c)
> [   64.795816] [<c03091a0>] (arch_cpu_idle) from [<c0376aa4>] (do_idle+0x1bc/0x298)
> [   64.803175] [<c0376aa4>] (do_idle) from [<c0376e1c>] (cpu_startup_entry+0x18/0x1c)
> [   64.810707] [<c0376e1c>] (cpu_startup_entry) from [<c1700ea8>] (start_kernel+0x480/0x4ac)
> [   64.818839] Code: bad PC value
> [   64.821890] ---[ end trace e226ed97b1c584cd ]---
> [   64.826482] Kernel panic - not syncing: Fatal exception in interrupt
> [   64.832807] CPU1: stopping
> [   64.835501] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D           5.2.0-rc5-01634-ge3a2773ba9e5 #1246
> [   64.845013] Hardware name: Freescale LS1021A
> [   64.849266] [<c0312394>] (unwind_backtrace) from [<c030cc74>] (show_stack+0x10/0x14)
> [   64.856972] [<c030cc74>] (show_stack) from [<c0ff4138>] (dump_stack+0xb4/0xc8)
> [   64.864159] [<c0ff4138>] (dump_stack) from [<c0310854>] (handle_IPI+0x3bc/0x3dc)
> [   64.871519] [<c0310854>] (handle_IPI) from [<c0709ce8>] (gic_handle_irq+0x98/0x9c)
> [   64.879050] [<c0709ce8>] (gic_handle_irq) from [<c0301a8c>] (__irq_svc+0x6c/0x90)
> [   64.886489] Exception stack(0xea8cbf60 to 0xea8cbfa8)
> [   64.891514] bf60: 00000000 0000307c eb6c11a0 c031da60 ffffe000 c19064ac c19064f0 00000002
> [   64.899649] bf80: 00000000 c1906488 c1876ba8 00000000 00000000 ea8cbfb0 c030919c c03091a0
> [   64.907780] bfa0: 600d0013 ffffffff
> [   64.911250] [<c0301a8c>] (__irq_svc) from [<c03091a0>] (arch_cpu_idle+0x38/0x3c)
> [   64.918609] [<c03091a0>] (arch_cpu_idle) from [<c0376aa4>] (do_idle+0x1bc/0x298)
> [   64.925967] [<c0376aa4>] (do_idle) from [<c0376e1c>] (cpu_startup_entry+0x18/0x1c)
> [   64.933496] [<c0376e1c>] (cpu_startup_entry) from [<803025cc>] (0x803025cc)
> [   64.940422] Rebooting in 3 seconds..
>
> In this case, what happened is that the DSA driver failed to probe at
> boot time due to a PHY issue during phylink_connect_phy:
>
> [    2.245607] fsl-gianfar soc:ethernet@2d90000 eth2: error -19 setting up slave phy
> [    2.258051] sja1105 spi0.1: failed to create slave for port 0.0
>
> Fixes: bb77f36ac21d ("net: dsa: sja1105: Add support for the PTP clock")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
