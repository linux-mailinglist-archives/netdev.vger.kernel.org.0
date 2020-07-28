Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6743A231447
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgG1Uyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgG1Uyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:54:44 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAAA420775;
        Tue, 28 Jul 2020 20:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595969684;
        bh=QxYwn1VGKKYVE4wolqR/oZEUZLEvahfqhhFb7dEx8ig=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vOySFjhisZjrjcpa3h8dZhmiRAvjA3NFhmfFS7JZXK8S/tGvXyOKMFYrYlx7PH5D1
         jyTYzUGhG2rDu8q/4rFJ6BRF6R0Mxsr6+7+WmueU55U6n7ppPqUezIRS4qfuQalUOD
         MKoUI6y3GhMnR81lA+6dxW9mjZoPYzp/EoRlX9rU=
Received: by mail-lj1-f179.google.com with SMTP id b25so22687674ljp.6;
        Tue, 28 Jul 2020 13:54:43 -0700 (PDT)
X-Gm-Message-State: AOAM530vI5V6+d70J27Jj+a4pX31kzRORROBCQOUfJlEzA1AJ63DCGzS
        0Z3y5Jk+3cooPAzY9BuEujVuux6aPoBH+C/B2r0=
X-Google-Smtp-Source: ABdhPJz/HC8mfYYw1GKSPbbMVpVjzr75BnuutV80ntrPCmSBUDVRRC2syeVUsksnTjoR6DbOSlm4KUI3h6YO329kpTk=
X-Received: by 2002:a2e:88c6:: with SMTP id a6mr13313441ljk.27.1595969682062;
 Tue, 28 Jul 2020 13:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200728003139.2410375-1-andriin@fb.com> <20200728003139.2410375-2-andriin@fb.com>
In-Reply-To: <20200728003139.2410375-2-andriin@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 28 Jul 2020 13:54:31 -0700
X-Gmail-Original-Message-ID: <CAPhsuW795Y2YaRDy1mDMaF5DMdAUPjeqFdDJ97=JNo1AW0b4jw@mail.gmail.com>
Message-ID: <CAPhsuW795Y2YaRDy1mDMaF5DMdAUPjeqFdDJ97=JNo1AW0b4jw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf 2/2] selftests/bpf: extend map-in-map selftest to
 detect memory leaks
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 5:32 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add test validating that all inner maps are released properly after skeleton
> is destroyed. To ensure determinism, trigger kernel-side synchronize_rcu()
> before checking map existence by their IDs.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

With one last nitpick...

> ---
>  .../selftests/bpf/prog_tests/btf_map_in_map.c | 124 ++++++++++++++++--
>  1 file changed, 110 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> index f7ee8fa377ad..2af1996df6f3 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> @@ -5,10 +5,60 @@
>
>  #include "test_btf_map_in_map.skel.h"
>
> +static int duration;
> +
> +__u32 bpf_map_id(struct bpf_map *map)

nit: We can make this function static.
