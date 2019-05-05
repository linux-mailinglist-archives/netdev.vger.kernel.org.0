Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E285A13E27
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 09:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfEEH3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 03:29:44 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43029 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEH3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 03:29:44 -0400
Received: by mail-lj1-f195.google.com with SMTP id z5so3392941lji.10;
        Sun, 05 May 2019 00:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Af9LsgIOZM3PelYJTFzE4sXLY8vPp0bkTsRwFhf26OM=;
        b=Q+T3StTrZbKHL1Phi117luZiBcX90rC22xWCuQI9A2zSwy/kV+8r/HWq4kEhIQXQSe
         39kr1h8tzvLw3mmM18Yv6N/AvMFO2fQDxywA+HdwzqlqP2ulVtPlTTnAICd8AQ7U8ljP
         4gu87t3RgO4sdDOFn8g7VHv3B70TAUI36wRg5HDjmvqD5wIt28bIFfewBV78jP8TAmuW
         zms8gC9ZLuU7YV8BfsHKQNzlIEwYbskVR4iys3q8leBvdTBlMzgvW+GHQL6iTSajVuD1
         EbdYeE1UCYP1c4SWbTgOZsXJV3sgRWUORko2D0aPqj8Hm92qRd+4eTB0F+kphPcF3GWU
         0dBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Af9LsgIOZM3PelYJTFzE4sXLY8vPp0bkTsRwFhf26OM=;
        b=pmX91L2fJaQIrxxeAFbItfBIy3WkncKI9s85c+yLcdzB3a47SWAYLyggxtlWmwj7hs
         orf6VNtAn2RJrapiwKNxdnRHOF1PlngdJM7/Z+khRSK3aSEYhO+8az4u+j7LStpD+Kdd
         ZMIZxhfcdYLDINI0qwx98fWpCSN6ebHCGsrSahdmv4c6ioLAr3myuzme9quu6bzid5fG
         ptow+TFq2WLVolon7OlvAKjjhY7uMPGcf27NQphIrtFqksFQclNzxPI/qcRU2JUxSe2n
         kjQclAHadgc48ZpoU0odzsO8Rvgnhm0f81F7MPk8r81u7zOhZkCYlE4X09tGj9/yMc0K
         jnrA==
X-Gm-Message-State: APjAAAXZAANRlVbAWOcFsNJfuDNNG6NhaQ2linXkkrVZKUhuEoTyX0k/
        tczqkY4BbpC2uGTucD2f7qgBcMuW9Ks3z8cKShkVVan1iT4=
X-Google-Smtp-Source: APXvYqyI+dgv9OjDRVY2zQQz8IeZFj0XjVrhDAvE2eelSOFjXM/JhUXBba3GQ58fBbZ6eewqYXeybYhzZzAjxAuDOYA=
X-Received: by 2002:a2e:6e01:: with SMTP id j1mr9299384ljc.85.1557041381919;
 Sun, 05 May 2019 00:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190503000806.1340927-1-yhs@fb.com> <20190503000806.1340997-1-yhs@fb.com>
In-Reply-To: <20190503000806.1340997-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 5 May 2019 00:29:30 -0700
Message-ID: <CAADnVQLJvK5Pr_-RAizrSSKBp80+RJQ3TDeyfTWU6wX2W6gxZg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v2 1/3] bpf: implement bpf_send_signal() helper
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 5:08 PM Yonghong Song <yhs@fb.com> wrote:
>
> This patch tries to solve the following specific use case.
>
> Currently, bpf program can already collect stack traces
> when certain events happens (e.g., cache miss counter or
> cpu clock counter overflows). These stack traces can be
> used for performance analysis. For jitted programs, e.g.,
> hhvm (jited php), it is very hard to get the true stack
> trace in the bpf program due to jit complexity.
>
> To resolve this issue, hhvm implements a signal handler,
> e.g. for SIGALARM, and a set of program locations which
> it can dump stack traces. When it receives a signal, it will
> dump the stack in next such program location.
>
> The following is the current way to handle this use case:
>   . profiler installs a bpf program and polls on a map.
>     When certain event happens, bpf program writes to a map.
>   . Once receiving the information from the map, the profiler
>     sends a signal to hhvm.
> This method could have large delays and causing profiling
> results skewed.
>
> This patch implements bpf_send_signal() helper to send a signal to
> hhvm in real time, resulting in intended stack traces.
>
> Reported-by: kbuild test robot <lkp@intel.com>

v2 addressing buildbot issue doesn't need to have such tag.

> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/uapi/linux/bpf.h | 15 ++++++-
>  kernel/trace/bpf_trace.c | 85 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 99 insertions(+), 1 deletion(-)
>
> v1 -> v2:
>  fixed a compilation warning (missing return value in case)
>  reported by kbuild test robot.
>  added Reported-by in the above to notify the bot.
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 72336bac7573..e3e824848335 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2667,6 +2667,18 @@ union bpf_attr {
>   *             0 on success.
>   *
>   *             **-ENOENT** if the bpf-local-storage cannot be found.
> + *
> + * int bpf_send_signal(u32 pid, u32 sig)
> + *     Description
> + *             Send signal *sig* to *pid*.
> + *     Return
> + *             0 on success or successfully queued.
> + *
> + *             **-ENOENT** if *pid* cannot be found.
> + *
> + *             **-EBUSY** if work queue under nmi is full.
> + *
> + *             Other negative values for actual signal sending errors.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -2777,7 +2789,8 @@ union bpf_attr {
>         FN(strtol),                     \
>         FN(strtoul),                    \
>         FN(sk_storage_get),             \
> -       FN(sk_storage_delete),
> +       FN(sk_storage_delete),          \
> +       FN(send_signal),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 8607aba1d882..49a804d59bfb 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -559,6 +559,76 @@ static const struct bpf_func_proto bpf_probe_read_str_proto = {
>         .arg3_type      = ARG_ANYTHING,
>  };
>
> +struct send_signal_irq_work {
> +       struct irq_work irq_work;
> +       u32 pid;
> +       u32 sig;
> +};
> +
> +static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
> +
> +static int do_bpf_send_signal_pid(u32 pid, u32 sig)
> +{
> +       struct task_struct *task;
> +       struct pid *pidp;
> +
> +       pidp = find_vpid(pid);

it takes pidns from current which should be valid
which makes bpf prog depend on current, but from nmi
there are no guarantees.
I think find_pid_ns() would be cleaner, but then the question
would be how to pass pidns...
Another issue is instability of pid as an integer...
upcoming pidfd could be the answer.
At this point I think it's cleaner to make such api to send signal
to existing process only under the same conditions as in bpf_probe_write_user.
Would that work for your use case?
