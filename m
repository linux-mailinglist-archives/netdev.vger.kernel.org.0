Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F81E43D941
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhJ1CSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229788AbhJ1CSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 22:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635387385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zyX1NBb1GFWiobOEsK//3db/aGGpCgwG1Zhr5JwpAoA=;
        b=hIcDVNzRdbqXrFOUYJFYy65zsGBm3Ti4xOtxc5h3tuAFjvFo+00R8613sG0Ns5FN9KmQjz
        Lq/NCdo6a7iH85JibYz1tvyLKMWlhlm4BeRa5cE/Q/su2OI2q74lA9adk8mIpYxNDK74+C
        gS3z0EtqWWTtVGDWy3kahrVlY39MLoU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-wvNYrGI-M2mF1VnqAdDWEw-1; Wed, 27 Oct 2021 22:16:23 -0400
X-MC-Unique: wvNYrGI-M2mF1VnqAdDWEw-1
Received: by mail-lf1-f71.google.com with SMTP id v137-20020a19488f000000b003ffe224c7deso291699lfa.11
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 19:16:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zyX1NBb1GFWiobOEsK//3db/aGGpCgwG1Zhr5JwpAoA=;
        b=cJE3GOIQ5mXHbaf4ha8AhnK8B19NZFrFeKmXiIRVP8UPL4bt6jmz3OoB1K2Nkd00ID
         wETPjNhZbzWLD7DIaIljuF6u9ZfbJ1FmY/tYSj/Np5rcr+nNOOSy9r2d9U1zCIZ1Zvnj
         1hmtRGAu1fEugXZsnLgjwDa4Z5F9wU/7zez6Q1FHxQjkLXnbIagF3x2kybqKFQqo0spG
         VSmdwvlh+OXoVu3OtzWQDwbfPCwoYoTPLn6Nu/qxBDvpDdRetOZK+l+Y2wMPbq2DcPmQ
         dvzr+eYFpav8OVVbh32oW2J7XtkPLppQZBv42WU4S+uZ+7LcYtjvdJve6vxSkvhwccCr
         mZ8g==
X-Gm-Message-State: AOAM533nMkbxlF6OFgNA0ESQXPfbAkFyD3Q6wg9YkM8fjeOphZ4WnJaj
        0H28S6VAS65O/4EVYRb8MZdOS0CHwfZAdzjjypgdhzqfkDvYLzsHVqSNMRNQz4UhVvLZ3dRf9+9
        92FxigDVi0jz0riBUgA+MgrhtZkpv2GUa
X-Received: by 2002:a2e:9155:: with SMTP id q21mr1593751ljg.217.1635387381448;
        Wed, 27 Oct 2021 19:16:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1snIYTirnKARWwiJO7raESyFHFyqNmD63SLBFxBpCK3iJaSWiFVXSRp1q8HHPRpYpIeMj6ciyoG44KjLUbIk=
X-Received: by 2002:a2e:9155:: with SMTP id q21mr1593727ljg.217.1635387381190;
 Wed, 27 Oct 2021 19:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211027061913.76276-1-xuanzhuo@linux.alibaba.com>
 <20211027061913.76276-2-xuanzhuo@linux.alibaba.com> <20211027130429-mutt-send-email-mst@kernel.org>
In-Reply-To: <20211027130429-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 28 Oct 2021 10:16:10 +0800
Message-ID: <CACGkMEssaFCNgmRL4b5P5Dpm3WBhpQX37t-_j9Bc6wndTh4UHw@mail.gmail.com>
Subject: Re: [PATCH 1/3] virtio: cache indirect desc for split
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 1:07 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Oct 27, 2021 at 02:19:11PM +0800, Xuan Zhuo wrote:
> > In the case of using indirect, indirect desc must be allocated and
> > released each time, which increases a lot of cpu overhead.
> >
> > Here, a cache is added for indirect. If the number of indirect desc to be
> > applied for is less than VIRT_QUEUE_CACHE_DESC_NUM, the desc array with
> > the size of VIRT_QUEUE_CACHE_DESC_NUM is fixed and cached for reuse.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/virtio/virtio.c      |  6 ++++
> >  drivers/virtio/virtio_ring.c | 63 ++++++++++++++++++++++++++++++------
> >  include/linux/virtio.h       | 10 ++++++
> >  3 files changed, 70 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > index 0a5b54034d4b..04bcb74e5b9a 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -431,6 +431,12 @@ bool is_virtio_device(struct device *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(is_virtio_device);
> >
> > +void virtio_use_desc_cache(struct virtio_device *dev, bool val)
> > +{
> > +     dev->desc_cache = val;
> > +}
> > +EXPORT_SYMBOL_GPL(virtio_use_desc_cache);
> > +
> >  void unregister_virtio_device(struct virtio_device *dev)
> >  {
> >       int index = dev->index; /* save for after device release */
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index dd95dfd85e98..0b9a8544b0e8 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -117,6 +117,10 @@ struct vring_virtqueue {
> >       /* Hint for event idx: already triggered no need to disable. */
> >       bool event_triggered;
> >
> > +     /* Is indirect cache used? */
> > +     bool use_desc_cache;
> > +     void *desc_cache_chain;
> > +
> >       union {
> >               /* Available for split ring */
> >               struct {
> > @@ -423,12 +427,47 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
> >       return extra[i].next;
> >  }
> >
> > -static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
> > +#define VIRT_QUEUE_CACHE_DESC_NUM 4
> > +
> > +static void desc_cache_chain_free_split(void *chain)
> > +{
> > +     struct vring_desc *desc;
> > +
> > +     while (chain) {
> > +             desc = chain;
> > +             chain = (void *)desc->addr;
> > +             kfree(desc);
> > +     }
> > +}
> > +
> > +static void desc_cache_put_split(struct vring_virtqueue *vq,
> > +                              struct vring_desc *desc, int n)
> > +{
> > +     if (vq->use_desc_cache && n <= VIRT_QUEUE_CACHE_DESC_NUM) {
> > +             desc->addr = (u64)vq->desc_cache_chain;
> > +             vq->desc_cache_chain = desc;
> > +     } else {
> > +             kfree(desc);
> > +     }
> > +}
> > +
>
>
> So I have a question here. What happens if we just do:
>
> if (n <= VIRT_QUEUE_CACHE_DESC_NUM) {
>         return kmem_cache_alloc(VIRT_QUEUE_CACHE_DESC_NUM * sizeof desc, gfp)
> } else {
>         return kmalloc_arrat(n, sizeof desc, gfp)
> }
>
> A small change and won't we reap most performance benefits?

Yes, I think we need a benchmark to use private cache to see how much
it can help.

Thanks

>
> --
> MST
>

