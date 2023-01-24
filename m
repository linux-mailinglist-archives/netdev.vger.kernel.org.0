Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71527678DA6
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 02:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjAXBoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 20:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjAXBoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 20:44:22 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69796392B1;
        Mon, 23 Jan 2023 17:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tVzKOa9T2IRU8P2Mj1uxknCEpQe8KQ0SnikmQEFNOjA=; b=f7qRojPtxwepLEjSQniONpkH8e
        UIH3SYylITIKBFR096XyeEqB+teycnoBeS6/0bu+AAxId1iYdXH61B0NqCom4nzzcLUWvBApd58hb
        s370/NwfWt0Nyup/BqJ533rwo+BI3YRulFVFy9G4sLBlPHdQj8sLHM/shgWDXLUjzl6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pK8Lx-002y4d-16; Tue, 24 Jan 2023 02:44:01 +0100
Date:   Tue, 24 Jan 2023 02:44:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: phy: C45-over-C22 access
Message-ID: <Y8834YKbZAoLyMQJ@lunn.ch>
References: <20230120224011.796097-1-michael@walle.cc>
 <Y87L5r8uzINALLw4@lunn.ch>
 <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
 <Y87og1SIe1OsoLfU@lunn.ch>
 <05e044a5f308ad81919d28a5b2dfdd42@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05e044a5f308ad81919d28a5b2dfdd42@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 01:35:48AM +0100, Michael Walle wrote:
> >       - const: ethernet-phy-ieee802.3-c45
> >         description: PHYs that implement IEEE802.3 clause 45
> > 
> > But it is not clear what that actually means. Does it mean it has c45
> > registers, or does it mean it supports C45 bus transactions?
> 
> PHYs which support C45 access but don't have C45 registers aren't
> a thing I presume - or doesn't make any sense, right?
> 
> PHYs which have C45 registers but don't support C45 access exists.
> e.g. the EEE registers of C22 PHYs. But they are C22 PHYs.

I wonder if there are any C22 PHYs which only allow access to EEE via
C45 transactions. That would be pretty broken...

To some extent, i'm still looking at everything and trying to decide
if the current definitions/documentation make it clear if means C45
transfers or registers. And the documentation in DT is ambiguous, but
as you point out, it probably means registers, not transactions.

> So I'd say if you have compatible = "ethernet-phy-ieee802.3-c45",
> it is a PHY with C45 registers _and_ which are accessible by
> C45 transactions. But they might or might not support C22 access.
> But I think thats pretty irrelevant because you always do C45 if
> you can. You cannot do C45 if:
>  (1) the mdio bus doesn't support C45
>  (2) you have a broken C22 phy on the mdio bus
> 
> In both cases, if the PHY doesn't support C22-over-C45 you are
> screwed. Therefore, if you have either (1) or (2) we should always
> fall back to C22-over-C45.
> 
> > If we have that compatible, we could probe first using C45 and if that
> > fails, or is not supported by the bus master, probe using C45 over
> > C22. That seems safe. For Michael use case, the results of
> > mdiobus_prevent_c45_scan(bus) needs keeping as a property of bus, so
> > we know not to perform the C45 scan, and go direct to C45 over C22.
> 
> So you are talking about DT, in which case there is no auto probing.
> See phy_mask in the dt code. Only PHYs in the device tree are probed.
> (unless of course there is no reg property.. then there is some
> obscure auto scanning). So if you want a C45 PHY you'd have to
> have that compatible in any case.
> 
> Btw. I still don't know how you can get a C45 PHY instance without
> a device tree, except if there is a C45 only bus or the PHY doesn't
> respond on C22 ids. Maybe I'm missing something here..

In the DT case, you are probably correct. But there are a number of
MDIO busses which don't come from DT. Those are typically PCIe or USB
devices. Those do get scanned, and my recent changes should mean they
first get scanned using C22 and then C45. DSA switches also typically
don't have a MDIO node in DT, it is assumed there is a 1:1 mapping
between port number and address on the MDIO bus. But as you said, it
would require that they don't respond to C22, or the bus master does
not support C22, which does actually exist from Marvell at least.

In the none DT case, we probably cannot easily do anything about
C22-over-C45, because as Russell pointed out, it is potentially a
destructive process doing a scan. We want some indication we do expect
a PHY to be there. And "ethernet-phy-ieee802.3-c45" would do that.

	Andrew
