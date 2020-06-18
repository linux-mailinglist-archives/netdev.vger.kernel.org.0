Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7B41FFD8E
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731443AbgFRVtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgFRVtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:49:00 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE447C06174E;
        Thu, 18 Jun 2020 14:48:59 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id x18so9121405lji.1;
        Thu, 18 Jun 2020 14:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q3SW089VJRQgJW9cl/e2kwpOjXCjLnxzYVYyNM7K6i8=;
        b=n2qOA+/MUC8heWEYdwM9XoyNyQNGs7lYb5wS/S/AI2Lx3K/J6QaeQ0lGlPtr7jx2q4
         u0M3xJxNsgK/k4GMAaDak5Zifay8CxEY/KtSucgOqetKCzoqDsqIzug0xMiSuXUuqr6P
         g2O9SHbgC9a8DocgLHSe6ZiihxQ++2p0hc1smtchmtS0CswwXpjxm2iZ4+Ol5uvDZdY4
         jgt6Ttt2cZE97tusxQr+l107GMKYtWA+GqrmBYf2DROfpnYbp6sTQ87mEd0mE7oJ8JU3
         TKTapccQc4s42u5ArBhNTSDM6jEqobZ2+cGh2V9r7XV2/dCTs7osz/eGVzTy+miMOWMb
         JpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q3SW089VJRQgJW9cl/e2kwpOjXCjLnxzYVYyNM7K6i8=;
        b=gbntNg9qe9WFGm2MzJCWMpAqC6c92nnoqfBnDe8XyL9oOSM2WqsYc0bi0ASx4Z26iY
         rcDoyKjJWtoLxlZP/qA0WRkpkMtjyCP5k1uOfmmd8t7CFUpTfaMcmDq+x5YfmQLHuau2
         qaNyj716BWeM92otxtwizk51zuqtNh7J6dc3EP4FWDJ+Pd0JHmFleRnoI7niOQ0BlCQx
         m0a1ZUfH03U531B/q3uED4SRqtO1J7ZsyWuIY8kYEP/kA+DJ2DqTQE7gCH6rJnjmI4Dj
         OMR40zJ08nWVFlLSXWLP3nE6WBWxk2O449jgZTVo3Fwy5vb0eOOB8S7gp3VGwNKY8q8w
         t94g==
X-Gm-Message-State: AOAM533piTA2fR0TaYsRdKZSjDqTBm4jeUU7ADdqXnX9bb/1E2nP6/1M
        UHGINBRY/nSmI9jSEDbXmqUKLsDWktf0WBBveCc=
X-Google-Smtp-Source: ABdhPJwDLhJjOmZvAlLjeFBaZznMgbfHXpEz0LjAkaV22GeUBWzaN1Up0oSQbnBc45YrHKuwwtXoiCYed/DjndgEg60=
X-Received: by 2002:a05:651c:1193:: with SMTP id w19mr214793ljo.121.1592516938204;
 Thu, 18 Jun 2020 14:48:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200617174226.2301909-1-kafai@fb.com> <5eeaf50fec904_38b82b28075185c44c@john-XPS-13-9370.notmuch>
In-Reply-To: <5eeaf50fec904_38b82b28075185c44c@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Jun 2020 14:48:46 -0700
Message-ID: <CAADnVQK1zH4sByPUN-+58P4n3XUzdKZJVunu7t5u+07T61gv=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: sk_storage: Prefer to get a free cache_idx
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:01 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Martin KaFai Lau wrote:
> > The cache_idx is currently picked by RR.  There is chance that
> > the same cache_idx will be picked by multiple sk_storage_maps while
> > other cache_idx is still unused.  e.g. It could happen when the
> > sk_storage_map is recreated during the restart of the user
> > space process.
> >
> > This patch tracks the usage count for each cache_idx.  There is
> > 16 of them now (defined in BPF_SK_STORAGE_CACHE_SIZE).
> > It will try to pick the free cache_idx.  If none was found,
> > it would pick one with the minimal usage count.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  net/core/bpf_sk_storage.c | 41 +++++++++++++++++++++++++++++++++++----
> >  1 file changed, 37 insertions(+), 4 deletions(-)
> >
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks
