Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48493F96D0
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244695AbhH0J0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhH0J0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:26:03 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC714C0613D9
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 02:25:14 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id t19so12430313ejr.8
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 02:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CQZSVnOjQTaOC4XZpSSeU/UltZMxftQtIHXd0FC9LUY=;
        b=Eiyqj+g5ZX6aj2srxpZtcC1FQBOndljXdzjzQhW3jQfg0AKnowg66sDkXhGEBa7ROp
         +53SIt2MmLtIoE8yXSbpYJx4I/VEj5rzSssq48dyRj2K9LTMGIxWpkX+rBd7bgLzzewm
         H7LTLql0SrRgfWYFJmh/kVwAwOxH4PN1xEh8cDnMjmoUUMNdlPpdKQKSpqobDjvAldfC
         cXn76T6Mu1zSuEcmMGjIeXjOf1VizyeMqiQ0WOFK5MjuDVZ5/RoACxnjGi7LF45nwgrQ
         Nfv9gXViN5n0dobPAoA9idt9BLeLe79P5wpff7nWT0kBWd8juzoAhi6J/RJ88ud8v62V
         8eEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CQZSVnOjQTaOC4XZpSSeU/UltZMxftQtIHXd0FC9LUY=;
        b=YD+Pd3Stzo5EjxsxHZIYF11qEJ7RRyWPQcOqD9yqF9KqliKdCyuk3EQhP5gMmTvRu8
         le9Sd9ymKx7UKpvyo+NtpQAR4nr8gjkPC0dl24cFrq9gEvYAM1PazTwsGKfm101haIbG
         S+jFqTysNs1eYlSGV/3zOaxoPmzfMd3VegAHiaIKrc47kH9EXE+n4PQgP5i6oCvxu3fO
         xr6W6r8TXRaTSv9Ub1ONXPlx1D9Kf3OX/tkqmBG8k1phfFuWq1i6DfT+KxuwVrEQ3F4h
         EkJ10jPvWENyKNTj1MVb/wdDhJMiZGs+UQ3X72uZ8vGq8AgoPehS1ObgwjB6nP/SeYKk
         IIsQ==
X-Gm-Message-State: AOAM531jiYB2GrjYYYWbENjn0g+j8zbKV6gv8w8wBdYIn5CEWlwLLlzN
        9Xb/DzWqmnquuMtvOJnvDWGVse1x+bGrQuUYEh7+
X-Google-Smtp-Source: ABdhPJwgcugxvkltcJohlXGHniUZmyhYLawWLaSxMYUiHXpZPra5boRHFyGEQTo7QNVw0MBfE++H/HV9ev3Dyf8sBpg=
X-Received: by 2002:a17:906:659:: with SMTP id t25mr8879799ejb.372.1630056313220;
 Fri, 27 Aug 2021 02:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210818120642.165-1-xieyongji@bytedance.com> <20210818120642.165-11-xieyongji@bytedance.com>
 <2d807de3-e245-c2fb-ae5d-7cacbe35dfcb@huawei.com>
In-Reply-To: <2d807de3-e245-c2fb-ae5d-7cacbe35dfcb@huawei.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 27 Aug 2021 17:25:02 +0800
Message-ID: <CACycT3uRvB2K7LeVpdv+DkGJGjdORMa2uk5T_PYswtddNOjV4A@mail.gmail.com>
Subject: Re: [PATCH v11 10/12] vduse: Implement an MMU-based software IOTLB
To:     John Garry <john.garry@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Robin Murphy <robin.murphy@arm.com>, kvm <kvm@vger.kernel.org>,
        netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        iommu@lists.linux-foundation.org, songmuchun@bytedance.com,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 4:53 PM John Garry <john.garry@huawei.com> wrote:
>
> On 18/08/2021 13:06, Xie Yongji wrote:
> > +
> > +static dma_addr_t
> > +vduse_domain_alloc_iova(struct iova_domain *iovad,
> > +                     unsigned long size, unsigned long limit)
> > +{
> > +     unsigned long shift = iova_shift(iovad);
> > +     unsigned long iova_len = iova_align(iovad, size) >> shift;
> > +     unsigned long iova_pfn;
> > +
> > +     /*
> > +      * Freeing non-power-of-two-sized allocations back into the IOVA caches
> > +      * will come back to bite us badly, so we have to waste a bit of space
> > +      * rounding up anything cacheable to make sure that can't happen. The
> > +      * order of the unadjusted size will still match upon freeing.
> > +      */
> > +     if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
> > +             iova_len = roundup_pow_of_two(iova_len);
>
> Whether it's proper to use this "fast" API or not here, this seems to be
> copied verbatim from dma-iommu.c, which tells me that something should
> be factored out.
>

Agreed.

> Indeed, this rounding up seems a requirement of the rcache, so not sure
> why this is not done there.
>

Me too. I guess it is to let users know that space is wasted.

Thanks,
Yongji
