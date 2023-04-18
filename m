Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BFF6E5628
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 03:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjDRBDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 21:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDRBDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 21:03:45 -0400
Received: from out-53.mta1.migadu.com (out-53.mta1.migadu.com [IPv6:2001:41d0:203:375::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D9D3581
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 18:03:43 -0700 (PDT)
Message-ID: <a4591e85-d58b-0efd-c8a4-2652dc69ff68@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681779821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6L4XXjJ7DAIawwAHN6exDhyLIgvinWJ7u4alQvnINk=;
        b=lrWoVAvN2dp4uPEXlR77OB9JFoLC9kWgFsZ9/4nEg+fkkX22rpYNjZ5BF5XaMVYgdbk15j
        yhdXAjHD9Ey+WsBnri+bIiW4dwJXCnhqcJgCMf+C4tMtcF2XvUj3AqxgOBy6x/dojejDj/
        Ae2yiGOgVqeW9s9fpj36dJzyQNjz8Es=
Date:   Mon, 17 Apr 2023 18:03:35 -0700
MIME-Version: 1.0
Subject: handling unsupported optlen in cgroup bpf getsockopt: (was [PATCH
 net-next v4 2/4] net: socket: add sockopts blacklist for BPF cgroup hook)
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org,
        Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        bpf <bpf@vger.kernel.org>
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com>
 <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
 <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
 <CAKH8qBt+xPygUVPMUuzbi1HCJuxc4gYOdU6JkrFmSouRQgoG6g@mail.gmail.com>
 <ZDoEG0VF6fb9y0EC@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <ZDoEG0VF6fb9y0EC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/23 6:55 PM, Stanislav Fomichev wrote:
> On 04/13, Stanislav Fomichev wrote:
>> On Thu, Apr 13, 2023 at 7:38 AM Aleksandr Mikhalitsyn
>> <aleksandr.mikhalitsyn@canonical.com> wrote:
>>>
>>> On Thu, Apr 13, 2023 at 4:22 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>
>>>> On Thu, Apr 13, 2023 at 3:35 PM Alexander Mikhalitsyn
>>>> <aleksandr.mikhalitsyn@canonical.com> wrote:
>>>>>
>>>>> During work on SO_PEERPIDFD, it was discovered (thanks to Christian),
>>>>> that bpf cgroup hook can cause FD leaks when used with sockopts which
>>>>> install FDs into the process fdtable.
>>>>>
>>>>> After some offlist discussion it was proposed to add a blacklist of
>>>>
>>>> We try to replace this word by either denylist or blocklist, even in changelogs.
>>>
>>> Hi Eric,
>>>
>>> Oh, I'm sorry about that. :( Sure.
>>>
>>>>
>>>>> socket options those can cause troubles when BPF cgroup hook is enabled.
>>>>>
>>>>
>>>> Can we find the appropriate Fixes: tag to help stable teams ?
>>>
>>> Sure, I will add next time.
>>>
>>> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
>>>
>>> I think it's better to add Stanislav Fomichev to CC.
>>
>> Can we use 'struct proto' bpf_bypass_getsockopt instead? We already
>> use it for tcp zerocopy, I'm assuming it should work in this case as
>> well?
> 
> Jakub reminded me of the other things I wanted to ask here bug forgot:
> 
> - setsockopt is probably not needed, right? setsockopt hook triggers
>    before the kernel and shouldn't leak anything
> - for getsockopt, instead of bypassing bpf completely, should we instead
>    ignore the error from the bpf program? that would still preserve
>    the observability aspect

stealing this thread to discuss the optlen issue which may make sense to bypass 
also.

There has been issue with optlen. Other than this older post related to optlen > 
PAGE_SIZE: 
https://lore.kernel.org/bpf/5c8b7d59-1f28-2284-f7b9-49d946f2e982@linux.dev/, the 
recent one related to optlen that we have seen is NETLINK_LIST_MEMBERSHIPS. The 
userspace passed in optlen == 0 and the kernel put the expected optlen (> 0) and 
'return 0;' to userspace. The userspace intention is to learn the expected 
optlen. This makes 'ctx.optlen > max_optlen' and 
__cgroup_bpf_run_filter_getsockopt() ends up returning -EFAULT to the userspace 
even the bpf prog has not changed anything.

Does it make sense to also bypass the bpf prog when 'ctx.optlen > max_optlen' 
for now (and this can use a separate patch which as usual requires a bpf selftests)?

In the future, does it make sense to have a specific cgroup-bpf-prog (a specific 
attach type?) that only uses bpf_dynptr kfunc to access the optval such that it 
can enforce read-only for some optname and potentially also track if bpf-prog 
has written a new optval? The bpf-prog can only return 1 (OK) and only allows 
using bpf_set_retval() instead. Likely there is still holes but could be a seed 
of thought to continue polishing the idea.


> - or maybe we can even have a per-proto bpf_getsockopt_cleanup call that
>    gets called whenever bpf returns an error to make sure protocols have
>    a chance to handle that condition (and free the fd)
> 


