Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D03355077
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbhDFKFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240979AbhDFKFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 06:05:18 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E559C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 03:05:10 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id h7so10711644qtx.3
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 03:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z/xnRTBuWqAi+huuq427+Hagp0Iffp9JP9RF/7XM+NU=;
        b=UJV+f4JCGRpnFO+0A5snSP1faa/tfAYHD1UMXC0RCHyBptxVMDQDdjc1C7zHyTNwZr
         SVG8E1bJaZ7MRf29V1mxrIrYxkPMFRpA6xcnyyNZviLt+tMlQaG5RXre/XdyIOD2pv0K
         C4nTkcr5RzJjbEbD5VmVBujABGMgVEKUWckXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z/xnRTBuWqAi+huuq427+Hagp0Iffp9JP9RF/7XM+NU=;
        b=HOikb5MY2j/IzSzHTKwwLnLWUL84SVJ6pxj44tdCx59enbrPQA9q+DBrbfJX1/v6d/
         05qU8Ttq887Rspud4YR+5aOgmez/0KdYMBsrZgGFUZYWU3o28WV8M96pF1QKy6h7VgPy
         qGnjYsH+OmVTGjbDPE3UBImXUB+VqvEdw4xxsBvBZarzEW0iDHet2q5BbvebkqeBFQ/O
         o5ZMQc+RhyzjVnSJvwgjuj+Bh/E1h9jwEwAxnd+5+VjqqMmzpU6KsZfwDdKGJi92SC1m
         qionFIsBOiqsWKEzeiGFUkI8WJ2zCR2h/YUDQeGVwNH79x8iVuCRJou5Ga+58ZNfkqON
         1rrg==
X-Gm-Message-State: AOAM5323ciA371IoaZATSMSIcF2cyLF94vuDb9ApYzTryHVNLYm9I+rj
        LGyyn8+q/H5VO3TZlzJ5NB9L80Dv1avnb2twR5tvYg==
X-Google-Smtp-Source: ABdhPJx+QxskeGybHZaP9XU5W/U0bdEC8s+rFcCwE80+g6Yk10+tEUew6P1i8uT989jXxH5blrDdLWBbuPy/6RqqbFI=
X-Received: by 2002:ac8:5313:: with SMTP id t19mr26582977qtn.148.1617703509526;
 Tue, 06 Apr 2021 03:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201209184740.16473-1-w@1wt.eu>
In-Reply-To: <20201209184740.16473-1-w@1wt.eu>
From:   Daniel Palmer <daniel@0x0f.com>
Date:   Tue, 6 Apr 2021 19:04:58 +0900
Message-ID: <CAFr9PX=Ky2QuXNH09DmegFV=e-4+ChdypSsJfV8svqxP7U-cpg@mail.gmail.com>
Subject: Re: [PATCH] Revert "macb: support the two tx descriptors on at91rm9200"
To:     Willy Tarreau <w@1wt.eu>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy,

I've been messing with the SSD202D (sibling of the MSC313E) recently
and the ethernet performance was awful.
I remembered this revert and reverted it and it makes the ethernet
work pretty well.

So I would like to find some way of making this patch work and I did
some digging..

On Thu, 10 Dec 2020 at 03:47, Willy Tarreau <w@1wt.eu> wrote:
>
> This reverts commit 0a4e9ce17ba77847e5a9f87eed3c0ba46e3f82eb.
>
> The code was developed and tested on an MSC313E SoC, which seems to be
> half-way between the AT91RM9200 and the AT91SAM9260 in that it supports
> both the 2-descriptors mode and a Tx ring.

The MSC313E and later seem to have a hidden "TX ring" with 4 descriptors.
It looks like instead of implementing a ring in memory like the RX
side has and all other macb variations they decided to put a 4 entry
FIFO behind the TAR/TCR registers.
You can load TAR/TCR normally so it is backwards compatible to the
at91rm9200 but you can fill it with multiple frames to transmit
without waiting for TX to end.
There are some extra bits in TSR that seem to indicate how many frames
are still waiting to be transmitted and the way BNQ works is a little
different.

> It turns out that after the code was merged I could notice that the
> controller would sometimes lock up, and only when dealing with sustained
> bidirectional transfers, in which case it would report a Tx overrun
> condition right after having reported being ready, and will stop sending
> even after the status is cleared (a down/up cycle fixes it though).

I can reproduce this with iperf3's bidirectional mode without fail.

I hacked up the driver a bit so that the TX path sends each frame 6
times recording the TSR register before and after to see what is
happening:

# udhcpc
udhcpc: started, v1.31.1
[   12.944302] Doing phy power up
[   13.147460] macb 1f2a2000.emac eth0: PHY
[1f2a2000.emac-ffffffff:00] driver [msc313e phy] (irq=POLL)
[   13.156655] macb 1f2a2000.emac eth0: configuring for phy/mii link mode
udhcpc: sending discover
[   15.205691] macb 1f2a2000.emac eth0: Link is Up - 100Mbps/Full -
flow control off
[   15.213358] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   15.245235] pre0 41001fb8, post0 30001fb0 -> IDLETSR clear
[   15.249291] pre1 30001f90, post1 20001d90 -> FIFOIDLE1 clear
[   15.253331] pre2 20001d90, post2 10001990 -> FIFOIDLE2 clear
[   15.257385] pre3 10001990, post3 00001190 -> FIFOIDLE3 clear
[   15.261435] pre4 00001190, post4 f0000191 -> FIFOIDLE4 clear, OVR set
[   15.265485] pre5 f0000190, post5 f0000191 -> OVR set
[   15.269535] pre6 f0000190, post6 e0000181 -> OVR set, BNQ clear

There seems to be a FIFO empty counter in the top of the register but
this is totally undocumented.
There are two new status bits TBNQ and FBNQ at bits 7 and 8. I have no
idea what they mean.
Bits 9 through 12 are some new status bits that seem to show if a FIFO
slot is inuse.
I can't find any mention of these bits anywhere except the header of
the vendor driver so I think these are specific to MStar's macb.

The interesting part though is that BNQ does not get cleared until
multiple frames have been pushed in and after OVR is set.
I think this is what breaks your code when it runs on the MSC313E
version of MACB.

Anyhow. I'm working on a version of your patch that should work with
both the at91rm9200 and the MSC313E.

Thanks,

Daniel
