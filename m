Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1959D79170
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfG2QvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:51:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35144 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728541AbfG2QvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:51:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so54067685wmg.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HxGQ2fS0M6Vg7g7VHJrZaUAKmqWrcLECVicIPFYKW7M=;
        b=fA2v8GBVwmVcdkHfWAD3F/z4XlNnocyv+gsT1yxQ3gSuZVkVgVg2QHAX0bQg33VEGo
         O9lTeorpsZDoiRorfcXXZP+8OORICICXlDPhdmMK2CiLpI1U5J1KXmvqf3EF3kl5f+tr
         koGEdPSjVY+TteJyKhK+b6OD9rBeVF4GHvhkUPm0vqySfKuQEa8lx9GSLzDRgY2d6z7/
         lmjXE4ewSMKctW8JmaaxTdAFYakfY7omO3y8THZH7EKH72KT+tXU0Cx05IKg/6xBhTsD
         hHipeRSvVshdsxXJNIz/H9DAf2Pp406XgIErUkS2+M7mbrLC4curH1f5HhBkxQ/v370W
         KFkQ==
X-Gm-Message-State: APjAAAXe7vEIL9ZHCLDQd26IxVR2A6hDDmauoWBN6R3etB1iQ2ZMNH4/
        oo3Baawm9xiLG6oS4mEXVhPm4A==
X-Google-Smtp-Source: APXvYqzvBHcCudsBcR+qOG1gn0sYZ8Nk3BYDqP15f0ppsY0NZfsRNzIDLbZ1BJjwiESq2rSGn1Lhzg==
X-Received: by 2002:a1c:7d08:: with SMTP id y8mr82606423wmc.50.1564419059190;
        Mon, 29 Jul 2019 09:50:59 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id s10sm46971809wrt.49.2019.07.29.09.50.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:50:58 -0700 (PDT)
Date:   Mon, 29 Jul 2019 18:50:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190729165056.r32uzj6om3o6vfvp@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190729153656.zk4q4rob5oi6iq7l@steredhat>
 <20190729114302-mutt-send-email-mst@kernel.org>
 <20190729161903.yhaj5rfcvleexkhc@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729161903.yhaj5rfcvleexkhc@steredhat>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 06:19:03PM +0200, Stefano Garzarella wrote:
> On Mon, Jul 29, 2019 at 11:49:02AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jul 29, 2019 at 05:36:56PM +0200, Stefano Garzarella wrote:
> > > On Mon, Jul 29, 2019 at 10:04:29AM -0400, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> > > > > Since virtio-vsock was introduced, the buffers filled by the host
> > > > > and pushed to the guest using the vring, are directly queued in
> > > > > a per-socket list. These buffers are preallocated by the guest
> > > > > with a fixed size (4 KB).
> > > > > 
> > > > > The maximum amount of memory used by each socket should be
> > > > > controlled by the credit mechanism.
> > > > > The default credit available per-socket is 256 KB, but if we use
> > > > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > > > guest will continue to fill the vring with new 4 KB free buffers
> > > > > to avoid starvation of other sockets.
> > > > > 
> > > > > This patch mitigates this issue copying the payload of small
> > > > > packets (< 128 bytes) into the buffer of last packet queued, in
> > > > > order to avoid wasting memory.
> > > > > 
> > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > 
> > > > This is good enough for net-next, but for net I think we
> > > > should figure out how to address the issue completely.
> > > > Can we make the accounting precise? What happens to
> > > > performance if we do?
> > > > 
> > > 
> > > In order to do more precise accounting maybe we can use the buffer size,
> > > instead of payload size when we update the credit available.
> > > In this way, the credit available for each socket will reflect the memory
> > > actually used.
> > > 
> > > I should check better, because I'm not sure what happen if the peer sees
> > > 1KB of space available, then it sends 1KB of payload (using a 4KB
> > > buffer).
> > > 
> > > The other option is to copy each packet in a new buffer like I did in
> > > the v2 [2], but this forces us to make a copy for each packet that does
> > > not fill the entire buffer, perhaps too expensive.
> > > 
> > > [2] https://patchwork.kernel.org/patch/10938741/
> > > 
> > > 
> > > Thanks,
> > > Stefano
> > 
> > Interesting. You are right, and at some level the protocol forces copies.
> > 
> > We could try to detect that the actual memory is getting close to
> > admin limits and force copies on queued packets after the fact.
> > Is that practical?
> 
> Yes, I think it is doable!
> We can decrease the credit available with the buffer size queued, and
> when the buffer size of packet to queue is bigger than the credit
> available, we can copy it.
> 
> > 
> > And yes we can extend the credit accounting to include buffer size.
> > That's a protocol change but maybe it makes sense.
> 
> Since we send to the other peer the credit available, maybe this
> change can be backwards compatible (I'll check better this).

What I said was wrong.

We send a counter (increased when the user consumes the packets) and the
"buf_alloc" (the max memory allowed) to the other peer.
It makes a difference between a local counter (increased when the
packets are sent) and the remote counter to calculate the credit available:

    u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
    {
    	u32 ret;

    	spin_lock_bh(&vvs->tx_lock);
    	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
    	if (ret > credit)
    		ret = credit;
    	vvs->tx_cnt += ret;
    	spin_unlock_bh(&vvs->tx_lock);

    	return ret;
    }

Maybe I can play with "buf_alloc" to take care of bytes queued but not
used.

Thanks,
Stefano
