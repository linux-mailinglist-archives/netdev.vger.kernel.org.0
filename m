Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85D25B0BC2
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiIGRqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiIGRqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:46:06 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE00A4076;
        Wed,  7 Sep 2022 10:46:01 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id 62so12091074iov.5;
        Wed, 07 Sep 2022 10:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=etqGEG1IsLc7y4+nfpEHnA8iCa8u/VWI1Z7w+pxJ8JQ=;
        b=p2fEuzr9nh9xc3In5S+N1QO+nIrt2g9ajVzCsqECmA0PwB5PZSSwHuc8xAvTsPQphQ
         Ne1cCnjtU0bH5cgdPHEnF3TL9z4whO/eRqboWSGER2f+GsgBNLAYH6pg52GTKT+E+0s+
         iVkNvjM2a5WgG8eX2A0/6YfplE36fHo8lqc1tGb/8JaCww85csNycvFzc9Tg27y/jL+2
         sL2KcePwD7pOp6TuGJisezIECddh1YGHHOpdowma7cZnaZKdAqPZHU/T/HZLEzjTCJaE
         I443yCEd/FLujkSrYaOftXGg91wCQVlg/AaKu/TI381dlfnP29v2p9LrRfKAfPWAg6f0
         0fpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=etqGEG1IsLc7y4+nfpEHnA8iCa8u/VWI1Z7w+pxJ8JQ=;
        b=wIhYmm13w2yHxOPrGJ1SfFmR+W0WbdjMJQLWj/mNe6RopUqW+VCaKR7ece2CdGq5g2
         tcKlnqtpUnKM9Ma7xRSk13LHBQDp3sMGmOYNhVTZvnnZQAh44x0+6nOdO9W7DXB0njWV
         NBJ0rZNOl6MIc3NSWjcdXSQLMjQ1RZkOFWE8T3YD1/QeFqYSKKP7eR5GHeli6DqP9dWu
         okaDoWRUfzjPmN0wtP3zympPuaMJ1PoJ/CLBto9xDKlt/uVQec6eQLgRybdryEbu/jKV
         FG4S2gd3LQ44lEjpMHcG4SLIGXTaY0tmeJj1axXFB4ISI66mMcign1iJMhsFCVHcam/K
         q8Cg==
X-Gm-Message-State: ACgBeo1moc8wpyslfGyJ5rbRmLbaqCOpRZpfGjqJCi+RqZDFo+1NTyT1
        9RbcNvDMRPKoDxcWS0KPRLsNfH3Qtn9DyCGo0HY=
X-Google-Smtp-Source: AA6agR6BUx6igUuAsTrhRZyZ05ktXQ/AyDG641fczoUfH3SE9Y0RGS+fB31x3WYEaUbacTM7O3tnZTj6ZRuW5MJJRDE=
X-Received: by 2002:a05:6638:3802:b0:351:d8a5:6d58 with SMTP id
 i2-20020a056638380200b00351d8a56d58mr2808510jav.206.1662572760259; Wed, 07
 Sep 2022 10:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com> <20220906151303.2780789-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20220906151303.2780789-5-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 7 Sep 2022 19:45:24 +0200
Message-ID: <CAP01T76Q4VGYveL=6NoRFsgjFvLTLLF8jER0HwU1hx+maqo7Tg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v11 4/7] selftests/bpf: add test for accessing
 ctx from syscall program type
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Sept 2022 at 17:13, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> We need to also export the kfunc set to the syscall program type,
> and then add a couple of eBPF programs that are testing those calls.
>
> The first one checks for valid access, and the second one is OK
> from a static analysis point of view but fails at run time because
> we are trying to access outside of the allocated memory.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---

CI is failing for test_progs-no_alu32:
https://github.com/kernel-patches/bpf/runs/8220916615?check_suite_focus=true

