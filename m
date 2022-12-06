Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB25644480
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiLFN0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiLFN0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:26:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEEB1AF26;
        Tue,  6 Dec 2022 05:26:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B234B81A19;
        Tue,  6 Dec 2022 13:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD112C433D6;
        Tue,  6 Dec 2022 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670333202;
        bh=PcKOxuA0F9qMRIEIAfbWnBs4yrfRxfF69kZ501yYJ6k=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Lr7w0LFmSgs7qGhQdQNn21s8pwOoa13xFjdER4w4qqW4RCyQfWtspTCi+wH4oEdS6
         JL5cybmAys92B1Pr/mBZ2hmHbdNb00LSCpc2uu68MmeCGPhUQxNc0eFcTQpC7Y3PKv
         IJ3xu4SNgcLWZ1scGEgK+FKgz4kzx4J3704Gc/ByV91RHr3+0UNQG1vRqwe6bIm99f
         B2yXv2RzeyGnMYbN5VIMliigYniBR2TbqSp16hVPIG6C9UoLbIJjcuGF4U5dwupS39
         zbOhdMTZBvMS9Mfx8/77Z7ouO7pAG6HrmTXfiBy29QVxPcCf081gFJuY45JZwv8R8W
         RuuN0hJMaOQUA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D32C382E38E; Tue,  6 Dec 2022 14:26:38 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [PATCH] bpf: call get_random_u32() for random integers
In-Reply-To: <CAHmME9poicgpHhXJ1ieWbDTFBu=ApSFaQKShhHezDmA0A5ajKQ@mail.gmail.com>
References: <20221205181534.612702-1-Jason@zx2c4.com>
 <730fd355-ad86-a8fa-6583-df23d39e0c23@iogearbox.net>
 <Y451ENAK7BQQDJc/@zx2c4.com> <87lenku265.fsf@toke.dk>
 <CAHmME9poicgpHhXJ1ieWbDTFBu=ApSFaQKShhHezDmA0A5ajKQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 06 Dec 2022 14:26:38 +0100
Message-ID: <87iliou0hd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hi Toke,
>
> On Tue, Dec 6, 2022 at 1:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@ker=
nel.org> wrote:
>>
>> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>>
>> > On Mon, Dec 05, 2022 at 11:21:51PM +0100, Daniel Borkmann wrote:
>> >> On 12/5/22 7:15 PM, Jason A. Donenfeld wrote:
>> >> > Since BPF's bpf_user_rnd_u32() was introduced, there have been three
>> >> > significant developments in the RNG: 1) get_random_u32() returns the
>> >> > same types of bytes as /dev/urandom, eliminating the distinction be=
tween
>> >> > "kernel random bytes" and "userspace random bytes", 2) get_random_u=
32()
>> >> > operates mostly locklessly over percpu state, 3) get_random_u32() h=
as
>> >> > become quite fast.
>> >>
>> >> Wrt "quite fast", do you have a comparison between the two? Asking as=
 its
>> >> often used in networking worst case on per packet basis (e.g. via XDP=
), would
>> >> be useful to state concrete numbers for the two on a given machine.
>> >
>> > Median of 25 cycles vs median of 38, on my Tiger Lake machine. So a
>> > little slower, but too small of a difference to matter.
>>
>> Assuming a 3Ghz CPU clock (so 3 cycles per nanosecond), that's an
>> additional overhead of ~4.3 ns. When processing 10 Gbps at line rate
>> with small packets, the per-packet processing budget is 67.2 ns, so
>> those extra 4.3 ns will eat up ~6.4% of the budget.
>>
>> So in other words, "too small a difference to matter" is definitely not
>> true in general. It really depends on the use case; if someone is using
>> this to, say, draw per-packet random numbers to compute a drop frequency
>> on ingress, that extra processing time will most likely result in a
>> quite measurable drop in performance.
>
> Huh, neat calculation, I'll keep that method in mind.

Yeah, I find that thinking in "time budget per packet" helps a lot! For
completeness, the 67.2 ns comes from 10 Gbps / 84 bytes (that's 64-byte
packets + 20 bytes of preamble and inter-packet gap), which is 14.8
Mpps, or 67.2 ns/pkt.

> Alright, sorry for the noise here. I'll check back in if I ever manage
> to eliminate that performance gap.

One approach that we use generally for XDP (and which may or may not
help for this case) is that we try to amortise as much fixed cost as we
can over a batch of packets. Because XDP processing always happens in
the NAPI receive poll loop, we have a natural batching mechanism, and we
know that for that whole loop we'll keep running on the same CPU.

So for instance, if there's a large fixed component of the overhead of
get_random_u32(), we could have bpf_user_rnd_u32() populate a larger
per-CPU buffer and then just emit u32 chunks of that as long as we're
still in the same NAPI loop as the first call. Or something to that
effect. Not sure if this makes sense for this use case, but figured I'd
throw the idea out there :)

-Toke
