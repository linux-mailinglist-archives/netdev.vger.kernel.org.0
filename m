Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E285D3F5AAE
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbhHXJOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhHXJOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 05:14:16 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50D9C061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 02:13:32 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id i8so39645808ybt.7
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 02:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zgWUg1cu9y2wNzJh4uBLrobUt8MwmGlK5zzyl+Ymn0k=;
        b=wAelqMeRa21jd5nmjMo9hwwxRDvt9UIKOVhDEHom+7maZ+SffpJq5CeH6nUFpLZNOp
         rXiAdIDqk1HheALul4vl1yCtv8GDdP8mLei0xNnpHDirbnjQNSjst+sDuom3GjLsESmW
         jREI3xKkAFzwf6cGiwCpSQbwUblllNBmAyN7P1CAS/N272Wxc2izTwqIpbypculHmgkG
         WeW6BYFN0h7fjN9mL4MPA4FvpeTDhHcLK3BmpWSBycxok15ideqDZ7TXCq1gNuNZqME4
         yXKO/f+XxLRbqMRyQssgmph7lPjC7ndOPUgvFy60lmuRoMAIAfbq7cGdVUTMLDfuPE1m
         7U9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zgWUg1cu9y2wNzJh4uBLrobUt8MwmGlK5zzyl+Ymn0k=;
        b=svST9+pJYhW9UkWCTKQsFX+5yh5W2eo1LJSLr4f0RY26jq0qG2DrT8ltW9OlDs1dzo
         VQubT5lmYmul7+zWy9lczwdil1L8K7amODG6egoILE5kdEl54AsuvvikHFS5qOODgWh0
         dKihmwZidzGuDJanPCRIRaklYDkH9x41qXf/u3K3KcQCdiEhBK+8rFGMj7nqc9UL1XN2
         T8mxzXma4Tt9lDf4tDKGoIHI7BB2nTJrA6e9Ym9rurs9MavGjvf9bnxPKYH/LGcF6GdC
         YNNS+G/YzLZpdJbZzI5qK+rF5NdHtztdsq2RoK3pCoOn8hTtVFP1WwmxG8wmotaEeW4J
         0I9Q==
X-Gm-Message-State: AOAM531uSr4owl6NMEM8FfjsgCmONRhesHRSi83b6Z4Ogu/zuXArq4Da
        sqBb6L1OF/kMUq/9wj3gJvdQZsg6Q1qLOYTf+x78hw==
X-Google-Smtp-Source: ABdhPJyJfp5NzkWtY0l7A9iMamwp9I5qxRl6XzHvf63lLqGTmx6J7/yPKuYx9ul+6aoB5WvwkM2uNDRTIwzn+uuWMyM=
X-Received: by 2002:a25:3545:: with SMTP id c66mr49877960yba.317.1629796412021;
 Tue, 24 Aug 2021 02:13:32 -0700 (PDT)
MIME-Version: 1.0
References: <1629796009-11010-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1629796009-11010-1-git-send-email-linyunsheng@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 24 Aug 2021 12:12:53 +0300
Message-ID: <CAC_iWjKUwnQPXDAFu_TCzFk4bF5ohNZemNUf_=94LxetN_9FaQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3] page_pool: use relaxed atomic for release
 side accounting
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 at 12:07, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> There is no need to synchronize the account updating, so
> use the relaxed atomic to avoid some memory barrier in the
> data path.
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V3: Drop patch 2.
> V2: Remove unnecessary unliky() mark as pointed out by
>     Heiner.
> ---
>  net/core/page_pool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e140905..1a69784 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -370,7 +370,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>         /* This may be the last page returned, releasing the pool, so
>          * it is not safe to reference pool afterwards.
>          */
> -       count = atomic_inc_return(&pool->pages_state_release_cnt);
> +       count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
>         trace_page_pool_state_release(pool, page, count);
>  }
>  EXPORT_SYMBOL(page_pool_release_page);
> --
> 2.7.4
>

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
