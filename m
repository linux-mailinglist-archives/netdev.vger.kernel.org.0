Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39796A9905
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 15:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjCCODQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 09:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCCODP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 09:03:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85F617CCE
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 06:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tCgAgXGruiBgB/jR7iq6fCOn46Xr8zknAM3YBFpkVEI=; b=ChCa78Vx/QV+5zuVH8NrN7CfPO
        kJ3zaQwtM6x2qmoXNmnQBoLWndW5AmTqt6cGL/6parXjBmt/q+8VLRvOhwakM9dYHjJnI/gceXWEI
        wOvGiqBj+2vMA4IBdciACVJkyzj7WW0OuztAg2MfLyMnXwBSkd9ZA6d+pK58eSa0tSQwj53BtYQhj
        sCgfKCKJI6z/Uo13fU0Jh8wnpog/74rCbpLQHcgYQbaPnSprPIs6iEu5lkO/Ynpo8T2oSbwf3XFdt
        BYZMqYNyzrPL+IYyTbvien0kNROmLky/PsGjFWOorPPnYDpJhNGcuthyKQ2gh+FPTCmuSr8Xupeoy
        SjG4ytWA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53846)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pY602-00011b-F7; Fri, 03 Mar 2023 14:03:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pY600-0005sQ-0M; Fri, 03 Mar 2023 14:03:04 +0000
Date:   Fri, 3 Mar 2023 14:03:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZAH+F6GCCXfzeR+6@shell.armlinux.org.uk>
References: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
 <20230303102005.442331-1-michael@walle.cc>
 <ZAH0FIrZL9Wf4gvp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAH0FIrZL9Wf4gvp@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 02:20:20PM +0100, Andrew Lunn wrote:
> I'm not sure we are making much progress here...
> 
> Lets divide an conquer. As far as i can see we have the following bits
> of work to do:
> 
> 1) Kernel internal plumbing to allow multiple time stampers for one
> netdev. The PTP core probably needs to be the mux for all kAPI calls,
> and any internal calling between components. This might mean changes
> to all MAC drivers supporting PTP and time stampers. But i don't think
> there is anything too controversial here, just plumbing work.
> 
> 2) Some method to allow user space to control which time stamper is
> used. Either an extension of the existing IOCTL interface, or maybe
> ethtool. Depending on how ambitious we want to be, add a netlink API
> to eventually replace the IOCTL interface?
> 
> 3) Add a device tree binding to control which time stamper is
> used. Probably a MAC property. Also probably not too controversial.
> 
> 4) Some solution to the default choice if there is no DT property.

I thought (4) was what we have been discussing... but the problem
seems to be that folk want to drill down into the fine detail about
whether PHY or MAC timestamping is better than the other.

As I've already stated, I doubt DT maintainers will wear having a
DT property for this, on the grounds that it's very much a software
control rather than a hardware description.

On the other hand, if DT described the connectivity of the PTP
hardware signals, then one could probably make a decision based
upon that, and as that's describing hardware, it would be less
problematical during DT review.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
