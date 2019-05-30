Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0E62F9FB
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 12:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfE3KKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 06:10:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35082 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfE3KKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 06:10:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so3816326wrv.2
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 03:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=o2QpfPQMBA0NlmW1cg8vMkuuLK6b3wP3G1AkstrHXqE=;
        b=SHdDcBLS6lUrJMIli87o8zVJ2nUZGOWQPwYWXbLRyIu2xPDk0PURYFN1IhpJ4VL+tC
         JdIdqDsZtXbHPFDup84eTaNrj2KyjWmYz3SMJfojgg8MlRpVhFc3CrOvclhO44P4RFXr
         zuyCfBczc4cqi7KKFRe5y3yT1tUNjTTh0v5yyAErz5ke1Niq66e+gcTjcMr2i9nzKpaF
         H2MlCe0KDj79lcZsCp7Bo0u5O9PkiaV0Z4ER0GvuYcjzpx3pfV1Bu8NcSBkjX0XRChA/
         S2h4QpRZvIwq/tWTHk8TUUGMwZqx8f8LzEnQ0aiGcknJXVnms1Yqd7/WO7A+lpeb2g/W
         +uEQ==
X-Gm-Message-State: APjAAAUp18qrxnEhQbIVXprGY9gpIKBwN+qZKePHs7gxdNGmTHSVfudh
        Afsk/8FYQPWuBuiMRbArKvJbdw==
X-Google-Smtp-Source: APXvYqzPc6rzYHF9CIK6oOP3D2N/2nCo5rU52HSjRHlPMrzTx9L+w/50d4fmmcJ6T6j6IcLRi7tD/g==
X-Received: by 2002:adf:c60e:: with SMTP id n14mr1986429wrg.255.1559211039272;
        Thu, 30 May 2019 03:10:39 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id p2sm1613529wmp.40.2019.05.30.03.10.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 03:10:38 -0700 (PDT)
Date:   Thu, 30 May 2019 12:10:36 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/4] vsock/virtio: fix flush of works during the .remove()
Message-ID: <20190530101036.wnjphmajrz6nz6zc@steredhat.homenet.telecomitalia.it>
References: <20190528105623.27983-1-sgarzare@redhat.com>
 <20190528105623.27983-4-sgarzare@redhat.com>
 <9ac9fc4b-5c39-2503-dfbb-660a7bdcfbfd@redhat.com>
 <20190529105832.oz3sagbne5teq3nt@steredhat>
 <8c9998c8-1b9c-aac6-42eb-135fcb966187@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c9998c8-1b9c-aac6-42eb-135fcb966187@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 05:46:18PM +0800, Jason Wang wrote:
