Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81958570726
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 17:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiGKPel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 11:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiGKPek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 11:34:40 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C583E768;
        Mon, 11 Jul 2022 08:34:39 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bk26so7489853wrb.11;
        Mon, 11 Jul 2022 08:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LLprjPtcQ5OaxbKSQkYbSQBstfe7hI1X1CVRdWTn7lM=;
        b=cdK23pl6KgNzy76HvNrQaiqkiECrGHxtSAmq/ADaZBjp0DracO+r5MJsbXarut4sht
         SHmJJjZQoxXhf1G4EvOUkSSdwtrR8XOv7zuXG0SWiLWJHdbWxlhHk0Mtp4xB/ocRn6pa
         bhjnGqHED0Db4Tr/uisFM6vhQLEvcVMZ6W8YT5bAXs/7kD8bUCpCF8TWcnHXnZOLc8K1
         AedyxkqgHNm6pRhIbpZW8CFNBCUo/GlrB9zWiQrqI7YTiJHRR+v7b6erxkqCpuzbmNI6
         QDY4mNC119cjhh6NL9wwBc4/67oStzKLZmmPhbE3/xg0X66zHyvhBrnjPp3xTq4kO54V
         u62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LLprjPtcQ5OaxbKSQkYbSQBstfe7hI1X1CVRdWTn7lM=;
        b=S5ots4GfWRQNAYTtKr7DsZBwMJ6pvlcVr+jXnlxeYM3f04fdKQ2a2wQd6/U6Z/RRIu
         UvDwqIC9d0l8AnuycUi/P8Uf8ok1VqdOfWiAo/wXr4jwmmykebm97xPjGohPv2d/vGbm
         Wmtisn4HaNRi9MHJfUOz+ikdhd6z4KCnSPniavkDVYq32wIhPMDOVPRGph8FO5WnB+YO
         QvBUsXrb8BxwKaNBRyq+vlQ8qlmnxAb8iJW2uEU2PDuuN7hPNoAGQRt1KxFW7VVF0FKn
         N0QnU7dTIFNCflmxNV5arfS2enxXKHR6fkagBt0vPAwL1/uf9VsPkEJFl6fQtJaeR4UC
         UwGg==
X-Gm-Message-State: AJIora+L09f0HlHo3ySIrg/53c04JFWZpZosVyTZbceZg/fe3889j0dv
        31fT7NuzL6OZUXmfu3U2wXOsjtv5HLGzsyduqpY=
X-Google-Smtp-Source: AGRyM1scU6NQgsUnPUl6eDjF1ng/eOFwcnayrhN43P5Z6Vwwhroymkpku+EBG1WqQ+/nW4sKbfPXEedHQOinRGfaclU=
X-Received: by 2002:adf:f90c:0:b0:21a:3dcb:d106 with SMTP id
 b12-20020adff90c000000b0021a3dcbd106mr17203559wrr.448.1657553677725; Mon, 11
 Jul 2022 08:34:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220711075225.15687-1-mlombard@redhat.com>
In-Reply-To: <20220711075225.15687-1-mlombard@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 11 Jul 2022 08:34:26 -0700
Message-ID: <CAKgT0UedQL-Yeum8m=j6oX5s2SjzjtwcwFXBZQde+FzmkmL5bQ@mail.gmail.com>
Subject: Re: [PATCH] mm: prevent page_frag_alloc() from corrupting the memory
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Chen Lin <chen45464546@163.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 12:52 AM Maurizio Lombardi <mlombard@redhat.com> wrote:
>
> A number of drivers call page_frag_alloc() with a
> fragment's size > PAGE_SIZE.
> In low memory conditions, __page_frag_cache_refill() may fail the order 3
> cache allocation and fall back to order 0;
> If this happens, the cache will be smaller than the fragment, causing
> memory corruptions.
>
> Prevent this from happening by checking if the newly allocated cache
> is large enough for the fragment; if not, the allocation will fail
> and page_frag_alloc() will return NULL.
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  mm/page_alloc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e008a3df0485..7fb000d7e90c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5611,12 +5611,17 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
>                 /* if size can vary use size else just use PAGE_SIZE */
>                 size = nc->size;
>  #endif
> -               /* OK, page count is 0, we can safely set it */
> -               set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
> -
>                 /* reset page count bias and offset to start of new frag */
>                 nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
>                 offset = size - fragsz;
> +               if (unlikely(offset < 0)) {
> +                       free_the_page(page, compound_order(page));
> +                       nc->va = NULL;
> +                       return NULL;
> +               }
> +
> +               /* OK, page count is 0, we can safely set it */
> +               set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
>         }
>
>         nc->pagecnt_bias--;

Rather than forcing us to free the page it might be better to move the
lines getting the size and computing the offset to the top of the "if
(unlikely(offset < 0)) {" block. Then instead of freeing the page we
could just return NULL and don't have to change the value of any
fields in the page_frag_cache.

That way a driver performing bad requests can't force us to start
allocating and freeing pages like mad by repeatedly flushing the
cache.
