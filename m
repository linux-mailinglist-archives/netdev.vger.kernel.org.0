Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CB127B4EF
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgI1TCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:02:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:43584 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgI1TCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:02:52 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kMyQD-0006bv-Fd; Mon, 28 Sep 2020 21:02:49 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kMyQD-0003MY-8X; Mon, 28 Sep 2020 21:02:49 +0200
Subject: Re: [PATCH bpf-next v2 4/6] bpf, libbpf: add bpf_tail_call_static
 helper for bpf programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
References: <cover.1601303057.git.daniel@iogearbox.net>
 <9c4b6a19ced3e2ee6c6d28f5f3883cc7b2b02400.1601303057.git.daniel@iogearbox.net>
 <CAEf4BzYxSkjJzPVzOkOQkOVPUKri9aa69QGFrUdGjAf7f9Uf=w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <55eb1fc6-f02b-ae59-768c-c17295639601@iogearbox.net>
Date:   Mon, 28 Sep 2020 21:02:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYxSkjJzPVzOkOQkOVPUKri9aa69QGFrUdGjAf7f9Uf=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25941/Mon Sep 28 15:55:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/20 7:39 PM, Andrii Nakryiko wrote:
> On Mon, Sep 28, 2020 at 7:39 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Port of tail_call_static() helper function from Cilium's BPF code base [0]
>> to libbpf, so others can easily consume it as well. We've been using this
>> in production code for some time now. The main idea is that we guarantee
>> that the kernel's BPF infrastructure and JIT (here: x86_64) can patch the
>> JITed BPF insns with direct jumps instead of having to fall back to using
>> expensive retpolines. By using inline asm, we guarantee that the compiler
>> won't merge the call from different paths with potentially different
>> content of r2/r3.
>>
>> We're also using Cilium's __throw_build_bug() macro (here as: __bpf_unreachable())
>> in different places as a neat trick to trigger compilation errors when
>> compiler does not remove code at compilation time. This works for the BPF
>> back end as it does not implement the __builtin_trap().
>>
>>    [0] https://github.com/cilium/cilium/commit/f5537c26020d5297b70936c6b7d03a1e412a1035
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Andrii Nakryiko <andriin@fb.com>
>> ---
> 
> few optional nits below, but looks good to me:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
[...]

Thanks!

>> +/*
>> + * Helper function to perform a tail call with a constant/immediate map slot.
>> + */
>> +static __always_inline void
>> +bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)
> 
> nit: const void *ctx would work here, right? would avoid users having
> to do unnecessary casts in some cases

The bpf_tail_call() UAPI signature only has 'void *ctx' as well, so shouldn't
cause any issues as drop-in replacement wrt casts, but also ctx here is not always
a read-only [context] object either so it may potentially be a bit misleading to
users to convert it to const.
