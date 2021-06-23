Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91F43B2400
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 01:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFWXlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 19:41:37 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:59892 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhFWXlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 19:41:35 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id EE0029200BB; Thu, 24 Jun 2021 01:39:14 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id EA54F92009D;
        Thu, 24 Jun 2021 01:39:14 +0200 (CEST)
Date:   Thu, 24 Jun 2021 01:39:14 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Nikolai Zhubr <zhubr.2@gmail.com>
cc:     Arnd Bergmann <arnd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
In-Reply-To: <60D361FF.70905@gmail.com>
Message-ID: <alpine.DEB.2.21.2106240044080.37803@angie.orcam.me.uk>
References: <60B24AC2.9050505@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
 <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com> <60D361FF.70905@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021, Nikolai Zhubr wrote:

> > As I said before, I still think we should also merge the 8139 driver patch,
> > probably without that loop. It's not great, but I'm much more confident
> > I understand what that does and that the patched version is better than
> > the current code.
> 
> Yes, the 'poll' approach apparently works stable and does not cause any
> measurable performance decrease. But it would need some carefull
> cleanup/review, especially WRT locking. Now that all real event handling work
> is happening in the poll function, it still has to be protected against the
> (potentially also long-running) reset function which in current design can be
> called e.g. from a different thread due to tx timeout, and this does not look
> good, but it is a bit beyond my capability to arrange it better. Besides, the
> idea was to keep the fix simple and avoid a massive rework...

 The simplest fix is not always the right one.

 I've now posted a small patch series that adds a PCI IRQ router for the 
SiS85C497 device.  Would you please try it with your system along with the 
debug patch included below and send me the resulting bootstap log?

  Maciej
---
 arch/x86/include/asm/pci_x86.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-macro-ide/arch/x86/include/asm/pci_x86.h
===================================================================
--- linux-macro-ide.orig/arch/x86/include/asm/pci_x86.h
+++ linux-macro-ide/arch/x86/include/asm/pci_x86.h
@@ -7,7 +7,7 @@
 
 #include <linux/ioport.h>
 
-#undef DEBUG
+#define DEBUG 1
 
 #ifdef DEBUG
 #define DBG(fmt, ...) printk(fmt, ##__VA_ARGS__)
