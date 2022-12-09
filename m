Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A778E648B63
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLIXcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLIXcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:32:20 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00499D896;
        Fri,  9 Dec 2022 15:32:18 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1p3mqf-0000ST-3j; Sat, 10 Dec 2022 00:32:09 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1p3mqe-0008ON-Cd; Sat, 10 Dec 2022 00:32:08 +0100
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Yonghong Song <yhs@meta.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
References: <Y5Inw4HtkA2ql8GF@krava> <Y5JkomOZaCETLDaZ@krava>
 <Y5JtACA8ay5QNEi7@krava> <Y5LfMGbOHpaBfuw4@krava> <Y5MaffJOe1QtumSN@krava>
 <Y5M9P95l85oMHki9@krava> <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com> <Y5OuQNmkoIvcV6IL@krava>
 <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net> <Y5O/yxcjQLq5oDAv@krava>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
Date:   Sat, 10 Dec 2022 00:32:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <Y5O/yxcjQLq5oDAv@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26745/Fri Dec  9 12:50:19 2022)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/22 12:07 AM, Jiri Olsa wrote:
> On Fri, Dec 09, 2022 at 11:41:11PM +0100, Daniel Borkmann wrote:
>> On 12/9/22 10:53 PM, Jiri Olsa wrote:
>>> On Fri, Dec 09, 2022 at 12:31:06PM -0800, Yonghong Song wrote:
>>>>
>>>>
>>>> On 12/9/22 7:20 AM, Jiri Olsa wrote:
>>>>> On Fri, Dec 09, 2022 at 02:50:55PM +0100, Jiri Olsa wrote:
>>>>>> On Fri, Dec 09, 2022 at 12:22:37PM +0100, Jiri Olsa wrote:
>>>>>>
>>>>>> SBIP
>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> I'm trying to understand the severity of the issues and
>>>>>>>>>>>>> whether we need to revert that commit asap since the merge window
>>>>>>>>>>>>> is about to start.
>>>>>>>>>>>>
>>>>>>>>>>>> Jiri, Peter,
>>>>>>>>>>>>
>>>>>>>>>>>> ping.
>>>>>>>>>>>>
>>>>>>>>>>>> cc-ing Thorsten, since he's tracking it now.
>>>>>>>>>>>>
>>>>>>>>>>>> The config has CONFIG_X86_KERNEL_IBT=y.
>>>>>>>>>>>> Is it related?
>>>>>>>>>>>
>>>>>>>>>>> sorry for late reply.. I still did not find the reason,
>>>>>>>>>>> but I did not try with IBT yet, will test now
>>>>>>>>>>
>>>>>>>>>> no difference with IBT enabled, can't reproduce the issue
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> ok, scratch that.. the reproducer got stuck on wifi init :-\
>>>>>>>>>
>>>>>>>>> after I fix that I can now reproduce on my local config with
>>>>>>>>> IBT enabled or disabled.. it's something else
>>>>>>>>
>>>>>>>> I'm getting the error also when reverting the static call change,
>>>>>>>> looking for good commit, bisecting
>>>>>>>>
>>>>>>>> I'm getting fail with:
>>>>>>>>       f0c4d9fc9cc9 (tag: v6.1-rc4) Linux 6.1-rc4
>>>>>>>>
>>>>>>>> v6.1-rc1 is ok
>>>>>>>
>>>>>>> so far I narrowed it down between rc1 and rc3.. bisect got me nowhere so far
>>>>>>>
>>>>>>> attaching some more logs
>>>>>>
>>>>>> looking at the code.. how do we ensure that code running through
>>>>>> bpf_prog_run_xdp will not get dispatcher image changed while
>>>>>> it's being exetuted
>>>>>>
>>>>>> we use 'the other half' of the image when we add/remove programs,
>>>>>> but could bpf_dispatcher_update race with bpf_prog_run_xdp like:
>>>>>>
>>>>>>
>>>>>> cpu 0:                                  cpu 1:
>>>>>>
>>>>>> bpf_prog_run_xdp
>>>>>>       ...
>>>>>>       bpf_dispatcher_xdp_func
>>>>>>          start exec image at offset 0x0
>>>>>>
>>>>>>                                            bpf_dispatcher_update
>>>>>>                                                    update image at offset 0x800
>>>>>>                                            bpf_dispatcher_update
>>>>>>                                                    update image at offset 0x0
>>>>>>
>>>>>>          still in image at offset 0x0
>>>>>>
>>>>>>
>>>>>> that might explain why I wasn't able to trigger that on
>>>>>> bare metal just in qemu
>>>>>
>>>>> I tried patch below and it fixes the issue for me and seems
>>>>> to confirm the race above.. but not sure it's the best fix
>>>>>
>>>>> jirka
>>>>>
>>>>>
>>>>> ---
>>>>> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
>>>>> index c19719f48ce0..6a2ced102fc7 100644
>>>>> --- a/kernel/bpf/dispatcher.c
>>>>> +++ b/kernel/bpf/dispatcher.c
>>>>> @@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
>>>>>     	}
>>>>>     	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
>>>>> +	synchronize_rcu_tasks();
>>>>>     	if (new)
>>>>>     		d->image_off = noff;
>>>>
>>>> This might work. In arch/x86/kernel/alternative.c, we have following
>>>> code and comments. For text_poke, synchronize_rcu_tasks() might be able
>>>> to avoid concurrent execution and update.
>>>
>>> so my idea was that we need to ensure all the current callers of
>>> bpf_dispatcher_xdp_func (which should have rcu read lock, based
>>> on the comment in bpf_prog_run_xdp) are gone before and new ones
>>> execute the new image, so the next call to the bpf_dispatcher_update
>>> will be safe to overwrite the other half of the image
>>
>> If v6.1-rc1 was indeed okay, then it looks like this may be related to
>> the trampoline patching for the static_call? Did it repro on v6.1-rc1
>> just with dbe69b299884 ("bpf: Fix dispatcher patchable function entry
>> to 5 bytes nop") cherry-picked?
> 
> I'll try that.. it looks to me like the problem was always there,
> maybe harder to trigger.. also to reproduce it you need to call
> bpf_dispatcher_update heavily, which is not probably the common
> use case
> 
> one other thing is that I think the fix might need rcu locking
> on the bpf_dispatcher_xdp_func side, because local_bh_disable
> seems not to be enough to make synchronize_rcu_tasks work
> 
> I'm now testing patch below
> 
> jirka
> 
> ---
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index efc42a6e3aed..a27245b96d6b 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -772,7 +772,13 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
>   	 * under local_bh_disable(), which provides the needed RCU protection
>   	 * for accessing map entries.
>   	 */
> -	u32 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
> +	u32 act;
> +
> +	rcu_read_lock();
> +
> +	act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
> +
> +	rcu_read_unlock();

fwiw, these should not be necessary, Documentation/RCU/checklist.rst :

   [...] One example of non-obvious pairing is the XDP feature in networking,
   which calls BPF programs from network-driver NAPI (softirq) context. BPF
   relies heavily on RCU protection for its data structures, but because the
   BPF program invocation happens entirely within a single local_bh_disable()
   section in a NAPI poll cycle, this usage is safe. The reason that this usage
   is safe is that readers can use anything that disables BH when updaters use
   call_rcu() or synchronize_rcu(). [...]

>   	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
>   		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> index c19719f48ce0..6a2ced102fc7 100644
> --- a/kernel/bpf/dispatcher.c
> +++ b/kernel/bpf/dispatcher.c
> @@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
>   	}
>   
>   	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
> +	synchronize_rcu_tasks();
>   
>   	if (new)
>   		d->image_off = noff;
> 

