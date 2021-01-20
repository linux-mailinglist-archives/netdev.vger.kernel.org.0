Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF322FD841
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 19:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404437AbhATS3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:29:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:27741 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404511AbhATSXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 13:23:22 -0500
IronPort-SDR: L9JpmDE4+luqpQRsxe+ManDEgp5OJ1nwHyTeaBh8ce4scZm7LFiOdiGAeVGSkcBN4DWDlabCF7
 eVSIasAySHtw==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="197885122"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="197885122"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 10:22:40 -0800
IronPort-SDR: Rw3uvpsEE+ay4sZqOKXOadvruh64iM56/DnqDGPdU28Gs3S1wE3k+hxHjoIhPSWf3oloWD2/2g
 6V2zBOubrIsQ==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384961621"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 10:22:34 -0800
Subject: Re: [PATCH bpf-next v2 4/8] xsk: register XDP sockets at bind(), and
 add new AF_XDP BPF helper
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-5-bjorn.topel@gmail.com> <878s8neprj.fsf@toke.dk>
 <46162f5f-5b3c-903b-8b8d-7c1afc74cb05@intel.com> <87k0s74q1a.fsf@toke.dk>
 <3c6feb0d-6a64-2251-3cac-c79cff29d85c@intel.com> <8735yv4iv1.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <ca8cbe21-f020-e5c0-5f09-19260e95839f@intel.com>
Date:   Wed, 20 Jan 2021 19:22:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <8735yv4iv1.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 18:29, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@intel.com> writes:
> 
>> On 2021-01-20 15:54, Toke Høiland-Jørgensen wrote:
>>> Björn Töpel <bjorn.topel@intel.com> writes:
>>>
>>>> On 2021-01-20 13:50, Toke Høiland-Jørgensen wrote:
>>>>> Björn Töpel <bjorn.topel@gmail.com> writes:
>>>>>
>>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>>> index c001766adcbc..bbc7d9a57262 100644
>>>>>> --- a/include/uapi/linux/bpf.h
>>>>>> +++ b/include/uapi/linux/bpf.h
>>>>>> @@ -3836,6 +3836,12 @@ union bpf_attr {
>>>>>>      *	Return
>>>>>>      *		A pointer to a struct socket on success or NULL if the file is
>>>>>>      *		not a socket.
>>>>>> + *
>>>>>> + * long bpf_redirect_xsk(struct xdp_buff *xdp_md, u64 action)
>>>>>> + *	Description
>>>>>> + *		Redirect to the registered AF_XDP socket.
>>>>>> + *	Return
>>>>>> + *		**XDP_REDIRECT** on success, otherwise the action parameter is returned.
>>>>>>      */
>>>>>
>>>>> I think it would be better to make the second argument a 'flags'
>>>>> argument and make values > XDP_TX invalid (like we do in
>>>>> bpf_xdp_redirect_map() now). By allowing any value as return you lose
>>>>> the ability to turn it into a flags argument later...
>>>>>
>>>>
>>>> Yes, but that adds a run-time check. I prefer this non-checked version,
>>>> even though it is a bit less futureproof.
>>>
>>> That...seems a bit short-sighted? :)
>>> Can you actually see a difference in your performance numbers?
>>>
>>
>> I would rather add an additional helper *if* we see the need for flags,
>> instead of paying for that upfront. For me, BPF is about being able to
>> specialize, and not having one call with tons of checks.
> 
> I get that, I'm just pushing back because omitting a 'flags' argument is
> literally among the most frequent reasons for having to replace a
> syscall (see e.g., [0]) instead of extending it. And yeah, I do realise
> that the performance implications are different for XDP than for
> syscalls, but maintainability of the API is also important; it's all a
> tradeoff. This will be the third redirect helper variant for XDP and I'd
> hate for the fourth one to have to be bpf_redirect_xsk_flags() because
> it did turn out to be needed...
> 
> (One potential concrete reason for this: I believe Magnus was talking
> about an API that would allow a BPF program to redirect a packet into
> more than one socket (cloning it in the process), or to redirect to a
> socket+another target. How would you do that with this new helper?)
> 
> [0] https://lwn.net/Articles/585415/
>

I have a bit of different view. One of the really nice parts about BPF
is exactly specialization. A user can tailor the kernel do a specific
thing. I *don't* see an issue with yet another helper, if that is needed
in the future. I think that is better than bloated helpers trying to
cope for all scenarios. I don't mean we should just add helpers all over
the place, but I do see more lightly on adding helpers, than adding
syscalls.

Elaborating a bit on this: many device drivers try to handle all the
things in the fast-path. I see BPF as one way forward to moving away
from that. Setup what you need, and only run what you currently need,
instead of the current "Is bleh on, then baz? Is this on, then that."

So, I would like to avoid "future proofing" the helpers, if that makes
sense. Use what you need. That's why BPF is so good (one of the things)!

As for bpf_redirect_xsk() it's a leaner version of bpf_redirect_map().
You want flags/shared sockets/...? Well go use bpf_redirect_map() and
XSKMAP. bpf_redirect_xsk() is not for you.

A lot of back-and-forth for *one* if-statement, but it's kind of a
design thing for me. ;-)


Björn


>> (Related; Going forward, the growing switch() for redirect targets in
>> xdp_do_redirect() is a concern for me...)
>>
>> And yes, even with all those fancy branch predictors, less instructions
>> is still less. :-) (It shows in my ubenchs.)
> 
> Right, I do agree that the run-time performance hit of checking the flag
> sucks (along with being hard to check for, cf. our parallel discussion
> about version checks). So ideally this would be fixed by having the
> verifier enforce the argument ranges instead; but if we merge this
> without the runtime check now we can't add that later without
> potentially breaking programs... :(
>
> -Toke
> 
