Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD4932F0E4
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 18:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhCERMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 12:12:13 -0500
Received: from mga05.intel.com ([192.55.52.43]:29771 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhCERLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 12:11:48 -0500
IronPort-SDR: OIjJhhbhVzcchnAkmNCsxfHC3KCjHFpvobqWfaSvXtWx9/B80xsRWmPNzH9LsT3onLgMLu8Vj5
 6TPKQSKsKerQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="272693124"
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="272693124"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 09:11:42 -0800
IronPort-SDR: iWIg0qjRRI3xD5hU2oPlL7eVQXm22GKwvvYyM19UDoz3MuE4viJVQHXnwx9+Yg7QB/+WF9+8Ez
 q3mwdppp4yGQ==
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="408399464"
Received: from luetzenk-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.43.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 09:11:37 -0800
Subject: Re: [PATCH bpf-next v5 1/2] bpf, xdp: make bpf_redirect_map() a map
 operation
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20210227122139.183284-1-bjorn.topel@gmail.com>
 <20210227122139.183284-2-bjorn.topel@gmail.com>
 <eb40aa9a-ffd4-539a-8a4e-420160962500@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <d7b7354d-a802-c711-f66f-118986652a8e@intel.com>
Date:   Fri, 5 Mar 2021 18:11:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <eb40aa9a-ffd4-539a-8a4e-420160962500@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-05 16:55, Daniel Borkmann wrote:
> On 2/27/21 1:21 PM, Björn Töpel wrote:
> [...]
> 
> Look good. Small nits inline I had originally fixed up locally before 
> glancing at 2/2:
> 
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 4c730863fa77..3d3e89a37e62 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -118,6 +118,9 @@ struct bpf_map_ops {
>>                          void *owner, u32 size);
>>       struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void 
>> *owner);
>> +    /* XDP helpers.*/
> 
> If this really needs a comment, I'd say 'Misc helpers' since we might 
> later also
> add implementations for tc and everything can be inferred from the code 
> anyway.
>

ACK!


>> +    int (*map_redirect)(struct bpf_map *map, u32 ifindex, u64 flags);
>> +
> [...]
>>   static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 9fe90ce52a65..b6c44b85e960 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -5582,7 +5582,8 @@ record_func_map(struct bpf_verifier_env *env, 
>> struct bpf_call_arg_meta *meta,
>>           func_id != BPF_FUNC_map_push_elem &&
>>           func_id != BPF_FUNC_map_pop_elem &&
>>           func_id != BPF_FUNC_map_peek_elem &&
>> -        func_id != BPF_FUNC_for_each_map_elem)
>> +        func_id != BPF_FUNC_for_each_map_elem &&
>> +        func_id != BPF_FUNC_redirect_map)
>>           return 0;
>>       if (map == NULL) {
>> @@ -12017,7 +12018,8 @@ static int do_misc_fixups(struct 
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
>> @@ -12059,6 +12061,8 @@ static int do_misc_fixups(struct 
>> bpf_verifier_env *env)
>>                        (int (*)(struct bpf_map *map, void *value))NULL));
>>               BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
>>                        (int (*)(struct bpf_map *map, void *value))NULL));
>> +            BUILD_BUG_ON(!__same_type(ops->map_redirect,
>> +                     (int (*)(struct bpf_map *map, u32 ifindex, u64 
>> flags))NULL));
> 
> I added a linebreak here.
>

Ok!

