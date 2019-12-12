Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C709111D84F
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbfLLVLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:11:25 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:52170 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730806AbfLLVLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:11:25 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ifVjz-0086Dz-Ss; Thu, 12 Dec 2019 22:11:20 +0100
Message-ID: <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
Subject: Re: debugging TCP stalls on high-speed wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Date:   Thu, 12 Dec 2019 22:11:17 +0100
In-Reply-To: <99748db5-7898-534b-d407-ed819f07f939@gmail.com> (sfid-20191212_191119_097127_6CE454CE)
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
         <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
         <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
         <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
         (sfid-20191212_191119_097127_6CE454CE)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thanks for looking :)

> > I'm not sure how to do headers-only, but I guess -s100 will work.
> > 
> > https://johannes.sipsolutions.net/files/he-tcp.pcap.xz
> > 
> 
> Lack of GRO on receiver is probably what is killing performance,
> both for receiver (generating gazillions of acks) and sender
> (to process all these acks)
Yes, I'm aware of this, to some extent. And I'm not saying we should see
even close to 1800 Mbps like we have with UDP...

Mind you, the biggest thing that kills performance with many ACKs isn't
the load on the system - the sender system is only moderately loaded at
~20-25% of a single core with TSO, and around double that without TSO.
The thing that kills performance is eating up all the medium time with
small non-aggregated packets, due to the the half-duplex nature of WiFi.
I know you know, but in case somebody else is reading along :-)

But unless somehow you think processing the (many) ACKs on the sender
will cause it to stop transmitting, or something like that, I don't
think I should be seeing what I described earlier: we sometimes (have
to?) reclaim the entire transmit queue before TCP starts pushing data
again. That's less than 2MB split across at least two TCP streams, I
don't see why we should have to get to 0 (which takes about 7ms) until
more packets come in from TCP?

Or put another way - if I free say 400kB worth of SKBs, what could be
the reason we don't see more packets be sent out of the TCP stack within
the few ms or so? I guess I have to correlate this somehow with the ACKs
so I know how much data is outstanding for ACKs. (*)

The sk_pacing_shift is set to 7, btw, which should give us 8ms of
outstanding data. For now in this setup that's enough(**), and indeed
bumping the limit up (setting sk_pacing_shift to say 5) doesn't change
anything. So I think this part we actually solved - I get basically the
same performance and behaviour with two streams (needed due to GBit LAN
on the other side) as with 20 streams.


> I had a plan about enabling compressing ACK as I did for SACK
> in commit 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5d9f4262b7ea41ca9981cc790e37cca6e37c789e
> 
> But I have not done it yet.
> It is a pity because this would tremendously help wifi I am sure.

Nice :-)

But that is something the *receiver* would have to do.

The dirty secret here is that we're getting close to 1700 Mbps TCP with
Windows in place of Linux in the setup, with the same receiver on the
other end (which is actually a single Linux machine with two GBit
network connections to the AP). So if we had this I'm sure it'd increase
performance, but it still wouldn't explain why we're so much slower than
Windows :-)

Now, I'm certainly not saying that TCP behaviour is the only reason for
the difference, we already found an issue for example where due to a
small Windows driver bug some packet extension was always used, and the
AP is also buggy in that it needs the extension but didn't request it
... so the two bugs cancelled each other out and things worked well, but
our Linux driver believed the AP ... :) Certainly there can be more
things like that still, I just started on the TCP side and ran into the
queueing behaviour that I cannot explain.


In any case, I'll try to dig deeper into the TCP stack to understand the
reason for this transmit behaviour.

Thanks,
johannes


(*) Hmm. Now I have another idea. Maybe we have some kind of problem
with the medium access configuration, and we transmit all this data
without the AP having a chance to send back all the ACKs? Too bad I
can't put an air sniffer into the setup - it's a conductive setup.


(**) As another aside to this, the next generation HW after this will
have 256 frames in a block-ack, so that means instead of up to 64 (we
only use 63 for internal reasons) frames aggregated together we'll be
able to aggregate 256 (or maybe we again only 255?). Each one of those
frames may be an A-MSDU with ~11k content though (only 8k in the setup I
have here right now), which means we can get a LOT of data into a single
PPDU ... we'll probably have to bump the sk_pacing_shift to be able to
fill that with a single TCP stream, though since we run all our
performance numbers with many streams, maybe we should just leave it :)


