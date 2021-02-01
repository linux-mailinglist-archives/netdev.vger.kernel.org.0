Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB90B30A4A0
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhBAJuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:50:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:20631 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhBAJuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 04:50:21 -0500
IronPort-SDR: Tl1bamgcCMTNU7lROzqsctstPTGGFEuY/fx8i5IjlmSCzkbBkjU+6X5R7xGCro604PHjNJcbnH
 ruQgd3pXn4lw==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="179883124"
X-IronPort-AV: E=Sophos;i="5.79,392,1602572400"; 
   d="scan'208";a="179883124"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 01:49:29 -0800
IronPort-SDR: 6XJYhqYxgdQ9uioLE3T2aCHrMeWDndJGQy84SYYaURwe9eZ+zvRY12SbsS88YSZ529ebSM8nK7
 P8zEDdgNoQAQ==
X-IronPort-AV: E=Sophos;i="5.79,392,1602572400"; 
   d="scan'208";a="390833200"
Received: from edesmara-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.52.104])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 01:49:24 -0800
Subject: Re: [RFC PATCH bpf-next] bpf, xdp: per-map bpf_redirect_map functions
 for XDP
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, maximmi@nvidia.com, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com
References: <20210129153215.190888-1-bjorn.topel@gmail.com>
 <87im7fy9nc.fsf@toke.dk> <e77f259a-2381-1a6e-6e2c-f5afceb35c51@intel.com>
 <20210201103158.6afccf33@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <42f840ea-040f-a468-2108-ecf389cfdf93@intel.com>
Date:   Mon, 1 Feb 2021 10:49:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201103158.6afccf33@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-02-01 10:31, Jesper Dangaard Brouer wrote:
> On Mon, 1 Feb 2021 07:27:57 +0100
> Björn Töpel <bjorn.topel@intel.com> wrote:
> 
>> On 2021-01-29 17:45, Toke Høiland-Jørgensen wrote:
>>> Björn Töpel <bjorn.topel@gmail.com> writes:
>>>    
>>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>>
>>>> Currently the bpf_redirect_map() implementation dispatches to the
>>>> correct map-lookup function via a switch-statement. To avoid the
>>>> dispatching, this change adds one bpf_redirect_map() implementation per
>>>> map. Correct function is automatically selected by the BPF verifier.
>>>>
>>>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>>>> ---
>>>> Hi XDP-folks!
>>>>
>>>> This is another take on my bpf_redirect_xsk() patch [1]. I figured I
>>>> send it as an RFC for some early input. My plan is to include it as
>>>> part of the xdp_do_redirect() optimization of [1].
>>>
>>> Assuming the maintainers are OK with the special-casing in the verifier,
>>> this looks like a neat way to avoid the runtime overhead to me. The
>>> macro hackery is not the prettiest; I wonder if the same effect could be
>>> achieved by using inline functions? If not, at least a comment
>>> explaining the reasoning (and that the verifier will substitute the
>>> right function) might be nice? Mostly in relation to this bit:
>>>   
>>
>> Yeah, I agree with the macro part. I'll replace it with a
>> __always_inline function, instead.
>>
> 
> Yes, I also prefer __always_inline over the macro.
>

Ok! Good!

> 
>>>>    static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
>>>> -	.func           = bpf_xdp_redirect_map,
>>>> +	.func           = bpf_xdp_redirect_devmap,
>>>   
>>
>> I'll try to clean this up as well.
> 
> I do like the optimization of having the verifier call the right map
> func directly.  Could you please add a descriptive comment that
> describe this above "bpf_xdp_redirect_map_proto", that this is
> happening in fixup_bpf_calls and use get_xdp_redirect_func (what you
> define).  It is a cool trick, but people reading the code will have a
> hard time following.
>

Good idea, and makes sense! I'll make sure to do that!

Thanks for the input!


Cheers,
Björn


> Surprisingly people do read this code and tries to follow.  I've had
> discussions on the Cilium Slack channel, where people misunderstood how
> our bpf_fib_lookup() calls gets mapped to two different functions
> depending on context (SKB vs XDP).  And that remapping happens in the
> same file (net/core/filter.c).
> 