>>   patch_map_ops_generic:
>>               switch (insn->imm) {
>>               case BPF_FUNC_map_lookup_elem:
>> @@ -12085,6 +12089,9 @@ static int do_misc_fixups(struct 
>> bpf_verifier_env *env)
>>                   insn->imm = BPF_CAST_CALL(ops->map_peek_elem) -
>>                           __bpf_call_base;
>>                   continue;
>> +            case BPF_FUNC_redirect_map:
>> +                insn->imm = BPF_CAST_CALL(ops->map_redirect) - 
>> __bpf_call_base;
> 
> Ditto so it matches the rest.
>

Fair enough; I guess my love for the 100 chars lines is bigger than 
conformity. :-P


>> +                continue;
>>               }
>>               goto patch_call_imm;
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 13bcf248ee7b..960299a3744f 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3934,22 +3934,6 @@ void xdp_do_flush(void)
>>   }
>>   EXPORT_SYMBOL_GPL(xdp_do_flush);
>> -static inline void *__xdp_map_lookup_elem(struct bpf_map *map, u32 
>> index)
>> -{
>> -    switch (map->map_type) {
>> -    case BPF_MAP_TYPE_DEVMAP:
>> -        return __dev_map_lookup_elem(map, index);
>> -    case BPF_MAP_TYPE_DEVMAP_HASH:
>> -        return __dev_map_hash_lookup_elem(map, index);
>> -    case BPF_MAP_TYPE_CPUMAP:
>> -        return __cpu_map_lookup_elem(map, index);
>> -    case BPF_MAP_TYPE_XSKMAP:
>> -        return __xsk_map_lookup_elem(map, index);
>> -    default:
>> -        return NULL;
>> -    }
>> -}
>> -
>>   void bpf_clear_redirect_map(struct bpf_map *map)
>>   {
>>       struct bpf_redirect_info *ri;
>> @@ -4103,28 +4087,7 @@ static const struct bpf_func_proto 
>> bpf_xdp_redirect_proto = {
>>   BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>>          u64, flags)
>>   {
>> -    struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>> -
>> -    /* Lower bits of the flags are used as return code on lookup 
>> failure */
>> -    if (unlikely(flags > XDP_TX))
>> -        return XDP_ABORTED;
>> -
>> -    ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
>> -    if (unlikely(!ri->tgt_value)) {
>> -        /* If the lookup fails we want to clear out the state in the
>> -         * redirect_info struct completely, so that if an eBPF program
>> -         * performs multiple lookups, the last one always takes
>> -         * precedence.
>> -         */
>> -        WRITE_ONCE(ri->map, NULL);
>> -        return flags;
>> -    }
>> -
>> -    ri->flags = flags;
>> -    ri->tgt_index = ifindex;
>> -    WRITE_ONCE(ri->map, map);
>> -
>> -    return XDP_REDIRECT;
>> +    return map->ops->map_redirect(map, ifindex, flags);
>>   }
>>   static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
>> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
>> index 113fd9017203..711acb3636b3 100644
>> --- a/net/xdp/xskmap.c
>> +++ b/net/xdp/xskmap.c
>> @@ -125,6 +125,18 @@ static int xsk_map_gen_lookup(struct bpf_map 
>> *map, struct bpf_insn *insn_buf)
>>       return insn - insn_buf;
>>   }
>> +static void *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
>> +{
>> +    struct xsk_map *m = container_of(map, struct xsk_map, map);
>> +    struct xdp_sock *xs;
>> +
>> +    if (key >= map->max_entries)
>> +        return NULL;
>> +
>> +    xs = READ_ONCE(m->xsk_map[key]);
> 
> Just 'return READ_ONCE(m->xsk_map[key]);'
>

Indeed.

I'll make sure to include the fixups in v6.


Björn


>> +    return xs;
>> +}
>> +
>>   static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
>>   {
>>       WARN_ON_ONCE(!rcu_read_lock_held());
>> @@ -215,6 +227,11 @@ static int xsk_map_delete_elem(struct bpf_map 
>> *map, void *key)
>>       return 0;
>>   }
>> +static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
>> +{
>> +    return __bpf_xdp_redirect_map(map, ifindex, flags, 
>> __xsk_map_lookup_elem);
>> +}
>> +
>>   void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
>>                    struct xdp_sock **map_entry)
>>   {
>> @@ -247,4 +264,5 @@ const struct bpf_map_ops xsk_map_ops = {
>>       .map_check_btf = map_check_no_btf,
>>       .map_btf_name = "xsk_map",
>>       .map_btf_id = &xsk_map_btf_id,
>> +    .map_redirect = xsk_map_redirect,
>>   };
>>
> 
