Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077AE25B34
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 02:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfEVAhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 20:37:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44545 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfEVAhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 20:37:04 -0400
Received: by mail-qt1-f193.google.com with SMTP id f24so339725qtk.11;
        Tue, 21 May 2019 17:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3crS8n0XY73o/qqaFDUwn2vOv8aJL38Pl+kiNJtDDK4=;
        b=LSpEAG+McIY0YJmr4dU4RFPJmV39NGK4NOvhLovIZlOlqnPkOaSwvzPaKi11ZdYtLz
         LNePryQjygtmERRkstR84FC7EkFQ9aPfV4p1Y35badZvI78lj/wrJY08RgDnjwFO8X+9
         zRIHSKVKCImAGg/7JImCCUWm6GPjQ/02II6uvac5vkM3LyVgPvc0pkfZ5Y5e5hCL/iMu
         fijJ/RJCa5PAqiEsAp11pS0WggJJ/XKIjG8X+MHPHJJy/Z0gnSYr6NYCPPETR/MjjKpz
         jZaWDInFcN/EnrNw74OP+CW7+cLO6HHSVAYcBiU1/1A18E/ulCwKCkqLimsQgftBCKF5
         3+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3crS8n0XY73o/qqaFDUwn2vOv8aJL38Pl+kiNJtDDK4=;
        b=NI3j8/Egv1SxXsoAOZxiuhRiCOdCi9iTuAQQkjHpdEusa00XQvo6eJSays9PAlEYA7
         Mllns2P2nT+20E9QDPmzBmeZ0Kd9hZ5hS/LmJB454M4K0h+zm5DXNO2tBoQPYsN8SmVm
         K8J9qT2ahA1w/QVuWIj9WRT+cCja3NZ+tGmA6F2FBo2C/eorDwRN6MtboG6epQBpJnm6
         aSvW2UHWpnX9KLwsJOy82ntYYt6V2a4k2mM3evFWXEDaU8WbigByZmPSIx4xNeAW5bF+
         1x0hQSmQOcsT+qCEVv3xHqcF6GcIZ6PdWVnuFQiAbzacu7toY+ZRXGO4oBaQlgO37/YQ
         DnTg==
X-Gm-Message-State: APjAAAXcFZBF/zgCn8TYOvZsOHoVE10GZ72JRpFXmSip5dgG5PE6ENvu
        Df6G9aCzcEulrC3ugtj+M8S+J9wtR6vbt3KzO/k=
X-Google-Smtp-Source: APXvYqwyNITBsxWUrgQr39S5Mi8dpr1G5ApgZmx/0koZCMEM0t4cI3JzEomG6QA62BPLm0AjyfdXsd1R+KYVxFsUiS0=
X-Received: by 2002:a0c:d917:: with SMTP id p23mr54196360qvj.162.1558485422288;
 Tue, 21 May 2019 17:37:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190521230939.2149151-1-ast@kernel.org> <20190521230939.2149151-4-ast@kernel.org>
