Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6642107DA
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 11:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgGAJRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 05:17:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:51128 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgGAJR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 05:17:29 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqYrp-0004Of-Sz; Wed, 01 Jul 2020 11:17:21 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqYrp-000Gex-LM; Wed, 01 Jul 2020 11:17:21 +0200
Subject: Re: [PATCH v5 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-3-alexei.starovoitov@gmail.com>
 <d0c6b6a6-7b82-e620-8ced-8a1acfaf6f6d@iogearbox.net>
 <20200630234117.arqmjpbivy5fhhmk@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1e9d88c9-c5f2-6def-7afc-aca47a88f4b0@iogearbox.net>
Date:   Wed, 1 Jul 2020 11:17:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200630234117.arqmjpbivy5fhhmk@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25859/Tue Jun 30 15:38:05 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/20 1:41 AM, Alexei Starovoitov wrote:
> On Wed, Jul 01, 2020 at 01:26:44AM +0200, Daniel Borkmann wrote:
>> On 6/30/20 6:33 AM, Alexei Starovoitov wrote:
>> [...]
>>> +/* list of non-sleepable kernel functions that are otherwise
>>> + * available to attach by bpf_lsm or fmod_ret progs.
>>> + */
>>> +static int check_sleepable_blacklist(unsigned long addr)
>>> +{
>>> +#ifdef CONFIG_BPF_LSM
>>> +	if (addr == (long)bpf_lsm_task_free)
>>> +		return -EINVAL;
>>> +#endif
>>> +#ifdef CONFIG_SECURITY
>>> +	if (addr == (long)security_task_free)
>>> +		return -EINVAL;
>>> +#endif
>>> +	return 0;
>>> +}
>>
>> Would be nice to have some sort of generic function annotation to describe
>> that code cannot sleep inside of it, and then filter based on that. Anyway,
>> is above from manual code inspection?
> 
> yep. all manual. I don't think there is a way to automate it.
> At least I cannot think of one.

Automation might be hard, but maybe semi-automate: we have a cant_migrate()
assertion in __BPF_PROG_RUN() which asserts on cant_sleep() PREEMPT_RT kernels
at least. We originally just has the cant_sleep() there before 37e1d9202225
("bpf: Replace cant_sleep() with cant_migrate()"). So perhaps one way to catch
bugs for sleepable progs is to add a __might_sleep() into __bpf_prog_enter_sleepable()
in order to trigger the assertion generally for DEBUG_ATOMIC_SLEEP configured
kernels when we're in non-sleepable sections? Still not perfect since the code
needs to be exercised first but better than nothing at all.

>> What about others like security_sock_rcv_skb() for example which could be
>> bh_lock_sock()'ed (or, generally hooks running in softirq context)?
> 
> ahh. it's in running in bh at that point? then it should be added to blacklist.

Yep.

Thanks,
Daniel
