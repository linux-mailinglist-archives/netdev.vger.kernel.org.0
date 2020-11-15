Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CC32B3315
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 09:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgKOI44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 03:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgKOI44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 03:56:56 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 073752242E;
        Sun, 15 Nov 2020 08:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605430615;
        bh=XlDHcdsl532SN92xdtOqleWanacVK4C5l0LGG518skA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UPt0zKKVOB17S0lL9O3/xZIsjZwBnd/ahSRgC/zVMdLWyUKOvrj3fRsbxYY9Wc1HB
         SQgiN8oXcpOvNgITU/tJPLgkCbr4EOWs8urM8GSOzPD3YiSRAAR+I4P5hkIAe13dKv
         pCYIIWoMwG3FqXtixZkMDjNOT9GtqrD7xDD583dU=
Date:   Sun, 15 Nov 2020 09:56:48 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andreas =?UTF-8?B?RsOkcmJlcg==?= <afaerber@suse.de>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <uwe@kleine-koenig.org>,
        Michal Hrusecki <Michal.Hrusecky@nic.cz>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH net-next] net: mvneta: Fix validation of 2.5G HSGMII
 without comphy
Message-ID: <20201115095648.0af1c42b@kernel.org>
In-Reply-To: <4bf5376c-a7d1-17bf-1034-b793113b101e@suse.de>
References: <20201115004151.12899-1-afaerber@suse.de>
        <20201115010241.GF1551@shell.armlinux.org.uk>
        <4bf5376c-a7d1-17bf-1034-b793113b101e@suse.de>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 03:26:01 +0100
Andreas F=C3=A4rber <afaerber@suse.de> wrote:

> Hi Russell,
>=20
> On 15.11.20 02:02, Russell King - ARM Linux admin wrote:
> > On Sun, Nov 15, 2020 at 01:41:51AM +0100, Andreas F=C3=A4rber wrote: =20
> >> Commit 1a642ca7f38992b086101fe204a1ae3c90ed8016 (net: ethernet: mvneta:
> >> Add 2500BaseX support for SoCs without comphy) added support for 2500B=
aseX.
> >>
> >> In case a comphy is not provided, mvneta_validate()'s check
> >>   state->interface =3D=3D PHY_INTERFACE_MODE_2500BASEX
> >> could never be true (it would've returned with empty bitmask before),
> >> so that 2500baseT_Full and 2500baseX_Full do net get added to the mask=
. =20
> >=20
> > This makes me nervous. It was intentional that if there is no comphy
> > configured in DT for SoCs such as Armada 388, then there is no support
> > to switch between 1G and 2.5G speed. Unfortunately, the configuration
> > of the comphy is up to the board to do, not the SoC .dtsi, so we can't
> > rely on there being a comphy on Armada 388 systems. =20
>=20
> Please note that the if clause at the beginning of the validate function
> does not check for comphy at all. So even with comphy, if there is a
> code path that attempts to validate state 2500BASEX, it is broken, too.
>=20
> Do you consider the modification of both ifs (validate and power_up) as
> correct? Should they be split off from my main _NA change you discuss?
>=20
> > So, one of the side effects of this patch is it incorrectly opens up
> > the possibility of allowing 2.5G support on Armada 388 without a comphy
> > configured.
> >=20
> > We really need a better way to solve this; just relying on the lack of
> > comphy and poking at a register that has no effect on Armada 388 to
> > select 2.5G speed while allowing 1G and 2.5G to be arbitarily chosen
> > doesn't sound like a good idea to me. =20
> [snip]
>=20
> May I add that the comphy needs better documentation?
>=20
> Marek and I independently came up with <&comphy5 2> in the end, but the
> DT binding doesn't explain what the index is supposed to be and how I
> might figure it out. It cost me days of reading U-Boot and kernel
> sources and playing around with values until I had the working one.
>=20
> Might be helpful to have a symbolic dt-bindings #define for this 2.
>=20

The gbe mux number is described in Armada 385 documentation. Yes, maybe
we should add these defines somewhere, but certainly we should not
declare ability of 2500baseX if comphy is not present and the interface
is not configured to 2500baseX by default.

I propose putting this just into the dt binding documentation. No need
for macros IMO, especially since these muxes may be different on each
SOC.

Marek
