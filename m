Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BB01CD18
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 18:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfENQfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 12:35:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33698 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENQfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 12:35:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id d9so11602289wrx.0
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 09:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=TRmSH+toJMjBNKSEQ3RtsylK7+rS178KvQ1RBahf+5s=;
        b=K6EGKV0Atdj+TdSwIZyskQqGPxTxxu4NGgiAkUIJaVjRQfrlsWOZCpgY7OoBRdr2ux
         jsV4JHgB85aaVm6BzgPUFO+nuN5F9aXJ21EFTUjivC7UCpj1cpjq14PW42Qg5foLcEhI
         mbhrNfoYeCwU/0CF1LSnGagQ1chWoIcFWlUM18wYQKg16R11z2dNYSpY6fa0rGMpHI1S
         0XS1+o2WBNmNxcKSYZ4vpP86TW+xv+WxPXX8i/51qlhDzjeYNZA1vKXVQzFIlLNjI7c4
         Zw8BsGmi7cjGT+fX25gL+ivNYsvFMB+YL0GuQahYyfpbTnLjDMJA/m6RD4CfFplFcdL4
         02Ug==
X-Gm-Message-State: APjAAAVDihmLc2vM4C0QsfDrbT3rC2g7Y9w7GJe+MBaco23AJM9tfADr
        Fs6rNiQZH08ZTvMJZRJ0jvN4fA==
X-Google-Smtp-Source: APXvYqyND+LSSDNDqT28MDu7z589ljMmvUo3U9FjLPyHbLMSLJ3Rz1AjcAEc90+CUvdqClX2N9lZHQ==
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr9943354wrv.295.1557851703616;
        Tue, 14 May 2019 09:35:03 -0700 (PDT)
Received: from steredhat (host151-251-static.12-87-b.business.telecomitalia.it. [87.12.251.151])
        by smtp.gmail.com with ESMTPSA id j131sm5790374wmb.9.2019.05.14.09.35.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 09:35:02 -0700 (PDT)
Date:   Tue, 14 May 2019 18:35:00 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v2 1/8] vsock/virtio: limit the memory used per-socket
Message-ID: <20190514163500.a7moalixvpn5mkcr@steredhat>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-2-sgarzare@redhat.com>
 <3b275b52-63d9-d260-1652-8e8bf7dd679f@redhat.com>
 <20190513172322.vcgenx7xk4v6r2ay@steredhat>
 <f834c9e9-5d0e-8ebb-44e0-6d99b6284e5c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f834c9e9-5d0e-8ebb-44e0-6d99b6284e5c@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 11:25:34AM +0800, Jason Wang wrote:
> 
> On 2019/5/14 上午1:23, Stefano Garzarella wrote:
> > On Mon, May 13, 2019 at 05:58:53PM +0800, Jason Wang wrote:
> > > On 2019/5/10 下午8:58, Stefano Garzarella wrote:
> > > > Since virtio-vsock was introduced, the buffers filled by the host
> > > > and pushed to the guest using the vring, are directly queued in
> > > > a per-socket list avoiding to copy it.
> > > > These buffers are preallocated by the guest with a fixed
> > > > size (4 KB).
> > > > 
> > > > The maximum amount of memory used by each socket should be
> > > > controlled by the credit mechanism.
> > > > The default credit available per-socket is 256 KB, but if we use
> > > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > > guest will continue to fill the vring with new 4 KB free buffers
> > > > to avoid starvation of her sockets.
> > > > 
> > > > This patch solves this issue copying the payload in a new buffer.
> > > > Then it is queued in the per-socket list, and the 4KB buffer used
> > > > by the host is freed.
> > > > 
> > > > In this way, the memory used by each socket respects the credit
> > > > available, and we still avoid starvation, paying the cost of an
> > > > extra memory copy. When the buffer is completely full we do a
> > > > "zero-copy", moving the buffer directly in the per-socket list.
> > > 
> > > I wonder in the long run we should use generic socket accouting mechanism
> > > provided by kernel (e.g socket, skb, sndbuf, recvbug, truesize) instead of
> > > vsock specific thing to avoid duplicating efforts.
> > I agree, the idea is to switch to sk_buff but this should require an huge
> > change. If we will use the virtio-net datapath, it will become simpler.
> 
> 
> Yes, unix domain socket is one example that uses general skb and socket
> structure. And we probably need some kind of socket pair on host. Using
> socket can also simplify the unification with vhost-net which depends on the
> socket proto_ops to work. I admit it's a huge change probably, we can do it
> gradually.
> 

Yes, I also prefer to do this change gradually :)

