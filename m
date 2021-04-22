Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCEA367FD2
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 13:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbhDVLvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 07:51:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:51394 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhDVLvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 07:51:47 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZXrS-000Acb-RL; Thu, 22 Apr 2021 13:51:10 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZXrS-000GSk-Gz; Thu, 22 Apr 2021 13:51:10 +0200
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <CAEf4BzYj_pODiQ_Xkdz_czAj3iaBcRhudeb_kJ4M2SczA_jDjA@mail.gmail.com>
 <87tunzh11d.fsf@toke.dk> <bd2ed7ed-a502-bee5-0a56-0f3064ee2be5@iogearbox.net>
 <875z0ehej8.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ab19b29f-f7a7-5f4b-001f-28d57c6c203f@iogearbox.net>
Date:   Thu, 22 Apr 2021 13:51:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <875z0ehej8.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26148/Thu Apr 22 13:06:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 11:08 AM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>> On 4/21/21 9:48 PM, Toke Høiland-Jørgensen wrote:
>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>>> On Tue, Apr 20, 2021 at 12:37 PM Kumar Kartikeya Dwivedi
>>>> <memxor@gmail.com> wrote:
>> [...]
>>>>> ---
>>>>>    tools/lib/bpf/libbpf.h   |  44 ++++++
>>>>>    tools/lib/bpf/libbpf.map |   3 +
>>>>>    tools/lib/bpf/netlink.c  | 319 ++++++++++++++++++++++++++++++++++++++-
>>>>>    3 files changed, 360 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>>>>> index bec4e6a6e31d..b4ed6a41ea70 100644
>>>>> --- a/tools/lib/bpf/libbpf.h
>>>>> +++ b/tools/lib/bpf/libbpf.h
>>>>> @@ -16,6 +16,8 @@
>>>>>    #include <stdbool.h>
>>>>>    #include <sys/types.h>  // for size_t
>>>>>    #include <linux/bpf.h>
>>>>> +#include <linux/pkt_sched.h>
>>>>> +#include <linux/tc_act/tc_bpf.h>
>>>>
>>>> apart from those unused macros below, are these needed in public API header?
>>>>
>>>>>    #include "libbpf_common.h"
>>>>>
>>>>> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
>>>>>    LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>>>>>    LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>>>>>
>>>>> +/* Convenience macros for the clsact attach hooks */
>>>>> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
>>>>> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
>>>>
>>>> these seem to be used only internally, why exposing them in public
>>>> API?
>>>
>>> No they're "aliases" for when you want to attach the filter directly to
>>> the interface (and thus install the clsact qdisc as the root). You can
>>> also use the filter with an existing qdisc (most commonly HTB), in which
>>> case you need to specify the qdisc handle as the root. We have a few
>>> examples of this use case:
>>>
>>> https://github.com/xdp-project/bpf-examples/tree/master/traffic-pacing-edt
>>> and
>>> https://github.com/xdp-project/xdp-cpumap-tc
>>
>> I'm a bit puzzled, could you elaborate on your use case on why you wouldn't
>> use the tc egress hook for those especially given it's guaranteed to run
>> outside of root qdisc lock?
> 
> Jesper can correct me if I'm wrong, but I think the first one of the
> links above is basically his implementation of just that EDT-based
> shaper. And it works reasonably well, except you don't get the nice
> per-flow scheduling and sparse flow prioritisation like in FQ-CoDel
> unless you implement that yourself in BPF when you set the timestamps
> (and that is by no means trivial to implement).
> 
> So if you want to use any of the features of the existing qdiscs (I have
> also been suggesting to people that they use tc_bpf if they want to
> customise sch_cake's notion of flows or shaping tiers), you need to be
> able to attach the filter to an existing qdisc. Sure, this means you're
> still stuck behind the qdisc lock, but for some applications that is
> fine (not everything is a data centre, some devices don't have that many
> CPUs anyway; and as the second example above shows, you can get around
> the qdisc lock by some clever use of partitioning of flows using
> cpumap).
> 
> So what this boils down to is, we should keep the 'parent' parameter not
> just as an egress/ingress enum, but also as a field the user can fill
> out. I'm fine with moving the latter into the opts struct, though, so
> maybe the function parameter can be an enum like:
> 
> enum bpf_tc_attach_point {
>    BPF_TC_CLSACT_INGRESS,
>    BPF_TC_CLSACT_EGRESS,
>    BPF_TC_QDISC_PARENT
> };
> 
> where if you set the last one you have to fill in the parent in opts?

Fair enough, I still think this is a bit backwards and should be discouraged
given the constraints, but if you have an actual need for it ... I'd rather
simplify API naming, the fact that it's clsact is an implementation detail
and shouldn't matter to a user, like:

enum bpf_tc_attach_point {
	BPF_TC_INGRESS,
	BPF_TC_EGRESS,
	BPF_TC_CUSTOM_PARENT,
};

For BPF_TC_INGRESS and BPF_TC_EGRESS, I would enforce opts parent parameter
to be /zero/ from the API.

Thanks,
Daniel
