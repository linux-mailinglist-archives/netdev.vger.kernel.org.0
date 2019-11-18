Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AD1FFEA9
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 07:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfKRGpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 01:45:40 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44710 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfKRGpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 01:45:39 -0500
Received: by mail-qk1-f196.google.com with SMTP id m16so13464615qki.11;
        Sun, 17 Nov 2019 22:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nP07Eu5kD288F54GgydPJCTnNHwVdZT3WVHeTF/YLXE=;
        b=YTXG3Ks+19M82fi9aXfzY9HkzZiJizuzR9yzm00CFb6hVZ2zKp7RXmaW3x95xLxyC0
         4Va3EEcy65TBz11jFxESyQu6ua1LI4xAN8w6gkSHxBuSAqgwS0izI4noS3+3tsL7ajqV
         eqhqFkquTbsqCPQ5Yv6M5PnHrv9ojbtqbGeW/qFw5wMVuF6VqaN9QH3TrjfyWEe7Fbwt
         1GDBg5E91SBaToGJKCB5D29re7aRU4CVsPlu4esV5gJ2edzIocd2eEHbydm+8TMZDvlq
         ee55x5yDCcNaFlIkXgUZzZMLFRGaZTuU0rPq3ioQqdzGiDjIFlkv3NX8MAkZ0B+zQQDh
         Z50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nP07Eu5kD288F54GgydPJCTnNHwVdZT3WVHeTF/YLXE=;
        b=ECBYNqwHRxd76cV8PLLtce/qUMnJG/6ALZUiX4Ppl2+sJ3FVOIe1ElJUPKy8McDJfv
         h74ZjnWx0REar5n23GrTvdX+qc2M16QXDq6xPHXJ1I0yUnbiaz+275gI2pfSxutGkhXY
         vbD5EEWis6z2iwXriF3Vg9FKNfztcbPA96OHApwj6Chpv5m5I6AuJ2Wi1Mn6ncqxzypS
         ZOZRWrN2AnhlukXw5ChP0IJAhOpgROPv3FBef3lP46N+RysVOUfF5vNJP0GP2XW4wLSa
         Y3BMkFGoUvF7mSMHzQEjqA/SsCenSR+FmiygHdbRCFk7XH6o3jXZyy85QoeNKioZakrI
         7OHA==
X-Gm-Message-State: APjAAAXmr1tLARoMp39g2H5wezmtmfwSfN8PQpbf55FGKWJWB1LC3e1H
        4bZWzfyewpA/etkZCdW/S9+a5u7I+tlcziLunbA=
X-Google-Smtp-Source: APXvYqzSBgUn7DCQE0X8gNV3+1pnjUtdAwD7XxIap7gB8fHw+XNY4ADfg1amDdSoyCxjL9V5lnOf7ynZGqbt6gMGJ5g=
X-Received: by 2002:a37:b3c4:: with SMTP id c187mr10795110qkf.36.1574059537664;
 Sun, 17 Nov 2019 22:45:37 -0800 (PST)
MIME-Version: 1.0
References: <20191115135901.8114-1-ethercflow@gmail.com>
In-Reply-To: <20191115135901.8114-1-ethercflow@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 17 Nov 2019 22:45:26 -0800
Message-ID: <CAEf4BzZ5sEDDmX4hYJFJ4-rB1ZftZ9=yVv3Y=WNSdLVXA6sipg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] selftests/bpf: test for bpf_get_file_path()
 from raw tracepoint
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 5:59 AM Wenbo Zhang <ethercflow@gmail.com> wrote:
>
> trace fstat events by raw tracepoint sys_enter:newfstat, and handle events
> only produced by test_file_get_path, which call fstat on several different
> types of files to test bpf_get_file_path's feature.
>
> v3->v4: addressed Andrii's feedback
> - use a set of fd instead of fds array
> - use global variables instead of maps (in v3, I mistakenly thought that
> the bpf maps are global variables.)
> - remove uncessary global variable path_info_index
> - remove fd compare as the fstat's order is fixed
>
> v2->v3: addressed Andrii's feedback
> - use global data instead of perf_buffer to simplified code
>
> v1->v2: addressed Daniel's feedback
> - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> helper's names
>
> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> ---

