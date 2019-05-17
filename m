Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573CD21551
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 10:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfEQIZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 04:25:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40050 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbfEQIZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 04:25:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id h4so6130679wre.7
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 01:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cULMJDOvF9eVDSo9dp6+c4o/bcGy8xGnvE5CwRJMTP8=;
        b=bbyfDJ0VPNOp0b0l+Y8QZgremw/ExdeugLHCwXNM9yZEJKtfPVRXzp6MqOKO7i+tnX
         fndttH1pkqgpKA/h0koVdLmptw0DYq1ZRezK7qK9/IneQqBM+g3aN7H7IKwcQ2onj2EJ
         SFHZ6DWvUKPi6TQBAhNVB98TmGx9WMwCMxhW0Xjc5xyahoQAJ9ZUtGESdKDCBmIoLoW0
         vyIIbeBJQmVu2D8h7XeAq2fkE5FXMSaiVkOE2BL9lbOCSIidGu6L0LupIzf0k0eeQ5hs
         8loq4HXYKpHi5uc5IF/OxiSIsGCjawB4dANJtDXCbNoS7gkccRQiepNT41PPZSUtSKlv
         Ay7Q==
X-Gm-Message-State: APjAAAWkz36CZHhqD2fFuXjBfi4k1cJU6Nok2CT/S1b++8jVzcAq3YGP
        9SzMJVF/TW1hkg5iREDNWs7wqA==
X-Google-Smtp-Source: APXvYqx44DAzcoMxwbPxDzA5zwUNnPhQ9uXSTLL/mcvCVkyoGjdl0B2O21dlBn3vcpThmyUCCK30Hw==
X-Received: by 2002:a5d:4f0e:: with SMTP id c14mr17663814wru.91.1558081508824;
        Fri, 17 May 2019 01:25:08 -0700 (PDT)
Received: from steredhat (host151-251-static.12-87-b.business.telecomitalia.it. [87.12.251.151])
        by smtp.gmail.com with ESMTPSA id l18sm7415127wrv.38.2019.05.17.01.25.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 01:25:08 -0700 (PDT)
Date:   Fri, 17 May 2019 10:25:05 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v2 1/8] vsock/virtio: limit the memory used per-socket
Message-ID: <20190517082505.ibjkuh7zibumen77@steredhat>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-2-sgarzare@redhat.com>
 <20190516152533.GB29808@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516152533.GB29808@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 04:25:33PM +0100, Stefan Hajnoczi wrote:
> On Fri, May 10, 2019 at 02:58:36PM +0200, Stefano Garzarella wrote:
> > +struct virtio_vsock_buf {
> 
> Please add a comment describing the purpose of this struct and to
> differentiate its use from struct virtio_vsock_pkt.
> 

Sure, I'll fix it.

> > +static struct virtio_vsock_buf *
> > +virtio_transport_alloc_buf(struct virtio_vsock_pkt *pkt, bool zero_copy)
> > +{
> > +	struct virtio_vsock_buf *buf;
> > +
> > +	if (pkt->len == 0)
> > +		return NULL;
> > +
> > +	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> > +	if (!buf)
> > +		return NULL;
> > +
> > +	/* If the buffer in the virtio_vsock_pkt is full, we can move it to
> > +	 * the new virtio_vsock_buf avoiding the copy, because we are sure that
> > +	 * we are not use more memory than that counted by the credit mechanism.
> > +	 */
> > +	if (zero_copy && pkt->len == pkt->buf_len) {
> > +		buf->addr = pkt->buf;
> > +		pkt->buf = NULL;
> > +	} else {
> > +		buf->addr = kmalloc(pkt->len, GFP_KERNEL);
> 
> buf and buf->addr could be allocated in a single call, though I'm not
> sure how big an optimization this is.
> 

IIUC, in the case of zero-copy I should allocate only the buf,
otherwise I should allocate both buf and buf->addr in a single call
when I'm doing a full-copy.

Is it correct?

> > @@ -841,20 +882,24 @@ virtio_transport_recv_connected(struct sock *sk,
> >  {
> >  	struct vsock_sock *vsk = vsock_sk(sk);
> >  	struct virtio_vsock_sock *vvs = vsk->trans;
> > +	struct virtio_vsock_buf *buf;
> >  	int err = 0;
> >  
> >  	switch (le16_to_cpu(pkt->hdr.op)) {
> >  	case VIRTIO_VSOCK_OP_RW:
> >  		pkt->len = le32_to_cpu(pkt->hdr.len);
> > -		pkt->off = 0;
> > +		buf = virtio_transport_alloc_buf(pkt, true);
> >  
> > -		spin_lock_bh(&vvs->rx_lock);
> > -		virtio_transport_inc_rx_pkt(vvs, pkt);
> > -		list_add_tail(&pkt->list, &vvs->rx_queue);
> > -		spin_unlock_bh(&vvs->rx_lock);
> > +		if (buf) {
> > +			spin_lock_bh(&vvs->rx_lock);
> > +			virtio_transport_inc_rx_pkt(vvs, pkt->len);
> > +			list_add_tail(&buf->list, &vvs->rx_queue);
> > +			spin_unlock_bh(&vvs->rx_lock);
> >  
> > -		sk->sk_data_ready(sk);
> > -		return err;
> > +			sk->sk_data_ready(sk);
> > +		}
> 
> The return value of this function isn't used but the code still makes an
> effort to return errors.  Please return -ENOMEM when buf == NULL.
> 
> If you'd like to remove the return value that's fine too, but please do
> it for the whole function to be consistent.

I'll return -ENOMEM when the allocation fails.

Thanks,
Stefano
