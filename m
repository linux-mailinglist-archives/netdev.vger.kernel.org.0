Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E084F57FE
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389091AbfKHT6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:58:22 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35263 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388678AbfKHT6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:58:22 -0500
Received: by mail-qk1-f194.google.com with SMTP id i19so6394926qki.2;
        Fri, 08 Nov 2019 11:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hTlRTyoHI4eKNFPGRjD/KRTAiqRzR7mG2qpZvjfy0/8=;
        b=ENnfw3BvNUWSTGKs/RSde99wPAErf3llsr5FLr+7ZweMJ+lFSw7WlVZNxZ/Ikn48U8
         Rv1U+YVEr/t+X6FlNTpQRp71TCP5YfXyp0Rixr9yJNDA3WN2ycqSkfGgI62MBQYur50y
         wezl0uKK09c8gjqxJlN0sOBm/EBNMEm+F4+1xW0Xf2t+fx7QAyEE+kaHc99o+oVwBaX9
         uLaaFFGpxv3kTTXGMWBQsnrDOEhY4TNUMtgsktre7mm3NX/ZwspRqEL8rKi2ykTEX5zW
         Cmgr0IBuw1o8lSUuesPnZYJXgSm39qBQ9EwTR1v8Tb7hExhzS7dTlUugoxGYSkmHnW6R
         J+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hTlRTyoHI4eKNFPGRjD/KRTAiqRzR7mG2qpZvjfy0/8=;
        b=kQevypahm8w2wChpFjBHhENR2H8UVbQkJH5v8nak1gfMMtn/xoNiyMb2o+caBh1v+j
         dXQXBuwVEUaE0W91mFWYqCe4DLU6SD6+dih9sN7k3L+sQkSMsp3hc8opfPsz3FWa71Ir
         ZEhq+CZNbiU6AquPQxhI2rCXKwUaSbYCbwgzFx+FIJT/aL1jJQEms8aubzye+FUUxCgF
         I8lr3GitqXPdUFvp1PW2EvqsjjDNpqjW0/F4uSKf5BkA+wofK5hgkSqX7x5LnJL2HmrY
         HAXT2DqwevS6RMm2vikiLiqKeS0jZz7jfNgqlqEeBVdxhxxDPHRRZlP5+kk6G13jrntj
         EAfQ==
X-Gm-Message-State: APjAAAXDzIIF4AoCZTQ0LlkYJi9KPQczYzFunPNeyE+/4RTB9CvIqLCw
        jGLMDjVXIKe9xgW8z9tjEbbv1lIBmwQkwTMbCLs=
X-Google-Smtp-Source: APXvYqxIDNbYO4jvsAF2rV7XhGrMcq/H7TBAfjlh9gk9hXRZfGEguWIom2llRF4WguVo6JzRcjfQGrrlJngMD4RGHIs=
X-Received: by 2002:a37:9a8a:: with SMTP id c132mr10475631qke.92.1573243100933;
 Fri, 08 Nov 2019 11:58:20 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-14-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-14-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 11:58:09 -0800
Message-ID: <CAEf4BzbTvKqLDhB6ncZWKt=uL-XDT1GGapzhOJE2a-fWsdGa3A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 13/18] bpf: Fix race in btf_resolve_helper_id()
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 10:42 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> btf_resolve_helper_id() caching logic is a bit racy, since under root the
> verifier can verify several programs in parallel. Fix it with READ/WRITE_ONCE.
> Fix the type as well, since error is also recorded.
>
> Fixes: a7658e1a4164 ("bpf: Check types of arguments passed into helpers")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

looks good

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h   |  5 +++--
>  kernel/bpf/btf.c      | 26 +++++++++++++++++++++++++-
>  kernel/bpf/verifier.c |  8 +++-----
>  net/core/filter.c     |  2 +-
>  4 files changed, 32 insertions(+), 9 deletions(-)
>

[...]
