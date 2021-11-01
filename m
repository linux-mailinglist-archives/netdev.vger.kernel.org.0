Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7746B442454
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhKAXu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhKAXu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 19:50:28 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2F1C061714;
        Mon,  1 Nov 2021 16:47:54 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id s186so24478328yba.12;
        Mon, 01 Nov 2021 16:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FBiWAJTIxuy3ItLyF6ugs0XoTouSN2poKfACp6muzeU=;
        b=HCef1svqJC9lBUd5duB92ijfUT5eRbFNY6HLDjzlGkQUpwd60ln2Wij+gYdq8HNT9T
         sb7V/QqQxkFbgg982LjzFs8ml9FFZk/VwylwQitcHEk08wHHwWErIPES2L+IDqUT3gBs
         9LplQea12M5qpyTMK0urKPM5EltKdsjjKMojrOiTpguMMSwlVUUdB5ciBBci5taDIEoi
         gWw1gjoaTVb+SEzW3GXoQJOCZg6hgC+dJOcj9hMlcXLT01W/1I3LjcXSj948Zw0diw4N
         dAB65Fn6kTT9lrlp64cjArjG4I3qD4Mr5tlryjf3IYHj8ngu42fTN0rGTfyeOBDJKIi7
         blOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FBiWAJTIxuy3ItLyF6ugs0XoTouSN2poKfACp6muzeU=;
        b=F1RJEf7hBNXOUthUkb5DSQWmzAjn1kxDrF3XG2XGbWQmDXWrwj/DKOkfSJFIDzTDO3
         IItzHZ5QWmwYTXDUVbo2+yZhcpXN3WYf638tbMR9VsT7f8RDUWfKJqGyLqDnHYXPwdfX
         lcBxFGHTzj2ai0GABB1nsKVENyI/ZWZ2l+Y+zJAte4hYwgRNV/OhpuVLvzoI7DvtgI/z
         wVTykXhyR70inLvqgWRrTrABgnRySMsTS5xCJm2q2QUVd+7RU1adXW7ME5RSQaIYzcWM
         7c4umi0P/U5AMOkhtQPUkxv2im1nOokjy+iVp58r0ijQSEC7V4KP2UY9GbSowVLD5nkN
         1TMA==
X-Gm-Message-State: AOAM531jpYI3lTENfWieYy5POWh+LxBU8bctDB/vfHq8ZiQRFxd9BkmO
        DFG7cCSCwetd9d5/EgiuU8hoEvzsAvg6PjBsh/o=
X-Google-Smtp-Source: ABdhPJxlpHGgK7He7Tl6X9dpvDabko/7ti4gevdzxJpVQ8OpaApql1I6fxpzu3nMALBQpSWeYKjJVGmJI9w8ZqNn9aA=
X-Received: by 2002:a25:cc4c:: with SMTP id l73mr33871640ybf.114.1635810473549;
 Mon, 01 Nov 2021 16:47:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <20211101060419.4682-8-laoar.shao@gmail.com>
In-Reply-To: <20211101060419.4682-8-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Nov 2021 16:47:42 -0700
Message-ID: <CAEf4BzYEWxb+cm-cyBFMtA4mBfRfhp9dypfV+7K=wR01XYudzg@mail.gmail.com>
Subject: Re: [PATCH v7 07/11] tools/bpf/bpftool/skeleton: make it adopt to
 task comm size change
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qiang Zhang <qiang.zhang@windriver.com>,
        robdclark <robdclark@chromium.org>,
        Christian Brauner <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 11:04 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
> we don't care about if the dst size is big enough.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Petr Mladek <pmladek@suse.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> index d9b420972934..f70702fcb224 100644
> --- a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> +++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> @@ -71,8 +71,8 @@ int iter(struct bpf_iter__task_file *ctx)
>
>         e.pid = task->tgid;
>         e.id = get_obj_id(file->private_data, obj_type);
> -       bpf_probe_read_kernel(&e.comm, sizeof(e.comm),
> -                             task->group_leader->comm);
> +       bpf_probe_read_kernel_str(&e.comm, sizeof(e.comm),
> +                                 task->group_leader->comm);
>         bpf_seq_write(ctx->meta->seq, &e, sizeof(e));
>
>         return 0;
> --
> 2.17.1
>
