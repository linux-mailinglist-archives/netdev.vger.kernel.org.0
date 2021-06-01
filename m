Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0105239796C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 19:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhFARqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 13:46:43 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:33700 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbhFARql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 13:46:41 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 9A3FB92009C; Tue,  1 Jun 2021 19:44:58 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 93D4E92009B;
        Tue,  1 Jun 2021 19:44:58 +0200 (CEST)
Date:   Tue, 1 Jun 2021 19:44:58 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
cc:     Nikolai Zhubr <zhubr.2@gmail.com>, Arnd Bergmann <arnd@kernel.org>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
In-Reply-To: <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
Message-ID: <alpine.DEB.2.21.2106011918390.11113@angie.orcam.me.uk>
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021, Heiner Kallweit wrote:

> > Alternatively, maybe it is possible to explicitely request level mode from 8259 at the driver startup?
> > 
> I have doubts that it is possible to overrule what the BIOS/ACPI communicate
> to the kernel.

 Umm, any 486 system surely predates ACPI by several years; indeed I have 
a dual Pentium MMX system from 1997 that does not have ACPI either and 
uses an MP Table to communicate interrupt line configuration.  I am fairly
sure an old UP 486 system communicates nothing.

 Since the inception of EISA the usual way for x86 systems to switch 
between classic edge-triggered and level-triggered interrupts on a line by 
line basis has been the ELCR, a 16-bit mainboard register at 0x4d0 in the 
port I/O space.  We do have support for that register, however used in 
certain circumstances only, clearly not yours.  Classic 8259A chips could 
only switch trigger modes globally across all interrupt lines.

 You might be able to add a quirk based on your chipset's vendor/device ID 
though, which would call `elcr_set_level_irq' for interrupt lines claimed 
by PCI devices.  You'd have to match on the southbridge's ID I imagine, if 
any (ISTR at least one Intel chipset did not have a southbridge visible on 
PCI), as it's where the 8259A cores along with any ELCR reside.

 It would be the right thing to do IMO; those early PCI systems often got 
these things wrong, and the selection for the trigger mode shouldn't have 
been there in the BIOS setup in the first place (the manufacturer couldn't 
obviously figure it out how to do this correctly by just scanning PCI, so 
they shifted the burden onto the end user; though I have to admit odd hw 
used to be made too, e.g. I remember seeing a PCI PATA option card with an 
extra cable and a tiny PCB stub to be plugged into the upper part of a 
spare ISA slot to get IRQ 14/15 routed from there).

 HTH,

  Maciej
