Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDCA95F565
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 11:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfGDJUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 05:20:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40539 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbfGDJUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 05:20:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so5790314wre.7
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 02:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=f1r99RR7Q+xI/HzT6VXzcxAxrKbEaF2CKUPs7/mZplQ=;
        b=gtKacPTF6EUbHYvSQltcVKJQ+Et08IHVoL0DzcOC00/w9GdkXwJM76qdrwwpQaxuD/
         yQ9X2z89PBOsocxjoaJ0KZmLy2vbFUUMpHsAJeoOBgvvehZoHjNL/BX70uii6kdovIr8
         dw3FFTCT3jkBLWzm81CgTHvrWQQN2Do3PUcCuv1K8XxMWeU2H2BhKvjOk0XjLhuBlNS0
         16DvUWqEMInG9/a2snLv/msZw2bsD9nmPacj4Kc13aLlb3KrPTTXyRVuNlBw329PGcCF
         2CjA5RHiJd3J9tDi3LxNelbMr/7a65zHKAKrKpk2AiMkOCtFFak0ppOIH9rXHuwezS5S
         nhIQ==
X-Gm-Message-State: APjAAAVEubazjDgvJunIq+kyspGxPTR7WmEIu1R+GzVhH1KigiEBOGWM
        QVd4PYadh7iQMVO4kmK7zH8a/g==
X-Google-Smtp-Source: APXvYqzoACtOvMPdg2pePxgdM0+1il13ShO5vkXimvj9VVxQkaROxCTCtnUfc8x4OnP7UGJOttUN6w==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr33084792wre.205.1562232047694;
        Thu, 04 Jul 2019 02:20:47 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host21-207-dynamic.52-79-r.retail.telecomitalia.it. [79.52.207.21])
        by smtp.gmail.com with ESMTPSA id z25sm4919093wmf.38.2019.07.04.02.20.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 02:20:47 -0700 (PDT)
Date:   Thu, 4 Jul 2019 11:20:44 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] vsock/virtio: use RCU to avoid use-after-free on
 the_virtio_vsock
Message-ID: <20190704092044.23gd5o2rhqarisgg@steredhat.homenet.telecomitalia.it>
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190628123659.139576-2-sgarzare@redhat.com>
 <05311244-ed23-d061-a620-7b83d83c11f5@redhat.com>
 <20190703104135.wg34dobv64k7u4jo@steredhat>
 <07e5bc00-ebde-4dac-d38c-f008fa230b5f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07e5bc00-ebde-4dac-d38c-f008fa230b5f@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 11:58:00AM +0800, Jason Wang wrote:
