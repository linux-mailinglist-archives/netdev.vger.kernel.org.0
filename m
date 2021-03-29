Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7ED34CE00
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhC2Ka5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhC2Kam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:30:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAD2C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 03:30:41 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1617013839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4XUKuDY4UHoIwwqGebIX/nAu3rjgida9J3DZWeqzZOk=;
        b=2fvkoDbm1Klb1SxpmuG/xjgC/8cTCbQT4O4GYgx8REmaFCWkGPiuDSi9IMLwiNqJKwyVEn
        89eV6KHoS8wDqXA73E4RMpLmLqMNtNV7S+gEEtAsQlhbo8cPA4G7CYSwFjz6CPzbcGYuUE
        1EwsHXQ6zRZ3lRCDY4PljQVn/PPxXzOz3q4wnLM6p3dribTDLHHgDnRU1JJJGoMokOI8hy
        vkLVHBH2FrBiKLkGN/2pQE4PBq9plga91c/ltQZyxofgvRVEqqnuGhdb++/Wx6ZvMKGGzE
        JexUVJMOWtxfSoANkMr+2RdbWnM5dTpyIOpl6CSfTjxvQ7XwlvUKgOn5gLCJmA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1617013839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4XUKuDY4UHoIwwqGebIX/nAu3rjgida9J3DZWeqzZOk=;
        b=2o45cTZr+34whC8KM6kEq5wRmWQeM62L0gfP0dB7zPQnz54YbvoW1sG7u5n2gmsdImgIxe
        8HcZJ5IjCvn0LRAA==
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] net: Reset MAC header for direct packet transmission
In-Reply-To: <CANn89iJfLQwADLMw6A9J103qM=1y3O6ki1hQMb3cDuJVrwAkrg@mail.gmail.com>
References: <20210329071716.12235-1-kurt@linutronix.de> <CANn89iJfLQwADLMw6A9J103qM=1y3O6ki1hQMb3cDuJVrwAkrg@mail.gmail.com>
Date:   Mon, 29 Mar 2021 12:30:37 +0200
Message-ID: <878s661cc2.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Mar 29 2021, Eric Dumazet wrote:
> Note that last year, I addressed the issue differently in commit
> 96cc4b69581db68efc9749ef32e9cf8e0160c509
> ("macvlan: do not assume mac_header is set in macvlan_broadcast()")
> (amended with commit 1712b2fff8c682d145c7889d2290696647d82dab
> "macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()")
>
> My reasoning was that in TX path, when ndo_start_xmit() is called, MAC
> header is essentially skb->data,
> so I was hoping to _remove_ skb_reset_mac_header(skb) eventually from
> the fast path (aka __dev_queue_xmit),
> because most drivers do not care about MAC header, they just use skb->dat=
a.
>
> I understand it is more difficult to review drivers instead of just
> adding more code in  __dev_direct_xmit()
>
> In hsr case, I do not really see why the existing check can not be
> simply reworked ?

It can be reworked, no problem. I just thought it might be better to add
it to the generic code just in case there are more drivers suffering
from the issue.

>
> mac_header really makes sense in input path, when some layer wants to
> get it after it has been pulled.
>
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index ed82a470b6e154be28d7e53be57019bccd4a964d..cda495cb1471e23e6666c1f2e=
9d27a01694f997f
> 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -555,11 +555,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct
> hsr_port *port)
>  {
>         struct hsr_frame_info frame;
>
> -       if (skb_mac_header(skb) !=3D skb->data) {
> -               WARN_ONCE(1, "%s:%d: Malformed frame (port_src %s)\n",
> -                         __FILE__, __LINE__, port->dev->name);
> -               goto out_drop;
> -       }
> +       skb_reset_mac_header(skb);

hsr_forward_skb() has four call sites. Three of them make sure that the
header is properly set. The Tx path does not. So, maybe something like
below?

Thanks,
Kurt

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 7444ec6e298e..bfcdc75fc01e 100644
=2D-- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -217,6 +217,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, st=
ruct net_device *dev)
        master =3D hsr_port_get_hsr(hsr, HSR_PT_MASTER);
        if (master) {
                skb->dev =3D master->dev;
+               skb_reset_mac_header(skb);
                hsr_forward_skb(skb, master);
        } else {
                atomic_long_inc(&dev->tx_dropped);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ed82a470b6e1..b218e4594009 100644
=2D-- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -555,12 +555,6 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_p=
ort *port)
 {
        struct hsr_frame_info frame;

=2D       if (skb_mac_header(skb) !=3D skb->data) {
=2D               WARN_ONCE(1, "%s:%d: Malformed frame (port_src %s)\n",
=2D                         __FILE__, __LINE__, port->dev->name);
=2D               goto out_drop;
=2D       }
=2D

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmBhrE0ACgkQeSpbgcuY
8KY45BAAkrwIlJ6AePjrZvfHrFrKpQBbM8J9KWGJ3vBHURWi1ngwZEQ1SBHc62E4
ujwgQiirw28mRMkVdfYBC79cKfNAcfvwFvY11KTEqek9fPxWM74NPfNJt1vItwCf
wSDnUbgpEjR+DChzYJUGg8HL2BDNg5mXNu3rlW59OrBup2htDRYDX+KjAgAqkwRf
bt8vKl/wdU9C7GvsRiB5sasIpp3A6z7YHXhZYwMqQ5ZsWjQPS9wB8vxhFdn7FPkr
+cbftDG5teQaEB6ktZGPbBQtCjs09r+zHTvaQJnRy0iwNzozmQeUDrsFfZFybv/b
Vq9Pkp8J9lS8K/1DfxQIURmxii067xbFo3XJ+vO3H7gE5wmR2DBNEiBaMr70tXCP
nLDf4cv+7sNlZnzEDJ2+/a6p+ZoEgwpNAHnt7EkmIgc/nfrxPvOCVs90+ZVsB6Lw
SVI0KkHT81Z9M2vEFif8AeqkpZHmBHkIKpWnbhaOUwdszBFSys4G37w2tkOllSfv
h598jMlt3RBycew9LZzrzL8fAUHFrjeQiIMs5C/8enwdhQ1G25WPHUy8eiZp+2vb
Q+OUiwtIA3RRoqTXvl2HZfKALrx4yLnrbd1iDq8d7lC1AE7fsxVjvMFWloSQsy5/
fo58Vtbn/d9SoKFvu8ViSKFBmC55SI+JdJiV0He+LhSddwmJ4M0=
=wiOT
-----END PGP SIGNATURE-----
--=-=-=--
