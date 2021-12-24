Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C16547EC54
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 07:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351618AbhLXG5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 01:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241330AbhLXG5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 01:57:33 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A688C061401;
        Thu, 23 Dec 2021 22:57:33 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id r2so5926118ilb.10;
        Thu, 23 Dec 2021 22:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=il9ZsHhcrefB2NTmfHYGwtXJdwA7dkSBq3okcSCwdaQ=;
        b=B0hDCgB2ikHU2bh9TgOWmxgp4NwMpsfCd9QeiSEZg77U/NU6kfs0DFVTPoI0sVIffL
         0Q+c6TQZbqF5HdEARSX5PybHd1EdP+4TPG7qTSP4jElAmsANVpmJaQuVnhZn+tiw7mq8
         l//s3NsdbemZMDbrQJobx63OhU1DsvHLDIXlpWc9NotJa7L2txhJ3zDmyEtoBWVR0Xnv
         UCzle1BfPUuR2YzULknSm3c2L88Xr94g+I+Pc2ZLzAJS9mni8RKTcuKnzqLo2oJuGnbo
         q4W2SiFap/JMPtAsgMS1DiItHn+8PGgu8MCarbY7NiA81Jmoayq+zw1jEzOMiifo8IXS
         oRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=il9ZsHhcrefB2NTmfHYGwtXJdwA7dkSBq3okcSCwdaQ=;
        b=45S+gBxUAcEL6Fa7b0wBgslli1miLgeXRi1tTyWwJMMAjio+f9W5E/aL81tYwJZZuj
         LRuiF2Nn79qjeiEVi5YGddCDaZ9xY8xF1bxuT9pF/5k6WpULJ3sW5KCI2daEUUBdNnkH
         faPAcgHXkRhJa06EN4uoSadgFmVxJf+phNQW2sS8/zjTMmF4pCfJS+njitl7EOl4uIH9
         kLDKIEBAJ2K7CiDKq85Sc4LrXqAzrk8vY+ync45BIiSnI+xs/wNokGCDM+2M2QlMhZmF
         vRHZgvMUAn4MvL4gFGvnZ9C26DkSHDymNZGBbhu1Fvc5fvFd8g8ASSRCJQqpAL7Zwd6y
         rr1A==
X-Gm-Message-State: AOAM532B6vS/1gzCB3p6JQm4WdtouoDOGfYGL4XKcOwGF0fYano/j2MY
        6MtIUqrCdFPh204FDzcLyyUiHa5aWcmT0dXQj/8=
X-Google-Smtp-Source: ABdhPJyjmuj2ip8cGVIqWma2BZFOOosThmhpHT5U2RgqboTRqYfnbOPX4aKMytO5ZE1YBTfPWAKg1AiFb1AozuOmJGg=
X-Received: by 2002:a05:6e02:1a24:: with SMTP id g4mr82005ile.71.1640329052759;
 Thu, 23 Dec 2021 22:57:32 -0800 (PST)
MIME-Version: 1.0
References: <c84094d2-75c1-a50d-ea9e-9dded5f01fb9@bytedance.com>
In-Reply-To: <c84094d2-75c1-a50d-ea9e-9dded5f01fb9@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 23 Dec 2021 22:57:21 -0800
Message-ID: <CAEf4Bza200bB3d-E3rMyxZs7wxijbzJ_0xmRSy+=tHm2Ot14Eg@mail.gmail.com>
Subject: Re: Fix repeated legacy kprobes on same function
To:     Qiang Wang <wangqiang.wq.frank@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, zhouchengming@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        duanxiongchun@bytedance.com, shekairui@bytedance.com,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 8:01 PM Qiang Wang
<wangqiang.wq.frank@bytedance.com> wrote:
>
> If repeated legacy kprobes on same function in one process,
> libbpf will register using the same probe name and got -EBUSY
> error. So append index to the probe name format to fix this
> problem.
>
> And fix a bug in commit 46ed5fc33db9, which wrongly used the
> func_name instead of probe_name to register.
>
> Fixes: 46ed5fc33db9 ("libbpf: Refactor and simplify legacy kprobe code")
> Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Qiang Wang <wangqiang.wq.frank@bytedance.com>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>
> ---
>   tools/lib/bpf/libbpf.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7c74342bb668..7d1097958459 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -9634,7 +9634,8 @@ static int append_to_file(const char *file, const
> char *fmt, ...)
>   static void gen_kprobe_legacy_event_name(char *buf, size_t buf_sz,
>                                           const char *kfunc_name, size_t
> offset)
>   {
> -       snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx", getpid(),
> kfunc_name, offset);
> +       static int index = 0;
> +       snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx_%d", getpid(),
> kfunc_name, offset, index++);

BCC doesn't add this auto-increment (which is also not thread-safe)
and it seems like that works fine for all users.

What is the use case where you'd like to attach to the same kernel
function multiple times with legacy kprobe?

>   }
>
>   static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
> @@ -9735,7 +9736,7 @@ bpf_program__attach_kprobe_opts(const struct
> bpf_program *prog,
>                  gen_kprobe_legacy_event_name(probe_name,
> sizeof(probe_name),
>                                               func_name, offset);
>
> -               legacy_probe = strdup(func_name);
> +               legacy_probe = strdup(probe_name);

please send this as a separate fix

>                  if (!legacy_probe)
>                          return libbpf_err_ptr(-ENOMEM);
>
> --
> 2.20.1
>
