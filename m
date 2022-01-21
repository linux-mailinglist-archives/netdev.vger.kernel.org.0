Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D80B4965A7
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiAUTeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 14:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbiAUTeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 14:34:02 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E618C06173B;
        Fri, 21 Jan 2022 11:34:02 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id f24so12074508ioc.0;
        Fri, 21 Jan 2022 11:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPoKrn7Hh5Vi4yvWlQ8J9R17kcR6feXpyZjSU9Wi8IA=;
        b=j3Y/rqhBwCOhdl8cEhyPWkXoJxGzPYyKwvHWTfWhfVrA2J1HvHLVoD16vpo2aJdWez
         S9dZqMXAgH05MZ8ykIbFZzOQn37j0OAt5BbNPAbHKEJyUtgWu4IZegpNMAO8NEePQLAR
         rIX2A9zl4P+Rigu8dPjm5WMOJoGujFU1x0Wlhv/Duwv/9pvIB6rV35AZd50GaCQRPTdB
         LQ7v8/POBwyJukis+yStJwq8DInwEqtfLOXx/3Hmyh4y8mPLskoRZvpZUMqx0J8jsgc1
         B78wKV5knLTXmtE6ksNbV9Ss7CiYO6JZTLEXX2GasosrNMQaSXHl3FW0iyP48k5srgcW
         n/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IPoKrn7Hh5Vi4yvWlQ8J9R17kcR6feXpyZjSU9Wi8IA=;
        b=f+jhkk0X1503lI+Y2eAU4ihYpZitQz7ZWKdSEfb+KvCrlsm0APwlVITw1k7MRgiAfw
         zLyImNXQkrbM4jbNjLyJxHz8Gcktju2dsBKTTIwaF7EdQW9ks+mlNZCJGsWhT5jCBI7l
         VjAK1sWF9Bm5wVJk13Yx7INm8zar2wKUXMBxYf+dtomv5QqXgsk5kAX9gyOrtoQdhuk7
         sqHLN9Ib9W4wLZOKpRXofeHaW9SjDqLxyK88vj17X5/aiC1iR2X46k9tQBPHGZhY+DtG
         VWRUa2KSEK/ao1mQdm50g7efr1cbqPDKOh7VD36b2AsJ1loRqGpTSg6ltYxkOLb2vSw9
         Nhrg==
X-Gm-Message-State: AOAM53330qMLhRzqr5vlmJqyvwRLiHA2EYfPK03e6xeTnKI1yf6LLVnU
        1N76Z3xAVsKGRxP9l1/Dl0AZrBtfEJxcAcpgI2o=
X-Google-Smtp-Source: ABdhPJw4Ql2oOANfjA+VlOW01NkkRQSXKOdajL4FnGJhFC1ceN8fkOgAgCpTfUq6nm3w3N/bFnmWDqQoYsEhmfwAnVE=
X-Received: by 2002:a05:6638:2a7:: with SMTP id d7mr2460538jaq.93.1642793641769;
 Fri, 21 Jan 2022 11:34:01 -0800 (PST)
MIME-Version: 1.0
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com> <1642678950-19584-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1642678950-19584-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jan 2022 11:33:50 -0800
Message-ID: <CAEf4Bzbe4L0eEBpLRaQ0m6qOmV40ayGr9L-W+0fDkjm0sLe2Bw@mail.gmail.com>
Subject: Re: [RFC bpf-next 2/3] libbpf: add auto-attach for uprobes based on
 section name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Now that u[ret]probes can use name-based specification, it makes
