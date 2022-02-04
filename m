Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20DA4A9AAE
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359082AbiBDOIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:08:52 -0500
Received: from mail.toke.dk ([45.145.95.12]:52747 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231415AbiBDOIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 09:08:51 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1643983728; bh=zktssZMQDJ73AzssbeXUo5LVMZBopiTomeDktQdcLkY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=i+4JKHFh4qc+mDhvkRHB8FVjsM2A37uN2tmcNOivmP9JVYyHP/fogjMxbxk0PAoOf
         MFzCrRT/yAHOWI5KKrf4ktXYFsuv6T5tsHqk2UwgJ0rc1DQOYUmBjJw+RX8Ck0H2BY
         0gd+cdx6cIPB7YmI8EwT0GEgohQkrelyA2R9n/vGgORhc5YFEN5jdJ3hF9qCaVp0qd
         7Ivc3uVpNEicX9xq6dpEiu/vtYbrELL01MP5qieXZB3OTh4D9FB17Q1Shf1jhnZ+S8
         Kx+9Gzl9BwJnK+OD0YwHS0+sT1gsv8Uig0yfxwAMvMbHvl3eKa0g2UY9TFTLsU0xvQ
         SS8L4/9xlvz1A==
To:     John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        linux-kselftest@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN
 cookies in XDP
In-Reply-To: <61fc9483dfbe7_1d27c208e7@john.notmuch>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-3-maximmi@nvidia.com>
 <61efacc6980f4_274ca2083e@john.notmuch>
 <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
 <61f850bdf1b23_8597208f8@john.notmuch>
 <61f852711e15a_92e0208ac@john.notmuch>
 <9cef58de-1f84-5988-92f8-fcdd3c61f689@nvidia.com>
 <61fc9483dfbe7_1d27c208e7@john.notmuch>
Date:   Fri, 04 Feb 2022 15:08:48 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a6f6bu6n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Maxim Mikityanskiy wrote:
>> On 2022-01-31 23:19, John Fastabend wrote:
>> > John Fastabend wrote:
>> >> Maxim Mikityanskiy wrote:
>> >>> On 2022-01-25 09:54, John Fastabend wrote:
>> >>>> Maxim Mikityanskiy wrote:
>> >>>>> The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
>> >>>>> to generate SYN cookies in response to TCP SYN packets and to check
>> >>>>> those cookies upon receiving the first ACK packet (the final packet of
>> >>>>> the TCP handshake).
>> >>>>>
>> >>>>> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
>> >>>>> listening socket on the local machine, which allows to use them together
>> >>>>> with synproxy to accelerate SYN cookie generation.
>> >>>>>
>> >>>>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> >>>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> >>>>> ---
>> >>>>
>> >>>> [...]
>> >>>>
>> >>>>> +
>> >>>>> +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
>> >>>>> +	   struct tcphdr *, th, u32, th_len)
>> >>>>> +{
>> >>>>> +#ifdef CONFIG_SYN_COOKIES
>> >>>>> +	u32 cookie;
>> >>>>> +	int ret;
>> >>>>> +
>> >>>>> +	if (unlikely(th_len < sizeof(*th)))
>> >>>>> +		return -EINVAL;
>> >>>>> +
>> >>>>> +	if (!th->ack || th->rst || th->syn)
>> >>>>> +		return -EINVAL;
>> >>>>> +
>> >>>>> +	if (unlikely(iph_len < sizeof(struct iphdr)))
>> >>>>> +		return -EINVAL;
>> >>>>> +
>> >>>>> +	cookie = ntohl(th->ack_seq) - 1;
>> >>>>> +
>> >>>>> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
>> >>>>> +	 * same offset so we can cast to the shorter header (struct iphdr).
>> >>>>> +	 */
>> >>>>> +	switch (((struct iphdr *)iph)->version) {
>> >>>>> +	case 4:
>> >>>>
>> >>>> Did you consider just exposing __cookie_v4_check() and __cookie_v6_check()?
>> >>>
>> >>> No, I didn't, I just implemented it consistently with
>> >>> bpf_tcp_check_syncookie, but let's consider it.
>> >>>
>> >>> I can't just pass a pointer from BPF without passing the size, so I
>> >>> would need some wrappers around __cookie_v{4,6}_check anyway. The checks
>> >>> for th_len and iph_len would have to stay in the helpers. The check for
>> >>> TCP flags (ACK, !RST, !SYN) could be either in the helper or in BPF. The
>> >>> switch would obviously be gone.
>> >>
>> >> I'm not sure you would need the len checks in helper, they provide
>> >> some guarantees I guess, but the void * is just memory I don't see
>> >> any checks on its size. It could be the last byte of a value for
>> >> example?
>> 
>> The verifier makes sure that the packet pointer and the size come 
>> together in function parameters (see check_arg_pair_ok). It also makes 
>> sure that the memory region defined by these two parameters is valid, 
>> i.e. in our case it belongs to packet data.
>> 
>> Now that the helper got a valid memory region, its length is still 
>> arbitrary. The helper has to check it's big enough to contain a TCP 
>> header, before trying to access its fields. Hence the checks in the helper.
>> 
>> > I suspect we need to add verifier checks here anyways to ensure we don't
>> > walk off the end of a value unless something else is ensuring the iph
>> > is inside a valid memory block.
>> 
>> The verifier ensures that the [iph; iph+iph_len) is valid memory, but 
>> the helper still has to check that struct iphdr fits into this region. 
>> Otherwise iph_len could be too small, and the helper would access memory 
>> outside of the valid region.
>
> Thanks for the details this all makes sense. See response to
> other mail about adding new types. Replied to the wrong email
> but I think the context is not lost.

Keeping my reply here in an attempt to de-fork :)

>> >>>
>> >>> The bottom line is that it would be the same code, but without the
>> >>> switch, and repeated twice. What benefit do you see in this approach?
>> >>
>> >> The only benefit would be to shave some instructions off the program.
>> >> XDP is about performance so I figure we shouldn't be adding arbitrary
>> >> stuff here. OTOH you're already jumping into a helper so it might
>> >> not matter at all.
>> >>
>> >>>   From my side, I only see the ability to drop one branch at the expense
>> >>> of duplicating the code above the switch (th_len and iph_len checks).
>> >>
>> >> Just not sure you need the checks either, can you just assume the user
>> >> gives good data?
>> 
>> No, since the BPF program would be able to trick the kernel into reading 
>> from an invalid location (see the explanation above).
>> 
>> >>>
>> >>>> My code at least has already run the code above before it would ever call
>> >>>> this helper so all the other bits are duplicate.
>> >>>
>> >>> Sorry, I didn't quite understand this part. What "your code" are you
>> >>> referring to?
>> >>
>> >> Just that the XDP code I maintain has a if ipv4 {...} else ipv6{...}
>> >> structure
>> 
>> Same for my code (see the last patch in the series).
>> 
>> Splitting into two helpers would allow to drop the extra switch in the 
>> helper, however:
>> 
>> 1. The code will be duplicated for the checks.
>
> See response wrt PTR_TO_IP, PTR_TO_TCP types.

So about that (quoting some context from your other email):

> We could have some new mem types, PTR_TO_IPV4, PTR_TO_IPv6, and PTR_TO_TCP.
> Then we simplify the helper signatures to just,
>
>   bpf_tcp_raw_check_syncookie_v4(iph, tcph);
>   bpf_tcp_raw_check_syncookie_v6(iph, tcph);
>
> And the verifier "knows" what a v4/v6 header is and does the mem
> check at verification time instead of run time.

I think this could probably be achieved with PTR_TO_BTF arguments to the
helper (if we define appropriate struct types that the program can use
for each header type)?

It doesn't really guard against pointing into the wrong bit of the
packet (or somewhere else entirely), so the header can still contain
garbage, but at least the len check should be handled automatically with
PTR_TO_BTF, and we avoid the need to define a whole bunch of new
PTR_TO_* types...

>> 2. It won't be consistent with bpf_tcp_check_syncookie (and all other 
>> existing helpers - as far as I see, there is no split for IPv4/IPv6).
>
> This does seem useful to me.

