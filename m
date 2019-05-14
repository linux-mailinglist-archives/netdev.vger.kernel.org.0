Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BD21D168
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 23:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfENVj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 17:39:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44607 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfENVjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 17:39:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id f24so848560qtk.11
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 14:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aWK7PXXvQrEhOv6s8QWB7I7Boz6+XjnQ7xuFCvI0oVU=;
        b=Q+f3dsG1DrJSXRQaOu58qDf1FK6cz0+DpX4XMmM9XjHMIai4sWCGdhS7uTN4oQ/tfM
         bZT3w5aQZP5Qj7Mg84ZS25xUasnJlFx9FtFqVSjiGGjhEMrp9enX23x3Qu8NloE2D+cU
         WW2E05JSUj+uevt5US7Hf4xmoMl+yH2jmIEEoTi9G4zUTQVwb2isYXpdPBM99oxB810y
         EYMsIUrIkIYh3inolPH/BJpT06GvfbsFP7nhoRlXEfhNZMjM+HIxNCFA0XhNDR+OPt6P
         TRFQK1wYP4FFvhPfXyKvUMOr8+6un2runOtdqbte2Os6sw6vFZv7T416nYAtV0FlNe6N
         +61g==
X-Gm-Message-State: APjAAAUB92s+uWTyhM+2pYhjZiWLkguLYhvB4nvRYvf56DLdvUtc8Ty0
        ifq58RPoFHIDQ4SXjWqUfXZaUg==
X-Google-Smtp-Source: APXvYqyUH3DCGNAgl6is6ltPv9BK0itoAq9TUOKssuzcmBenrgWo5uFpT9bZO0oG+lKaN/sd9hObGA==
X-Received: by 2002:ac8:4304:: with SMTP id z4mr23665337qtm.275.1557869964487;
        Tue, 14 May 2019 14:39:24 -0700 (PDT)
Received: from redhat.com ([185.54.206.10])
        by smtp.gmail.com with ESMTPSA id t17sm100990qte.66.2019.05.14.14.39.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 14 May 2019 14:39:23 -0700 (PDT)
Date:   Tue, 14 May 2019 17:39:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ppandit@redhat.com
Subject: Re: [PATCH net] vhost_net: fix possible infinite loop
Message-ID: <20190514173016-mutt-send-email-mst@kernel.org>
References: <1556177599-56248-1-git-send-email-jasowang@redhat.com>
 <20190425131021-mutt-send-email-mst@kernel.org>
 <f4b4ff70-d64f-c3fb-fe2e-97ef6c55bda0@redhat.com>
 <999ef863-2994-e0c0-fbb1-a6e92de3fd24@redhat.com>
 <20190512125959-mutt-send-email-mst@kernel.org>
 <a0d99d7a-2323-a6a8-262d-9fdc5d926384@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0d99d7a-2323-a6a8-262d-9fdc5d926384@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 01:42:33PM +0800, Jason Wang wrote:
