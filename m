Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA4B5990BA
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbiHRWuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiHRWuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:50:03 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9968956B7;
        Thu, 18 Aug 2022 15:49:59 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x21so3643705edd.3;
        Thu, 18 Aug 2022 15:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=rNlsaCWVcW80MXzpUrUNFhKEvE2cJ8XPhPWA7oScFPI=;
        b=DZk0NhIGutHPUO2B4xEIhG3JWTiDn/g9IJQRoTawhDK1/alblLFPa696umNPIgsKel
         +FwF8KacumP5wrXSUW5Ju7v+qhtWhCBh/mRM/Va4tDAITDnADixOMSN0K+sFfovL/0PL
         JS+pj6z2sX4FQ5Ye7/NH2ltzO9B6dXElXXxR87eSx3nxlg5ZS8Xc+sE36wFFZTXOAOOR
         rQAGbTwcb4gHYDymzgWL4nyFkZIPB3COoJiBZr7R5yxuFmJzUQhU40/Sc/EMckTqkMlv
         N/ZPaRDySlCHjX3IXmV9GaYjGOjMxB6BMgAdL0hLWgkUn2bxGCPc9KmjSVtLxbL1VTTT
         9FxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=rNlsaCWVcW80MXzpUrUNFhKEvE2cJ8XPhPWA7oScFPI=;
        b=K8zjtM8pRUN2ZlbV1k9fQHL3/l3HIMWiByu0fWynFgvxybzVSAMeI7E9GH3eV2brzN
         CohemztdeG9tEMCULy9gN5pOJ6IGS2MeUpMF0T63dvfGZe8HTi31bbAnQu9OnsWYXxF3
         wahj5mpvufrAgJscn4ds8CcFRPzzSdL6x8nG98DjEbIIS2Ib+sfaSJhO5SfkH7RqDsbc
         1TpC0oHZ1sOsqIJOssPU4OuEfc1y1qWhZBx65pnb5pZCwO1hlW87r/tnn0ARj+3oS2NK
         gb6my2L+2Gt4GAkRfEB0jUV/IwkMTub/Qbh87nESpL8ZYNwfxfxuABOMdITJwAwBDJs9
         SJpQ==
X-Gm-Message-State: ACgBeo3j9Pp9WXwbGRcR15RjEfCRUXpEqC2wQB5aMiiNQULjSSJNr1HK
        SR/7trGhLyqur94Pu18mePIgOlIzI+H5L1wuBkw=
X-Google-Smtp-Source: AA6agR6isVgBYEvS3X6rTm5FLMn3TFrONnRZzvfP5aOxu1SR1SvL4Sm4B9G4mF67Nj9DF8wr/0BY7Ii6e96K80fF0/c=
X-Received: by 2002:aa7:ce0f:0:b0:445:f488:51ca with SMTP id
 d15-20020aa7ce0f000000b00445f48851camr3824300edv.6.1660862998092; Thu, 18 Aug
 2022 15:49:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220818042339.82992-1-kuniyu@amazon.com> <20220818042339.82992-2-kuniyu@amazon.com>
In-Reply-To: <20220818042339.82992-2-kuniyu@amazon.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Aug 2022 15:49:46 -0700
Message-ID: <CAADnVQ+H2n5-Gwgq-OZu-WZKRsg=kq7FtOGXJu6YNHoCEBap6w@mail.gmail.com>
Subject: Re: [PATCH v1 bpf 1/4] bpf: Fix data-races around bpf_jit_enable.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 9:24 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> A sysctl variable bpf_jit_enable is accessed concurrently, and there is
> always a chance of data-race.  So, all readers and a writer need some
> basic protection to avoid load/store-tearing.
>
> Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  arch/arm/net/bpf_jit_32.c        | 2 +-
>  arch/arm64/net/bpf_jit_comp.c    | 2 +-
>  arch/mips/net/bpf_jit_comp.c     | 2 +-
>  arch/powerpc/net/bpf_jit_comp.c  | 5 +++--
>  arch/riscv/net/bpf_jit_core.c    | 2 +-
>  arch/s390/net/bpf_jit_comp.c     | 2 +-
>  arch/sparc/net/bpf_jit_comp_32.c | 5 +++--
>  arch/sparc/net/bpf_jit_comp_64.c | 5 +++--
>  arch/x86/net/bpf_jit_comp.c      | 2 +-
>  arch/x86/net/bpf_jit_comp32.c    | 2 +-
>  include/linux/filter.h           | 2 +-
>  net/core/sysctl_net_core.c       | 4 ++--
>  12 files changed, 19 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> index 6a1c9fca5260..4b6b62a6fdd4 100644
> --- a/arch/arm/net/bpf_jit_32.c
> +++ b/arch/arm/net/bpf_jit_32.c
> @@ -1999,7 +1999,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>         }
>         flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
>
> -       if (bpf_jit_enable > 1)
> +       if (READ_ONCE(bpf_jit_enable) > 1)

Nack.
Even if the compiler decides to use single byte loads for some
odd reason there is no issue here.
