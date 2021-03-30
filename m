Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A478E34EA94
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhC3Ojy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhC3Ojg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:39:36 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63380C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:39:36 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 8so17621509ybc.13
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E6cHdmveA5GSFmAYgeQp69NxYMoZIzx6KxWNHUpTbx8=;
        b=qrdMUv3xy9qCAP55mumIhQUXRTYy+VBksleQMErdUz2ZAwTJeSGjqr96BIxtbdPuMw
         jlupywENXwU/05e2ZCdoV7YFcK7KcsUPWUXrLnX5PZN/tzidoXkS5mlEf0hQL5fqBx04
         NYhxF9ryxvPiehUe6n5EMrOC05cmcSsZMWlpK1V0imA5UPwUoVekkF9FHkrAhECqNBis
         kZgb9E9SolxEA3qvi/jZQlVP/zvpf78uX/s3uFcIMQ1AWXeX7XbSaFRpoKBXM8a3q9g9
         vX8PSYs+OrxM87aUImBltktx3Z9+RXIyLvGfnOMjn88tpEyWSDINc12cgwPKPJlhFzG8
         qiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E6cHdmveA5GSFmAYgeQp69NxYMoZIzx6KxWNHUpTbx8=;
        b=b0NoiKn7vXv50Khu8li8AXRQV9XKelcc0vzDS7mYwRd+361EM5RltSekL24MxFRFP5
         cqjt7+JPcCECheHzy6hgjZ+tAk7rauXi9NZHmBBsjjwolpwkKpRVvvFz7IUYbkvTWlib
         gA43v1eLeRmfTxtouorXkUCDpjgMhMAIGJdC93o8nxgRBY6Q8ML8ee1r9cGayQxoFxF6
         UuRQHpbi4CUWMXqMD6UpIQM7U3O07pRAtLR/PFwEvgbNWcx5wMDIDOmlNRqB+JevcMez
         1SADl1P7EQYBGtzpQ7ni0scc0lsGoEZDWh1wjFJ5XbrgN7bU6EZg5fQw+FopUeO93FZF
         t8RQ==
X-Gm-Message-State: AOAM533pCRToO8UvYlV5N1C1LCe/xBKFXtUaR5Mju+lkKZ/BsYIWtwOF
        UydPIi4oXoUBz3SO1wR8bjTkofgArNzeheE9SR8gzxxcdKIeSA==
X-Google-Smtp-Source: ABdhPJwnNdkUQI+3oKLRhLltrKELcEFWG6B1ZgBxUOPQI4W74+IJbG0LY7gCg2nywqp0b+M2F8HqhXKwp9yccB2WGtM=
X-Received: by 2002:a25:d687:: with SMTP id n129mr29393329ybg.132.1617115175082;
 Tue, 30 Mar 2021 07:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <880d627b79b24c0f92a47203193ed11f48c3031e.1617113947.git.pabeni@redhat.com>
In-Reply-To: <880d627b79b24c0f92a47203193ed11f48c3031e.1617113947.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Mar 2021 16:39:23 +0200
Message-ID: <CANn89iJQRf5GVhiUp3PA5y9p3_Nqrm8J2CcfxA=0yd9_aB=17w@mail.gmail.com>
Subject: Re: [PATCH net] net: let skb_orphan_partial wake-up waiters.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 4:25 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Currently the mentioned helper can end-up freeing the socket wmem
> without waking-up any processes waiting for more write memory.
>
> If the partially orphaned skb is attached to an UDP (or raw) socket,
> the lack of wake-up can hang the user-space.
>
> Address the issue invoking the write_space callback after
> releasing the memory, if the old skb destructor requires that.
>
> Fixes: f6ba8d33cfbb ("netem: fix skb_orphan_partial()")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/core/sock.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 0ed98f20448a2..7a38332d748e7 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2137,6 +2137,8 @@ void skb_orphan_partial(struct sk_buff *skb)
>
>                 if (refcount_inc_not_zero(&sk->sk_refcnt)) {
>                         WARN_ON(refcount_sub_and_test(skb->truesize, &sk->sk_wmem_alloc));
> +                       if (skb->destructor == sock_wfree)
> +                               sk->sk_write_space(sk);

Interesting.

Why TCP is not a problem here ?

I would rather replace WARN_ON(refcount_sub_and_test(skb->truesize,
&sk->sk_wmem_alloc)) by :
                        skb_orphan(skb);

This will get rid of this suspect WARN_ON() at the same time ?

>                         skb->destructor = sock_efree;
>                 }
>         } else {
> --
> 2.26.2
>
