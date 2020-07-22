Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1581F22A09F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgGVUQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbgGVUQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:16:04 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE400C0619DC;
        Wed, 22 Jul 2020 13:14:25 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jyL87-00028N-Fk; Wed, 22 Jul 2020 22:14:19 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jyL87-000Tov-9u; Wed, 22 Jul 2020 22:14:19 +0200
Subject: Re: [PATCH v2 bpf-next 2/6] bpf: propagate poke descriptors to
 subprograms
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
References: <20200721115321.3099-1-maciej.fijalkowski@intel.com>
 <20200721115321.3099-3-maciej.fijalkowski@intel.com>
 <29a3dcfc-9d85-c113-19d2-e33f80ce5430@iogearbox.net>
 <20200722183749.GB8874@ranger.igk.intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <89d0d100-2221-b8c8-ad37-d1b615a27817@iogearbox.net>
Date:   Wed, 22 Jul 2020 22:14:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200722183749.GB8874@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25881/Wed Jul 22 16:35:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 8:37 PM, Maciej Fijalkowski wrote:
> On Wed, Jul 22, 2020 at 04:40:42PM +0200, Daniel Borkmann wrote:
>> On 7/21/20 1:53 PM, Maciej Fijalkowski wrote:
>>> Previously, there was no need for poke descriptors being present in
>>> subprogram's bpf_prog_aux struct since tailcalls were simply not allowed
>>> in them. Each subprog is JITed independently so in order to enable
>>> JITing such subprograms, simply copy poke descriptors from main program
>>> to subprogram's poke tab.
>>>
>>> Add also subprog's aux struct to the BPF map poke_progs list by calling
>>> on it map_poke_track().
>>>
>>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>>> ---
>>>    kernel/bpf/verifier.c | 20 ++++++++++++++++++++
>>>    1 file changed, 20 insertions(+)
>>>
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 3c1efc9d08fd..3428edf85220 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -9936,6 +9936,9 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>>>    		goto out_undo_insn;
>>>    	for (i = 0; i < env->subprog_cnt; i++) {
>>> +		struct bpf_map *map_ptr;
>>> +		int j;
>>> +
>>>    		subprog_start = subprog_end;
>>>    		subprog_end = env->subprog_info[i + 1].start;
>>> @@ -9960,6 +9963,23 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>>>    		func[i]->aux->btf = prog->aux->btf;
>>>    		func[i]->aux->func_info = prog->aux->func_info;
>>> +		for (j = 0; j < prog->aux->size_poke_tab; j++) {
>>> +			int ret;
>>> +
>>> +			ret = bpf_jit_add_poke_descriptor(func[i],
>>> +							  &prog->aux->poke_tab[j]);
>>> +			if (ret < 0) {
>>> +				verbose(env, "adding tail call poke descriptor failed\n");
>>> +				goto out_free;
>>> +			}
>>> +			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
>>> +			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
>>> +			if (ret < 0) {
>>> +				verbose(env, "tracking tail call prog failed\n");
>>> +				goto out_free;
>>> +			}
>>
>> Hmm, I don't think this is correct/complete. If some of these have been registered or
>> if later on the JIT'ing fails but the subprog is already exposed to the prog array then
>> it's /public/ at this point, so a later bpf_jit_free() in out_free will rip them mem
>> while doing live patching on prog updates leading to UAF.
> 
> Ugh. So if we would precede the out_free label with map_poke_untrack() on error
> path - would that be sufficient?

Yes that would be needed and should be sufficient since tracking/untracking/patching is
synchronized under the map's poke mutex lock.

>>> +		}
>>> +
>>>    		/* Use bpf_prog_F_tag to indicate functions in stack traces.
>>>    		 * Long term would need debug info to populate names
>>>    		 */
>>>
>>

