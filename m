Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1486D6D2D4
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfGRRb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:31:59 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46994 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRRb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:31:59 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so28019232qtn.13;
        Thu, 18 Jul 2019 10:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jWf17EVMvZGSpA3H+ooozo3DQA4byfgOEwJC4G8BGps=;
        b=BjjDK0/TCbQAfZR8AsJaT4ErD25yeJkNi4UL8Ik6JiwcRd7sOT56oyK+Tp2qLYpyzr
         PMWSQq7aay0uUOnco+nNPiTZc18JZDtpXi6zns+p4OorvTwI+aEe+rhA8jDthOngLFah
         1MdSen9Y/pSgqyZGUQY/81VPJvpjsEL4hJkuPYzL5ObRJlw+qxgic43xgQRJ1/jydVev
         4M6kp/Nsd5+8riXjEZ3kjM6BlaCjn2IjP0cx8F9yhM35pKbwthPofKaORdsEZKvmMhwC
         eKy81mSpkVEL9jpNvGbyxqHdqiCTEhe4S5cCo1hfmdgxJ5aECtDgCuCRw9l0tw4pmIsW
         10NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jWf17EVMvZGSpA3H+ooozo3DQA4byfgOEwJC4G8BGps=;
        b=s4tJB6x92M+J9L/S17Ur0GsXy3OyUJZfQnDodz4cvejvjbuooorND9Gqwknk6bpthR
         VkHXgwwFgnfGWMUwFZl5kMPfBV7bNX1tN+U0jZ/PhkJEBbmNVmshlBbfxR9XQzipqvJ0
         y41HGXWGA8kPO/YbVLaos6AK3sZVNx76GLNBgyoUYK1x5Jm6QiXEgGfa0gBtBENsjV4M
         L4ASKOUym+WNwkRhl/VHdL7SBkKuiEcA/+IYgKP2TlfH5WWolsuMxs2sdajvDtPKkRBU
         gaJPIzGO6HnN3y907fpE5iv8QqP7nlLL44oTnO/u2VEU3J4tAE2AvvoEYBOO73IILST+
         KPog==
X-Gm-Message-State: APjAAAXCItavnOjiL/T8oVbFw6y8CyC2cxnvP77k72tSzIS0cJC2fwLp
        Y2RK4MpXnOldflxMyI4PkRXOxg7ejaYrepN5xWs=
X-Google-Smtp-Source: APXvYqzwcfHQZ8crQnDTdns9c6NCFqKdfteB1QMFAnZ1T+94VjDX6K9uggfMjujVyNMF636S32dNWSXBcR2JxTU6TGs=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr34585403qvv.38.1563471118407;
 Thu, 18 Jul 2019 10:31:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190718173021.2418606-1-andriin@fb.com>
In-Reply-To: <20190718173021.2418606-1-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jul 2019 10:31:47 -0700
Message-ID: <CAEf4BzaOMmVHGMMrKKRHtMDj2r09cQjuCyiSTF3mpjp+R0cvrQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] libbpf: fix missing __WORDSIZE definition
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 10:30 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> hashmap.h depends on __WORDSIZE being defined. It is defined by
> glibc/musl in different headers. It's an explicit goal for musl to be
> "non-detectable" at compilation time, so instead include glibc header if
> glibc is explicitly detected and fall back to musl header otherwise.
>
> Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
> Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Arnaldo,

As it compiled fine for me even before and I don't have a musl set up,
could you please verify this fixes the issue for perf for all your
test environments?

Thanks!

> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/hashmap.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index 03748a742146..bae8879cdf58 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -10,6 +10,11 @@
>
>  #include <stdbool.h>
>  #include <stddef.h>
> +#ifdef __GLIBC__
> +#include <bits/wordsize.h>
> +#else
> +#include <bits/reg.h>
> +#endif
>  #include "libbpf_internal.h"
>
>  static inline size_t hash_bits(size_t h, int bits)
> --
> 2.17.1
>
