Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9692155D1B9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238870AbiF0V1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 17:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbiF0V1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 17:27:24 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C726119006;
        Mon, 27 Jun 2022 14:27:22 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id lw20so21818691ejb.4;
        Mon, 27 Jun 2022 14:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ffH6sqTChxu/43eEw2gjEC1ladRfvkvB5r33/uaRpY8=;
        b=ZH41EW1m/LJARcI+lm9nKo4a+XCFNfAO01a4+XvRgu17owajzK7SWiJ6umyLqaEI5z
         jtUqSCXtgl7coDCjeX1nmWgXwCLebD1HkAccjXIU10uED93z6YnLewRmivRjRL8zeS3W
         Cawk1sLYTfbz50BP0AEAPF02iWvX2GlBtoUkdeoKiarH+3f2w4hhH32aombGon+0SFww
         B8jJCgwNvnTqbArkUoPzC6O2VrgGuXqlDSfyBSgnh/iDSv6rimLc6/zQCXKU76X8wSP/
         a7OkL5M9QG8JOimVMYR7wPp5v2T9T/ZV5X+sA2rpRA+uu5KU1a/ottJGJKuvzNazGTYq
         Yj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ffH6sqTChxu/43eEw2gjEC1ladRfvkvB5r33/uaRpY8=;
        b=stV5892MLK7w3OQNJD232hnRcalTwWVNiOt9CSwWZageXlA8MLtNKKJVjle+cEQXtp
         Y/NpygBf3ORUG1yCmbGG0UlKbEKVT5kGF4+EXlIOrtExuWQAfZhEv2Qu/hCHRK/vxkWl
         YRySYtnZnJR/qYtAJ7q32xGSIOiLQgZGzeMhAgxibkboBVaHfzcgWIm3Ytd+L98Pa992
         vd4XoWDpqVrcAxgxq4xXwJ0M9FTORu04pbtKwVgqxeB2P/IuUeZ6ywv7OsQSy3bJc6+z
         v/r2PMoPQCE6mcNl4QDRUsn/T9eOn/cOSrLulFs2TyGX5Jwhsw8HI0p0KaoELNpJ0BNK
         SC3Q==
X-Gm-Message-State: AJIora9NaGb1UoxfLPdMn1q95SPfnuFQZPKYOliOqgdGD7Qy1TL6h5Z2
        MfKX5MreTiNuK8zaEh3q5gWXRaSTHjP7o3JF2YE=
X-Google-Smtp-Source: AGRyM1ubCMGDYUtM5u6GHoJvohmX1hyk2R3j56/JEUUZbxsjNRJW9HJRpSWU/HrVmabaokS5XgV0PPvDaZB/p/KNecM=
X-Received: by 2002:a17:907:980a:b0:722:f4a7:e00 with SMTP id
 ji10-20020a170907980a00b00722f4a70e00mr15016491ejc.114.1656365241370; Mon, 27
 Jun 2022 14:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220626031301.60390-1-nashuiliang@gmail.com>
In-Reply-To: <20220626031301.60390-1-nashuiliang@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jun 2022 14:27:09 -0700
Message-ID: <CAEf4BzbnEFqdEZTNRWf8vJ8hExpKkg_rwgoQE-cyyU7fDafxZw@mail.gmail.com>
Subject: Re: [PATCH v3] libbpf: Cleanup the legacy kprobe_event on failed add/attach_event()
To:     Chuang W <nashuiliang@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jingren Zhou <zhoujingren@didiglobal.com>
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

On Sat, Jun 25, 2022 at 8:13 PM Chuang W <nashuiliang@gmail.com> wrote:
>
> Before the 0bc11ed5ab60 commit ("kprobes: Allow kprobes coexist with
> livepatch"), in a scenario where livepatch and kprobe coexist on the
> same function entry, the creation of kprobe_event using
> add_kprobe_event_legacy() will be successful, at the same time as a
> trace event (e.g. /debugfs/tracing/events/kprobe/XXX) will exist, but
> perf_event_open() will return an error because both livepatch and kprobe
> use FTRACE_OPS_FL_IPMODIFY. As follows:
>
> 1) add a livepatch
>
> $ insmod livepatch-XXX.ko
>
> 2) add a kprobe using tracefs API (i.e. add_kprobe_event_legacy)
>
> $ echo 'p:mykprobe XXX' > /sys/kernel/debug/tracing/kprobe_events
>
> 3) enable this kprobe (i.e. sys_perf_event_open)
>
> This will return an error, -EBUSY.
>
> On Andrii Nakryiko's comment, few error paths in
> bpf_program__attach_kprobe_opts() which should need to call
> remove_kprobe_event_legacy().
>
> With this patch, whenever an error is returned after
> add_kprobe_event_legacy() or bpf_program__attach_perf_event_opts(), this
> ensures that the created kprobe_event is cleaned.
>
> Signed-off-by: Chuang W <nashuiliang@gmail.com>

Is this your full name? Signed-off-by is required to have a full name
of a person, please update if it's not

> Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
> ---
> V2->v3:
> - add detail commits
> - call remove_kprobe_event_legacy() on failed bpf_program__attach_perf_event_opts()
>
>  tools/lib/bpf/libbpf.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 49e359cd34df..038b0cb3313f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10811,10 +10811,11 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
>         }
>         type = determine_kprobe_perf_type_legacy(probe_name, retprobe);
>         if (type < 0) {
> +               err = type;
>                 pr_warn("failed to determine legacy kprobe event id for '%s+0x%zx': %s\n",
>                         kfunc_name, offset,
> -                       libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> -               return type;
> +                       libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               goto clear_kprobe_event;
>         }
>         attr.size = sizeof(attr);
>         attr.config = type;
> @@ -10828,9 +10829,14 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
>                 err = -errno;
>                 pr_warn("legacy kprobe perf_event_open() failed: %s\n",
>                         libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> -               return err;
> +               goto clear_kprobe_event;
>         }
>         return pfd;
> +
> +clear_kprobe_event:
> +       /* Clear the newly added legacy kprobe_event */
> +       remove_kprobe_event_legacy(probe_name, retprobe);
> +       return err;
>  }
>

this part looks good


>  struct bpf_link *
> @@ -10899,6 +10905,9 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
>
>         return link;
>  err_out:
> +       /* Clear the newly added legacy kprobe_event */
> +       if (legacy)
> +               remove_kprobe_event_legacy(legacy_probe, retprobe);

this one will call remove_kprobe_event_legacy() even if we failed to
create that kprobe_event in the first place. So let's maybe add

err_clean_legacy:
    if (legacy)
         remove_kprobe_event_legacy(legacy_probe, retprobe);

before err_out: and goto there if we fail to attach (but not if we
fail to create pfd)?


Also, looking through libbpf code, I realized that we have exactly the
same problem for uprobes, so please add same fixed to
perf_event_uprobe_open_legacy and attach_uprobe_opts. Thanks!




>         free(legacy_probe);
>         return libbpf_err_ptr(err);
>  }
> --
> 2.34.1
>
