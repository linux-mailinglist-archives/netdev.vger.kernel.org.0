Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3756F65F5B5
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbjAEV0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbjAEV0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:26:12 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EFC59FA4
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=M1RvZF0s9YTg59MuYNklVSmapsh4yUMA2AYm+2602cU=; b=rUEjxR7Cr7yKjcWSJvu8VM0mBJ
        AVhcrJgI8UMna2K7QHLJ5eVeUrkodkY2sbCBNU6Ff8d6c6pkMYQHHoD0nnmiqxLC0yf+tikTZ2iD6
        uw6t1Xq2/E619JH1zK7fPj6fKVzGFdQsaK55ysCq+fyAHKoM1Gkj2rgpQlntWTViXBOo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pDXkV-001GS4-CY; Thu, 05 Jan 2023 22:26:07 +0100
Date:   Thu, 5 Jan 2023 22:26:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Chunhao Lin <hau@realtek.com>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
Subject: Re: [PATCH net] r8169: fix rtl8168h wol fail
Message-ID: <Y7dAbxSPeaMnW/ly@lunn.ch>
References: <20230105180408.2998-1-hau@realtek.com>
 <714782c5-b955-4511-23c0-9688224bba84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <714782c5-b955-4511-23c0-9688224bba84@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 08:37:07PM +0100, Heiner Kallweit wrote:
> On 05.01.2023 19:04, Chunhao Lin wrote:
> > rtl8168h has an application that it will connect to rtl8211fs through mdi
> > interface. And rtl8211fs will connect to fiber through serdes interface.
> > In this application, rtl8168h revision id will be set to 0x2a.
> > 
> > Because rtl8211fs's firmware will set link capability to 100M and GIGA
> > when link is from off to on. So when system suspend and wol is enabled,
> > rtl8168h will speed down to 100M (because rtl8211fs advertise 100M and GIGA
> > to rtl8168h). If the link speed between rtl81211fs and fiber is GIGA.
> > The link speed between rtl8168h and fiber will mismatch. That will cause
> > wol fail.
> > 
> > In this patch, if rtl8168h is in this kind of application, driver will not
> > speed down phy when wol is enabled.
> > 
> I think the patch title is inappropriate because WoL works normally on
> RTL8168h in the standard setup.
> What you add isn't a fix but a workaround for a firmware bug in RTL8211FS.
> As mentioned in a previous review comment: if speed on fibre side is 1Gbps
> then RTL8211FS shouldn't advertise 100Mbps on MDI/UTP side.
> 
> Last but not least the user can still use e.g. ethtool to change the speed
> to 100Mbps thus breaking the link.

I agree with Heiner here. I assume you cannot fix the firmware?

So can we detect the broken firmware and correctly set
phydev->advertising? That will fix WoL and should prevent the user
from using ethtool to select a slower speed.

     Andrew
