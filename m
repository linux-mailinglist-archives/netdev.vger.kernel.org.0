Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FD13B4F2B
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 17:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFZPTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 11:19:46 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54636 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhFZPTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 11:19:46 -0400
Received: from fsav118.sakura.ne.jp (fsav118.sakura.ne.jp [27.133.134.245])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 15QFHMSN075545;
        Sun, 27 Jun 2021 00:17:22 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav118.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp);
 Sun, 27 Jun 2021 00:17:22 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 15QFHM6h075541
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 27 Jun 2021 00:17:22 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] tracepoint: Do not warn on EEXIST or ENOENT
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Robert Richter <rric@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
References: <20210626135845.4080-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <20210626101834.55b4ecf1@rorschach.local.home>
 <7297f336-70e5-82d3-f8d3-27f08c7d1548@i-love.sakura.ne.jp>
Message-ID: <ca78b1b1-e6e3-9a98-7919-a68389933829@i-love.sakura.ne.jp>
Date:   Sun, 27 Jun 2021 00:17:20 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7297f336-70e5-82d3-f8d3-27f08c7d1548@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/06/27 0:13, Tetsuo Handa wrote:
> On 2021/06/26 23:18, Steven Rostedt wrote:
>> On Sat, 26 Jun 2021 22:58:45 +0900
>> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
>>
>>> syzbot is hitting WARN_ON_ONCE() at tracepoint_add_func() [1], but
>>> func_add() returning -EEXIST and func_remove() returning -ENOENT are
>>> not kernel bugs that can justify crashing the system.
>>
>> There should be no path that registers a tracepoint twice. That's a bug
>> in the kernel. Looking at the link below, I see the backtrace:
>>
>> Call Trace:
>>  tracepoint_probe_register_prio kernel/tracepoint.c:369 [inline]
>>  tracepoint_probe_register+0x9c/0xe0 kernel/tracepoint.c:389
>>  __bpf_probe_register kernel/trace/bpf_trace.c:2154 [inline]
>>  bpf_probe_register+0x15a/0x1c0 kernel/trace/bpf_trace.c:2159
>>  bpf_raw_tracepoint_open+0x34a/0x720 kernel/bpf/syscall.c:2878
>>  __do_sys_bpf+0x2586/0x4f40 kernel/bpf/syscall.c:4435
>>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>
>> So BPF is allowing the user to register the same tracepoint more than
>> once? That looks to be a bug in the BPF code where it shouldn't be
>> allowing user space to register the same tracepoint multiple times.
> 
> I didn't catch your question.
> 
>   (1) func_add() can reject an attempt to add same tracepoint multiple times
>       by returning -EINVAL to the caller.

Sorry, s/EINVAL/EEXIST/g on (1) (2) (6).

>   (2) But tracepoint_add_func() (the caller of func_add()) is calling WARN_ON_ONCE()
>       if func_add() returned -EINVAL.
>   (3) And tracepoint_add_func() is triggerable via request from userspace.
>   (4) tracepoint_probe_register_prio() serializes tracepoint_add_func() call
>       triggered by concurrent request from userspace using tracepoints_mutex mutex.
>   (5) But tracepoint_add_func() does not check whether same tracepoint multiple
>       is already registered before calling func_add().
>   (6) As a result, tracepoint_add_func() receives -EINVAL from func_add(), and
>       calls WARN_ON_ONCE() and the system crashes due to panic_on_warn == 1.
> 
> Why this is a bug in the BPF code? The BPF code is not allowing userspace to
> register the same tracepoint multiple times. I think that tracepoint_add_func()
> is stupid enough to crash the kernel instead of rejecting when an attempt to
> register the same tracepoint multiple times is made.
> 

