Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA16054BBDC
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiFNUeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiFNUeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:34:14 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126F724942;
        Tue, 14 Jun 2022 13:34:11 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1DEl-000Dyp-5G; Tue, 14 Jun 2022 22:34:07 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1DEk-000FcU-Sh; Tue, 14 Jun 2022 22:34:06 +0200
Subject: Re: [PATCH bpf-next 1/2] Revert "bpftool: Use libbpf 1.0 API mode
 instead of RLIMIT_MEMLOCK"
To:     Quentin Monnet <quentin@isovalent.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20220610112648.29695-1-quentin@isovalent.com>
 <20220610112648.29695-2-quentin@isovalent.com> <YqNsWAH24bAIPjqy@google.com>
 <cb05a59e-07d5-ddd1-b028-82133faaf67e@isovalent.com>
 <CAKH8qBvvq0f+D8BXChw_8krH896J_cYg0yhRfnDOSO_U1n394w@mail.gmail.com>
 <71b56050-11ad-bd06-09c9-1a8c61b4c1b4@isovalent.com>
 <CAKH8qBsFyakQRd1q6XWggdv4F5+HrHoC4njg9jQFDOfq+kRBCQ@mail.gmail.com>
 <CALOAHbCvWzOJ169fPTCp1KsFpkEVukKgGnH4mDeYGOEv6hsEpQ@mail.gmail.com>
 <e9aa57d2-4ce7-23f2-0ba1-ea58f3254353@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5cd8428d-5d09-3676-cd18-93746d8961e2@iogearbox.net>
