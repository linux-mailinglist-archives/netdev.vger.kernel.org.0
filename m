Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36586E53DD
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 23:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjDQVbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 17:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjDQVbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 17:31:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90B544B4;
        Mon, 17 Apr 2023 14:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4368862AA3;
        Mon, 17 Apr 2023 21:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BBBC433EF;
        Mon, 17 Apr 2023 21:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681767065;
        bh=X7/XKh0tfw2LkGLYNbrUS3Ifq5cyxuxuTvnfPsqt4aw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mx7rns5lAtVCbqsjB3rINNj1hvjiO7pO/QZqRlySjdkfNvrNY9/nWfoXUx335CrN3
         FzrNZgCFPZvDT3nKkX+yykp54wsGWJfa1vWQHKH3K2PQXR+ZojcBViBlVggFXDjmC+
         ogVwmZl75gi3PgPjZXhRiaCkW1HYp+Zvuai54mYq2bXabVIw0KBRWFUpwM/Nu5fnWo
         m6xz8KBCTC+XLZzYznLFk89Ko1m7RoWFI1T7/3Z1AggrXjewY0y8z5JrAdYhq0H/Iu
         mEa4KfCC7jJrmYpzWkDQg/CvmYcECQNpze/A5C7mLKnEaiT/RS+bs7VcUGWJ0AQpKT
         GhljhOvf22TKg==
Date:   Mon, 17 Apr 2023 23:31:01 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: Re: issue with inflight pages from page_pool
Message-ID: <ZD26lb2qdsdX16qa@lore-desk>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
 <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
 <ZD2NSSYFzNeN68NO@lore-desk>
 <20230417112346.546dbe57@kernel.org>
 <ZD2TH4PsmSNayhfs@lore-desk>
 <20230417120837.6f1e0ef6@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SutYOmmiMl9JrJVi"
Content-Disposition: inline
In-Reply-To: <20230417120837.6f1e0ef6@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SutYOmmiMl9JrJVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 17 Apr 2023 20:42:39 +0200 Lorenzo Bianconi wrote:
> > > Is drgn available for your target? You could try to scan the pages on
> > > the system and see if you can find what's still pointing to the page
> > > pool (assuming they are indeed leaked and not returned to the page
> > > allocator without releasing :() =20
> >=20
> > I will test it but since setting sysctl_skb_defer_max to 0 fixes the is=
sue,
> > I think the pages are still properly linked to the pool, they are just =
not
> > returned to it. I proved it using the other patch I posted [0] where I =
can see
> > the counter of returned pages incrementing from time to time (in a very=
 long
> > time slot..).
>=20
> If it's that then I'm with Eric. There are many ways to keep the pages
> in use, no point working around one of them and not the rest :(

I was not clear here, my fault. What I mean is I can see the returned
pages counter increasing from time to time, but during most of tests,
even after 2h the tcp traffic has stopped, page_pool_release_retry()
still complains not all the pages are returned to the pool and so the
pool has not been deallocated yet.
The chunk of code in my first email is just to demonstrate the issue
and I am completely fine to get a better solution :) I guess we just
need a way to free the pool in a reasonable amount of time. Agree?

>=20
> > Unrelated to this issue, but debugging it I think a found a page_pool l=
eak in
> > skb_condense() [1] where we can reallocate the skb data using kmalloc f=
or a
> > page_pool recycled skb.
>=20
> I don't see a problem having pp_recycle =3D 1 and head in slab is legal.
> pp_recycle just means that *if* a page is from the page pool we own=20
> the recycling reference. A page from slab will not be treated as a PP
> page cause it doesn't have pp_magic set to the correct pattern.

ack, right. Thx for pointing this out.

Regards,
Lorenzo

--SutYOmmiMl9JrJVi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZD26lQAKCRA6cBh0uS2t
rPjVAQCHrFx3TcfwPeHcJL1jsHp7zocc30VFsZSmJOzk+JUWmQEAwEkzQH4m926X
anWg8h7IrJEOFZY+wiDK9jR0qpmjFgA=
=Ma8w
-----END PGP SIGNATURE-----

--SutYOmmiMl9JrJVi--
