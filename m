Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8F34A9FF5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 20:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiBDTWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 14:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbiBDTWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 14:22:44 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6616FC06173D;
        Fri,  4 Feb 2022 11:22:44 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id c188so8615285iof.6;
        Fri, 04 Feb 2022 11:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aisCN3l6WOXDrmbPOWatWBE/ylzGJgrWjc6EN17uhCQ=;
        b=qz0HyOX8g6OKRqwQrQBoZiosE7q/sFrosxHYYPgBDPvTJeXhNqEaOhqcvFNc40CGhU
         nXPGKbNPycKk5e31cSHBVwKnTmwfp/p9gOz+1B7EaGiK5e3LSjdNIeIMBpKDzzsP6Rpx
         sl5vRSHdr9um5AJbwv4jpgrSxSiVYnfgtwm5O47jIYGwwWaq6QPYZAj9Ln8xkvxIl21y
         ImrK1ZcWtqhw1ZF++6Rs6StHMksUqc6Njjw0dVdUsJssx+jvgj2hm64oLZsGg6yDviX1
         6JqQMhPstT894ikVbLsnVXuDUXEXjSTJ4l64UczUBJYua0d+4DkcxIuVGbE0vQerOj/V
         FRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aisCN3l6WOXDrmbPOWatWBE/ylzGJgrWjc6EN17uhCQ=;
        b=QZL4TFE2PCFTgeG96SoLuH1PfY1zPEAFBH+FHV+WFZrDPWYIKQjl5d4rii3qKHTIBt
         4Tu8nIrzm6ns+rqNVC2KEXuOl7Otvq8bLyGrN7liQ0YO6W6MqMl/JViWo3Fi55dDyt+3
         z59pj02xfptVnbfouqHSpcjS/lziONNr728KIqyrxvWdG0kCx6Ftn4J400Wgx2p2qlu6
         ZYRciYcQ72g+gcGo6DR21nKXgkf9fEd07M0Yt64BMYg1V89FlZaBfVMR1QeekYoECMek
         5T524tEMuzDI8HkkAcLyx2RgZCS4UzyASHT9WDIu5OMSMC40mQ2RAeqzC++xjW/weYLs
         420A==
X-Gm-Message-State: AOAM531ASZip1VMW7IjFVYhFQ5VPhD6v0/wANRGQBuka4YsuvdHtVfVV
        +VrVn3FziwFd2NkVSD3qxCaJNSktr7U/B5pEf2Pg4+FU
X-Google-Smtp-Source: ABdhPJz+eb9l3RnKI/MPHzIFwOJMPhn3UPFbUMfz7Dy9S1Bjvat0AVTfVoDVQMDe45cwaF/V8fD2wWUDY00qZ8TDxeM=
X-Received: by 2002:a05:6602:2e88:: with SMTP id m8mr279536iow.79.1644002563841;
 Fri, 04 Feb 2022 11:22:43 -0800 (PST)
MIME-Version: 1.0
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com> <1643645554-28723-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1643645554-28723-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 11:22:32 -0800
Message-ID: <CAEf4Bzb9xhpn5asJo7cwhL61DawqtuL_MakdU0YZwOeWuaRq6A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/4] libbpf: add auto-attach for uprobes based
 on section name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 8:13 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Now that u[ret]probes can use name-based specification, it makes
> sense to add support for auto-attach based on SEC() definition.
> The format proposed is
>
>         SEC("u[ret]probe//path/to/prog:[raw_offset|[function_name[+offset]]")
>
> For example, to trace malloc() in libc:
>
>         SEC("uprobe//usr/lib64/libc.so.6:malloc")

I assume that path to library can be relative path as well, right?

Also, should be look at trying to locate library in the system if it's
specified as "libc"? Or if the binary is "bash", for example. Just
bringing this up, because I think it came up before in the context of
one of libbpf-tools.

>
> Auto-attach is done for all tasks (pid -1).
>
> Note that there is a backwards-compatibility issue here.  Consider a BPF
> object consisting of a set of BPF programs, including a uprobe program.
> Because uprobes did not previously support auto-attach, it's possible that
> because the uprobe section name is not in auto-attachable form, overall
> BPF skeleton attach would now fail due to the failure of the uprobe program
> to auto-attach.  So we need to handle the case of auto-attach failure where
> the form of the section name is not suitable for auto-attach without
> a complete attach failure.  On surveying the code, bpf_program__attach()
> already returns -ESRCH in cases where no auto-attach function is
> supplied, so for consistency with that - and because that return value
> is less likely to collide with actual attach failures than -EOPNOTSUPP -
> it is used as the attach function return value signalling auto-attach
> is not possible.

I'm actually working on generalizing and extending this part of
libbpf's SEC() handling, I should post code today or early next week.
So we can base your code on those changes and we won't need to worry
about error code collisions.

>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/libbpf.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 74 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index eb95629..e2b4415 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8581,6 +8581,7 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
>  }
>

[...]
