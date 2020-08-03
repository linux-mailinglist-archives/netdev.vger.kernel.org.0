Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB9123ABF0
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgHCR4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:56:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:49624 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgHCR4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:56:10 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2egx-0008BO-HR; Mon, 03 Aug 2020 19:56:07 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2egx-00013C-BR; Mon, 03 Aug 2020 19:56:07 +0200
Subject: Re: [PATCH v5 bpf-next 3/4] bpf: Add kernel module with user mode
 driver that populates bpffs.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20200802222950.34696-1-alexei.starovoitov@gmail.com>
 <20200802222950.34696-4-alexei.starovoitov@gmail.com>
 <33d2db5b-3f81-e384-bed8-96f1d7f1d4c7@iogearbox.net>
 <430839eb-2761-0c1a-4b99-dffb07b9f502@iogearbox.net>
 <736dc34e-254d-de46-ac91-512029f675e7@iogearbox.net>
 <CAEf4BzY-RHiG+0u1Ug+k0VC01Fqp3BUQ60OenRv+na4fuYRW=Q@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <181ce3e4-c960-3470-5c08-3e56ea7f28b2@iogearbox.net>
Date:   Mon, 3 Aug 2020 19:56:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY-RHiG+0u1Ug+k0VC01Fqp3BUQ60OenRv+na4fuYRW=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25893/Mon Aug  3 17:01:47 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 7:51 PM, Andrii Nakryiko wrote:
> On Mon, Aug 3, 2020 at 10:41 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 8/3/20 7:34 PM, Daniel Borkmann wrote:
>>> On 8/3/20 7:15 PM, Daniel Borkmann wrote:
>>>> On 8/3/20 12:29 AM, Alexei Starovoitov wrote:
>>>>> From: Alexei Starovoitov <ast@kernel.org>
>>>>>
>>>>> Add kernel module with user mode driver that populates bpffs with
>>>>> BPF iterators.
>>>>>
> 
> [...]
> 
>>     CC      kernel/events/ring_buffer.o
>>     CC [U]  kernel/bpf/preload/./../../../tools/lib/bpf/bpf.o
>>     CC [U]  kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.o
>> In file included from kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.c:47:0:
>> ./tools/include/tools/libc_compat.h:11:21: error: static declaration of ‘reallocarray’ follows non-static declaration
>>    static inline void *reallocarray(void *ptr, size_t nmemb, size_t size)
>>                        ^~~~~~~~~~~~
>> In file included from kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.c:16:0:
>> /usr/include/stdlib.h:558:14: note: previous declaration of ‘reallocarray’ was here
>>    extern void *reallocarray (void *__ptr, size_t __nmemb, size_t __size)
>>                 ^~~~~~~~~~~~
> 
> A bit offtopic. reallocarray and related feature detection causes so
> much hassle, that I'm strongly tempted to just get rid of it in the
> entire libbpf. Or just unconditionally implement libbpf-specific
> reallocarray function. Any objections?

Agree that it's continuously causing pain; no objection from my side to have
something libbpf-specifc for example (along with a comment on /why/ we're not
reusing it anymore).

>>     CC      kernel/user-return-notifier.o
>> scripts/Makefile.userprogs:43: recipe for target 'kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.o' failed
>> make[3]: *** [kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.o] Error 1
>> scripts/Makefile.build:497: recipe for target 'kernel/bpf/preload' failed
>> make[2]: *** [kernel/bpf/preload] Error 2
>> scripts/Makefile.build:497: recipe for target 'kernel/bpf' failed
>> make[1]: *** [kernel/bpf] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>> [...]
