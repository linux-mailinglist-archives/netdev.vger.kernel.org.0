Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13A92F710E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 04:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732557AbhAODkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 22:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732512AbhAODko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 22:40:44 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A680C061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 19:40:04 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id v126so10515318qkd.11
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 19:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rfrYO+PzQZa2QgXSwKBu/qFaywy+T6Io8dlHNEUX3yI=;
        b=n4kETA0UJ2RPfhp5JNojIlpHVNNZficpwIcG6VF6OCwbB6kubdjLD2SR/BJ5DqMcJo
         k/1ejG49tWV9zHJrLsLNUXWHCpgXUkkRYWqz0ieWz4c8robiPwzsMTVSJop0D0apfwGW
         sCRApvTXm8DTS0jD126seaO0xdOYe93R5H/jlNo3YxhlboiooQ3T2bJPdgZZ9KPSzbYR
         C7+HznQpPHl3hR/fP6O7b8Mis9U67mbXWriFKl+nx/KWFhK/ESxJUuJyhNnMEntSmSk4
         Ws5UAuPVva/LjXZdChHAw6gVLwhrU88AudBfoFGqjQn+INB1jIBlzu/rVX/3hy53F4Sj
         AZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rfrYO+PzQZa2QgXSwKBu/qFaywy+T6Io8dlHNEUX3yI=;
        b=LxS0RgL93tbcgiuIjBjzVGou1KvfwtZuu/FMCb4UUfFMUMhMeQgUi4zTTsnf1KF6da
         PBzuuZZDcWNrPVjBF1ThPF9EeRqrJCBWvGH7YM/griMIbUQdDjMa+aNX1dnzFKgVMJw9
         WtwbY6ulP5mG4sXgd27tLWJKSRN29tPoDdp+pUFtiDKkJVsE7ZXN51nR4tXSn7b51/y+
         /q4hxKC+GfSzgtmCU1E00R6ohuyt3x1U//z/MAsq4LNmtMsk5ktHovDw8EMBJWLA3D0V
         /cX6o3wpPNxBxzRN0IldzrwOkSYGgB062X7H8a9MZTuzYHeztqVMYzo1lvs1UjD6x/CS
         RGzQ==
X-Gm-Message-State: AOAM531Vbv7ovRbjauxUsJefaYqSj6p36XcV26sDlUIHXuQfRiHUkM0W
        cJ+91I76iNRHAPgE6vU9guS26jC/+aRTS93mcCs7peQfhSkBNA==
X-Google-Smtp-Source: ABdhPJxXAHrb2NsmvMNmhQMUV91h9BRzJJOWXPngoYyejvZNF3LZUpmlGg9PJfyt2CNYzclJ9nOXtG5fDk8MxCb5GVc=
X-Received: by 2002:a05:620a:b0f:: with SMTP id t15mr10667659qkg.485.1610682003281;
 Thu, 14 Jan 2021 19:40:03 -0800 (PST)
MIME-Version: 1.0
References: <20210113213321.2832906-1-sdf@google.com> <20210113213321.2832906-2-sdf@google.com>
 <CAADnVQLssJ4oStg7C4W-nafFKaka1H3-N0DhsBrB3FdmgyUC_A@mail.gmail.com>
In-Reply-To: <CAADnVQLssJ4oStg7C4W-nafFKaka1H3-N0DhsBrB3FdmgyUC_A@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 14 Jan 2021 19:39:52 -0800
Message-ID: <CAKH8qBsaZjOkvGZuNCtG=V2M9YfAJgtG+moAejwtBCB6kNJUwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 7:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jan 13, 2021 at 1:33 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > call in do_tcp_getsockopt using the on-stack data. This removes
> > 3% overhead for locking/unlocking the socket.
> >
> > Without this patch:
> >      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> >             |
> >              --3.30%--__cgroup_bpf_run_filter_getsockopt
> >                        |
> >                         --0.81%--__kmalloc
> >
> > With the patch applied:
> >      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
>
> Few issues in this patch and the patch 2 doesn't apply:
> Switched to a new branch 'tmp'
> Applying: bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
> .git/rebase-apply/patch:295: trailing whitespace.
> #endif
> .git/rebase-apply/patch:306: trailing whitespace.
> union tcp_word_hdr {
> .git/rebase-apply/patch:309: trailing whitespace.
> };
> .git/rebase-apply/patch:311: trailing whitespace.
> #define tcp_flag_word(tp) ( ((union tcp_word_hdr *)(tp))->words [3])
> .git/rebase-apply/patch:313: trailing whitespace.
> enum {
> warning: squelched 1 whitespace error
> warning: 6 lines add whitespace errors.
> Applying: bpf: Try to avoid kzalloc in cgroup/{s,g}etsockopt
> error: patch failed: kernel/bpf/cgroup.c:1390
> error: kernel/bpf/cgroup.c: patch does not apply
> Patch failed at 0002 bpf: Try to avoid kzalloc in cgroup/{s,g}etsockopt
Sorry, I mentioned in the cover letter that the series requires
4be34f3d0731 ("bpf: Don't leak memory in bpf getsockopt when optlen == 0")
which is only in the bpf tree. No sure when bpf & bpf-next merge.
Or are you trying to apply on top of that?
