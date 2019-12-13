Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBA011DF19
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 09:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLMIIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 03:08:17 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:42932 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfLMIIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 03:08:15 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iffzf-009Qfq-NZ; Fri, 13 Dec 2019 09:08:11 +0100
Message-ID: <f74b46e7554d9798ab1ba6c06bb67042a4fa9137.camel@sipsolutions.net>
Subject: Re: debugging TCP stalls on high-speed wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>
Date:   Fri, 13 Dec 2019 09:08:10 +0100
In-Reply-To: <CAA93jw6b6n0jm_BC6DbccEU3uN9zXcfjqnZMNm=vFjLVqYKyNA@mail.gmail.com> (sfid-20191213_004245_370450_D3825B7B)
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
         <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
         <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
         <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
         <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
         <CAA93jw6b6n0jm_BC6DbccEU3uN9zXcfjqnZMNm=vFjLVqYKyNA@mail.gmail.com>
         (sfid-20191213_004245_370450_D3825B7B)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-12-12 at 15:42 -0800, Dave Taht wrote:

> If you captured the air you'd probably see the sender winning the
> election for airtime 2 or more times in a row,
> it's random and oft dependent on on a variety of factors.

I'm going to try to capture more details - I can probably extract this
out of the firmware but it's more effort.

> Most Wifi is *not* "half" duplex, which implies it ping pongs between
> send and receive.

That's an interesting definition of "half duplex" which doesn't really
match anything that I've seen used or in the literature? What you're
describing sounds more like some sort of "half duplex with token-based
flow control" or something like that to me ...

> > But unless somehow you think processing the (many) ACKs on the sender
> > will cause it to stop transmitting, or something like that, I don't
> > think I should be seeing what I described earlier: we sometimes (have
> > to?) reclaim the entire transmit queue before TCP starts pushing data
> > again. That's less than 2MB split across at least two TCP streams, I
> > don't see why we should have to get to 0 (which takes about 7ms) until
> > more packets come in from TCP?
> 
> Perhaps having a budget for ack processing within a 1ms window?

What do you mean? There's such a budget? What kind of budget? I have
plenty of CPU time left, as far as I can tell.

> It would be interesting to repeat this test in ht20 mode,

Why? HT20 is far slower, what would be the advantage. In my experience I
don't hit this until I get to HE80.

> flent --socket-stats --step-size=.04 --te=upload_streams=2 -t
> whatever_variant_of_test tcp_nup
> 
> That will capture some of the tcp stats for you.

I guses I can try, but the upload_streams=2 won't actually help - I need
to run towards two different IP addresses - remember that I'm otherwise
limited by a GBit LAN link on the other side right now.

> > But that is something the *receiver* would have to do.
> 
> Well it is certainly feasible to thin acks on the driver as we did in
> cake.

I really don't think it would help in my case, either the ACKs are the
problem (which I doubt) and then they're the problem on the air, or
they're not the problem since I have plenty of CPU time to waste on them
...

> One thing comcast inadvertently does to most flows is remark them cs1,
> which tosses big data into the bk queue and acks into the be queue. It
> actually helps sometimes.

I thought about doing this but if I make my flows BK it halves my
throughput (perhaps due to the more then double AIFSN?)

> > (**) As another aside to this, the next generation HW after this will
> > have 256 frames in a block-ack, so that means instead of up to 64 (we
> > only use 63 for internal reasons) frames aggregated together we'll be
> > able to aggregate 256 (or maybe we again only 255?).
> 
> My fervent wish is to somehow be able to mark every frame we can as not
> needing a retransmit in future standards.

This can be done since ... oh I don't know, probably 2005 with the
802.11e amendment? Not sure off the top of my head how it interacts with
A-MPDUs though, and probably has bugs if you do that.

> I've lost track of what ax
> can do. ? And for block ack retries
> to give up far sooner.

You can do that too, it's just a local configuration how much you try
each packet. If you give up you leave a hole in the reorder window, but
if you start sending packets that are further ahead then the window, the
old ones will (have to be) released regardless.

> you can safely drop all but the last three acks in a flow, and the
> txop itself provides
> a suitable clock.

Now that's more tricky because once you stick the packets into the
hardware queue you likely have to decide whether or not they're
important.

I can probably think of ways of working around that (similar to the
table-based rate scaling we use), but it's tricky.

> And, ya know, releasing packets ooo doesn't hurt as much as it used
> to, with rack.

:)
That I think is not currently possible with A-MPDUs. It'd also still
have to be opt-in per frame since you can't really do that for anything
but TCP (and probably QUIC? Maybe SCTP?)

> Just wearing my usual hat, I would prefer to optimize for service
> time, not bandwidth, in the future,
> using smaller txops with this more data in them, than the biggest
> txops possible.

Patience. We're getting there now. HE will allow the AP to schedule
everything, and then you don't need TXOPs anymore. The problem is that
winning a TXOP is costly, so you *need* to put as much as possible into
it for good performance.

With HE and the AP scheduling, you win some, you lose some. The client
will lose the ability to actually make any decisions about its transmit
rate and things like that, but the AP can schedule & poll the clients
better without all the overhead.

> If you constrain your max txop to 2ms in this test, you will see tcp
> in slow start ramp up faster,
> and the ap scale to way more devices, with way less jitter and
> retries. Most flows never get out of slowstart.

I'm running a client ... you're forgetting that there's something else
that's actually talking to the AP you're thinking of :-)

> > . we'll probably have to bump the sk_pacing_shift to be able to
> > fill that with a single TCP stream, though since we run all our
> > performance numbers with many streams, maybe we should just leave it :)
> 
> Please. Optimizing for single flow performance is an academic's game.

Same here, kinda.

johannes

