Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD94E68DBD9
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjBGOlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjBGOlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:41:02 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B3A3EC74;
        Tue,  7 Feb 2023 06:39:40 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1ADFA1BF214;
        Tue,  7 Feb 2023 14:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675780759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UgTjkfhErQAXd/2bdHyqrP5YcPwCn6JNIcfadunoXU4=;
        b=Fu2pSU8TRoi+yu5AR3jUSEf/++jNuEOCQoM3+F5Ob6MagmavxDFR4HVwRZCFeiAuckyw9D
        I3BX/YR1VhGI8D8gv6I8aZGtUxuVx2mkunIIMNEZv5xw/bL0Z20V4xSW9syXWDjk1I6xds
        PC4oCwtCfFK8C8CfTX0Ss+Kv4g5tkfd4Kj4H9Bq5SL/dPm83cHt69/tHh+e3E7dsV8r3vN
        HC4S+exCpCM+6iP4w3v6uNM0S1dZVDPVpRdWexVqK2tzDFFXPNfOJErl5oXagRIH1M2VIk
        jfBOxwCaM6pWs73TFjMSX83dkwnDcS+2bSKOBqVvkJsoOGqRId+B1cRR4Z4cQQ==
Date:   Tue, 7 Feb 2023 15:41:35 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 3/6] net: stmmac: start phylink before setting
 up hardware
Message-ID: <20230207154135.6f0e59f8@fixe.home>
In-Reply-To: <Y8UsvREsKOR2ejzT@shell.armlinux.org.uk>
References: <20230116103926.276869-1-clement.leger@bootlin.com>
        <20230116103926.276869-4-clement.leger@bootlin.com>
        <Y8UsvREsKOR2ejzT@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 16 Jan 2023 10:53:49 +0000,
"Russell King (Oracle)" <linux@armlinux.org.uk> a =C3=A9crit :

> On Mon, Jan 16, 2023 at 11:39:23AM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/driver=
s/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index f2247b8cf0a3..88c941003855 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -3818,6 +3818,12 @@ static int __stmmac_open(struct net_device *dev,
> >  		}
> >  	}
> > =20
> > +	/* We need to setup the phy & PCS before accessing the stmmac registe=
rs
> > +	 * because in some cases (RZ/N1), if the stmmac IP is not clocked by =
the
> > +	 * PCS, hardware init will fail because it lacks a RGMII RX clock.
> > +	 */
> > +	phylink_start(priv->phylink); =20
>=20
> So what happens if you end up with the mac_link_up method being called
> at this point in the driver, before the hardware has been setup ?
>=20
> If you use a fixed-link, that's a real possibility.

I actually have this setup. On the board, one GMAC is connected to a
DSA switch using a fixed-link and the other using the PCS such as added
by this series.

=46rom what I see, indeed, the mac_link_up() function is called before
stmmac_hw_setup(). This does not seems to have any effect on my setup
(except making it working of course) but I agree this is clearly not
ideal.

What I could do is adding a function in the miic pcs driver that could
be called from my rzn1 stmmac probe function to actually configure the
PCS at probe time based on the detected "phy-mode". Does that seems
better to you ?

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
