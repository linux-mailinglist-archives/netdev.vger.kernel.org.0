Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852B7299A31
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395434AbgJZXIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:08:12 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:40933 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394676AbgJZXIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 19:08:10 -0400
Received: by mail-yb1-f193.google.com with SMTP id n142so9105921ybf.7;
        Mon, 26 Oct 2020 16:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kY3ST5v22Tq7SgipsKGJCPPLOdbub6AVwGCbFCogewY=;
        b=vevT0upiGembVlwg+p1QaMFmS1TC2tInlZh8A1flekbSfcoGX63Kl/xQAKtuObZnpD
         9k9wcD0oTwrrtEXIkiae2hDEQeKdlfLpOITaut6uwOMJBNyacCo1bpPA05z2YymW/svo
         glQzdq9ueZ8ndES1zq+ykrnUOzM/PhkZxahAyozEM4PIZAEKDd7txYnygbIlCn63LDXL
         91L9FlT7IKB9hZriRFfE03Wz3owor5BVXmznD+vf+13yLwq2twCUCVQS+KKYT7lRUKqn
         d+BpsFqPrvr5fOI1tsGKYCdqTIiZie1SMQMQWVEhQaQ9sFzqHEMNyTLVLwYecdNUmfAI
         w1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kY3ST5v22Tq7SgipsKGJCPPLOdbub6AVwGCbFCogewY=;
        b=LP7+Zt0TW+DXJFCE4iNGIQyIBML/aq9cfvrCz3huXrfxULsRYJkFO51HKIIpFhImQu
         Ejbm8w36HLDasPGaBX7vGbcemoLzXhnJV/FmcYZulOjlhkemHelL5p1IqluNQ3oAud84
         tL8c7FBl0PGS9ZZDwHg5hGsluydjlL36zJalQdkMtxNhcxGEsQTSE20TGoJZ6iSQWWLu
         YNxhBoJPGIJ9WE85sn6FL2oPzWgXNAmZMlF0nPMmYN1lmjYxI0qrYw+5BwEVCd+xwguG
         P1mkvGVS4ChcQ6M/mz/NEolKbRxy14AWhMmJJaGoisGsyIfo+S7KAGUHziEaPeaYmn7r
         ffeA==
X-Gm-Message-State: AOAM5327htnXxNa/7UnhsFY/uN3m4ulmJiEOul2rbWXwyLsvOJw6WY8H
        UFFbcYuqlkbGufDuOEY59LDCmkkrHuuVm1mawmY=
X-Google-Smtp-Source: ABdhPJyyu2U9HJJJR8Q1IhRXScEZ9pYS+vZ23fGFqKcAYZ2idP9WC5GQplffi9lsDNffQt505GPAxWH8YJVgnP5r/vc=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr27714170ybl.347.1603753689534;
 Mon, 26 Oct 2020 16:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201024080541.51683-1-dev@der-flo.net>
In-Reply-To: <20201024080541.51683-1-dev@der-flo.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Oct 2020 16:07:58 -0700
Message-ID: <CAEf4BzY-bNN7fx2eAvRBq89pDHptEqoftgSSF=0dv_GgeNACvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: Lift hashtab key_size limit
To:     Florian Lehner <dev@der-flo.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 24, 2020 at 7:10 AM Florian Lehner <dev@der-flo.net> wrote:
>
> Currently key_size of hashtab is limited to MAX_BPF_STACK.
> As the key of hashtab can also be a value from a per cpu map it can be
> larger than MAX_BPF_STACK.
>
> The use-case for this patch originates to implement allow/disallow
> lists for files and file paths. The maximum length of file paths is
> defined by PATH_MAX with 4096 chars including nul.
> This limit exceeds MAX_BPF_STACK.
>
> Changelog:
>
> v3:
>  - Rebase
>
> v2:
>  - Add a test for bpf side
>
> Signed-off-by: Florian Lehner <dev@der-flo.net>
> ---

You dropped the ack from John, btw.

>  kernel/bpf/hashtab.c                          | 16 +++----
>  .../selftests/bpf/prog_tests/hash_large_key.c | 28 ++++++++++++
>  .../selftests/bpf/progs/test_hash_large_key.c | 45 +++++++++++++++++++
>  tools/testing/selftests/bpf/test_maps.c       |  2 +-
>  4 files changed, 79 insertions(+), 12 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/hash_large_key.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_hash_large_key.c
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 1815e97d4c9c..10097d6bcc35 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -390,17 +390,11 @@ static int htab_map_alloc_check(union bpf_attr *attr)
>             attr->value_size == 0)
>                 return -EINVAL;
>
> -       if (attr->key_size > MAX_BPF_STACK)
> -               /* eBPF programs initialize keys on stack, so they cannot be
> -                * larger than max stack size
> -                */
> -               return -E2BIG;
> -
> -       if (attr->value_size >= KMALLOC_MAX_SIZE -
> -           MAX_BPF_STACK - sizeof(struct htab_elem))
> -               /* if value_size is bigger, the user space won't be able to
> -                * access the elements via bpf syscall. This check also makes
> -                * sure that the elem_size doesn't overflow and it's
> +       if ((attr->key_size + attr->value_size) >= KMALLOC_MAX_SIZE -

key_size+value_size can overflow, can't it? So probably want to cast
to (size_t) or __u64?

> +           sizeof(struct htab_elem))
> +               /* if key_size + value_size is bigger, the user space won't be
> +                * able to access the elements via bpf syscall. This check
> +                * also makes sure that the elem_size doesn't overflow and it's
>                  * kmalloc-able later in htab_map_update_elem()
>                  */
>                 return -E2BIG;
> diff --git a/tools/testing/selftests/bpf/prog_tests/hash_large_key.c b/tools/testing/selftests/bpf/prog_tests/hash_large_key.c
> new file mode 100644
> index 000000000000..962f56060b76
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/hash_large_key.c
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Florian Lehner
> +
> +#include <test_progs.h>
> +
> +void test_hash_large_key(void)
> +{
> +       const char *file = "./test_hash_large_key.o";
> +       int prog_fd, map_fd[2];
> +       struct bpf_object *obj = NULL;
> +       int err = 0;
> +
> +       err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);

Please utilize the BPF skeleton in the new tests.

> +       if (CHECK_FAIL(err)) {
> +               printf("test_hash_large_key: bpf_prog_load errno %d", errno);
> +               goto close_prog;
> +       }
> +
> +       map_fd[0] = bpf_find_map(__func__, obj, "hash_map");
> +       if (CHECK_FAIL(map_fd[0] < 0))
> +               goto close_prog;
> +       map_fd[1] = bpf_find_map(__func__, obj, "key_map");
> +       if (CHECK_FAIL(map_fd[1] < 0))
> +               goto close_prog;

You are not really checking much here.

Why don't you check that the value was set to 42 here? Consider also
using big global variables as your key and value. You can specify them
from user-space with BPF skeleton easily to any custom value (not just
zeroes).


> +
> +close_prog:
> +       bpf_object__close(obj);
> +}

[...]
