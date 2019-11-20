Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09194104448
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 20:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfKTT1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 14:27:04 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41536 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbfKTT1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 14:27:04 -0500
Received: by mail-qk1-f195.google.com with SMTP id m125so841347qkd.8;
        Wed, 20 Nov 2019 11:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3HrkdqvmN50aApe/piV/XuKcLpcUtPhjJ0WX/3o8nwo=;
        b=N5s5y0qLM5KtmwAaJh3NhmrqUz3XY3dX03L4KihrtyKazbHyonJuMoBeb0YFULfRnd
         nvUK+nD2Tn48xzX7uuRYQz35aScpQN7tN+eIIOPvdGtMDOkpItAIpNgggAJVXjGGUZs8
         cDQpIpKoXcPoMsGVS1XnxZy2I2YHGmtRq7nkCnNXKLJkCQ0I5hMyG5hRZX2koNLpdhzj
         Ye+5/e3u0Thfl7Q6sNbZqc+x75Rwug0Y+BAl5U16XwV6l21Gqqtx/dVCLUMq0Y9Ff+yy
         bHfdTp9Ucmi7pfUh8dwmGGPqGk7lRGNGIn6OzId90WrpDHf4SJ/qFxtGDjo/1U5/HtCY
         qmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3HrkdqvmN50aApe/piV/XuKcLpcUtPhjJ0WX/3o8nwo=;
        b=aouC4c2yX11PSr2zp6ofhf8QbC/9G7Q9ECavcjKbL/Bn0gsH6q/jrMO2sisEKEj4xu
         F1luUjDaHNcM9yI5QSxgeRTjr099n7n7aSdVo8ImHDHPk7ZxMI/N0MyzAcY3uWQ3ypnF
         mU0Fk6KaeGILMX8BHqz+OTWzkrjqm7h/CXF7HB/sKtS0Eyq8yPI9yElu7pv1rUY2cD4+
         dkboLYt/kxI0g/A82dD0mhVsZ2nhOKncxgeaxFAKzD1hl0zm4GHxKPWWnKo3l6aFWD2S
         3Dnf2s67QC1zMV2ldcbfDCxMVxrRQ/NV4/pRVZF65ThYA0Htlf6nIE3WKFDcEwev3zOg
         w5Vw==
X-Gm-Message-State: APjAAAW9VGrTQFSfCK1MZrKh5TPFZ6twOYtsa85c13KAJrXzkZ+0NBJa
        jkqG069PoLEXMSSm71DV//yTrPT1RNxXxLnckac=
X-Google-Smtp-Source: APXvYqyxAKvqsE93jVX1fkVNkD0acLDJKfQD56ylxZvm3HoR+BMIVF9GQRF3Si0sTjxUv9IFTVsRynXWy/3cQlRnPaE=
X-Received: by 2002:a37:a685:: with SMTP id p127mr610729qke.449.1574278022329;
 Wed, 20 Nov 2019 11:27:02 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574126683.git.daniel@iogearbox.net> <fee9a309e61c4abee212b6287f41637aae78acbe.1574126683.git.daniel@iogearbox.net>
In-Reply-To: <fee9a309e61c4abee212b6287f41637aae78acbe.1574126683.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Nov 2019 11:26:51 -0800
Message-ID: <CAEf4BzYffw=COVaz8-xZeq8-=Wczmq-h+mAPdwoKTNYrpf739g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 8/8] bpf, testing: add various tail call test cases
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 5:38 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add several BPF kselftest cases for tail calls which test the various
> patch directions (NOP -> JMP, JMP -> JMP, JMP -> NOP), and that multiple
> locations are patched.
>
>   # ./test_progs -n 44
>   #44 tailcalls:OK
>   Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  .../selftests/bpf/prog_tests/tailcalls.c      | 210 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/tailcall1.c |  48 ++++
>  tools/testing/selftests/bpf/progs/tailcall2.c |  59 +++++
>  3 files changed, 317 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tailcalls.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tailcall1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tailcall2.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
> new file mode 100644
> index 000000000000..6862bb5f9688
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
> @@ -0,0 +1,210 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +
> +static void test_tailcall_1(void)
> +{
> +       int err, map_fd, prog_fd, main_fd, i, j;
> +       struct bpf_map *prog_array;
> +       struct bpf_program *prog;
> +       struct bpf_object *obj;
> +       __u32 retval, duration;
> +       char prog_name[32];
> +       char buff[128] = {};
> +
> +       err = bpf_prog_load("tailcall1.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
> +                           &prog_fd);
> +       if (CHECK_FAIL(err))
> +               return;
> +
> +       prog = bpf_object__find_program_by_title(obj, "classifier");
> +       if (CHECK_FAIL(!prog))
> +               goto out;
> +
> +       main_fd = bpf_program__fd(prog);
> +       if (CHECK_FAIL(main_fd < 0))
> +               goto out;


can this happen if bpf_prog_load succeeded? same for a bunch of
prog_fd checks below.

> +
> +       prog_array = bpf_object__find_map_by_name(obj, "jmp_table");
> +       if (CHECK_FAIL(!prog_array))
> +               goto out;
> +

[...]

> +
> +       for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
> +               err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
> +                                       &duration, &retval, NULL);
> +               CHECK(err || retval != i, "tailcall",
> +                     "err %d errno %d retval %d\n", err, errno, retval);
> +
> +               err = bpf_map_delete_elem(map_fd, &i);
> +               if (CHECK_FAIL(err))
> +                       goto out;
> +       }
> +
> +       /* Testing JMP -> NOP */

nit: this comment should probably go before previous loop?

> +       err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
> +                               &duration, &retval, NULL);
> +       CHECK(err || retval != 3, "tailcall", "err %d errno %d retval %d\n",
> +             err, errno, retval);
> +

[...]

> +       for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
> +               j = bpf_map__def(prog_array)->max_entries - 1 - i;
> +
> +               err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
> +                                       &duration, &retval, NULL);
> +               CHECK(err || retval != j, "tailcall",
> +                     "err %d errno %d retval %d\n", err, errno, retval);
> +
> +               err = bpf_map_delete_elem(map_fd, &i);

in addition to explicit delete, can you test update to NULL? Also, I
think it might be useful to validate update from NULL to NULL (it's a
separate check in your poke_run code).

> +               if (CHECK_FAIL(err))
> +                       goto out;
> +       }
> +
> +       err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
> +                               &duration, &retval, NULL);
> +       CHECK(err || retval != 3, "tailcall", "err %d errno %d retval %d\n",
> +             err, errno, retval);
> +out:
> +       bpf_object__close(obj);
> +}
> +

[...]

> +void test_tailcalls(void)
> +{
> +       test_tailcall_1();
> +       test_tailcall_2();
> +}

these could be sub-tests:


if (test__start_subtest("tailcall_1"))
    test_tailcall_1();
if (test__start_subtest("tailcall_2"))
    test_tailcall_2();

though, a bit more descriptive names would be certainly better :)

> diff --git a/tools/testing/selftests/bpf/progs/tailcall1.c b/tools/testing/selftests/bpf/progs/tailcall1.c
> new file mode 100644
> index 000000000000..63531e1a9fa4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/tailcall1.c
> @@ -0,0 +1,48 @@

[...]
