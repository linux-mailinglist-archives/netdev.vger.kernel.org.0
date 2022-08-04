Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0595899BC
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 11:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbiHDJL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 05:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiHDJL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 05:11:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC7161D95
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 02:11:55 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oJWtE-0002xs-VD; Thu, 04 Aug 2022 11:11:37 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2F68AC2937;
        Thu,  4 Aug 2022 09:11:34 +0000 (UTC)
Date:   Thu, 4 Aug 2022 11:11:32 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
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
Message-ID: <20220804091132.qpmiulpjmvleiqqj@pengutronix.de>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <202208021820.17878.pisa@cmp.felk.cvut.cz>
 <20220803083718.7bh2edmsorwuv4vu@pengutronix.de>
 <202208041008.15122.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dzgkrvvap34d65mk"
Content-Disposition: inline
In-Reply-To: <202208041008.15122.pisa@cmp.felk.cvut.cz>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dzgkrvvap34d65mk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.08.2022 10:08:15, Pavel Pisa wrote:
> > > > Can the ctucan_skb_set_timestamp() and ctucan_read_timestamp_counte=
r()
> > > > happen concurrently? AFAICS they are all called from ctucan_rx_poll=
(),
> > > > right?
> > >
> > > I am not sure about which possible problem do you think.
> > > But ctucan_read_timestamp_counter() is fully reentrant
> > > and has no side effect on the core. So there is no
> > > problem.
> >
> > ctucan_read_timestamp_counter() is reentrant, but on 32 bit systems the
> > update of tc->cycle_last isn't.
> >
> > [...]
>=20
> Good catch, so we probably should use atomic there or we need to add
> spinlock, but I think that atomic is optimal solution there.

Atomic look like a good solution, but not scope of this patch, as the
timercounter needs to be modified. So use spinlocks for now.

> > > The need for clock running should be released in ctucan_suspend()
> > > and regained in ctucan_resume(). I see that the most CAN drivers
> > > use there clk_disable_unprepare/clk_prepare_enable but I am not
> > > sure, if this is right. Ma be plain clk_disable/clk_enable should
> > > be used for suspend and resume because as I understand, the clock
> > > frequency can be recomputed and reset during clk_prepare which
> > > would require to recompute bitrate. Do you have some advice
> > > what is a right option there?
> >
> > For the CAN clock, add a prepare_enable to ndo_open, corresponding
> > function to ndo_stop. Or better, add these time runtime_pm.
>=20
> Hmm, there is problem that we have single clock for whole design,
> so if we try to touch AXI/APB slave registers without clock setup
> then system blocks. So I think that we need to prepare and enable
> clocks in probe to allow registers access later.

ACK, enable clocks during probe, too. There are already pm_runtime calls
in the driver, but no runtime pm callback that handle the clocks.

BTW: that pm_enable_call argument to ctucan_probe_common() looks a bit
strange.

| int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, =
unsigned int ntxbufs,
| 			unsigned long can_clk_rate, int pm_enable_call,
| 			void (*set_drvdata_fnc)(struct device *dev, struct net_device *ndev))

I think the caller should setup the pm stuff so that the
ctucan_probe_common() can do a pm_runtime_get_sync(dev) call.

> We need it at least
> for core bus endian probe and version validation/quirks. May it be
> we can disable clocks and reenable them in open.... But it is
> a little risky play and needs to ensure that no other path
> in the closed driver can attempt to access registers.

Sure. There are basically 3 parts in the base driver to consider:
1) ctucan_probe_common()
2) ndo_open()...ndo_stop()
3) do_get_berr_counter()

> Due to use of AXI bridges and other peripherals in Zynq Programmable
> Logic (FPGA) we keep forcibly clock enabled. In the fact, this
> should be solved some way on level of APB (now renamed in Zynq DST
> to AXI) bus mapping.=20
>=20
> > Has system suspend/resume been tested? I think the IP core might be
> > powered off during system suspend, so the driver has to restore the
> > state of the chip. The easiest would be to run through
> > chip_start()/chip_stop().
>=20
> Hmm, if we do not reconfigure FPGA then it keeps state and if we
> lose configuration then whole cycle with DTS overlay is required.

Hardware IP cores might be powered down during system suspend and lose
their configuration. So you have to configure the CAN IP core again,
i.e. setup priorities, queues, bit timing, etc... Things that the
ctucan_chip_start() does. So I think ctucan_resume() must call to
ctucan_chip_start() if the interface was up while the system was
suspended.

> So basically for runtime power down wee need to unload overlay
> which removes driver instances and then reload  overlay and instances
> again...

I've never played with softcores before, but from the theory I don't
think you have to unload overlays etc...every driver needs to implement
proper suspend/resume functions.

> If you speak about suspend to disk, then I do not expect
> to run this way on any platform bus based system in near future.
> With PCIe card on PC it is possible... So it is other area to invest
> work in future...

:)

> > For the possible change of clock rate between probe and ifup, we should
> > add a CAN driver framework wide function to re-calculate the bitrates
> > with the current clock rate after the prepare_enable.
>=20
> ACK
>=20
> > BTW: In an early version of the stm32mp1 device tree some graphics clock
> > and the CAN clock shared the same parent clock. The configuration of the
> > display (which happened after the probe of the CAN driver ) caused a
> > different rate in the CAN clock, resulting in broken bit timings.
>=20
> So in the fact each CAN device should listen to the clock rate
> change notifier...

ACK - and strictly speaking clk_get_rate() of a clock that's not enabled
is not valid. But that's not enforced by the common clock framework.

> > > Actual omission is no problem on our systems, be the clock are used
> > > in whole FPGA system with AXI connection and has to running already
> > > and we use same for timestamping.
> > >
> > > I would prefer to allow timestamping patch as it is without clock ena=
ble
> > > and then correct clock enable, disable by another patch for both ts a=
nd
> > > core clocks.
> >
> > NACK - if the time stamping clock is added, please with proper handling.
> > The core clock can be fixed in a later patch.
>=20
> OK, how is it with your timing plans. I have already stated to Matej=20
> Vasilevski that slip of the patch sending after 5.19 release means
> that we would not fit in 5.20 probably.

net-next for 5.20 is closed.

> If it is so and you, then I
> expect that postpone of discussions, replies and thoughts about our
> work after 5.20 preparation calms down is preferred on your side.
> We focus on preparation of proper series for early 5.21/6.0 cycle.

I don't mind discussing things for 5.21 now. Everything for 5.20 is now
bug fixes only.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dzgkrvvap34d65mk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLrjUIACgkQrX5LkNig
011S1Qf8CPEgvlOxHSSrzUNvqiMw5zh7LaDHyeGfhTKek7Y8f0U+Bnva8QzumvdY
AYq7adWLmTORP1S/+FJgGem2ho2iQoNXb3+LsZipnbAMS71+eOgbBTnNqrFx9Yom
JSmBgjxHA0l/gBReyCcTwotGZm0qZ2RvmtedUZMTEJGIgfVr3QFvTFehfaQGDMpE
n1xKU5aWVoLl9vt/w2CDHEYlWyYyPKUvId1QJfvT9xVtw7FpTCmARA5VSvIrRPx7
NNsaCqKqbqvG2iGHwRbRh6GP7LgEVUA9keLb94nOeGI9tgRGFnorZ2qetimxf5Bq
281P0ySj0Byhghx5PcLTLD3TcgcLLw==
=T2wJ
-----END PGP SIGNATURE-----

--dzgkrvvap34d65mk--
