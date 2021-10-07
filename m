Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48839425F87
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbhJGVuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234061AbhJGVuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 17:50:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 536B9610C8;
        Thu,  7 Oct 2021 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633643293;
        bh=ftvGbHTi5x6A31DLYtQHZgcTCDTwim8P4UGb5oPHJ5Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=P1TcGfi5Y1RLufigdWLf9nnuPAwL5vEHbRoML+RZDhXW6whXpXQUpbiiQGlDeP527
         XxjDd0cb6CmYMrHg5hmxTM3yXIGY3NbHhCe+CdmhRNFyphlRtcxSAgrhlxw4jJURaz
         7wqFcVDefndyLyqha56p5ogDhW8NuNbc6na4DMeAQFvM9iYL4d02Q4dGnAPFm+jNm6
         FXXeRLNnCfXOjaSHuzb2jv8iZHkPw3Hi9O+G6TlFIriY7kfessXRgLZd6ihj8nif8V
         /DIMq1MjdzUKqaXBtKRUCr0cr4mBh/AqJGoSkwSXDXo9yos3s8G6t4BUArWhu+Ct4Q
         D2mcWTMsGACQA==
Received: by mail-lf1-f48.google.com with SMTP id t9so29700695lfd.1;
        Thu, 07 Oct 2021 14:48:13 -0700 (PDT)
X-Gm-Message-State: AOAM5311be0z/BPB2e4kCx7H7/sb7P0zfacHuZcV6NIcFHoA2wh6wDPS
        gsL7KNllUMU3a40lab5ekuA1NOqnoKtq2L+YilU=
X-Google-Smtp-Source: ABdhPJwRRue+SqFEavEBWEKdEqAvQQZ11cA10n+YARdGJnRqSlL+Vgd09T+ezj8q29hy526D9DT3W/tGiL+LELbf8PI=
X-Received: by 2002:a05:6512:3d88:: with SMTP id k8mr2779020lfv.114.1633643291383;
 Thu, 07 Oct 2021 14:48:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-6-memxor@gmail.com>
 <87zgrmfy0z.fsf@cloudflare.com>
In-Reply-To: <87zgrmfy0z.fsf@cloudflare.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Oct 2021 14:48:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4c-Ps0YwFBnm2FuxEgM13vBbe+m=fFHA6JQMSe8ubC9g@mail.gmail.com>
Message-ID: <CAPhsuW4c-Ps0YwFBnm2FuxEgM13vBbe+m=fFHA6JQMSe8ubC9g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 5/6] bpf: selftests: Fix fd cleanup in
 sk_lookup test
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 11:50 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Oct 06, 2021 at 02:28 AM CEST, Kumar Kartikeya Dwivedi wrote:
> > Similar to the fix in commit:
> > e31eec77e4ab (bpf: selftests: Fix fd cleanup in get_branch_snapshot)
> >
> > We use memset to set fds to -1 without breaking on future changes to
> > the array size (when MAX_SERVER constant is bumped).
> >
> > The particular close(0) occurs on non-reuseport tests, so it can be seen
> > with -n 115/{2,3} but not 115/4. This can cause problems with future
> > tests if they depend on BTF fd never being acquired as fd 0, breaking
> > internal libbpf assumptions.
> >
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Fixes: 0ab5539f8584 (selftests/bpf: Tests for BPF_SK_LOOKUP attach point)

Similar to Andrii's comment in 6/6, we need add " to the Fixes tag.

> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

>
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
