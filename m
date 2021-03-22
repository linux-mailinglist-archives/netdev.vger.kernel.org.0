Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED9C345011
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhCVTjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:39:47 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35200 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhCVTjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 15:39:17 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by linux.microsoft.com (Postfix) with ESMTPSA id BABF120B5681;
        Mon, 22 Mar 2021 12:39:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BABF120B5681
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616441956;
        bh=zXWBEachdkTaURsAl/ZePmAtpLfOIIadK6i3iNDA+W0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UB6A5o+pWt4aw+6YdIBgb55kYIOI9yb+IN4NygtGhrCY9Ugs4/7VklwuomKdH+yW7
         f+Od18T9fgOYGKReTtiz4NMQijLb3EnuTFETAKM/YyvZgScmXBwvrbKYG7xvVB/A1J
         LgPzgLgG8OeLMZJVqJCqkH9jKRPQU4YGvfdriU3Y=
Received: by mail-pj1-f49.google.com with SMTP id w8so9023950pjf.4;
        Mon, 22 Mar 2021 12:39:16 -0700 (PDT)
X-Gm-Message-State: AOAM532+G3b4uk0Kohg7IyJua5ztd9Be5Q4EyfJkJ/1EQQ2rvwb7Xa/8
        hfH0AWh6W12SKcywfThzRUoA+Xbi0Esa/Wd+Yx8=
X-Google-Smtp-Source: ABdhPJw2nwkrWZ7NBnuRL84RIzC2U6/525zhEDpkvDyuwg4IjruXgvT0X/SgDRq7ahIh/AC68oDrAhZWv0XiUbGnR8E=
X-Received: by 2002:a17:90a:f190:: with SMTP id bv16mr620021pjb.187.1616441956295;
 Mon, 22 Mar 2021 12:39:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210322170301.26017-1-mcroce@linux.microsoft.com> <20210322170301.26017-4-mcroce@linux.microsoft.com>
In-Reply-To: <20210322170301.26017-4-mcroce@linux.microsoft.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Mon, 22 Mar 2021 20:38:40 +0100
X-Gmail-Original-Message-ID: <CAFnufp0t3EzB=kSbCFax4b=TNbvPp=JS1PaZAzM5F4-RfoCbRQ@mail.gmail.com>
Message-ID: <CAFnufp0t3EzB=kSbCFax4b=TNbvPp=JS1PaZAzM5F4-RfoCbRQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] page_pool: DMA handling and allow to
 recycles frames via SKB
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 6:03 PM Matteo Croce <mcroce@linux.microsoft.com> wrote:
>
> From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>
> During skb_release_data() intercept the packet and if it's a buffer
> coming from our page_pool API recycle it back to the pool for further
> usage.
> To achieve that we introduce a bit in struct sk_buff (pp_recycle:1) and
> store the xdp_mem_info in page->private. The SKB bit is needed since
> page->private is used by skb_copy_ubufs, so we can't rely solely on
> page->private to trigger recycling.
>
> The driver has to take care of the sync operations on it's own
> during the buffer recycling since the buffer is never unmapped.
>
> In order to enable recycling the driver must call skb_mark_for_recycle()
> to store the information we need for recycling in page->private and
> enabling the recycling bit
>
> Storing the information in page->private allows us to recycle both SKBs
> and their fragments
>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---

Hi, the patch title really should be:

page_pool: DMA handling and frame recycling via SKBs

As in the previous RFC.
Sorry,
-- 
per aspera ad upstream
