Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2ABB5BD865
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 01:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiISXqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 19:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiISXqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 19:46:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD4D4F18D;
        Mon, 19 Sep 2022 16:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7XSafxCudu/hbAHchLG9erl7tn3ygvlXG1LzO7Z0ywo=; b=CgaFVwSCffephfP6kVbskRHcyp
        +mHn9pDMn634CRa6Xkm+FI/J9OYqBKZprPLEaCosd7mVFCjJVVM+C0p/sMCppNqP/FYQQoMm53BFw
        G9OYW94h6DBlDwJidOuZ8wHWDo603DVE/T/56LTayutDVyyXaQ/tdgvEH6WJsAzaxBRI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaQSa-00HCGe-8Y; Tue, 20 Sep 2022 01:45:56 +0200
Date:   Tue, 20 Sep 2022 01:45:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Jamaluddin, Aminuddin" <aminuddin.jamaluddin@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net 1/1] net: phy: marvell: add link status check before
 enabling phy loopback
Message-ID: <Yyj/NORWrGglz/HJ@lunn.ch>
References: <20220825082238.11056-1-aminuddin.jamaluddin@intel.com>
 <Ywd4oUPEssQ+/OBE@lunn.ch>
 <DM6PR11MB43480C1D3526031F79592A7F81799@DM6PR11MB4348.namprd11.prod.outlook.com>
 <Yw3/vIDAr9W7zZwv@lunn.ch>
 <DM6PR11MB43489B7C27B0A3F3EA18909B81499@DM6PR11MB4348.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB43489B7C27B0A3F3EA18909B81499@DM6PR11MB4348.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Its required cabled plug in, back to back connection.
> > 
> > Loopback should not require that. The whole point of loopback in the PHY is
> > you can do it without needing a cable.
> > 
> > > >
> > > > Have you tested this with the cable unplugged?
> > >
> > > Yes we have and its expected to have the timeout. But the self-test
> > > required the link to be up first before it can be run.
> > 
> > So you get an ETIMEDOUT, and then skip the code which actually sets the
> > LOOPBACK bit?
> 
> If cable unplugged, test result will be displayed as 1. See comments below.
> 
> > 
> > Please look at this again, and make it work without a cable.
> 
> Related to this the flow without cable, what we see in the codes during debugging.
> After the phy loopback bit was set.
> The test will be run through this __stmmac_test_loopback()
> https://elixir.bootlin.com/linux/v5.19.8/source/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c#L320
> Here, it will have another set of checking in dev_direct_xmit(), __dev_direct_xmit().
> returning value 1(NET_XMIT_DROP)
> https://elixir.bootlin.com/linux/v5.19.8/source/net/core/dev.c#L4288
> Which means the interface is not available or the interface link status is not up.
> For this case the interface link status is not up. 
> Thus failing the phy loopback test.
> https://elixir.bootlin.com/linux/v5.19.8/source/net/core/dev.c#L4296
> Since we don't own this __stmmac_test_loopback(), we conclude the behaviour was as expected.
> 
> > 
> > Maybe you are addressing the wrong issue? Is the PHY actually performing
> > loopback, but reporting the link is down? Maybe you need to fake a link up?
> > Maybe you need the self test to not care about the link state, all it really
> > needs is that packets get looped?
> 
> When bit 14 was set, the link will be broken. 
> But before the self-test was triggered it requires link to be up as stated above comments.

You have not said anything about my comment:

> Maybe you need to fake a link up?

My guess is, some PHYs are going to report link up when put into
loopback. Others might not. For the Marvell PHY, it looks like you
need to make marvell_read_status() return that the link is up if
loopback is enabled.

	 Andrew
