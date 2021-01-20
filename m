Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9722FD6EC
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390154AbhATOHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:07:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:29664 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390142AbhATNlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 08:41:02 -0500
IronPort-SDR: 5UASwqYBA9HVYSZGvY+SpQO5upsCij8ITaS2f0GsD6GAc21CQT4HrPnz/o9JMAAPEbDYiOBYmq
 oEWAaIQuDwHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="243174738"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="243174738"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 05:40:21 -0800
IronPort-SDR: RHQWWJnEWBlPQEehNKqeTuhA5Kz8UaTA4D+WhDobTFUhO1iwg21Y3CTOaG4B2p98otlW39NktQ
 mjBLltqGsaBQ==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384838084"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 05:40:16 -0800
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
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <996f1ff7-5891-fd4a-ee3e-fefd7e93879d@intel.com>
Date:   Wed, 20 Jan 2021 14:40:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <87bldjeq1j.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-01-20 13:44, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The XDP_REDIRECT implementations for maps and non-maps are fairly
>> similar, but obviously need to take different code paths depending on
>> if the target is using a map or not. Today, the redirect targets for
>> XDP either uses a map, or is based on ifindex.
>>
>> Future commits will introduce yet another redirect target via the a
>> new helper, bpf_redirect_xsk(). To pave the way for that, we introduce
>> an explicit redirect type to bpf_redirect_info. This makes the code
>> easier to follow, and makes it easier to add new redirect targets.
>>
>> Further, using an explicit type in bpf_redirect_info has a slight
>> positive performance impact by avoiding a pointer indirection for the
>> map type lookup, and instead use the hot cacheline for
>> bpf_redirect_info.
>>
>> The bpf_redirect_info flags member is not used by XDP, and not
>> read/written any more. The map member is only written to when
>> required/used, and not unconditionally.
> 
> I like the simplification. However, the handling of map clearing becomes
> a bit murky with this change:
> 
> You're not changing anything in bpf_clear_redirect_map(), and you're
> removing most of the reads and writes of ri->map. Instead,
> bpf_xdp_redirect_map() will store the bpf_dtab_netdev pointer in
> ri->tgt_value, which xdp_do_redirect() will just read and use without
> checking. But if the map element (or the entire map) has been freed in
> the meantime that will be a dangling pointer. I *think* the RCU callback
> in dev_map_delete_elem() and the rcu_barrier() in dev_map_free()
> protects against this, but that is by no means obvious. So confirming
> this, and explaining it in a comment would be good.
>

Yes, *most* of the READ_ONCE(ri->map) are removed, it's pretty much only 
the bpf_redirect_map(), and as you write, the tracepoints.

The content/element of the map is RCU protected, and actually even the
map will be around until the XDP processing is complete. Note the
synchronize_rcu() followed after all bpf_clear_redirect_map() calls.

I'll try to make it clearer in the commit message! Thanks for pointing 
that out!

> Also, as far as I can tell after this, ri->map is only used for the
> tracepoint. So how about just storing the map ID and getting rid of the
> READ/WRITE_ONCE() entirely?
>

...and the bpf_redirect_map() helper. Don't you think the current
READ_ONCE(ri->map) scheme is more obvious/clear?


> (Oh, and related to this I think this patch set will conflict with
> Hangbin's multi-redirect series, so maybe you two ought to coordinate? :))
>

Yeah, good idea! I would guess Hangbin's would go in before this, so I
would need to adapt.


Thanks for taking of look at the series, Toke! Much appreciated!


Björn

