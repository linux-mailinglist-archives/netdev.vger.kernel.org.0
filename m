Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DAD2AE531
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbgKKA70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:59:26 -0500
Received: from smtp1.emailarray.com ([65.39.216.14]:51794 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730894AbgKKA70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:59:26 -0500
Received: (qmail 33220 invoked by uid 89); 11 Nov 2020 00:59:24 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 11 Nov 2020 00:59:24 -0000
Date:   Tue, 10 Nov 2020 16:59:22 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Victor Stewart <v@nametag.social>
Cc:     netdev@vger.kernel.org
Subject: Re: MSG_ZEROCOPY_FIXED
Message-ID: <20201111005922.h55aiqcs325bvhk7@bsd-mbp.dhcp.thefacebook.com>
References: <CAM1kxwjkJndycnWWbzBFyAap9=y13DynF=SMijL1=3SPpHbvdw@mail.gmail.com>
 <20201111000902.zs4zcxlq5ija7swe@bsd-mbp.dhcp.thefacebook.com>
 <CAM1kxwh9+fu1O=rG9=HuEnp8c0E2_xvyZpTq=ehX+r5pmNiMLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM1kxwh9+fu1O=rG9=HuEnp8c0E2_xvyZpTq=ehX+r5pmNiMLg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 12:20:22AM +0000, Victor Stewart wrote:
> On Wed, Nov 11, 2020 at 12:09 AM Jonathan Lemon
> <jonathan.lemon@gmail.com> wrote:
> >
> > On Sun, Nov 08, 2020 at 05:04:41PM +0000, Victor Stewart wrote:
> > > hi all,
> > >
> > > i'm seeking input / comment on the idea of implementing full fledged
> > > zerocopy UDP networking that uses persistent buffers allocated in
> > > userspace... before I go off on a solo tangent with my first patches
> > > lol.
> > >
> > > i'm sure there's been lots of thought/discussion on this before. of
> > > course Willem added MSG_ZEROCOPY on the send path (pin buffers on
> > > demand / per send). and something similar to what I speak of exists
> > > with TCP_ZEROCOPY_RECEIVE.
> > >
> > > i envision something like a new flag like MSG_ZEROCOPY_FIXED that
> > > "does the right thing" in the send vs recv paths.
> >
> > See the netgpu patches that I posted earlier; these will handle
> > protocol independent zerocopy sends/receives.  I do have a working
> > UDP receive implementation which will be posted with an updated
> > patchset.
> 
> amazing i'll check it out. thanks.
> 
> does your udp zerocopy receive use mmap-ed buffers then vm_insert_pfn
> / remap_pfn_range to remap the physical pages of the received payload
> into the memory submitted by recvmsg for reception?

The application mmaps buffers, which are then pinned into the kernel.
The NIC receives directly into the buffers and then notifies the application.

For completions, the mechanism that I prefer is having one of the
sends tagged with SO_NOTIFY message.  Then a completion notification is 
generated when the buffer corresponding to the NOTIFY is released by
the protocol stack.

The notifiations could be posted as an io_uring CQE.  (work TBD)

> https://lore.kernel.org/io-uring/acc66238-0d27-cd22-dac4-928777a8efbc@gmail.com/T/#t
> 
> ^^ and check the thread from today on the io_uring mailing list going
> into the mechanics of zerocopy sendmsg i have in mind.
> 
> (TLDR; i think it should be io_uring "only" so that we can collapse it
> into a single completion event, aka when the NIC ACKs the
> transmission. and exploiting the asynchrony of io_uring is the only
> way to do this? so you'd submit your sendmsg operation to io_uring and
> instead of receiving a completion event when the send gets enqueued,
> you'd only get it upon failure or NIC ACK).

I think it's likely better to have two completions:
  "this buffer has been submitted", and 
  "this buffer is released by the protocol".

This simplifies handling of errors, cancellations, and short writes.
-- 
Jonathan
