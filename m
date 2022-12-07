Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9646455E8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiLGI6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiLGI6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:58:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484EFCF1
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 00:58:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66E9760C50
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 08:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41997C433D6;
        Wed,  7 Dec 2022 08:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670403518;
        bh=o8tZrvK0J0P/JKRm6LB0DBzv4jgBVUZuv4G7hsPps7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KmPO8b0GFlx+Ukr+O1qynnKPOTDaDOamPLCe+itUZUIASltdSR7cLWZ/iP1qz1zpx
         NRFPlfgcdT30diYfrlwQcbQLoIoI8sWr2wvNg+8yoiTkM7qvUNLJXaOs2fgkQ9+/5b
         igzRpDj9elRu3iFH1n5Fxdn9tykincIpoI00KPe/YIonjGqMeeYtTF/YoX9mlQmCJO
         wftEXcafmPCTe6oQT5klkj4KTPvLn1r6NJrhp+R7n+Ug90008zQG2wvEiBSSyKTd1I
         DLIBZCAlBzq2hYs5CBaXq70iISErfkF2sYmf5NA1Q7eWNog6mZNDJRMRGV7hl6cU29
         0sZnsC7WxSn2A==
Date:   Wed, 7 Dec 2022 09:58:34 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix possible deadlock
 if mtk_wed_wo_init fails
Message-ID: <Y5BVunJ8Ti8xJ2IC@lore-desk>
References: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
 <Y4ybbkn+nXkGsqWe@unreal>
 <Y4y4If8XXu+wErIj@lore-desk>
 <Y42d2us5Pv1UqhEj@unreal>
 <Y420B4/IpwFHJAck@lore-desk>
 <20221205174441.30741550@kernel.org>
 <Y4/VvGi2d0/0RrRW@lore-desk>
 <20221206172426.7e7cf3bf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xGqROEpnmGaA3qcp"
Content-Disposition: inline
In-Reply-To: <20221206172426.7e7cf3bf@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xGqROEpnmGaA3qcp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 7 Dec 2022 00:52:28 +0100 Lorenzo Bianconi wrote:
> > > FWIW, that does seem slightly better to me as well.
> > > Also - aren't you really fixing multiple issues here=20
> > > (even if on the same error path)? The locking,=20
> > > the null-checking and the change in mtk_wed_wo_reset()? =20
> >=20
> > wo NULL pointer issue was not hit before for the deadlock one (so I fix=
ed them
> > in the same patch).
> > Do you prefer to split them in two patches? (wo null pointer fix first).
>=20
> Yes, I think they are different issues even if once "covers" the other.
> I think it'd make the review / judgment easier.

ok, I will post v3 splitting them.

Regards,
Lorenzo

>=20
> > I have posted v2 addressing Leon's comments but I need to post a v3 to =
add
> > missing WARN_ON.
>=20

--xGqROEpnmGaA3qcp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY5BVugAKCRA6cBh0uS2t
rLa0AQDr9p6ivLFrnHACTcfdjevTsoR9cGUxKSDcoH6EbgAjPQD7BRctA4SvOLuz
iZze5NPep21OFwCC4dfwBpT8egj+9wI=
=J7uz
-----END PGP SIGNATURE-----

--xGqROEpnmGaA3qcp--
