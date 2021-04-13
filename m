Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9734635E8E3
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348624AbhDMWLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:11:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232530AbhDMWLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618351891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FwHJYneX3jqLvQL75mdfgjni6//ZDHqX9VNzr6xXMHI=;
        b=WFMLJh+g5DLsw4Bn26VaWJYGMzGSWWdIKSWHrEpR5TIdUoCj13Npzn3TyCM412foHLSSBY
        LVOVrnZSvqiyBHhDx3usTdykEPRdSrIljkWAg397hXQxw/TVAjzQLex3aHUK4OAI68JYo3
        /BZlNF0fifYYL2KYDE39BoLZ7DR+ytU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-Z_EO-mL5N5SufUyXDjc-VQ-1; Tue, 13 Apr 2021 18:11:30 -0400
X-MC-Unique: Z_EO-mL5N5SufUyXDjc-VQ-1
Received: by mail-wr1-f70.google.com with SMTP id s9-20020a5d51090000b02901028ea30da6so64803wrt.7
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 15:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FwHJYneX3jqLvQL75mdfgjni6//ZDHqX9VNzr6xXMHI=;
        b=KA076feRScZWdB3+wtdVLs9hNUhq8v0ZU/EceTK8BSNdP49j/SpjuX4hh82wXvagY7
         d1qu7tGJ3epvw9DM9RkTH/y9COEsFPE2rCfuo9RFeypiRNYzli8kOAwiZ4BjW8s2By14
         XDFYvKmCunEKO8MVYdHYUtbMb4VNUH6NoqBekybVGfr8yfGOh1elF6iaVrWzu2SciHiB
         SZNpaK+7+UHM1y79NbuO718AGMFXTQ/qEfKsVhcRJcOhiuadFHSSRjSCOXHFSNW8PRtZ
         0G7FmT2BhP0XnVTuu2/4/Vfz41KzNO14W70RuZWU+uYB3Y2EuZTFXT6muRMaY2nnFC1Z
         sV5A==
X-Gm-Message-State: AOAM532hp87W+ZxoB5Y4cxTLNOZuUb2wCl0izxgaBEzm2/6z//vvpHGo
        SJvh3yjYdLJb/oSpr4+l/qpyHZXNthzZYAbHrGRkgZjU065WxKaZJf5SCI4GVIYtBHY/c8jG/ty
        31KO6aUiQyYlWTl0X
X-Received: by 2002:adf:e34f:: with SMTP id n15mr39188353wrj.224.1618351888761;
        Tue, 13 Apr 2021 15:11:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5dnyOsFJS1wT/Ww00ClVTfJyI0R8HAlU1+tiUWsyxyQSYd5Kbxrzx0ZYgAtA0joZ160eBpQ==
X-Received: by 2002:adf:e34f:: with SMTP id n15mr39188335wrj.224.1618351888477;
        Tue, 13 Apr 2021 15:11:28 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id b5sm20635800wri.57.2021.04.13.15.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 15:11:27 -0700 (PDT)
Date:   Tue, 13 Apr 2021 18:11:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v2 1/4] virtio: fix up virtio_disable_cb
Message-ID: <20210413180830-mutt-send-email-mst@kernel.org>
References: <20210413054733.36363-1-mst@redhat.com>
 <20210413054733.36363-2-mst@redhat.com>
 <CA+FuTSe_SjUY4JxR6G9b8a0nx-MfQOkLdHJSzmjpuRG4BvsVPw@mail.gmail.com>
 <20210413153951-mutt-send-email-mst@kernel.org>
 <CA+FuTSd7qagJAN0wpvudvi2Rvxn-SvQaBZ1SU9rwdb1x0j1s3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSd7qagJAN0wpvudvi2Rvxn-SvQaBZ1SU9rwdb1x0j1s3g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 05:44:42PM -0400, Willem de Bruijn wrote:
> On Tue, Apr 13, 2021 at 3:54 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Apr 13, 2021 at 10:01:11AM -0400, Willem de Bruijn wrote:
> > > On Tue, Apr 13, 2021 at 1:47 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > virtio_disable_cb is currently a nop for split ring with event index.
> > > > This is because it used to be always called from a callback when we know
> > > > device won't trigger more events until we update the index.  However,
> > > > now that we run with interrupts enabled a lot we also poll without a
> > > > callback so that is different: disabling callbacks will help reduce the
> > > > number of spurious interrupts.
> > >
> > > The device may poll for transmit completions as a result of an interrupt
> > > from virtnet_poll_tx.
> > >
> > > As well as asynchronously to this transmit interrupt, from start_xmit or
> > > from virtnet_poll_cleantx as a result of a receive interrupt.
> > >
> > > As of napi-tx, transmit interrupts are left enabled to operate in standard
> > > napi mode. While previously they would be left disabled for most of the
> > > time, enabling only when the queue as low on descriptors.
> > >
> > > (in practice, for the at the time common case of split ring with event index,
> > > little changed, as that mode does not actually enable/disable the interrupt,
> > > but looks at the consumer index in the ring to decide whether to interrupt)
> > >
> > > Combined, this may cause the following:
> > >
> > > 1. device sends a packet and fires transmit interrupt
> > > 2. driver cleans interrupts using virtnet_poll_cleantx
> > > 3. driver handles transmit interrupt using vring_interrupt,
> > >     detects that the vring is empty: !more_used(vq),
> > >     and records a spurious interrupt.
> > >
> > > I don't quite follow how suppressing interrupt suppression, i.e.,
> > > skipping disable_cb, helps avoid this.
> > > I'm probably missing something. Is this solving a subtly different
> > > problem from the one as I understand it?
> >
> > I was thinking of this one:
> >
> >  1. device is sending packets
> >  2. driver cleans them at the same time using virtnet_poll_cleantx
> >  3. device fires transmit interrupts
> >  4. driver handles transmit interrupts using vring_interrupt,
> >      detects that the vring is empty: !more_used(vq),
> >      and records spurious interrupts.
> 
> I think that's the same scenario

Not a big difference I agree.

> >
> >
> > but even yours is also fixed I think.
> >
> > The common point is that a single spurious interrupt is not a problem.
> > The problem only exists if there are tons of spurious interrupts with no
> > real ones. For this to trigger, we keep polling the ring and while we do
> > device keeps firing interrupts. So just disable interrupts while we
> > poll.
> 
> But the main change in this patch is to turn some virtqueue_disable_cb
> calls into no-ops.

Well this was not the design. This is the main change:


@@ -739,7 +742,10 @@ static void virtqueue_disable_cb_split(struct virtqueue *_vq)

        if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
                vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
-               if (!vq->event)
+               if (vq->event)
+                       /* TODO: this is a hack. Figure out a cleaner value to write. */
+                       vring_used_event(&vq->split.vring) = 0x0;
+               else
                        vq->split.vring.avail->flags =
                                cpu_to_virtio16(_vq->vdev,
                                                vq->split.avail_flags_shadow);


IIUC previously when event index was enabled (vq->event) virtqueue_disable_cb_split
was a nop. Now it sets index to 0x0 (which is a hack, but good enough
for testing I think).

> I don't understand how that helps reduce spurious
> interrupts, as if anything, it keeps interrupts enabled for longer.
> 
> Another patch in the series disable callbacks* before starting to
> clean the descriptors from the rx interrupt. That I do understand will
> suppress additional tx interrupts that might see no work to be done. I
> just don't entire follow this patch on its own.
> 
> *(I use interrupt and callback as a synonym in this context, correct
> me if I'm glancing over something essential)

It's the same for the pci transport.

-- 
MST

