Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727102977D6
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 21:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754933AbgJWTq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 15:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754901AbgJWTq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 15:46:27 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F176C0613CE;
        Fri, 23 Oct 2020 12:46:27 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id f140so2158737ybg.3;
        Fri, 23 Oct 2020 12:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8K+Yumi9kyjveoiqi6yCm6sjzyyeKTQw8sa+wYBvFMo=;
        b=UnopzMWWSCyXa63QdFguw02OBGdWTikzQkQudqsAMrJnUscWSSlVL12UcCk9TalHc4
         r1rVyrStj+d4nRjVXCqzgeHNyA8P1DXoLDw+g5k2aqc6JEgRcM6Y8DbwtXcb+r8cAsdQ
         8NwVZweudhjbO7Jnt78nq3XLaI6JLPi/PGOBq0mS0dFCYg5qRKiou+u+em5UYHOJwcjW
         +NLeJUhq2WL2Qim97fwCGzNF1tINbLYOp1axLgvVKxxlIpd31LJ0IzUj+SgXF5SFkKL9
         cxH1mYxVAQRlSLjCkNEJm9bSPEu54qD0FHxXXGMwhrhFhgijFxwm/8i5pr7YGBpKlWGV
         Yajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8K+Yumi9kyjveoiqi6yCm6sjzyyeKTQw8sa+wYBvFMo=;
        b=IJGIZIAedjfhGwXXQ7BN4ngvR2NeY3H5YtVnCUpxRp0pUX8U0kp8OuG8h7V9rlXh05
         O8+PU80j0W5SPBjAQs8s6LQzkvGRySSH0TXMHGdvFkFttS93xVMRVmdL4f+tDw47QMFL
         c9FkdbEwwKQUo1lPMfyWycq92ZTCxNmcbtxbadz5SJryai5Hv3OV2ggagL33G5rAcgLw
         rtNkxdrsHc9kn0/3j2Sv7sWU+8t7F6uyY15dfXNkvCGbFfiq5GP6/YIyfVUSqO5Iy6TN
         15D6OxV+spXfjtJKKUnw9OBwQmV56Vhj6YuRnqsFWXROrAoUd+1Voh9ae4zr7mAUEgVs
         33rg==
X-Gm-Message-State: AOAM532eUw+3oW9Nccrs5O8vvxDT7lrBDBDKIzz8RgVBoW7gwo2RkaX0
        Gbu6gjDFGGIg+IG7aYapp56Nt9D/wny0RQnstW0=
X-Google-Smtp-Source: ABdhPJx/dzB7rSkpRF2uaX2RK0YpyYc9XOQ8HwbGIfnAuAF6ycqR7/0I8zKjHkG3TQdzvF4dzym2Ix6k3/a5rAqToZc=
X-Received: by 2002:a25:3443:: with SMTP id b64mr5587652yba.510.1603482386320;
 Fri, 23 Oct 2020 12:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201022082138.2322434-1-jolsa@kernel.org> <20201022082138.2322434-9-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Oct 2020 12:46:15 -0700
Message-ID: <CAEf4BzZ9zwA=SrLTx9JT50OeM6fVPg0Py0Gx+K9ah2we8YtCRA@mail.gmail.com>
Subject: Re: [RFC bpf-next 08/16] bpf: Use delayed link free in bpf_link_put
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 8:01 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Moving bpf_link_free call into delayed processing so we don't
> need to wait for it when releasing the link.
>
> For example bpf_tracing_link_release could take considerable
> amount of time in bpf_trampoline_put function due to
> synchronize_rcu_tasks call.
>
> It speeds up bpftrace release time in following example:
>
> Before:
>
>  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s*
>     { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
>
>      3,290,457,628      cycles:k                                 ( +-  0.27% )
>        933,581,973      cycles:u                                 ( +-  0.20% )
>
>              50.25 +- 4.79 seconds time elapsed  ( +-  9.53% )
>
> After:
>
>  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s*
>     { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
>
>      2,535,458,767      cycles:k                                 ( +-  0.55% )
>        940,046,382      cycles:u                                 ( +-  0.27% )
>
>              33.60 +- 3.27 seconds time elapsed  ( +-  9.73% )
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/syscall.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 1110ecd7d1f3..61ef29f9177d 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2346,12 +2346,8 @@ void bpf_link_put(struct bpf_link *link)
>         if (!atomic64_dec_and_test(&link->refcnt))
>                 return;
>
> -       if (in_atomic()) {
> -               INIT_WORK(&link->work, bpf_link_put_deferred);
> -               schedule_work(&link->work);
> -       } else {
> -               bpf_link_free(link);
> -       }
> +       INIT_WORK(&link->work, bpf_link_put_deferred);
> +       schedule_work(&link->work);

We just recently reverted this exact change. Doing this makes it
non-deterministic from user-space POV when the BPF program is
**actually** detached. This makes user-space programming much more
complicated and unpredictable. So please don't do this. Let's find
some other way to speed this up.

>  }
>
>  static int bpf_link_release(struct inode *inode, struct file *filp)
> --
> 2.26.2
>
