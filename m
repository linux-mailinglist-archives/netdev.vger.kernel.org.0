Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C87E2FD657
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391655AbhATRCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:02:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:47811 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391051AbhATPuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 10:50:08 -0500
IronPort-SDR: rXXFTGtll4N2OzRjaFzg5qeD4nQGy4rehd8mNPodbwK56GynuS0lnJpVuVfzLnxVZwAJ6gq5JQ
 o+b4wslYT6Ig==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="176555131"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="176555131"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 07:49:34 -0800
IronPort-SDR: Cy4wyteDgb3xDy5nZdIBsMBAWem7rtiTfA7MlBvkEKezagzqnUbcYbWYuk8/IFID1JTrYFcUOr
 p8T18IWqvhXw==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384884012"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 07:49:28 -0800
Subject: Re: [PATCH bpf-next v2 1/8] xdp: restructure redirect actions
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-2-bjorn.topel@gmail.com> <87bldjeq1j.fsf@toke.dk>
 <996f1ff7-5891-fd4a-ee3e-fefd7e93879d@intel.com> <87mtx34q48.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0a7d1a0b-de2e-b973-a807-b9377bb89737@intel.com>
Date:   Wed, 20 Jan 2021 16:49:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <87mtx34q48.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 15:52, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@intel.com> writes:
> 
>> On 2021-01-20 13:44, Toke Høiland-Jørgensen wrote:
>>> Björn Töpel <bjorn.topel@gmail.com> writes:
>>>
>>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>>
>>>> The XDP_REDIRECT implementations for maps and non-maps are fairly
>>>> similar, but obviously need to take different code paths depending on
>>>> if the target is using a map or not. Today, the redirect targets for
>>>> XDP either uses a map, or is based on ifindex.
>>>>
>>>> Future commits will introduce yet another redirect target via the a
>>>> new helper, bpf_redirect_xsk(). To pave the way for that, we introduce
>>>> an explicit redirect type to bpf_redirect_info. This makes the code
>>>> easier to follow, and makes it easier to add new redirect targets.
>>>>
>>>> Further, using an explicit type in bpf_redirect_info has a slight
>>>> positive performance impact by avoiding a pointer indirection for the
>>>> map type lookup, and instead use the hot cacheline for
>>>> bpf_redirect_info.
>>>>
>>>> The bpf_redirect_info flags member is not used by XDP, and not
>>>> read/written any more. The map member is only written to when
>>>> required/used, and not unconditionally.
>>>
>>> I like the simplification. However, the handling of map clearing becomes
>>> a bit murky with this change:
>>>
>>> You're not changing anything in bpf_clear_redirect_map(), and you're
>>> removing most of the reads and writes of ri->map. Instead,
>>> bpf_xdp_redirect_map() will store the bpf_dtab_netdev pointer in
>>> ri->tgt_value, which xdp_do_redirect() will just read and use without
>>> checking. But if the map element (or the entire map) has been freed in
>>> the meantime that will be a dangling pointer. I *think* the RCU callback
>>> in dev_map_delete_elem() and the rcu_barrier() in dev_map_free()
>>> protects against this, but that is by no means obvious. So confirming
>>> this, and explaining it in a comment would be good.
>>>
>>
>> Yes, *most* of the READ_ONCE(ri->map) are removed, it's pretty much only
>> the bpf_redirect_map(), and as you write, the tracepoints.
>>
>> The content/element of the map is RCU protected, and actually even the
>> map will be around until the XDP processing is complete. Note the
>> synchronize_rcu() followed after all bpf_clear_redirect_map() calls.
>>
>> I'll try to make it clearer in the commit message! Thanks for pointing
>> that out!
>>
>>> Also, as far as I can tell after this, ri->map is only used for the
>>> tracepoint. So how about just storing the map ID and getting rid of the
>>> READ/WRITE_ONCE() entirely?
>>>
>>
>> ...and the bpf_redirect_map() helper. Don't you think the current
>> READ_ONCE(ri->map) scheme is more obvious/clear?
> 
> Yeah, after your patch we WRITE_ONCE() the pointer in
> bpf_redirect_map(), but the only place it is actually *read* is in the
> tracepoint. So the only purpose of bpf_clear_redirect_map() is to ensure
> that an invalid pointer is not read in the tracepoint function. Which
> seems a bit excessive when we could just store the map ID for direct use
> in the tracepoint and get rid of bpf_clear_redirect_map() entirely, no?
> 
> Besides, from a UX point of view, having the tracepoint display the map
> ID even if that map ID is no longer valid seems to me like it makes more
> sense than just displaying a map ID of 0 and leaving it up to the user
> to figure out that this is because the map was cleared. I mean, at the
> time the redirect was made, that *was* the map ID that was used...
>

Convinced! Getting rid of bpf_clear_redirect_map() would be good! I'll
take a stab at this for v3!


> Oh, and as you say due to the synchronize_rcu() call in dev_map_free() I
> think this whole discussion is superfluous anyway, since it can't
> actually happen that the map gets freed between the setting and reading
> of ri->map, no?
>

It can't be free'd but, ri->map can be cleared via
bpf_clear_redirect_map(). So, between the helper (setting) and the
tracepoint in xdp_do_redirect() it can be cleared (say if the XDP
program is swapped out, prior running xdp_do_redirect()).

Moving to the scheme you suggested, does make the discussion
superfluous. :-)


Thanks for the input!
Björn

