Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBF93AE212
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 06:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhFUEMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 00:12:21 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:59736 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhFUEMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 00:12:20 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id C0A9492009C; Mon, 21 Jun 2021 06:10:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id B8E5592009B;
        Mon, 21 Jun 2021 06:10:04 +0200 (CEST)
Date:   Mon, 21 Jun 2021 06:10:04 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Gleixner <tglx@linutronix.de>
cc:     Arnd Bergmann <arnd@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Nikolai Zhubr <zhubr.2@gmail.com>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
In-Reply-To: <877dipgyrb.ffs@nanos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk>
 <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Jun 2021, Thomas Gleixner wrote:

> > If overriding the BIOS setting breaks something that works today, nothing
> > is gained, because the next person running into an i486 PCI specific bug
> > is unlikely to be as persistent and competent as Nikolai in tracking down
> > the root cause.
> 
> Yes, sigh. The reason why this BIOS switch exists, which should have
> never existed, is that during the transition from EISA which was edge
> triggered to PCI some card manufacturers just changed the bus interface
> of their cards but completely missed the edge -> level change in
> hardware either by stupidity or intentionally so they did not have to
> make any changes to the rest of the hardware and to drivers.

 Umm, I have been fairly sure it is actually EISA that has introduced 
switching between edge- and level-triggered interrupts on a line-by-line 
basis for ISA option compatibility (previously ISA and MCA were globally 
edge-triggered and level-triggered respectively via a bit in ICW1 as per 
classic 8259A configuration modes) and at least Intel documentation[1][2] 
confirms that ELCR was already present in plain EISA chipsets, so that you 
could set IRQ lines used by ISA and EISA cards for edge-triggering and 
level-triggering respectively.

 One peculiarity here is that level-triggered interrupts are necessarily 
active-low to permit sharing, but ISA edge-triggered interrupts are 
active-high.  Otherwise due to the oddity of how edge-triggered 8259A 
interrupts work we could actually safely reprogram all but the 8254 timer 
for level triggering and things would still work just fine (pretty much 
what MCA did with a hardware hack for the timer).

 So while there may have been odd cases of ISA circuitry repurposed for 
PCI (and then in a broken manner), they must have been exceedingly rare in 
the first place, and likely hardly any have survived, as their usability 
must have been marginal.

 For EISA I reckon such repurposing wouldn't be an issue as the 
manufacturer would simply require the interrupt line to be programmed by 
the EISA BIOS for the edge-triggered mode via the accompanying ECU 
configuration file for the piece of hardware in question.  In fact some 
genuine ISA hardware, such as the 3Com 3c509b Ethernet card, did support 
configuring as EISA hardware.

> The predominant OS'es at that time of course did not have an easy way to
> add a quirk to fix this, so the way out was to add the chicken bit
> option to the BIOS which then either tells the OS the trigger mode for
> INTA..INTD and just sets up ELCR before booting the OS. I have faint
> memories that I had to use such a BIOS switch long time ago to get some
> add-on PCI card working.
> 
> So the right thing to do is to leave 8139 as is and add a PCI quirk
> which enforces level trigger type for 8139 in legacy PCI interrupt mode.

 I think it makes little sense really to add a quirk based on option card 
hardware ID, as one could plug any PCI card into a slot whose interrupt 
line to be used has been incorrectly configured in the BIOS.  So all PCI 
cards would have to have such a quirk defined.

 As I noted in a previous message I think the only sensible approach is to 
have the quirk based on the southbridge hardware ID, or in the absence of 
one -- the northbridge ID (I have now double-checked and it's the Aries 
chipset that does not make its southbridge component, the 82426EX ISA 
Bridge (IB), visible in the PCI configuration space).

 If this system uses the IB or the 82378ZB SIO southbridge, then we can 
handle it with full confidence however, as they have been documented, and 
they both have the ELCR register[3][4][5].  Note that the earlier version 
of the SIO southbridge, the 82378IB doesn't have the ELCR register[6][7], 
and it could only handle PCI interrupts with board-specific external logic 
(probably a design erratum/oversight, hence a later correction[8]).

 The northbridge ID for Aries is 8086:0486 and the southbridge ID for SIO 
is 8086:0484.  The 82378IB and 82378ZB SIO revisions can be told apart by 
the configuration-space Revision Identification Register, bits 3:0: 0x0 
for the 82378IB w/o ELCR, 0x3 for the 82378ZB with ELCR[9].

> Alternatively we can just emit a noisy warning when a legacy PCI
> interrupt is configured as edge by the BIOS and tell people to toggle
> that switch if stuff does not work. Though that might be futile because
> not all BIOSes have these toggle options.

 A warning surely won't hurt, but TBH I'd just reprogram any incorrectly 
configured PCI interrupt line unconditionally where the ELCR is available.  
The chance someone uses a broken PCI card that drives its interrupt line 
as edge-triggered and is actually handled by a Linux driver both at a time 
is IMO nil.  Such a card requires special provisions hardly any system 
provides and has anyone here seen a report of such a beast?

 NB copies of documents referred available upon request, except for 
290473-004, which I only have in the hardcopy form (though see 
<https://archive.org/details/bitsavers_intelpentirocessorsandRelatedComponents_64170750>).

References:

[1] "82357 Integrated System Peripheral (ISP)", Intel Corporation, Order 
    Number: 290253-006, March, 1994, Section 5.14.7 "Edge and Level
    Triggered Modes", p. 44

[2] "Multiprocessor Specification", Version 1.1, Intel Corporation, Order 
    Number: 242016-003, September 1994, Section 5.3.2 "Level-triggered 
    Interrupt Support", p. 5-7

[3] "82420EX PCIset Data Sheet, 82425EX PCI System Controller (PSC)
    and 82426EX ISA Bridge (IB)", Intel Corporation, Order Number: 
    290488-004, December 1995, Section 4.11.2 "Edge and Level Interrupt
    Triggered Mode", p. 111

[4] "82378 System I/O (SIO)", Intel Corporation, Order Number: 290473-004, 
    December 1994, Section 5.8.1 "Edge and Level Triggered Modes"

[5] "82378ZB System I/O (SIO) and 82379AB System I/O APIC (SIO.A)", Intel 
    Corporation, Order Number: 290571-001, March 1996, Section 4.8.1. 
    "Edge and Level Triggered Modes", p. 101

[6] "82378IB System I/O (SIO)", Intel Corporation, Order Number: 
    290473-002, April 1993, Section 5.8.7.7 "Edge and Level Triggered 
    Modes"

[7] "82378 System I/O (SIO)", Intel Corporation, Order Number: 290473-004, 
    December 1994, Section 4.4.1 "ICW1--Initialization Command Word 1 
    Register"

[8] "82378IB to 82378ZB Errata Fix and Feature Enhancement Conversion 
    FOL933002-01", 
    <https://web.archive.org/web/19990421045433/http://support.intel.com/support/chipsets/420/8511.htm>

[9] "82378 System I/O (SIO)", Intel Corporation, Order Number: 290473-004,
    December 1994, Section 4.1.5 "RID--Revision Identification Register"

  Maciej
