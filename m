Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1482730E1
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgIUR3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbgIUR3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:29:42 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B97EC061755;
        Mon, 21 Sep 2020 10:29:42 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id v60so10833403ybi.10;
        Mon, 21 Sep 2020 10:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2F1h/EWboNIp8fpoSSezX7MP2/UtK1ptSrD/DJjbvU=;
        b=Mf4MPPUOUNvYq8l/gH/Te+S53Ojx820Ckjo3OMdSQG1WMwEyr2eBYHCgcktxpNsZ/z
         UzVwLNzA9RNjuxHecSZTZLd7VqGyFG6DygSg2+6QZ3yzFHc7/GhDofN54wU4jNdMYpdb
         Q/WUNOCTvAGZ9idlaRTL6Uw+eLQ0rS4efQyIY6TDbtzCk7o19NnyG1Mr70uSi+zs0h/o
         g8obpsnpwloAu8orhfp93qlqXfPSUNqLXHq3MZPJZr/pXqB3v1d9CfIzO8kmVrzjLFu/
         JnziWCt4yqBioR9L6EZ41hFtuUy3nwPJ1yVGq+4Nm9/TUSFfKA1wX50uSAvOzWfrBvk7
         ALtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2F1h/EWboNIp8fpoSSezX7MP2/UtK1ptSrD/DJjbvU=;
        b=iJGIlqn/GFu3RRDy59/gk14CqB7J08sYuK/jmA9dKWCBjDCGpKoCxY4+cCst7a30C9
         vzJwagufUV8rCwyBcEt0ogG/5NSCVbYH76Sm/E8YpK21nqZejH+5HMY6Hh6x0g+biEew
         BSqDDyuK223lJQAZ5ykDxJ3DZqDzwn1wjQzpJkI68hj7RYph2e2IVvaEL0V7S4G19Oz5
         5tAdwpc+/Qz7Hoah7GhaWO7OQUJMS13aTLToDnUujj9U4fLGHbkCkONDCnQed3gA5WFx
         XnMHTGvYJD168TxnSXeGduOCEdB3K1JpVTtjEIF4mEe1DqIzRYLCfL6LoJe4aoiXeWyY
         hbRg==
X-Gm-Message-State: AOAM530BojKAB49a5CZWqGDn09L+90PZDlyMnOQfk6dOsrHUtzobctuo
        jVAxDumJUklHwP75IqxYeEWsHneyl68NOVIP6no=
X-Google-Smtp-Source: ABdhPJwxCOkI7ZoiMGiiUJBkbWO/mO5coExoe/Gg36tUGW2E2LMl8gOWe2LjJwZFGgTyHnUfEKWChHwUXnDywc2pGME=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr1238355ybz.27.1600709381303;
 Mon, 21 Sep 2020 10:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200917074453.20621-1-songmuchun@bytedance.com>
In-Reply-To: <20200917074453.20621-1-songmuchun@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 10:29:30 -0700
Message-ID: <CAEf4Bzad2LDGH_qnE+Qumy=B0N9WXGrwaK5pAdhNm53Q-XzawA@mail.gmail.com>
Subject: Re: [RFC PATCH] bpf: Fix potential call bpf_link_free() in atomic context
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 12:46 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> The in_atomic macro cannot always detect atomic context. In particular,
> it cannot know about held spinlocks in non-preemptible kernels. Although,
> there is no user call bpf_link_put() with holding spinlock now. Be the
> safe side, we can avoid this in the feature.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

This change seems unnecessary (or at least premature), as if we ever
get a use case that does bpf_link_put() from under held spinlock, we
should see a warning about that (and in that case I bet code can be
rewritten to not hold spinlock during bpf_link_put()). But on the
other hand it makes bpf_link_put() to follow the pattern of
bpf_map_put(), which always defers the work, so I'm ok with this. As
Song mentioned, this is not called from a performance-critical hot
path, so doesn't matter all that much.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/syscall.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 178c147350f5..6347be0a5c82 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2345,12 +2345,8 @@ void bpf_link_put(struct bpf_link *link)
>         if (!atomic64_dec_and_test(&link->refcnt))
>                 return;
>
> -       if (in_atomic()) {
> -               INIT_WORK(&link->work, bpf_link_put_deferred);
> -               schedule_work(&link->work);
> -       } else {
> -               bpf_link_free(link);
> -       }
> +       INIT_WORK(&link->work, bpf_link_put_deferred);
> +       schedule_work(&link->work);
>  }
>
>  static int bpf_link_release(struct inode *inode, struct file *filp)
> --
> 2.20.1
>
