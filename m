Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1852DEAB8
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgLRVD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 16:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgLRVDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 16:03:55 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64839C0617A7;
        Fri, 18 Dec 2020 13:03:15 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id k78so3103870ybf.12;
        Fri, 18 Dec 2020 13:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TWw1SCmQsxvxc+WNYPEFwdaZl88n8UiSpwon3yGxrO8=;
        b=FFh8H88/BSQq+lpq1Iy1zhCO5iaCNefaRPKrADFZT4bSGI2KslZJLi2AFWDnBbR8WU
         9+NV/FF7C9ZoCEMp9UaYadIKkIhOmte9+aBI/ExbImjFcGlHgPG0cNjwQCuW/fyZErmt
         Fi6pu9Uphp4OxYr11Ldlms7HjobcLstsx5pVEX/f8uFG0hRrPLGSpi6mHhlO8K5T+eJG
         FmeDBO20j3bNYVILfUB3ewdMpDZ+b+to9idnq01ZW8sibJRUgittABnZdmQUKnQD9hIY
         ccvNE5dB2Uj80iTNn3rVgOKxtX/f6oAZHYpRnZL+Xijol9E03HxzE+9oF84ETA6On0cj
         NJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TWw1SCmQsxvxc+WNYPEFwdaZl88n8UiSpwon3yGxrO8=;
        b=VJHqRAomzTobfkVR3vDC/D8FCPIj3L7esRjLCtWVpDUhkbir0vzGjusl37nGbV7JXQ
         0IvYVQV+RVahk9tPxEaKRG3EAOw1YPgERjk56ThKyx1Rdphrz7hVGiCnHLdonT3BVoch
         41F/hIfnGvXfuvLs1i3xBnQ6y8xXVR77+G3r5KAxCdFrw9jldJWIScuexQgho33b726/
         kaE50n7o/ZFenD4a9m4dqjduopMO7+uXkHwB84ZJp2sE0rlMUgQpQ1f89mvCVCVhCLEj
         Cs/ykOhwFG9nqdTedCvJ2YxxU/eDvClfKPNa3mNbtKmkF/3086+JmtasmIZ/RgDyFXSn
         YjCA==
X-Gm-Message-State: AOAM531RKqn4/1czCqteSuNe3ofkVFra4CFZhuxAT+qwz9WS/TKPGZHF
        1cnt2t/U8uqBSTgTCozjC6RJkSJIloR+r4xR/X4=
X-Google-Smtp-Source: ABdhPJwUuXbrOJQYKxGfyUdnAD2vWenTIvq0QpowwrcS81+xGmv9qG+9qreKRk1sxZWt4zyZaF9+rUoLUg9fgfN9gBU=
X-Received: by 2002:a25:d44:: with SMTP id 65mr8733205ybn.260.1608325394752;
 Fri, 18 Dec 2020 13:03:14 -0800 (PST)
MIME-Version: 1.0
References: <20201218185032.2464558-1-jonathan.lemon@gmail.com> <20201218185032.2464558-4-jonathan.lemon@gmail.com>
In-Reply-To: <20201218185032.2464558-4-jonathan.lemon@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Dec 2020 13:03:03 -0800
Message-ID: <CAEf4BzaZDmceV1o+r2TLZub9WQ8bTM4NGUz9NdZjNeMaen=FEw@mail.gmail.com>
Subject: Re: [PATCH 3/3 v4 bpf-next] bpf: optimize task iteration
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 12:47 PM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> Only obtain the task reference count at the end of the RCU section
> instead of repeatedly obtaining/releasing it when iterating though
> a thread group.
>
> Jump to the correct branch when it is known that the task is NULL.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/task_iter.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index dc4007f1843b..598a8d7da5bf 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -33,7 +33,7 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>         pid = find_ge_pid(*tid, ns);
>         if (pid) {
>                 *tid = pid_nr_ns(pid, ns);
> -               task = get_pid_task(pid, PIDTYPE_PID);
> +               task = pid_task(pid, PIDTYPE_PID);
>                 if (!task) {
>                         ++*tid;
>                         goto retry;
> @@ -44,6 +44,7 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>                         ++*tid;
>                         goto retry;
>                 }
> +               get_task_struct(task);
>         }
>         rcu_read_unlock();
>
> @@ -148,12 +149,12 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
>          * it held a reference to the task/files_struct/file.
>          * Otherwise, it does not hold any reference.
>          */
> -again:
>         if (info->task) {
>                 curr_task = info->task;
>                 curr_files = info->files;
>                 curr_fd = info->fd;
>         } else {
> +again:
>                 curr_task = task_seq_get_next(ns, &curr_tid, true);
>                 if (!curr_task) {
>                         info->task = NULL;
> --
> 2.24.1
>