> 
> > > 
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > ---
> > > >    drivers/vhost/vsock.c                   |  2 +
> > > >    include/linux/virtio_vsock.h            |  8 +++
> > > >    net/vmw_vsock/virtio_transport.c        |  1 +
> > > >    net/vmw_vsock/virtio_transport_common.c | 95 ++++++++++++++++++-------
> > > >    4 files changed, 81 insertions(+), 25 deletions(-)
> > > > 
> > > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > > index bb5fc0e9fbc2..7964e2daee09 100644
> > > > --- a/drivers/vhost/vsock.c
> > > > +++ b/drivers/vhost/vsock.c
> > > > @@ -320,6 +320,8 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> > > >    		return NULL;
> > > >    	}
> > > > +	pkt->buf_len = pkt->len;
> > > > +
> > > >    	nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
> > > >    	if (nbytes != pkt->len) {
> > > >    		vq_err(vq, "Expected %u byte payload, got %zu bytes\n",
> > > > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > > > index e223e2632edd..345f04ee9193 100644
> > > > --- a/include/linux/virtio_vsock.h
> > > > +++ b/include/linux/virtio_vsock.h
> > > > @@ -54,9 +54,17 @@ struct virtio_vsock_pkt {
> > > >    	void *buf;
> > > >    	u32 len;
> > > >    	u32 off;
> > > > +	u32 buf_len;
> > > >    	bool reply;
> > > >    };
> > > > +struct virtio_vsock_buf {
> > > > +	struct list_head list;
> > > > +	void *addr;
> > > > +	u32 len;
> > > > +	u32 off;
> > > > +};
> > > > +
> > > >    struct virtio_vsock_pkt_info {
> > > >    	u32 remote_cid, remote_port;
> > > >    	struct vsock_sock *vsk;
> > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > > index 15eb5d3d4750..af1d2ce12f54 100644
> > > > --- a/net/vmw_vsock/virtio_transport.c
> > > > +++ b/net/vmw_vsock/virtio_transport.c
> > > > @@ -280,6 +280,7 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
> > > >    			break;
> > > >    		}
> > > > +		pkt->buf_len = buf_len;
> > > >    		pkt->len = buf_len;
> > > >    		sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
> > > > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > > > index 602715fc9a75..0248d6808755 100644
> > > > --- a/net/vmw_vsock/virtio_transport_common.c
> > > > +++ b/net/vmw_vsock/virtio_transport_common.c
> > > > @@ -65,6 +65,9 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
> > > >    		pkt->buf = kmalloc(len, GFP_KERNEL);
> > > >    		if (!pkt->buf)
> > > >    			goto out_pkt;
> > > > +
> > > > +		pkt->buf_len = len;
> > > > +
> > > >    		err = memcpy_from_msg(pkt->buf, info->msg, len);
> > > >    		if (err)
> > > >    			goto out;
> > > > @@ -86,6 +89,46 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
> > > >    	return NULL;
> > > >    }
> > > > +static struct virtio_vsock_buf *
> > > > +virtio_transport_alloc_buf(struct virtio_vsock_pkt *pkt, bool zero_copy)
> > > > +{
> > > > +	struct virtio_vsock_buf *buf;
> > > > +
> > > > +	if (pkt->len == 0)
> > > > +		return NULL;
> > > > +
> > > > +	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> > > > +	if (!buf)
> > > > +		return NULL;
> > > > +
> > > > +	/* If the buffer in the virtio_vsock_pkt is full, we can move it to
> > > > +	 * the new virtio_vsock_buf avoiding the copy, because we are sure that
> > > > +	 * we are not use more memory than that counted by the credit mechanism.
> > > > +	 */
> > > > +	if (zero_copy && pkt->len == pkt->buf_len) {
> > > > +		buf->addr = pkt->buf;
> > > > +		pkt->buf = NULL;
> > > > +	} else {
> > > 
> > > Is the copy still needed if we're just few bytes less? We meet similar issue
> > > for virito-net, and virtio-net solve this by always copy first 128bytes for
> > > big packets.
> > > 
> > > See receive_big()
> > I'm seeing, It is more sophisticated.
> > IIUC, virtio-net allocates a sk_buff with 128 bytes of buffer, then copies the
> > first 128 bytes, then adds the buffer used to receive the packet as a frag to
> > the skb.
> 
> 
> Yes and the point is if the packet is smaller than 128 bytes the pages will
> be recycled.
> 
> 

So it's avoid the overhead of allocation of a large buffer. I got it.

Just a curiosity, why the threshold is 128 bytes?

> > 
> > Do you suggest to implement something similar, or for now we can use my
> > approach and if we will merge the datapath we can reuse the virtio-net
> > approach?
> 
> 
> I think we need a better threshold. If I understand the patch correctly, we
> will do copy unless the packet is 64K when guest is doing receiving. 1 byte
> packet is indeed a problem, but we need to solve it without losing too much
> performance.

It is correct. I'll try to figure out a better threshold and the usage of
order 0 page.

Thanks again for your advices,
Stefano
