Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4EE3C2608
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhGIOhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 10:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhGIOhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 10:37:36 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E3DC0613DD;
        Fri,  9 Jul 2021 07:34:51 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id o5so16581239ejy.7;
        Fri, 09 Jul 2021 07:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Of8sTWUpYkw8uHoUjgY7rFsK+OTOd/MVYUUYb7dwPKE=;
        b=Dam8JlEJ+8i+TF+EyE6l3aDaaPK1jI26C7teqf6yuMEpnVLtpgIebGm/kystU1ncsV
         fsjQMpeJaw/ZCCnP+Gdaadf5k7/jsrk8I55uFgWRdCNEvZW/IpS7n4MwCaZQ2Fd3VIh/
         F993Xg7sUIf8Cd/OWkzyGTY1OuoKGWyNcxHvHbkuCbcNOwTwi5DRHjaA6JS5eQMmWiPT
         Q6UnTdMTKUEwIz37n1jJkglzWaf9VtSn4dt0tXg6lXQdN4+V9CMwpJxvmVmI1BVFusYM
         HS6VovNhI5NrKiQxILIrwpZ+TH6wy+lP/5IOXN/Zlp9WKMPmiIWwxKwE8+ma6iBbMU5S
         b+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Of8sTWUpYkw8uHoUjgY7rFsK+OTOd/MVYUUYb7dwPKE=;
        b=nOzW8hKji/V5lEnWPy3yNXvutXRS1qQx3H2IhLavFl9997+XOWth9W5xrqdeEAEInd
         2Yws32GHQGht6h5ubmhDP6w7QhdQMtj7y4HQKyRSLvTNl/uVlwSLtCtUrfS0vjTXmKed
         73IvlDFHPXgf1GYCEJAPO7/RAG67VTz+bSM/o2Kf9NuvVRjc+I82aTEZhT1r9H4LYgTd
         KyHVqXc6mjs23KcaXjRDo94TekkNpT7eiiEb/5wpmMAo1jeXjOwlQ43Vp6yVPGtzlvNh
         zj2sWyBPwggXJaMWqmIZ8DbYO4dNEOXdlJdaNG3AaA2j1sxAzIxuDHJsRlSKTKQrTXoZ
         rHpg==
X-Gm-Message-State: AOAM532mmoMTIxsj6K9ZvMXU5Pbgg8peiuIegmf9UsgPJPRlF2Jr42ad
        OxWcJTDRuh/wGvVMCdYw7LqTTrN4vhl2imNGpaQ=
X-Google-Smtp-Source: ABdhPJy9wQsDdJWri14ybKCFEQtG704SNOTxAYZDWL4CzaCA/2hswVstfiOlRwp8Sd0k/B8GaWR+EHLNC22/Qzz80PM=
X-Received: by 2002:a17:906:bc84:: with SMTP id lv4mr12289770ejb.493.1625841289853;
 Fri, 09 Jul 2021 07:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
In-Reply-To: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 9 Jul 2021 07:34:38 -0700
Message-ID: <CAKgT0UdQmrzZufHpvRBtWgbFdTCVmKH4Vx6GzwtmC9FuM8K+hg@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 11:30 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> As Alexander points out, when we are trying to recycle a cloned/expanded
> SKB we might trigger a race.  The recycling code relies on the
> pp_recycle bit to trigger,  which we carry over to cloned SKBs.
> If that cloned SKB gets expanded or if we get references to the frags,
> call skbb_release_data() and overwrite skb->head, we are creating separate
> instances accessing the same page frags.  Since the skb_release_data()
> will first try to recycle the frags,  there's a potential race between
> the original and cloned SKB, since both will have the pp_recycle bit set.
>
> Fix this by explicitly those SKBs not recyclable.
> The atomic_sub_return effectively limits us to a single release case,
> and when we are calling skb_release_data we are also releasing the
> option to perform the recycling, or releasing the pages from the page pool.
>
> Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
> Reported-by: Alexander Duyck <alexanderduyck@fb.com>
> Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
> Changes since v1:
> - Set the recycle bit to 0 during skb_release_data instead of the
>   individual fucntions triggering the issue, in order to catch all
>   cases
>  net/core/skbuff.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 12aabcda6db2..f91f09a824be 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -663,7 +663,7 @@ static void skb_release_data(struct sk_buff *skb)
>         if (skb->cloned &&
>             atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
>                               &shinfo->dataref))
> -               return;
> +               goto exit;
>
>         skb_zcopy_clear(skb, true);
>
> @@ -674,6 +674,8 @@ static void skb_release_data(struct sk_buff *skb)
>                 kfree_skb_list(shinfo->frag_list);
>
>         skb_free_head(skb);
> +exit:
> +       skb->pp_recycle = 0;
>  }
>
>  /*
> --
> 2.32.0.rc0
>

This is probably the cleanest approach with the least amount of
change, but one thing I am concerned with in this approach is that we
end up having to dirty a cacheline that I am not sure is otherwise
touched during skb cleanup. I am not sure if that will be an issue or
not. If it is then an alternative or follow-on patch could move the
pp_recycle flag into the skb_shared_info flags itself and then make
certain that we clear it around the same time we are setting
shinfo->dataref to 1.

Otherwise this looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