> 
> On 2019/7/3 下午6:41, Stefano Garzarella wrote:
> > On Wed, Jul 03, 2019 at 05:53:58PM +0800, Jason Wang wrote:
> > > On 2019/6/28 下午8:36, Stefano Garzarella wrote:
> > > > Some callbacks used by the upper layers can run while we are in the
> > > > .remove(). A potential use-after-free can happen, because we free
> > > > the_virtio_vsock without knowing if the callbacks are over or not.
> > > > 
> > > > To solve this issue we move the assignment of the_virtio_vsock at the
> > > > end of .probe(), when we finished all the initialization, and at the
> > > > beginning of .remove(), before to release resources.
> > > > For the same reason, we do the same also for the vdev->priv.
> > > > 
> > > > We use RCU to be sure that all callbacks that use the_virtio_vsock
> > > > ended before freeing it. This is not required for callbacks that
> > > > use vdev->priv, because after the vdev->config->del_vqs() we are sure
> > > > that they are ended and will no longer be invoked.
> > > > 
> > > > We also take the mutex during the .remove() to avoid that .probe() can
> > > > run while we are resetting the device.
> > > > 
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > ---
> > > >    net/vmw_vsock/virtio_transport.c | 67 +++++++++++++++++++++-----------
> > > >    1 file changed, 44 insertions(+), 23 deletions(-)
> > > > 
> > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > > index 9c287e3e393c..7ad510ec12e0 100644
> > > > --- a/net/vmw_vsock/virtio_transport.c
> > > > +++ b/net/vmw_vsock/virtio_transport.c
> > > > @@ -65,19 +65,22 @@ struct virtio_vsock {
> > > >    	u32 guest_cid;
> > > >    };
> > > > -static struct virtio_vsock *virtio_vsock_get(void)
> > > > -{
> > > > -	return the_virtio_vsock;
> > > > -}
> > > > -
> > > >    static u32 virtio_transport_get_local_cid(void)
> > > >    {
> > > > -	struct virtio_vsock *vsock = virtio_vsock_get();
> > > > +	struct virtio_vsock *vsock;
> > > > +	u32 ret;
> > > > -	if (!vsock)
> > > > -		return VMADDR_CID_ANY;
> > > > +	rcu_read_lock();
> > > > +	vsock = rcu_dereference(the_virtio_vsock);
> > > > +	if (!vsock) {
> > > > +		ret = VMADDR_CID_ANY;
> > > > +		goto out_rcu;
> > > > +	}
> > > > -	return vsock->guest_cid;
> > > > +	ret = vsock->guest_cid;
> > > > +out_rcu:
> > > > +	rcu_read_unlock();
> > > > +	return ret;
> > > >    }
> > > >    static void virtio_transport_loopback_work(struct work_struct *work)
> > > > @@ -197,14 +200,18 @@ virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
> > > >    	struct virtio_vsock *vsock;
> > > >    	int len = pkt->len;
> > > > -	vsock = virtio_vsock_get();
> > > > +	rcu_read_lock();
> > > > +	vsock = rcu_dereference(the_virtio_vsock);
> > > >    	if (!vsock) {
> > > >    		virtio_transport_free_pkt(pkt);
> > > > -		return -ENODEV;
> > > > +		len = -ENODEV;
> > > > +		goto out_rcu;
> > > >    	}
> > > > -	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid)
> > > > -		return virtio_transport_send_pkt_loopback(vsock, pkt);
> > > > +	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid) {
> > > > +		len = virtio_transport_send_pkt_loopback(vsock, pkt);
> > > > +		goto out_rcu;
> > > > +	}
> > > >    	if (pkt->reply)
> > > >    		atomic_inc(&vsock->queued_replies);
> > > > @@ -214,6 +221,9 @@ virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
> > > >    	spin_unlock_bh(&vsock->send_pkt_list_lock);
> > > >    	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
> > > > +
> > > > +out_rcu:
> > > > +	rcu_read_unlock();
> > > >    	return len;
> > > >    }
> > > > @@ -222,12 +232,14 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
> > > >    {
> > > >    	struct virtio_vsock *vsock;
> > > >    	struct virtio_vsock_pkt *pkt, *n;
> > > > -	int cnt = 0;
> > > > +	int cnt = 0, ret;
> > > >    	LIST_HEAD(freeme);
> > > > -	vsock = virtio_vsock_get();
> > > > +	rcu_read_lock();
> > > > +	vsock = rcu_dereference(the_virtio_vsock);
> > > >    	if (!vsock) {
> > > > -		return -ENODEV;
> > > > +		ret = -ENODEV;
> > > > +		goto out_rcu;
> > > >    	}
> > > >    	spin_lock_bh(&vsock->send_pkt_list_lock);
> > > > @@ -255,7 +267,11 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
> > > >    			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> > > >    	}
> > > > -	return 0;
> > > > +	ret = 0;
> > > > +
> > > > +out_rcu:
> > > > +	rcu_read_unlock();
> > > > +	return ret;
> > > >    }
> > > >    static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
> > > > @@ -590,8 +606,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> > > >    	vsock->rx_buf_max_nr = 0;
> > > >    	atomic_set(&vsock->queued_replies, 0);
> > > > -	vdev->priv = vsock;
> > > > -	the_virtio_vsock = vsock;
> > > >    	mutex_init(&vsock->tx_lock);
> > > >    	mutex_init(&vsock->rx_lock);
> > > >    	mutex_init(&vsock->event_lock);
> > > > @@ -613,6 +627,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> > > >    	virtio_vsock_event_fill(vsock);
> > > >    	mutex_unlock(&vsock->event_lock);
> > > > +	vdev->priv = vsock;
> > > > +	rcu_assign_pointer(the_virtio_vsock, vsock);
> > > 
> > > You probably need to use rcu_dereference_protected() to access
> > > the_virtio_vsock in the function in order to survive from sparse.
> > > 
> > Ooo, thanks!
> > 
> > Do you mean when we check if the_virtio_vsock is not null at the beginning of
> > virtio_vsock_probe()?
> 
> 
> I mean instead of:
> 
>     /* Only one virtio-vsock device per guest is supported */
>     if (the_virtio_vsock) {
>         ret = -EBUSY;
>         goto out;
>     }
> 
> you should use:
> 
> if (rcu_dereference_protected(the_virtio_vosck,
> lock_dep_is_held(&the_virtio_vsock_mutex))
> 
> ...

Okay, thanks for confirming! I'll send a v3 to fix this!

> 
> 
> > 
> > > > +
> > > >    	mutex_unlock(&the_virtio_vsock_mutex);
> > > >    	return 0;
> > > > @@ -627,6 +644,12 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> > > >    	struct virtio_vsock *vsock = vdev->priv;
> > > >    	struct virtio_vsock_pkt *pkt;
> > > > +	mutex_lock(&the_virtio_vsock_mutex);
> > > > +
> > > > +	vdev->priv = NULL;
> > > > +	rcu_assign_pointer(the_virtio_vsock, NULL);
> > > 
> > > This is still suspicious, can we access the_virtio_vsock through vdev->priv?
> > > If yes, we may still get use-after-free since it was not protected by RCU.
> > We will free the object only after calling the del_vqs(), so we are sure
> > that the vq_callbacks ended and will no longer be invoked.
> > So, IIUC it shouldn't happen.
> 
> 
> Yes, but any dereference that is not done in vq_callbacks will be very
> dangerous in the future.

Right.

Do you think make sense to continue with this series in order to fix the
hot-unplug issue, then I'll work to refactor the driver code to use the refcnt
(as you suggested in patch 2) and singleton for the_virtio_vsock?

Thanks,
Stefano
