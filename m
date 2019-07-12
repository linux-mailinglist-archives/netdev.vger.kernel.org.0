Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4753466A8D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 12:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfGLKAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 06:00:39 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51928 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfGLKAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 06:00:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so8342077wma.1
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 03:00:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=EqoAJckpOTk8nm2P0izdSKZ2tencgx+ph9N9xk2n8js=;
        b=c40/2phtlJ9ThAdad0hHlCpR1aoUA5iVLRVnKpJCqpiMS7XBWlheIT7urgm3lklzEM
         F1LD1wSMKIG3ZbaCnoceyOhmjuOUdAiv7T0NpG62ytU+d3zJuVNlqI95mHP1V1gBYFcO
         xo2yFYovlXstxjaINaum4R+HUUspWT7HfhZXeZtBp0F6MhL+a6qCNlWLhlQYQQeMtEWL
         Qdszfr0rQ1qRTCQ1U98y5DO/OTEzxCfsXemUubbg+19yjvDaXN6/vmyyuGpzopsWiQVT
         H7S97C1mfdN/qFXzvH13P8N203HnT985Z/exDXkZUmmPuGMGLk5x2EgV7vTr1SLKO62H
         zQwQ==
X-Gm-Message-State: APjAAAVB1EJHTVF1eNZ6B9FDTC6r/BtkJarWzbiGutabZivljFQOWcGd
        I2D2i4rS+rlzcQ+WZ648E/uWiw==
X-Google-Smtp-Source: APXvYqynz1lid0hXOzi9SBvXO3SErW+1wZal7YqeAuXp5WsGgd1VG+tFG2b90W0Fugx2O+3in3820g==
X-Received: by 2002:a1c:1d4f:: with SMTP id d76mr9464126wmd.127.1562925635903;
        Fri, 12 Jul 2019 03:00:35 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id d10sm1887932wrx.34.2019.07.12.03.00.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 03:00:35 -0700 (PDT)
Date:   Fri, 12 Jul 2019 12:00:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC] virtio-net: share receive_*() and add_recvbuf_*() with
 virtio-vsock
Message-ID: <20190712100033.xs3xesz2plfwj3ag@steredhat>
References: <20190710153707.twmzgmwqqw3pstos@steredhat>
 <9574bc38-4c5c-2325-986b-430e4a2b6661@redhat.com>
 <20190711114134.xhmpciyglb2angl6@steredhat>
 <20190711152855-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190711152855-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 03:52:21PM -0400, Michael S. Tsirkin wrote:
