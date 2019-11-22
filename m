Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BAC10670B
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKVH1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:27:13 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38649 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfKVH1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:27:13 -0500
Received: by mail-lj1-f196.google.com with SMTP id v8so6168197ljh.5;
        Thu, 21 Nov 2019 23:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JXodrqg0Ns9fDSfl3NpT9xgzI8A0tSboj9r6ouzs1nQ=;
        b=f9a9jG7Yga7eCX/RCPBoI4sJjsG/OXDrxi4R1+XYPf03uDc1Pi83E6ZVRBCAUfknxA
         UJkjRvMzjJ9iCDwX1zFBas9f+qAXCfDbIdxXvOlrrrkHZrlsRCqq/iafKohLQoDuYvZj
         OZKGna5sMB6QI4KdO4oSb9NLFeiaB2ed//zsscR17sLeAyLgTkbe8Jbdyoh/wNoA+BEw
         4nF1e7nbcQjyl5/2LXc54GaquYPr1ST4qKYklnn3yfSlavH3Y1tFXLTOYSPu9bVui5U6
         6EWNnaRSCOCwlPKZJXXkc9zlisE8luR6jDxTcX8nbglCD/v/EXFaBAIHXWcRY2N1nBOB
         4ukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JXodrqg0Ns9fDSfl3NpT9xgzI8A0tSboj9r6ouzs1nQ=;
        b=E+0sM2voBHWaAaJwqbRy4zcBEMj+YjH+lwaI4wYql4Emrhhts+y/f6oryEmgWbWA9u
         l/E8paM9yD3jjmkILaHQWjou2r6Sq+fUOMdOZhf3Uw4/FA8G/vq9wGm/o53iiqPMx3K1
         17GrNgk096JutszI9OfB3pg7TnvcCXM9S+EPXzq8BTvek9ft0w1iLRIEeI/2IeoBSAwK
         uQkcEK35OK9LYK6iZeSHpup145b/zXlGcsiyTn87xJ4FQTh0tc697oGZvC4jnw4D2qHQ
         DbTxRhDmqXvWgv7BEn3mFoGYTcg1/mTbkV2izUxmMj7t5IchJzRg/WAbQJ4i3XeBd3ks
         2egQ==
X-Gm-Message-State: APjAAAX/vnUb9JwE8KcZPYpudG4AcIUqs4nUxOOF7W5XYBX50BR4TioV
        0m9sAE+v2QVBHCNHbBPLHFGhbyHGgNpX/Io8C8Y=
X-Google-Smtp-Source: APXvYqxYs63Myf6KumzAMSV2SQQHoHtIOOwunSkfmhax/GjzRFVbYMQ2hws1G/UkzCLv7i2CGpQ9a+rsCoQ85pt7+7s=
X-Received: by 2002:a2e:b5b8:: with SMTP id f24mr10676623ljn.188.1574407630969;
 Thu, 21 Nov 2019 23:27:10 -0800 (PST)
MIME-Version: 1.0
References: <20191121175900.3486133-1-andriin@fb.com>
In-Reply-To: <20191121175900.3486133-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Nov 2019 23:26:59 -0800
Message-ID: <CAADnVQ+=NVQg_=eUudG3Q9knGHbwBzx8bKH+1oWemtpn23HfwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: ensure core_reloc_kernel is
 reading test_progs's data only
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 9:59 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> test_core_reloc_kernel.c selftest is the only CO-RE test that reads and
> returns for validation calling thread's information (pid, tgid, comm). Thus it
> has to make sure that only test_prog's invocations are honored.
>
> Fixes: df36e621418b ("selftests/bpf: add CO-RE relocs testing setup")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../selftests/bpf/prog_tests/core_reloc.c        | 16 +++++++++++-----
>  .../selftests/bpf/progs/test_core_reloc_kernel.c |  4 ++++
>  2 files changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> index ec9e2fdd6b89..05fe85281ff7 100644
> --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> @@ -2,6 +2,7 @@
>  #include <test_progs.h>
>  #include "progs/core_reloc_types.h"
>  #include <sys/mman.h>
> +#include <sys/syscall.h>
>
>  #define STRUCT_TO_CHAR_PTR(struct_name) (const char *)&(struct struct_name)
>
> @@ -452,6 +453,7 @@ static struct core_reloc_test_case test_cases[] = {
>  struct data {
>         char in[256];
>         char out[256];
> +       uint64_t my_pid_tgid;
>  };
>
>  static size_t roundup_page(size_t sz)
> @@ -471,9 +473,12 @@ void test_core_reloc(void)
>         struct bpf_map *data_map;
>         struct bpf_program *prog;
>         struct bpf_object *obj;
> +       uint64_t my_pid_tgid;
>         struct data *data;
>         void *mmap_data = NULL;
>
> +       my_pid_tgid = getpid() | ((uint64_t)syscall(SYS_gettid) << 32);
> +
>         for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
>                 test_case = &test_cases[i];
>                 if (!test__start_subtest(test_case->case_name))
> @@ -517,11 +522,6 @@ void test_core_reloc(void)
>                                 goto cleanup;
>                 }
>
> -               link = bpf_program__attach_raw_tracepoint(prog, tp_name);
> -               if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
> -                         PTR_ERR(link)))
> -                       goto cleanup;
> -
>                 data_map = bpf_object__find_map_by_name(obj, "test_cor.bss");
>                 if (CHECK(!data_map, "find_data_map", "data map not found\n"))
>                         goto cleanup;
> @@ -537,6 +537,12 @@ void test_core_reloc(void)
>
>                 memset(mmap_data, 0, sizeof(*data));
>                 memcpy(data->in, test_case->input, test_case->input_len);
> +               data->my_pid_tgid = my_pid_tgid;
> +
> +               link = bpf_program__attach_raw_tracepoint(prog, tp_name);
> +               if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
> +                         PTR_ERR(link)))
> +                       goto cleanup;
>
>                 /* trigger test run */
>                 usleep(1);
> diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> index a4b5e0562ed5..d2fe8f337846 100644
> --- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> @@ -11,6 +11,7 @@ char _license[] SEC("license") = "GPL";
>  static volatile struct data {
>         char in[256];
>         char out[256];
> +       uint64_t my_pid_tgid;
>  } data;

There was a conflict here, since global data support patchset was
already applied.
I resolved it and applied to bpf-next.
Thanks
