Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C8DA4801
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 08:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbfIAG4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 02:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbfIAG4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 02:56:51 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 061668535D
        for <netdev@vger.kernel.org>; Sun,  1 Sep 2019 06:56:51 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id x1so12284768qkn.6
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 23:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UW9CVZWWp/DmXfhS0ymox5ZMSVNVKNMeicZiRHV6nTI=;
        b=hkb5GUQPsxzmrVl+3CiuJesXpZOROR+ueMF5DI1GnjIaW4ZTXZdZFfLckvuLugIpLC
         Wbrp9iXbdci7NTdzXAisH82IyxxJNQx6jnNbwFmgiZ8FCIYeYfnCIA/ou5m5KSWv9yQ8
         e+WJLWRkN/o7U5Ta1SLVs720MHTbTx4jMZxgCzKhtN6qqwG4XHQeiaPPOb73wyAsPSLC
         71qIw7L687yeJl6HKtLQMUj0qPhg1aeHpXXmXjYcXzz+gChrSUQYty91abJBcZEbPllP
         jrQoNwb3Ie8OFFTbVg/DbasdiKF4hS5vgb+/DkSxNXEoPy3iR1VPLZqA9zMluNzdl8tY
         bdwQ==
X-Gm-Message-State: APjAAAWPGwp6P1TLhTlUIgBlnE9OdOL4mLsuD2CulXvQA/FZin1lxoMR
        cFy0R7U/vsRdSo5larZsDDO2TAICemMveKiOdiDsPX2bqBRhjUuZovBeSBFbOJNXVRVEmnSBYsG
        69VjEbC2bfsSXHV5X
X-Received: by 2002:a37:a411:: with SMTP id n17mr23142375qke.216.1567321010322;
        Sat, 31 Aug 2019 23:56:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxPKZ+Vuh8zQ97EQPv9t8FqbPGIvcdvksLy9917GAkHcy++oRW46I0ZqIJtBQeoHzJyWxhR6w==
X-Received: by 2002:a37:a411:: with SMTP id n17mr23142366qke.216.1567321010113;
        Sat, 31 Aug 2019 23:56:50 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id p59sm4831049qtd.75.2019.08.31.23.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 23:56:49 -0700 (PDT)
Date:   Sun, 1 Sep 2019 02:56:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190901024525-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190830094059.c7qo5cxrp2nkrncd@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830094059.c7qo5cxrp2nkrncd@steredhat>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 11:40:59AM +0200, Stefano Garzarella wrote:
> On Mon, Jul 29, 2019 at 10:04:29AM -0400, Michael S. Tsirkin wrote:
> > On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> > > Since virtio-vsock was introduced, the buffers filled by the host
> > > and pushed to the guest using the vring, are directly queued in
> > > a per-socket list. These buffers are preallocated by the guest
> > > with a fixed size (4 KB).
> > > 
> > > The maximum amount of memory used by each socket should be
> > > controlled by the credit mechanism.
> > > The default credit available per-socket is 256 KB, but if we use
> > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > guest will continue to fill the vring with new 4 KB free buffers
> > > to avoid starvation of other sockets.
> > > 
> > > This patch mitigates this issue copying the payload of small
> > > packets (< 128 bytes) into the buffer of last packet queued, in
> > > order to avoid wasting memory.
> > > 
> > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > This is good enough for net-next, but for net I think we
> > should figure out how to address the issue completely.
> > Can we make the accounting precise? What happens to
> > performance if we do?
> > 
> 
> Since I'm back from holidays, I'm restarting this thread to figure out
> how to address the issue completely.
> 
> I did a better analysis of the credit mechanism that we implemented in
> virtio-vsock to get a clearer view and I'd share it with you:
> 
>     This issue affect only the "host->guest" path. In this case, when the
>     host wants to send a packet to the guest, it uses a "free" buffer
>     allocated by the guest (4KB).
>     The "free" buffers available for the host are shared between all
>     sockets, instead, the credit mechanism is per-socket, I think to
>     avoid the starvation of others sockets.
>     The guests re-fill the "free" queue when the available buffers are
>     less than half.
> 
>     Each peer have these variables in the per-socket state:
>        /* local vars */
>        buf_alloc        /* max bytes usable by this socket
>                            [exposed to the other peer] */
>        fwd_cnt          /* increased when RX packet is consumed by the
>                            user space [exposed to the other peer] */
>        tx_cnt 	        /* increased when TX packet is sent to the other peer */
> 
>        /* remote vars  */
>        peer_buf_alloc   /* peer's buf_alloc */
>        peer_fwd_cnt     /* peer's fwd_cnt */
> 
>     When a peer sends a packet, it increases the 'tx_cnt'; when the
>     receiver consumes the packet (copy it to the user-space buffer), it
>     increases the 'fwd_cnt'.
>     Note: increments are made considering the payload length and not the
>     buffer length.
> 
>     The value of 'buf_alloc' and 'fwd_cnt' are sent to the other peer in
>     all packet headers or with an explicit CREDIT_UPDATE packet.
> 
>     The local 'buf_alloc' value can be modified by the user space using
>     setsockopt() with optname=SO_VM_SOCKETS_BUFFER_SIZE.
> 
>     Before to send a packet, the peer checks the space available:
>     	credit_available = peer_buf_alloc - (tx_cnt - peer_fwd_cnt)
>     and it will send up to credit_available bytes to the other peer.
> 
> Possible solutions considering Michael's advice:
> 1. Use the buffer length instead of the payload length when we increment
>    the counters:
>   - This approach will account precisely the memory used per socket.
>   - This requires changes in both guest and host.
>   - It is not compatible with old drivers, so a feature should be negotiated.
> 2. Decrease the advertised 'buf_alloc' taking count of bytes queued in
>    the socket queue but not used. (e.g. 256 byte used on 4K available in
>    the buffer)
>   - pkt->hdr.buf_alloc = buf_alloc - bytes_not_used.
>   - This should be compatible also with old drivers.
> 
> Maybe the second is less invasive, but will it be too tricky?
> Any other advice or suggestions?
> 
> Thanks in advance,
> Stefano

OK let me try to clarify.  The idea is this:

Let's say we queue a buffer of 4K, and we copy if len < 128 bytes.  This
means that in the worst case (128 byte packets), each byte of credit in
the socket uses up 4K/128 = 16 bytes of kernel memory. In fact we need
to also account for the virtio_vsock_pkt since I think it's kept around
until userspace consumes it.

Thus given X buf alloc allowed in the socket, we should publish X/16
credits to the other side. This will ensure the other side does not send
more than X/16 bytes for a given socket and thus we won't need to
allocate more than X bytes to hold the data.

We can play with the copy break value to tweak this.



