Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B168B248BF6
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgHRQs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgHRQsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 12:48:55 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95394C061389;
        Tue, 18 Aug 2020 09:48:54 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id u6so5893735ybf.1;
        Tue, 18 Aug 2020 09:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1FVN/vdhfkj9uu++nQpjO7/xQUOyX482LKAJmHBQtqs=;
        b=mgueEoueN7X0W32a57OMhpOjO7p+myebDwrU/k0w2oGsmtRI+F0xwDHTEaZz/p819N
         tKQgJjbL4AVfwZ2EGe0CEuQR890QFTOz3vPl3DHHvkrl5YIi99eXc4KSEzAPN6i4J+81
         96yjjGaNwW5tqutypE6P5PQajFi/urRng1MA9IHdmrot5bw0IKICkw95Q71Jvxy3I0Wt
         rNKwL7JNhsjOBbiydvpjxwDX+nCTvd19Rz9dsYaJHXwhWowNeUh4GZJeAaX0cr3bULea
         ikh3a6Dkwzt1DzK8leOk2KjDbjybhXg/rkjlvImraX+WRn5MiXmfAXho06nB5Zm0jCsT
         t15A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1FVN/vdhfkj9uu++nQpjO7/xQUOyX482LKAJmHBQtqs=;
        b=pIIHC54Y7sl5oO7VmE0vzRUZFcVQuC6cN9RT0R3KLWihj8XWEz17GF6hDNFE+jMCcI
         jXWvseWAsrq6SKXulVCbySs56SPLw3cQ2mCuh5YoypreiT8iGh8sxEFEzpkfa495Lv/1
         3s1Vh8Mq9H459LhckYqkCNoYGNAQFx4P2/eU0i+1IkRjVgpoylS96NFKOahV0oxR9hIq
         lgrrfO6zh1YNcb3Dxd3ophekb2qDNV89VGDap4OBZ1O/XSSloubSZGHvccFNTVpDpn6v
         HawozxaTXvDfG2HzUnFCnnpVWS9b/hOumsZljb8h3Qfrvheyopb7ofd2mx2zS+SZxsdw
         grJw==
X-Gm-Message-State: AOAM531i8vVrZGxUiwe9MCvG/wPqLXFN7r5Ym616kZMxh0YGfgnTv5xN
        aSLW0bzSgRgRuYGs9wMeKN4GR9KONaYWfJbvRnE=
X-Google-Smtp-Source: ABdhPJz6lDp1nESPWR3+SI7K+cYnbhnIkU1/J/IjjVIUBuYOrwvUoPCqMtk97dhWtoNZcu5XnfvwqTbMLGAQlDwdzYg=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr26087623ybk.230.1597769333791;
 Tue, 18 Aug 2020 09:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200818162408.836759-1-yhs@fb.com> <20200818162408.836816-1-yhs@fb.com>
In-Reply-To: <20200818162408.836816-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Aug 2020 09:48:42 -0700
Message-ID: <CAEf4BzY=YskvOg+cr_XFF42kDWOL3T1mzx=vAoQcS2oAzPOUsQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: fix a rcu_sched stall issue with bpf
 task/task_file iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 9:26 AM Yonghong Song <yhs@fb.com> wrote:
>
> In our production system, we observed rcu stalls when
> 'bpftool prog` is running.

[...]

>
> Note that `bpftool prog` actually calls a task_file bpf iterator
> program to establish an association between prog/map/link/btf anon
> files and processes.
>
> In the case where the above rcu stall occured, we had a process
> having 1587 tasks and each task having roughly 81305 files.
> This implied 129 million bpf prog invocations. Unfortunwtely none of
> these files are prog/map/link/btf files so bpf iterator/prog needs
> to traverse all these files and not able to return to user space
> since there are no seq_file buffer overflow.
>
> The fix is to add cond_resched() during traversing tasks
> and files. So voluntarily releasing cpu gives other tasks, e.g.,
> rcu resched kthread, a chance to run.

What are the performance implications of doing this for every task
and/or file? Have you benchmarked `bpftool prog` before/after? What
was the difference?

I wonder if it's possible to amortize those cond_resched() and call
them only ever so often, based on CPU time or number of files/tasks
processed, if cond_resched() does turn out to slow bpf_iter down.

>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/task_iter.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index f21b5e1e4540..885b14cab2c0 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -27,6 +27,8 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>         struct task_struct *task = NULL;
>         struct pid *pid;
>
> +       cond_resched();
> +
>         rcu_read_lock();
>  retry:
>         pid = idr_get_next(&ns->idr, tid);
> @@ -137,6 +139,8 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
>         struct task_struct *curr_task;
>         int curr_fd = info->fd;
>
> +       cond_resched();
> +
>         /* If this function returns a non-NULL file object,
>          * it held a reference to the task/files_struct/file.
>          * Otherwise, it does not hold any reference.
> --
> 2.24.1
>