I like this much better, so much simpler BPF program and userspace
parts has less unnecessary moving pieces. I just have minor nits
below.

But I think you should send this patch together with the patch adding
helper as one patch series. Both patches are either going to get
accepted together, or declined together; having them as a patch set is
more meaningful.

>  .../selftests/bpf/prog_tests/get_file_path.c  | 173 ++++++++++++++++++
>  .../selftests/bpf/progs/test_get_file_path.c  |  43 +++++
>  2 files changed, 216 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_path.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_path.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_file_path.c b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
> new file mode 100644
> index 000000000000..446ee4dd20e2
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
> @@ -0,0 +1,173 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include <sys/stat.h>
> +#include <linux/sched.h>
> +#include <sys/syscall.h>
> +
> +#define MAX_PATH_LEN           128
> +#define MAX_FDS                        7
> +#define MAX_EVENT_NUM          16
> +
> +static struct file_path_test_data {
> +       pid_t pid;
> +       __u32 cnt;
> +       __u32 fds[MAX_EVENT_NUM];
> +       char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
> +} src, dst;
> +
> +static inline int set_pathname(int fd)
> +{
> +       char buf[MAX_PATH_LEN];
> +
> +       snprintf(buf, MAX_PATH_LEN, "/proc/%d/fd/%d", src.pid, fd);
> +       src.fds[src.cnt] = fd;
> +       return readlink(buf, src.paths[src.cnt++], MAX_PATH_LEN);
> +}
> +
> +static int trigger_fstat_events(pid_t pid)
> +{
> +       int pipefd[2] = { -1, -1 };
> +       int sockfd = -1, procfd = -1, devfd = -1;
> +       int localfd = -1, indicatorfd = -1;
> +       struct stat fileStat;
> +       int ret = -1;
> +
> +       /* unmountable pseudo-filesystems */
> +       if (CHECK_FAIL(pipe(pipefd) < 0))
> +               return ret;
> +       /* unmountable pseudo-filesystems */
> +       sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +       if (CHECK_FAIL(sockfd < 0))
> +               goto out_close;
> +       /* mountable pseudo-filesystems */
> +       procfd = open("/proc/self/comm", O_RDONLY);
> +       if (CHECK_FAIL(procfd < 0))
> +               goto out_close;
> +       devfd = open("/dev/urandom", O_RDONLY);
> +       if (CHECK_FAIL(devfd < 0))
> +               goto out_close;
> +       localfd = open("/tmp/fd2path_loadgen.txt", O_CREAT|O_RDONLY);
> +       if (CHECK_FAIL(localfd < 0))
> +               goto out_close;
> +       /* bpf_get_file_path will return path with (deleted) */
> +       remove("/tmp/fd2path_loadgen.txt");
> +       indicatorfd = open("/tmp/", O_PATH);
> +       if (CHECK_FAIL(indicatorfd < 0))
> +               goto out_close;
> +
> +       src.pid = pid;
> +
> +       ret = set_pathname(pipefd[0]);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(pipefd[1]);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(sockfd);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(procfd);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(devfd);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(localfd);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(indicatorfd);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +
> +       fstat(pipefd[0], &fileStat);
> +       fstat(pipefd[1], &fileStat);
> +       fstat(sockfd, &fileStat);
> +       fstat(procfd, &fileStat);
> +       fstat(devfd, &fileStat);
> +       fstat(localfd, &fileStat);
> +       fstat(indicatorfd, &fileStat);
> +
> +out_close:
> +       close(indicatorfd);
> +       close(localfd);
> +       close(devfd);
> +       close(procfd);
> +       close(sockfd);
> +       close(pipefd[1]);
> +       close(pipefd[0]);
> +
> +       return ret;
> +}
> +
> +void test_get_file_path(void)
> +{
> +       const char *prog_name = "tracepoint/syscalls/sys_enter_newfstat";
> +       const char *obj_file = "./test_get_file_path.o";
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts, );
> +       int err, results_map_fd, duration = 0;
> +       struct bpf_program *tp_prog = NULL;
> +       struct bpf_link *tp_link = NULL;
> +       struct bpf_object *obj = NULL;
> +       const int zero = 0;
> +
> +       obj = bpf_object__open_file(obj_file, &opts);

