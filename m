Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEEF1CFEF2
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 22:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731153AbgELUHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 16:07:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:54528 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730610AbgELUHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 16:07:20 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYbBF-0007ZL-8n; Tue, 12 May 2020 22:07:09 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYbBE-000H0y-Sf; Tue, 12 May 2020 22:07:08 +0200
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <2aac2366-151a-5ae1-d65f-9232433f425f@iogearbox.net>
 <20200512182515.7kvp6lvtnsij4jvj@ast-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2203fb7d-f1e5-a9a1-8dfc-98c8c9ce3889@iogearbox.net>
Date:   Tue, 12 May 2020 22:07:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200512182515.7kvp6lvtnsij4jvj@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25810/Tue May 12 14:14:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/20 8:25 PM, Alexei Starovoitov wrote:
> On Tue, May 12, 2020 at 04:35:41PM +0200, Daniel Borkmann wrote:
>> On 5/8/20 11:53 PM, Alexei Starovoitov wrote:
>>> From: Alexei Starovoitov <ast@kernel.org>
>>>
>>> Implement permissions as stated in uapi/linux/capability.h
>>> In order to do that the verifier allow_ptr_leaks flag is split
>>> into allow_ptr_leaks and bpf_capable flags and they are set as:
>>>     env->allow_ptr_leaks = perfmon_capable();
>>>     env->bpf_capable = bpf_capable();
>>>
>>> bpf_capable enables bounded loops, variable stack access and other verifier features.
>>> allow_ptr_leaks enable ptr leaks, ptr conversions, subtraction of pointers, etc.
>>> It also disables side channel mitigations.
>>>
>>> That means that the networking BPF program loaded with CAP_BPF + CAP_NET_ADMIN will
>>> have speculative checks done by the verifier and other spectre mitigation applied.
>>> Such networking BPF program will not be able to leak kernel pointers.
>>
>> I don't quite follow this part in the code below yet, see my comments.
>>
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>> [...]
>>> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
>>> index 6abd5a778fcd..c32a7880fa62 100644
>>> --- a/include/linux/bpf_verifier.h
>>> +++ b/include/linux/bpf_verifier.h
>>> @@ -375,6 +375,7 @@ struct bpf_verifier_env {
>>>    	u32 used_map_cnt;		/* number of used maps */
>>>    	u32 id_gen;			/* used to generate unique reg IDs */
>>>    	bool allow_ptr_leaks;
>>> +	bool bpf_capable;
>>>    	bool seen_direct_write;
>>>    	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
>>>    	const struct bpf_line_info *prev_linfo;
>>> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
>>> index 95d77770353c..264a9254dc39 100644
>>> --- a/kernel/bpf/arraymap.c
>>> +++ b/kernel/bpf/arraymap.c
>>> @@ -77,7 +77,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
>>>    	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
>>>    	int ret, numa_node = bpf_map_attr_numa_node(attr);
>>>    	u32 elem_size, index_mask, max_entries;
>>> -	bool unpriv = !capable(CAP_SYS_ADMIN);
>>> +	bool unpriv = !bpf_capable();
>>
>> So here progs loaded with CAP_BPF will have spectre mitigations bypassed which
>> is the opposite of above statement, no?
> 
> right. good catch, but now I'm not sure it was such a good call to toss
> spectre into cap_perfmon. It probably should be disabled under cap_bpf.

Right. :( Too bad CAP_*s are not more fine-grained today for more descriptive
policy. I would presume granting both CAP_BPF + CAP_PERFMON combination is not
always desired either, so probably makes sense to leave it out with a clear
description in patch 1/3 for CAP_BPF about the implications.

>>>    	u64 cost, array_size, mask64;
>>>    	struct bpf_map_memory mem;
>>>    	struct bpf_array *array;
>> [...]
>>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>>> index 6aa11de67315..8f421dd0c4cf 100644
>>> --- a/kernel/bpf/core.c
>>> +++ b/kernel/bpf/core.c
>>> @@ -646,7 +646,7 @@ static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
>>>    void bpf_prog_kallsyms_add(struct bpf_prog *fp)
>>>    {
>>>    	if (!bpf_prog_kallsyms_candidate(fp) ||
>>> -	    !capable(CAP_SYS_ADMIN))
>>> +	    !bpf_capable())
>>>    		return;
>>>    	bpf_prog_ksym_set_addr(fp);
>>> @@ -824,7 +824,7 @@ static int bpf_jit_charge_modmem(u32 pages)
>>>    {
>>>    	if (atomic_long_add_return(pages, &bpf_jit_current) >
>>>    	    (bpf_jit_limit >> PAGE_SHIFT)) {
>>> -		if (!capable(CAP_SYS_ADMIN)) {
>>> +		if (!bpf_capable()) {
>>
>> Should there still be an upper charge on module mem for !CAP_SYS_ADMIN?
> 
> hmm. cap_bpf is a subset of cap_sys_admin. I don't see a reason
> to keep requiring cap_sys_admin here.

It should probably be described in the CAP_BPF comment as well since this
is different compared to plain unpriv.

>>>    			atomic_long_sub(pages, &bpf_jit_current);
>>>    			return -EPERM;
>>>    		}
>> [...]
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 70ad009577f8..a6893746cd87 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>> [...]
>>> @@ -3428,7 +3429,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
>>>    		 * Spectre masking for stack ALU.
>>>    		 * See also retrieve_ptr_limit().
>>>    		 */
>>> -		if (!env->allow_ptr_leaks) {
>>> +		if (!env->bpf_capable) {
>>
>> This needs to stay on env->allow_ptr_leaks, the can_skip_alu_sanitation() does
>> check on env->allow_ptr_leaks as well, otherwise this breaks spectre mitgation
>> when masking alu.
> 
> The patch kept it in can_skip_alu_sanitation(), but I missed it here.
> Don't really recall the details of discussion around
> commit 088ec26d9c2d ("bpf: Reject indirect var_off stack access in unpriv mode")
> 
> So thinking all over this bit will effectively disable variable
> stack access which is one of main usability features.

The reason is that we otherwise cannot derive a fixed limit for the masking
in order to avoid oob access under speculation.

> So for v6 I'm thinking to put spectre bypass into cap_bpf.
> allow_ptr_leak will mean only what the name says: pointer leaks only.
> cap_bpf should not be given to user processes that want to become root
> via spectre side channels.

Yeah, I think it needs to be made crystal clear that from a security level
CAP_BPF is effectively from a BPF point of view very close to CAP_SYS_ADMIN
minus the remaining non-BPF stuff in there, so this should not be handed out
loosely.

> I think it's a usability trade-off for cap_bpf.
> Without indirect var under cap_bpf too many networking progs will be forced to use
> cap_bpf+net_net_admin+cap_perfmon only to pass the verifier
> while they don't really care about reading arbitrary memory via cap_perfmon.

If I recall correctly, at least for Cilium programs the var access restriction
was not an issue - we don't use/need them in our code today, but it might differ
on your side, for example. This brings us back that while CAP_BPF would solve
the issue of not having to hand out the even wider CAP_SYS_ADMIN, it's still not
the end of the tunnel either and we'll see need for something more fine-grained
coming next.

Thanks,
Daniel