> On Thu, Jul 11, 2019 at 01:41:34PM +0200, Stefano Garzarella wrote:
> > On Thu, Jul 11, 2019 at 03:37:00PM +0800, Jason Wang wrote:
> > > 
> > > On 2019/7/10 下午11:37, Stefano Garzarella wrote:
> > > > Hi,
> > > > as Jason suggested some months ago, I looked better at the virtio-net driver to
> > > > understand if we can reuse some parts also in the virtio-vsock driver, since we
> > > > have similar challenges (mergeable buffers, page allocation, small
> > > > packets, etc.).
> > > > 
> > > > Initially, I would add the skbuff in the virtio-vsock in order to re-use
> > > > receive_*() functions.
> > > 
> > > 
> > > Yes, that will be a good step.
> > > 
> > 
> > Okay, I'll go on this way.
> > 
> > > 
> > > > Then I would move receive_[small, big, mergeable]() and
> > > > add_recvbuf_[small, big, mergeable]() outside of virtio-net driver, in order to
> > > > call them also from virtio-vsock. I need to do some refactoring (e.g. leave the
> > > > XDP part on the virtio-net driver), but I think it is feasible.
> > > > 
> > > > The idea is to create a virtio-skb.[h,c] where put these functions and a new
> > > > object where stores some attributes needed (e.g. hdr_len ) and status (e.g.
> > > > some fields of struct receive_queue).
> > > 
> > > 
> > > My understanding is we could be more ambitious here. Do you see any blocker
> > > for reusing virtio-net directly? It's better to reuse not only the functions
> > > but also the logic like NAPI to avoid re-inventing something buggy and
> > > duplicated.
> > > 
> > 
> > These are my concerns:
> > - virtio-vsock is not a "net_device", so a lot of code related to
> >   ethtool, net devices (MAC address, MTU, speed, VLAN, XDP, offloading) will be
> >   not used by virtio-vsock.
> > 
> > - virtio-vsock has a different header. We can consider it as part of
> >   virtio_net payload, but it precludes the compatibility with old hosts. This
> >   was one of the major doubts that made me think about using only the
> >   send/recv skbuff functions, that it shouldn't break the compatibility.
> > 
> > > 
> > > > This is an idea of virtio-skb.h that
> > > > I have in mind:
> > > >      struct virtskb;
> > > 
> > > 
> > > What fields do you want to store in virtskb? It looks to be exist sk_buff is
> > > flexible enough to us?
> > 
> > My idea is to store queues information, like struct receive_queue or
> > struct send_queue, and some device attributes (e.g. hdr_len ).
> > 
> > > 
> > > 
> > > > 
> > > >      struct sk_buff *virtskb_receive_small(struct virtskb *vs, ...);
> > > >      struct sk_buff *virtskb_receive_big(struct virtskb *vs, ...);
> > > >      struct sk_buff *virtskb_receive_mergeable(struct virtskb *vs, ...);
> > > > 
> > > >      int virtskb_add_recvbuf_small(struct virtskb*vs, ...);
> > > >      int virtskb_add_recvbuf_big(struct virtskb *vs, ...);
> > > >      int virtskb_add_recvbuf_mergeable(struct virtskb *vs, ...);
> > > > 
> > > > For the Guest->Host path it should be easier, so maybe I can add a
> > > > "virtskb_send(struct virtskb *vs, struct sk_buff *skb)" with a part of the code
> > > > of xmit_skb().
> > > 
> > > 
> > > I may miss something, but I don't see any thing that prevents us from using
> > > xmit_skb() directly.
> > > 
> > 
> > Yes, but my initial idea was to make it more parametric and not related to the
> > virtio_net_hdr, so the 'hdr_len' could be a parameter and the
> > 'num_buffers' should be handled by the caller.
> > 
> > > 
> > > > 
> > > > Let me know if you have in mind better names or if I should put these function
> > > > in another place.
> > > > 
> > > > I would like to leave the control part completely separate, so, for example,
> > > > the two drivers will negotiate the features independently and they will call
> > > > the right virtskb_receive_*() function based on the negotiation.
> > > 
> > > 
> > > If it's one the issue of negotiation, we can simply change the
> > > virtnet_probe() to deal with different devices.
> > > 
> > > 
> > > > 
> > > > I already started to work on it, but before to do more steps and send an RFC
> > > > patch, I would like to hear your opinion.
> > > > Do you think that makes sense?
> > > > Do you see any issue or a better solution?
> > > 
> > > 
> > > I still think we need to seek a way of adding some codes on virtio-net.c
> > > directly if there's no huge different in the processing of TX/RX. That would
> > > save us a lot time.
> > 
> > After the reading of the buffers from the virtqueue I think the process
> > is slightly different, because virtio-net will interface with the network
> > stack, while virtio-vsock will interface with the vsock-core (socket).
> > So the virtio-vsock implements the following:
> > - control flow mechanism to avoid to loose packets, informing the peer
> >   about the amount of memory available in the receive queue using some
> >   fields in the virtio_vsock_hdr
> > - de-multiplexing parsing the virtio_vsock_hdr and choosing the right
> >   socket depending on the port
> > - socket state handling
> > 
> > We can use the virtio-net as transport, but we should add a lot of
> > code to skip "net device" stuff when it is used by the virtio-vsock.
> > This could break something in virtio-net, for this reason, I thought to reuse
> > only the send/recv functions starting from the idea to split the virtio-net
> > driver in two parts:
> > a. one with all stuff related to the network stack
> > b. one with the stuff needed to communicate with the host
> > 
> > And use skbuff to communicate between parts. In this way, virtio-vsock
> > can use only the b part.
> > 
> > Maybe we can do this split in a better way, but I'm not sure it is
> > simple.
> > 
> > Thanks,
> > Stefano
> 
> Frankly, skb is a huge structure which adds a lot of
> overhead. I am not sure that using it is such a great idea
> if building a device that does not have to interface
> with the networking stack.

Thanks for the advice!

> 
> So I agree with Jason in theory. To clarify, he is basically saying
> current implementation is all wrong, it should be a protocol and we
> should teach networking stack that there are reliable net devices that
> handle just this protocol. We could add a flag in virtio net that
> will say it's such a device.
> 
> Whether it's doable, I don't know, and it's definitely not simple - in
> particular you will have to also re-implement existing devices in these
> terms, and not just virtio - vmware vsock too.
> 
> If you want to do a POC you can add a new address family,
> that's easier.

Very interesting!
I agree with you. In this way we can completely split the protocol
logic, from the device.

As you said, it will not simple to do, but can be an opportunity to learn
better the Linux networking stack!
I'll try to do a PoC with AF_VSOCK2 that will use the virtio-net.

> 
> Just reusing random functions won't help, net stack
> is very heavy, if it manages to outperform vsock it's
> because vsock was not written with performance in mind.
> But the smarts are in the core not virtio driver.
> What makes vsock slow is design decisions like
> using a workqueue to process packets,
> not batching memory management etc etc.
> All things that net core does for virtio net.

Got it :)

Michael, Jason, thank you very much! Your suggestions are very useful!

Stefano
