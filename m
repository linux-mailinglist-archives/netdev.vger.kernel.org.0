Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BF522757E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgGUCQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGUCQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:16:33 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7936DC061794;
        Mon, 20 Jul 2020 19:16:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B9hzg5GdJz9sSy;
        Tue, 21 Jul 2020 12:16:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595297792;
        bh=MQhPK7Of38NS8E7kuszvHDn+nGkfoaSvpuI3ArH4y9Q=;
        h=Date:From:To:Cc:Subject:From;
        b=ZnMB6Iyl47yKHcqQyhqk+mGM2pbKzrlLhiY3PO3kKliNhBdpYK1vSMeakAvg7nQzJ
         SAuneqXJOdh+2rLEry9qVzYDn4u2qKozLhWyKPNZihA5zU4LAMDHBaCO63Lb9gsdOV
         z5G7dqOHOnnscCZUtxGvWsf1Z19En0UNVLEot9ovjg0FewfbTvmpvmd7WDPf8EiftG
         kmtVzv0RFHeCc1wajOH43vLfROKoMj2gHf9/V5M7ElmghWmyDZapBZo6Ry13LjVpc0
         eTbg/k7ZQ4UNCyiQZUvLzcZ3yqOoTGw65L8ErAUEv6QjHZxzZ7Xce141GXR5dFLetN
         Y/37dN0uOLgbA==
Date:   Tue, 21 Jul 2020 12:16:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20200721121630.5c06c492@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/AuQAVy0q=OC.ztWpD/zw4rg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/AuQAVy0q=OC.ztWpD/zw4rg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  include/net/xdp.h

between commit:

  2f0bc54ba9a8 ("xdp: introduce xdp_get_shared_info_from_{buff, frame} util=
ity routines")

from the net-next tree and commits:

  9216477449f3 ("bpf: cpumap: Add the possibility to attach an eBPF program=
 to cpumap")
  28b1520ebf81 ("bpf: cpumap: Implement XDP_REDIRECT for eBPF programs atta=
ched to map entries")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/net/xdp.h
index d3005bef812f,5be0d4d65b94..000000000000
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@@ -104,15 -98,12 +104,21 @@@ struct xdp_frame=20
  	struct net_device *dev_rx; /* used by cpumap */
  };
 =20
 +static inline struct skb_shared_info *
 +xdp_get_shared_info_from_frame(struct xdp_frame *frame)
 +{
 +	void *data_hard_start =3D frame->data - frame->headroom - sizeof(*frame);
 +
 +	return (struct skb_shared_info *)(data_hard_start + frame->frame_sz -
 +				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 +}
 +
+ struct xdp_cpumap_stats {
+ 	unsigned int redirect;
+ 	unsigned int pass;
+ 	unsigned int drop;
+ };
+=20
  /* Clear kernel pointers in xdp_frame */
  static inline void xdp_scrub_frame(struct xdp_frame *frame)
  {

--Sig_/AuQAVy0q=OC.ztWpD/zw4rg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8WT/8ACgkQAVBC80lX
0GxOXAf+J1KJ5i8wnn1+rkxAbVQ9INjgIUPb+TNOyxa85tHHyjgCiEehBsbscQoj
42c2xq42+xI7Z+AJ7VQ0iZJaQlM8usG7d0SOvi+zynyEynycjOc4hYlxWnkNPhK+
0hAidcIOwJsG6B0dRKlLDiQNDUAt4bX5p7hX+BohAEdKvHYYyPpAFr0WTeLe/NR8
wS7d2Y8oexfg+QlHtRZ4fmhzbRqo8BwuZk5nIsd6Oha+mO5qr+3d/a/RRY0hAjna
tUPAcDpfaHgEY50/832Y3RytnGY+GUWccHXdYO+vEUQKJmkzIL50J9uN9NUTAt08
DR+eiHOItK73iq42vitUtAG0cAj2fQ==
=xwir
-----END PGP SIGNATURE-----

--Sig_/AuQAVy0q=OC.ztWpD/zw4rg--
