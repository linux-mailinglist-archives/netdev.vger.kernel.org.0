Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CEF5230A3
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242185AbiEKK0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242123AbiEKK0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:26:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F228716
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+pQU2Th1s2IAHG7FJGYExaZeVjvPT2fIkO2Lr0ZlwTw=; b=XX82peg0sNOM3udowC8sgquIZH
        cbTq7GX2EoJYr6SbVauBlHCac70lwE5frPfRxuY0jqJoQWsYFdTXu4DH5MakdVHDBVrGP4R+cdCEw
        xGAkJ/9hTa3Ij6W1BcRIJgTIOS2R2etH8tqGyg943wbeEBiMz8PX46boonOlMa8sjwt1NBDfWDeOk
        EkuJw9hDth78S0qNCgR0IZrixNj5OwkhZbdHbU4GpTFDysao/aDUJ7KlIb2rJFveCLvOTriAs6R4x
        2xLTNxOlieYR2/fjgS2DJpiWhTV91bG4Cmx7YrLGDmVxqRAk+vyOY7GLmmjuuwt7Fk6ad+1Hgrui0
        JRczfXNQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60678)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nojXo-0006d1-F3; Wed, 11 May 2022 11:26:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nojXo-00070h-9k; Wed, 11 May 2022 11:26:12 +0100
Date:   Wed, 11 May 2022 11:26:12 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Josua Mayer <josua@solid-run.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Message-ID: <YnuPRKRBj/5YbAUQ@shell.armlinux.org.uk>
References: <20220509122938.14651-1-josua@solid-run.com>
 <YnkN954Wb7ioPkru@lunn.ch>
 <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
 <YnpW9nSZ2zMAmmq0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnpW9nSZ2zMAmmq0@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 02:13:42PM +0200, Andrew Lunn wrote:
> > > As far as i'm aware, the in kernel code always has a netdev for each
> > > MAC. Are you talking about the vendor stack?
> > The coprocessor can be configured both at boot-time and runtime.
> > During runtime there is a vendor tool "restool" which can create and destroy
> > network interfaces, which the dpaa2 driver knows to discover and bind to.
> 
> There should not be any need to use a vendor tool for mainline. In
> fact, that is strongly discouraged, since it leads to fragmentation,
> each device doing its own thing, the user needing to read each vendors
> user manual, rather than it just being a standard Unix box with
> interfaces.

You're missing the bigger picture.

There are two ways to setup the networking on LX2160A - one is via
DT-like files that are processed by the network firmware, which tells
it what you want to do with each individual network connection.

Then there is a userspace tool that talks to the LX2160A network
firmware and requests it to configure the network layer - e.g. create
a network interface to connect to a network connection, or whatever.

I believe that when using DPDK, one does not want the network
connections to be associated with Linux network interfaces - but
don't quote me on that.

The tool has nothing to do with LEDs. It's all about talking to the
networking firmware on the chip.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
