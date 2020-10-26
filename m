Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43432999B8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394532AbgJZWdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:33:00 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35555 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394179AbgJZWdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 18:33:00 -0400
Received: by mail-yb1-f194.google.com with SMTP id m188so4036091ybf.2;
        Mon, 26 Oct 2020 15:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tYGKgBOvXd0V/keZVVJoez9jaPUFednPhovrcJOgA2g=;
        b=kAauVYU8XtFtg2dOaqnJQwkbqB52ez/V5BY4VECXf1bDCA3xkrgRxmc8mhHkcL7Sh2
         AnPLxWk9P9V1Lreux98xz77OgW9JboFSUIItFrvNvleQT0UzZqghu4150Ors4lsor85u
         gRoREfMaYdYZhjfAARgesMNdkJCswegVeHEWUIfeRxBQ5gQle3JJN5ORqwnMaSZuqUbe
         FALLq7z6Uf9W7P2t1zkJcuOiBjPeJbdCNQM82B7viQLfowGVyApJqeWkEBNtry0VWiCp
         LtwOeOXqtIen5DMkS5jbnd6DPA+/SQfqUxiLg9kUyrnEEscb7eIv0G0MOnvPkiMCdVT0
         RzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tYGKgBOvXd0V/keZVVJoez9jaPUFednPhovrcJOgA2g=;
        b=O4YIv+7NEXQm19X/WYq0dMHS7qDu9RmEugG4/o2EAmxRWHNnlTQ9sLsiufFnBOfzwK
         BoHa00e13JFh5fYF9mzvdYmjJPDk9si3OGZWzC92utChH3WNTv7UzoMjPKCuOmgot+yQ
         bAZv1svxNNr8F8PxlLGuMuVOIkDwSHV1Hzn8PYBwKa9Vvb2SiwuvD4xx1dh+Uduks5wv
         qSlhJTtGGvscj8v/09hjMnYzoJXFiAsj8XXAm+VFt+RmnrxP7B5fHNfa3z2d+n31yy5Q
         xICSfmSVZ5hGuUKQ310a5ZhoTIZq83jEXTHOg3vzgyVTv/IEtYYNrG5QcBknQEy5Uqxa
         7MPw==
X-Gm-Message-State: AOAM532OJ+4sTGKHUXHMltBAOQkpO2Zn6B1IyXA0H9g5wbKrpRL+cgKU
        uIkM8iPxcebuLnNQdHGOPP1nZcMgZrhCiJY/WcA=
X-Google-Smtp-Source: ABdhPJzJ8WKki2YfYpJmDD9XUL4ndI92W9goc0lwvGF2XEbq+khib6ri7e9trS95QelSwRqFNcMe0EnnNUduMZUawrk=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr27858824ybk.260.1603751578973;
 Mon, 26 Oct 2020 15:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201026210355.3885283-1-arnd@kernel.org>
In-Reply-To: <20201026210355.3885283-1-arnd@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Oct 2020 15:32:48 -0700
Message-ID: <CAEf4BzYbH_x3s0Z4YGv4spOQ5oQAYbYNBf+3Fy5eopCK8=nuNw@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix incorrect initialization of bpf_ctx_convert_map
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Jiri Olsa <jolsa@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>,
        Hao Luo <haoluo@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 2:04 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> gcc -Wextra points out that a field may get overridden in some
> configurations such as x86 allmodconfig, when the next index after the one
> that has been assigned last already had a value, in this case for index
> BPF_PROG_TYPE_SK_LOOKUP, which comes after BPF_PROG_TYPE_LSM in the list:
>
> kernel/bpf/btf.c:4225:2: warning: initialized field overwritten [-Woverride-init]
>  4225 |  0, /* avoid empty array */
>       |  ^
> kernel/bpf/btf.c:4225:2: note: (near initialization for 'bpf_ctx_convert_map[30]')
>
> Move the zero-initializer first instead. This avoids the warning since
> nothing else uses index 0, and the last element does not have to be zero.

Wouldn't it be cleaner and more explicit to add __MAX_BPF_PROG_TYPE to
enum bpf_prog_type in include/uapi/linux/bpf.h, similarly to how we do
it with enum bpf_attach_type? Then just specify the size of the array
here explicitly? Unless we are trying to save a few bytes for more
minimal configurations where some BPF program types are not used (but
still defined in an enum)?


>
> Fixes: e9ddbb7707ff ("bpf: Introduce SK_LOOKUP program type with a dedicated attach point")
> Fixes: 4c80c7bc583a ("bpf: Fix build in minimal configurations, again")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  kernel/bpf/btf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index ed7d02e8bc93..2a4a4aeeaac1 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4218,11 +4218,11 @@ enum {
>         __ctx_convert_unused, /* to avoid empty enum in extreme .config */
>  };
>  static u8 bpf_ctx_convert_map[] = {
> +       [0] = 0, /* avoid empty array */
>  #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
>         [_id] = __ctx_convert##_id,
>  #include <linux/bpf_types.h>
>  #undef BPF_PROG_TYPE
> -       0, /* avoid empty array */
>  };
>  #undef BPF_MAP_TYPE
>  #undef BPF_LINK_TYPE
> --
> 2.27.0
>
