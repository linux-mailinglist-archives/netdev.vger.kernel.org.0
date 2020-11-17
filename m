Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9745E2B6F3C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731268AbgKQTrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:47:23 -0500
Received: from mail.efficios.com ([167.114.26.124]:40818 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728948AbgKQTrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:47:22 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4A8EB2E36C2;
        Tue, 17 Nov 2020 14:47:21 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id GR3dE06nSY_Y; Tue, 17 Nov 2020 14:47:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id C2DBA2E3946;
        Tue, 17 Nov 2020 14:47:20 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com C2DBA2E3946
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605642440;
        bh=+B59aLsvKUka/9WP6zUbeiECXbkqSfWKHUa+MS2yq28=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=c9pI2WHhQqyR0JFf55+95q5YT43Kp1xWnub2hm9BSUNVibjMfp+odXZ8TQ7ueM5ea
         1DAT01hpE3YoCwl9Qbswo5oN4Dftd0GalhskDcxOr4pCn2ynpg/8lFSxh6WQH/DFch
         aj3m2uC+ToZ3LAO9lE4UttmWlgmfVz9mTnYyVFUTmXy2NCIcXcTcI8BpzhF7VHbJte
         h3vwS6tQc6gTF+RkvYKJbDC4PVvxoZVHP672k6E3UPaUUSzV7Y80ijSYKtG+ooW+fL
         ZUKJ0Gypovl3miO3ZqOxeqDxnKIHlizesapoAGKwTblWyCOBbUXGjd6km7wL19ziG+
         wRmCIAIysei6w==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id iuc9IeOT2QZf; Tue, 17 Nov 2020 14:47:20 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id AE1BB2E3945;
        Tue, 17 Nov 2020 14:47:20 -0500 (EST)
Date:   Tue, 17 Nov 2020 14:47:20 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Message-ID: <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201117142145.43194f1a@gandalf.local.home>
References: <20201116175107.02db396d@gandalf.local.home> <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com> <20201117142145.43194f1a@gandalf.local.home>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: tracepoint: Do not fail unregistering a probe due to memory allocation
Thread-Index: cU8QSyXnFie0NdnbNChYpOJ7ycvfPg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 17, 2020, at 2:21 PM, rostedt rostedt@goodmis.org wrote:

> On Tue, 17 Nov 2020 14:15:10 -0500 (EST)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> 
>> diff --git a/include/linux/tracepoint-defs.h b/include/linux/tracepoint-defs.h
>> index e7c2276be33e..e0351bb0b140 100644
>> --- a/include/linux/tracepoint-defs.h
>> +++ b/include/linux/tracepoint-defs.h
>> @@ -38,6 +38,7 @@ struct tracepoint {
>>         int (*regfunc)(void);
>>         void (*unregfunc)(void);
>>         struct tracepoint_func __rcu *funcs;
>> +       void *stub_func;
>>  };
>>  
>>  #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
>> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
>> index 0f21617f1a66..b0b805de3779 100644
>> --- a/include/linux/tracepoint.h
>> +++ b/include/linux/tracepoint.h
>> @@ -287,6 +287,9 @@ static inline struct tracepoint
>> *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>>  #define DEFINE_TRACE_FN(_name, _reg, _unreg, proto, args)              \
>>         static const char __tpstrtab_##_name[]                          \
>>         __section("__tracepoints_strings") = #_name;                    \
>> +       static void __cold __tracepoint_stub_func_##_name(void *__data, proto) \
>> +       {                                                               \
>> +       }                                                               \
> 
> The thing is, tracepoints are already bloated. I do not want to add
> something like this that will unnecessarily add more text.

I've measured the impact of adding these stubs to kernel/sched/core.o, and
it's entirely lost in the code alignment (it effectively adds 0 byte of text
to my build) when using the "cold" attribute.

Over an entire vmlinux, it adds 256 bytes of text overall, for a 0.008% code size
increase.

Can you measure any significant code size increase with this approach ?

There seems to be more effect on the data size: adding the "stub_func" field
in struct tracepoint adds 8320 bytes of data to my vmlinux. But considering
the layout of struct tracepoint:

struct tracepoint {
        const char *name;               /* Tracepoint name */
        struct static_key key;
        struct static_call_key *static_call_key;
        void *static_call_tramp;
        void *iterator;
        int (*regfunc)(void);
        void (*unregfunc)(void);
        struct tracepoint_func __rcu *funcs;
        void *stub_func;
};

I would argue that we have many other things to optimize there if we want to
shrink the bloat, starting with static keys and system call reg/unregfunc pointers.

> 
> Since all tracepoints callbacks have at least one parameter (__data), we
> could declare tp_stub_func as:
> 
> static void tp_stub_func(void *data, ...)
> {
>	return;
> }
> 
> And now C knows that tp_stub_func() can be called with one or more
> parameters, and had better be able to deal with it!

AFAIU this won't work.

C99 6.5.2.2 Function calls

"If the function is defined with a type that is not compatible with the type (of the
expression) pointed to by the expression that denotes the called function, the behavior is
undefined."

and

6.7.5.3 Function declarators (including prototypes), item 15:

"For two function types to be compatible, both shall specify compatible return types.

Moreover, the parameter type lists, if both are present, shall agree in the number of
parameters and in use of the ellipsis terminator; corresponding parameters shall have
compatible types. [...]"

What you suggest here is to use the ellipsis in the stub definition, but the caller
prototype does not use the ellipsis, which brings us into undefined behavior territory
again.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
