Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E063D81A6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhG0VUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235121AbhG0VUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:20:03 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834FFC06136A;
        Tue, 27 Jul 2021 14:17:58 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v46so363034ybi.3;
        Tue, 27 Jul 2021 14:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N0YopGj12bQGWfMdc3jkyR2E2qRKbpuIhWGg2LpvYYc=;
        b=fnpjhchgw22BQ0yXyTWlGm7QISRq8QvpJrKVU4oqt1VFqRwb2BsdTMm6advPdgqDhl
         hGHbFrZeLqqYw3JqYgfqLFr0aFlysgq9YyYAEgSJpcR6/XTsk8mFO/yFbj4PsqFxRODQ
         gMiHAAUmZSUp7wMHiwiVK/MR5JKARSIxqwjVmZbEcC+nXFJeZkyo6sel3/ulwK8zesuR
         ePmyTdLEKPj+R8ZDoraJIxFiSjDYiWSQDvZl8Yygz7jU+fDHH2jetvRq0LJ2oRyWfuK1
         XpX2hQicYrgJ3wlUXN4IzyS1s029QCXKDiZ4dtG3aUkYK7ESXeDjAcdbZAUTRumkvn4R
         bveA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N0YopGj12bQGWfMdc3jkyR2E2qRKbpuIhWGg2LpvYYc=;
        b=VmRvuPETTxm1p4ok5EdNc4i4dNDqyLUE13jCmAGDS6kwnfGszpoZNbtJirec98rR+l
         F2WlvYcRZHa0oLeDle0Btxb5B+LLKHKi4ZqaIkKSDXT4ckXBEW9GPZRhLmexxMEvNk3c
         l4g6bFaEbt1g1nJXH15DYc9lcIUWG5liBXCR0D2gcIAbQBp+lZznK+u4CR1p3i3WAxn3
         qHAKX6vLg7sxATofevUZPly1sIDpQ2+P7aipd8N7N1QRaOWDpt3s2Y/aebUbR2gcRa+J
         y+sXVVP6S1JXGmXU34U0hydFjC5IX2IyJNMq3TILc98pPWxSacGKLkhM5jacyxFh0DSq
         Pr7A==
X-Gm-Message-State: AOAM533a6JMkIkB57HZazTa4YiN3L2nkRrYd94srhUAY/Y4Z57H5+OdR
        NIcPwG+BEZQ6Vwc5ca+QEc9dJxhevaEDE7K/V30=
X-Google-Smtp-Source: ABdhPJxkfTc6jsEilq04G4xnwG5iajUVdwv/eSrHcRbskv4JbDzLbDGEqRF8hN+ykj4m/aGPDwFJAqKB/tG1quafeF4=
X-Received: by 2002:a25:6148:: with SMTP id v69mr12085934ybb.510.1627420677808;
 Tue, 27 Jul 2021 14:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <DB8P193MB0581FEB4CB90263430546C4C88E99@DB8P193MB0581.EURP193.PROD.OUTLOOK.COM>
In-Reply-To: <DB8P193MB0581FEB4CB90263430546C4C88E99@DB8P193MB0581.EURP193.PROD.OUTLOOK.COM>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Jul 2021 14:17:46 -0700
Message-ID: <CAEf4BzaSthevAa_0Jjc4meKtW898NPgzd6yywzLLfztVa_c55Q@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix probe for BPF_PROG_TYPE_CGROUP_SOCKOPT
To:     =?UTF-8?B?Um9iaW4gR8O2Z2dl?= <r.goegge@outlook.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 7:41 AM Robin G=C3=B6gge <r.goegge@outlook.com> wro=
te:
>
> This patch fixes the probe for BPF_PROG_TYPE_CGROUP_SOCKOPT,
> so the probe reports accurate results when used by e.g.
> bpftool.
>
> Fixes: 4cdbfb59c44a ("libbpf: support sockopt hooks")
>
> Signed-off-by: Robin G=C3=B6gge <r.goegge@outlook.com>
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
> ---

Looks good, I'll apply to bpf tree once this patch makes it into patchworks=
.

Meanwhile, looking at probe_load() seems like a bunch of other program
types are not handled properly as well. Would you mind checking that
as well and following up with more fixes for this? See also [0] for
this whole probing APIs situation.

  [0] https://github.com/libbpf/libbpf/issues/312

>  tools/lib/bpf/libbpf_probes.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.=
c
> index ecaae2927ab8..cd8c703dde71 100644
> --- a/tools/lib/bpf/libbpf_probes.c
> +++ b/tools/lib/bpf/libbpf_probes.c
> @@ -75,6 +75,9 @@ probe_load(enum bpf_prog_type prog_type, const struct b=
pf_insn *insns,
>         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>                 xattr.expected_attach_type =3D BPF_CGROUP_INET4_CONNECT;
>                 break;
> +       case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> +               xattr.expected_attach_type =3D BPF_CGROUP_GETSOCKOPT;
> +               break;
>         case BPF_PROG_TYPE_SK_LOOKUP:
>                 xattr.expected_attach_type =3D BPF_SK_LOOKUP;
>                 break;
> @@ -104,7 +107,6 @@ probe_load(enum bpf_prog_type prog_type, const struct=
 bpf_insn *insns,
>         case BPF_PROG_TYPE_SK_REUSEPORT:
>         case BPF_PROG_TYPE_FLOW_DISSECTOR:
>         case BPF_PROG_TYPE_CGROUP_SYSCTL:
> -       case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>         case BPF_PROG_TYPE_TRACING:
>         case BPF_PROG_TYPE_STRUCT_OPS:
>         case BPF_PROG_TYPE_EXT:
> --
> 2.25.1
>
