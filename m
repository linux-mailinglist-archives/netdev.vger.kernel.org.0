Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947BD4F77EA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242021AbiDGHpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiDGHpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:45:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5EE114FF9
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:43:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FDFE61E23
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 07:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01448C385A4;
        Thu,  7 Apr 2022 07:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649317395;
        bh=7oAl12c6ecWJwVDG17piR46TelZ7cPNti7AaL18/ZoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QLnl/AWmry/BD2ziiuj1Qe4lZX7mPMHyqpA2fPbemjJ4pSA/qCnE7kboyP+HqZnWb
         h/QS7SLq4qEYsHr6m5TDANTYcb7vsnZosFgyoeYB+/dmzXk5B5FGiiClmlmsu5HIUq
         tlXGtx9NiKRdNy3kWNit2bEJZJ+61lMc1uN4QnA7TkUZ/+NgyNUpgpEDAy5Pj4ETqM
         V4thVE7KBIxBplEL7129qHLLx6Z+N6TZK2b3JpqHBS8P4FPYeN4d+Hwxuft2HL5ZUF
         H7jOec8NN80PiaCOYUZE1OGRPtqoxISCsv3ocSoVEy0QhxIE5xpvhquLZHJaiZGqJO
         HE5j8mAxzfE/w==
Date:   Thu, 7 Apr 2022 09:43:11 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] page_pool: Add recycle stats to
 page_pool_put_page_bulk
Message-ID: <Yk6WD+rEIdWL8tpW@lore-desk>
References: <1921137145a6a20bb3494c72b33268f5d6d86834.1649191881.git.lorenzo@kernel.org>
 <20220406231512.GB96269@fastly.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YiYUia7dnPzI7s6p"
Content-Disposition: inline
In-Reply-To: <20220406231512.GB96269@fastly.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YiYUia7dnPzI7s6p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Apr 05, 2022 at 10:52:55PM +0200, Lorenzo Bianconi wrote:
> > Add missing recycle stats to page_pool_put_page_bulk routine.
>=20
> Thanks for proposing this change. I did miss this path when adding
> stats.
>=20
> I'm sort of torn on this. It almost seems that we might want to track
> bulking events separately as their own stat.
>=20
> Maybe Ilias has an opinion on this; I did implement the stats, but I'm not
> a maintainer of the page_pool so I'm not sure what I think matters all
> that much ;)=20
>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/core/page_pool.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 1943c0f0307d..4af55d28ffa3 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -36,6 +36,12 @@
> >  		this_cpu_inc(s->__stat);						\
> >  	} while (0)
> > =20
> > +#define recycle_stat_add(pool, __stat, val)						\
> > +	do {										\
> > +		struct page_pool_recycle_stats __percpu *s =3D pool->recycle_stats;	\
> > +		this_cpu_add(s->__stat, val);						\
> > +	} while (0)
> > +
> >  bool page_pool_get_stats(struct page_pool *pool,
> >  			 struct page_pool_stats *stats)
> >  {
> > @@ -63,6 +69,7 @@ EXPORT_SYMBOL(page_pool_get_stats);
> >  #else
> >  #define alloc_stat_inc(pool, __stat)
> >  #define recycle_stat_inc(pool, __stat)
> > +#define recycle_stat_add(pool, __stat, val)
> >  #endif
> > =20
> >  static int page_pool_init(struct page_pool *pool,
> > @@ -566,9 +573,13 @@ void page_pool_put_page_bulk(struct page_pool *poo=
l, void **data,
> >  	/* Bulk producer into ptr_ring page_pool cache */
> >  	page_pool_ring_lock(pool);
> >  	for (i =3D 0; i < bulk_len; i++) {
> > -		if (__ptr_ring_produce(&pool->ring, data[i]))
> > -			break; /* ring full */
> > +		if (__ptr_ring_produce(&pool->ring, data[i])) {
> > +			/* ring full */
> > +			recycle_stat_inc(pool, ring_full);
> > +			break;
> > +		}
> >  	}
> > +	recycle_stat_add(pool, ring, i);
>=20
> If we do go with this approach (instead of adding bulking-specific stats),
> we might want to replicate this change in __page_pool_alloc_pages_slow; we
> currently only count the single allocation returned by the slow path, but
> the rest of the pages which refilled the cache are not counted.

Hi Joe,

do you mean to add an event like "bulk_ring_refill" and just count one for
this? I guess the "bulk_ring_refill" event is just a ring refill on "n" pag=
es
so I think it is more meaningful to increment ring refill counter of "n".
What do you think?

Regards,
Lorenzo

>=20
> >  	page_pool_ring_unlock(pool);
> > =20
> >  	/* Hopefully all pages was return into ptr_ring */
> > --=20
> > 2.35.1
> >=20

--YiYUia7dnPzI7s6p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYk6WDwAKCRA6cBh0uS2t
rN3kAP9idYxjiE/avp9VA5UP893N/1iknTHPZ/liCLtVqEwEwQEA+sgHnXQYu6gq
INX3O7Ejz88vc0O81bgN0WRNBKplqA8=
=RGwB
-----END PGP SIGNATURE-----

--YiYUia7dnPzI7s6p--
