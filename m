Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D50655DC
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 13:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfGKLll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 07:41:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40856 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbfGKLlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 07:41:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so5373293wmj.5
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 04:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ymUIehAhvLYWh4tBvZT988gIZp7NQryn4z3+jx6j/kU=;
        b=si0ooBSxEAYQm7mLbGC+r5c9CiSfnZvdJK2sN2Nv3mQHC1OPciIQSZuJ/UVRZwjtNt
         3oOgjjrqwJvBvQfzlR036p38AYwQr/HtsUcRM/NPc+ZHeN//VKcA2s6RkEGFdMzpGO8i
         Xmn3+ZkiSONf/IRA7RrXCD50teS59zvb+iTpktq0wx4Yi3YUolh3EKqQeGtW/cvx52QG
         EGSiVsKYNm26/aZkNP6s6vXRUR4g7va0SWgTaBqCSDRlZ9pD7ruTqgn1HGWI1bEvx10B
         ZT+A/UwMEVP8c9gN3sppnGOX6o+MVmGZ+mSzg6DFRqCSB2THBWEoRxvPfrnWxThaIS1g
         iQwQ==
X-Gm-Message-State: APjAAAUCZVe8TwNUTlyqpR6ajzAaVJfubUserptnE/mDpPoFlPc3/0JB
        K7cnIOwabkBpIb0jN+MTPmsDZQO507g=
X-Google-Smtp-Source: APXvYqwRR0/7VKLUCV5HmnQ3oF3/2TnLVMCDW4FVoJ7/5sx7SY7FwnHRjcfV5YmEH/+ltoXXWjAEVQ==
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr3880334wmc.128.1562845297577;
        Thu, 11 Jul 2019 04:41:37 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id h8sm5005660wmf.12.2019.07.11.04.41.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 04:41:37 -0700 (PDT)
Date:   Thu, 11 Jul 2019 13:41:34 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC] virtio-net: share receive_*() and add_recvbuf_*() with
 virtio-vsock
Message-ID: <20190711114134.xhmpciyglb2angl6@steredhat>
References: <20190710153707.twmzgmwqqw3pstos@steredhat>
 <9574bc38-4c5c-2325-986b-430e4a2b6661@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9574bc38-4c5c-2325-986b-430e4a2b6661@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 03:37:00PM +0800, Jason Wang wrote:
> 
> On 2019/7/10 下午11:37, Stefano Garzarella wrote:
> > Hi,
> > as Jason suggested some months ago, I looked better at the virtio-net driver to
> > understand if we can reuse some parts also in the virtio-vsock driver, since we
> > have similar challenges (mergeable buffers, page allocation, small
> > packets, etc.).
> > 
> > Initially, I would add the skbuff in the virtio-vsock in order to re-use
> > receive_*() functions.
> 
> 
> Yes, that will be a good step.
> 

Okay, I'll go on this way.

> 
> > Then I would move receive_[small, big, mergeable]() and
> > add_recvbuf_[small, big, mergeable]() outside of virtio-net driver, in order to
> > call them also from virtio-vsock. I need to do some refactoring (e.g. leave the
> > XDP part on the virtio-net driver), but I think it is feasible.
> > 
> > The idea is to create a virtio-skb.[h,c] where put these functions and a new
> > object where stores some attributes needed (e.g. hdr_len ) and status (e.g.
> > some fields of struct receive_queue).
> 
> 
> My understanding is we could be more ambitious here. Do you see any blocker
> for reusing virtio-net directly? It's better to reuse not only the functions
> but also the logic like NAPI to avoid re-inventing something buggy and
> duplicated.
> 

These are my concerns:
- virtio-vsock is not a "net_device", so a lot of code related to
  ethtool, net devices (MAC address, MTU, speed, VLAN, XDP, offloading) will be
  not used by virtio-vsock.

- virtio-vsock has a different header. We can consider it as part of
  virtio_net payload, but it precludes the compatibility with old hosts. This
  was one of the major doubts that made me think about using only the
  send/recv skbuff functions, that it shouldn't break the compatibility.

> 
> > This is an idea of virtio-skb.h that
> > I have in mind:
> >      struct virtskb;
> 
> 
> What fields do you want to store in virtskb? It looks to be exist sk_buff is
> flexible enough to us?

My idea is to store queues information, like struct receive_queue or
struct send_queue, and some device attributes (e.g. hdr_len ).

> 
> 
> > 
> >      struct sk_buff *virtskb_receive_small(struct virtskb *vs, ...);
> >      struct sk_buff *virtskb_receive_big(struct virtskb *vs, ...);
> >      struct sk_buff *virtskb_receive_mergeable(struct virtskb *vs, ...);
> > 
> >      int virtskb_add_recvbuf_small(struct virtskb*vs, ...);
> >      int virtskb_add_recvbuf_big(struct virtskb *vs, ...);
> >      int virtskb_add_recvbuf_mergeable(struct virtskb *vs, ...);
> > 
> > For the Guest->Host path it should be easier, so maybe I can add a
> > "virtskb_send(struct virtskb *vs, struct sk_buff *skb)" with a part of the code
> > of xmit_skb().
> 
> 
> I may miss something, but I don't see any thing that prevents us from using
> xmit_skb() directly.
> 

Yes, but my initial idea was to make it more parametric and not related to the
virtio_net_hdr, so the 'hdr_len' could be a parameter and the
'num_buffers' should be handled by the caller.

> 
> > 
> > Let me know if you have in mind better names or if I should put these function
> > in another place.
> > 
> > I would like to leave the control part completely separate, so, for example,
> > the two drivers will negotiate the features independently and they will call
> > the right virtskb_receive_*() function based on the negotiation.
> 
> 
> If it's one the issue of negotiation, we can simply change the
> virtnet_probe() to deal with different devices.
> 
> 
> > 
> > I already started to work on it, but before to do more steps and send an RFC
> > patch, I would like to hear your opinion.
> > Do you think that makes sense?
> > Do you see any issue or a better solution?
> 
> 
> I still think we need to seek a way of adding some codes on virtio-net.c
> directly if there's no huge different in the processing of TX/RX. That would
> save us a lot time.

After the reading of the buffers from the virtqueue I think the process
is slightly different, because virtio-net will interface with the network
stack, while virtio-vsock will interface with the vsock-core (socket).
So the virtio-vsock implements the following:
- control flow mechanism to avoid to loose packets, informing the peer
  about the amount of memory available in the receive queue using some
  fields in the virtio_vsock_hdr
- de-multiplexing parsing the virtio_vsock_hdr and choosing the right
  socket depending on the port
- socket state handling

We can use the virtio-net as transport, but we should add a lot of
code to skip "net device" stuff when it is used by the virtio-vsock.
This could break something in virtio-net, for this reason, I thought to reuse
only the send/recv functions starting from the idea to split the virtio-net
driver in two parts:
a. one with all stuff related to the network stack
b. one with the stuff needed to communicate with the host

And use skbuff to communicate between parts. In this way, virtio-vsock
can use only the b part.

Maybe we can do this split in a better way, but I'm not sure it is
simple.

Thanks,
Stefano
