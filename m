Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C2A6E311A
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 13:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjDOLQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 07:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjDOLQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 07:16:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BEB3AAE
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 04:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B08666102C
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 11:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96336C433D2;
        Sat, 15 Apr 2023 11:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681557404;
        bh=PkJlTawFM67Hk6ioINwM+eHjcnQFwbM4MaJMaD+iSb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oos7g3en27IXSwwCK+8dmnZteiDoekGYq4JSjugHXJCFGD2G+XlvZp5ReXHuASoJv
         1hKQTZ6OAUtwgsIi36r6KRPyvtI4mTJ9FHQLAdeye3Gn5Mvquq8A5IQlbwAiIbv5Qq
         IddnsAyHowhG/q9Z5vxy9HXSCMQpULoWyzMMZHCJV+8l7gvqhWcAzLxJ++D7xbtNXf
         0edgwXJg+uECk1oYmBj0LD+24SjZITGZ4gCKoPcb3oJKiHPAlBsynRqLgzxG0llQws
         WfjsGhIR89ywT+YZJDU+CBrbjy9xz1hqYnN3FtNIOQaP5w9TNQZcdr+vIW12GhI59b
         2u7uwHnpuD6YQ==
Date:   Sat, 15 Apr 2023 13:16:40 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: page_pool: add pages and released_pages
 counters
Message-ID: <ZDqHmCX7D4aXOQzl@lore-desk>
References: <a20f97acccce65d174f704eadbf685d0ce1201af.1681422222.git.lorenzo@kernel.org>
 <20230414184653.21b4303d@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VQCj+tTcV8zaDR4+"
Content-Disposition: inline
In-Reply-To: <20230414184653.21b4303d@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--VQCj+tTcV8zaDR4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 13 Apr 2023 23:46:03 +0200 Lorenzo Bianconi wrote:
> > @@ -411,6 +417,7 @@ static struct page *__page_pool_alloc_pages_slow(st=
ruct page_pool *pool,
> >  		pool->pages_state_hold_cnt++;
> >  		trace_page_pool_state_hold(pool, page,
> >  					   pool->pages_state_hold_cnt);
> > +		alloc_stat_inc(pool, pages);
> >  	}
> > =20
> >  	/* Return last page */
>=20
> What about high order? If we use bulk API for high order one day,=20
> will @slow_high_order not count calls like @slow does? So we should
> bump the new counter for high order, too.

yes, right. AFAIU "slow_high_order" and "slow" just count number of
pages returned to the pool consumer and not the number of pages
allocated to the pool (as you said, since we do not use bulking
for high_order allocation there is no difference at the moment).
What I would like to track is the number of allocated pages
(of any order) so I guess we can just increment "pages" counter in
__page_pool_alloc_page_order() as well. Agree?

>=20
> Which makes it very similar to pages_state_hold_cnt, just 64bit...

do you prefer to use pages_state_hold_cnt instead of adding a new
pages counter?

Regards,
Lorenzo


--VQCj+tTcV8zaDR4+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZDqHmAAKCRA6cBh0uS2t
rJNFAQCjLoP/mBy2be+DFUf+2Tr9i5PktxN53NtBU4X7TpDp7gEAtnMMaYnrEzY9
bGlT2emwpO10tQcxTp9JjUcLwh2GEAs=
=dfgg
-----END PGP SIGNATURE-----

--VQCj+tTcV8zaDR4+--
