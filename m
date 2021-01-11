Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0530F2F22F0
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 23:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390627AbhAKWiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 17:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389096AbhAKWiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:38:54 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB23C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 14:38:14 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id c1so455806qtc.1
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 14:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1IW7/fA5Ajyrajc5mHJ+bzWkjlO8sJ5wBoYvYk1qyMk=;
        b=qiUGdxhyZ/jXKqbUHNvYgtgB9M+Rh9rbb3Npig26GC1lL4XTTdOiiQ/gontOj/LIVI
         A+tEQSxDNRGgdkKgHP/qTFPypIUUvF6a6CR5RYQnipejS2L2+KbVDUKNPCsnZ4MzUsXX
         68JKvIx4H1pOjR5wJ8b8MNiSeR/v/ztnRqhi4sUot882w7QHJ7mO4+SWNavFtBDg/yh1
         UPAkFVq2o/RIzliXy/c65nbXm/cVhfNH2MTMI7ptrPEMgNVAnOySSA552JmFYkR1Li5d
         dBhAEb6seq32zbhgBVbdODr9zxbI19z5TX8mZGyo78cqORracYGNWTkUZ2cgxKVmiPzG
         SSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1IW7/fA5Ajyrajc5mHJ+bzWkjlO8sJ5wBoYvYk1qyMk=;
        b=bujT2NLZ4ysBeINF8dJgFX2zSF/eB9m6bOUk4CQU6/5V1gjRwAAs8FMtZZxA+e3xfJ
         LpZ1hapZfXPXrjX7YofuykKk08eObFMQ3ilErPTr4CKiEOG8yHQmwWAaJteYz08h/MUG
         x51KoTtkB/AbLrgwRww9z0LuM0p05xv3KV/GAA+rqcAjCaPqHEuJaS1ylnqpSBCwglq4
         ZtfeQfFa/1sLPLFOKdXP5/XvB1dmyMKp0h7jXJrIDpPNYkyo+vEcf5UWWIGXLuwnOoIN
         fRKHBkApFQjZAwyNCarEbuBXjW9YSqSlBTEE+CqqSkmA/0hzYiU7J5gtcL12OWUeuGWi
         3DcA==
X-Gm-Message-State: AOAM533HcCx3xRs6xQu2oS2tWvYXvxwLpQEJ/qJigaU7275bpNhIqoWA
        shsFeRsXuSM2Vw18oB/52Rz/eo3mOa4udVrWKSI89w==
X-Google-Smtp-Source: ABdhPJzwUnKoof2dPPa2mnGWtCOMilsy3FsJPpd3WHsZyuS9wxzrdEm6ffM+umMXDZXE8STiYP0j+o4y2SF29NTRpsU=
X-Received: by 2002:ac8:4f45:: with SMTP id i5mr1827132qtw.349.1610404693053;
 Mon, 11 Jan 2021 14:38:13 -0800 (PST)
MIME-Version: 1.0
References: <20210111194738.132139-1-sdf@google.com> <20210111223147.crc56dz52j342wlb@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210111223147.crc56dz52j342wlb@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 11 Jan 2021 14:38:02 -0800
Message-ID: <CAKH8qBtM_56n15sxVV1CT9c0XGm-W1neYhUktasd1qGHJoN9mQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: don't leak memory in bpf getsockopt when optlen
 == 0
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 2:32 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, Jan 11, 2021 at 11:47:38AM -0800, Stanislav Fomichev wrote:
> > optlen == 0 indicates that the kernel should ignore BPF buffer
> > and use the original one from the user. We, however, forget
> > to free the temporary buffer that we've allocated for BPF.
> >
> > Reported-by: Martin KaFai Lau <kafai@fb.com>
> > Fixes: d8fe449a9c51 ("bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE")
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  kernel/bpf/cgroup.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 6ec088a96302..09179ab72c03 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -1395,7 +1395,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> >       }
> >
> >  out:
> > -     if (ret)
> > +     if (*kernel_optval == NULL)
> It seems fragile to depend on the caller to init *kernel_optval to NULL.
We can manually reset it to NULL when we enter
__cgroup_bpf_run_filter_setsockopt,
I didn't bother since there is only one existing caller.

But you patch also LGTM, I don't really have a preference.

> How about something like:
>
> diff --git i/kernel/bpf/cgroup.c w/kernel/bpf/cgroup.c
> index 6ec088a96302..8d94c004e781 100644
> --- i/kernel/bpf/cgroup.c
> +++ w/kernel/bpf/cgroup.c
> @@ -1358,7 +1358,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>
>         if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) != 0) {
>                 ret = -EFAULT;
> -               goto out;
> +               goto err_out;
>         }
>
>         lock_sock(sk);
> @@ -1368,7 +1368,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>
>         if (!ret) {
>                 ret = -EPERM;
> -               goto out;
> +               goto err_out;
>         }
>
>         if (ctx.optlen == -1) {
> @@ -1379,7 +1379,6 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>                 ret = -EFAULT;
>         } else {
>                 /* optlen within bounds, run kernel handler */
> -               ret = 0;
>
>                 /* export any potential modifications */
>                 *level = ctx.level;
> @@ -1391,12 +1390,15 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>                 if (ctx.optlen != 0) {
>                         *optlen = ctx.optlen;
>                         *kernel_optval = ctx.optval;
> +               } else {
> +                       sockopt_free_buf(&ctx);
>                 }
> +
> +               return 0;
>         }
>
> -out:
> -       if (ret)
> -               sockopt_free_buf(&ctx);
> +err_out:
> +       sockopt_free_buf(&ctx);
>         return ret;
>  }
