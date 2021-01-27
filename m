Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02FE30675F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhA0W6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 17:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhA0Wzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 17:55:53 -0500
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D273C0617AA;
        Wed, 27 Jan 2021 14:49:33 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4tcF-000CrN-Ho; Wed, 27 Jan 2021 23:48:47 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4tcF-000MlJ-9A; Wed, 27 Jan 2021 23:48:47 +0100
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>, yhs@fb.com
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com>
 <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
 <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
 <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b646c7b5-be91-79c6-4538-e41a10d4b9ae@iogearbox.net>
Date:   Wed, 27 Jan 2021 23:48:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26062/Wed Jan 27 13:26:15 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/21 7:00 PM, Alexei Starovoitov wrote:
> On Tue, Jan 26, 2021 at 11:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>>                ret = PTR_ERR(l_new);
>>>> +             if (ret == -EAGAIN) {
>>>> +                     htab_unlock_bucket(htab, b, hash, flags);
>>>> +                     htab_gc_elem(htab, l_old);
>>>> +                     mod_delayed_work(system_unbound_wq, &htab->gc_work, 0);
>>>> +                     goto again;
>>>
>>> Also this one looks rather worrying, so the BPF prog is stalled here, loop-waiting
>>> in (e.g. XDP) hot path for system_unbound_wq to kick in to make forward progress?
>>
>> In this case, the old one is scheduled for removal in GC, we just wait for GC
>> to finally remove it. It won't stall unless GC itself or the worker scheduler is
>> wrong, both of which should be kernel bugs.
>>
>> If we don't do this, users would get a -E2BIG when it is not too big. I don't
>> know a better way to handle this sad situation, maybe returning -EBUSY
>> to users and let them call again?
> 
> I think using wq for timers is a non-starter.
> Tying a hash/lru map with a timer is not a good idea either.

Thinking some more, given we have jiffies64 helper and atomic ops for BPF by now,
we would technically only need the ability to delete entries via bpf iter progs
(d6c4503cc296 ("bpf: Implement bpf iterator for hash maps")) which could then be
kicked off from user space at e.g. dynamic intervals which would be the equivalent
for the wq in here. That patch could then be implemented this way. I presume
the ability to delete map entries from bpf iter progs would be generic and useful
enough anyway.

> I think timers have to be done as independent objects similar to
> how the kernel uses them.
> Then there will be no question whether lru or hash map needs it.
> The bpf prog author will be able to use timers with either.
> The prog will be able to use timers without hash maps too.
> 
> I'm proposing a timer map where each object will go through
> bpf_timer_setup(timer, callback, flags);
> where "callback" is a bpf subprogram.
> Corresponding bpf_del_timer and bpf_mod_timer would work the same way
> they are in the kernel.
> The tricky part is kernel style of using from_timer() to access the
> object with additional info.

Would this mean N timer objs for N map elems? I presume not given this could be
racy and would have huge extra mem overhead. Either way, timer obj could work, but
then at the same time you could probably also solve it with the above; it's not
like you need the timer to kick in at some /exact/ time, but rather at some point
to clean up stale entries before the map gets full and worst case refuses updates
for new entries. (In the ideal case though we wouldn't need the extra effort to
search deeply for elements w/o penalizing the fast-path lookup costs too much when
walking the bucket.)

> I think bpf timer map can model it the same way.
> At map creation time the value_size will specify the amount of extra
> bytes necessary.
> Another alternative is to pass an extra data argument to a callback.
