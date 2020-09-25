Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83C5278903
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgIYNFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:05:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbgIYNFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:05:54 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601039152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xhe5KxfKkK3aUjIYs2cWP5cnri5+HS/g/0mzyZIrbQA=;
        b=EUgAScP1yN+sD6aHfdNeKTBnAebSV6imQRRtz8fhdOLF6BRKimmEsb4UsbG/BJtzhSR/ly
        2AKd+2gjUxbXBohqXzvvnUnt8ICCQHYnCUqDNHUT3o1I6Q5SA3b6PvfO8ERRnjhEFCCnT1
        1oJWDtafWpvtsdeo563XwpglmjkOngo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-nMGFx1_hP_KvP-xMFYh27g-1; Fri, 25 Sep 2020 09:05:50 -0400
X-MC-Unique: nMGFx1_hP_KvP-xMFYh27g-1
Received: by mail-wm1-f72.google.com with SMTP id m10so814204wmf.5
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xhe5KxfKkK3aUjIYs2cWP5cnri5+HS/g/0mzyZIrbQA=;
        b=rmvgMgx1tG3NdeNSjrYZLy4tS+a0q8j4UiK8JDy05JErv1a7bWoOV8tUTCxT5sOzyH
         K6B/JkyUbuvwGlBS2rO3I/ESvap43JOmf5MCzgC6urx9/Yzh+rOSNIHpML6bU6HxIBIs
         y3gnTberL30TcGUzeru6MVeVaQLSynpsSQAcvfB4rojb7i8ON4ta/g68zuECXik1fQ80
         HGQUT45pSzo/35cBZbs0UH6Ukt1hlD87t8fwXqmUcvcQCo6+tBhTgHzApgpHls19qmmd
         LcSFtzvZDavI5ENSv1JVg0LttrZG5QLee23ZkoO98rXI+LNRpDCSo3SdcbxMyof9F65m
         EVXw==
X-Gm-Message-State: AOAM533/uE2GcIcSjUciTXq64vqwJimvjbq4d/bt41vvbwFYb7XNu8M0
        L4hy0x2Zg32TAukj6hyRoPx9jX0l26NHRjqa1bzo0aG1VQCFikWnSbzamQXfDQAZegun+T3DS7f
        npf1YxYVSm1WzxTOD
X-Received: by 2002:adf:ef4f:: with SMTP id c15mr4776057wrp.390.1601039148010;
        Fri, 25 Sep 2020 06:05:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjIUu+AqvdMvawTD89gHBSPDwwgP99Xel2vwLPcja/DDn/CM1AMK4Vq/fJA/OfBc1P4RKZow==
X-Received: by 2002:adf:ef4f:: with SMTP id c15mr4776024wrp.390.1601039147686;
        Fri, 25 Sep 2020 06:05:47 -0700 (PDT)
Received: from localhost ([151.66.98.27])
        by smtp.gmail.com with ESMTPSA id c25sm2754758wml.31.2020.09.25.06.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 06:05:46 -0700 (PDT)
Date:   Fri, 25 Sep 2020 15:05:43 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: mvneta: try to use in-irq pp cache in
 mvneta_txq_bufs_free
