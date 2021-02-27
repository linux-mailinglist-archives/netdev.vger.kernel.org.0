Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42586326C74
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 10:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhB0JJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 04:09:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:28530 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhB0JF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Feb 2021 04:05:59 -0500
IronPort-SDR: 77LrvIsU0kOxP2IrKDZyem+1XxIo8F05cUybqin6T5RqU8H4Wr3WWf85jDwG1Walmco9fHX/CN
 DSCZ0NRalbfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="271073108"
X-IronPort-AV: E=Sophos;i="5.81,210,1610438400"; 
   d="scan'208";a="271073108"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 01:04:48 -0800
IronPort-SDR: uaVN3QrBmS6Phl3AlobsMfPSn5fnxtjZhKhMHYPxLKGgiFFpdQ9+VD9JoY4Om3m2eRCnHoGQ7x
 wmRbQrCNfPbw==
X-IronPort-AV: E=Sophos;i="5.81,210,1610438400"; 
   d="scan'208";a="405339296"
Received: from nsilvest-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.60.14])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 01:04:44 -0800
Subject: Re: [PATCH bpf-next v4 1/2] bpf, xdp: make bpf_redirect_map() a map
 operation
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
 <20210226112322.144927-2-bjorn.topel@gmail.com>
 <c36e681a-673d-d0d2-816a-e8f2c8ef5df7@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <69b51d70-a885-d39a-cff3-92e8ef703a20@intel.com>
Date:   Sat, 27 Feb 2021 10:04:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <c36e681a-673d-d0d2-816a-e8f2c8ef5df7@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-02-26 22:48, Daniel Borkmann wrote:
> On 2/26/21 12:23 PM, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Currently the bpf_redirect_map() implementation dispatches to the
>> correct map-lookup function via a switch-statement. To avoid the
>> dispatching, this change adds bpf_redirect_map() as a map
>> operation. Each map provides its bpf_redirect_map() version, and
>> correct function is automatically selected by the BPF verifier.
>>
>> A nice side-effect of the code movement is that the map lookup
>> functions are now local to the map implementation files, which removes
>> one additional function call.
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
>>   include/linux/bpf.h    | 26 ++++++--------------------
>>   include/linux/filter.h | 27 +++++++++++++++++++++++++++
>>   include/net/xdp_sock.h | 19 -------------------
>>   kernel/bpf/cpumap.c    |  8 +++++++-
>>   kernel/bpf/devmap.c    | 16 ++++++++++++++--
>>   kernel/bpf/verifier.c  | 11 +++++++++--
>>   net/core/filter.c      | 39 +--------------------------------------
>>   net/xdp/xskmap.c       | 18 ++++++++++++++++++
>>   8 files changed, 82 insertions(+), 82 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index cccaef1088ea..a44ba904ca37 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -117,6 +117,9 @@ struct bpf_map_ops {
>>                          void *owner, u32 size);
>>       struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void 
>> *owner);
>> +    /* XDP helpers.*/
>> +    int (*xdp_redirect_map)(struct bpf_map *map, u32 ifindex, u64 
>> flags);
>> +
>>       /* map_meta_equal must be implemented for maps that can be
>>        * used as an inner map.  It is a runtime check to ensure
>>        * an inner map can be inserted to an outer map.
> [...]
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 1dda9d81f12c..96705a49225e 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -5409,7 +5409,8 @@ record_func_map(struct bpf_verifier_env *env, 
>> struct bpf_call_arg_meta *meta,
>>           func_id != BPF_FUNC_map_delete_elem &&
>>           func_id != BPF_FUNC_map_push_elem &&
>>           func_id != BPF_FUNC_map_pop_elem &&
>> -        func_id != BPF_FUNC_map_peek_elem)
>> +        func_id != BPF_FUNC_map_peek_elem &&
>> +        func_id != BPF_FUNC_redirect_map)
>>           return 0;
>>       if (map == NULL) {
>> @@ -11762,7 +11763,8 @@ static int fixup_bpf_calls(struct 
>> bpf_verifier_env *env)
>>                insn->imm == BPF_FUNC_map_delete_elem ||
>>                insn->imm == BPF_FUNC_map_push_elem   ||
>>                insn->imm == BPF_FUNC_map_pop_elem    ||
>> -             insn->imm == BPF_FUNC_map_peek_elem)) {
>> +             insn->imm == BPF_FUNC_map_peek_elem   ||
>> +             insn->imm == BPF_FUNC_redirect_map)) {
>>               aux = &env->insn_aux_data[i + delta];
>>               if (bpf_map_ptr_poisoned(aux))
>>                   goto patch_call_imm;
>> @@ -11804,6 +11806,8 @@ static int fixup_bpf_calls(struct 
>> bpf_verifier_env *env)
>>                        (int (*)(struct bpf_map *map, void *value))NULL));
>>               BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
>>                        (int (*)(struct bpf_map *map, void *value))NULL));
>> +            BUILD_BUG_ON(!__same_type(ops->xdp_redirect_map,
>> +                     (int (*)(struct bpf_map *map, u32 ifindex, u64 
>> flags))NULL));
>>   patch_map_ops_generic:
>>               switch (insn->imm) {
>>               case BPF_FUNC_map_lookup_elem:
>> @@ -11830,6 +11834,9 @@ static int fixup_bpf_calls(struct 
>> bpf_verifier_env *env)
>>                   insn->imm = BPF_CAST_CALL(ops->map_peek_elem) -
>>                           __bpf_call_base;
>>                   continue;
>> +            case BPF_FUNC_redirect_map:
>> +                insn->imm = BPF_CAST_CALL(ops->xdp_redirect_map) - 
>> __bpf_call_base;
> 
> Small nit: I would name the generic callback ops->map_redirect so that 
> this is in line with
> the general naming convention for the map ops. Otherwise this looks much 
> better, thx!
>

I'll respin! Thanks for the input!

I'll ignore the BPF_CAST_CALL W=1 warnings ([-Wcast-function-type]), or
do you have any thoughts on that? I don't think it's a good idea to
silence that warning for the whole verifier.c


Björn


>> +                continue;
>>               }
>>               goto patch_call_imm;
