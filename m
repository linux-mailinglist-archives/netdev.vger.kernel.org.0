Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D003E2697B2
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgINV2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:28:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgINV2f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:28:35 -0400
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E55EC20759;
        Mon, 14 Sep 2020 21:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600118915;
        bh=u5Jk5vVHO8+pyIDSaH+QzspSWY9WmRHd+b9OCljc7dI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DvpP69pnhca5aCj+0HojKeLEhE4pQllwXrE7nBfjhqmZB3rHT/FbyGarmtc7ul312
         FjJDL3WJx0ktXeX1KTqnI1QNUk5PmERUJFkiF452Wa/Jzb6pGduxfUyC1up+YgiMAe
         tjjz18LF5bScWQqdE721wT5Gs8jPUBHu3Frpx4Sc=
Received: by mail-lf1-f43.google.com with SMTP id u8so873139lff.1;
        Mon, 14 Sep 2020 14:28:34 -0700 (PDT)
X-Gm-Message-State: AOAM5321csyRBAEvVwJ2YIaadCfjqiIQYORkuj1Cqb/RxrUu8IE0SbFf
        z8oWZSfv4yV6R30DFO8D2jhYE4x8pRwx5NtXIl4=
X-Google-Smtp-Source: ABdhPJxzyOGEMYdgFYaDNaIv2APOCBWZBLAP9fnBU6TeiTz9avUHHp0WR3HatoYxsXM01cW3wFCCGFK+Yonm4KblJWw=
X-Received: by 2002:a19:992:: with SMTP id 140mr4673023lfj.273.1600118913292;
 Mon, 14 Sep 2020 14:28:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200914184630.1048718-1-yhs@fb.com>
In-Reply-To: <20200914184630.1048718-1-yhs@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Sep 2020 14:28:22 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6+kqJ+=+ssxdZ7+ZsCgiUC2rrLPZsWb6YdXEiN7ZhW9Q@mail.gmail.com>
Message-ID: <CAPhsuW6+kqJ+=+ssxdZ7+ZsCgiUC2rrLPZsWb6YdXEiN7ZhW9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: using rcu_read_lock for bpf_sk_storage_map iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:47 AM Yonghong Song <yhs@fb.com> wrote:
>
> Currently, we use bucket_lock when traversing bpf_sk_storage_map
> elements. Since bpf_iter programs cannot use bpf_sk_storage_get()
> and bpf_sk_storage_delete() helpers which may also grab bucket lock,
> we do not have a deadlock issue which exists for hashmap when
> using bucket_lock ([1]).

The paragraph above describes why we can use bucket_lock, which is more
or less irrelevant to this change. Also, I am not sure why we refer to [1] here.

>
> If a bucket contains a lot of sockets, during bpf_iter traversing
> a bucket, concurrent bpf_sk_storage_{get,delete}() may experience
> some undesirable delays. Using rcu_read_lock() is a reasonable

It will be great to include some performance comparison.

> compromise here. Although it may lose some precision, e.g.,
> access stale sockets, but it will not hurt performance of other
> bpf programs.
>
> [1] https://lore.kernel.org/bpf/20200902235341.2001534-1-yhs@fb.com
>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Other than these,

Acked-by: Song Liu <songliubraving@fb.com>

[...]
