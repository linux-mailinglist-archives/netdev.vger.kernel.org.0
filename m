Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A8045D53B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349649AbhKYHRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:17:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353352AbhKYHPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:15:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637824332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nC8TAYilw4eO6qk6TmC4Zgxkm1cFgxZk3ttBumo2rHs=;
        b=S3MGCFb6U4mxvisdvaGyiI9kFg2FK9OSMERFeCbmEwAxR3HdsQ3XLjoeCI8nkwsjyQCWFD
        ZeQIovvyYygUlI0y32fnQLgJTlVYuwXF4HPVz2bsq1F5JCf1o3vmvacpASqfFrkbMl4ids
        yfsKnUhbS0GZyKhQH+uOEFw6qo11r8g=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-oAP9RlgkPD6T-OQclsefiQ-1; Thu, 25 Nov 2021 02:12:11 -0500
X-MC-Unique: oAP9RlgkPD6T-OQclsefiQ-1
Received: by mail-lf1-f72.google.com with SMTP id f15-20020a056512228f00b004037c0ab223so2757166lfu.16
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:12:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nC8TAYilw4eO6qk6TmC4Zgxkm1cFgxZk3ttBumo2rHs=;
        b=7jlXuvpFKoV4xU1OajBzt7WBAKcis2QnYrYM3wL4Ytuikgtt7K1tgzVKjii+mH7Ox5
         HTtB5TnKAc3jDGWsGtOpskqUS52pRthpNZIlnVhxp5z9W02OnkkdOD/aLStYMThMFNih
         9vPmHCvWYV3VUE79pyuGDNmLbz7pQo1P63lZ4SS5+vn2pO1YnmL2CmtdwaScpj4bHdDg
         hsSAPK6FfxHsM3gCCh4TWmEbgWqOXKOKVLEuy1spWjFNFAZkktxl+6S+l0BOgX2CDwwO
         ciYnHQqrrjDXuyJWxEUzrxLG1/EvEaWLZEPS+2KQ574VGKexylwqcIAxS4CllKeMkMZb
         WoTg==
X-Gm-Message-State: AOAM532IULkVJVNegPlpNm2x0kxrWPmL2gr5fQMmBgMyZ3dpdZRusvmf
        ntPcaAq5MxferymcBRi2J4vgb2O9q9T+qdcaLSsKZpwOK5NPUQ0CBhpSOngwAx9tzpbkRKY5Xi4
        IpLyzxPljSncjAHOyWqFh6l6AkvQgwzx+
X-Received: by 2002:a2e:915a:: with SMTP id q26mr22426553ljg.277.1637824329433;
        Wed, 24 Nov 2021 23:12:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxeFz9HHABX6i5h6gRcn7nboD1zkLDLVn4pgHX8pSwTiW54CFKdWcSQ/ukSK+/hSpgPW0KT1r7HGC5agHABEKc=
X-Received: by 2002:a2e:915a:: with SMTP id q26mr22426527ljg.277.1637824329157;
 Wed, 24 Nov 2021 23:12:09 -0800 (PST)
MIME-Version: 1.0
References: <20211125060547.11961-1-jasowang@redhat.com> <20211125015532-mutt-send-email-mst@kernel.org>
In-Reply-To: <20211125015532-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 25 Nov 2021 15:11:58 +0800
Message-ID: <CACGkMEv+hehZazXRG9mavv=KZ76XfCrkeNqB8CPOnkwRF9cdHA@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: enable big mode correctly
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eli Cohen <elic@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 3:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Nov 25, 2021 at 02:05:47PM +0800, Jason Wang wrote:
> > When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
> > large max_mtu. In this case, using small packet mode is not correct
> > since it may breaks the networking when MTU is grater than
> > ETH_DATA_LEN.
> >
> > To have a quick fix, simply enable the big packet mode when
> > VIRTIO_NET_F_MTU is not negotiated.
>
> This will slow down dpdk hosts which disable mergeable buffers
> and send standard MTU sized packets.
>
> > We can do optimization on top.
>
> I don't think it works like this, increasing mtu
> from guest >4k never worked,

Looking at add_recvbuf_small() it's actually GOOD_PACKET_LEN if I was not wrong.

> we can't regress everyone's
> performance with a promise to maybe sometime bring it back.

So consider it never work before I wonder if we can assume a 1500 as
max_mtu value instead of simply using MAX_MTU?

Thanks

>
> > Reported-by: Eli Cohen <elic@nvidia.com>
> > Cc: Eli Cohen <elic@nvidia.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> >
> > ---
> >  drivers/net/virtio_net.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 7c43bfc1ce44..83ae3ef5eb11 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
> >               dev->mtu = mtu;
> >               dev->max_mtu = mtu;
> >
> > -             /* TODO: size buffers correctly in this case. */
> > -             if (dev->mtu > ETH_DATA_LEN)
> > -                     vi->big_packets = true;
> >       }
> >
> > +     /* TODO: size buffers correctly in this case. */
> > +     if (dev->max_mtu > ETH_DATA_LEN)
> > +             vi->big_packets = true;
> > +
> >       if (vi->any_header_sg)
> >               dev->needed_headroom = vi->hdr_len;
> >
> > --
> > 2.25.1
>

