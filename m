Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAFF51AEC9
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354216AbiEDUPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377922AbiEDUPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:15:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96E414020;
        Wed,  4 May 2022 13:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83D49B828AA;
        Wed,  4 May 2022 20:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A07CC385A4;
        Wed,  4 May 2022 20:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651695081;
        bh=Qg91tBcD1wN6wCVZbNcaVdgDsBFAx4BdW5qUv0clohE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k0nauOa1Bj1fH+nV/tCxgCm53/f50EqRFFbXX4UmFurst9ceXSnSwFo6MIkAxragh
         5yQYzhmG8wkpd+8XsxO/UnET+q5d4bTEcRmHdIzQnV26/rAu3E5EzlLpm68LJwnnRo
         lYxNg9htFSZF5EpfdzVr99/HpOlGOq06xKt5uFJDchy2D3xpOLl+wqOOc/4n45ledU
         xv75a9RbRrPehvAAge7KNeOz0uOBKXeIYEMszDQ6nfZ/qjRuG0Lcm+U+vwdtnpNmLy
         0IR3U+IyFWaJ3IHq89KI2T09mhKcBa8U25/bKRyHdLTTLQhIpR50bnUIqRKtrl0ax3
         ACIXPXPsjTiDA==
Date:   Wed, 4 May 2022 22:11:18 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v1 2/4] powerpc/mpc5xxx: Switch
 mpc5xxx_get_bus_frequency() to use fwnode
Message-ID: <YnLd5lvmlgv6LmuU@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
References: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
 <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5kYQ0ef1AFwxM1LW"
Content-Disposition: inline
In-Reply-To: <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5kYQ0ef1AFwxM1LW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 04, 2022 at 04:44:47PM +0300, Andy Shevchenko wrote:
> Switch mpc5xxx_get_bus_frequency() to use fwnode in order to help
> cleaning up other parts of the kernel from OF specific code.
>=20
> No functional change intended.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Wolfram Sang <wsa@kernel.org> # for the I2C part


--5kYQ0ef1AFwxM1LW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmJy3eUACgkQFA3kzBSg
KbZC2Q/9HAv5wUkTBzMP5daIIk3LyMvlDsqR6gGOTpeHvdPasQpBF8ncPQZ8Hxjv
co5o3/oPS/t/Shwsks9LfPG1YkbqBjE6ETFyJEHeRaw4I9kxoGkkBZWLlB5DTSm+
Ms19PVmw9n4YtbryC4f9hp9oJORb581zX6PCbjHtt3JmJwc/xZZRx5rHvHLFMdRP
OiQIzpvpSPLC918gyiRWBJ2dTxoJ4C583qKzMtYm7bNHq+2Rh+aQ6tAwuKSfGOe/
804ae0+AH9V6GH+xr0cXfNULvOW3K8YWYWeGWBJoLfsqWOQWW18bIqJibJEyfu8u
1JNQDJHLzjozQpQmIktz+a00eabM3KLGRM3Yotg105GYl8iFhJ7OvCL03jdTTlVV
87lzkfi3vO0IrbG2GdUsHoE8XcoXa5HbnCMhoWppczIFaxvFlNDmO8cyu78O0u11
fDA7SVtfnYpTyZS4LvC5PNXxNrN2NVyGyLklQopXHzz0FXslFidsjALTmWvpUYbg
xZAS+y42lmIaBMzfeqehu5vSL1VGwExjfSPPLdQfuB0zxdjboUEsop6SgKN6nBro
bEsVptHCUWgF6d/zGaF5LaO6ydAPHwzqmfAJeEy3fDTDBrcRDciXZNf5FtYi5eP9
jDdX2vtBqp7uwKC4fEEuIwWQoz7cmyjxI4pHaxYi4oqiDGYNp8Y=
=F8ka
-----END PGP SIGNATURE-----

--5kYQ0ef1AFwxM1LW--
