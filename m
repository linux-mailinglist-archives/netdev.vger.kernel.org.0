Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704A03675AD
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 01:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244020AbhDUXWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 19:22:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:47814 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhDUXWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 19:22:31 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZMAO-000G2g-Na; Thu, 22 Apr 2021 01:21:56 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZMAO-000XQA-EU; Thu, 22 Apr 2021 01:21:56 +0200
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org,
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
        netdev@vger.kernel.org
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net>
 <20210421230858.ruwqw5jvsy7cjioy@apollo>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <21c55619-e26d-d901-076e-20f55302c2fd@iogearbox.net>
Date:   Thu, 22 Apr 2021 01:21:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210421230858.ruwqw5jvsy7cjioy@apollo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26147/Wed Apr 21 13:06:05 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 1:08 AM, Kumar Kartikeya Dwivedi wrote:
> On Thu, Apr 22, 2021 at 04:29:28AM IST, Daniel Borkmann wrote:
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
>>>    #include "libbpf_common.h"
>>> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
>>>    LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>>>    LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>>> +/* Convenience macros for the clsact attach hooks */
>>> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
>>> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
>>
>> I would abstract those away into an enum, plus avoid having to pull in
>> linux/pkt_sched.h and linux/tc_act/tc_bpf.h from main libbpf.h header.
>>
>> Just add a enum { BPF_TC_DIR_INGRESS, BPF_TC_DIR_EGRESS, } and then the
>> concrete tc bits (TC_H_MAKE()) can be translated internally.
> 
> Ok, will do.
> 
>>> +struct bpf_tc_opts {
>>> +	size_t sz;
>>
>> Is this set anywhere?
> 
> This is needed by the OPTS_* infrastructure.
> 
>>> +	__u32 handle;
>>> +	__u32 class_id;
>>
>> I'd remove class_id from here as well given in direct-action a BPF prog can
>> set it if needed.
> 
> Ok, makes sense.
> 
>>> +	__u16 priority;
>>> +	bool replace;
>>> +	size_t :0;
>>
>> What's the rationale for this padding?
> 
> dde7b3f5f2f4 ("libbpf: Add explicit padding to bpf_xdp_set_link_opts")

Hm, fair enough.

>>> +};
>>> +
>>> +#define bpf_tc_opts__last_field replace
>>> +
>>> +/* Acts as a handle for an attached filter */
>>> +struct bpf_tc_attach_id {
>>
>> nit: maybe bpf_tc_ctx
>>
> 
> Noted.
> 
>>> +	__u32 handle;
>>> +	__u16 priority;
>>> +};
>>> +
>>> +struct bpf_tc_info {
>>> +	struct bpf_tc_attach_id id;
>>> +	__u16 protocol;
>>> +	__u32 chain_index;
>>> +	__u32 prog_id;
>>> +	__u8 tag[BPF_TAG_SIZE];
>>> +	__u32 class_id;
>>> +	__u32 bpf_flags;
>>> +	__u32 bpf_flags_gen;
>>
>> Given we do not yet have any setters e.g. for offload, etc, the one thing
>> I'd see useful and crucial initially is prog_id.
>>
>> The protocol, chain_index, and I would also include tag should be dropped.
> 
> A future user of this API needs to know the tag, so I would like to keep that.
> The rest we can drop, and probably document the default values explicitly.

Couldn't this be added along with the future patch for the [future] user?

The tag should be the tag of the prog itself, so if you have prog_id, you
could also retrieve the same tag from the prog. The tag was basically from
the early days where we didn't have bpf_prog_get_info_by_fd().

What does that future user need to do different here?

Thanks,
Daniel
