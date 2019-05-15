Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFD71E9FD
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 10:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfEOIWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 04:22:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51764 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfEOIWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 04:22:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id o189so1651551wmb.1
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 01:22:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=PPQSJiwlVW1PE92NeJWVh3dDEhwcNImDy2Q5NEYn4yo=;
        b=AvERmFi3aCIUVTz3zM79zS8qs1INSIkmU3AeIrb1/f2S7YdEMMkcsjhB8Cb3qWjxwI
         3r3Mg3FufjTk+v7MLGv7bs0xzOJfOeI88pXfFdvFUeuqIbHqYN0r7ckL7rGFvWjlhKZk
         IvjlFyUC/U/0Ba7H0aR4hPjY2wmGI259veFkCGSFjbkv6e6NBqK29OaRCYToVA85dqt2
         aXUuNooKYHQ2eeIoq4kD0WylCKw4cMs8Pnd/NawSrjp+61akU7QIzNxsUpGZqG/46bXL
         rr7NSuxw460J4naQY0OREz8GByXAi0pPobe2vy4//dk9aM6IPfeWbmvDrsYJIxKxfnka
         q7xg==
X-Gm-Message-State: APjAAAU98OG3VrWBQNtYcBPKt9JdXRY6Su8U9GXv5NC2yIN+eaz7BkNF
        Hg0HofU17Q3UAltBhzw5+a8f1g==
X-Google-Smtp-Source: APXvYqwpXrWkAROlq0ytsK33r1VNVYl9awseeDiyNlDpFhZC69GGaWDX1zimAMr2LLpZz2MeWmJqQg==
X-Received: by 2002:a1c:2104:: with SMTP id h4mr21953640wmh.146.1557908557541;
        Wed, 15 May 2019 01:22:37 -0700 (PDT)
Received: from steredhat (host151-251-static.12-87-b.business.telecomitalia.it. [87.12.251.151])
        by smtp.gmail.com with ESMTPSA id y184sm1579251wmg.7.2019.05.15.01.22.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 01:22:36 -0700 (PDT)
Date:   Wed, 15 May 2019 10:22:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v2 7/8] vsock/virtio: increase RX buffer size to 64 KiB
Message-ID: <20190515082233.iqaibtfdoblijb5z@steredhat>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-8-sgarzare@redhat.com>
 <bf0416f1-0e69-722d-75ce-3d101e6d7d71@redhat.com>
 <20190513175138.4yycad2xi65komw6@steredhat>
 <fd934a4c-f7d2-8a04-ed93-a3b690ed0d79@redhat.com>
 <20190514162056.5aotcuzsi6e6wya7@steredhat>
 <646275c5-3530-f428-98da-56da99d72fe1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <646275c5-3530-f428-98da-56da99d72fe1@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 10:50:43AM +0800, Jason Wang wrote:
> 
> On 2019/5/15 上午12:20, Stefano Garzarella wrote:
> > On Tue, May 14, 2019 at 11:38:05AM +0800, Jason Wang wrote:
> > > On 2019/5/14 上午1:51, Stefano Garzarella wrote:
> > > > On Mon, May 13, 2019 at 06:01:52PM +0800, Jason Wang wrote:
> > > > > On 2019/5/10 下午8:58, Stefano Garzarella wrote:
> > > > > > In order to increase host -> guest throughput with large packets,
> > > > > > we can use 64 KiB RX buffers.
> > > > > > 
> > > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > > ---
> > > > > >     include/linux/virtio_vsock.h | 2 +-
> > > > > >     1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > > > > > index 84b72026d327..5a9d25be72df 100644
> > > > > > --- a/include/linux/virtio_vsock.h
> > > > > > +++ b/include/linux/virtio_vsock.h
> > > > > > @@ -10,7 +10,7 @@
> > > > > >     #define VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE	128
> > > > > >     #define VIRTIO_VSOCK_DEFAULT_BUF_SIZE		(1024 * 256)
> > > > > >     #define VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE	(1024 * 256)
> > > > > > -#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
> > > > > > +#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 64)
> > > > > >     #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
> > > > > >     #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
> > > > > We probably don't want such high order allocation. It's better to switch to
> > > > > use order 0 pages in this case. See add_recvbuf_big() for virtio-net. If we
> > > > > get datapath unified, we will get more stuffs set.
> > > > IIUC, you are suggesting to allocate only pages and put them in a
> > > > scatterlist, then add them to the virtqueue.
> > > > 
> > > > Is it correct?
> > > 
> > > Yes since you are using:
> > > 
> > >                  pkt->buf = kmalloc(buf_len, GFP_KERNEL);
> > >                  if (!pkt->buf) {
> > >                          virtio_transport_free_pkt(pkt);
> > >                          break;
> > >                  }
> > > 
> > > This is likely to fail when the memory is fragmented which is kind of
> > > fragile.
> > > 
> > > 
> > Thanks for pointing that out.
> > 
> > > > The issue that I have here, is that the virtio-vsock guest driver, see
> > > > virtio_vsock_rx_fill(), allocates a struct virtio_vsock_pkt that
> > > > contains the room for the header, then allocates the buffer for the payload.
> > > > At this point it fills the scatterlist with the &virtio_vsock_pkt.hdr and the
> > > > buffer for the payload.
> > > 
> > > This part should be fine since what is needed is just adding more pages to
> > > sg[] and call virtuqeueu_add_sg().
> > > 
> > > 
> > Yes, I agree.
> > 
> > > > Changing this will require several modifications, and if we get datapath
> > > > unified, I'm not sure it's worth it.
> > > > Of course, if we leave the datapaths separated, I'd like to do that later.
> > > > 
> > > > What do you think?
> > > 
> > > For the driver it self, it should not be hard. But I think you mean the
> > > issue of e.g virtio_vsock_pkt itself which doesn't support sg. For short
> > > time, maybe we can use kvec instead.
> > I'll try to use kvec in the virtio_vsock_pkt.
> > 
> > Since this struct is shared also with the host driver (vhost-vsock),
> > I hope the changes could be limited, otherwise we can remove the last 2
> > patches of the series for now, leaving the RX buffer size to 4KB.
> 
> 
> Yes and if it introduces too much changes, maybe we can do the 64KB buffer
> in the future with the conversion of using skb where supports page frag
> natively.

Yes, I completely agree!

Thanks,
Stefano
