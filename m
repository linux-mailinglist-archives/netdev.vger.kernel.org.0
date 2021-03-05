Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D79432F0E7
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 18:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhCERMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 12:12:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:15154 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231515AbhCERLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 12:11:52 -0500
IronPort-SDR: k4KPxxvu/IeXe3n3v/MZ7dMlD3unfKOtxckP/qWGe9dsDzW8TBe8SWZya26u5wK6vZZt9+eqdv
 eZCA+UDVD6Ow==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="174799048"
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="174799048"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 09:11:51 -0800
IronPort-SDR: QnYQ33vzpaI8JxA7ylLM2g1KNooLV/OXI5KPbzeB0eNctUkvmCMkhKBXe7Dy9UgKAw1BT4hIEk
 avUXwZ83cZGA==
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="408399582"
Received: from luetzenk-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.43.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 09:11:46 -0800
Subject: Re: [PATCH bpf-next v5 2/2] bpf, xdp: restructure redirect actions
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20210227122139.183284-1-bjorn.topel@gmail.com>
 <20210227122139.183284-3-bjorn.topel@gmail.com>
 <ddbbeadc-bead-904a-200a-b75cd995b254@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <222735a9-0cbe-7131-7fd8-f638ddecbedc@intel.com>
Date:   Fri, 5 Mar 2021 18:11:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <ddbbeadc-bead-904a-200a-b75cd995b254@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-05 16:44, Daniel Borkmann wrote:
> On 2/27/21 1:21 PM, Björn Töpel wrote:
> [...]
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index 008691fd3b58..a7752badc2ec 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -646,11 +646,20 @@ struct bpf_redirect_info {
>>       u32 flags;
>>       u32 tgt_index;
>>       void *tgt_value;
>> -    struct bpf_map *map;
>> +    u32 map_id;
>> +    u32 tgt_type;
>>       u32 kern_flags;
>>       struct bpf_nh_params nh;
>>   };
>> +enum xdp_redirect_type {
>> +    XDP_REDIR_UNSET,
>> +    XDP_REDIR_DEV_IFINDEX,
> 
> [...]
> 
>> +    XDP_REDIR_DEV_MAP,
>> +    XDP_REDIR_CPU_MAP,
>> +    XDP_REDIR_XSK_MAP,
> 
> Did you eval whether for these maps we can avoid the redundant def above 
> by just
> passing in map->map_type as ri->tgt_type and inferring the 
> XDP_REDIR_UNSET from
> invalid map_id of 0 (given the idr will never allocate such)?
>

I'll take a stab at it!


> [...]
>> @@ -4068,10 +4039,9 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, 
>> flags)
>>       if (unlikely(flags))
>>           return XDP_ABORTED;
>> -    ri->flags = flags;
>> -    ri->tgt_index = ifindex;
>> -    ri->tgt_value = NULL;
>> -    WRITE_ONCE(ri->map, NULL);
>> +    ri->tgt_type = XDP_REDIR_DEV_IFINDEX;
>> +    ri->tgt_index = 0;
>> +    ri->tgt_value = (void *)(long)ifindex;
> 
> nit: Bit ugly to pass this in /read out this way, maybe union if we 
> cannot use
> tgt_index?
>

Dito!


Thanks for the input! I'll get back with a v6!


Björn


>>       return XDP_REDIRECT;
>>   }
>> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
>> index 711acb3636b3..2c58d88aa69d 100644
>> --- a/net/xdp/xskmap.c
>> +++ b/net/xdp/xskmap.c
>> @@ -87,7 +87,6 @@ static void xsk_map_free(struct bpf_map *map)
>>   {
>>       struct xsk_map *m = container_of(map, struct xsk_map, map);
>> -    bpf_clear_redirect_map(map);
>>       synchronize_net();
>>       bpf_map_area_free(m);
>>   }
>> @@ -229,7 +228,8 @@ static int xsk_map_delete_elem(struct bpf_map 
>> *map, void *key)
>>   static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 
>> flags)
>>   {
>> -    return __bpf_xdp_redirect_map(map, ifindex, flags, 
>> __xsk_map_lookup_elem);
>> +    return __bpf_xdp_redirect_map(map, ifindex, flags, 
>> __xsk_map_lookup_elem,
>> +                      XDP_REDIR_XSK_MAP);
>>   }
>>   void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
>>
> 
