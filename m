Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D102B53BB
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbgKPVVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:21:54 -0500
Received: from mail.efficios.com ([167.114.26.124]:57478 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733296AbgKPVVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 16:21:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 815862D1045;
        Mon, 16 Nov 2020 16:21:52 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id j56jjRegskv2; Mon, 16 Nov 2020 16:21:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 12C6C2D1044;
        Mon, 16 Nov 2020 16:21:52 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 12C6C2D1044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605561712;
        bh=XDeZWiiEdVupnqTwdsUVCKsTQx0J+rcTBCNULwSCLng=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=piBSfANJiYd3l6RUSk1gUZS4ILARLuMNTSv+D6nOrM9wvLV6rDwvncvSyJbTofzKW
         AqOi0laougQj2dfm9qnnSH8On9gWJH6LA/1WddiARfQejfLCcn3k0tE5lZD19/07qD
         giAzDn8NXPRR2LT6TV8v2KwBvbTrB6xciQDcG9PmoGHGydtwj8cDUshXOrg1YOX/Ky
         I1tIGyeA/dUSgvJVtABN1h4H1dWjdGG9dh4vZgAw4jxEEL2HJ61LedS+7fs0ThRYlt
         /CeuXrFH2CTzcS5Cp+tlC6856bFRzmyOHEvc5NU7fATPc4EwIHhpuHqtAqCAzZVqPn
         1kurUJ3arCttQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EruccdcCl7Un; Mon, 16 Nov 2020 16:21:52 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id F3AFA2D10CC;
        Mon, 16 Nov 2020 16:21:51 -0500 (EST)
Date:   Mon, 16 Nov 2020 16:21:51 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     paulmck <paulmck@kernel.org>, Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <1716181165.46730.1605561711896.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201116154437.254a8b97@gandalf.local.home>
References: <00000000000004500b05b31e68ce@google.com> <20201115055256.65625-1-mmullins@mmlx.us> <20201116121929.1a7aeb16@gandalf.local.home> <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com> <20201116154437.254a8b97@gandalf.local.home>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: don't fail kmalloc while releasing raw_tp
Thread-Index: kIVZDEdRzf2ykv7hXQgCxoHMiDMaAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 16, 2020, at 3:44 PM, rostedt rostedt@goodmis.org wrote:

> On Mon, 16 Nov 2020 15:37:27 -0500 (EST)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>> > 
>> > Mathieu,
>> > 
>> > Can't we do something that would still allow to unregister a probe even if
>> > a new probe array fails to allocate? We could kick off a irq work to try to
>> > clean up the probe at a later time, but still, the unregister itself should
>> > not fail due to memory failure.
>> 
>> Currently, the fast path iteration looks like:
>> 
>>                 struct tracepoint_func *it_func_ptr;
>>                 void *it_func;
>> 
>>                 it_func_ptr =                                           \
>>                         rcu_dereference_raw((&__tracepoint_##_name)->funcs); \
>>                 do {                                                    \
>>                         it_func = (it_func_ptr)->func;                  \
>>                         __data = (it_func_ptr)->data;                   \
>>                         ((void(*)(void *, proto))(it_func))(__data, args); \
>>                 } while ((++it_func_ptr)->func);
>> 
>> So we RCU dereference the array, and iterate on the array until we find a NULL
>> func. So you could not use NULL to skip items, but you could perhaps reserve
>> a (void *)0x1UL tombstone for this.
> 
> Actually, you could just set it to a stub callback that does nothing. then
> you don't even need to touch the above macro. Not sure why I didn't
> recommend this to begin with, because that's exactly what the function
> tracer does with ftrace_stub.

I like the stub idea.

What prototype should the stub function have ? Is it acceptable to pass
arguments to a function expecting (void) ? If not, then we may need to
create stub functions for each tracepoint.

> 
> 
>> 
>> It should ideally be an unlikely branch, and it would be good to benchmark the
>> change when multiple tracing probes are attached to figure out whether the
>> overhead is significant when tracing is enabled.
> 
> If you use a stub function, it shouldn't affect anything. And the worse
> that would happen is that you have a slight overhead of calling the stub
> until you can properly remove the callback.
> 
>> 
>> I wonder whether we really mind that much about using slightly more memory
>> than required after a failed reallocation due to ENOMEM. Perhaps the irq work
>> is not even needed. Chances are that the irq work would fail again and again if
>> it's in low memory conditions. So maybe it's better to just keep the tombstone
>> in place until the next successful callback array reallocation.
>> 
> 
> True. If we just replace the function with a stub on memory failure (always
> using __GFP_NOFAIL, and if it fails to reallocate a new array, just replace
> the callback with the stub and be done with it. It may require some more
> accounting to make sure the tracepoint.c code can handle these stubs, and
> remove them on new additions to the code.

Yes.

> Heck, if a stub exists, you could just swap it with a new item.

Not without proper synchronization, otherwise you could end up with
mismatch between function callback and private data. The only transition
valid without waiting for an rcu grace period is to change the function
pointer to a stub function. Anything else (e.g. replacing the stub by
some other callback function) would require to wait for a grace period
beforehand.

> But on any new changes to the list, the stubs should be purged.

Yes,

Thanks,

Mathieu

> 
> 
> -- Steve

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
