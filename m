Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F63031FE37
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhBSRrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:47:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:12770 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhBSRrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 12:47:52 -0500
IronPort-SDR: wLBJuSUzM9HxmY2YVExJjA0xFsT19P7Hco+vyghcw6jQFweuNxr89uyKTTWRfORpfmTEY8CGDH
 EZyk65Yp0r7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9900"; a="247978006"
X-IronPort-AV: E=Sophos;i="5.81,189,1610438400"; 
   d="scan'208";a="247978006"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 09:47:12 -0800
IronPort-SDR: AH1h+7CFu1Rge515kEi6NWdHDAOMyG6r0227UHaCwsfaLth3vXFWvX3CKuHS5sr34bmEmzUI3S
 qzJmALPCbReQ==
X-IronPort-AV: E=Sophos;i="5.81,189,1610438400"; 
   d="scan'208";a="401126271"
Received: from martafor-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.56.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 09:47:05 -0800
Subject: Re: [PATCH bpf-next 1/2] bpf, xdp: per-map bpf_redirect_map functions
 for XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
References: <20210219145922.63655-1-bjorn.topel@gmail.com>
 <20210219145922.63655-2-bjorn.topel@gmail.com> <87tuq8httg.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <b62f3795-0842-95fe-65fc-8b769c77b81c@intel.com>
Date:   Fri, 19 Feb 2021 18:47:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87tuq8httg.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-19 18:05, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 

[...]


>> @@ -4110,22 +4094,17 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
>>   	.arg2_type      = ARG_ANYTHING,
>>   };
>>   
>> -BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>> -	   u64, flags)
>> +static __always_inline s64 __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex, u64 flags,
>> +						  void *lookup_elem(struct bpf_map *map,
>> +								    u32 key))
>>   {
>>   	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>>   
>> -	/* Lower bits of the flags are used as return code on lookup failure */
>>   	if (unlikely(flags > XDP_TX))
>>   		return XDP_ABORTED;
>>   
>> -	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
>> +	ri->tgt_value = lookup_elem(map, ifindex);
>>   	if (unlikely(!ri->tgt_value)) {
>> -		/* If the lookup fails we want to clear out the state in the
>> -		 * redirect_info struct completely, so that if an eBPF program
>> -		 * performs multiple lookups, the last one always takes
>> -		 * precedence.
>> -		 */
> 
> Why remove the comments?
>

Ugh, no reason. I'll do a v2. LKP had a warning as well.


Thanks,
Björn

[...]
