Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC22644FD3
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLFXwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLFXwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:52:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8968AB77
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:52:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42891B81BA6
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 23:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C76C4347C;
        Tue,  6 Dec 2022 23:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670370751;
        bh=+7iMz5Ov6HdWwupKL/7aGdoMC453p3MLaqq2MFbXMj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b7WXZg9pzzpUsN/MDiCdexUPTZPokYl+CfyEW3iZBEzC/FkwfEPzxwgdJsV637+U9
         oAxLkDwGZCLmEJXXXHxRTpr4niYmzT9cTaMieHg++m7tPS3IaXW++zaoldg9aDG1Pq
         HNdZtKLiraobVdgzT5cGj1qc6Z211lx863Yy/TKwk3kE/uJNO7jugVcRUPe0qv6IkI
         klWyEE/E+sg/bfeW/qNKus3x1H0qG873pwacTvNBfqYUcQIQbZqzxRux3226BRfydI
         sOQfT2V99Ip4LEs0qH6RGr7Vn2TWXn0KzcI4YILUetnXPbiAUOeMjx+N1qLbSFSemq
         A7AGRhw6/tdvA==
Date:   Wed, 7 Dec 2022 00:52:28 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix possible deadlock
 if mtk_wed_wo_init fails
Message-ID: <Y4/VvGi2d0/0RrRW@lore-desk>
References: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
 <Y4ybbkn+nXkGsqWe@unreal>
 <Y4y4If8XXu+wErIj@lore-desk>
 <Y42d2us5Pv1UqhEj@unreal>
 <Y420B4/IpwFHJAck@lore-desk>
 <20221205174441.30741550@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="J2sYSVOsyacBCi4m"
Content-Disposition: inline
In-Reply-To: <20221205174441.30741550@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J2sYSVOsyacBCi4m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > > IMHO, it is a culprit, proper error unwind means that you won't call =
to
> > > uninit functions for something that is not initialized yet. It is bet=
ter
> > > to fix it instead of adding "if (!wo) ..." checks. =20
> >=20
> > So, iiuc, you would prefer to do something like:
> >=20
> > __mtk_wed_detach()
> > {
> > 	...
> > 	if (mtk_wed_get_rx_capa(dev) && wo) {
> > 		mtk_wed_wo_reset(dev);
> > 		mtk_wed_free_rx_rings(dev);
> > 		mtk_wed_wo_deinit(hw);
> > 	}
> > 	...
> > =09
> > Right? I am fine both ways :)
>=20
> FWIW, that does seem slightly better to me as well.
> Also - aren't you really fixing multiple issues here=20
> (even if on the same error path)? The locking,=20
> the null-checking and the change in mtk_wed_wo_reset()?

wo NULL pointer issue was not hit before for the deadlock one (so I fixed t=
hem
in the same patch).
Do you prefer to split them in two patches? (wo null pointer fix first).

I have posted v2 addressing Leon's comments but I need to post a v3 to add
missing WARN_ON.

Regards,
Lorenzo

--J2sYSVOsyacBCi4m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY4/VvAAKCRA6cBh0uS2t
rB8qAQDGVtf8g6SfAZiVQyyevkk8CtXG67JxqFxrzOOVD09TgwD/aoq4Xf1f56Au
miGn63kIKOn4R4YaEKTgk/ZT0dMGtgA=
=g4Hl
-----END PGP SIGNATURE-----

--J2sYSVOsyacBCi4m--
