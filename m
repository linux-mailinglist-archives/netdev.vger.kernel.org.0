Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D0949691E
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 02:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiAVBNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 20:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 20:13:40 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF3AC06173B;
        Fri, 21 Jan 2022 17:13:40 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id e16so214872pgn.4;
        Fri, 21 Jan 2022 17:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNgg6eO7ColBOjJRtsN+izURgDgh5DwLKUT8tJKn3F4=;
        b=R6eZjlgADSq02DqjhCypwUKjz3PcPDkXKE0wqhasQKfPcGsv4RKyqhhtRZs212NqCv
         c0dUIqzlNoh7tXPEH4KB8Q0fhvUxvCf+7N8ZZvM7e1kOmIXlZ180NqUazn+nLDWQ3O8S
         Ncj9TyQELzEzlCO9o2sYq3QuonbpxzJXOOzk6wIevna/AG5g+cZH2Tq7fspXfLVPgMW7
         /Veb+7BpLvTstFOEB8xMofx7iydtql2nWm0g/uZy8tSJvIJNZh5Id8HBY10EM5uZAKGp
         tUdvvyUppV7Y+dhSmdQeElaVVwZxLfuwDCEqbq2HCr27MD17H7lvvchcKlZlZbq80dLA
         XBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNgg6eO7ColBOjJRtsN+izURgDgh5DwLKUT8tJKn3F4=;
        b=GwqT4VzPpWrmsdC3x/oEaFJQWsm828kqyoYWJ8ABBCq7sFFERv7MeaHznym8n6ijIv
         2yFG4ArhERdr/3+QPwGXyq8U48jlcHaHRTsZstApNjmWUHuRXE8Wnbe9Pd+yViW0mf6Y
         TGQVIB3TlJEtGka4qFvGZpv3ookGQZN8hidpIrHMGrhEm8tveYcEjOCgC6iw9U0+0nUF
         E4lCfKmBCSjIZrJDPwk3SB4osuKF5PQEb9W5fWZw22F0JAEbcdLSA8qgmugKdFxAupX7
         m45ahaLjAM3C5nUyFRsRIpVXLlfRs2D9whM4nJVxSpqR0Nr8QEA8n0uULG0gtI2mTgkB
         McoQ==
X-Gm-Message-State: AOAM532HrHX9qB3EVsw3S8jM83Pyrr5ZS3CzmbGF3LJGbiRR1Ey5qGmR
        7LTz9nZaD2jOwqlK5nZUpdogmLAcr5vIYmz8iGao81HJ
X-Google-Smtp-Source: ABdhPJziky8PEQUp4JuO3WkgPA9FToi4wq4Yt+sP8aOydJU2MAr68pYX5ZVFCjqaeBfuAEzeLWx5oUtmH9ujaom772A=
X-Received: by 2002:a62:6342:0:b0:4bc:c4f1:2abf with SMTP id
 x63-20020a626342000000b004bcc4f12abfmr5957394pfb.77.1642814019152; Fri, 21
 Jan 2022 17:13:39 -0800 (PST)
MIME-Version: 1.0
References: <20220122005644.802352-1-colin.foster@in-advantage.com> <20220122005644.802352-2-colin.foster@in-advantage.com>
In-Reply-To: <20220122005644.802352-2-colin.foster@in-advantage.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jan 2022 17:13:28 -0800
Message-ID: <CAADnVQK8xrQ92+=wm8AoDkC93SEKz3G=CoOnkPgvs=spJk5UZA@mail.gmail.com>
Subject: Re: [net RFC v1 1/1] page_pool: fix NULL dereference crash
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 4:57 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> Check for the existence of page pool params before dereferencing. This can
> cause crashes in certain conditions.

In what conditions?
Out of tree driver?

> Fixes: 35b2e549894b ("page_pool: Add callback to init pages when they are
> allocated")
>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  net/core/page_pool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index bd62c01a2ec3..641f849c95e7 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -213,7 +213,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>  {
>         page->pp = pool;
>         page->pp_magic |= PP_SIGNATURE;
> -       if (pool->p.init_callback)
> +       if (pool->p && pool->p.init_callback)
>                 pool->p.init_callback(page, pool->p.init_arg);
>  }
>
> --
> 2.25.1
>