> sense to add support for auto-attach based on SEC() definition.
> The format proposed is
>
>         SEC("u[ret]probe[/]/path/to/prog/function[+offset]")
>
> For example, to trace malloc() in libc:
>
>         SEC("uprobe/usr/lib64/libc.so.6/malloc")
>
> Auto-attach is done for all tasks (pid -1).
>
> Future work will look at generalizing section specification to
> substitute ':' for '/'.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/libbpf.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 58 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6479aae..1c8c8f0 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8565,6 +8565,7 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
>  }
>
>  static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cookie);
> +static struct bpf_link *attach_uprobe(const struct bpf_program *prog, long cookie);
>  static struct bpf_link *attach_tp(const struct bpf_program *prog, long cookie);
>  static struct bpf_link *attach_raw_tp(const struct bpf_program *prog, long cookie);
>  static struct bpf_link *attach_trace(const struct bpf_program *prog, long cookie);
> @@ -8576,9 +8577,9 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
>         SEC_DEF("sk_reuseport/migrate", SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT_OR_MIGRATE, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>         SEC_DEF("sk_reuseport",         SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>         SEC_DEF("kprobe/",              KPROBE, 0, SEC_NONE, attach_kprobe),
> -       SEC_DEF("uprobe/",              KPROBE, 0, SEC_NONE),
> +       SEC_DEF("uprobe/",              KPROBE, 0, SEC_NONE, attach_uprobe),
>         SEC_DEF("kretprobe/",           KPROBE, 0, SEC_NONE, attach_kprobe),
> -       SEC_DEF("uretprobe/",           KPROBE, 0, SEC_NONE),
> +       SEC_DEF("uretprobe/",           KPROBE, 0, SEC_NONE, attach_uprobe),
>         SEC_DEF("tc",                   SCHED_CLS, 0, SEC_NONE),
>         SEC_DEF("classifier",           SCHED_CLS, 0, SEC_NONE | SEC_SLOPPY_PFX),
>         SEC_DEF("action",               SCHED_ACT, 0, SEC_NONE | SEC_SLOPPY_PFX),
> @@ -10454,6 +10455,61 @@ static ssize_t find_elf_func_offset(const char *binary_path, const char *name)
>
>  }
>
> +/* Format of u[ret]probe section definition supporting auto-attach:
> + * u[ret]probe[/]/path/to/prog/function[+offset]
> + *
> + * Many uprobe programs do not avail of auto-attach, so we need to handle the
> + * case where the format is uprobe/myfunc by returning NULL rather than an
> + * error.
> + */
> +static struct bpf_link *attach_uprobe(const struct bpf_program *prog, long cookie)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> +       char *func_name, binary_path[512];
> +       char *func, *probe_name;
> +       struct bpf_link *link;
> +       size_t offset = 0;
> +       int n, err;
> +
> +       opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe/");
> +       if (opts.retprobe)
> +               probe_name = prog->sec_name + sizeof("uretprobe/") - 1;
> +       else
> +               probe_name = prog->sec_name + sizeof("uprobe/") - 1;
> +
> +       /* First char in binary_path is a '/'; this allows us to support
> +        * uprobe/path/2/prog and uprobe//path/2/prog, while also
> +        * distinguishing between old-style uprobe/something definitions.
> +        */

see my comments on cover letter, I don't think this is the right thing to do

> +       snprintf(binary_path, sizeof(binary_path) - 1, "/%s", probe_name);
> +       /* last '/' should be prior to function+offset */
> +       func_name = strrchr(binary_path + 1, '/');
> +       if (!func_name) {
> +               pr_debug("section '%s' is old-style u[ret]probe/function, cannot auto-attach\n",
> +                        prog->sec_name);
> +               return NULL;

this is actually a regression, we need to adapt
bpf_object__attach_skeleton() to accommodate SEC_DEF()s with attach
functions that might decide not to auto-attach (but not treat it as an
error). Maybe -EOPNOTSUPP should be treated specially?

> +       }
> +       func_name[0] = '\0';
> +       func_name++;
> +       n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
> +       if (n < 1) {
> +               err = -EINVAL;
> +               pr_warn("uprobe name is invalid: %s\n", func_name);
> +               return libbpf_err_ptr(err);
> +       }
> +       if (opts.retprobe && offset != 0) {
> +               free(func);
> +               err = -EINVAL;
> +               pr_warn("uretprobes do not support offset specification\n");
> +               return libbpf_err_ptr(err);
> +       }
> +       opts.func_name = func;
> +
> +       link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
> +       free(func);
> +       return link;
> +}
> +
>  struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
>                                             bool retprobe, pid_t pid,
>                                             const char *binary_path,
> --
> 1.8.3.1
>
