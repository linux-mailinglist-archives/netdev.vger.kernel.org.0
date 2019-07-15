Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5627E68494
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 09:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfGOHoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 03:44:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43628 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfGOHoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 03:44:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so15886939wru.10
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 00:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=fVzLXZf7lP50zS67MzpIYhStykUqf86iRlmdmfeauOw=;
        b=Eiu9qtfst3TYE5gEwcMFamUWWv+H7Oi9Q98XqoAkfLYISEaiImLeEnZfxcDyDMQuMi
         J6zPMeIwY84O49O11qbDfBt3tyAqKd0jbawKwHZahxAHK7xYUUFSWXvb8ETWBzdqoXji
         3rV7zQ7ygQeo5cSwwiukt2xGT3LzSRozTiL5hxFKjxv2PEIY/K1QCkLnG8ph8P/UUkUB
         uHRRy11M3tMiSxZVx3idPResqGSFK6plAJKHIo/TpJdSLOljnuMrWjM0lEZ2iOS5Sqlc
         NtQZq/yIAN0lClA82IrmG/wuZkCXkcjlgWM94BcKr6GJtJx0/uAjJ/Y3t+4NtFuohC3g
         dVjw==
X-Gm-Message-State: APjAAAXuZyBdmLsipWuYqCncArnSe6BeqNu24YVFFGyoOd1037J28RyG
        bk+u/vRrx7ss4vDvdO+7TByOt6dSkFk=
X-Google-Smtp-Source: APXvYqyobUY0/cMMh71zF+NLI/Ve7zXcF3R3UZ0zGz8VloDsiixKMkQse1dqpRRSYJxyuDpy2tF35Q==
X-Received: by 2002:a5d:5644:: with SMTP id j4mr285593wrw.144.1563176659787;
        Mon, 15 Jul 2019 00:44:19 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id m7sm13100584wrx.65.2019.07.15.00.44.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 00:44:19 -0700 (PDT)
Date:   Mon, 15 Jul 2019 09:44:16 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC] virtio-net: share receive_*() and add_recvbuf_*() with
 virtio-vsock
Message-ID: <20190715074416.a3s2i5ausognotbn@steredhat>
References: <20190710153707.twmzgmwqqw3pstos@steredhat>
 <9574bc38-4c5c-2325-986b-430e4a2b6661@redhat.com>
 <20190711114134.xhmpciyglb2angl6@steredhat>
 <20190711152855-mutt-send-email-mst@kernel.org>
 <20190712100033.xs3xesz2plfwj3ag@steredhat>
 <a514d8a4-3a12-feeb-4467-af7a9fbf5183@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a514d8a4-3a12-feeb-4467-af7a9fbf5183@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 06:14:39PM +0800, Jason Wang wrote:
