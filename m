Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7700E26C5ED
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 19:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgIPRZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 13:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgIPRZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:25:18 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8F6C061BD1
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 10:25:14 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k15so7734286wrn.10
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 10:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FLIuBcEfXFqBGnCMg96s4H8fMHjOET/yZlTCC4s2SjY=;
        b=iSKsbfCaH85JTyF93w9TDVj+qgI43v1QxUEyWe0EQUbDc2aQHYBMp7y1gRr8uJgVuM
         1cVf+stUl9US5B0yTdv8lUKTKT+fgWT5ER7KxMErMG5bzGAZRoKGiAAiQD7o1yhB+czu
         N8jMTmR0u6nEsuq1VQl1fAx9EM4X/d/DETGps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FLIuBcEfXFqBGnCMg96s4H8fMHjOET/yZlTCC4s2SjY=;
        b=kcp8i0Fup1l89ruDcp6ghJrYWOgyqvcUbgqkgXal61uQzD03gWOC/wNtXIDqXeqytn
         e5NUjjbdfc+6iGwbItbZlb+fuXAP5GbpTlou+80ubZFs1qQRb3tVPzIRU+sKuZORg+cN
         0qb9+LcdXqRHbjTfQaL+6qtgil1utKzdmyA15ho+CNyjrO1hqS6udNGcOm1ErHYECej7
         OekMyn3CtRtLzZOTiNJZGHKY96ge3KdT6A9OWjwmihmGhv3plvlQcTiqqtK1D4PlIZlb
         ZGOSovzjJBYLspNYk+KPc4bbmR5VeSQf81cT7oCRflsq/Bv6Pindjtc1LPMCS3FsYdzz
         q9lA==
X-Gm-Message-State: AOAM532BcHk7dJkBQgHbQnuViR1e4ZY523vzlH04tOFTRCLuf7zENsX4
        nq/yjYlXajTQRa9ZhLu0IdFT8WrFmmhGi0UPyid4Bw==
X-Google-Smtp-Source: ABdhPJzFG0CKotHKNUMxQnzas0sxg7FAmpAAmBAxshrbYB7YiD0VwMPfDZp16xsSPod2p+vLLrtXqNwlDt36g8M7VhU=
X-Received: by 2002:adf:e711:: with SMTP id c17mr28472007wrm.359.1600277113217;
 Wed, 16 Sep 2020 10:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200916112416.2321204-1-jolsa@kernel.org>
In-Reply-To: <20200916112416.2321204-1-jolsa@kernel.org>
From:   KP Singh <kpsingh@chromium.org>
Date:   Wed, 16 Sep 2020 19:25:02 +0200
Message-ID: <CACYkzJ7Y8WhVE9-6jSCC1svVLeuFFzXQ0Q-A9sjHomGQGgtZCw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix stat probe in d_path test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 1:24 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Some kernels builds might inline vfs_getattr call within fstat
> syscall code path, so fentry/vfs_getattr trampoline is not called.
>
> Alexei suggested [1] we should use security_inode_getattr instead,
> because it's less likely to get inlined.
>
> Adding security_inode_getattr to the d_path allowed list and
> switching the stat trampoline to security_inode_getattr.
>
> Adding flags that indicate trampolines were called and failing
> the test if any of them got missed, so it's easier to identify
> the issue next time.
>
> [1] https://lore.kernel.org/bpf/CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com/
> Fixes: e4d1af4b16f8 ("selftests/bpf: Add test for d_path helper")
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Acked-by: KP Singh <kpsingh@google.com>

> ---
>  kernel/trace/bpf_trace.c                        | 1 +
>  tools/testing/selftests/bpf/prog_tests/d_path.c | 6 ++++++
>  tools/testing/selftests/bpf/progs/test_d_path.c | 9 ++++++++-
>  3 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index b2a5380eb187..1001c053ebb3 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1122,6 +1122,7 @@ BTF_ID(func, vfs_truncate)
>  BTF_ID(func, vfs_fallocate)
>  BTF_ID(func, dentry_open)
>  BTF_ID(func, vfs_getattr)
> +BTF_ID(func, security_inode_getattr)
>  BTF_ID(func, filp_close)
>  BTF_SET_END(btf_allowlist_d_path)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
> index fc12e0d445ff..f507f1a6fa3a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/d_path.c
> +++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
> @@ -120,6 +120,12 @@ void test_d_path(void)
>         if (err < 0)
>                 goto cleanup;
>
> +       if (CHECK(!bss->called_stat || !bss->called_close,
> +                 "check",
> +                 "failed to call trampolines called_stat %d, bss->called_close %d\n",
> +                  bss->called_stat, bss->called_close))

optional:

maybe it's better to add two separate checks with specific error messages?

"stat", "trampoline for security_inode_getattr was not called\n"
"close", "trampoline for filp_close was not called\n"

I think this would make the output more readable.

- KP

> +               goto cleanup;
> +
>         for (int i = 0; i < MAX_FILES; i++) {
>                 CHECK(strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
>                       "check",

[...]

>         if (pid != my_pid)
>                 return 0;
>
> --
> 2.26.2
>
