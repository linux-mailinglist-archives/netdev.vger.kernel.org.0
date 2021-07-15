Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960EC3CA107
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbhGOPBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbhGOPBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:01:04 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D30C06175F;
        Thu, 15 Jul 2021 07:58:09 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id dj21so8651065edb.0;
        Thu, 15 Jul 2021 07:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HS3cF/mabey16un9bdwF6dGa/tupZXRQDRhGTHFs9D8=;
        b=J4Ngz4LQptEgO4mJ348hhHxLas+NpIKAdxj6Z1kLMyX7YXGWN65JfzxRnYgCmezAX0
         Yg6O6FKnaxC0L03uveQyrA7CdGEy0aXZJPrLx9IMaMYuYsQKOaqabjjbrx2pSEEoeWE9
         lww2DzFs2DJwLLcByKR4LK/Dj5X0Pkz0bSCvpp3ObIK27mVtrHVCCr22+9Vkn3mB88cc
         8xum0PaWjELY59WrJ8uvYB9f6+8lXKAQHLh0Zqd2I74/lk0SjheyEZL6D/5dhgdNfYCX
         NSedajshfKJRl17Gn6bbhuEcYnpEqz0pnKl8itx89OwVdcv21Oz3QM9OLhT2QK09xvLc
         r/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HS3cF/mabey16un9bdwF6dGa/tupZXRQDRhGTHFs9D8=;
        b=N0G8gZ5Q/KpFW02bppPSc2vK/ZBKpzUxRiM8xHkEtI9XeJlhPePQh/RgtvYGGYXOIo
         lgfYtZp0FbM2bSCNkUMWv6bkL1qzbALrQIAwGPoTAHp0nX+Iy/CpgZk/w/iq99yHymv6
         OMol4swnrZ0yTbrBj5qIXNQ4LpMdKZ3abBMuE6X+VCDvgZFJDxO7EHiGEBpZaKJ0hw/x
         P2Ln0kIWrGlUWHp1k9zj8iNzwK2N9rVtZ3fCEwsBKww0Lhjsi8ptj21sS06+9z19+/Us
         MKY9iKMUE/ek8q+JutuZvbMYsGUF9qcmUpLgYp0WEmExbN+eDorJ7rRa74omZ3ATJO63
         /EYA==
X-Gm-Message-State: AOAM533efuJeUXxa2Uwl9UVaZ2Z9p0Ls7wVMsqT7cw27HQSJcrhnYo/K
        Aq26QSSh8eB8J7kSX8p5S4sz398w6yjOjga4+Zo=
X-Google-Smtp-Source: ABdhPJws88n/G9mXfk1KS1BFCNmHiJHJHI+NA6KKpmq4Rt6uhFaGR89rMrVRmXm6snHbMIidO298uNjxrM+VM1sZHs4=
X-Received: by 2002:a05:6402:40c4:: with SMTP id z4mr7656556edb.364.1626361088281;
 Thu, 15 Jul 2021 07:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
 <bf326953-495f-db01-e554-42f4421d237a@huawei.com> <CAKgT0UemhFPHo9krmQfm=yNTSjwpBwVkoFtLEEQ-qLVh=-BeHg@mail.gmail.com>
 <YPBKFXWdDytvPmoN@Iliass-MBP>
In-Reply-To: <YPBKFXWdDytvPmoN@Iliass-MBP>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 15 Jul 2021 07:57:57 -0700
Message-ID: <CAKgT0UfOr7U-8T+Hr9NVPL7EMYaTzbx7w1-hUthjD9bXUFsqMw@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Netdev <netdev@vger.kernel.org>,
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

On Thu, Jul 15, 2021 at 7:45 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> > > >           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
>
> [...]
>
> > > >                             &shinfo->dataref))
> > > > -             return;
> > > > +             goto exit;
> > >
> > > Is it possible this patch may break the head frag page for the original skb,
> > > supposing it's head frag page is from the page pool and below change clears
> > > the pp_recycle for original skb, causing a page leaking for the page pool?
> >
> > I don't see how. The assumption here is that when atomic_sub_return
> > gets down to 0 we will still have an skb with skb->pp_recycle set and
> > it will flow down and encounter skb_free_head below. All we are doing
> > is skipping those steps and clearing skb->pp_recycle for all but the
> > last buffer and the last one to free it will trigger the recycling.
>
> I think the assumption here is that
> 1. We clone an skb
> 2. The original skb goes into pskb_expand_head()
> 3. skb_release_data() will be called for the original skb
>
> But with the dataref bumped, we'll skip the recycling for it but we'll also
> skip recycling or unmapping the current head (which is a page_pool mapped
> buffer)

Right, but in that case it is the clone that is left holding the
original head and the skb->pp_recycle flag is set on the clone as it
was copied from the original when we cloned it. What we have
essentially done is transferred the responsibility for freeing it from
the original to the clone.

If you think about it the result is the same as if step 2 was to go
into kfree_skb. We would still be calling skb_release_data and the
dataref would be decremented without the original freeing the page. We
have to wait until all the clones are freed and dataref reaches 0
before the head can be recycled.