> 
> On 2019/7/12 下午6:00, Stefano Garzarella wrote:
> > On Thu, Jul 11, 2019 at 03:52:21PM -0400, Michael S. Tsirkin wrote:
> > > On Thu, Jul 11, 2019 at 01:41:34PM +0200, Stefano Garzarella wrote:
> > > > On Thu, Jul 11, 2019 at 03:37:00PM +0800, Jason Wang wrote:
> > > > > On 2019/7/10 下午11:37, Stefano Garzarella wrote:
> > > > > > Hi,
> > > > > > as Jason suggested some months ago, I looked better at the virtio-net driver to
> > > > > > understand if we can reuse some parts also in the virtio-vsock driver, since we
> > > > > > have similar challenges (mergeable buffers, page allocation, small
> > > > > > packets, etc.).
> > > > > > 
> > > > > > Initially, I would add the skbuff in the virtio-vsock in order to re-use
> > > > > > receive_*() functions.
> > > > > 
> > > > > Yes, that will be a good step.
> > > > > 
> > > > Okay, I'll go on this way.
> > > > 
> > > > > > Then I would move receive_[small, big, mergeable]() and
> > > > > > add_recvbuf_[small, big, mergeable]() outside of virtio-net driver, in order to
> > > > > > call them also from virtio-vsock. I need to do some refactoring (e.g. leave the
> > > > > > XDP part on the virtio-net driver), but I think it is feasible.
> > > > > > 
> > > > > > The idea is to create a virtio-skb.[h,c] where put these functions and a new
> > > > > > object where stores some attributes needed (e.g. hdr_len ) and status (e.g.
> > > > > > some fields of struct receive_queue).
> > > > > 
> > > > > My understanding is we could be more ambitious here. Do you see any blocker
> > > > > for reusing virtio-net directly? It's better to reuse not only the functions
> > > > > but also the logic like NAPI to avoid re-inventing something buggy and
> > > > > duplicated.
> > > > > 
> > > > These are my concerns:
> > > > - virtio-vsock is not a "net_device", so a lot of code related to
> > > >    ethtool, net devices (MAC address, MTU, speed, VLAN, XDP, offloading) will be
> > > >    not used by virtio-vsock.
> 
> 
> Linux support device other than ethernet, so it should not be a problem.
> 
> 
> > > > 
> > > > - virtio-vsock has a different header. We can consider it as part of
> > > >    virtio_net payload, but it precludes the compatibility with old hosts. This
> > > >    was one of the major doubts that made me think about using only the
> > > >    send/recv skbuff functions, that it shouldn't break the compatibility.
> 
> 
> We can extend the current vnet header helper for it to work for vsock.

Okay, I'll do it.

> 
> 
> > > > 
> > > > > > This is an idea of virtio-skb.h that
> > > > > > I have in mind:
> > > > > >       struct virtskb;
> > > > > 
> > > > > What fields do you want to store in virtskb? It looks to be exist sk_buff is
> > > > > flexible enough to us?
> > > > My idea is to store queues information, like struct receive_queue or
> > > > struct send_queue, and some device attributes (e.g. hdr_len ).
> 
> 
> If you reuse skb or virtnet_info, there is not necessary.
> 

Okay.

> 
> > > > 
> > > > > 
> > > > > >       struct sk_buff *virtskb_receive_small(struct virtskb *vs, ...);
> > > > > >       struct sk_buff *virtskb_receive_big(struct virtskb *vs, ...);
> > > > > >       struct sk_buff *virtskb_receive_mergeable(struct virtskb *vs, ...);
> > > > > > 
> > > > > >       int virtskb_add_recvbuf_small(struct virtskb*vs, ...);
> > > > > >       int virtskb_add_recvbuf_big(struct virtskb *vs, ...);
> > > > > >       int virtskb_add_recvbuf_mergeable(struct virtskb *vs, ...);
> > > > > > 
> > > > > > For the Guest->Host path it should be easier, so maybe I can add a
> > > > > > "virtskb_send(struct virtskb *vs, struct sk_buff *skb)" with a part of the code
> > > > > > of xmit_skb().
> > > > > 
> > > > > I may miss something, but I don't see any thing that prevents us from using
> > > > > xmit_skb() directly.
> > > > > 
> > > > Yes, but my initial idea was to make it more parametric and not related to the
> > > > virtio_net_hdr, so the 'hdr_len' could be a parameter and the
> > > > 'num_buffers' should be handled by the caller.
> > > > 
> > > > > > Let me know if you have in mind better names or if I should put these function
> > > > > > in another place.
> > > > > > 
> > > > > > I would like to leave the control part completely separate, so, for example,
> > > > > > the two drivers will negotiate the features independently and they will call
> > > > > > the right virtskb_receive_*() function based on the negotiation.
> > > > > 
> > > > > If it's one the issue of negotiation, we can simply change the
> > > > > virtnet_probe() to deal with different devices.
> > > > > 
> > > > > 
> > > > > > I already started to work on it, but before to do more steps and send an RFC
> > > > > > patch, I would like to hear your opinion.
> > > > > > Do you think that makes sense?
> > > > > > Do you see any issue or a better solution?
> > > > > 
> > > > > I still think we need to seek a way of adding some codes on virtio-net.c
> > > > > directly if there's no huge different in the processing of TX/RX. That would
> > > > > save us a lot time.
> > > > After the reading of the buffers from the virtqueue I think the process
> > > > is slightly different, because virtio-net will interface with the network
> > > > stack, while virtio-vsock will interface with the vsock-core (socket).
> > > > So the virtio-vsock implements the following:
> > > > - control flow mechanism to avoid to loose packets, informing the peer
> > > >    about the amount of memory available in the receive queue using some
> > > >    fields in the virtio_vsock_hdr
> > > > - de-multiplexing parsing the virtio_vsock_hdr and choosing the right
> > > >    socket depending on the port
> > > > - socket state handling
> 
> 
> I think it's just a branch, for ethernet, go for networking stack. otherwise
> go for vsock core?
> 

