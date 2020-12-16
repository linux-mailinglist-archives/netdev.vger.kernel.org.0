Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567502DC6E0
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733013AbgLPTE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733009AbgLPTE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:04:27 -0500
X-Gm-Message-State: AOAM530i40Y8dEWXnOWKiAXgXhpKfRw+Kqw8LC8+2cVOPmpTfcZo38MG
        jQl+ndAgx0mTBH6d5zNeD8xcN0cNlh3NpOnp4VuGtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608142553;
        bh=SpoSy2ru3dxdVIN3z4wBnLjHSnde6Ol4c5u5A58iUnA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pX32w6A4XK95zjCGoTEGF1sfNqofZ7WjblrXJ3NkN8DzAb2eHc8tiEJtRbfiPRpy6
         +43I8TUn+bXKfoVSQeQbHDO6bPCMP9JwSKXgOl44iCXpOYkR+QWYMPRG8BipoLNe0z
         NqKbQGOhcky3hISdJOaWC3jtzwwsYMDfXx01SyTwiEMo1ah9RpOqAKNW/2iYI2C9Dz
         1+Og9Y1Pq4VBeH1sQzlK1J7gP34x32HIOI/Hl2A8FtRkA/zXrR39XcW0GJ9E5CLNJO
         eCJh+As4rwySJ4KaF88hrNua6zD9yQW88Fg7LkoCRD9SxLDnHd+uczK/Qr1Mpn6SdT
         F3rA0hWa8QzuQ==
X-Google-Smtp-Source: ABdhPJzvPzglAPBQ2YqX5Vzx39lxQg6y7LTkHB2g3e5epJeJ8TZOpwX7QrKgS740w1a/SROZqCpbYD1u841pV3yx8hw=
X-Received: by 2002:a05:651c:542:: with SMTP id q2mr15537280ljp.19.1608142551416;
 Wed, 16 Dec 2020 10:15:51 -0800 (PST)
MIME-Version: 1.0
References: <20201215233702.3301881-1-songliubraving@fb.com> <20201215233702.3301881-3-songliubraving@fb.com>
In-Reply-To: <20201215233702.3301881-3-songliubraving@fb.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 16 Dec 2020 19:15:40 +0100
X-Gmail-Original-Message-ID: <CANA3-0cNSkE3iFjbG6EdsA9ZsrTEApBmVwU-2LOkC+0om70zQQ@mail.gmail.com>
Message-ID: <CANA3-0cNSkE3iFjbG6EdsA9ZsrTEApBmVwU-2LOkC+0om70zQQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: allow bpf_d_path in sleepable
 bpf_iter program
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 1:06 AM Song Liu <songliubraving@fb.com> wrote:
>
> task_file and task_vma iter programs have access to file->f_path. Enable
> bpf_d_path to print paths of these file.
>
> bpf_iter programs are generally called in sleepable context. However, it
> is still necessary to diffientiate sleepable and non-sleepable bpf_iter
> programs: sleepable programs have access to bpf_d_path; non-sleepable
> programs have access to bpf_spin_lock.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  kernel/trace/bpf_trace.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 4be771df5549a..9e5f9b968355f 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1191,6 +1191,11 @@ BTF_SET_END(btf_allowlist_d_path)
>
>  static bool bpf_d_path_allowed(const struct bpf_prog *prog)
>  {
> +       if (prog->type == BPF_PROG_TYPE_TRACING &&
> +           prog->expected_attach_type == BPF_TRACE_ITER &&
> +           prog->aux->sleepable)
> +               return true;

For the sleepable/non-sleepable we have been (until now) checking
this in bpf_tracing_func_proto (or bpf_lsm_func_proto)

eg.

case BPF_FUNC_copy_from_user:
return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;

But even beyond that, I don't think this is needed.

We have originally exposed the helper to both sleepable and
non-sleepable LSM and tracing programs with an allow list.

For LSM the allow list is bpf_lsm_is_sleepable_hook) but
that's just an initial allow list and thus causes some confusion
w.r.t to sleep ability (maybe we should add a comment there).

Based on the current logic, my understanding is that
it's okay to use the helper in the allowed hooks in both
"lsm.s/" and "lsm/" (and the same for
BPF_PROG_TYPE_TRACING).

We would have required sleepable only if this helper called "dput"
(which can sleep).

> +
>         if (prog->type == BPF_PROG_TYPE_LSM)
>                 return bpf_lsm_is_sleepable_hook(prog->aux->attach_btf_id);
>
> --
> 2.24.1
>
