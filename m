Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57666CA29
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 09:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389252AbfGRHnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 03:43:09 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39250 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfGRHnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 03:43:09 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so14184408wmc.4
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 00:43:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+5h5a3O3K59BqV9oPAQLtP560NcGiWgROtgONhhQBcA=;
        b=Mh6QNKEvhGh894GTBbAtc2pDGeqISNj0bdznss8RPdeF7to9+FYv9cQs2/EMfopfj4
         d+6f0yY5AiXAvPBx8GpVqPlPLw8qhdEgD6q8A1szj+DIL2qeOLDzhvQom7iRn5t0Wvxv
         CfZUCdhByxh01+2QwhVQUsJnj15td/Krv4wGP7tqux7Tujeebm9CthymsR9taK63HIDP
         uABl+TRfVtMNbDozYQCq0OPiB1qaAdUK6WY+6LWgFpxdZG7RcGZ0sSEXfzwG1qpkjBPQ
         yW+IaWKopmRx2bhmLLLUbqOCFO/CaQG/909Ay3z9ymlMAYtApsNkAfdH1XSkaDFnAb4l
         X/wg==
X-Gm-Message-State: APjAAAUzd0O5Udb7Qn1rBQliYBmmyP4KTMbIE/fIPmciK6QDtVtmk9Ep
        /FCoqLa4wOkFnKpFlfQ6X5OxGQ==
X-Google-Smtp-Source: APXvYqwtVzF6pOrVC5RrHtwRwAyqm+l6A25CyYC8a8Kyj4y50SwTmJGOs3CDoEzgqjZKGhzJbIUIfQ==
X-Received: by 2002:a1c:3:: with SMTP id 3mr41105085wma.6.1563435787761;
        Thu, 18 Jul 2019 00:43:07 -0700 (PDT)
Received: from steredhat ([5.170.38.133])
        by smtp.gmail.com with ESMTPSA id g25sm18763167wmk.39.2019.07.18.00.43.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 00:43:07 -0700 (PDT)
Date:   Thu, 18 Jul 2019 09:43:04 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 3/5] vsock/virtio: fix locking in
 virtio_transport_inc_tx_pkt()
Message-ID: <CAGxU2F5PS8Ug3ei79ShVHOwLSXGYKwn3umvfvnhSFDs9pdvH2g@mail.gmail.com>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-4-sgarzare@redhat.com>
 <20190717105056-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717105056-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 4:51 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 17, 2019 at 01:30:28PM +0200, Stefano Garzarella wrote:
> > fwd_cnt and last_fwd_cnt are protected by rx_lock, so we should use
> > the same spinlock also if we are in the TX path.
> >
> > Move also buf_alloc under the same lock.
> >
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>
> Wait a second is this a bugfix?
> If it's used under the wrong lock won't values get corrupted?
> Won't traffic then stall or more data get to sent than
> credits?

Before this series, we only read vvs->fwd_cnt and vvs->buf_alloc in this
function, but using a different lock than the one used to write them.
I'm not sure if a corruption can happen, but if we want to avoid the
lock, we should use an atomic operation or memory barriers.

Since now we also need to update vvs->last_fwd_cnt, in order to limit the
credit message, I decided to take the same lock used to protect vvs->fwd_cnt
and vvs->last_fwd_cnt.


Thanks,
Stefano

>
> > ---
> >  include/linux/virtio_vsock.h            | 2 +-
> >  net/vmw_vsock/virtio_transport_common.c | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > index 49fc9d20bc43..4c7781f4b29b 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -35,7 +35,6 @@ struct virtio_vsock_sock {
> >
> >       /* Protected by tx_lock */
> >       u32 tx_cnt;
> > -     u32 buf_alloc;
> >       u32 peer_fwd_cnt;
> >       u32 peer_buf_alloc;
> >
> > @@ -43,6 +42,7 @@ struct virtio_vsock_sock {
> >       u32 fwd_cnt;
> >       u32 last_fwd_cnt;
> >       u32 rx_bytes;
> > +     u32 buf_alloc;
> >       struct list_head rx_queue;
> >  };
> >
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index a85559d4d974..34a2b42313b7 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -210,11 +210,11 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
> >
> >  void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt)
> >  {
> > -     spin_lock_bh(&vvs->tx_lock);
> > +     spin_lock_bh(&vvs->rx_lock);
> >       vvs->last_fwd_cnt = vvs->fwd_cnt;
> >       pkt->hdr.fwd_cnt = cpu_to_le32(vvs->fwd_cnt);
> >       pkt->hdr.buf_alloc = cpu_to_le32(vvs->buf_alloc);
> > -     spin_unlock_bh(&vvs->tx_lock);
> > +     spin_unlock_bh(&vvs->rx_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_transport_inc_tx_pkt);
> >
> > --
> > 2.20.1
