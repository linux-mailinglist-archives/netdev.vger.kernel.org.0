Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED225EDC21
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiI1MB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiI1MB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:01:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947E46CD0E;
        Wed, 28 Sep 2022 05:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yG3EO7bhQAbZBMVLnUELpWW5SoVX+r5MbUkq+fTPHdk=; b=zsDIjoZXxhbZwwH4RSzziY+y8Z
        OxaIAz/ND+ZwVJSocwu9+lnHXhP0FBbqaoV5C6o2OPPNKFCOnJ8osRNJ3NJ510QANPFaBytU1XkIS
        WCQ6VnrUsfXPRdFEK/rbIzimAo7pjRzz/5hn15H+yfI0VV7o3i81vdsbuZeiI001v9Qw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odVkP-000VTF-66; Wed, 28 Sep 2022 14:01:05 +0200
Date:   Wed, 28 Sep 2022 14:01:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <YzQ3gdO/a+jygIDa@lunn.ch>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <Yy2wivbzUA2zroqy@lunn.ch>
 <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzH65W3r1IV+rHFW@lunn.ch>
 <TYBPR01MB534189F384D8A0F5E5E00666D8559@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzLybsJBIHtbQOwE@lunn.ch>
 <TYBPR01MB53419D2076953EB3480BC301D8549@TYBPR01MB5341.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYBPR01MB53419D2076953EB3480BC301D8549@TYBPR01MB5341.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > How do you direct a frame from the
> > CPU out a specific user port? Via the DMA ring you place it into, or
> > do you need a tag on the frame to indicate its egress port?
> 
> Via the DMA ring.

Are there bits in the ring descriptor which indicate the user port?
Can you set these bits to some other value which causes the switch to
use its MAC table to determine the egress interface?

> > > The PHY is 88E2110 on my environment, so Linux has a driver in
> > > drivers/net/phy/marvell10g.c. However, I guess this is related to
> > > configuration of the PHY chip on the board, it needs to change
> > > the host 7interface mode, but the driver doesn't support it for now.
> > 
> > Please give us more details. The marvell10g driver will change its
> > host side depending on the result of the line side negotiation. It
> > changes the value of phydev->interface to indicate what is it doing on
> > its host side, and you have some control over what modes it will use
> > on the host side. You can probably define its initial host side mode
> > via phy-mode in DT.
> 
> I'm sorry, my explanation was completely wrong.
> My environment needs to change default MAC speed from 2.5G/5G to 1000M.
> The register of 88E2110 is 31.F000.7:6. And sets the register to "10" (1000 Mbps).
> (Default value of the register is "11" (Speed controlled by other register).)

Is this the host side speed? The speed of the SERDES between the
switch and the PHY? Normally, the PHY determines this from the line
side. If the line side is using 2.5G, it will set the host side to
2500BaseX. If the line side is 1G, the host side is likely to be
SGMII.

You have already removed speeds you don't support. So the PHY will not
negotiate 2.5G or 5G. It is limited to 1G. So it should always have
the host side as SGMII. This should be enough to make it work.

    Andrew
