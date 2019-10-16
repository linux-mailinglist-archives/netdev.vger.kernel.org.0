Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37FED98A1
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390942AbfJPRnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:43:51 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34325 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfJPRnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:43:51 -0400
Received: by mail-lj1-f195.google.com with SMTP id j19so24939129lja.1;
        Wed, 16 Oct 2019 10:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eaRUhXBbWt3s8K06DJiUkmSVvgGNMgRZLpiGfxeuwSA=;
        b=aQ04ZpMUsKO6CnHAvc4YfjSQV2snZVAco1gxc1JyM4oN0Dq0ACcjGFwKzeCH29cYgU
         tYgP0uZvtznLh79kDSVEAzqZ7eq7Cq9hJPoQIpRdR/jWz5q3HN31nur8LdP2eEbgSgQm
         /0R23O9DsxL82+EZqCOwz2A4hXqTCD4xCfhaomhZB/JdoFMHqauDD0ENL0X7acc6f5NB
         ztEEuA3WSKlB5O3u+9qKxg3pNIcah9v7spGOvxRRlfoDbxM8mnPTUg0Mv3UB3UW/EPdi
         jOV+jcks7OuMBtdBir+5PZjYzT69ylpC5HuDDoySSGzs1SVrQkf2n5w4ZCYUVbZf9MVj
         DZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eaRUhXBbWt3s8K06DJiUkmSVvgGNMgRZLpiGfxeuwSA=;
        b=FwEa4SjrLL+6MxtQI9Y0u3kHXayziUStRogZwmufmgNo0mzEmueoxO3Gajw6yMLzOF
         JZ6bHQu82e7O7Vy7l71tva0kK3LhKvuOGcl4+ehh9HvL4LNHGcib/Xw7A5NBzEFbxsd5
         SjF5tJCvaeJDkKe7xZJL0krXcSUOPxzaD/yXCy2DbOUA0VVKUAQXEHJbMNbG2LJWtC6q
         Sov/q16Z+ePjiCqCRBQzOHCPsCmSMRKjrzWlkT7iHpREDenDCeSiGI85D3DML8/spOSt
         MXfudElUHxMKIJMA8TYFIH9CEZH8sKjTn/67+Y9qSjvVV0uAczecMYIJl4Edv2fZ99We
         I/Zg==
X-Gm-Message-State: APjAAAUFZEB6z0hHX4GPF4RRWKWAAn8tntGkGlfpcBM43YF2Mi1F1jlx
        aBNSmR4b2gEsI8Xx7RXuXN7/9qKRWTvDkfMb8dc=
X-Google-Smtp-Source: APXvYqznw3y3lUIpyR3mcdILznHQc1ScODpS98UCaetVIONDsO4wbRguVwSyUmliMkmK3fiRgYNaawPHGTDl53GQqZg=
X-Received: by 2002:a2e:9bc1:: with SMTP id w1mr21397813ljj.136.1571247828713;
 Wed, 16 Oct 2019 10:43:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191014171223.357174-1-songliubraving@fb.com>
In-Reply-To: <20191014171223.357174-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 16 Oct 2019 10:43:36 -0700
Message-ID: <CAADnVQKn3RZnAZAOSg1yoQmo9doeGouEBkcFzmZGWLU7QqjJOA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf/stackmap: fix deadlock with rq_lock in bpf_get_stack()
To:     Song Liu <songliubraving@fb.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        sashal@kernel.org, Kernel Team <kernel-team@fb.com>,
        stable <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 10:12 AM Song Liu <songliubraving@fb.com> wrote:
>
> bpf stackmap with build-id lookup (BPF_F_STACK_BUILD_ID) can trigger A-A
> deadlock on rq_lock():
>
> rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> [...]
> Call Trace:
>  try_to_wake_up+0x1ad/0x590
>  wake_up_q+0x54/0x80
>  rwsem_wake+0x8a/0xb0
>  bpf_get_stack+0x13c/0x150
>  bpf_prog_fbdaf42eded9fe46_on_event+0x5e3/0x1000
>  bpf_overflow_handler+0x60/0x100
>  __perf_event_overflow+0x4f/0xf0
>  perf_swevent_overflow+0x99/0xc0
>  ___perf_sw_event+0xe7/0x120
>  __schedule+0x47d/0x620
>  schedule+0x29/0x90
>  futex_wait_queue_me+0xb9/0x110
>  futex_wait+0x139/0x230
>  do_futex+0x2ac/0xa50
>  __x64_sys_futex+0x13c/0x180
>  do_syscall_64+0x42/0x100
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> This can be reproduced by:
> 1. Start a multi-thread program that does parallel mmap() and malloc();
> 2. taskset the program to 2 CPUs;
> 3. Attach bpf program to trace_sched_switch and gather stackmap with
>    build-id, e.g. with trace.py from bcc tools:
>    trace.py -U -p <pid> -s <some-bin,some-lib> t:sched:sched_switch
>
> A sample reproducer is attached at the end.
>
> This could also trigger deadlock with other locks that are nested with
> rq_lock.
>
> Fix this by checking whether irqs are disabled. Since rq_lock and all
> other nested locks are irq safe, it is safe to do up_read() when irqs are
> not disable. If the irqs are disabled, postpone up_read() in irq_work.
>
> Fixes: commit 615755a77b24 ("bpf: extend stackmap to save binary_build_id+offset instead of address")
> Cc: stable@vger.kernel.org # v4.17+
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Song Liu <songliubraving@fb.com>

I fixed 'Fixes' tag and applied to bpf-next.
Thanks
