Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245E5B5789
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 23:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfIQV2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 17:28:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfIQV2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 17:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y7ISixd4A8WIRvjIvfDK9Nd3udrwxUJDSq6tTf8pltQ=; b=PraKjzbYVvjvYMqBNRkX4xSNGA
        HHA21VZwJv410CqoMSJ1tQeHAJ1uiX70S6UDkX13VECqezGBdCLbNRp/li5Beo6LbRtgnS2jTDuYx
        A7HkUs5j3YMDy6zf1IEJBE/fCjlQwp0FmPwChL8+91qASeCm7EXovFoMcDedw5AihMpI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAL1g-00043M-9p; Tue, 17 Sep 2019 23:28:44 +0200
Date:   Tue, 17 Sep 2019 23:28:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arlie Davis <arlied@google.com>
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: Bug report (with fix) for DEC Tulip driver (de2104x.c)
Message-ID: <20190917212844.GJ9591@lunn.ch>
References: <CAK-9enMxA68mRYFG=2zD02guvCqe-aa3NO0YZuJcTdBWn5MPqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-9enMxA68mRYFG=2zD02guvCqe-aa3NO0YZuJcTdBWn5MPqg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 02:50:53PM -0700, Arlie Davis wrote:
> Hello. I'm a developer on GCE, Google's virtual machine platform. As
> part of my work, we needed to emulate a DEC Tulip 2104x NIC, so I
> implemented a basic virtual device for it.
> 
> While doing so, I believe I found a bug in the Linux driver for this
> device, in de2104x.c. I see in MAINTAINERS that this is an orphaned
> device driver, but I was wondering if the kernel would still accept a
> patch for it.  Should I submit this patch, and if so, where should I
> submit it?
> 
> Below is the commit text from my local repo, and the patch diffs
> (they're quite short).
> 
>     Fix a bug in DEC Tulip driver (de2104x.c)
> 
>     The DEC Tulip Ethernet controller uses a 16-byte transfer descriptor for
>     both its transmit (tx) and receive (rx) rings. Each descriptor has a
>     "status" uint32 field (called opts1 in de2104x.c, and called TDES0 /
>     Status in the DEC hardware specifications) and a "control" field (called
>     opts2 in de2104x.c and called TDES1 / Control in the DEC
>     specifications). In the "control" field, bit 30 is the LastSegment bit,
>     which indicates that this is the last transfer descriptor in a sequence
>     of descriptors (in case a single Ethernet frame spans more than one
>     descriptor).
> 
>     The de2104x driver correctly sets LastSegment, in the de_start_xmit
>     function. (The code calls it LastFrag, not LastSegment). However, in the
>     interrupt handler (in function de_tx), the driver incorrectly checks for
>     this bit in the status field, not the control field. This means that the
>     driver is reading bits that are undefined in the specification; the
>     spec does not make any guarantees at all about the contents of bits 29
>     and bits 30 in the "status" field.
> 
>     The effect of the bug is that the driver may think that a TX ring entry
>     is never finished, even though a compliant DEC Tulip hardware device (or
>     a virtualized device, in a VM) actually did finish sending the Ethernet
>     frame.
> 
>     The fix is to read the correct "control" field from the TX descriptor.
> 
>     DEC Tulip programming specification:
> 
>     https://web.archive.org/web/20050805091751/http://www.intel.com/design/network/manuals/21140ahm.pdf

Hi Arlie

Without having access to real hardware, it is hard to verify
this. Maybe the programming specification is wrong? It could be, the
hardware designer thought the control field should be write only from
the CPU side, and the status field read only from the CPU side, to
avoid race conditions. So in practice it does mirror the LastSegment
bit from control to status?

Are there any other emulators of this out there? Any silicon vendor
who produces devices which claim to be compatible?

    Andrew
