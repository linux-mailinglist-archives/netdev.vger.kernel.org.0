Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4AD39EA43
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 01:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFGXnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFGXny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 19:43:54 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64E5C061574;
        Mon,  7 Jun 2021 16:41:45 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id b9so27476033ybg.10;
        Mon, 07 Jun 2021 16:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JThR94HK/PNwE+CdS8jezHLb3p5lfPVZqYEfwfaZLFM=;
        b=qPlj+pEN8yaKacr7ymZaLgbQNX1kNhJ3O4zBw891u855OrQXXNBgvx+RNv4/BQBfCJ
         GlUE5gOtkIXXyZQzCHJmL4XEDyN/5RKCyKwXO83xyIjI4PZUdgg3MM5B5nHE3g5JTpjZ
         fKiVax2m46bCJzGFMOG7r3fpqbd1v1OU1HivJ7ZTzqVeuX1RrKSVITBlX5yphAG/S69W
         XA7sfqNMbpd44dIHkF3+Crbx6PT+rkzoN+Vq8rxqPeYha9PjdSAsfiP09TDfFoz7dMFL
         2YwU7dMtGzDBsDQtQ8OFoEmsiyF0pJZLA+HRf8d6hSYQ4hAdLWczUD89cTtayMzPooab
         Inhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JThR94HK/PNwE+CdS8jezHLb3p5lfPVZqYEfwfaZLFM=;
        b=W92jv4dihFZRLdYyRaU8+WDguMZgbZ38XxYjbqTQcjgegENw/zVopSbSB1zAJoWO5q
         pmDCgNy7t5jguycuSHKZS+7dXQ6h7mWPwabIaWcThl+P3apOosw/d+IfoBl2pSqsDu8P
         q83ZFJMBt8CHyn28e0LH+sNJXSGji2TXvjiS+188IMwGI0bPwp2xTLqwPY77sB4u+lj4
         4v0aEaZBglaBKQmjdqagaUJQZhbDawJxlFDnF5FEkaYXeiIDg702X/dQmJ5ojKlqrsQH
         UZ7auy3kytKW/Va68vrXFG+F9d65VSRoK+36NQugasv2aZMSPYbbnvYTbT4jbWrJRwxa
         HRYQ==
X-Gm-Message-State: AOAM530eI72FHjm6+SWEiIwsFvmdiDD3ZoVysrzxLCf7ixMlWhCMRSca
        e1i5nwPYKSgAKzR/GLGpb1QX0epzVrKymJEn0bI=
X-Google-Smtp-Source: ABdhPJwHpAm9ADNUgeBPvfeGnvGnxeGgfE+0YJLbCG4w9pN6FYpuaQq4JfcBetF98ppDa2WLrAnc8EVnUtIGKdUuHnc=
X-Received: by 2002:a25:4182:: with SMTP id o124mr26727553yba.27.1623109304846;
 Mon, 07 Jun 2021 16:41:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com> <20210604063116.234316-7-memxor@gmail.com>
In-Reply-To: <20210604063116.234316-7-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Jun 2021 16:41:33 -0700
Message-ID: <CAEf4BzaPewpUkPMvKXupQdANHbuAoEokC5g8eiugQcaJ_saVDg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/7] libbpf: add bpf_link based TC-BPF
 management API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 11:32 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds userspace TC-BPF management API based on bpf_link.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>.
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/bpf.c      |  8 +++++-
>  tools/lib/bpf/bpf.h      |  8 +++++-
>  tools/lib/bpf/libbpf.c   | 59 ++++++++++++++++++++++++++++++++++++++--
>  tools/lib/bpf/libbpf.h   | 17 ++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  tools/lib/bpf/netlink.c  |  5 ++--
>  tools/lib/bpf/netlink.h  |  8 ++++++
>  7 files changed, 100 insertions(+), 6 deletions(-)
>  create mode 100644 tools/lib/bpf/netlink.h
>

[...]

> +       link =3D calloc(1, sizeof(*link));
> +       if (!link)
> +               return ERR_PTR(-ENOMEM);
> +       link->detach =3D &bpf_link__detach_fd;
> +
> +       link_fd =3D bpf_link_create(prog_fd, OPTS_GET(hook, ifindex, 0), =
BPF_TC, &lopts);
> +       if (link_fd < 0) {
> +               link_fd =3D -errno;
> +               free(link);
> +               pr_warn("prog '%s': failed to attach tc filter: %s\n",
> +                       prog->name, libbpf_strerror_r(link_fd, errmsg, si=
zeof(errmsg)));
> +               return ERR_PTR(link_fd);

like Yonghong mentioned, all these error returns have to be either
`return libbpf_err_ptr(err);` or, given it's a new API, we can do just
direct `return errno =3D err, NULL;`. I'd probably use libbpf_err_ptr()
for now for consistency.

> +       }
> +       link->fd =3D link_fd;
> +
> +       return link;
> +}
> +
>  struct bpf_link *bpf_program__attach_freplace(struct bpf_program *prog,
>                                               int target_fd,
>                                               const char *attach_func_nam=
e)

[...]

> diff --git a/tools/lib/bpf/netlink.h b/tools/lib/bpf/netlink.h
> new file mode 100644
> index 000000000000..c89133d56eb4
> --- /dev/null
> +++ b/tools/lib/bpf/netlink.h
> @@ -0,0 +1,8 @@
> +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +#pragma once

we don't use "#pragma once" in libbpf. And I saw some kernel
discussions discouraging its use. So please just stick to the classic
#ifdef/#define/#endif combo.

> +
> +#include <linux/types.h>
> +#include "libbpf.h"
> +
> +int tc_get_tcm_parent(enum bpf_tc_attach_point attach_point,
> +                     __u32 *parent);
> --
> 2.31.1
>