> 
> On 2019/5/13 上午1:10, Michael S. Tsirkin wrote:
> > On Sun, May 05, 2019 at 12:20:24PM +0800, Jason Wang wrote:
> > > On 2019/4/26 下午3:35, Jason Wang wrote:
> > > > On 2019/4/26 上午1:52, Michael S. Tsirkin wrote:
> > > > > On Thu, Apr 25, 2019 at 03:33:19AM -0400, Jason Wang wrote:
> > > > > > When the rx buffer is too small for a packet, we will discard the vq
> > > > > > descriptor and retry it for the next packet:
> > > > > > 
> > > > > > while ((sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
> > > > > >                            &busyloop_intr))) {
> > > > > > ...
> > > > > >      /* On overrun, truncate and discard */
> > > > > >      if (unlikely(headcount > UIO_MAXIOV)) {
> > > > > >          iov_iter_init(&msg.msg_iter, READ, vq->iov, 1, 1);
> > > > > >          err = sock->ops->recvmsg(sock, &msg,
> > > > > >                       1, MSG_DONTWAIT | MSG_TRUNC);
> > > > > >          pr_debug("Discarded rx packet: len %zd\n", sock_len);
> > > > > >          continue;
> > > > > >      }
> > > > > > ...
> > > > > > }
> > > > > > 
> > > > > > This makes it possible to trigger a infinite while..continue loop
> > > > > > through the co-opreation of two VMs like:
> > > > > > 
> > > > > > 1) Malicious VM1 allocate 1 byte rx buffer and try to slow down the
> > > > > >      vhost process as much as possible e.g using indirect descriptors or
> > > > > >      other.
> > > > > > 2) Malicious VM2 generate packets to VM1 as fast as possible
> > > > > > 
> > > > > > Fixing this by checking against weight at the end of RX and TX
> > > > > > loop. This also eliminate other similar cases when:
> > > > > > 
> > > > > > - userspace is consuming the packets in the meanwhile
> > > > > > - theoretical TOCTOU attack if guest moving avail index back and forth
> > > > > >     to hit the continue after vhost find guest just add new buffers
> > > > > > 
> > > > > > This addresses CVE-2019-3900.
> > > > > > 
> > > > > > Fixes: d8316f3991d20 ("vhost: fix total length when packets are
> > > > > > too short")
> > > > > I agree this is the real issue.
> > > > > 
> > > > > > Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
> > > > > This is just a red herring imho. We can stick this on any vhost patch :)
> > > > > 
> > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > ---
> > > > > >    drivers/vhost/net.c | 41 +++++++++++++++++++++--------------------
> > > > > >    1 file changed, 21 insertions(+), 20 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > > > > index df51a35..fb46e6b 100644
> > > > > > --- a/drivers/vhost/net.c
> > > > > > +++ b/drivers/vhost/net.c
> > > > > > @@ -778,8 +778,9 @@ static void handle_tx_copy(struct vhost_net
> > > > > > *net, struct socket *sock)
> > > > > >        int err;
> > > > > >        int sent_pkts = 0;
> > > > > >        bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
> > > > > > +    bool next_round = false;
> > > > > >    -    for (;;) {
> > > > > > +    do {
> > > > > >            bool busyloop_intr = false;
> > > > > >              if (nvq->done_idx == VHOST_NET_BATCH)
> > > > > > @@ -845,11 +846,10 @@ static void handle_tx_copy(struct
> > > > > > vhost_net *net, struct socket *sock)
> > > > > >            vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
> > > > > >            vq->heads[nvq->done_idx].len = 0;
> > > > > >            ++nvq->done_idx;
> > > > > > -        if (vhost_exceeds_weight(++sent_pkts, total_len)) {
> > > > > > -            vhost_poll_queue(&vq->poll);
> > > > > > -            break;
> > > > > > -        }
> > > > > > -    }
> > > > > > +    } while (!(next_round = vhost_exceeds_weight(++sent_pkts,
> > > > > > total_len)));
> > > > > > +
> > > > > > +    if (next_round)
> > > > > > +        vhost_poll_queue(&vq->poll);
> > > > > >          vhost_tx_batch(net, nvq, sock, &msg);
> > > > > >    }
> > > > > > @@ -873,8 +873,9 @@ static void handle_tx_zerocopy(struct
> > > > > > vhost_net *net, struct socket *sock)
> > > > > >        struct vhost_net_ubuf_ref *uninitialized_var(ubufs);
> > > > > >        bool zcopy_used;
> > > > > >        int sent_pkts = 0;
> > > > > > +    bool next_round = false;
> > > > > >    -    for (;;) {
> > > > > > +    do {
> > > > > >            bool busyloop_intr;
> > > > > >              /* Release DMAs done buffers first */
> > > > > > @@ -951,11 +952,10 @@ static void handle_tx_zerocopy(struct
> > > > > > vhost_net *net, struct socket *sock)
> > > > > >            else
> > > > > >                vhost_zerocopy_signal_used(net, vq);
> > > > > >            vhost_net_tx_packet(net);
> > > > > > -        if (unlikely(vhost_exceeds_weight(++sent_pkts, total_len))) {
> > > > > > -            vhost_poll_queue(&vq->poll);
> > > > > > -            break;
> > > > > > -        }
> > > > > > -    }
> > > > > > +    } while (!(next_round = vhost_exceeds_weight(++sent_pkts,
> > > > > > total_len)));
> > > > > > +
> > > > > > +    if (next_round)
> > > > > > +        vhost_poll_queue(&vq->poll);
> > > > > >    }
> > > > > >      /* Expects to be always run from workqueue - which acts as
> > > > > > @@ -1134,6 +1134,7 @@ static void handle_rx(struct vhost_net *net)
> > > > > >        struct iov_iter fixup;
> > > > > >        __virtio16 num_buffers;
> > > > > >        int recv_pkts = 0;
> > > > > > +    bool next_round = false;
> > > > > >          mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
> > > > > >        sock = vq->private_data;
> > > > > > @@ -1153,8 +1154,11 @@ static void handle_rx(struct vhost_net *net)
> > > > > >            vq->log : NULL;
> > > > > >        mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
> > > > > >    -    while ((sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
> > > > > > -                              &busyloop_intr))) {
> > > > > > +    do {
> > > > > > +        sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
> > > > > > +                              &busyloop_intr);
> > > > > > +        if (!sock_len)
> > > > > > +            break;
> > > > > >            sock_len += sock_hlen;
> > > > > >            vhost_len = sock_len + vhost_hlen;
> > > > > >            headcount = get_rx_bufs(vq, vq->heads + nvq->done_idx,
> > > > > > @@ -1239,12 +1243,9 @@ static void handle_rx(struct vhost_net *net)
> > > > > >                vhost_log_write(vq, vq_log, log, vhost_len,
> > > > > >                        vq->iov, in);
> > > > > >            total_len += vhost_len;
> > > > > > -        if (unlikely(vhost_exceeds_weight(++recv_pkts, total_len))) {
> > > > > > -            vhost_poll_queue(&vq->poll);
> > > > > > -            goto out;
> > > > > > -        }
> > > > > > -    }
> > > > > > -    if (unlikely(busyloop_intr))
> > > > > > +    } while (!(next_round = vhost_exceeds_weight(++recv_pkts,
> > > > > > total_len)));
> > > > > > +
> > > > > > +    if (unlikely(busyloop_intr || next_round))
> > > > > >            vhost_poll_queue(&vq->poll);
> > > > > >        else
> > > > > >            vhost_net_enable_vq(net, vq);
> > > > > I'm afraid with this addition the code is too much like spagetty. What
> > > > > does next_round mean?  Just that we are breaking out of loop?
> > > > 
> > > > Yes, we can have a better name of course.
> > > > 
> > > > 
> > > > > That is
> > > > > what goto is for...  Either let's have for(;;) with goto/break to get
> > > > > outside or a while loop with a condition.  Both is just unreadable.
> > > > > 
> > > > > All these checks in 3 places are exactly the same on all paths and they
> > > > > are slow path. Why don't we put this in a function?
> > > > 
> > > > The point I think is, we want the weight to be checked in both fast path
> > > > and slow path.
> > > > 
> > > > 
> > > > > E.g. like the below.
> > > > > Warning: completely untested.
> > > > > 
> > > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > 
> > > > > ---
> > > > > 
> > > > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > > > index df51a35cf537..a0f89a504cd9 100644
> > > > > --- a/drivers/vhost/net.c
> > > > > +++ b/drivers/vhost/net.c
> > > > > @@ -761,6 +761,23 @@ static int vhost_net_build_xdp(struct
> > > > > vhost_net_virtqueue *nvq,
> > > > >        return 0;
> > > > >    }
> > > > >    +/* Returns true if caller needs to go back and re-read the ring. */
> > > > > +static bool empty_ring(struct vhost_net *net, struct
> > > > > vhost_virtqueue *vq,
> > > > > +               int pkts, size_t total_len, bool busyloop_intr)
> > > > > +{
> > > > > +    if (unlikely(busyloop_intr)) {
> > > > > +        vhost_poll_queue(&vq->poll);
> > > > > +    } else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
> > > > > +        /* They have slipped one in meanwhile: check again. */
> > > > > +        vhost_disable_notify(&net->dev, vq);
> > > > > +        if (!vhost_exceeds_weight(pkts, total_len))
> > > > > +            return true;
> > > > > +        vhost_poll_queue(&vq->poll);
> > > > > +    }
> > > > > +    /* Nothing new?  Wait for eventfd to tell us they refilled. */
> > > > > +    return false;
> > > > > +}
> > > > 
> > > > Ring empy is not the only places that needs care. E.g for RX, we need
> > > > care about overrun and when userspace is consuming the packet in the
> > > > same time. So there's no need to toggle vq notification in those two.
> > Well I just factored out code that looked exactly the same.
> > You can add more common code and rename the function
> > if it turns out to be worth while.
> > 
> > 
> > > > 
> > > > > +
> > > > >    static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > >    {
> > > > >        struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_TX];
> > > > > @@ -790,15 +807,10 @@ static void handle_tx_copy(struct vhost_net
> > > > > *net, struct socket *sock)
> > > > >            /* On error, stop handling until the next kick. */
> > > > >            if (unlikely(head < 0))
> > > > >                break;
> > > > > -        /* Nothing new?  Wait for eventfd to tell us they refilled. */
> > > > >            if (head == vq->num) {
> > > > > -            if (unlikely(busyloop_intr)) {
> > > > > -                vhost_poll_queue(&vq->poll);
> > > > > -            } else if (unlikely(vhost_enable_notify(&net->dev,
> > > > > -                                vq))) {
> > > > > -                vhost_disable_notify(&net->dev, vq);
> > > > > +            if (unlikely(empty_ring(net, vq, ++sent_pkts,
> > > > > +                        total_len, busyloop_intr)))
> > > > >                    continue;
> > > > > -            }
> > > > >                break;
> > > > >            }
> > > > >    @@ -886,14 +898,10 @@ static void handle_tx_zerocopy(struct
> > > > > vhost_net *net, struct socket *sock)
> > > > >            /* On error, stop handling until the next kick. */
> > > > >            if (unlikely(head < 0))
> > > > >                break;
> > > > > -        /* Nothing new?  Wait for eventfd to tell us they refilled. */
> > > > >            if (head == vq->num) {
> > > > > -            if (unlikely(busyloop_intr)) {
> > > > > -                vhost_poll_queue(&vq->poll);
> > > > > -            } else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
> > > > > -                vhost_disable_notify(&net->dev, vq);
> > > > > +            if (unlikely(empty_ring(net, vq, ++sent_pkts,
> > > > > +                        total_len, busyloop_intr)))
> > > > >                    continue;
> > > > > -            }
> > > > >                break;
> > > > >            }
> > > > >    @@ -1163,18 +1171,10 @@ static void handle_rx(struct vhost_net *net)
> > > > >            /* On error, stop handling until the next kick. */
> > > > >            if (unlikely(headcount < 0))
> > > > >                goto out;
> > > > > -        /* OK, now we need to know about added descriptors. */
> > > > >            if (!headcount) {
> > > > > -            if (unlikely(busyloop_intr)) {
> > > > > -                vhost_poll_queue(&vq->poll);
> > > > > -            } else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
> > > > > -                /* They have slipped one in as we were
> > > > > -                 * doing that: check again. */
> > > > > -                vhost_disable_notify(&net->dev, vq);
> > > > > -                continue;
> > > > > -            }
> > > > > -            /* Nothing new?  Wait for eventfd to tell us
> > > > > -             * they refilled. */
> > > > > +            if (unlikely(empty_ring(net, vq, ++recv_pkts,
> > > > > +                        total_len, busyloop_intr)))
> > > > > +                    continue;
> > > > >                goto out;
> > > > >            }
> > > > >            busyloop_intr = false;
> > > > The patch misses several other continue that need cares and there's
> > > > another call of vhost_exceeds_weight() at the end of the loop.
> > > > 
> > > > So instead of duplicating check everywhere like:
> > > > 
> > > > for (;;) {
> > > >      if (condition_x) {
> > > >          if (empty_ring())
> > > >              continue;
> > > >          break;
> > > >      }
> > > >      if (condition_y) {
> > > >          if (empty_ring());
> > > >              continue;
> > > >          break;
> > > >      }
> > > >      if (condition_z) {
> > > >          if (empty_ring())
> > > >              continue;
> > > >          break;
> > > >      }
> > > > 
> > > > }
> > > > 
> > > > What this patch did:
> > > > 
> > > > do {
> > > >     if (condition_x)
> > > >      continue;
> > > >     if (condition_y)
> > > >      continue;
> > > >     if (condition_z)
> > > >      continue;
> > > > } while(!need_break())
> > > > 
> > > > is much more compact and easier to read?
> > > > 
> > > > Thanks
> > > 
> > > Hi Michael:
> > > 
> > > Any more comments?
> > > 
> > > Thanks
> > Jason the actual code in e.g. handle_tx_copy is nowhere close to the
> > neat example you provide below. Yes new parts are like this but we
> > kept all the old code around and that works differently.
> > 
> > 
> > Look at handle_tx_copy for example.
> > With your patch applied one can exit the loop:
> > 
> > 
> > 	with a break
> > 	with continue and condition false
> > 	get to end of loop and condition false
> > 
> > 	and we have a goto there which now can get us to
> > 	end of loop and then exit.
> 
> 
> For the goto case, there's no functional change. For either case, there will
> be a weight check at the end of the loop. Isn't it?
> 
> 
> > 
> > previously at least we would only exit
> > on a break.
> 
> 
> Actually, the only difference in handle_tx_copy() is the handling of
> 'continue'. Without the patch, we won't check weight. With the patch, we
> will check and exit the loop if we exceeds the weight. Did I miss anything
> obvious?
> 
> Thanks

Let me try to explain again.
At the moment how does handle_tx_copy exit?
It's for(;;) so you know you need to look for a break.

When reading code you also notice there's a goto done
which could exit the loop. if you scan forward
you notice that it does not.
This is confusing, but oh well. Worth fixing maybe ...

Now you add the next round check.
And there is also special code that
detects whether you exited with break
and whenever you did it acts specially.

Yea it works. But I think it's clearer if we
just make things obvious.
If we want something to happen on error then

	if (error)
		handle
		break

is imho clearer than

	flag = true
	if (error)
		break
	flag = false


if (flag)
	handle

in partucular - less branches on data path.

you point out code duplication correctly,
but we can solve it just by adding functions.
like i suggested.


> 
> > 
> > Frankly trying to review it I get lost now.
> > I also think repeated checking of empty_ring is not that
> > problematic.
> > But I don't insist on this specific splitup
> > just pls make the code regular by
> > moving stuff to sub-function.
> > 
> > 
