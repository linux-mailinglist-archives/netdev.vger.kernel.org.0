Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C90333E0ED
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCPV5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:57:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:42774 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhCPV5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 17:57:20 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMHgh-0001W9-La; Tue, 16 Mar 2021 22:57:15 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMHgh-000Lt3-CZ; Tue, 16 Mar 2021 22:57:15 +0100
Subject: Re: [PATCH] libbpf: avoid inline hint definition from
 'linux/stddef.h'
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <20210314173839.457768-1-pctammela@gmail.com>
 <5083f82b-39fc-9d46-bcd0-3a6be2fc7f98@iogearbox.net>
 <CAEf4Bza3vs3P0+zua5j8kJwCDXeiA3Up+t8f58AqswceHca7cA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3b05d3c8-1f4a-194a-098f-0eb7ab43d455@iogearbox.net>
Date:   Tue, 16 Mar 2021 22:57:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza3vs3P0+zua5j8kJwCDXeiA3Up+t8f58AqswceHca7cA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26110/Tue Mar 16 12:05:23 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/21 10:34 PM, Andrii Nakryiko wrote:
> On Tue, Mar 16, 2021 at 2:01 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 3/14/21 6:38 PM, Pedro Tammela wrote:
>>> Linux headers might pull 'linux/stddef.h' which defines
>>> '__always_inline' as the following:
>>>
>>>      #ifndef __always_inline
>>>      #define __always_inline __inline__
>>>      #endif
>>>
>>> This becomes an issue if the program picks up the 'linux/stddef.h'
>>> definition as the macro now just hints inline to clang.
>>
>> How did the program end up including linux/stddef.h ? Would be good to
>> also have some more details on how we got here for the commit desc.
> 
> It's an UAPI header, so why not? Is there anything special about
> stddef.h that makes it unsuitable to be included?

Hm, fair enough, looks like linux/types.h already pulls it in, so no. We
defined our own stddef.h longer time ago, so looks like we never ran into
this issue.

>>> This change now enforces the proper definition for BPF programs
>>> regardless of the include order.
>>>
>>> Signed-off-by: Pedro Tammela <pctammela@gmail.com>
>>> ---
>>>    tools/lib/bpf/bpf_helpers.h | 7 +++++--
>>>    1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
>>> index ae6c975e0b87..5fa483c0b508 100644
>>> --- a/tools/lib/bpf/bpf_helpers.h
>>> +++ b/tools/lib/bpf/bpf_helpers.h
>>> @@ -29,9 +29,12 @@
>>>     */
>>>    #define SEC(NAME) __attribute__((section(NAME), used))
>>>
>>> -#ifndef __always_inline
>>> +/*
>>> + * Avoid 'linux/stddef.h' definition of '__always_inline'.
>>> + */
>>
>> I think the comment should have more details on 'why' we undef it as in
>> few months looking at it again, the next question to dig into would be
>> what was wrong with linux/stddef.h. Providing a better rationale would
>> be nice for readers here.
> 
> So for whatever reason commit bot didn't send notification, but I've
> already landed this yesterday. To me, with #undef + #define it's
> pretty clear that we "force-define" __always_inline exactly how we
> want it, but we can certainly add clarifying comment in the follow up,
> if you think it's needed.

Up to you, but given you applied it it's probably not worth the trouble;
missed it earlier given I didn't see the patchbot message in the thread
initially. :/

>>> +#undef __always_inline
>>>    #define __always_inline inline __attribute__((always_inline))
>>> -#endif
>>> +
>>>    #ifndef __noinline
>>>    #define __noinline __attribute__((noinline))
>>>    #endif
>>>
>>

