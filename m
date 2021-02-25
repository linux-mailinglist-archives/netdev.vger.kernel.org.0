Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64538324AA1
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 07:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhBYGku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 01:40:50 -0500
Received: from mga07.intel.com ([134.134.136.100]:32122 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234354AbhBYGkg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 01:40:36 -0500
IronPort-SDR: D9yL8UTf3JMy5XtFjjAXmsLguoHyThMaGyuTQxgyNm0MeKCMkVK22ZZ8pViyZisoqZJYGMCTie
 UVRpciGKKckg==
X-IronPort-AV: E=McAfee;i="6000,8403,9905"; a="249487334"
X-IronPort-AV: E=Sophos;i="5.81,205,1610438400"; 
   d="scan'208";a="249487334"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2021 22:40:11 -0800
IronPort-SDR: Q1FO86YA1ZWNQwvl6CrC+LIin+XMwdTeHsTlPU/gq0AJF36pNJrMe6s7Ha+2Y0nSUx8Dq7Ib5h
 bVTWgOaq8utw==
X-IronPort-AV: E=Sophos;i="5.81,205,1610438400"; 
   d="scan'208";a="404109403"
Received: from riessph-mobl3.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.40.153])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2021 22:40:05 -0800
Subject: Re: [PATCH bpf-next v3 1/2] bpf, xdp: per-map bpf_redirect_map
 functions for XDP
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
References: <20210221200954.164125-1-bjorn.topel@gmail.com>
 <20210221200954.164125-2-bjorn.topel@gmail.com>
 <755205ef-819d-15f7-3fcd-30d964b6668d@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <29f1e58e-1ecf-e191-f60f-c82eb8a7e76c@intel.com>
Date:   Thu, 25 Feb 2021 07:39:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <755205ef-819d-15f7-3fcd-30d964b6668d@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-25 00:38, Daniel Borkmann wrote:
> On 2/21/21 9:09 PM, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Currently the bpf_redirect_map() implementation dispatches to the
>> correct map-lookup function via a switch-statement. To avoid the
>> dispatching, this change adds one bpf_redirect_map() implementation per
>> map. Correct function is automatically selected by the BPF verifier.
>>
>> v2->v3 : Fix build when CONFIG_NET is not set. (lkp)
>> v1->v2 : Re-added comment. (Toke)
>> rfc->v1: Get rid of the macro and use __always_inline. (Jesper)
>>
>> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> 
> [...]
> 
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 3d34ba492d46..89ccc10c6348 100644
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
>> @@ -11545,12 +11546,12 @@ static int fixup_bpf_calls(struct 
>> bpf_verifier_env *env)
>>       struct bpf_prog *prog = env->prog;
>>       bool expect_blinding = bpf_jit_blinding_enabled(prog);
>>       struct bpf_insn *insn = prog->insnsi;
>> -    const struct bpf_func_proto *fn;
>>       const int insn_cnt = prog->len;
>>       const struct bpf_map_ops *ops;
>>       struct bpf_insn_aux_data *aux;
>>       struct bpf_insn insn_buf[16];
>>       struct bpf_prog *new_prog;
>> +    bpf_func_proto_func func;
>>       struct bpf_map *map_ptr;
>>       int i, ret, cnt, delta = 0;
>> @@ -11860,17 +11861,23 @@ static int fixup_bpf_calls(struct 
>> bpf_verifier_env *env)
>>           }
>>   patch_call_imm:
>> -        fn = env->ops->get_func_proto(insn->imm, env->prog);
>> +        if (insn->imm == BPF_FUNC_redirect_map) {
>> +            aux = &env->insn_aux_data[i];
>> +            map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
>> +            func = get_xdp_redirect_func(map_ptr->map_type);
> 
> Nope, this is broken. :/ The map_ptr could be poisoned, so 
> unconditionally fetching
> map_ptr->map_type can crash the box for specially crafted BPF progs.
>

Thanks for explaining, Daniel! I'll address that!

> Also, given you add the related BPF_CALL_3() functions below, what is 
> the reason
> to not properly integrate this like the map ops near patch_map_ops_generic?
>

...and will have look how the map-patching works!


Cheers,
Björn

[...]
