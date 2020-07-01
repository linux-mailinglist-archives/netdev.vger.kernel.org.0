Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925A121083F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 11:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgGAJer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 05:34:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:54622 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgGAJer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 05:34:47 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqZ8c-00060n-GJ; Wed, 01 Jul 2020 11:34:42 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqZ8c-000Nz6-8n; Wed, 01 Jul 2020 11:34:42 +0200
Subject: Re: [PATCH v5 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     KP Singh <kpsingh@chromium.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, paulmck@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-3-alexei.starovoitov@gmail.com>
 <d0c6b6a6-7b82-e620-8ced-8a1acfaf6f6d@iogearbox.net>
 <20200630234117.arqmjpbivy5fhhmk@ast-mbp.dhcp.thefacebook.com>
 <CACYkzJ5kGxxA1E70EKah_hWbsb7hoUy8s_Y__uCeSyYxVezaBA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5596445c-7474-9913-6765-5d699c6c5c4e@iogearbox.net>
Date:   Wed, 1 Jul 2020 11:34:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACYkzJ5kGxxA1E70EKah_hWbsb7hoUy8s_Y__uCeSyYxVezaBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25859/Tue Jun 30 15:38:05 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/20 11:15 AM, KP Singh wrote:
> On Wed, Jul 1, 2020 at 1:41 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Wed, Jul 01, 2020 at 01:26:44AM +0200, Daniel Borkmann wrote:
>>> On 6/30/20 6:33 AM, Alexei Starovoitov wrote:
>>> [...]
>>>> +/* list of non-sleepable kernel functions that are otherwise
>>>> + * available to attach by bpf_lsm or fmod_ret progs.
>>>> + */
>>>> +static int check_sleepable_blacklist(unsigned long addr)
>>>> +{
>>>> +#ifdef CONFIG_BPF_LSM
>>>> +   if (addr == (long)bpf_lsm_task_free)
>>>> +           return -EINVAL;
>>>> +#endif
>>>> +#ifdef CONFIG_SECURITY
>>>> +   if (addr == (long)security_task_free)
>>>> +           return -EINVAL;
>>>> +#endif
>>>> +   return 0;
>>>> +}
>>>
>>> Would be nice to have some sort of generic function annotation to describe
>>> that code cannot sleep inside of it, and then filter based on that. Anyway,
>>> is above from manual code inspection?
>>
>> yep. all manual. I don't think there is a way to automate it.
>> At least I cannot think of one.
>>
>>> What about others like security_sock_rcv_skb() for example which could be
>>> bh_lock_sock()'ed (or, generally hooks running in softirq context)?
>>
>> ahh. it's in running in bh at that point? then it should be added to blacklist.
>>
>> The rough idea I had is to try all lsm_* and security_* hooks with all
>> debug kernel flags and see which ones will complain. Then add them to blacklist.
>> Unfortunately I'm completely swamped and cannot promise to do that
>> in the coming months.
>> So either we wait for somebody to do due diligence or land it knowing
>> that blacklist is incomplete and fix it up one by one.
>> I think the folks who're waiting on sleepable work would prefer the latter.
>> I'm fine whichever way.
> 
> Chiming in since I belong to the folks who are waiting on sleepable BPF patches:
> 
> 1. Let's obviously add security_sock_rcv_skb to the list.
> 2. I can help in combing through the LSM hooks (at least the comments)
>       to look for any other obvious candidates.
> 3. I think it's okay (for us) for this list to be a WIP and build on it with
>      proper warnings (in the changelog / comments).
> 4. To make it easier for figuring out which hooks cannot sleep,
>       It would be nice if we could:
> 
>      * Have a helper say, bool bpf_cant_sleep(), available when
>         DEBUG_ATOMIC_SLEEP is enabled.
>      * Attach LSM programs to all hooks which call this helper and gather data.
>      * Let this run on dev machines, run workloads which use the LSM hooks .
> 
> 4. Finally, once we do the hard work. We can also think of augmenting the
>      LSM_HOOK macro to have structured access to whether a hook is sleepable
>      or not (instead of relying on comments).

+1, I think augmenting mid-term would be the best given check_sleepable_blacklist()
is rather a very fragile workaround^hack and it's also a generic lsm/sec hooks issue
(at least for BPF_PROG_TYPE_LSM type & for the sake of documenting it for other LSMs).
Perhaps there are function attributes that could be used and later retrieved via BTF?

Thanks,
Daniel