you can just pass NULL for opts, as you are not really using any

> +       if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
> +               return;
> +
> +       tp_prog = bpf_object__find_program_by_title(obj, prog_name);
> +       if (CHECK(!tp_prog, "find_tp",
> +                 "prog '%s' not found\n", prog_name))
> +               goto cleanup;
> +
> +       err = bpf_object__load(obj);
> +       if (CHECK(err, "obj_load", "err %d\n", err))
> +               goto cleanup;
> +
> +       results_map_fd = bpf_find_map(__func__, obj, "test_get.bss");
> +       if (CHECK(results_map_fd < 0, "find_bss_map",
> +                 "err %d\n", results_map_fd))
> +               goto cleanup;
> +
> +       tp_link = bpf_program__attach_tracepoint(tp_prog, "syscalls",
> +                                                "sys_enter_newfstat");

your patch subject says "raw tracepoint", but you are really using a
normal tracepoint here

> +       if (CHECK(IS_ERR(tp_link), "attach_tp",
> +                 "err %ld\n", PTR_ERR(tp_link))) {
> +               tp_link = NULL;
> +               goto cleanup;
> +       }
> +
> +       dst.pid = syscall(SYS_gettid);

see comment below, you can just use getpid(), as this test is single-threaded

> +       err = bpf_map_update_elem(results_map_fd, &zero, &dst, 0);
> +       if (CHECK(err, "update_elem",
> +                 "failed to set pid filter: %d\n", err))
> +               goto cleanup;
> +
> +       err = trigger_fstat_events(dst.pid);
> +       if (CHECK_FAIL(err < 0))
> +               goto cleanup;
> +
> +       err = bpf_map_lookup_elem(results_map_fd, &zero, &dst);
> +       if (CHECK(err, "get_results",
> +                 "failed to get results: %d\n", err))
> +               goto cleanup;
> +
> +       for (int i = 0; i < MAX_FDS; i++) {
> +               if (i < 3) {
> +                       CHECK((dst.paths[i][0] != '\0'), "get_file_path",

nit: unnecessary parens around check

> +                              "failed to filter fs [%d]: %u(%s) vs %u(%s)\n",
> +                              i, src.fds[i], src.paths[i], dst.fds[i],
> +                              dst.paths[i]);
> +               } else {
> +                       err = strncmp(src.paths[i], dst.paths[i], MAX_PATH_LEN);
> +                       CHECK(err != 0, "get_file_path",
> +                              "failed to get path[%d]: %u(%s) vs %u(%s)\n",
> +                              i, src.fds[i], src.paths[i], dst.fds[i],
> +                              dst.paths[i]);
> +               }
> +       }
> +
> +cleanup:
> +       bpf_link__destroy(tp_link);
> +       bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_get_file_path.c b/tools/testing/selftests/bpf/progs/test_get_file_path.c
> new file mode 100644
> index 000000000000..c006fa05e32b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_get_file_path.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <linux/ptrace.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include "bpf_helpers.h"
> +#include "bpf_tracing.h"
> +
> +#define MAX_PATH_LEN           128
> +#define MAX_EVENT_NUM          16
> +
> +static struct file_path_test_data {
> +       pid_t pid;
> +       __u32 cnt;
> +       __u32 fds[MAX_EVENT_NUM];
> +       char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
> +} data;
> +
> +struct sys_enter_newfstat_args {
> +       unsigned long long pad1;
> +       unsigned long long pad2;
> +       unsigned int fd;
> +};
> +
> +SEC("tracepoint/syscalls/sys_enter_newfstat")
> +int bpf_prog(struct sys_enter_newfstat_args *args)
> +{
> +       pid_t pid = bpf_get_current_pid_tgid();

you don't have to use thread id, given test_progs is single-threaded,
so can do (bpf_get_current_pid_tgid() >> 32) here and use getpid() in
userspace part.

> +
> +       if (pid != data.pid)
> +               return 0;
> +       if (data.cnt >= MAX_EVENT_NUM)
> +               return 0;
> +
> +       data.fds[data.cnt] = args->fd;
> +       bpf_get_file_path(data.paths[data.cnt], MAX_PATH_LEN, args->fd);
> +       data.cnt++;
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.17.1
>
