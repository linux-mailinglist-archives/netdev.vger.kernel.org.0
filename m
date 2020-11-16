Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DE92B3ED8
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgKPIhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 03:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgKPIhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 03:37:17 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C96C0613D1
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 00:37:17 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id w8so4338641ilg.12
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 00:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SQYTN/rZ1aDgUQSp2jlM2eDGpSqvkEfnliWtIDeccMg=;
        b=YK2BePIDJ8dNHlG3OvyUOjJpZeUB18Ep80hyvsTOLNqRu4URyDGI6sugPUfeI+JyWu
         SRwQevK+0Xg0DaYY+oNeKDsffA3BYHFyyDKlmU4CYgAtFvXfFPq5V1+hUS3NFFzAnbSM
         29lrqn7x73zVsvOY9wylEu0hpvKfG7JrROyMfT7rtak80OmZoPPF3XeJgFLzAO/ZNphn
         gIxWXiJxx54o1sUNuttrMr4haR/Aq7OD4ycZXEacrllzgnAxD3kRruC9rszOUzybz/Dx
         LEV6EwKEa0t0JVAjIz5oJT1OGG1zps77FCfwUlcenHe17CmLoA44Za/tBXHQXr3RKpkS
         lpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SQYTN/rZ1aDgUQSp2jlM2eDGpSqvkEfnliWtIDeccMg=;
        b=FDMSmC/alodik0D+oRRCskn6Eq7rgAoGxlXcsa9NduESSAfR3qybMJqiF1evfNzjQd
         6eYWpjLconU684YVYdaST+Ywu8PKObmjhhrwxh6VOSrojth0rSNUTg0mHfzKf9/qc2+m
         rJ0hT00iCvX4By0Os7jknk2A+6ofLnw51UaqCFKWyU0oEhFhAUcW1Bm6bCpMgOd7lGOc
         uzU6bkvvHSEgIJwo1BIk5MBvpme+0zbDXR81TJpH2xYLA/iwfb6nP9dhStyDAc+mJPHq
         LyvSSFxVctemBtyry3XLv9PAhNCIl+JJDaVgC8NffbHQZ6DviegBHP2ZW5Qeh+jFjbdt
         E1zQ==
X-Gm-Message-State: AOAM530t8iAgU9Pm39p5h2oAptKyXPUoIr8+KBtcHpuH3mwCOrBYhUyt
        6l9oZgpusFbJ+pl6FpxalU7YZECkWgmtdJ5eFaCUiw==
X-Google-Smtp-Source: ABdhPJxQaf7gf9ZlS72mk+2AyyCjIGHVF7y9ilDqOLl4ASFEx0jIThn480I3uqEqXlE8tfReApMkYNTtaLl2Vz7jERI=
X-Received: by 2002:a92:6f11:: with SMTP id k17mr7809416ilc.69.1605515836891;
 Mon, 16 Nov 2020 00:37:16 -0800 (PST)
MIME-Version: 1.0
References: <20201115201029.11903-1-dongli.zhang@oracle.com>
In-Reply-To: <20201115201029.11903-1-dongli.zhang@oracle.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Nov 2020 09:37:05 +0100
Message-ID: <CANn89i+TFxPFoajAgUXTYQ2X7j8YPcPK=NY7UOEDWG4BB1sTuA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] page_frag: Recover from memory pressure
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     linux-mm <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        rama.nichanamatlu@oracle.com,
        "venkat x.venkatsubra" <venkat.x.venkatsubra@oracle.com>,
        manjunath.b.patil@oracle.com, joe.jin@oracle.com,
        srinivas.eeda@oracle.com, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 9:16 PM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>
> The ethernet driver may allocate skb (and skb->data) via napi_alloc_skb().
> This ends up to page_frag_alloc() to allocate skb->data from
> page_frag_cache->va.
>
> During the memory pressure, page_frag_cache->va may be allocated as
> pfmemalloc page. As a result, the skb->pfmemalloc is always true as
> skb->data is from page_frag_cache->va. The skb will be dropped if the
> sock (receiver) does not have SOCK_MEMALLOC. This is expected behaviour
> under memory pressure.
...
> References: https://lore.kernel.org/lkml/20201103193239.1807-1-dongli.zhang@oracle.com/
> References: https://lore.kernel.org/linux-mm/20201105042140.5253-1-willy@infradead.org/
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> Cc: Bert Barbe <bert.barbe@oracle.com>
> Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
> Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Cc: SRINIVAS <srinivas.eeda@oracle.com>
> Cc: stable@vger.kernel.org
> Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> Changed since v1:
>   - change author from Matthew to Dongli
>   - Add references to all prior discussions
>   - Add more details to commit message
> Changed since v2:
>   - add unlikely (suggested by Eric Dumazet)
>
>  mm/page_alloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 23f5066bd4a5..91129ce75ed4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5103,6 +5103,11 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>                 if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
>                         goto refill;
>
> +               if (unlikely(nc->pfmemalloc)) {
> +                       free_the_page(page, compound_order(page));
> +                       goto refill;
> +               }
> +

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