If it's consistency we're after we could split the others as well? I
guess the main drawback here is code bloat (can't inline the functions
as they need to be available for BPF_CALL, so we either get duplicates
or an additional function call overhead for the old helper if it just
calls the new ones).

>> 3. It's easier to misuse, e.g., pass an IPv6 header to the IPv4 helper. 
>> This point is controversial, since it shouldn't pose any additional 
>> security threat, but in my opinion, it's better to be foolproof. That 
>> means, I'd add the IP version check even to the separate helpers, which 
>> defeats the purpose of separating them.
>
> Not really convinced that we need to guard against misuse. This is
> down in XDP space its not a place we should be adding extra insns
> to stop developers from hurting themselves, just as a general
> rule.

Yeah, I think in general for XDP, if you pass garbage data to the
helpers to get to keep the pieces when it breaks. We need to make sure
the *kernel* doesn't misbehave (i.e., no crashing, and no invalid state
being created inside the kernel), but it's up to the XDP program author
to use the API correctly...

>> Given these points, I'd prefer to keep it a single helper. However, if 
>> you have strong objections, I can split it.
>
> I think (2) is the strongest argument combined with the call is
> heavy operation and saving some cycles maybe isn't terribly
> important, but its XDP land again and insns matter IMO. I'm on
> the fence maybe others have opinions?

It's not a very strong opinion, but I think in general, optimising for
performance in XDP is the right thing to do. That's kinda what it's for :)

-Toke
