Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4AC641D93
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 16:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiLDPJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 10:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLDPJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 10:09:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DE1F5B
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 07:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8F07B80066
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 15:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AD5C433D6;
        Sun,  4 Dec 2022 15:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670166565;
        bh=zaEl7zRMfpVqBV1L2UinSVoJVJecClXoYddjyKIbegE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IOx51a8KKFI5+y5K+sxnPq2EVwTtO0FHR4UFy6tuZLMVQZPpTaFhuLVN892d9NzAE
         NS6WcZ63Lzu9i3iP5539ZH3SoUArMCv2GwmeFSznEpzG4uATh56qoRpvM1rHbYkhvx
         DRH0L3z9y60ea3nB9Q4xMVNmkWqzDQAvIdFifnawt9Sr5Uql+pQFWM1Qy/Bm3PoNZc
         3Me5YOvpSbRs8Rme3ZaJ9BehFMS/UwYwDGG+s8BrNQ7DSSBUwEYIg2jfeBUYhfJw/T
         idfamotzw/ZiRSzM5/Rz6SyoDIamXPw609HOqZpaG2UHCnLk8qghDMCWFEziFM73es
         qrR3pHRdVawGQ==
Date:   Sun, 4 Dec 2022 16:09:21 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix possible deadlock
 if mtk_wed_wo_init fails
Message-ID: <Y4y4If8XXu+wErIj@lore-desk>
References: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
 <Y4ybbkn+nXkGsqWe@unreal>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FiFvvHc0xRrwB4HC"
Content-Disposition: inline
In-Reply-To: <Y4ybbkn+nXkGsqWe@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FiFvvHc0xRrwB4HC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Dec 02, 2022 at 06:36:33PM +0100, Lorenzo Bianconi wrote:
> > Introduce __mtk_wed_detach() in order to avoid a possible deadlock in
> > mtk_wed_attach routine if mtk_wed_wo_init fails.
> >=20
> > Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo supp=
ort")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_wed.c     | 24 ++++++++++++++-------
> >  drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 10 ++++++---
> >  drivers/net/ethernet/mediatek/mtk_wed_wo.c  |  3 +++
> >  3 files changed, 26 insertions(+), 11 deletions(-)
>=20
> <...>
>=20
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/=
ethernet/mediatek/mtk_wed_mcu.c
> > index f9539e6233c9..b084009a32f9 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > @@ -176,6 +176,9 @@ int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int=
 id, int cmd,
> >  	u16 seq;
> >  	int ret;
> > =20
> > +	if (!wo)
> > +		return -ENODEV;
>=20
> <...>
>=20
> >  static void
> >  mtk_wed_wo_hw_deinit(struct mtk_wed_wo *wo)
> >  {
> > +	if (!wo)
> > +		return;
>=20
> How are these changes related to the written in deadlock?
> How is it possible to get internal mtk functions without valid wo?

Hi Leon,

if mtk_wed_rro_alloc() fails in mtk_wed_attach(), we will end up running
__mtk_wed_detach() when wo struct is not allocated yet (wo is allocated in
mtk_wed_wo_init()).
Moreover __mtk_wed_detach() can run mtk_wed_wo_reset() and mtk_wed_wo_deini=
t()
so we will need to check if wo pointer is properly set. We will face the sa=
me
issue if wo allocation fails in mtk_wed_wo_init routine.
If we remove the deadlock we need to take into account even these condition=
s.

Regards,
Lorenzo

>=20
> Thanks
>=20
> > +
> >  	/* disable interrupts */
> >  	mtk_wed_wo_set_isr(wo, 0);
> > =20
> > --=20
> > 2.38.1
> >=20

--FiFvvHc0xRrwB4HC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY4y4IQAKCRA6cBh0uS2t
rNC1AP4uCyNvASYhxfjb8IiHvuONICL7rKSlK47wKTB1xSuQxAD9GoVT9OnQo2yG
SFi0uEVU+b8+P96tNAvn5NUk2BqIBwU=
=o4UA
-----END PGP SIGNATURE-----

--FiFvvHc0xRrwB4HC--
