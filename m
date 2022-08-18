Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55E1597B25
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 03:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbiHRBoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 21:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235733AbiHRBoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 21:44:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A83A1A74;
        Wed, 17 Aug 2022 18:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v/ogUYGKhlL5A9QYZicl3oguBuH01CMBW+H2SPHWlcY=; b=OjN4bS215lSgFfYMQQiD3ZiDze
        7k8YW41eft49l+Dspmjw/tCXJ1EXjQ+93EpaLaPeufaEe+x0TEn7W/ompuH8pSBzfnGMAQkAn61JH
        vCMSIvfftE40xU49pcEuZPQHjIqSAABOhHB8f/zAK7RSbFOQuv3+n44TcwXfZpmdprfU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOUa9-00Dgfw-Hb; Thu, 18 Aug 2022 03:44:25 +0200
Date:   Thu, 18 Aug 2022 03:44:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Message-ID: <Yv2ZeWPTZkIlh4t2@lunn.ch>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <YvZggGkdlAUuQ1NG@lunn.ch>
 <DB9PR04MB8106F2BFD8150A1C76669F9C88689@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Yv2TwkThceuU+m5l@lunn.ch>
 <DB9PR04MB8106FF32F683295860D4939F886D9@DB9PR04MB8106.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB8106FF32F683295860D4939F886D9@DB9PR04MB8106.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, after the PHY enters hibernation mode that the RX_CLK stop ticking, but
> for stmmac, it is essential that RX_CLK of PHY is present for software reset
> completion. Otherwise, the stmmac is failed to complete the software reset
> and can not init DMA.

So the RX_CLK is more than the recovered clock from the bit stream on
the wire. The PHY has a way to generate a clock when there is no
bit stream?

To me, it sounds like your hardware design is wrong, and it should be
using the 25MHz reference clock. And what you are proposing is a
workaround for this hardware problem.

Anyway, i agree with Russell, a DT property is fine. But please make
it clear in the binding documentation that disabling hibernation has
the side affect of keeping the RX_CLK ticking when there is no
link. That is probably what people want this for, not to actual
disable hibernation.

	Andrew
