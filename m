Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C255980C7
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbiHRJZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiHRJZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:25:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8452B0B18
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 02:25:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oOblZ-0005dc-2X; Thu, 18 Aug 2022 11:24:41 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4D648CD62E;
        Thu, 18 Aug 2022 09:24:38 +0000 (UTC)
Date:   Thu, 18 Aug 2022 11:24:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220818092435.hchmowfaolxe2tlq@pengutronix.de>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz>
 <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
 <20220803000903.GB4457@hopium>
 <20220803085303.2u4l5l6wmualq33v@pengutronix.de>
 <20220817231434.GA157998@hopium>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4qtlqk4ha34rel2p"
Content-Disposition: inline
In-Reply-To: <20220817231434.GA157998@hopium>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4qtlqk4ha34rel2p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.08.2022 01:14:34, Matej Vasilevski wrote:
> Hello Marc,
>=20
> I have two questions before I send the next patch version, please
> bear with me.
>=20
> On Wed, Aug 03, 2022 at 10:53:03AM +0200, Marc Kleine-Budde wrote:
>=20
> [...]
>=20
> > > > > +	if (priv->timestamp_possible) {
> > > > > +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timest=
amp_freq,
> > > > > +				       NSEC_PER_SEC, CTUCANFD_MAX_WORK_DELAY_SEC);
> > > > > +		priv->work_delay_jiffies =3D
> > > > > +			ctucan_calculate_work_delay(timestamp_bit_size, timestamp_fre=
q);
> > > > > +		if (priv->work_delay_jiffies =3D=3D 0)
> > > > > +			priv->timestamp_possible =3D false;
> > > >=20
> > > > You'll get a higher precision if you take the mask into account, at
> > > > least if the counter overflows before CTUCANFD_MAX_WORK_DELAY_SEC:
> > > >=20
> > > >         maxsec =3D min(CTUCANFD_MAX_WORK_DELAY_SEC, priv->cc.mask /=
 timestamp_freq);
> > > > =09
> > > >         clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, tim=
estamp_freq, NSEC_PER_SEC,  maxsec);
> > > >         work_delay_in_ns =3D clocks_calc_max_nsecs(&priv->cc.mult, =
&priv->cc.shift, 0, &priv->cc.mask, NULL);
> > > >=20
> > > > You can use clocks_calc_max_nsecs() to calculate the work delay.
> > >=20
> > > This is a good point, thanks. I'll incorporate it into the patch.
> >=20
> > And do this calculation after a clk_prepare_enable(), see other mail to
> > Pavel
> > | https://lore.kernel.org/all/20220803083718.7bh2edmsorwuv4vu@pengutron=
ix.de/
>=20
>=20
> 1) I can't use clocks_calc_max_nsecs(), because it isn't exported
> symbol (and I get modpost error during linking). Is that simply an
> oversight on your end or I'm doing something incorrectly?

Oh, I haven't checked if clocks_calc_max_nsecs() is exported. You can
either create a patch to export it, or "open code" its functionality. I
think this should be more or less equivalent:

| work_delay_in_ns =3D clocksource_cyc2ns(mask, mult, shift) >> 1;

> I've also listed all the exported symbols from /kernel/time, and nothing
> really stood out to me as super useful for this patch. So I would
> continue using ctucan_calculate_work_delay().
>=20
> 2) Instead of using clk_prepare_enable() manually in probe, I've added
> the prepare_enable and disable_unprepare(ts_clk) calls into pm_runtime
> suspend and resume callbacks. And I call clk_get_rate(ts_clk) only after
> the pm_runtime_enable() and pm_runtime_get_sync() are called.

Use pm_runtime_resume_and_get(), see:

| https://elixir.bootlin.com/linux/v5.19/source/include/linux/pm_runtime.h#=
L419

> This
> seemed nicer to me, because the core clock prepare/unprepare will go
> into the pm_runtime callbacks too.

Sound good. If you rely on the runtime PM, please add a "depends on PM"
to the Kconfig. If you want/need to support configurations without
runtime PM, you have to do some extra work:

| https://elixir.bootlin.com/linux/v5.19/source/drivers/net/can/spi/mcp251x=
fd/mcp251xfd-core.c#L1860

In the mcp251xfd driver without runtime PM I enable the clocks and VDD
during probe() and keep them running until remove(). The idea is:

1) call clock_prepare_enable() manually
2) call pm_runtime_get_noresume(), which equal to
   pm_runtime_resume_and_get() but doesn't call the resume function
3) pm_runtime_enable()
4) pm_runtime_put()
   will call suspend with runtime PM enabled,
   will do nothing otherwise

Then use pm_runtime_resume_and_get() during open() and pm_runtime_put()
during stop(). Use both between accessing regs in do_get_berr_counter().

During remove it's a bit simpler:

| https://elixir.bootlin.com/linux/v5.19/source/drivers/net/can/spi/mcp251x=
fd/mcp251xfd-core.c#L1932

> Is that a correct approach, or should I really use the clk_prepare_enable=
()
> and clk_disable_unprepare() "manually" in ctucan_common_probe()/ctucan_ti=
mestamp_stop()?
>=20
> On my Zynq board I don't see the ctucan_resume() callback executed during=
 probe
> (after pm_runtime_enable() and pm_runtime_get_sync() are called in _probe=
()),

Is this a kernel without CONFIG_PM?

> but in theory it seems like the correct approach. Xilinx_can driver does =
this too.
> Other drivers (e.g. flexcan, mpc251xfd, rcar) call clk_get_rate() right a=
fter
> devm_clk_get() in probe, but maybe the situation there is different, I do=
n't
> know too much about clocks and pm_runtime yet.

The API says the clock must be enabled during clk_get_rate() (but that's
not enforced). And another problem is that the clock rate might change,
but let's ignore the clock rate change problem for now.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4qtlqk4ha34rel2p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmL+BVAACgkQrX5LkNig
013oTAf/X0uRNyeHKJ+6Clm0PtLxXHaXGF6vQemQJGO9HUiAubFTgwJ70JPSYER0
KrJnfW+UJZz9MPxJsNljKSqGQLU3+yXRP10hBLTHVGFhHFdSnRNITzbnBtbYdi0U
KbtmN0Mrl+z73CsubfizJpFaRfkEgUVUHQcV1YtXauSF2KFo5YCF4C70qtcxiMz6
O2QogTaVQ8sKlIEtW7y1Vn+4wlIZpiSZp4HHAnZxrJuo1iisYHk+MKONiXl5LEOp
vFZ4zjLvSOP8w3JfkEubMl++1ngjjCxGOupmzeK3UpJheDsIV4deTrBlaxnU5iSr
lWzwhkasxiwZWLAXIqHGN/YAL/L4HA==
=bS85
-----END PGP SIGNATURE-----

--4qtlqk4ha34rel2p--
