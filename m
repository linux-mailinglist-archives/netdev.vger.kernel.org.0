Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1401E4C80
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388805AbgE0R6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387653AbgE0R6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:58:52 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BADC03E97D;
        Wed, 27 May 2020 10:58:51 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b27so392947qka.4;
        Wed, 27 May 2020 10:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WRv4Z8zJNUKA0SGzkHYaK+ggH5/VmBQG1XzDnpTMpe8=;
        b=o4EJqw+cQCec1/8DC0/Bzvc0DHz3n6c35XtBRNO//XIG6JmyIc3G8w4vrd4kiGkzQt
         QLV5bQkAPy/Oh4Zvw51za0pc2KAaW8OlJr4u/nw+LzXdzGcA0X6YhHPClspD6EDNz6Gy
         LwttPa6MPiS6MAAW8kmFkH5T7K2QVwXPjvWrdueR0BROcZF8xGmkJTsJ8mMLHfqt2Swy
         f04b9FJn4r2pw1/4JcZ6aYLOzgj+P3UBsbnxNBLXfL7ZQFmU7TyJVOWKIZmYwUGn8mbP
         EXxLXYazFboOK7civ7yJcqFvGtwaEkCVRZOYp+WcYAA8ldKoIyCHV3t9pbnBttetlh35
         wc7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WRv4Z8zJNUKA0SGzkHYaK+ggH5/VmBQG1XzDnpTMpe8=;
        b=JRSRF93MhCjqm/2ZA14azZNx3D6t6Ifzjk1isBH8nfqFO12CBtnyt5puDTAEA9FSZt
         cXjNGTtmXl2gisO/Wr6MVWZr3iPKrYWNiiVzMJG6XJ2IxXaMqIDmQlfDZOyd0oLBKPF3
         crKabbo9GiyGqVxh6asYKS+Qa1mt1qqoGtUNcg00DAkQAPsVpWPeTZ2+6Nix8W3DgZRZ
         tyTODgo+UWAZeuzwUGZ72vRyvhLcifreBBJUtSyCR46OOxG6vY4PvJz1XSDO3BDjsJPk
         nokZMmyPs+VMcXT1fvdqBNdP0qm3daXhtRfCgjcIpiVQNpo+MKuookUPFU7nbU8kKYMw
         uvgA==
X-Gm-Message-State: AOAM533QT23NuErVtE4C7Qtu7zCJuFQG1F0PlzMpipZJCa48ybbGaLIv
        TxlD7mdfKxF87Ql8hg6SqrixvdSFQcsHQEx3atc=
X-Google-Smtp-Source: ABdhPJyNzM/ZCzAUGSmfqD1qt8hKcBEbfNs5ViVnw70hBboIqloM4u6U0kIEAZbBTvnGKYuN+FI7nblJ1cp3sZdBvXc=
X-Received: by 2002:a37:a89:: with SMTP id 131mr5211385qkk.92.1590602330816;
 Wed, 27 May 2020 10:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <159056888305.330763.9684536967379110349.stgit@ebuild>
In-Reply-To: <159056888305.330763.9684536967379110349.stgit@ebuild>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 May 2020 10:58:39 -0700
Message-ID: <CAEf4BzZ8h89QXQLFKM34iggW3M1AzBFKcqvq2J9Jn=Ur9yM7YA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix perf_buffer__free() API for sparse allocs
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 1:42 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> In case the cpu_bufs are sparsely allocated they are not
> all free'ed. These changes will fix this.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---

Thanks a lot!

You forgot:

Fixes: fb84b8224655 ("libbpf: add perf buffer API")

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 5d60de6fd818..74d967619dcf 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8137,9 +8137,12 @@ void perf_buffer__free(struct perf_buffer *pb)
>         if (!pb)
>                 return;
>         if (pb->cpu_bufs) {
> -               for (i = 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) {
> +               for (i = 0; i < pb->cpu_cnt; i++) {
>                         struct perf_cpu_buf *cpu_buf = pb->cpu_bufs[i];
>
> +                       if (!cpu_buf)
> +                               continue;
> +
>                         bpf_map_delete_elem(pb->map_fd, &cpu_buf->map_key);
>                         perf_buffer__free_cpu_buf(pb, cpu_buf);
>                 }
>
