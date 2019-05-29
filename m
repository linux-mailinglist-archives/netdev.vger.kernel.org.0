Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED8F2DB43
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfE2K6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:58:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53881 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2K6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:58:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id d17so1348018wmb.3
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 03:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=4gM+INWJgv9FdjldlOiqfPQs/3KoKbaQl3oay9t+Fsc=;
        b=BgC+O3V1CDCLG9eAonc2x3Z0pzthiSs90mJ/qq6CbpX16xCwRLb2GL1CAWLAh2YSbc
         sP5VbYTGIBAl2Rs0tVm88/uFymzBoNl34hew/6CwMLQlov/U0iBZcNQUs0ZopEv1UfnU
         4L9rdL7bvkyhznUXNIswsObQZQlY6UQbOzJpxyCIuKZOUj8G47PFf67/k76T0iFCq4Ae
         UhxBBu6KiyMwzlp0eEa6AwfI7UMqsGIoyjh9w2tuuWoTRShkGHwzamHJ69dEQ3IO8iBF
         vY7Ldvi6B5R+9+PixwqTO8/4kji1o1IA0ULXPE7ahcV9ZYhWB81p6tDCQlUKJUZDLFa4
         bk7A==
X-Gm-Message-State: APjAAAUXcnLrahAIvY1qWUH9jr+5WEVLgH1ceZ6gr+wrAhwxvljSZYXB
        3mft9FmlgzSgr8aLhRsj14hMxQ==
X-Google-Smtp-Source: APXvYqx8DFltvKkXywu9P2M63vLL0b9huUgQDGKM0bNckHf+CE/QRL47FPbLHu0JlvqcBJyV8vRuLQ==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr6597928wme.177.1559127515682;
        Wed, 29 May 2019 03:58:35 -0700 (PDT)
Received: from steredhat (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id j123sm9038134wmb.32.2019.05.29.03.58.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 03:58:34 -0700 (PDT)
Date:   Wed, 29 May 2019 12:58:32 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 3/4] vsock/virtio: fix flush of works during the .remove()
Message-ID: <20190529105832.oz3sagbne5teq3nt@steredhat>
References: <20190528105623.27983-1-sgarzare@redhat.com>
 <20190528105623.27983-4-sgarzare@redhat.com>
 <9ac9fc4b-5c39-2503-dfbb-660a7bdcfbfd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ac9fc4b-5c39-2503-dfbb-660a7bdcfbfd@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 11:22:40AM +0800, Jason Wang wrote:
> 
> On 2019/5/28 下午6:56, Stefano Garzarella wrote:
> > We flush all pending works before to call vdev->config->reset(vdev),
> > but other works can be queued before the vdev->config->del_vqs(vdev),
> > so we add another flush after it, to avoid use after free.
> > 
> > Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >   net/vmw_vsock/virtio_transport.c | 23 +++++++++++++++++------
> >   1 file changed, 17 insertions(+), 6 deletions(-)
> > 
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index e694df10ab61..ad093ce96693 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -660,6 +660,15 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> >   	return ret;
> >   }
> > +static void virtio_vsock_flush_works(struct virtio_vsock *vsock)
> > +{
> > +	flush_work(&vsock->loopback_work);
> > +	flush_work(&vsock->rx_work);
> > +	flush_work(&vsock->tx_work);
> > +	flush_work(&vsock->event_work);
> > +	flush_work(&vsock->send_pkt_work);
> > +}
> > +
> >   static void virtio_vsock_remove(struct virtio_device *vdev)
> >   {
> >   	struct virtio_vsock *vsock = vdev->priv;
> > @@ -668,12 +677,6 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> >   	mutex_lock(&the_virtio_vsock_mutex);
> >   	the_virtio_vsock = NULL;
> > -	flush_work(&vsock->loopback_work);
> > -	flush_work(&vsock->rx_work);
> > -	flush_work(&vsock->tx_work);
> > -	flush_work(&vsock->event_work);
> > -	flush_work(&vsock->send_pkt_work);
> > -
> >   	/* Reset all connected sockets when the device disappear */
> >   	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
> > @@ -690,6 +693,9 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> >   	vsock->event_run = false;
> >   	mutex_unlock(&vsock->event_lock);
> > +	/* Flush all pending works */
> > +	virtio_vsock_flush_works(vsock);
> > +
> >   	/* Flush all device writes and interrupts, device will not use any
> >   	 * more buffers.
> >   	 */
> > @@ -726,6 +732,11 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> >   	/* Delete virtqueues and flush outstanding callbacks if any */
> >   	vdev->config->del_vqs(vdev);
> > +	/* Other works can be queued before 'config->del_vqs()', so we flush
> > +	 * all works before to free the vsock object to avoid use after free.
> > +	 */
> > +	virtio_vsock_flush_works(vsock);
> 
> 
> Some questions after a quick glance:
> 
> 1) It looks to me that the work could be queued from the path of
> vsock_transport_cancel_pkt() . Is that synchronized here?
>

Both virtio_transport_send_pkt() and vsock_transport_cancel_pkt() can
queue work from the upper layer (socket).

Setting the_virtio_vsock to NULL, should synchronize, but after a careful look
a rare issue could happen:
we are setting the_virtio_vsock to NULL at the start of .remove() and we
are freeing the object pointed by it at the end of .remove(), so
virtio_transport_send_pkt() or vsock_transport_cancel_pkt() may still be
running, accessing the object that we are freed.

Should I use something like RCU to prevent this issue?

    virtio_transport_send_pkt() and vsock_transport_cancel_pkt()
    {
        rcu_read_lock();
        vsock = rcu_dereference(the_virtio_vsock_mutex);
        ...
        rcu_read_unlock();
    }

    virtio_vsock_remove()
    {
        rcu_assign_pointer(the_virtio_vsock_mutex, NULL);
        synchronize_rcu();

        ...

        free(vsock);
    }

Could there be a better approach?


> 2) If we decide to flush after dev_vqs(), is tx_run/rx_run/event_run still
> needed? It looks to me we've already done except that we need flush rx_work
> in the end since send_pkt_work can requeue rx_work.

The main reason of tx_run/rx_run/event_run is to prevent that a worker
function is running while we are calling config->reset().

E.g. if an interrupt comes between virtio_vsock_flush_works() and
config->reset(), it can queue new works that can access the device while
we are in config->reset().

IMHO they are still needed.

What do you think?


Thanks for your questions,
Stefano
