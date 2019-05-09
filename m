Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64BF18940
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 13:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfEILtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 07:49:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:46058 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfEILtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 07:49:32 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hOhYE-0001ym-UL; Thu, 09 May 2019 13:49:27 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hOhYE-0000XM-ED; Thu, 09 May 2019 13:49:26 +0200
Subject: Re: Question about seccomp / bpf
To:     Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kees Cook <keescook@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jann Horn <jannh@google.com>, Will Drewry <wad@chromium.org>
References: <CANn89iL_XLb5C-+DY5PRhneZDJv585xfbLtiEVc3-ejzNNXaVg@mail.gmail.com>
 <20190508230941.6rqccgijqzkxmz4t@ast-mbp>
 <CANn89iL_1n8Lb5yCEk3ZrBsUtPPWPZ=0BiELUo+jyBWfLfaAzg@mail.gmail.com>
 <20190509044720.fxlcldi74atev5id@ast-mbp>
 <CANn89i+v52ktezz5J_0of_EvTUozf86rP1Uh36HpbHf33uzDJg@mail.gmail.com>
 <CANn89iK8e8ROW8CrtTDq9-_bFeg2MdeqAdjf10i6HiwKuaZi=g@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e525ec9d-df46-4280-b1c8-486a809f61e6@iogearbox.net>
Date:   Thu, 9 May 2019 13:49:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK8e8ROW8CrtTDq9-_bFeg2MdeqAdjf10i6HiwKuaZi=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25444/Thu May  9 09:57:18 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/09/2019 12:58 PM, Eric Dumazet wrote:
> On Thu, May 9, 2019 at 3:52 AM Eric Dumazet <edumazet@google.com> wrote:
>> On Wed, May 8, 2019 at 9:47 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>> On Wed, May 08, 2019 at 04:17:29PM -0700, Eric Dumazet wrote:
>>>> On Wed, May 8, 2019 at 4:09 PM Alexei Starovoitov
>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>> On Wed, May 08, 2019 at 02:21:52PM -0700, Eric Dumazet wrote:
>>>>>> Hi Alexei and Daniel
>>>>>>
>>>>>> I have a question about seccomp.
>>>>>>
>>>>>> It seems that after this patch, seccomp no longer needs a helper
>>>>>> (seccomp_bpf_load())
>>>>>>
>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bd4cf0ed331a275e9bf5a49e6d0fd55dffc551b8
>>>>>>
>>>>>> Are we detecting that a particular JIT code needs to call at least one
>>>>>> function from the kernel at all ?
>>>>>
>>>>> Currently we don't track such things and trying very hard to avoid
>>>>> any special cases for classic vs extended.
>>>>>
>>>>>> If the filter contains self-contained code (no call, just inline
>>>>>> code), then we could use any room in whole vmalloc space,
>>>>>> not only from the modules (which is something like 2GB total on x86_64)
>>>>>
>>>>> I believe there was an effort to make bpf progs and other executable things
>>>>> to be everywhere too, but I lost the track of it.
>>>>> It's not that hard to tweak x64 jit to emit 64-bit calls to helpers
>>>>> when delta between call insn and a helper is more than 32-bit that fits
>>>>> into call insn. iirc there was even such patch floating around.
>>>>>
>>>>> but what motivated you question? do you see 2GB space being full?!
>>>>
>>>> A customer seems to hit the limit, with about 75,000 threads,
>>>> each one having a seccomp filter with 6 pages (plus one guard page
>>>> given by vmalloc)
>>>
>>> Since cbpf doesn't have "fd as a program" concept I suspect
>>> the same program was loaded 75k times. What a waste of kernel memory.
>>> And, no, we're not going to extend or fix cbpf for this.
>>> cbpf is frozen. seccomp needs to start using ebpf.
>>> It can have one program to secure all threads.
>>> If necessary single program can be customized via bpf maps
>>> for each thread.
>>
>> Yes,  docker seems to have a very generic implementation and  should
>> probably be fixed
>> ( https://github.com/moby/moby/blob/v17.03.2-ce/profiles/seccomp/seccomp.go )
> 
> Even if the seccomp program was optimized to a few bytes, it would
> still consume at least 2 pages in module vmalloc space,
> so the limit in number of concurrent programs would be around 262,144
> 
> We might ask seccomp guys to detect that the same program is used, by
> maintaining a hash of already loaded ones.
> ( I see struct seccomp_filter has a @usage refcount_t )

+1, that would indeed be worth to pursue as a short term solution.
