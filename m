Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989CE64B186
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 09:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiLMIvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 03:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234807AbiLMIu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 03:50:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D30D1B9D5
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 00:50:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3CFD61349
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB28C433EF;
        Tue, 13 Dec 2022 08:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670921434;
        bh=IezD4oqy6n8FBwqQnQ09WRFgPg8UkBT00pjPJB/eXqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZQqsbbMnDQwwRQaZflylJzDe5cj/YDX+szT51XRGovK2tUozuxwvhXVhsNYgVUJxX
         TOB5IlVkan3eijMhlirPhsEciPd9DbFfmZBNV+kTNHkzbf1luwhD+2vvW2FCvwadZz
         oupdOKmehPGoMpTBFrcR1rwKQepv3VZ/b56DFJJxlQOmMAnBupHHCQ61UCoqXOdMvs
         ZxiUgU8YzdVTakYDLN4242YR1dYp2TuQGei+4GkAx3RBrrqVhLCYg2OzZyV8lrqqDX
         m/F3jAlPttqUk3U7RNilYuriOo6Q+tuZe2wEOCO4vnH026wzhcC0Qk1GluIK1ygI2G
         NmPN2/turUFVw==
Date:   Tue, 13 Dec 2022 09:50:30 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v3 net-next 0/2] enetc: unlock XDP_REDIRECT for XDP
 non-linear
Message-ID: <Y5g81tvyH6SJg26E@lore-desk>
References: <cover.1670680119.git.lorenzo@kernel.org>
 <20221212195130.w2f5ykiwek4jrvqu@skbuf>
 <Y5eZ87w4EKnmWFuW@lore-desk>
 <20221213003041.jgdotdqbodec2toz@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Fl8/b6odHSfX0K+P"
Content-Disposition: inline
In-Reply-To: <20221213003041.jgdotdqbodec2toz@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Fl8/b6odHSfX0K+P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Dec 12, 2022 at 10:15:31PM +0100, Lorenzo Bianconi wrote:
> > Hi Vladimir,
> >=20
> > thx for testing. If we perform XDP_REDIRECT with SG XDP frames, the dev=
map
> > code will always return an error and the driver is responsible to free =
the
> > pending pages. Looking at the code, can the issue be the following?
> >=20
> > - enetc_flip_rx_buff() will unmap the page and set rx_swbd->page =3D NU=
LL if
> >   the page is not reusable.
> > - enetc_xdp_free() will not be able to free the page since rx_swbd->pag=
e is
> >   NULL.
> >=20
> > What do you think? I am wondering if we have a similar issue for 'linea=
r' XDP
> > buffer as well when xdp_do_redirect() returns an error. What do you thi=
nk?
>=20
> A bit more complicated, but that's the gist, yes. Thanks for the hint.
> I was quite sure that this situation does not lead to a leak, because
> even though rx_swbd->page becomes NULL, the reference to it is not lost.
> But wrong I was. Not sure if you pointed out the condition where the
> page is not reusable because that's the only part that's problematic,
> or because you simply didn't notice that enetc_put_rx_buff() makes
> rx_swbd->page =3D NULL too. In any case, it's normally quite rare for a
> page to not be reusable, yet in this case, the way in which the page
> becomes non reusable is the key to the bug.
>=20
> Anyway, I've tested your patch set again with that fixed, and also
> submitted the fix here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20221213001908.23470=
46-1-vladimir.oltean@nxp.com/
>=20
> It works as it should now. And yes, the issue should also be
> reproducible with single buffer XDP, if we redirect to a devmap which
> doesn't implement ndo_xdp_xmit or is down, for example.

ack, cool now it is fixed. I will repost the series when net-next is open
adding your tested-by.

Regards,
Lorenzo

--Fl8/b6odHSfX0K+P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY5g81gAKCRA6cBh0uS2t
rCyXAQDDdmR/+4wsm1X35J0O11YPl1a+e0ZLWQ24l0z7j+fWcwEAwqhV7JKEmxVY
pvbLQvC6KKSZWTyvuCuXLQzI2IVjPgQ=
=hbBD
-----END PGP SIGNATURE-----

--Fl8/b6odHSfX0K+P--
