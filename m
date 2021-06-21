Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100903AEB9A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 16:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFUOoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 10:44:39 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:59768 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFUOog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 10:44:36 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 060F492009C; Mon, 21 Jun 2021 16:42:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id F28A192009B;
        Mon, 21 Jun 2021 16:42:19 +0200 (CEST)
Date:   Mon, 21 Jun 2021 16:42:19 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Arnd Bergmann <arnd@kernel.org>
cc:     Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Nikolai Zhubr <zhubr.2@gmail.com>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
In-Reply-To: <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2106211623090.779@angie.orcam.me.uk>
References: <60B24AC2.9050505@gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com>
 <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com>
 <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Jun 2021, Arnd Bergmann wrote:

> >  A warning surely won't hurt, but TBH I'd just reprogram any incorrectly
> > configured PCI interrupt line unconditionally where the ELCR is available.
> > The chance someone uses a broken PCI card that drives its interrupt line
> > as edge-triggered and is actually handled by a Linux driver both at a time
> > is IMO nil.  Such a card requires special provisions hardly any system
> > provides and has anyone here seen a report of such a beast?
> 
> I looked some more through the git history and found at least one time
> that the per-chipset ELCR fixup came up for discussion[1], and this
> appears to have resulted in generalizing an ALI specific fixup into
> common code into common code[2], so we should already be doing
> exactly this in many cases. If Nikolai can boot the system with debugging
> enabled for arch/x86/pci/irq.c, we should be able to see exactly
> which code path is his in his case, and why it doesn't go through
> setting that register at the moment.
> 
> I also found an slightly more recent discussion, from where it seems
> that the authoritative decision when it came up in the past was that edge
> triggered interrupts are supposed to work as long as they are not
> shared [3][4].

 Sadly Linus's rule applies both ways: if a device has been designed with 
level-triggered interrupts in mind, there may be no race-free way to 
ensure an active-to-inactive-to-active transition has happened on its IRQ 
line as the driver acknowledges handling in the relevant device's CSR.  

 The rule of thumb is to acknowledge early in the handler, and to work 
around broken configurations it may be desirable to also briefly mask all 
the interrupt sources with the device so as to make sure it deasserts its 
IRQ line even if another interrupt has already been queued.  OTOH if IRQ
sharing is to be supported a device absolutely has to have an interrupt 
mask register, as the system cannot rely on masking at the interrupt 
controller if multiple devices are to be handled with a single line.  I 
suspect many of our drivers do not do such precautionary masking though.

 Is there a mask register with the 8139?

 NB I find it amazing how people can break such relatively simple 
concepts, like not getting PCI IRQ steering right in early designs or 
messing up edge and level triggering.  I mean wired interrupts are not 
rocket science.  Sigh...

  Maciej
