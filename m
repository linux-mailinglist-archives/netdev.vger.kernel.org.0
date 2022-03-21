Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAF04E334A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiCUW47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiCUW4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:56:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD7044B80E;
        Mon, 21 Mar 2022 15:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XZ3oFyOSp0Vku3EvXsBQyxrGvvfq0+pDjNDfzwtDRnI=; b=lgATyuc8BDzyagsTk6S7pPJHcK
        cAHP+N8Q5SqHFIS7Cg8rgYZK/HWBCCIB75xt36TSH0HEmeLYfac5IzauQiV3cmYUTCT0r1yY3+wne
        bXIpPxwzFnzGIKuhiV6u84+HLGVmP7X2AQ8yuxyxomfReOQJDlh21GEoNw1FniHe+ib8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWQbb-00C1yF-20; Mon, 21 Mar 2022 23:34:27 +0100
Date:   Mon, 21 Mar 2022 23:34:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clause 45 and Clause 22 PHYs on one MDIO bus
Message-ID: <Yjj9c/b8J50WiECf@lunn.ch>
References: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
 <cdb3d3f6ad35d4e26fd8abb23b2e96a3@walle.cc>
 <YjjhxbZgKHykJ+35@lunn.ch>
 <4d728d267e45fe591c933c86cdfff333@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d728d267e45fe591c933c86cdfff333@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 10:41:56PM +0100, Michael Walle wrote:
> Am 2022-03-21 21:36, schrieb Andrew Lunn:
> > > Actually, it looks like mdiobus_c45_read() is really c45 only and only
> > > used for PHYs which just support c45 and not c45-over-c22 (?). I was
> > > mistaken by the heavy use of the function in phy_device.c. All the
> > > methods in phy-c45.c use phy_*_mmd() functions. Thus it might only be
> > > the mxl-gpy doing something fishy in its probe function.
> > 
> > Yes, there is something odd here. You should search back on the
> > mailing list.
> > 
> > If i remember correctly, it is something like it responds to both c22
> > and c45. If it is found via c22, phylib does not set phydev->is_c45,
> > and everything ends up going indirect. So the probe additionally tries
> > to find it via c45? Or something like that.
> 
> Yeah, found it: https://lore.kernel.org/netdev/YLaG9cdn6ewdffjV@lunn.ch/
> 
> But that means that if the controller is not c45 capable, it will always
> fail to probe, no?

The problem is around here:

https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy-c45.c#L455

phydev->c45_ids.mmds_present needs to be set. Which happens as part of
get_phy_c45_ids(). What probably needs to happen is the
mdiobus_c45_read() in that function need to change to phy_read_mmd()
so that it can use C45 over C22. The devil in the details is making
sure it does actually do C45 if C45 is available, otherwise we could
break devices on a C45 only bus, of which there is a few.

> I'll have to give it a try. First I was thinking that we wouldn't need
> it because a broken PHY driver could just set a quirk "broken_c45_access"
> or similar. But that would mean it has to be probed before any c45 PHY.
> Dunno if that will be true for the future. And it sounds rather fragile.
> So yes, a dt property might be a better option.

This is unfortunately not a PHY property, but a bus property. This bus
has a FUBAR PHY on it, which limits the protocols that can be used on
this bus. And there is no clear relationship between PHYs, you cannot
easily say which PHYs share the same bus. So even if the lan8814 was
to indicate it is FUBAR, you have no idea which other PHYs are
affected.

A DT property is more generic, and if done correct, could actually ban
C22 or it could ban C45.

    Andrew
