Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D767B35E724
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345589AbhDMTfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:35:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345572AbhDMTfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 15:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618342485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rUMDskTlMoyXG03Qzv2sJykQt3gDWIVCZXpcjseuLJI=;
        b=Uh9y5nWdWe5B8lKArAEWhcIyDYkpV6GR4utlHDQ43rekZOzX1sPb6vxLj9ua8W4fOE9l4u
        OM1IXRAJnKwUvMjJ8BIv1llUb8fVxi1xcvwYgdFZgUwp5QW+MH1sc6gw/l61AC2JlixcOe
        wOK+QRCa8ntKjqHura9Z+4qY3YJ5iUs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-_mT5-1K1OI-N0cDvMkQDpQ-1; Tue, 13 Apr 2021 15:34:44 -0400
X-MC-Unique: _mT5-1K1OI-N0cDvMkQDpQ-1
Received: by mail-wr1-f70.google.com with SMTP id a15so1021974wrf.19
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 12:34:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rUMDskTlMoyXG03Qzv2sJykQt3gDWIVCZXpcjseuLJI=;
        b=TAcPf5KYXmrhGJQo0r+dC7dNitu7/jFuHbmxeIlc3J3HtLELBsdI+BhnBc8OeTAeCA
         Ujz1t7Y/SIEqArFBmM3Un8wZCl/CaBFNpGu3w+T6/wbnLoA1W0C55mC9qYchpJhwy8Ud
         8b2bAbQNBEshO5uhjWAUJWMbbIUiCFJyCNdysAHn/F8FpxOdxLCzI9s+pNGuIQzskXQY
         OGljckYSFTTWOgBD+dQeTkEdN6GqtPzt0LKnkhTXX/oHnjHvNMtVJyx3Bci5JtitcgnP
         eW80uNzJgWn+EAdhVaeQD1ijqAY/czvodA9ujCAOtUAaAn6PnEIj9D+8DLXNZp1kXDL5
         flfQ==
X-Gm-Message-State: AOAM533gTggu0+lUPd3IN2yUjGOgDThSIOyTbRdQbl6sllStSRXCziuU
        oXVy8MBL96gnFkpO6tSgKJ8i9Pl5UPrhhdkD4KHnHrx0HdiwHK1IYXhbqZOF4cmZe0WVu1hgQqT
        8i7TyWehpUQaHTdZD
X-Received: by 2002:a1c:7311:: with SMTP id d17mr1440603wmb.183.1618342482959;
        Tue, 13 Apr 2021 12:34:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZbArAc+T8QG6nMuGSbTU709+g9JEWWp4LeRlXInp+dBjh991nnHPKXLmKpQOGky2lgU6niQ==
X-Received: by 2002:a1c:7311:: with SMTP id d17mr1440589wmb.183.1618342482730;
        Tue, 13 Apr 2021 12:34:42 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id h2sm3431632wmc.24.2021.04.13.12.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 12:34:41 -0700 (PDT)
Date:   Tue, 13 Apr 2021 15:34:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 5/5] virtio-net: keep tx interrupts disabled
 unless kick
Message-ID: <20210413153023-mutt-send-email-mst@kernel.org>
References: <20170424174930.82623-1-willemdebruijn.kernel@gmail.com>
 <20170424174930.82623-6-willemdebruijn.kernel@gmail.com>
 <20210413010354-mutt-send-email-mst@kernel.org>
 <CA+FuTSe_iy=vDze=MSca1iRJX+WR=PjG-HoFZ2GBpFaCxE33Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSe_iy=vDze=MSca1iRJX+WR=PjG-HoFZ2GBpFaCxE33Fg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 10:27:16AM -0400, Willem de Bruijn wrote:
> On Tue, Apr 13, 2021 at 1:06 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Apr 24, 2017 at 01:49:30PM -0400, Willem de Bruijn wrote:
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > Tx napi mode increases the rate of transmit interrupts. Suppress some
> > > by masking interrupts while more packets are expected. The interrupts
> > > will be reenabled before the last packet is sent.
> > >
> > > This optimization reduces the througput drop with tx napi for
> > > unidirectional flows such as UDP_STREAM that do not benefit from
> > > cleaning tx completions in the the receive napi handler.
> > >
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > ---
> > >  drivers/net/virtio_net.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 9dd978f34c1f..003143835766 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1200,6 +1200,9 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >       /* Free up any pending old buffers before queueing new ones. */
> > >       free_old_xmit_skbs(sq);
> > >
> > > +     if (use_napi && kick)
> > > +             virtqueue_enable_cb_delayed(sq->vq);
> > > +
> > >       /* timestamp packet in software */
> > >       skb_tx_timestamp(skb);
> >
> >
> > I have been poking at this code today and I noticed that is
> > actually does enable cb where the commit log says masking interrupts.
> > I think the reason is that with even index previously disable cb
> > actually did nothing while virtqueue_enable_cb_delayed pushed
> > the event index out some more.
> > And this likely explains why it does not work well for packed,
> > where virtqueue_enable_cb_delayed is same as virtqueue_enable_cb.
> >
> > Right? Or did I miss something?
> 
> This was definitely based on the split queue with event index handling.
> 
> When you say does not work well for packed, you mean that with packed
> mode we see the consequences of the race condition when accessing vq
> without holding __netif_tx_lock, in a way that I did not notice with
> split queue with event index, right?

I mean curretly packed does not seem to show same performance gains as
a micro-benchmark. Could be due to enabling interrupts more aggressively
there.

> Thanks for looking into this and proposing fixes for this issue and the
> known other spurious tx interrupt issue.