Date:   Tue, 14 Jun 2022 22:34:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e9aa57d2-4ce7-23f2-0ba1-ea58f3254353@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26572/Tue Jun 14 10:17:51 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/22 4:20 PM, Quentin Monnet wrote:
> 2022-06-14 20:37 UTC+0800 ~ Yafang Shao <laoar.shao@gmail.com>
>> On Sat, Jun 11, 2022 at 1:17 AM Stanislav Fomichev <sdf@google.com> wrote:
>>> On Fri, Jun 10, 2022 at 10:00 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>> 2022-06-10 09:46 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
>>>>> On Fri, Jun 10, 2022 at 9:34 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>>> 2022-06-10 09:07 UTC-0700 ~ sdf@google.com
>>>>>>> On 06/10, Quentin Monnet wrote:
>>>>>>>> This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.
>>>>>>>
>>>>>>>> In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
>>>>>>>> RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
>>>>>>>> kernel has switched to memcg-based memory accounting. Thanks to the
>>>>>>>> LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
>>>>>>>> with other systems and ask libbpf to raise the limit for us if
>>>>>>>> necessary.
>>>>>>>
>>>>>>>> How do we know if memcg-based accounting is supported? There is a probe
>>>>>>>> in libbpf to check this. But this probe currently relies on the
>>>>>>>> availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
>>>>>>>> landed in the same kernel version as the memory accounting change. This
>>>>>>>> works in the generic case, but it may fail, for example, if the helper
>>>>>>>> function has been backported to an older kernel. This has been observed
>>>>>>>> for Google Cloud's Container-Optimized OS (COS), where the helper is
>>>>>>>> available but rlimit is still in use. The probe succeeds, the rlimit is
>>>>>>>> not raised, and probing features with bpftool, for example, fails.
>>>>>>>
>>>>>>>> A patch was submitted [0] to update this probe in libbpf, based on what
>>>>>>>> the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
>>>>>>>> 0, attempt to load a BPF object, and reset the rlimit. But it may induce
>>>>>>>> some hard-to-debug flakiness if another process starts, or the current
>>>>>>>> application is killed, while the rlimit is reduced, and the approach was
>>>>>>>> discarded.
>>>>>>>
>>>>>>>> As a workaround to ensure that the rlimit bump does not depend on the
>>>>>>>> availability of a given helper, we restore the unconditional rlimit bump
>>>>>>>> in bpftool for now.
>>>>>>>
>>>>>>>> [0]
>>>>>>>> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
>>>>>>>> [1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
>>>>>>>
>>>>>>>> Cc: Yafang Shao <laoar.shao@gmail.com>
>>>>>>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>>>>>>>> ---
>>>>>>>>    tools/bpf/bpftool/common.c     | 8 ++++++++
>>>>>>>>    tools/bpf/bpftool/feature.c    | 2 ++
>>>>>>>>    tools/bpf/bpftool/main.c       | 6 +++---
>>>>>>>>    tools/bpf/bpftool/main.h       | 2 ++
>>>>>>>>    tools/bpf/bpftool/map.c        | 2 ++
>>>>>>>>    tools/bpf/bpftool/pids.c       | 1 +
>>>>>>>>    tools/bpf/bpftool/prog.c       | 3 +++
>>>>>>>>    tools/bpf/bpftool/struct_ops.c | 2 ++
>>>>>>>>    8 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
>>>>>>>> index a45b42ee8ab0..a0d4acd7c54a 100644
>>>>>>>> --- a/tools/bpf/bpftool/common.c
>>>>>>>> +++ b/tools/bpf/bpftool/common.c
>>>>>>>> @@ -17,6 +17,7 @@
>>>>>>>>    #include <linux/magic.h>
>>>>>>>>    #include <net/if.h>
>>>>>>>>    #include <sys/mount.h>
>>>>>>>> +#include <sys/resource.h>
>>>>>>>>    #include <sys/stat.h>
>>>>>>>>    #include <sys/vfs.h>
>>>>>>>
>>>>>>>> @@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
>>>>>>>>        return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
>>>>>>>>    }
>>>>>>>
>>>>>>>> +void set_max_rlimit(void)
>>>>>>>> +{
>>>>>>>> +    struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
>>>>>>>> +
>>>>>>>> +    setrlimit(RLIMIT_MEMLOCK, &rinf);
>>>>>>>
>>>>>>> Do you think it might make sense to print to stderr some warning if
>>>>>>> we actually happen to adjust this limit?
>>>>>>>
>>>>>>> if (getrlimit(MEMLOCK) != RLIM_INFINITY) {
>>>>>>>      fprintf(stderr, "Warning: resetting MEMLOCK rlimit to
>>>>>>>      infinity!\n");
>>>>>>>      setrlimit(RLIMIT_MEMLOCK, &rinf);
>>>>>>> }
>>>>>>>
>>>>>>> ?
>>>>>>>
>>>>>>> Because while it's nice that we automatically do this, this might still
>>>>>>> lead to surprises for some users. OTOH, not sure whether people
>>>>>>> actually read those warnings? :-/
>>>>>>
>>>>>> I'm not strictly opposed to a warning, but I'm not completely sure this
>>>>>> is desirable.
>>>>>>
>>>>>> Bpftool has raised the rlimit for a long time, it changed only in April,
>>>>>> so I don't think it would come up as a surprise for people who have used
>>>>>> it for a while. I think this is also something that several other
>>>>>> BPF-related applications (BCC I think?, bpftrace, Cilium come to mind)
>>>>>> have been doing too.
>>>>>
>>>>> In this case ignore me and let's continue doing that :-)
>>>>>
>>>>> Btw, eventually we'd still like to stop doing that I'd presume?
>>>>
>>>> Agreed. I was thinking either finding a way to improve the probe in
>>>> libbpf, or waiting for some more time until 5.11 gets old, but this may
>>>> take years :/
>>>>
>>>>> Should
>>>>> we at some point follow up with something like:
>>>>>
>>>>> if (kernel_version >= 5.11) { don't touch memlock; }
>>>>>
>>>>> ?
>>>>>
>>>>> I guess we care only about <5.11 because of the backports, but 5.11+
>>>>> kernels are guaranteed to have memcg.
>>>>
>>>> You mean from uname() and parsing the release? Yes I suppose we could do
>>>> that, can do as a follow-up.
>>>
>>> Yeah, uname-based, I don't think we can do better? Given that probing
>>> is problematic as well :-(
>>> But idk, up to you.
>>
>> Agreed with the uname-based solution. Another possible solution is to
>> probe the member 'memcg' in struct bpf_map, in case someone may
>> backport memcg-based  memory accounting, but that will be a little
>> over-engineering. The uname-based solution is simple and can work.
> 
> Thanks! Yes, memcg would be more complex: the struct is not exposed to
> user space, and BTF is not a hard dependency for bpftool. I'll work on
> the uname-based test as a follow-up to this set.

How would this work for things like RHEL? Maybe two potential workarounds ...
1) We could use a different helper for the probing and see how far we get with
it.. though not great, probably still rare enough that we would run into it
again. 2) Maybe we could create a temp memcg and check whether we get accounted
against it on prog load (e.g. despite high rlimit)?

Thanks,
Daniel