Yes, that should work.

So, I should refactor the functions that can be called also from the vsock
core, in order to remove "struct net_device *dev" parameter.
Maybe creating some wrappers for the network stack.

Otherwise I should create a fake net_device for vsock_core.

What do you suggest?

> 
> > > > 
> > > > We can use the virtio-net as transport, but we should add a lot of
> > > > code to skip "net device" stuff when it is used by the virtio-vsock.
> 
> 
> This could be another choice, but consider it was not transparent to the
> admin and require new features, we may seek a transparent solution here.
> 
> 
> > > > This could break something in virtio-net, for this reason, I thought to reuse
> > > > only the send/recv functions starting from the idea to split the virtio-net
> > > > driver in two parts:
> > > > a. one with all stuff related to the network stack
> > > > b. one with the stuff needed to communicate with the host
> > > > 
> > > > And use skbuff to communicate between parts. In this way, virtio-vsock
> > > > can use only the b part.
> > > > 
> > > > Maybe we can do this split in a better way, but I'm not sure it is
> > > > simple.
> > > > 
> > > > Thanks,
> > > > Stefano
> > > Frankly, skb is a huge structure which adds a lot of
> > > overhead. I am not sure that using it is such a great idea
> > > if building a device that does not have to interface
> > > with the networking stack.
> 
> 
> I believe vsock is mainly used for stream performance not for PPS. So the
> impact should be minimal. We can use other metadata, just need branch in
> recv_xxx().
> 

Yes, I think stream performance is the case.

> 
> > Thanks for the advice!
> > 
> > > So I agree with Jason in theory. To clarify, he is basically saying
> > > current implementation is all wrong, it should be a protocol and we
> > > should teach networking stack that there are reliable net devices that
> > > handle just this protocol. We could add a flag in virtio net that
> > > will say it's such a device.
> > > 
> > > Whether it's doable, I don't know, and it's definitely not simple - in
> > > particular you will have to also re-implement existing devices in these
> > > terms, and not just virtio - vmware vsock too.
> 
> 
> Merging vsock protocol to exist networking stack could be a long term goal,
> I believe for the first phase, we can seek to use virtio-net first.
>

Yes, I agree.

> 
> > > 
> > > If you want to do a POC you can add a new address family,
> > > that's easier.
> > Very interesting!
> > I agree with you. In this way we can completely split the protocol
> > logic, from the device.
> > 
> > As you said, it will not simple to do, but can be an opportunity to learn
> > better the Linux networking stack!
> > I'll try to do a PoC with AF_VSOCK2 that will use the virtio-net.
> 
> 
> I suggest to do this step by step:
> 
> 1) use virtio-net but keep some protocol logic
> 
> 2) separate protocol logic and merge it to exist Linux networking stack

Make sense, thanks for the suggestions, I'll try to do these steps!

Thanks,
Stefano
