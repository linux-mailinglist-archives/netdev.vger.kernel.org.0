Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C67746FE7C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 11:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhLJKM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:12:56 -0500
Received: from www62.your-server.de ([213.133.104.62]:44984 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240070AbhLJKMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:12:02 -0500
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mvcpE-000CX1-Eg; Fri, 10 Dec 2021 11:08:24 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mvcpE-0008zp-6o; Fri, 10 Dec 2021 11:08:24 +0100
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
 <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
 <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
 <1ef23d3b-fe49-213b-6b60-127393b24e84@iogearbox.net>
 <20211208221924.v4gqpkzzrbhgi2xe@kafai-mbp.dhcp.thefacebook.com>
 <b7989f8a-3f04-5186-a9f1-50f101575cfa@iogearbox.net>
 <20211210013720.mp7avsr63i4nttr3@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fb490760-160f-6c39-7d17-2bde4297f4c7@iogearbox.net>
Date:   Fri, 10 Dec 2021 11:08:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211210013720.mp7avsr63i4nttr3@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26378/Thu Dec  9 10:21:16 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/21 2:37 AM, Martin KaFai Lau wrote:
> On Thu, Dec 09, 2021 at 01:58:52PM +0100, Daniel Borkmann wrote:
>>> Daniel, do you have suggestion on where to temporarily store
>>> the forwarded EDT so that the bpf@ingress can access?
>>
>> Hm, was thinking maybe moving skb->skb_mstamp_ns into the shared info as
>> in skb_hwtstamps(skb)->skb_mstamp_ns could work. In other words, as a union
>> with hwtstamp to not bloat it further. And TCP stack as well as everything
>> else (like sch_fq) could switch to it natively (hwtstamp might only be used
>> on RX or TX completion from driver side if I'm not mistaken).
>>
>> But then while this would solve the netns transfer, we would run into the
>> /same/ issue again when implementing a hairpinning LB where we loop from RX
>> to TX given this would have to be cleared somewhere again if driver populates
>> hwtstamp, so not really feasible and bloating shared info with a second
>> tstamp would bump it by one cacheline. :(
> If the edt is set at skb_hwtstamps,
> skb->tstamp probably needs to be re-populated for the bpf@tc-egress
> but should be minor since there is a skb_at_tc_ingress() test.
> 
> It seems fq does not need shinfo now, so that will be an extra cacheline to
> bring... hmm

Right. :/ The other thing I was wondering (but haven't looked enough into the
code yet whether feasible or not) ... maybe skb_hwtstamps(skb)->hwtstamp could
be changed to cover both hw & sw ingress tstamp (meaning, if nic doesn't provide
it, then we fall back to the sw one and __net_timestamp() stores it there, too)
whereas skb->tstamp would always concern an egress tstamp. However, it might
result in quite a lot of churn given the wider-spread use, but more importantly,
performance implications are also not quite clear as you mentioned above wrt
extra cache miss.

>> A cleaner BUT still non-generic solution compared to the previous diff I could
>> think of might be the below. So no change in behavior in general, but if the
>> bpf@ingress@veth@host needs to access the original tstamp, it could do so
>> via existing mapping we already have in BPF, and then it could transfer it
>> for all or certain traffic (up to the prog) via BPF code setting ...
>>
>>    skb->tstamp = skb->hwtstamp
>>
>> ... and do the redirect from there to the phys dev with BPF_F_KEEP_TSTAMP
>> flag. Minimal intrusive, but unfortunately only accessible for BPF. Maybe use
>> of skb_hwtstamps(skb)->nststamp could be extended though (?)
> I like the idea of the possibility in temporarily storing a future mono EDT
> in skb_shared_hwtstamps.
> 
> It may open up some possibilities.  Not sure how that may look like yet
> but I will try to develop on this.

Ok! One thing I noticed later in the diff, that for the ingressing direction
aka phys -> host veth -> netns veth, we also do the skb_xfer_tstamp() switch
and might override the one stored from driver with potentially the one from
__net_timestamp(), but maybe for netns'es that's acceptable (perhaps a test
for existing skb->sk owner before skb_xfer_tstamp() could do the trick..).

> I may have to separate the fwd-edt problem from __sk_buff->tstamp accessibility
> @ingress to keep it simple first.
> will try to make it generic also before scaling back to a bpf-specific solution.

Yeah sounds good, if we can solve it generically, even better!

> Thanks for the code and the idea !
Thanks,
Daniel
