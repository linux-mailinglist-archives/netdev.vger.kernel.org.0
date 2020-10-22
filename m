Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEA1295EF8
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 14:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898800AbgJVMsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 08:48:03 -0400
Received: from pipe.dmesg.gr ([185.6.77.131]:46192 "EHLO pipe.dmesg.gr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898795AbgJVMsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 08:48:01 -0400
Received: from marvin.dmesg.gr (unknown [185.6.77.97])
        by pipe.dmesg.gr (Postfix) with ESMTPSA id 3678AA76D0;
        Thu, 22 Oct 2020 15:47:54 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=dmesg.gr; s=2013;
        t=1603370874; bh=TOfzN1Mw7TXciE15VadRTuo/tE+/TLgUR6tld7DZd18=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hfE8eVwSiGbw0m7bFiPiaQa3N1r4P6Shf0hZT8Ot0MdROlyoms8XK77uGQlFaw3Hp
         We9Cw7Xx0GHqZJNxkrWNE7HsLe0i5cDxdyDi0sD6aYLrZeALNmL5Fbvc/3YHmZof1E
         DJUlmQ57eSfbKZ4vwGRSBQA6vu/0uM9gwZAUbXRKonaeDh5oTzKV64749woix5o0cw
         Cnq7Zbngl82uAcITSwJ2DWWVLMh+qkfbFFbn7eOesaqz2oi3XbAF/aCXkQ5aGF8r7U
         lHjofRSl6M7asHWuWrD3ajckbGLsmtcRb+D8951MWPm02u7KR5AbfBBojlLYg3u+2K
         83Slg/MxERyFQ==
Received: by marvin.dmesg.gr (Postfix, from userid 1000)
        id ACDCE223090; Thu, 22 Oct 2020 15:47:53 +0300 (EEST)
From:   Apollon Oikonomopoulos <apoikos@dmesg.gr>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Yuchung Cheng <ycheng@google.com>, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
In-Reply-To: <878sc63y8j.fsf@marvin.dmesg.gr>
References: <87eelz4abk.fsf@marvin.dmesg.gr> <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com> <CAK6E8=fCwjP47DvSj4YQQ6xn25bVBN_1mFtrBwOJPYU6jXVcgQ@mail.gmail.com> <87blh33zr7.fsf@marvin.dmesg.gr> <CADVnQym2cJGRP8JnRAdzHfWEeEbZrmXd3eXD-nFP6pRNK7beWw@mail.gmail.com> <878sc63y8j.fsf@marvin.dmesg.gr>
Date:   Thu, 22 Oct 2020 15:47:53 +0300
Message-ID: <87eelqs9za.fsf@marvin.dmesg.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apollon Oikonomopoulos <apoikos@dmesg.gr> writes:
> We are now running the patched kernel on the machines involved. I want
> to give it some time just to be sure, so I'll get back to you by
> Thursday if everything goes well.

It has been almost a week and we have had zero hangs in 60 rsync runs,
so I guess we can call it fixed. At the same time we didn't notice any
ill side-effects. In the unlikely event it hangs again, I will let you
know.

I spent quite some time pondering this issue and to be honest it
troubles me that it seems to have been there for far too long for nobody
else to have noticed. The only reasonable explanation I can come up with
is that (please comment/correct me if I'm wrong):

 1. It will not be triggered by most L7 protocols. In "synchronous"
    request-response protocols such as HTTP, usually each side will
    consume all available data before sending. In this case, even if
    snd_wl1 wraps around, the bulk receiver is left with a non-zero
    window and is still able to send out data, causing the next
    acknowledgment to update the window and adjust snd_wl1. Also I
    cannot think of any asynchronous protocol apart from rsync where the
    server sends out multi-GB responses without checking for incoming
    data in the process.

 2. Regardless of the application protocol, the receiver must remain
    long enough (for at least 2GB) with a zero send window in the fast
    path to cause a wraparound =E2=80=94 but not too long for after(ack_seq,
    snd_wl1) to be true again. In practice this means that header
    prediction should not fail (not even once!) and we should never run
    out of receive space, as these conditions would send us to the slow
    path and call tcp_ack(). I'd argue this is likely to happen only
    with stable, long-running, low- or moderately-paced TCP connections
    in local networks where packet loss is minimal (although most of the
    time things move around as fast as they can in a local network). At
    this point I wonder if the userspace rate-limiting we enabled on
    rsync actually did more harm=E2=80=A6

Finally, even if someone hits this, any application caring about network
timeouts will either fail or reconnect, making it appear as a "random
network glitch" and leaving no traces to debug behind. And in the
unlikely event that your application lingers forever in the persist
state, it certainly takes a fair amount of annoyance to sidestep your
ignorance, decide that this might indeed be a kernel bug, and go after
it :)

Thanks again for the fast response!

Best,
Apollon

P.S: I wonder if it would make sense to expose snd_una and snd_wl1
     in struct tcp_info to ease debugging.
