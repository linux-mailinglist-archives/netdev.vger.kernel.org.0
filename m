Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DAB2326DB
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgG2Vgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2Vgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:36:37 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 583672082E;
        Wed, 29 Jul 2020 21:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596058596;
        bh=bygAj4IRMJ/H+qqV44HiSS+jQ8yHN707Z52/EZCUesY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lYiSYccCU52pS5ClVwRb1pnRB0Aq34GWggclxt4rcXlOKGKmktoKGdE2nuP7ImHfy
         tLkcGlGzsboPc17Yh+kigSP79/d7CUz1ZiD381OnMyWcw1JNMOD2VAQGieUkeqqQEp
         9MzQ2IJPHo0jpjc5rMKhhiQgcWFAC8dR/writ8hU=
Received: by mail-lj1-f178.google.com with SMTP id 185so16431422ljj.7;
        Wed, 29 Jul 2020 14:36:36 -0700 (PDT)
X-Gm-Message-State: AOAM533VHvopikzuJSs8AU8FqbYp25mZgew1/2KjfBtuf8bvm7nqI26v
        S9oZXLxgJA/6RCwejJcF3r6Lhn7ycrBiWcee4FM=
X-Google-Smtp-Source: ABdhPJySNOAl/9Gvukw4uH/X1mWvKTx3s9TUheBzPpW3tN1gHv1Dg6Zz/62bukIr6uosZ3p0z009C6DhIZDohE2S4OY=
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr220235ljg.10.1596058594692;
 Wed, 29 Jul 2020 14:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
 <159603983037.4454.12599156913109163942.stgit@john-Precision-5820-Tower>
In-Reply-To: <159603983037.4454.12599156913109163942.stgit@john-Precision-5820-Tower>
From:   Song Liu <song@kernel.org>
Date:   Wed, 29 Jul 2020 14:36:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW57u98jjvaFSZ=Suhrq9Zz-khbr4CF26Px4JY3FciiZ5g@mail.gmail.com>
Message-ID: <CAPhsuW57u98jjvaFSZ=Suhrq9Zz-khbr4CF26Px4JY3FciiZ5g@mail.gmail.com>
Subject: Re: [bpf PATCH v2 4/5] bpf, selftests: Add tests for sock_ops load
 with r9, r8.r7 registers
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 9:24 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Loads in sock_ops case when using high registers requires extra logic to
> ensure the correct temporary value is used. We need to ensure the temp
> register does not use either the src_reg or dst_reg. Lets add an asm
> test to force the logic is triggered.
>
> The xlated code is here,
>
>   30: (7b) *(u64 *)(r9 +32) = r7
>   31: (61) r7 = *(u32 *)(r9 +28)
>   32: (15) if r7 == 0x0 goto pc+2
>   33: (79) r7 = *(u64 *)(r9 +0)
>   34: (63) *(u32 *)(r7 +916) = r8
>   35: (79) r7 = *(u64 *)(r9 +32)
>
> Notice r9 and r8 are not used for temp registers and r7 is chosen.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

[...]
