Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00E1B57AE
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 23:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfIQVhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 17:37:13 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41379 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfIQVhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 17:37:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id x15so2685098pgg.8
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 14:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IWZyGnTuUXe6mInqirs/V2Jra4CVO2Bebqh0F6XSVWY=;
        b=tFs+S5kA+2T0TuwnELnYmfmp6QR7u4BcTRFU9Vt7rwB20ByIWxuR8P3RFqrmLBEy8q
         UkZMPn9Xj2tpD7r6Nqb7vJWZeBkNMe+FAu8HUa1Cb6XUsAb4lbfEdD0mISZQk4EqsbgP
         LNTGpyKgoblsTrbJIkXDUMAcxZ/XH91iUtwpoh640fm/nhFKKSyujrDW6+2WHCoOCimS
         lpMk0J8Ar174jnwcyrdDkx+iZgZoP+PTYXD30yiQQontAcyMo+sNjIvFrJ7FcZhkQPLG
         UVULoCRrnUZ+IVNBXJjDPcq6zrbNRlcmRQa4XCpMOHDC0ezS2fo8h6T74Hi6iWwBf6ej
         q2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IWZyGnTuUXe6mInqirs/V2Jra4CVO2Bebqh0F6XSVWY=;
        b=gqz8+gHlQRExKAMThka9vPPgVIKqx9e9xBIn6OLSqzUbvJkDnux2bZ8AweAvbNrJSk
         DXf2T04mS6Hsmy1HCw0eS5zfAkfK5YSi8FpIyUrCE1ZAF9bKXf+FJucfngFgIgfBc6mp
         KhZTycpFvBmOMpjmA+XwGml6Lt5vqd+cGMyLOiB/j3aqZBqDJ/wjq996U8DhI9DALdCs
         FIimlUU1CtbiKPH/32QpyE422yTV/UgOxP5AABa82CeKnIPW5rMqKC98AOjCrY3aGgEV
         ddgMfPgV2EqXJQspuTX6YWpdWr9N7L4DRaxBB5dOLuHFXTC256qoju6xoMyQFVUv5XYz
         YjYg==
X-Gm-Message-State: APjAAAXUW6hEvvIk6JeUFzflp0njGcfjmOlPLYpjJ1zbTqH6aVM7X0ca
        scH2y7/m1SDFH8f8d4SSjONJ0sRCv/PDcDlzKuA1JBQ5
X-Google-Smtp-Source: APXvYqxPaxu/JL+zxvzVdiV6XryuclEXRH+Gsgf3ti3HpQhjPFPILizUDOCgchY+FHGoVbWml+Lo9ursR2pMb56cYaI=
X-Received: by 2002:a63:d846:: with SMTP id k6mr898180pgj.378.1568756230483;
 Tue, 17 Sep 2019 14:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-9enMxA68mRYFG=2zD02guvCqe-aa3NO0YZuJcTdBWn5MPqg@mail.gmail.com>
 <20190917212844.GJ9591@lunn.ch>
In-Reply-To: <20190917212844.GJ9591@lunn.ch>
From:   Arlie Davis <arlied@google.com>
Date:   Tue, 17 Sep 2019 14:36:59 -0700
Message-ID: <CAK-9enOx8xt_+t6-rpCGEL0j-HJGm=sFXYq9-pgHQ26AwrGm5Q@mail.gmail.com>
Subject: Re: Bug report (with fix) for DEC Tulip driver (de2104x.c)
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I checked QEMU v3.1, and I don't see any Tulip implementation for it.
I haven't checked any other emulators. A few cursory searches didn't
turn up anything.

I checked the FreeBSD driver for the same device. It just treats the
control field as a write-only field; the driver just uses its own
internal state, rather than reading anything from the transfer
descriptor, aside from the relevant status bits.

My guess is that the hardware just always sets bit 30 = 1, in the
status field. In this Linux driver, for a normal packet (non-SETUP,
non-DUMMY), all packets use a single TX descriptor, so LastFrag=1 is
always true. Because of this, I considered changing the Linux driver
to just remove the "if (status & LastFrag)" check, and make it
unconditional, since this driver never uses more than 1 descriptor per
transmitted packet. Would you support that change?

Likewise, I'm at a loss for testing with real hardware. It's hard to
find such things, now.

On Tue, Sep 17, 2019 at 2:28 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Sep 16, 2019 at 02:50:53PM -0700, Arlie Davis wrote:
> > Hello. I'm a developer on GCE, Google's virtual machine platform. As
> > part of my work, we needed to emulate a DEC Tulip 2104x NIC, so I
> > implemented a basic virtual device for it.
> >
> > While doing so, I believe I found a bug in the Linux driver for this
> > device, in de2104x.c. I see in MAINTAINERS that this is an orphaned
> > device driver, but I was wondering if the kernel would still accept a
> > patch for it.  Should I submit this patch, and if so, where should I
> > submit it?
> >
> > Below is the commit text from my local repo, and the patch diffs
> > (they're quite short).
> >
> >     Fix a bug in DEC Tulip driver (de2104x.c)
> >
> >     The DEC Tulip Ethernet controller uses a 16-byte transfer descriptor for
> >     both its transmit (tx) and receive (rx) rings. Each descriptor has a
> >     "status" uint32 field (called opts1 in de2104x.c, and called TDES0 /
> >     Status in the DEC hardware specifications) and a "control" field (called
> >     opts2 in de2104x.c and called TDES1 / Control in the DEC
> >     specifications). In the "control" field, bit 30 is the LastSegment bit,
> >     which indicates that this is the last transfer descriptor in a sequence
> >     of descriptors (in case a single Ethernet frame spans more than one
> >     descriptor).
> >
> >     The de2104x driver correctly sets LastSegment, in the de_start_xmit
> >     function. (The code calls it LastFrag, not LastSegment). However, in the
> >     interrupt handler (in function de_tx), the driver incorrectly checks for
> >     this bit in the status field, not the control field. This means that the
> >     driver is reading bits that are undefined in the specification; the
> >     spec does not make any guarantees at all about the contents of bits 29
> >     and bits 30 in the "status" field.
> >
> >     The effect of the bug is that the driver may think that a TX ring entry
> >     is never finished, even though a compliant DEC Tulip hardware device (or
> >     a virtualized device, in a VM) actually did finish sending the Ethernet
> >     frame.
> >
> >     The fix is to read the correct "control" field from the TX descriptor.
> >
> >     DEC Tulip programming specification:
> >
> >     https://web.archive.org/web/20050805091751/http://www.intel.com/design/network/manuals/21140ahm.pdf
>
> Hi Arlie
>
> Without having access to real hardware, it is hard to verify
> this. Maybe the programming specification is wrong? It could be, the
> hardware designer thought the control field should be write only from
> the CPU side, and the status field read only from the CPU side, to
> avoid race conditions. So in practice it does mirror the LastSegment
> bit from control to status?
>
> Are there any other emulators of this out there? Any silicon vendor
> who produces devices which claim to be compatible?
>
>     Andrew