In-Reply-To: <20190521230939.2149151-4-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 May 2019 17:36:51 -0700
Message-ID: <CAEf4BzZrK1Fw211ef9psBxOoP_vV9tH2Hre1DJSqUsp7iX7bSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add pyperf scale test
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 4:10 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add a snippet of pyperf bpf program used to collect python stack traces
> as a scale test for the verifier.
>
> At 189 loop iterations llvm 9.0 starts ignoring '#pragma unroll'
> and generates partially unrolled loop instead.
> Hence use 50, 100, and 180 loop iterations to stress test.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  .../bpf/prog_tests/bpf_verif_scale.c          |  31 +-
>  tools/testing/selftests/bpf/progs/pyperf.h    | 268 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/pyperf100.c |   4 +
>  tools/testing/selftests/bpf/progs/pyperf180.c |   4 +
>  tools/testing/selftests/bpf/progs/pyperf50.c  |   4 +
>  5 files changed, 298 insertions(+), 13 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf.h
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf100.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf180.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf50.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> index b74e2f6e96d0..6a64c77d5af7 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> @@ -12,7 +12,7 @@ static int libbpf_debug_print(enum libbpf_print_level level,
>         return vfprintf(stderr, "%s", args);
>  }
>
> -static int check_load(const char *file)
> +static int check_load(const char *file, enum bpf_prog_type type)
>  {
>         struct bpf_prog_load_attr attr;
>         struct bpf_object *obj = NULL;
> @@ -20,7 +20,7 @@ static int check_load(const char *file)
>
>         memset(&attr, 0, sizeof(struct bpf_prog_load_attr));
>         attr.file = file;
> -       attr.prog_type = BPF_PROG_TYPE_SCHED_CLS;
> +       attr.prog_type = type;
>         attr.log_level = 4;
>         err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
>         bpf_object__close(obj);
> @@ -31,19 +31,24 @@ static int check_load(const char *file)
>
>  void test_bpf_verif_scale(void)
>  {
> -       const char *file1 = "./test_verif_scale1.o";
> -       const char *file2 = "./test_verif_scale2.o";
> -       const char *file3 = "./test_verif_scale3.o";
> -       int err;
> +       const char *scale[] = {
> +               "./test_verif_scale1.o", "./test_verif_scale2.o", "./test_verif_scale3.o"
> +       };
> +       const char *pyperf[] = {
> +               "./pyperf50.o", "./pyperf100.o", "./pyperf180.o"
> +       };
> +       int err, i;
>
>         if (verifier_stats)
>                 libbpf_set_print(libbpf_debug_print);
>
> -       err = check_load(file1);
> -       err |= check_load(file2);
> -       err |= check_load(file3);
> -       if (!err)
> -               printf("test_verif_scale:OK\n");
> -       else
> -               printf("test_verif_scale:FAIL\n");
> +       for (i = 0; i < 3; i++) {

use ARRAY_SIZE(scale)?

> +               err = check_load(scale[i], BPF_PROG_TYPE_SCHED_CLS);
> +               printf("test_scale:%s:%s\n", scale[i], err ? "FAIL" : "OK");
> +       }
> +
> +       for (i = 0; i < 3; i++) {

same as above

> +               err = check_load(pyperf[i], BPF_PROG_TYPE_RAW_TRACEPOINT);
> +               printf("test_scale:%s:%s\n", pyperf[i], err ? "FAIL" : "OK");
> +       }
>  }
> diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/selftests/bpf/progs/pyperf.h
> new file mode 100644
> index 000000000000..0cc5e4ee90bd
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/pyperf.h
> @@ -0,0 +1,268 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook

Maybe let's include a link to an up-to-date real tool, that was used
to create this scale test in BCC:
https://github.com/iovisor/bcc/blob/master/examples/cpp/pyperf/PyPerfBPFProgram.cc

> +#include <linux/sched.h>
> +#include <linux/ptrace.h>
> +#include <stdint.h>
> +#include <stddef.h>
> +#include <stdbool.h>
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +#define FUNCTION_NAME_LEN 64
> +#define FILE_NAME_LEN 128
> +#define TASK_COMM_LEN 16
> +
> +typedef struct {
> +       int PyThreadState_frame;
> +       int PyThreadState_thread;
> +       int PyFrameObject_back;
> +       int PyFrameObject_code;
> +       int PyFrameObject_lineno;
> +       int PyCodeObject_filename;
> +       int PyCodeObject_name;
> +       int String_data;
> +       int String_size;
> +} OffsetConfig;
> +
> +typedef struct {
> +       uintptr_t current_state_addr;
> +       uintptr_t tls_key_addr;
> +       OffsetConfig offsets;
> +       bool use_tls;
> +} PidData;
> +
> +typedef struct {
> +       uint32_t success;
> +} Stats;
> +
> +typedef struct {
> +       char name[FUNCTION_NAME_LEN];
> +       char file[FILE_NAME_LEN];
> +} Symbol;
> +
> +typedef struct {
> +       uint32_t pid;
> +       uint32_t tid;
> +       char comm[TASK_COMM_LEN];
> +       int32_t kernel_stack_id;
> +       int32_t user_stack_id;
> +       bool thread_current;
> +       bool pthread_match;
> +       bool stack_complete;
> +       int16_t stack_len;
> +       int32_t stack[STACK_MAX_LEN];
> +
> +       int has_meta;
> +       int metadata;
> +       char dummy_safeguard;
> +} Event;
> +
> +
> +struct bpf_elf_map {
> +       __u32 type;
> +       __u32 size_key;
> +       __u32 size_value;
> +       __u32 max_elem;
> +       __u32 flags;
> +};
> +
> +typedef int pid_t;
> +
> +typedef struct {
> +       void* f_back; // PyFrameObject.f_back, previous frame
> +       void* f_code; // PyFrameObject.f_code, pointer to PyCodeObject
> +       void* co_filename; // PyCodeObject.co_filename
> +       void* co_name; // PyCodeObject.co_name
> +} FrameData;
> +
> +static inline __attribute__((__always_inline__)) void*
> +get_thread_state(void* tls_base, PidData* pidData)
> +{
> +       void* thread_state;
> +       int key;
> +
> +       bpf_probe_read(&key, sizeof(key), (void*)(long)pidData->tls_key_addr);
> +       bpf_probe_read(&thread_state, sizeof(thread_state),
> +                      tls_base + 0x310 + key * 0x10 + 0x08);
> +       return thread_state;
> +}
> +
> +static inline __attribute__((__always_inline__)) bool
> +get_frame_data(void* frame_ptr, PidData* pidData, FrameData* frame, Symbol* symbol)
> +{
> +       // read data from PyFrameObject
> +       bpf_probe_read(&frame->f_back,
> +                      sizeof(frame->f_back),
> +                      frame_ptr + pidData->offsets.PyFrameObject_back);
> +       bpf_probe_read(&frame->f_code,
> +                      sizeof(frame->f_code),
> +                      frame_ptr + pidData->offsets.PyFrameObject_code);
> +
> +       // read data from PyCodeObject
> +       if (!frame->f_code)
> +               return false;
> +       bpf_probe_read(&frame->co_filename,
> +                      sizeof(frame->co_filename),
> +                      frame->f_code + pidData->offsets.PyCodeObject_filename);
> +       bpf_probe_read(&frame->co_name,
> +                      sizeof(frame->co_name),
> +                      frame->f_code + pidData->offsets.PyCodeObject_name);
> +       // read actual names into symbol
> +       if (frame->co_filename)
> +               bpf_probe_read_str(&symbol->file,
> +                                  sizeof(symbol->file),
> +                                  frame->co_filename + pidData->offsets.String_data);
> +       if (frame->co_name)
> +               bpf_probe_read_str(&symbol->name,
> +                                  sizeof(symbol->name),
> +                                  frame->co_name + pidData->offsets.String_data);
> +       return true;
> +}
> +
> +struct bpf_elf_map SEC("maps") pidmap = {
> +       .type = BPF_MAP_TYPE_HASH,
> +       .size_key = sizeof(int),
> +       .size_value = sizeof(PidData),
> +       .max_elem = 1,
> +};
> +
> +struct bpf_elf_map SEC("maps") eventmap = {
> +       .type = BPF_MAP_TYPE_HASH,
> +       .size_key = sizeof(int),
> +       .size_value = sizeof(Event),
> +       .max_elem = 1,
> +};
> +
> +struct bpf_elf_map SEC("maps") symbolmap = {
> +       .type = BPF_MAP_TYPE_HASH,
> +       .size_key = sizeof(Symbol),
> +       .size_value = sizeof(int),
> +       .max_elem = 1,
> +};
> +
> +struct bpf_elf_map SEC("maps") statsmap = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .size_key = sizeof(Stats),
> +       .size_value = sizeof(int),
> +       .max_elem = 1,
> +};
> +
> +struct bpf_elf_map SEC("maps") perfmap = {
> +       .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> +       .size_key = sizeof(int),
> +       .size_value = sizeof(int),
> +       .max_elem = 32,
> +};
> +
> +struct bpf_elf_map SEC("maps") stackmap = {
> +       .type = BPF_MAP_TYPE_STACK_TRACE,
> +       .size_key = sizeof(int),
> +       .size_value = sizeof(long long) * 127,
> +       .max_elem = 1000,
> +};
> +
> +static inline __attribute__((__always_inline__)) int __on_event(struct pt_regs *ctx)
> +{
> +       uint64_t pid_tgid = bpf_get_current_pid_tgid();
> +       pid_t pid = (pid_t)(pid_tgid >> 32);
> +       PidData* pidData = bpf_map_lookup_elem(&pidmap, &pid);
> +       if (!pidData)
> +               return 0;
> +
> +       int zero = 0;
> +       Event* event = bpf_map_lookup_elem(&eventmap, &zero);
> +       if (!event)
> +               return 0;
> +
> +       event->pid = pid;
> +
> +       event->tid = (pid_t)pid_tgid;
> +       bpf_get_current_comm(&event->comm, sizeof(event->comm));
> +
> +       event->user_stack_id = bpf_get_stackid(ctx, &stackmap, BPF_F_USER_STACK);
> +       event->kernel_stack_id = bpf_get_stackid(ctx, &stackmap, 0);
> +
> +       void* thread_state_current = (void*)0;
> +       bpf_probe_read(&thread_state_current,
> +                      sizeof(thread_state_current),
> +                      (void*)(long)pidData->current_state_addr);
> +
> +       struct task_struct* task = (struct task_struct*)bpf_get_current_task();
> +       void* tls_base = (void*)task;
> +
> +       void* thread_state = pidData->use_tls ? get_thread_state(tls_base, pidData)
> +               : thread_state_current;
> +       event->thread_current = thread_state == thread_state_current;
> +
> +       if (pidData->use_tls) {
> +               uint64_t pthread_created;
> +               uint64_t pthread_self;
> +               bpf_probe_read(&pthread_self, sizeof(pthread_self), tls_base + 0x10);
> +
> +               bpf_probe_read(&pthread_created,
> +                              sizeof(pthread_created),
> +                              thread_state + pidData->offsets.PyThreadState_thread);
> +               event->pthread_match = pthread_created == pthread_self;
> +       } else {
> +               event->pthread_match = 1;
> +       }
> +
> +       if (event->pthread_match || !pidData->use_tls) {
> +               void* frame_ptr;
> +               FrameData frame;
> +               Symbol sym = {};
> +               int cur_cpu = bpf_get_smp_processor_id();
> +
> +               bpf_probe_read(&frame_ptr,
> +                              sizeof(frame_ptr),
> +                              thread_state + pidData->offsets.PyThreadState_frame);
> +
> +               int32_t* symbol_counter = bpf_map_lookup_elem(&symbolmap, &sym);
> +               if (symbol_counter == NULL)
> +                       return 0;
> +#pragma unroll
> +               /* Unwind python stack */
> +               for (int i = 0; i < STACK_MAX_LEN; ++i) {
> +                       if (frame_ptr && get_frame_data(frame_ptr, pidData, &frame, &sym)) {
> +                               int32_t new_symbol_id = *symbol_counter * 64 + cur_cpu;
> +                               int32_t *symbol_id = bpf_map_lookup_elem(&symbolmap, &sym);
> +                               if (!symbol_id) {
> +                                       bpf_map_update_elem(&symbolmap, &sym, &zero, 0);
> +                                       symbol_id = bpf_map_lookup_elem(&symbolmap, &sym);
> +                                       if (!symbol_id)
> +                                               return 0;
> +                               }
> +                               if (*symbol_id == new_symbol_id)
> +                                       (*symbol_counter)++;
> +                               event->stack[i] = *symbol_id;
> +                               event->stack_len = i + 1;
> +                               frame_ptr = frame.f_back;
> +                       }
> +               }
> +               event->stack_complete = frame_ptr == NULL;
> +       } else {
> +               event->stack_complete = 1;
> +       }
> +
> +       Stats* stats = bpf_map_lookup_elem(&statsmap, &zero);
> +       if (stats)
> +               stats->success++;
> +
> +       event->has_meta = 0;
> +       bpf_perf_event_output(ctx, &perfmap, 0, event, offsetof(Event, metadata));
> +       return 0;
> +}
> +
> +SEC("raw_tracepoint/kfree_skb")
> +int on_event(struct pt_regs* ctx)
> +{
> +       int i, ret = 0;
> +       ret |= __on_event(ctx);
> +       ret |= __on_event(ctx);
> +       ret |= __on_event(ctx);
> +       ret |= __on_event(ctx);
> +       ret |= __on_event(ctx);
> +       return ret;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/pyperf100.c b/tools/testing/selftests/bpf/progs/pyperf100.c
> new file mode 100644
> index 000000000000..29786325db54
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/pyperf100.c
> @@ -0,0 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#define STACK_MAX_LEN 100
> +#include "pyperf.h"
> diff --git a/tools/testing/selftests/bpf/progs/pyperf180.c b/tools/testing/selftests/bpf/progs/pyperf180.c
> new file mode 100644
> index 000000000000..c39f559d3100
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/pyperf180.c
> @@ -0,0 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#define STACK_MAX_LEN 180
> +#include "pyperf.h"
> diff --git a/tools/testing/selftests/bpf/progs/pyperf50.c b/tools/testing/selftests/bpf/progs/pyperf50.c
> new file mode 100644
> index 000000000000..ef7ce340a292
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/pyperf50.c
> @@ -0,0 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#define STACK_MAX_LEN 50
> +#include "pyperf.h"
> --
> 2.20.0
>
