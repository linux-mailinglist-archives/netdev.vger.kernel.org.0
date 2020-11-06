Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC8B2A9809
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 16:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgKFPGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 10:06:08 -0500
Received: from pb-smtp20.pobox.com ([173.228.157.52]:61102 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgKFPGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 10:06:07 -0500
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 6780810017C;
        Fri,  6 Nov 2020 10:06:04 -0500 (EST)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=F4V1WbFobXV+iU6r79daG5anTsc=; b=Zl6nib
        71EuICw+K01UwAKOAN0yMZ7PzPGo1qdhG11ngC0kNta3USlp2d2bqtGmYeTAQp9Y
        cXLjXapRQZB4iS0+TkZf1/B17+HHvwsrL+Mj727U50rcmHrH2MqKMjeykp8Yh5JA
        WMiPdD4nlOsDCOA9IciyaaJTok2HmsTntNyP0=
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 610BB10017B;
        Fri,  6 Nov 2020 10:06:04 -0500 (EST)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=s3wM6xxB6N8HyG2pP206sGXJneMn/ZnQEE4uSQsHZEs=; b=RLMhvKKBItIDWqFBVxJyVhGMZVOmzWeihmi97nM1QQ5qAkxZtCvM25KppSsjoGlZMRneYvXmVPFxOkVq1g4JJ8esRx6emKH3V4HG9I4RdQe4IsKXVNLFePMbnZcQ5U1eNXHIdbd5B00g4LNzuvP4Jmtguft2QMu15dYUmm76/TU=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id 4760A100178;
        Fri,  6 Nov 2020 10:06:01 -0500 (EST)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 700612DA0963;
        Fri,  6 Nov 2020 10:05:59 -0500 (EST)
Date:   Fri, 6 Nov 2020 10:05:59 -0500 (EST)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     'Jakub Kicinski' <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Subject: RE: [PATCH net-next v2 6/7] drivers: net: smc911x: Fix cast from
 pointer to integer of different size
In-Reply-To: <babda61688af4f42b4a9e0fb41808272@AcuMS.aculab.com>
Message-ID: <nycvar.YSQ.7.78.906.2011060942360.2184@knanqh.ubzr>
References: <20201104154858.1247725-1-andrew@lunn.ch> <20201104154858.1247725-7-andrew@lunn.ch> <20201105144711.40a2f8f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <babda61688af4f42b4a9e0fb41808272@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 9533733E-2041-11EB-B90A-E43E2BB96649-78420484!pb-smtp20.pobox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020, David Laight wrote:

> From: Jakub Kicinski
> > Sent: 05 November 2020 22:47
> > 
> > On Wed,  4 Nov 2020 16:48:57 +0100 Andrew Lunn wrote:
> > > -	buf = (char*)((u32)skb->data & ~0x3);
> > > -	len = (skb->len + 3 + ((u32)skb->data & 3)) & ~0x3;
> > > -	cmdA = (((u32)skb->data & 0x3) << 16) |
> > > +	offset = (unsigned long)skb->data & 3;
> > > +	buf = skb->data - offset;
> > > +	len = skb->len + offset;
> > > +	cmdA = (offset << 16) |
> > 
> > The len calculation is wrong, you trusted people on the mailing list
> > too much ;)
> 
> I misread what the comment-free convoluted code was doing....
> 
> Clearly it is rounding the base address down to a multiple of 4
> and passing the offset in cmdA.
> This is fine - but quite why the (I assume) hardware doesn't do
> this itself and just document that it does a 32bit read is
> another matter - the logic will be much the same and I doubt
> anything modern is that pushed for space.
> 
> However rounding the length up to a multiple of 4 is buggy.
> If this is an ethernet chipset it must (honest) be able to
> send frames that don't end on a 4 byte boundary.
> So rounding up the length is very dubious.

I probably wrote that code. Probably something like 20 years ago at this 
point. I no longer have access to the actual hardware either.

But my recollection is that this ethernet chip had the ability to do 1, 
2 or 4 byte wide data transfers.

To be able to efficiently use I/O helpers like readsl()/writesl() on 
ARM, the host memory pointer had to be aligned to a 32-bit boundary 
because misaligned accesses were not supported by the hardware and 
therefore were very costly to perform in software with a bytewise 
approach. Remember that back then, the CPU clock was very close to the 
actual ethernet throughput and PIO was the only option.

This was made even worse by the fact that, on some boards, the hw 
designers didn't consider connecting the byte select signals as a 
worthwhile thing to do. That means only 32-bit wide access to the chip 
were possible.

So to work around this, the skb buffer address was rounded down, the 
length was rounded up, and 
the on-chip pointer was adjusted to refer to the actual data 
payload accordingly with the original length. Therefore the proposed 
patch is indeed wrong.

Just to say that, although the code might look suspicious, there was a 
reason for that and it did work correctly for a long long time at this 
point. Obviously those were only 32- bit systems (I really doubt those 
ethernet chips were ever used on 64-bit systems).


Nicolas