>
> changes in v11:
> - use new way of declaring tests
>
> changes in v10:
> - use new definitions for tests in an array
> - add a new kfunc syscall_test_null_fail test
>
> no changes in v9
>
> no changes in v8
>
> changes in v7:
> - add 1 more case to ensure we can read the entire sizeof(ctx)
> - add a test case for when the context is NULL
>
> new in v6
> ---
>  net/bpf/test_run.c                            |   1 +
>  .../selftests/bpf/prog_tests/kfunc_call.c     | 143 +++++++++++++++++-
>  .../selftests/bpf/progs/kfunc_call_fail.c     |  39 +++++
>  .../selftests/bpf/progs/kfunc_call_test.c     |  38 +++++
>  4 files changed, 214 insertions(+), 7 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_fail.c
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 25d8ecf105aa..f16baf977a21 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -1634,6 +1634,7 @@ static int __init bpf_prog_test_run_init(void)
>
>         ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
>         ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &bpf_prog_test_kfunc_set);
> +       ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_prog_test_kfunc_set);
>         return ret ?: register_btf_id_dtor_kfuncs(bpf_prog_test_dtor_kfunc,
>                                                   ARRAY_SIZE(bpf_prog_test_dtor_kfunc),
>                                                   THIS_MODULE);
> diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> index 9dfbe5355a2d..d5881c3331a8 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> @@ -2,6 +2,7 @@
>  /* Copyright (c) 2021 Facebook */
>  #include <test_progs.h>
>  #include <network_helpers.h>
> +#include "kfunc_call_fail.skel.h"
>  #include "kfunc_call_test.skel.h"
>  #include "kfunc_call_test.lskel.h"
>  #include "kfunc_call_test_subprog.skel.h"
> @@ -10,37 +11,96 @@
>
>  #include "cap_helpers.h"
>
> +static size_t log_buf_sz = 1048576; /* 1 MB */
> +static char obj_log_buf[1048576];
> +
> +enum kfunc_test_type {
> +       tc_test = 0,
> +       syscall_test,
> +       syscall_null_ctx_test,
> +};
> +
>  struct kfunc_test_params {
>         const char *prog_name;
>         unsigned long lskel_prog_desc_offset;
>         int retval;
> +       enum kfunc_test_type test_type;
> +       const char *expected_err_msg;
>  };
>
> -#define TC_TEST(name, __retval) \
> +#define __BPF_TEST_SUCCESS(name, __retval, type) \
>         { \
>           .prog_name = #name, \
>           .lskel_prog_desc_offset = offsetof(struct kfunc_call_test_lskel, progs.name), \
>           .retval = __retval, \
> +         .test_type = type, \
> +         .expected_err_msg = NULL, \
> +       }
> +
> +#define __BPF_TEST_FAIL(name, __retval, type, error_msg) \
> +       { \
> +         .prog_name = #name, \
> +         .lskel_prog_desc_offset = 0 /* unused when test is failing */, \
> +         .retval = __retval, \
> +         .test_type = type, \
> +         .expected_err_msg = error_msg, \
>         }
>
> +#define TC_TEST(name, retval) __BPF_TEST_SUCCESS(name, retval, tc_test)
> +#define SYSCALL_TEST(name, retval) __BPF_TEST_SUCCESS(name, retval, syscall_test)
> +#define SYSCALL_NULL_CTX_TEST(name, retval) __BPF_TEST_SUCCESS(name, retval, syscall_null_ctx_test)
> +
> +#define SYSCALL_NULL_CTX_FAIL(name, retval, error_msg) \
> +       __BPF_TEST_FAIL(name, retval, syscall_null_ctx_test, error_msg)
> +
>  static struct kfunc_test_params kfunc_tests[] = {
> +       /* failure cases:
> +        * if retval is 0 -> the program will fail to load and the error message is an error
> +        * if retval is not 0 -> the program can be loaded but running it will gives the
> +        *                       provided return value. The error message is thus the one
> +        *                       from a successful load
> +        */
> +       SYSCALL_NULL_CTX_FAIL(kfunc_syscall_test_fail, -EINVAL, "processed 4 insns"),
> +       SYSCALL_NULL_CTX_FAIL(kfunc_syscall_test_null_fail, -EINVAL, "processed 4 insns"),
> +
> +       /* success cases */
>         TC_TEST(kfunc_call_test1, 12),
>         TC_TEST(kfunc_call_test2, 3),
>         TC_TEST(kfunc_call_test_ref_btf_id, 0),
> +       SYSCALL_TEST(kfunc_syscall_test, 0),
> +       SYSCALL_NULL_CTX_TEST(kfunc_syscall_test_null, 0),
> +};
> +
> +struct syscall_test_args {
> +       __u8 data[16];
> +       size_t size;
>  };
>
>  static void verify_success(struct kfunc_test_params *param)
>  {
>         struct kfunc_call_test_lskel *lskel = NULL;
> +       LIBBPF_OPTS(bpf_test_run_opts, topts);
>         struct bpf_prog_desc *lskel_prog;
>         struct kfunc_call_test *skel;
>         struct bpf_program *prog;
>         int prog_fd, err;
> -       LIBBPF_OPTS(bpf_test_run_opts, topts,
> -               .data_in = &pkt_v4,
> -               .data_size_in = sizeof(pkt_v4),
> -               .repeat = 1,
> -       );
> +       struct syscall_test_args args = {
> +               .size = 10,
> +       };
> +
> +       switch (param->test_type) {
> +       case syscall_test:
> +               topts.ctx_in = &args;
> +               topts.ctx_size_in = sizeof(args);
> +               /* fallthrough */
> +       case syscall_null_ctx_test:
> +               break;
> +       case tc_test:
> +               topts.data_in = &pkt_v4;
> +               topts.data_size_in = sizeof(pkt_v4);
> +               topts.repeat = 1;
> +               break;
> +       }
>
>         /* first test with normal libbpf */
>         skel = kfunc_call_test__open_and_load();
> @@ -79,6 +139,72 @@ static void verify_success(struct kfunc_test_params *param)
>                 kfunc_call_test_lskel__destroy(lskel);
>  }
>
> +static void verify_fail(struct kfunc_test_params *param)
> +{
> +       LIBBPF_OPTS(bpf_object_open_opts, opts);
> +       LIBBPF_OPTS(bpf_test_run_opts, topts);
> +       struct bpf_program *prog;
> +       struct kfunc_call_fail *skel;
> +       int prog_fd, err;
> +       struct syscall_test_args args = {
> +               .size = 10,
> +       };
> +
> +       opts.kernel_log_buf = obj_log_buf;
> +       opts.kernel_log_size = log_buf_sz;
> +       opts.kernel_log_level = 1;
> +
> +       switch (param->test_type) {
> +       case syscall_test:
> +               topts.ctx_in = &args;
> +               topts.ctx_size_in = sizeof(args);
> +               /* fallthrough */
> +       case syscall_null_ctx_test:
> +               break;
> +       case tc_test:
> +               topts.data_in = &pkt_v4;
> +               topts.data_size_in = sizeof(pkt_v4);
> +               break;
> +               topts.repeat = 1;
> +       }
> +
> +       skel = kfunc_call_fail__open_opts(&opts);
> +       if (!ASSERT_OK_PTR(skel, "kfunc_call_fail__open_opts"))
> +               goto cleanup;
> +
> +       prog = bpf_object__find_program_by_name(skel->obj, param->prog_name);
> +       if (!ASSERT_OK_PTR(prog, "bpf_object__find_program_by_name"))
> +               goto cleanup;
> +
> +       bpf_program__set_autoload(prog, true);
> +
> +       err = kfunc_call_fail__load(skel);
> +       if (!param->retval) {
> +               /* the verifier is supposed to complain and refuses to load */
> +               if (!ASSERT_ERR(err, "unexpected load success"))
> +                       goto out_err;
> +
> +       } else {
> +               /* the program is loaded but must dynamically fail */
> +               if (!ASSERT_OK(err, "unexpected load error"))
> +                       goto out_err;
> +
> +               prog_fd = bpf_program__fd(prog);
> +               err = bpf_prog_test_run_opts(prog_fd, &topts);
> +               if (!ASSERT_EQ(err, param->retval, param->prog_name))
> +                       goto out_err;
> +       }
> +
> +out_err:
> +       if (!ASSERT_OK_PTR(strstr(obj_log_buf, param->expected_err_msg), "expected_err_msg")) {
> +               fprintf(stderr, "Expected err_msg: %s\n", param->expected_err_msg);
> +               fprintf(stderr, "Verifier output: %s\n", obj_log_buf);
> +       }
> +
> +cleanup:
> +       kfunc_call_fail__destroy(skel);
> +}
> +
>  static void test_main(void)
>  {
>         int i;
> @@ -87,7 +213,10 @@ static void test_main(void)
>                 if (!test__start_subtest(kfunc_tests[i].prog_name))
>                         continue;
>
> -               verify_success(&kfunc_tests[i]);
> +               if (!kfunc_tests[i].expected_err_msg)
> +                       verify_success(&kfunc_tests[i]);
> +               else
> +                       verify_fail(&kfunc_tests[i]);
>         }
>  }
>
> diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_fail.c b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
> new file mode 100644
> index 000000000000..4168027f2ab1
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +
> +extern void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
> +
> +struct syscall_test_args {
> +       __u8 data[16];
> +       size_t size;
> +};
> +
> +SEC("?syscall")
> +int kfunc_syscall_test_fail(struct syscall_test_args *args)
> +{
> +       bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args) + 1);
> +
> +       return 0;
> +}
> +
> +SEC("?syscall")
> +int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
> +{
> +       /* Must be called with args as a NULL pointer
> +        * we do not check for it to have the verifier consider that
> +        * the pointer might not be null, and so we can load it.
> +        *
> +        * So the following can not be added:
> +        *
> +        * if (args)
> +        *      return -22;
> +        */
> +
> +       bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> index 5aecbb9fdc68..94c05267e5e7 100644
> --- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> +++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> @@ -92,4 +92,42 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
>         return 0;
>  }
>
> +struct syscall_test_args {
> +       __u8 data[16];
> +       size_t size;
> +};
> +
> +SEC("syscall")
> +int kfunc_syscall_test(struct syscall_test_args *args)
> +{
> +       const int size = args->size;
> +
> +       if (size > sizeof(args->data))
> +               return -7; /* -E2BIG */
> +

Looks like it is due to this. Verifier is confused because:
r7 = args->data;
r1 = r7;

then it does r1 <<= 32; r1 >>=32; clearing upper 32 bits, so both r1
and r7 lose the id association which propagates the bounds of r1
learnt from comparison of it with sizeof(args->data);

> +       bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(args->data));
> +       bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args));

Later llvm assigns r7 to r2 for this call's 2nd arg. At this point the
verifier still thinks r7 is unbounded, while to make a call with mem,
len pair you need non-negative min value.

Easiest way might be to just do args->size & sizeof(args->data), as
the verifier log says. You might still keep the error above.
Others may have better ideas/insights.

> +       bpf_kfunc_call_test_mem_len_pass1(&args->data, size);
> +
> +       return 0;
> +}
> +
> +SEC("syscall")
> +int kfunc_syscall_test_null(struct syscall_test_args *args)
> +{
> +       /* Must be called with args as a NULL pointer
> +        * we do not check for it to have the verifier consider that
> +        * the pointer might not be null, and so we can load it.
> +        *
> +        * So the following can not be added:
> +        *
> +        * if (args)
> +        *      return -22;
> +        */
> +
> +       bpf_kfunc_call_test_mem_len_pass1(args, 0);
> +
> +       return 0;
> +}
> +
>  char _license[] SEC("license") = "GPL";
> --
> 2.36.1
>
