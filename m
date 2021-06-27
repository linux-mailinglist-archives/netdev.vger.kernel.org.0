Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BD33B50B1
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 03:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhF0BM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 21:12:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62073 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhF0BM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 21:12:59 -0400
Received: from fsav315.sakura.ne.jp (fsav315.sakura.ne.jp [153.120.85.146])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 15R1AWWa081414;
        Sun, 27 Jun 2021 10:10:32 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav315.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp);
 Sun, 27 Jun 2021 10:10:31 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 15R1APoP081243
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 27 Jun 2021 10:10:31 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] tracepoint: Do not warn on EEXIST or ENOENT
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
 <20210626114157.765d9371@rorschach.local.home>
 <20210626142213.6dee5c60@rorschach.local.home>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <fc5d0f90-502d-b217-0ad6-0d17cae12ff7@i-love.sakura.ne.jp>
Date:   Sun, 27 Jun 2021 10:10:24 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210626142213.6dee5c60@rorschach.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/06/27 3:22, Steven Rostedt wrote:
>> If BPF is expected to register the same tracepoint with the same
>> callback and data more than once, then let's add a call to do that
>> without warning. Like I said, other callers expect the call to succeed
>> unless it's out of memory, which tends to cause other problems.
> 
> If BPF is OK with registering the same probe more than once if user
> space expects it, we can add this patch, which allows the caller (in
> this case BPF) to not warn if the probe being registered is already
> registered, and keeps the idea that a probe registered twice is a bug
> for all other use cases.

I think BPF will not register the same tracepoint with the same callback and
data more than once, for bpf(BPF_RAW_TRACEPOINT_OPEN) cleans the request up
by calling bpf_link_cleanup() and returns -EEXIST. But I think BPF relies on
tracepoint_add_func() returning -EEXIST without crashing the kernel.

CPU: 0 PID: 16193 Comm: syz-executor.5 Not tainted 5.13.0-rc7-syzkaller #0
RIP: 0010:tracepoint_add_func+0x1fb/0xa90 kernel/tracepoint.c:291
Call Trace:
 tracepoint_probe_register_prio kernel/tracepoint.c:369 [inline]
 tracepoint_probe_register+0x9c/0xe0 kernel/tracepoint.c:389
 __bpf_probe_register kernel/trace/bpf_trace.c:1843 [inline]
 bpf_probe_register+0x15a/0x1c0 kernel/trace/bpf_trace.c:1848
 bpf_raw_tracepoint_open+0x34a/0x720 kernel/bpf/syscall.c:2895
 __do_sys_bpf+0x2586/0x4f40 kernel/bpf/syscall.c:4453
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size) {
  switch (cmd) {
  case BPF_RAW_TRACEPOINT_OPEN:
    err = bpf_raw_tracepoint_open(&attr) {
      err = bpf_link_prime(&link->link, &link_primer);
      if (err) {
        kfree(link);
        goto out_put_btp;
      }
      err = bpf_probe_register(link->btp, prog) {
        return __bpf_probe_register(btp, prog) {
          return tracepoint_probe_register(tp, (void *)btp->bpf_func, prog) {
            return tracepoint_probe_register_prio(tp, probe, data, TRACEPOINT_DEFAULT_PRIO) {
              mutex_lock(&tracepoints_mutex); // Serialization start.
              ret = tracepoint_add_func(tp, &tp_func, prio) {
                old = func_add(&tp_funcs, func, prio); // Returns -EEXIST.
                if (IS_ERR(old)) {
                  WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM); // Crashes due to warn_on_paic==1.
                  return PTR_ERR(old); // Returns -EEXIST.
                }
              }
              mutex_unlock(&tracepoints_mutex); // Serialization end.
              return ret; // Returns -EEXIST.
            }
          }
        }
      }
      if (err) {
        bpf_link_cleanup(&link_primer); // Reject if func_add() returned -EEXIST.
        goto out_put_btp;
      }
      return bpf_link_settle(&link_primer);
    }
    break;
  }
  return ret; // Returns -EEXIST to the userspace.
}

On 2021/06/27 0:41, Steven Rostedt wrote:
>>   (1) func_add() can reject an attempt to add same tracepoint multiple times
>>       by returning -EEXIST to the caller.
>>   (2) But tracepoint_add_func() (the caller of func_add()) is calling WARN_ON_ONCE()
>>       if func_add() returned -EEXIST.
> 
> That's because (before BPF) there's no place in the kernel that tries
> to register the same tracepoint multiple times, and was considered a
> bug if it happened, because there's no ref counters to deal with adding
> them multiple times.

I see. But does that make sense? Since func_add() can fail with -ENOMEM,
all places (even before BPF) needs to be prepared for failures.

> 
> If the tracepoint is already registered (with the given function and
> data), then something likely went wrong.

That can be prepared on the caller side of tracepoint_add_func() rather than
tracepoint_add_func() side.

> 
>>   (3) And tracepoint_add_func() is triggerable via request from userspace.
> 
> Only via BPF correct?
> 
> I'm not sure how it works, but can't BPF catch that it is registering
> the same tracepoint again?

There is no chance to check whether some tracepoint is already registered, for
tracepoints_mutex is the only lock which gives us a chance to check whether
some tracepoint is already registered.

Should bpf() syscall hold a global lock (like tracepoints_mutex) which will serialize
the entire code in order to check whether some tracepoint is already registered?
That might severely damage concurrency.

