Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAED17B0E0
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 22:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCEVuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 16:50:22 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37314 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCEVuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 16:50:22 -0500
Received: by mail-qk1-f196.google.com with SMTP id y126so395755qke.4;
        Thu, 05 Mar 2020 13:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gVF04oFX2dW/NQ2Xfyde00nV8RIHAfk7rBY6uJtkYPw=;
        b=aEnXEN5N+9T4pnsYkIK+aNOl4xqI846SvI7Y5+soDSeN51i+V29jh4LwHvRdgCQEUq
         2TL7RInpZEHmIYE292JWFDFZXvCOvxCQxAF+quPepU/9CS8kT4Efe+b5UsZrz5txz55C
         svORe55I2iLeJAK0N3jCKQHAvsG3Yd8Vkx7qa4PbjukpYgNmzHM8BUYT+YOBd5gsWF3r
         KS3ie6vn8v7hBmIGspF2sTXyifO6FH6QNVf++jiHsg4I0cCQzi7J6Pw4zL57otntCYrG
         TR64+UrVPRnbKz4AAQ2JGiOUSRf3I0Sx+S7P87DgpnYKM3NrUi6C16ODumATS8pl9Evf
         r0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gVF04oFX2dW/NQ2Xfyde00nV8RIHAfk7rBY6uJtkYPw=;
        b=plKXPKMiAit04U5QPWMRTD8E46N4UEO2blb5h3AscRbtNO2LJNyZq9I2akC12DhMr7
         /iQHY42LLzDsf6warxJeycB2O4rhpTLz1YQsL3TO8PTqb1HZGXqqhUWA1lRes1t54qyA
         9FkZ1VdmW7GXwiHR/IfoCUvDnnxn94q9AtG2cIQoHIt3zdcAkKT6FEBGm347By5rf+yl
         Ek7o+Lp2UEe513B4upku7LzNLJ0U18B65abOR3aFobMGy9DBIR6K6JKJEbsptuzsmtud
         oezIQfGBgbr0y7AgT4YwDVa62TGMaYJL5PubbMdAD0uSASb2pmtYI5dWaypz2YQzcdtm
         i6HQ==
X-Gm-Message-State: ANhLgQ0PG87gy8e1fkJW2cyV3WvTokV2kabJADuuomgMrdfvgodbGvN3
        yigXJBqUYUUk7KBW/9hgtHCjlsZFQ1z6ks3PCYA=
X-Google-Smtp-Source: ADFU+vsckWlyB13SdB0JOAuW6Ayhd6XdUTRJjXgZ6a54qOvRwNXjBwrbgahLFEf6ogP68iDJwaOLG4PMTwzdMHFeBdA=
X-Received: by 2002:a37:9104:: with SMTP id t4mr79597qkd.449.1583445019185;
 Thu, 05 Mar 2020 13:50:19 -0800 (PST)
MIME-Version: 1.0
References: <20200305192146.589093-1-eric@sage.org>
In-Reply-To: <20200305192146.589093-1-eric@sage.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Mar 2020 13:50:07 -0800
Message-ID: <CAEf4Bzb6FP4germQketqZ7NyOMMYEQ_qjVeqrngKMnQCNeokOA@mail.gmail.com>
Subject: Re: [PATCH] [bpf] Make bpf program autoloading optional
To:     Eric Sage <eric@sage.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 5, 2020 at 11:22 AM Eric Sage <eric@sage.org> wrote:
>
> Adds bpf_program__set_autoload which can be used to disable loading
> a bpf_prog when loading the bpf_object that contains it after the
> bpf_object has been opened. This behavior affect calling load directly
> and loading through BPF skel. A single flag is added to bpf_prog
> to make this work.
>
> Signed-off-by: Eric Sage <eric@sage.org>
> ---

This is a very useful feature for complicated scenarios, thanks for
working on this! You've based it off bpf tree, but all the new
features should go through bpf-next, please rebase.

