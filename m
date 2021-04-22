Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DC136836A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhDVPgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:36:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:59250 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbhDVPgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 11:36:18 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZbMi-000EgG-8z; Thu, 22 Apr 2021 17:35:40 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZbMh-000XNf-W9; Thu, 22 Apr 2021 17:35:40 +0200
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
 <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net>
 <CAEf4Bzai3maV8E9eWi1fc8fgaeC7qFg7_-N_WdLH4ukv302bhg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b7ace8c2-0147-fde7-d319-479be1e2a05e@iogearbox.net>
Date:   Thu, 22 Apr 2021 17:35:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzai3maV8E9eWi1fc8fgaeC7qFg7_-N_WdLH4ukv302bhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26148/Thu Apr 22 13:06:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 5:43 AM, Andrii Nakryiko wrote:
> On Wed, Apr 21, 2021 at 3:59 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 4/20/21 9:37 PM, Kumar Kartikeya Dwivedi wrote:
>> [...]
>>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>>> index bec4e6a6e31d..b4ed6a41ea70 100644
>>> --- a/tools/lib/bpf/libbpf.h
>>> +++ b/tools/lib/bpf/libbpf.h
>>> @@ -16,6 +16,8 @@
>>>    #include <stdbool.h>
>>>    #include <sys/types.h>  // for size_t
>>>    #include <linux/bpf.h>
>>> +#include <linux/pkt_sched.h>
>>> +#include <linux/tc_act/tc_bpf.h>
>>>
>>>    #include "libbpf_common.h"
>>>
>>> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
>>>    LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>>>    LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>>>
>>> +/* Convenience macros for the clsact attach hooks */
>>> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
>>> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
>>
>> I would abstract those away into an enum, plus avoid having to pull in
>> linux/pkt_sched.h and linux/tc_act/tc_bpf.h from main libbpf.h header.
>>
>> Just add a enum { BPF_TC_DIR_INGRESS, BPF_TC_DIR_EGRESS, } and then the
>> concrete tc bits (TC_H_MAKE()) can be translated internally.
>>
>>> +struct bpf_tc_opts {
>>> +     size_t sz;
>>
>> Is this set anywhere?
>>
>>> +     __u32 handle;
>>> +     __u32 class_id;
>>
>> I'd remove class_id from here as well given in direct-action a BPF prog can
>> set it if needed.
>>
>>> +     __u16 priority;
>>> +     bool replace;
>>> +     size_t :0;
>>
>> What's the rationale for this padding?
>>
>>> +};
>>> +
>>> +#define bpf_tc_opts__last_field replace
>>> +
>>> +/* Acts as a handle for an attached filter */
>>> +struct bpf_tc_attach_id {
>>
>> nit: maybe bpf_tc_ctx
> 
> ok, so wait. It seems like apart from INGRESS|EGRESS enum and ifindex,
> everything else is optional and/or has some sane defaults, right? So
> this bpf_tc_attach_id or bpf_tc_ctx seems a bit artificial construct
> and it will cause problems for extending this.
> 
> So if my understanding is correct, I'd get rid of it completely. As I
> said previously, opts allow returning parameters back, so if user
> didn't specify handle and priority and kernel picks values on user's
> behalf, we can return them in the same opts fields.
> 
> For detach, again, ifindex and INGRESS|EGRESS is sufficient, but if
> user want to provide more detailed parameters, we should do that
> through extensible opts. That way we can keep growing this easily,
> plus simple cases will remain simple.
> 
> Similarly bpf_tc_info below, there is no need to have struct
> bpf_tc_attach_id id; field, just have handle and priority right there.
> And bpf_tc_info should use OPTS framework for extensibility (though
> opts name doesn't fit it very well, but it is still nice for
> extensibility and for doing optional input/output params).
> 
> Does this make sense? Am I missing something crucial here?

I would probably keep the handle + priority in there; maybe if both are 0,
we could fix it to some default value internally, but without those it might
be a bit hard if people want to build a 'pipeline' of cls_bpf progs if they
need/want to.

Potentially, one could fixate the handle itself, and then allow to specify
different priorities for it such that when a BPF prog returns a TC_ACT_UNSPEC,
it will exec the next one inside that cls_bpf instance, every other TC_ACT_*
opcode will terminate the processing. Technically, only priority would really
be needed (unless you combine multiple different classifiers from tc side on
the ingress/egress hook which is not great to begin with, tbh).

> The general rule with any new structs added to libbpf APIs is to
> either be 100% (ok, 99.99%) sure that they will never be changed, or
> do forward/backward compatible OPTS. Any other thing is pain and calls
> for symbol versioning, which we are trying really hard to avoid.
> 
>>> +     __u32 handle;
>>> +     __u16 priority;
>>> +};
>>> +
>>> +struct bpf_tc_info {
>>> +     struct bpf_tc_attach_id id;
>>> +     __u16 protocol;
>>> +     __u32 chain_index;
>>> +     __u32 prog_id;
>>> +     __u8 tag[BPF_TAG_SIZE];
>>> +     __u32 class_id;
>>> +     __u32 bpf_flags;
>>> +     __u32 bpf_flags_gen;
>>
>> Given we do not yet have any setters e.g. for offload, etc, the one thing
>> I'd see useful and crucial initially is prog_id.
>>
>> The protocol, chain_index, and I would also include tag should be dropped.
>> Similarly class_id given my earlier statement, and flags I would extend once
>> this lib API would support offloading progs.
>>
>>> +};
>>> +
>>> +/* id is out parameter that will be written to, it must not be NULL */
>>> +LIBBPF_API int bpf_tc_attach(int fd, __u32 ifindex, __u32 parent_id,
>>> +                          const struct bpf_tc_opts *opts,
>>> +                          struct bpf_tc_attach_id *id);
>>> +LIBBPF_API int bpf_tc_detach(__u32 ifindex, __u32 parent_id,
>>> +                          const struct bpf_tc_attach_id *id);
>>> +LIBBPF_API int bpf_tc_get_info(__u32 ifindex, __u32 parent_id,
>>> +                            const struct bpf_tc_attach_id *id,
>>> +                            struct bpf_tc_info *info);
>>
>> As per above, for parent_id I'd replace with dir enum.
>>
>>> +
>>>    #ifdef __cplusplus
>>>    } /* extern "C" */
>>>    #endif