> 
> On 2019/5/29 下午6:58, Stefano Garzarella wrote:
> > On Wed, May 29, 2019 at 11:22:40AM +0800, Jason Wang wrote:
> > > On 2019/5/28 下午6:56, Stefano Garzarella wrote:
> > > > We flush all pending works before to call vdev->config->reset(vdev),
> > > > but other works can be queued before the vdev->config->del_vqs(vdev),
> > > > so we add another flush after it, to avoid use after free.
> > > > 
> > > > Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > ---
> > > >    net/vmw_vsock/virtio_transport.c | 23 +++++++++++++++++------
> > > >    1 file changed, 17 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > > index e694df10ab61..ad093ce96693 100644
> > > > --- a/net/vmw_vsock/virtio_transport.c
> > > > +++ b/net/vmw_vsock/virtio_transport.c
> > > > @@ -660,6 +660,15 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> > > >    	return ret;
> > > >    }
> > > > +static void virtio_vsock_flush_works(struct virtio_vsock *vsock)
> > > > +{
> > > > +	flush_work(&vsock->loopback_work);
> > > > +	flush_work(&vsock->rx_work);
> > > > +	flush_work(&vsock->tx_work);
> > > > +	flush_work(&vsock->event_work);
> > > > +	flush_work(&vsock->send_pkt_work);
> > > > +}
> > > > +
> > > >    static void virtio_vsock_remove(struct virtio_device *vdev)
> > > >    {
> > > >    	struct virtio_vsock *vsock = vdev->priv;
> > > > @@ -668,12 +677,6 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> > > >    	mutex_lock(&the_virtio_vsock_mutex);
> > > >    	the_virtio_vsock = NULL;
> > > > -	flush_work(&vsock->loopback_work);
> > > > -	flush_work(&vsock->rx_work);
> > > > -	flush_work(&vsock->tx_work);
> > > > -	flush_work(&vsock->event_work);
> > > > -	flush_work(&vsock->send_pkt_work);
> > > > -
> > > >    	/* Reset all connected sockets when the device disappear */
> > > >    	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
> > > > @@ -690,6 +693,9 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> > > >    	vsock->event_run = false;
> > > >    	mutex_unlock(&vsock->event_lock);
> > > > +	/* Flush all pending works */
> > > > +	virtio_vsock_flush_works(vsock);
> > > > +
> > > >    	/* Flush all device writes and interrupts, device will not use any
> > > >    	 * more buffers.
> > > >    	 */
> > > > @@ -726,6 +732,11 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> > > >    	/* Delete virtqueues and flush outstanding callbacks if any */
> > > >    	vdev->config->del_vqs(vdev);
> > > > +	/* Other works can be queued before 'config->del_vqs()', so we flush
> > > > +	 * all works before to free the vsock object to avoid use after free.
> > > > +	 */
> > > > +	virtio_vsock_flush_works(vsock);
> > > 
> > > Some questions after a quick glance:
> > > 
> > > 1) It looks to me that the work could be queued from the path of
> > > vsock_transport_cancel_pkt() . Is that synchronized here?
> > > 
> > Both virtio_transport_send_pkt() and vsock_transport_cancel_pkt() can
> > queue work from the upper layer (socket).
> > 
> > Setting the_virtio_vsock to NULL, should synchronize, but after a careful look
> > a rare issue could happen:
> > we are setting the_virtio_vsock to NULL at the start of .remove() and we
> > are freeing the object pointed by it at the end of .remove(), so
> > virtio_transport_send_pkt() or vsock_transport_cancel_pkt() may still be
> > running, accessing the object that we are freed.
> 
> 
> Yes, that's my point.
> 
> 
> > 
> > Should I use something like RCU to prevent this issue?
> > 
> >      virtio_transport_send_pkt() and vsock_transport_cancel_pkt()
> >      {
> >          rcu_read_lock();
> >          vsock = rcu_dereference(the_virtio_vsock_mutex);
> 
> 
> RCU is probably a way to go. (Like what vhost_transport_send_pkt() did).
> 

Okay, I'm going this way.

> 
> >          ...
> >          rcu_read_unlock();
> >      }
> > 
> >      virtio_vsock_remove()
> >      {
> >          rcu_assign_pointer(the_virtio_vsock_mutex, NULL);
> >          synchronize_rcu();
> > 
> >          ...
> > 
> >          free(vsock);
> >      }
> > 
> > Could there be a better approach?
> > 
> > 
> > > 2) If we decide to flush after dev_vqs(), is tx_run/rx_run/event_run still
> > > needed? It looks to me we've already done except that we need flush rx_work
> > > in the end since send_pkt_work can requeue rx_work.
> > The main reason of tx_run/rx_run/event_run is to prevent that a worker
> > function is running while we are calling config->reset().
> > 
> > E.g. if an interrupt comes between virtio_vsock_flush_works() and
> > config->reset(), it can queue new works that can access the device while
> > we are in config->reset().
> > 
> > IMHO they are still needed.
> > 
> > What do you think?
> 
> 
> I mean could we simply do flush after reset once and without tx_rx/rx_run
> tricks?
> 
> rest();
> 
> virtio_vsock_flush_work();
> 
> virtio_vsock_free_buf();

My only doubt is:
is it safe to call config->reset() while a worker function could access
the device?

I had this doubt reading the Michael's advice[1] and looking at
virtnet_remove() where there are these lines before the config->reset():

	/* Make sure no work handler is accessing the device. */
	flush_work(&vi->config_work);

Thanks,
Stefano

[1] https://lore.kernel.org/netdev/20190521055650-mutt-send-email-mst@kernel.org