>  tools/lib/bpf/libbpf.c                        |   9 +
>  tools/lib/bpf/libbpf.h                        |   2 +
>  tools/lib/bpf/libbpf.map                      |   5 +
>  tools/testing/selftests/bpf/Makefile          |   2 +-
>  .../selftests/bpf/progs/test_autoload_kern.c  |  24 +++
>  tools/testing/selftests/bpf/test_autoload.c   | 158 ++++++++++++++++++
>  6 files changed, 199 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_autoload_kern.c
>  create mode 100644 tools/testing/selftests/bpf/test_autoload.c
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 514b1a524abb..fe156ca10d16 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -222,6 +222,7 @@ struct bpf_program {
>         bpf_program_prep_t preprocessor;
>
>         struct bpf_object *obj;
> +       bool autoload;

this will create unnecessarily 7 bytes of padding. Let's move this
field after `enum bpf_prog_type type;` few lines above, it will take
part of 4 byte padding there.

>         void *priv;
>         bpf_program_clear_priv_t clear_priv;
>
> @@ -499,6 +500,7 @@ bpf_program__init(void *data, size_t size, char *section_name, int idx,
>         prog->instances.fds = NULL;
>         prog->instances.nr = -1;
>         prog->type = BPF_PROG_TYPE_UNSPEC;
> +       prog->autoload = true;
>
>         return 0;
>  errout:
> @@ -4933,6 +4935,11 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>         return ret;
>  }
>
> +void bpf_program__set_autoload(struct bpf_program *prog, bool autoload)
> +{
> +       prog->autoload = autoload;
> +}
> +
>  static int libbpf_find_attach_btf_id(struct bpf_program *prog);
>
>  int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
> @@ -5030,6 +5037,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
>         int err;
>
>         for (i = 0; i < obj->nr_programs; i++) {
> +               if (!obj->programs[i].autoload)
> +                       continue;
>                 if (bpf_program__is_function_storage(&obj->programs[i], obj))
>                         continue;
>                 obj->programs[i].log_level |= log_level;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 3fe12c9d1f92..e5f30f70bac1 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -204,6 +204,8 @@ LIBBPF_API const char *bpf_program__title(const struct bpf_program *prog,
>  /* returns program size in bytes */
>  LIBBPF_API size_t bpf_program__size(const struct bpf_program *prog);
>
> +LIBBPF_API void bpf_program__set_autoload(struct bpf_program *prog, bool autoload);
> +
>  LIBBPF_API int bpf_program__load(struct bpf_program *prog, char *license,
>                                  __u32 kern_version);
>  LIBBPF_API int bpf_program__fd(const struct bpf_program *prog);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index b035122142bb..1d7572806981 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -235,3 +235,8 @@ LIBBPF_0.0.7 {
>                 btf__align_of;
>                 libbpf_find_kernel_btf;
>  } LIBBPF_0.0.6;
> +
> +LIBBPF_0.0.8 {
> +  global:
> +    bpf_program__set_autoload;
> +} LIBBPF_0.0.7;
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 257a1aaaa37d..1ee62911992d 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -29,7 +29,7 @@ LDLIBS += -lcap -lelf -lz -lrt -lpthread
>  # Order correspond to 'make run_tests' order
>  TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
>         test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
> -       test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
> +       test_sock test_btf test_sockmap test_autoload get_cgroup_id_user test_socket_cookie \

We normally add new tests into test_progs framework, can you please
add it there? See some notes regarding testing below as well.

>         test_cgroup_storage \
>         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
>         test_progs-no_alu32
> diff --git a/tools/testing/selftests/bpf/progs/test_autoload_kern.c b/tools/testing/selftests/bpf/progs/test_autoload_kern.c
> new file mode 100644
> index 000000000000..e4cfe9b90606
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_autoload_kern.c

nit: we usually name BPF programs as progs/test_<whatever> and their
user-space counterparts as prog_tests/<whatever>.c. _kern suffix is
rarely used now.

> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +SEC("xdp_prog_0")
> +int prog_0(struct xdp_md *xdp)
> +{
> +       return XDP_PASS;
> +}
> +
> +SEC("xdp_prog_1")
> +int prog_1(struct xdp_md *xdp)
> +{
> +       return XDP_PASS;
> +}
> +
> +SEC("xdp_prog_2")
> +int prog_2(struct xdp_md *xdp)
> +{
> +       return XDP_PASS;
> +}
> +

I've found that it's easiest to test BPF programs of
SEC("raw_tp/sys_enter") type, you can trigger them, e.g., with
usleep(1). I'd suggest switching them to that type, and each setting
its own global variable from 0 to 1. Then on user-space side you can
just validate that one of them wasn't triggered, while other(s) were.
No need for more code to check that program was loaded, etc.

> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/test_autoload.c b/tools/testing/selftests/bpf/test_autoload.c
> new file mode 100644
> index 000000000000..3294c167bbfd
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_autoload.c
> @@ -0,0 +1,158 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <sys/resource.h>
> +
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +
> +#include "test_autoload_kern.skel.h"
> +
> +#define AUTOLOAD_KERN "test_autoload_kern.o"
> +#define TEST_NO_AUTOLOAD_PROG "prog_2"
> +
> +int print_libbpf_log(enum libbpf_print_level lvl, const char *fmt, va_list args)
> +{
> +       return 0;
> +}
> +
> +int test_libbpf(void)
> +{
> +       struct bpf_object *obj;
> +       struct bpf_program *unloaded_prog, *prog;
> +       struct bpf_prog_info *info;
> +       __u32 info_len;
> +       int prog_fd;
> +
> +       obj = bpf_object__open(AUTOLOAD_KERN);
> +       if (obj == NULL) {
> +               fprintf(stderr, "failed to load %s\n", AUTOLOAD_KERN);
> +               return -1;
> +       }
> +
> +       unloaded_prog =
> +               bpf_object__find_program_by_name(obj, TEST_NO_AUTOLOAD_PROG);
> +       if (unloaded_prog == NULL) {
> +               fprintf(stderr, "failed to find test xdp prog %s\n",
> +                       TEST_NO_AUTOLOAD_PROG);
> +               goto fail;
> +       }
> +
> +       bpf_program__set_autoload(unloaded_prog, false);
> +
> +       bpf_object__load(obj);
> +
> +       bpf_object__for_each_program(prog, obj) {
> +               prog_fd = bpf_program__fd(prog);
> +
> +               if (unloaded_prog == prog) {
> +                       if (-prog_fd != EINVAL) {
> +                               fprintf(stderr,
> +                                       "non-autoloaded prog should not be loaded\n");
> +                               goto fail;
> +                       }
> +                       continue;
> +               }
> +
> +               info_len = sizeof(struct bpf_prog_info);
> +               info = calloc(1, info_len);
> +
> +               if (bpf_obj_get_info_by_fd(prog_fd, info, &info_len) < 0) {
> +                       fprintf(stderr, "could not get bpf prog info\n");
> +                       goto fail;
> +               }
> +
> +               if (info->id == 0) {
> +                       fprintf(stderr, "expected valid prog id\n");
> +                       goto fail;
> +               }
> +       }
> +
> +       bpf_object__close(obj);
> +       return 0;
> +fail:
> +       bpf_object__close(obj);
> +       return -1;
> +}
> +
> +int test_skel(void)
> +{
> +       struct test_autoload_kern *kern;
> +       struct bpf_object *obj;
> +       struct bpf_program *unloaded_prog, *prog;
> +       struct bpf_prog_info *info;
> +       __u32 info_len;
> +       int prog_fd;
> +
> +       kern = test_autoload_kern__open();

I think there's no need to test skeleton-based and
bpf_object__open()-based variants. Skeleton is using
bpf_object__open() either way, so I'd just use shorter skeleton
variant. See above about program type and global variables, that makes
test programs more concise.

> +       if (kern == NULL) {
> +               fprintf(stderr, "failed to autoload skel\n");
> +               return -1;
> +       }
> +
> +       obj = kern->obj;
> +
> +       unloaded_prog =
> +               bpf_object__find_program_by_name(obj, TEST_NO_AUTOLOAD_PROG);
> +       if (unloaded_prog == NULL) {
> +               fprintf(stderr, "failed to find test xdp prog %s\n",
> +                       TEST_NO_AUTOLOAD_PROG);
> +               goto fail;
> +       }
> +
> +       bpf_program__set_autoload(unloaded_prog, false);
> +
> +       bpf_object__load(obj);

CHECK that load succeeded?

> +
> +       bpf_object__for_each_program(prog, obj) {
> +               prog_fd = bpf_program__fd(prog);
> +
> +               if (unloaded_prog == prog) {
> +                       if (-prog_fd != EINVAL) {
> +                               fprintf(stderr,
> +                                       "non-autoloaded prog should not be loaded\n");
> +                               goto fail;
> +                       }
> +                       continue;
> +               }
> +
> +               info_len = sizeof(struct bpf_prog_info);
> +               info = calloc(1, info_len);
> +
> +               if (bpf_obj_get_info_by_fd(prog_fd, info, &info_len) < 0) {
> +                       fprintf(stderr, "could not get bpf prog info\n");
> +                       goto fail;
> +               }
> +
> +               if (info->id == 0) {
> +                       fprintf(stderr, "expected valid prog id\n");
> +                       goto fail;
> +               }
> +       }
> +
> +       test_autoload_kern__destroy(kern);
> +       return 0;
> +fail:
> +       test_autoload_kern__destroy(kern);
> +       return -1;
> +}
> +
> +int main(void)
> +{
> +       struct rlimit r = { RLIM_INFINITY, RLIM_INFINITY };
> +
> +       if (setrlimit(RLIMIT_MEMLOCK, &r)) {
> +               perror("setrlimit(RLIMIT_MEMLOCK)");
> +               return EXIT_FAILURE;
> +       }
> +
> +       libbpf_set_print(print_libbpf_log);
> +

all this is taken care of in test_progs framework

> +       if (test_libbpf() < 0)
> +               return EXIT_FAILURE;
> +
> +       if (test_skel() < 0)
> +               return EXIT_FAILURE;
> +}
> --
> 2.24.1
>