Message-ID: <20200925130543.GC32064@lore-desk>
References: <4f6602e98fdaef1610e948acec19a5de51fb136e.1601027617.git.lorenzo@kernel.org>
 <20200925125213.4981cff8@carbon>
 <CAJ0CqmV8OJoERhYktLNP7gYDwURs97JAmbsXq2jqKHhMoHk-pg@mail.gmail.com>
 <20200925140920.47bec9cf@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <20200925140920.47bec9cf@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 25 Sep 2020 13:29:00 +0200
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>=20
> > >
> > > On Fri, 25 Sep 2020 12:01:32 +0200
> > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > =20
> > > > Try to recycle the xdp tx buffer into the in-irq page_pool cache if
> > > > mvneta_txq_bufs_free is executed in the NAPI context. =20
> > >
> > > NACK - I don't think this is safe.  That is also why I named the
> > > function postfix rx_napi.  The page pool->alloc.cache is associated
> > > with the drivers RX-queue.  The xdp_frame's that gets freed could be
> > > coming from a remote driver that use page_pool. This remote drivers
> > > RX-queue processing can run concurrently on a different CPU, than this
> > > drivers TXQ-cleanup. =20
> >=20
> > ack, right. What about if we do it just XDP_TX use case? Like:
> >=20
> > if (napi && buf->type =3D=3D MVNETA_TYPE_XDP_TX)
> >    xdp_return_frame_rx_napi(buf->xdpf);
> > else
> >    xdp_return_frame(buf->xdpf);
> >=20
> > In this way we are sure the packet is coming from local page_pool.
>=20
> Yes, that case XDP_TX should be safe.
>=20
> > >
> > > If you want to speedup this, I instead suggest that you add a
> > > xdp_return_frame_bulk API. =20
> >=20
> > I will look at it
>=20
> Great!
>=20
> Notice that bulk return should be easy/obvious in most drivers, as they
> (like mvneta in mvneta_txq_bufs_free()) have a loop that process
> several TXQ completions.
>=20
> I did a quick tests on mlx5 with xdp_redirect_map and perf report shows
> __xdp_return calls at the top#1 overhead.
>=20
> # Overhead  CPU  Symbol                             =20
> # ........  ...  ....................................
> #
>      8.46%  003  [k] __xdp_return                   =20
>      6.41%  003  [k] dma_direct_map_page            =20
>      4.65%  003  [k] bpf_xdp_redirect_map           =20
>      4.58%  003  [k] dma_direct_unmap_page          =20
>      4.04%  003  [k] xdp_do_redirect                =20
>      3.53%  003  [k] __page_pool_put_page           =20
>      3.27%  003  [k] dma_direct_sync_single_for_cpu =20
>      2.63%  003  [k] dev_map_enqueue                =20
>      2.28%  003  [k] page_pool_refill_alloc_cache   =20
>      1.69%  003  [k] bq_enqueue.isra.0              =20
>      1.15%  003  [k] _raw_spin_lock                 =20
>      0.92%  003  [k] xdp_return_frame               =20
>=20
> Thus, there will be a benefit from implementing a bulk return.  Also
> for your XDP_TX case, as the overhead in __xdp_return also exist for
> rx_napi variant.

ack, I will post a v2 limiting the xdp_return_frame_rx_napi just for XDP_TX
use-case and then I will look at implementing a xdp bulk return.

Regards,
Lorenzo

>=20
>=20
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  drivers/net/ethernet/marvell/mvneta.c | 11 +++++++----
> > > >  1 file changed, 7 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/et=
hernet/marvell/mvneta.c
> > > > index 14df3aec285d..646fbf4ed638 100644
> > > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > > @@ -1831,7 +1831,7 @@ static struct mvneta_tx_queue *mvneta_tx_done=
_policy(struct mvneta_port *pp,
> > > >  /* Free tx queue skbuffs */
> > > >  static void mvneta_txq_bufs_free(struct mvneta_port *pp,
> > > >                                struct mvneta_tx_queue *txq, int num,
> > > > -                              struct netdev_queue *nq)
> > > > +                              struct netdev_queue *nq, bool napi)
> > > >  {
> > > >       unsigned int bytes_compl =3D 0, pkts_compl =3D 0;
> > > >       int i;
> > > > @@ -1854,7 +1854,10 @@ static void mvneta_txq_bufs_free(struct mvne=
ta_port *pp,
> > > >                       dev_kfree_skb_any(buf->skb);
> > > >               } else if (buf->type =3D=3D MVNETA_TYPE_XDP_TX ||
> > > >                          buf->type =3D=3D MVNETA_TYPE_XDP_NDO) {
> > > > -                     xdp_return_frame(buf->xdpf);
> > > > +                     if (napi)
> > > > +                             xdp_return_frame_rx_napi(buf->xdpf);
> > > > +                     else
> > > > +                             xdp_return_frame(buf->xdpf);
> > > >               }
> > > >       }
> > > >
> > > > @@ -1872,7 +1875,7 @@ static void mvneta_txq_done(struct mvneta_por=
t *pp,
> > > >       if (!tx_done)
> > > >               return;
> > > >
> > > > -     mvneta_txq_bufs_free(pp, txq, tx_done, nq);
> > > > +     mvneta_txq_bufs_free(pp, txq, tx_done, nq, true);
> > > >
> > > >       txq->count -=3D tx_done;
> > > >
> > > > @@ -2859,7 +2862,7 @@ static void mvneta_txq_done_force(struct mvne=
ta_port *pp,
> > > >       struct netdev_queue *nq =3D netdev_get_tx_queue(pp->dev, txq-=
>id);
> > > >       int tx_done =3D txq->count;
> > > >
> > > > -     mvneta_txq_bufs_free(pp, txq, tx_done, nq);
> > > > +     mvneta_txq_bufs_free(pp, txq, tx_done, nq, false);
> > > >
> > > >       /* reset txq */
> > > >       txq->count =3D 0; =20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX23rJAAKCRA6cBh0uS2t
rNbYAP0QukQ2dzh+MpXJIOws/Xmmh3wb5mzAiCzMAbrYavOx5gD/cV7PjPKVFIgh
GAkbvWQg7yiVYn/B0Lxwwwo1wnIxnAk=
=FIq6
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--

