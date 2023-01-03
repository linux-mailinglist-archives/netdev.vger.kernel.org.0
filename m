Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25A165C349
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238003AbjACPtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjACPtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:49:24 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFA512080;
        Tue,  3 Jan 2023 07:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Bl7zNPyg/17oKHhmiSL8xm9swJqehU6paU/Oyhzf6vI=; b=tugNUhosNDBEkmAtZH7CviKjAx
        EVZIPwfPfDBEo1tIq1mPP6dzRFul1Q9rpGo8qGLcg7AKlvemJkbedaPzVt9d2EhIBw5NcFaPsFF/D
        VOA707yX2El8ta6EhLXJyvw39L5fWM5yoJ+eG00iuvg/bYzUqbwgxGdCyQ1qqpn/NTIg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pCjX9-0013iX-VA; Tue, 03 Jan 2023 16:48:59 +0100
Date:   Tue, 3 Jan 2023 16:48:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 11/12] net: dsa: Separate C22 and C45
 MDIO bus transaction methods
Message-ID: <Y7ROa8ql9R5SHPsK@lunn.ch>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20230103153134.utalc6kw3l34dp4s@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103153134.utalc6kw3l34dp4s@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Since clause 45 PHYs are identified by the "ethernet-phy-ieee802.3-c45"
> compatible string (otherwise they are C22), then a PHY which is not
> described in the device tree can only be C22. So this is why
> ds->slave_mii_bus only deals with clause 22 methods, and the true reason
> behind the comment above.
> 
> But actually this premise is no longer true since Luiz' commit
> fe7324b93222 ("net: dsa: OF-ware slave_mii_bus"), which introduced the
> strange concept of an "OF-aware helper for internal PHYs which are not
> described in the device tree". After his patch, it is possible to have
> something like this:
> 
> 	ethernet-switch {
> 		ethernet-ports {
> 			port@1 {
> 				reg = <1>;
> 			};
> 		};
> 
> 		mdio {
> 			ethernet-phy@1 {
> 				compatible = "ethernet-phy-ieee802.3-c45"
> 				reg = <1>;
> 			};
> 		};
> 	};
> 
> As you can see, this is a clause 45 internal PHY which lacks a
> phy-handle, so its bus must be put in ds->slave_mii_bus in order for
> dsa_slave_phy_connect() to see it without that phy-handle (based on the
> port number matching with the PHY number). After Luiz' patch, this kind
> of device tree is possible, and it invalidates the assumption about
> ds->slave_mii_bus only driving C22 PHYs.

My memory is hazy, but i think at the time i wrote these patches,
there was no DSA driver which made use of ds->slave_mii_bus with
C45. So i took the short cut of only supporting C22.

Those DSA drivers which do support C45 all register their bus directly
with the MDIO core.

So Luiz patches may allow a C45 bus, but are there any drivers today
actually using it?

	 Andrew
