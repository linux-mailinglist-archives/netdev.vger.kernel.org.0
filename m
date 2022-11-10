Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FCA624682
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiKJQCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKJQCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:02:48 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42392F64E;
        Thu, 10 Nov 2022 08:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=D8Um2SWESyWwAoQ0Hp9/x5Na8vtfvbENXwnpCxX3ROY=; b=prm2DHsV5YAlzHXZNaeodoW5qC
        KVVvbi+niGkOnDkEvts551Z+HwtHFPgpmktCmgRrcb0AlY/sV9SjYkuMr7//dCosqX+cHwzBAcIl8
        51BgYUtbIUd847zJCt9gtMNirT5IcN7UXZGK2iU+5LK8KT+fnoZAvqaRT2ddP2LCgJ9Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot9zi-0022yz-Er; Thu, 10 Nov 2022 17:01:34 +0100
Date:   Thu, 10 Nov 2022 17:01:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Message-ID: <Y20gXppMemnHSTG9@lunn.ch>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109224110.erfaftzja4fybdbc@skbuf>
 <bcb87445-d80d-fea0-82f2-a15b20baaf06@seco.com>
 <20221110152925.3gkkp5opf74oqrxb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110152925.3gkkp5opf74oqrxb@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 03:29:26PM +0000, Vladimir Oltean wrote:
> On Thu, Nov 10, 2022 at 09:55:32AM -0500, Sean Anderson wrote:
> > On 11/9/22 17:41, Vladimir Oltean wrote:
> > > On Thu, Nov 03, 2022 at 05:06:39PM -0400, Sean Anderson wrote:
> > >> Several (later) patches in this series cannot be applied until a stable
> > >> release has occured containing the dts updates.
> > > 
> > > New kernels must remain compatible with old device trees.
> > 
> > Well, this binding is not present in older device trees, so it needs to
> > be added before these patches can be applied. It also could be possible
> > to manually bind the driver using e.g. a helper function (like what is
> > done with lynx_pcs_create_on_bus). Of course this would be tricky,
> > because we would need to unbind any generic phy driver attached, but
> > avoid unbinding an existing Lynx PCS driver.
> 
> If you know the value of the MII_PHYSID1 and MII_PHYSID2 registers for
> these PCS devices, would it be possible to probe them in a generic way
> as MDIO devices, if they lack a compatible string?

That is not how it currently works. If a device on an MDIO bus has a
compatible, it is assumed to be an mdio device, and it is probed in a
generic way as an sort of mdio device. It could be an Ethernet switch,
or Broadcom has some generic PHYs which are mdio devices, etc.

If there is no compatible, the ID registers are read and it is assumed
to be a PHY. It will be probed as a PHY. The probe() function will be
given a phydev etc.

It will need some core changes to allow an mdio device to be probed
via the ID registers.

    Andrew
