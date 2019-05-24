Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57ECD2A069
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404246AbfEXVct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:32:49 -0400
Received: from www62.your-server.de ([213.133.104.62]:51412 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391745AbfEXVct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:32:49 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUHnz-0000iA-3K; Fri, 24 May 2019 23:32:47 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUHny-000PVZ-Tp; Fri, 24 May 2019 23:32:46 +0200
Subject: Re: [PATCH bpf-next v5 0/3] bpf: implement bpf_send_signal() helper
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>, kernel-team@fb.com,
        Peter Zijlstra <peterz@infradead.org>
References: <20190523214745.854300-1-yhs@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8f751452-271f-6253-2f34-9e4cecb347b8@iogearbox.net>
Date:   Fri, 24 May 2019 23:32:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190523214745.854300-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25459/Fri May 24 09:59:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/23/2019 11:47 PM, Yonghong Song wrote:
> This patch tries to solve the following specific use case. 
> 
> Currently, bpf program can already collect stack traces
> through kernel function get_perf_callchain()
> when certain events happens (e.g., cache miss counter or
> cpu clock counter overflows). But such stack traces are 
> not enough for jitted programs, e.g., hhvm (jited php).
> To get real stack trace, jit engine internal data structures
> need to be traversed in order to get the real user functions.
> 
> bpf program itself may not be the best place to traverse 
> the jit engine as the traversing logic could be complex and
> it is not a stable interface either.
> 
> Instead, hhvm implements a signal handler,
> e.g. for SIGALARM, and a set of program locations which 
> it can dump stack traces. When it receives a signal, it will
> dump the stack in next such program location.
> 
> This patch implements bpf_send_signal() helper to send
> a signal to hhvm in real time, resulting in intended stack traces. 
> 
> Patch #1 implemented the bpf_send_helper() in the kernel.
> Patch #2 synced uapi header bpf.h to tools directory.
> Patch #3 added a self test which covers tracepoint
> and perf_event bpf programs. 
> 
> Changelogs:
>   v4 => v5:
>     . pass the "current" task struct to irq_work as well
>       since the current task struct may change between
>       nmi and subsequent irq_work_interrupt.
>       Discovered by Daniel.
>   v3 => v4:
>     . fix one typo and declare "const char *id_path = ..."
>       to avoid directly use the long string in the func body 
>       in Patch #3.
>   v2 => v3:
>     . change the standalone test to be part of prog_tests.
>   RFC v1 => v2:
>     . previous version allows to send signal to an arbitrary 
>       pid. This version just sends the signal to current
>       task to avoid unstable pid and potential races between
>       sending signals and task state changes for the pid.
> 
> Yonghong Song (3):
>   bpf: implement bpf_send_signal() helper
>   tools/bpf: sync bpf uapi header bpf.h to tools directory
>   tools/bpf: add selftest in test_progs for bpf_send_signal() helper
> 
>  include/uapi/linux/bpf.h                      |  17 +-
>  kernel/trace/bpf_trace.c                      |  72 +++++++
>  tools/include/uapi/linux/bpf.h                |  17 +-
>  tools/testing/selftests/bpf/bpf_helpers.h     |   1 +
>  .../selftests/bpf/prog_tests/send_signal.c    | 198 ++++++++++++++++++
>  .../bpf/progs/test_send_signal_kern.c         |  51 +++++
>  6 files changed, 354 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/send_signal.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_send_signal_kern.c
> 

Applied, thanks. One more remark in patch 1, will reply there.
