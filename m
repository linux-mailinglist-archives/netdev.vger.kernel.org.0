Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188A16872F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 12:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbfGOKm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 06:42:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52823 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbfGOKmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 06:42:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so14642787wms.2
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 03:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oyD5SUTkl63HtbjEDszT2KkUVTMpHqfY9Ujle8tjXBw=;
        b=HTiBeHuo3xV1ph86tOMMYUgcDnq/jFpA6nzCNupMrU/hR8DnytMIVy1qAfUiG9OBEM
         +q1/D+jbolCJGkDjBtJb78hnIrT+uXE3x2QVHsiWq2B+KZpVIuS0xdncgyJ86jNK2pVq
         dWGHnUxMhBVfve7GjS9TMwjIMS/y/DoYPz6GNtzHBopPOsV2++fn4LEGzt94bY/RogpW
         l1lA3gxb+wgt/y3T+mOL0gkMiygRUOELIiXPzkBuyttp5a9v/Z/JaW0tUNETCaFtFusO
         PSY37OPeg419pUvqmwzT5sHtYRqFw0p1+Wh9Vqjhew0q7iN88uWCbGLF8KTO5MLuHYa4
         RKSA==
X-Gm-Message-State: APjAAAU4Twqekv49Rz+bVUOPjnvI9NVWUPLbt3k/MzRknTk/QzeJypZm
        pqFOXEUYZGTyYTDOclf7w/byNMC0ug0=
X-Google-Smtp-Source: APXvYqwY6ZbOufj9qXWZ3qtrrCMUfkv2NIKI7eH9a/099xy5vRZPB6+AkmVtqZo8yNXLlrQbnqYjrw==
X-Received: by 2002:a1c:200a:: with SMTP id g10mr22582918wmg.160.1563187343491;
        Mon, 15 Jul 2019 03:42:23 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id c7sm13992464wro.70.2019.07.15.03.42.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 03:42:22 -0700 (PDT)
Date:   Mon, 15 Jul 2019 12:42:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC] virtio-net: share receive_*() and add_recvbuf_*() with
 virtio-vsock
Message-ID: <20190715104220.dy4rty7xzerq2wut@steredhat>
References: <20190710153707.twmzgmwqqw3pstos@steredhat>
 <9574bc38-4c5c-2325-986b-430e4a2b6661@redhat.com>
 <20190711114134.xhmpciyglb2angl6@steredhat>
 <20190711152855-mutt-send-email-mst@kernel.org>
 <20190712100033.xs3xesz2plfwj3ag@steredhat>
 <a514d8a4-3a12-feeb-4467-af7a9fbf5183@redhat.com>
 <20190715074416.a3s2i5ausognotbn@steredhat>
 <880c1ad2-7e02-3d5d-82d7-49076cc8d02b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <880c1ad2-7e02-3d5d-82d7-49076cc8d02b@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 05:16:09PM +0800, Jason Wang wrote:
> 
> > > > > > > >        struct sk_buff *virtskb_receive_small(struct virtskb *vs, ...);
> > > > > > > >        struct sk_buff *virtskb_receive_big(struct virtskb *vs, ...);
> > > > > > > >        struct sk_buff *virtskb_receive_mergeable(struct virtskb *vs, ...);
> > > > > > > > 
> > > > > > > >        int virtskb_add_recvbuf_small(struct virtskb*vs, ...);
> > > > > > > >        int virtskb_add_recvbuf_big(struct virtskb *vs, ...);
> > > > > > > >        int virtskb_add_recvbuf_mergeable(struct virtskb *vs, ...);
> > > > > > > > 
> > > > > > > > For the Guest->Host path it should be easier, so maybe I can add a
> > > > > > > > "virtskb_send(struct virtskb *vs, struct sk_buff *skb)" with a part of the code
> > > > > > > > of xmit_skb().
> > > > > > > I may miss something, but I don't see any thing that prevents us from using
> > > > > > > xmit_skb() directly.
> > > > > > > 
> > > > > > Yes, but my initial idea was to make it more parametric and not related to the
> > > > > > virtio_net_hdr, so the 'hdr_len' could be a parameter and the
> > > > > > 'num_buffers' should be handled by the caller.
> > > > > > 
> > > > > > > > Let me know if you have in mind better names or if I should put these function
> > > > > > > > in another place.
> > > > > > > > 
> > > > > > > > I would like to leave the control part completely separate, so, for example,
> > > > > > > > the two drivers will negotiate the features independently and they will call
> > > > > > > > the right virtskb_receive_*() function based on the negotiation.
> > > > > > > If it's one the issue of negotiation, we can simply change the
> > > > > > > virtnet_probe() to deal with different devices.
> > > > > > > 
> > > > > > > 
> > > > > > > > I already started to work on it, but before to do more steps and send an RFC
> > > > > > > > patch, I would like to hear your opinion.
> > > > > > > > Do you think that makes sense?
> > > > > > > > Do you see any issue or a better solution?
> > > > > > > I still think we need to seek a way of adding some codes on virtio-net.c
> > > > > > > directly if there's no huge different in the processing of TX/RX. That would
> > > > > > > save us a lot time.
> > > > > > After the reading of the buffers from the virtqueue I think the process
> > > > > > is slightly different, because virtio-net will interface with the network
> > > > > > stack, while virtio-vsock will interface with the vsock-core (socket).
> > > > > > So the virtio-vsock implements the following:
> > > > > > - control flow mechanism to avoid to loose packets, informing the peer
> > > > > >     about the amount of memory available in the receive queue using some
> > > > > >     fields in the virtio_vsock_hdr
> > > > > > - de-multiplexing parsing the virtio_vsock_hdr and choosing the right
> > > > > >     socket depending on the port
> > > > > > - socket state handling
> > > 
> > > I think it's just a branch, for ethernet, go for networking stack. otherwise
> > > go for vsock core?
> > > 
> > Yes, that should work.
> > 
> > So, I should refactor the functions that can be called also from the vsock
> > core, in order to remove "struct net_device *dev" parameter.
> > Maybe creating some wrappers for the network stack.
> > 
> > Otherwise I should create a fake net_device for vsock_core.
> > 
> > What do you suggest?
> 
> 
> I'm not quite sure I get the question. Can you just use the one that created
> by virtio_net?

Sure, sorry but I missed that it is allocated in the virtnet_probe()!

Thanks,
Stefano
