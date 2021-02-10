Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961B5316453
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhBJKv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhBJKtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:49:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0744C0613D6;
        Wed, 10 Feb 2021 02:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oU/bEFbJX+Oxte65uYr1mV6/P3GdOdvC+g8seWSXo/8=; b=PkW9pnhcz2bQaT2e2f49S9QS8
        XI/QxTxA6tZyiEhCahsP8ny849D65ADCKLuRWOYMfB7gocELzyaoMgjLzQRQWUurVdOUqnspZ1UVj
        xnB2c/Gi76ibPvDGzMUYwMVbZplXH/ypmUZKSJs7i1XvDfhwxN6cK9JMPt4ZHDD3uetL+HMNPa9da
        PTfAJbxUmCXCirXksZe4jruOgx1S66bs8PF09M1hkkB81kTxk+X64rEpUuXCbHKeYU9h5pv+YCSVw
        DaBP44U0W/J9FtM2TqW25yLFaxIXNMGv9+V+6kc2yHYKNRbpmZGiSfIurvFnX5VnCnz0TVtxbMHXB
        eEd/VU3QA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41568)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l9n3N-0004Xk-GD; Wed, 10 Feb 2021 10:49:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l9n3N-000502-09; Wed, 10 Feb 2021 10:49:01 +0000
Date:   Wed, 10 Feb 2021 10:49:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before
 writing control register
Message-ID: <20210210104900.GS1463@shell.armlinux.org.uk>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
 <20210210103059.GR1463@shell.armlinux.org.uk>
 <d35f726f82c6c743519f3d8a36037dfa@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d35f726f82c6c743519f3d8a36037dfa@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:38:18AM +0100, Michael Walle wrote:
> Am 2021-02-10 11:30, schrieb Russell King - ARM Linux admin:
> > On Wed, Feb 10, 2021 at 08:03:07AM +0100, Heiner Kallweit wrote:
> > > On 09.02.2021 17:40, Michael Walle wrote:
> > > > +out:
> > > > +	return phy_restore_page(phydev, oldpage, err);
> > > 
> > > If a random page was set before entering config_init, do we actually
> > > want
> > > to restore it? Or wouldn't it be better to set the default page as
> > > part
> > > of initialization?
> > 
> > I think you've missed asking one key question: does the paging on this
> > PHY affect the standardised registers at 0..15 inclusive, or does it
> > only affect registers 16..31?
> 
> For this PHY it affects only registers >=16. But that doesn't invaldiate
> the point that for other PHYs this might affect all regsisters. Eg. ones
> where you could select between fiber and copper pages, right?

You are modifying the code using ip101a_g_* functions, which is only
used for the IP101A and IP101G PHYs. Do these devices support fiber
in a way that change the first 16 registers?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
