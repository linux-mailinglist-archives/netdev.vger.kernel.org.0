Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0820A2B2BCB
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 07:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgKNGqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 01:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgKNGqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 01:46:54 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19495C0613D1;
        Fri, 13 Nov 2020 22:46:54 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id o71so10512959ybc.2;
        Fri, 13 Nov 2020 22:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T3JoNGsLLfaSzgm/xH7EsjSABx9CvajWm1o2Q/RugXw=;
        b=rDgIVuWZYhSHvUV7sPPvkJ0fXhA/pUmPszDyTdMZ2LC41dE7neI+fvhXFxYZz8bKUm
         eli1rPb++MBA4qr0DZr0oYuCnzEyiRQvwb76DglOFRmoHpJZ/qTXsmM+2OsquNnzEHjt
         v4tee06b0VU0dvXjLs7OOvVee51NgLILEzj10jiak6JKrfa43WxFTgxnOzG2q8K4E5bo
         lbsxMzhKlyevRocnHKGLVWTmRfozDyn6h4Gdgx/RdHbzL6pWvFMvfGGHsFUWgR1VWo7g
         TR8hBNNHsTXywCHfVM04FWo0nUxup1AIIICaV0Cl7FO0lPylbPpVyng1ehD1WFvndq4c
         fB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T3JoNGsLLfaSzgm/xH7EsjSABx9CvajWm1o2Q/RugXw=;
        b=BhXKt5V9DslYbtmqirSHWZ28LGb13RF8AVit1sLksPp+AE8E48373I1AU+CfZThKfk
         NFshMKyamiUiJFkN5835Ig++qolW3Cm7xr9k84uKWss73FoM9rGxxqDdzHYmSWFaTW3B
         4XPyylJ0NfG0gwhZs408LIgBQ1786hWBg8oK8Ycy01DPJj2glsEyFiEB5JMVfiUyS2ZP
         f8DGqDPr/HEdXvchgBdsgspIP6UC/qmX483q37opOUymk6ROJuZHmGmnHXpFRlv9RquI
         kPLp/tc9iJrS54GK8oANHhhfOrw5vVxBubQJTVSIsVh4GH4lJWgSB2t+t4H59ZsPRAJA
         BRRw==
X-Gm-Message-State: AOAM531PHCzRsgRhaWYZdwrDJDMRP76KeCbnq5KexaAnsvwZK28lByan
        njuElwNV4voUlYXWYkhdUkydBKCsKaig+v4sNXs=
X-Google-Smtp-Source: ABdhPJzsXVU9tct6T3TnUVPbuJD0Nx1iykTRf8zhCWn8ih9iIEuzIEmnQklUihQqO8txgXREer2vDSHnjVHyYt0YjjQ=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr6684246ybg.230.1605336413266;
 Fri, 13 Nov 2020 22:46:53 -0800 (PST)
MIME-Version: 1.0
References: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com> <1605291013-22575-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1605291013-22575-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Nov 2020 22:46:42 -0800
Message-ID: <CAEf4BzZ6RBVSDdHBjRsHGUg0ZKU-vSKZuLXq7y1zFHZV4xhiQg@mail.gmail.com>
Subject: Re: [RFC bpf-next 2/3] libbpf: bpf__find_by_name[_kind] should use btf__get_nr_types()
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 10:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> When operating on split BTF, btf__find_by_name[_kind] will not
> iterate over all types since they use btf->nr_types to show
> the number of types to iterate over.  For split BTF this is
> the number of types _on top of base BTF_, so it will
> underestimate the number of types to iterate over, especially
> for vmlinux + module BTF, where the latter is much smaller.
>
> Use btf__get_nr_types() instead.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

Good catch. I'm amazed I didn't fix it up when I implemented split BTF
support, I distinctly remember looking at these two APIs...

Can you please add Fixes tag and post this as a separate patch? There
is no need to wait on all the other changes.

Fixes: ba451366bf44 ("libbpf: Implement basic split BTF support")

>  tools/lib/bpf/btf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 2d0d064..0fccf4b 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -679,7 +679,7 @@ __s32 btf__find_by_name(const struct btf *btf, const char *type_name)
>         if (!strcmp(type_name, "void"))
>                 return 0;
>
> -       for (i = 1; i <= btf->nr_types; i++) {
> +       for (i = 1; i <= btf__get_nr_types(btf); i++) {

I think it's worthwhile to cache the result of btf__get_nr_types(btf)
in a local variable instead of re-calculating it thousands of times.

>                 const struct btf_type *t = btf__type_by_id(btf, i);
>                 const char *name = btf__name_by_offset(btf, t->name_off);
>
> @@ -698,7 +698,7 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
>         if (kind == BTF_KIND_UNKN || !strcmp(type_name, "void"))
>                 return 0;
>
> -       for (i = 1; i <= btf->nr_types; i++) {
> +       for (i = 1; i <= btf__get_nr_types(btf); i++) {

same as above


>                 const struct btf_type *t = btf__type_by_id(btf, i);
>                 const char *name;
>
> --
> 1.8.3.1
>
