Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385B234F3B1
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhC3Vq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhC3Vq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 17:46:56 -0400
X-Greylist: delayed 1226 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Mar 2021 14:46:56 PDT
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEE3C061574;
        Tue, 30 Mar 2021 14:46:56 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lRLrw-000CEQ-PW; Tue, 30 Mar 2021 23:25:48 +0200
Received: from [85.7.101.30] (helo=pc-6.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lRLrw-000KZf-CJ; Tue, 30 Mar 2021 23:25:48 +0200
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
Date:   Tue, 30 Mar 2021 23:25:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26125/Tue Mar 30 13:11:47 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/21 10:39 PM, Andrii Nakryiko wrote:
> On Sun, Mar 28, 2021 at 1:11 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
>> On Sun, Mar 28, 2021 at 10:12:40AM IST, Andrii Nakryiko wrote:
>>> Is there some succinct but complete enough documentation/tutorial/etc
>>> that I can reasonably read to understand kernel APIs provided by TC
>>> (w.r.t. BPF, of course). I'm trying to wrap my head around this and
>>> whether API makes sense or not. Please share links, if you have some.
>>
>> Hi Andrii,
>>
>> Unfortunately for the kernel API part, I couldn't find any when I was working
>> on this. So I had to read the iproute2 tc code (tc_filter.c, f_bpf.c,
>> m_action.c, m_bpf.c) and the kernel side bits (cls_api.c, cls_bpf.c, act_api.c,
>> act_bpf.c) to grok anything I didn't understand. There's also similar code in
>> libnl (lib/route/{act,cls}.c).
>>
>> Other than that, these resources were useful (perhaps you already went through
>> some/all of them):
>>
>> https://docs.cilium.io/en/latest/bpf/#tc-traffic-control
>> https://qmonnet.github.io/whirl-offload/2020/04/11/tc-bpf-direct-action/
>> tc(8), and tc-bpf(8) man pages
>>
>> I hope this is helpful!
> 
> Thanks! I'll take a look. Sorry, I'm a bit behind with all the stuff,
> trying to catch up.
> 
> I was just wondering if it would be more natural instead of having
> _dev _block variants and having to specify __u32 ifindex, __u32
> parent_id, __u32 protocol, to have some struct specifying TC
> "destination"? Maybe not, but I thought I'd bring this up early. So
> you'd have just bpf_tc_cls_attach(), and you'd so something like
> 
> bpf_tc_cls_attach(prog_fd, TC_DEV(ifindex, parent_id, protocol))
> 
> or
> 
> bpf_tc_cls_attach(prog_fd, TC_BLOCK(block_idx, protocol))
> 
> ? Or it's taking it too far?
> 
> But even if not, I think detaching can be unified between _dev and
> _block, can't it?

Do we even need the _block variant? I would rather prefer to take the chance
and make it as simple as possible, and only iff really needed extend with
other APIs, for example:

   bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS});

Internally, this will create the sch_clsact qdisc & cls_bpf filter instance
iff not present yet, and attach to a default prio 1 handle 1, and _always_ in
direct-action mode. This is /as simple as it gets/ and we don't need to bother
users with more complex tc/cls_bpf internals unless desired. For example,
extended APIs could add prio/parent so that multi-prog can be attached to a
single cls_bpf instance, but even that could be a second step, imho.

Thanks,
Daniel
