Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB98E4BB727
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbiBRKpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:45:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbiBRKpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:45:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2C02B3AE9
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 02:45:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nL0lE-0007Wy-FR; Fri, 18 Feb 2022 11:45:12 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9A31436EAB;
        Fri, 18 Feb 2022 10:45:07 +0000 (UTC)
Date:   Fri, 18 Feb 2022 11:45:04 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>, kernel@axis.com,
        Lars Persson <larper@axis.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Enable NAPI before interrupts go live
Message-ID: <20220218104504.62sfwbc4yoaceqdw@pengutronix.de>
References: <20220217145527.2696444-1-vincent.whitchurch@axis.com>
 <20220217203604.39e318d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="h4oitkp7lwuotckt"
Content-Disposition: inline
In-Reply-To: <20220217203604.39e318d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--h4oitkp7lwuotckt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.02.2022 20:36:04, Jakub Kicinski wrote:
> On Thu, 17 Feb 2022 15:55:26 +0100 Vincent Whitchurch wrote:
> > From: Lars Persson <larper@axis.com>
> >=20
> > The stmmac_open function has a race window between enabling the RX
> > path and its interrupt to the point where napi_enabled is called.
> >=20
> > A chatty network with plenty of broadcast/multicast traffic has the
> > potential to completely fill the RX ring before the interrupt handler
> > is installed. In this scenario the single interrupt taken will find
> > napi disabled and the RX ring will not be processed. No further RX
> > interrupt will be delivered because the ring is full.
> >=20
> > The RX stall could eventually clear because the TX path will trigger a
> > DMA interrupt once the tx_coal_frames threshold is reached and then
> > NAPI becomes scheduled.
>=20
> LGTM, although now the ndo_open and ndo_stop paths are not symmetrical.
> Is there no way to mask the IRQs so that they don't fire immediately?
> More common flow (IMO) would be:
>  - request irq
>  - mask irq

I think you can merge these, to avoid a race condition, see:

| cbe16f35bee6 genirq: Add IRQF_NO_AUTOEN for request_irq/nmi()

>  - populate rings
>  - start dma
>  - enable napi
>  - unmask irq
> Other than the difference in flow between open/stop there may also be
> some unpleasantness around restarting tx queues twice with the patch
> as is.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--h4oitkp7lwuotckt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIPeK0ACgkQrX5LkNig
011lEAf/ceZBFk9BF55mTJawpi5z5TpEgwyp84woyMIdPDmhW3IArp/mlLOJTaMF
7lcjuYVsoI2YmLM5uuk8XFrI/+7ajWtphtGFcks3RxEMR3/GoSPdY8UI5Z4bdMT8
c0dMjvNeD77ha6lQ2ZUHflAaBzCbtRctty+f8nxqVix/uI2xLQ4AAgehs079auMh
+yEBwQ8WWBF5UWdLCcLe9zqcQ5NPHMLfPiiHLA3VLUr8ilDTcp1gy613RDzHRPnj
qGvowf3Kwa4jAN0LISa1kJ1/4OsezXdrTvUTwfns6JxvP/PmktSX0ENg6jVKefds
vIR5lSdqHX0L74ub2GLCNXqf7rJCdw==
=WZKK
-----END PGP SIGNATURE-----

--h4oitkp7lwuotckt--
