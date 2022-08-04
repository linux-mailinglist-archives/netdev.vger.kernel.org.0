Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897DD589C8E
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 15:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiHDNZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 09:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiHDNZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 09:25:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EADD26544
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 06:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4LY8oCUkPMofYrOC/wOSrNkUV6hoG5gjnqSQEJmCRJg=; b=iofjy9CC0o40QsHnE1H/XSJYyL
        Lufume4dfgSZqw4GbH5Mz4YmguoT0A3ANRtw8DzdKFO2DKgus0xl4fUGW5pXSeoDw26LfNmATyxCC
        4jrvRyLBBwSebBJ97w4d9TMRqyM01tO1RotR88OFykhGZ5KmJbbh+tgVhr1q80r7STTw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oJaqO-00CQUJ-Fs; Thu, 04 Aug 2022 15:24:56 +0200
Date:   Thu, 4 Aug 2022 15:24:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     hayeswang@realtek.com, netdev@vger.kernel.org
Subject: Re: [RFC] r8152: pass through needs to be singular
Message-ID: <YuvIqCBAcZTMh0xV@lunn.ch>
References: <20220728191851.30402-1-oneukum@suse.com>
 <YuMJhAuZVVZtl9VZ@lunn.ch>
 <34f7cb15-91e8-e92c-7dcd-f5b28724df92@suse.com>
 <YuknNESeYxCjcPrD@lunn.ch>
 <d8e45a94-e16a-1152-afad-2ebb15b48d67@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8e45a94-e16a-1152-afad-2ebb15b48d67@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am afraid I have to beg to differ.
> 
> We have a couple of related issues here. Obviously whoever designed
> MAC pass-through did not consider the case of somebody using two
> docking stations at the same time. While pass-through is used I agree
> that this is unsolvable.
> 
> Yet connecting two (or even more) docking stations to a host is
> within spec. They are USB devices (partially) and if they contain
> a NIC it is clear what we have to do.
> We would operate them with
> 1. a MAC contained on the device
> 2. if the device contains no MAC, we'd use a random MAC, but a
> different one per device. User space can assign any MAC it wants to,
> but we are talking defaults here.
> 
> Now, the question arises whether we let another feature interfere
> with that. And then I must say, if we do that and we have decided
> to take a feature that does so, we'll have to do it in a way that
> stays within spec. Yet I am sorry, you cannot give out the same
> MAC to two devices at the same time, if you want to do so.
> 
> So while the bug in the driver derives from a stupid design,
> it nevertheless is a bug and my patch fixes it. Optimally?
> No, of course not, the design is broken.

The problem is regressions. Current code will put the MAC address on
both. I guess most users just have one dock with a cabled and the
second is unused. Both will get the same MAC address, the DHCP server
will recognise the MAC address and give out the expected IP address.

If you change it to only give the MAC address out once, you get into a
race condition, which device probes first, gets the MAC, and gives the
expected MAC to the DHCP server? You are going to see regressions.

> >>> What exactly is your problem which you are trying to fix? 
> >> Adressing the comment Hayes made when reset_resume() was fixed
> >> from a deadlock, that it still assigns wrong MACs. I feel that
> >> before I fix keeping the correct address I better make sure the
> >> MAC is sane in the first place.
> > 
> > I would say that reset_resume() should restore whatever the MAC
> > address was before the suspend.
> 
> The problem is that these devices reread the passed through MAC
> at post_reset(). Do you want reset_resume() to act differently?

I would expect whatever MAC address is in the netdev structure to be
put on the interface at resume. That should of been the MAC it was
using before suspend. And by doing that, you bypass all the discussion
about where it came from.

      Andrew
