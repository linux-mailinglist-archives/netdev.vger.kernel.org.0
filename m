Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96AB28D760
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 02:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgJNAVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 20:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgJNAVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 20:21:54 -0400
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C700D208B3;
        Wed, 14 Oct 2020 00:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602634913;
        bh=bP1yfZHeH57zBg9sGmXWqcmVDf3HXI8UxNucqglGNQg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WXpyHBxZyCrV6q9Rv5dWxwxu0QEUpULHsg3e6c7cludk3S1MW+QLxoTiES0L0niTh
         5xRGesdVdF7mB0LzYELWJbgiPm2JnvXfQqNfz/+sxsiW3S8mv+aLuGeb2OIIbEzml2
         tDONfRuhdkFBE8czcxSmxR6htR1fKCfB8+CTNhV8=
Received: by mail-lf1-f42.google.com with SMTP id 184so1723948lfd.6;
        Tue, 13 Oct 2020 17:21:52 -0700 (PDT)
X-Gm-Message-State: AOAM532qD39MmoTjnPHdydHsJGFFrpyXQ09SzxB4F71hS4TS3ZB2jD7x
        6ML0Qm/wnSJSqGh1R16rSBsIKACo5Tw92GOZwg4=
X-Google-Smtp-Source: ABdhPJz0YkSPqe+QT0XawZxpDHMRYw4ObhNOnTcJ9nTvzDfl4Q/UmNJ0VBKX8OJyTm8nlcjY/4Csw3kdkopUsuTEicA=
X-Received: by 2002:a05:6512:2029:: with SMTP id s9mr503639lfs.273.1602634910979;
 Tue, 13 Oct 2020 17:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com> <20201013195622.GB1305928@krava>
In-Reply-To: <20201013195622.GB1305928@krava>
From:   Song Liu <song@kernel.org>
Date:   Tue, 13 Oct 2020 17:21:39 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4ZnYmfSGAXibVEZVA79opyWxRnw2-m7VfsQngi9NLBBg@mail.gmail.com>
Message-ID: <CAPhsuW4ZnYmfSGAXibVEZVA79opyWxRnw2-m7VfsQngi9NLBBg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 12:57 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 08, 2020 at 06:12:39PM -0700, Alexei Starovoitov wrote:
>
> SNIP
>
> > +
> > +#ifdef UNROLL
> > +#pragma unroll
> > +#endif
> > +     for (int i = 0; i < MAX_CGROUPS_PATH_DEPTH; i++) {
> > +             filepart_length =
> > +                     bpf_probe_read_str(payload, MAX_PATH, BPF_CORE_READ(cgroup_node, name));
> > +             if (!cgroup_node)
> > +                     return payload;
> > +             if (cgroup_node == cgroup_root_node)
> > +                     *root_pos = payload - payload_start;
> > +             if (filepart_length <= MAX_PATH) {
> > +                     barrier_var(filepart_length);
> > +                     payload += filepart_length;
> > +             }
> > +             cgroup_node = BPF_CORE_READ(cgroup_node, parent);
> > +     }
> > +     return payload;
> > +}
> > +
> > +static ino_t get_inode_from_kernfs(struct kernfs_node* node)
> > +{
> > +     struct kernfs_node___52* node52 = (void*)node;
> > +
> > +     if (bpf_core_field_exists(node52->id.ino)) {
> > +             barrier_var(node52);
> > +             return BPF_CORE_READ(node52, id.ino);
> > +     } else {
> > +             barrier_var(node);
> > +             return (u64)BPF_CORE_READ(node, id);
> > +     }
> > +}
> > +
> > +int pids_cgrp_id = 1;
>
>
> hi,
> I'm getting compilation failure with this:
>
>           CLNG-LLC [test_maps] profiler2.o
>         In file included from progs/profiler2.c:6:
>         progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as different kind of symbol
>         int pids_cgrp_id = 1;
>             ^
>         /home/jolsa/linux-qemu/tools/testing/selftests/bpf/tools/include/vmlinux.h:14531:2: note: previous definition is here
>                 pids_cgrp_id = 11,
>                 ^
>         1 error generated.
>         /opt/clang/bin/llc: error: /opt/clang/bin/llc: <stdin>:1:1: error: expected top-level entity
>         BPF obj compilation failed
>         ^
>         make: *** [Makefile:396: /home/jolsa/linux-qemu/tools/testing/selftests/bpf/profiler2.o] Error 1

I got the same error with some .config. We should fix it with something below.

I will send official patch soon.

Thanks,
Song

diff --git i/tools/testing/selftests/bpf/progs/profiler.inc.h
w/tools/testing/selftests/bpf/progs/profiler.inc.h
index 00578311a4233..54f594efccbca 100644
--- i/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ w/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -243,7 +243,7 @@ static ino_t get_inode_from_kernfs(struct kernfs_node* node)
        }
 }

-int pids_cgrp_id = 1;
+int pids_cgrp_id_ = 1;

 static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_data,
                                         struct task_struct* task,
@@ -262,7 +262,7 @@ static INLINE void* populate_cgroup_info(struct
cgroup_data_t* cgroup_data,
                                BPF_CORE_READ(task, cgroups, subsys[i]);
                        if (subsys != NULL) {
                                int subsys_id = BPF_CORE_READ(subsys, ss, id);
-                               if (subsys_id == pids_cgrp_id) {
+                               if (subsys_id == pids_cgrp_id_) {
                                        proc_kernfs =
BPF_CORE_READ(subsys, cgroup, kn);
                                        root_kernfs =
BPF_CORE_READ(subsys, ss, root, kf_root, kn);
                                        break;
