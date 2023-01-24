Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7344F679C12
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbjAXOhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbjAXOhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:37:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C65D113DC
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bbcyd8ZIrxbTOTQRVEPE8rX9QQkCxvRNix3l7+/P4mw=; b=NUOiEiG+1aIiMG6lOg7jrCMbV0
        DfTJWuyT2STIdV4mMzzJeoBhyAJ+hdMaefsPogiS7X1gy//Q9Vnuxj13xB3d2VfpJWV9XN0eqvcrN
        rTfTuaSBR8gi2IJA7Ag+YPbN8I7XtRz9rwALfPFPJ/ArOx+gkvSf3NPSCamT/XLgzUNs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pKJnL-0031I7-Ig; Tue, 24 Jan 2023 14:57:03 +0100
Date:   Tue, 24 Jan 2023 14:57:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <Y8/jrzhb2zoDiidZ@lunn.ch>
References: <Y7yIK4a8mfAUpQ2g@lunn.ch>
 <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
 <20230110222246.iy7m7f36iqrmiyqw@skbuf>
 <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf>
 <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 08:21:35AM +0100, Angelo Dureghello wrote:
> 
> Hi Andrew and Vladimir,
> 
> On Mon, 23 Jan 2023, Andrew Lunn wrote:
> 
> > > I don't know what this means:
> > > 
> > > | I am now trying this way on mv88e6321,
> > > | - one vlan using dsa kernel driver,
> > > | - other vlan using dsdt userspace driver.
> > > 
> > > specifically what is "dsdt userspace driver".
> > 
> > I think DSDT is Marvells vendor crap code.
> > 
> Yes, i have seen someone succeeding using it, why do you think it's crap ?

In the Linux kernel community, that is the name given to vendor code,
because in general, that is the quality level. The quality does vary
from vendor to vendor and SDK to SDK, some are actually O.K.

> 
> > Having two drivers for the same hardware is a recipe for disaster.
> > 
> >  Andrew
> > 
> 
> What i need is something as
> 
>         eth0 ->  vlan1 -> port5(rmii)  ->  port 0,1,2
>         eth1 ->  vlan2 -> port6(rgmii) ->  port 3,4
> 
> The custom board i have here is already designed in this way
> (2 fixed-link mac-to-mac connecitons) and trying my best to have
> the above layout working.

With todays mainline i would do:

So set eth0 as DSA master port.

Create a bridge br0 with ports 0, 1, 2.
Create a bridge br1 with ports 3, 4, 6.

You don't actually make use of the br1 interface in Linux, it just
needs to be up. You can think of eth1 being connected to an external
managed switch.

	Andrew
