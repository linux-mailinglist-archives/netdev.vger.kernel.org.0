Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3D932C499
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446501AbhCDAPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1578009AbhCCSQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 13:16:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B337464EEC;
        Wed,  3 Mar 2021 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614795335;
        bh=5T9bHIFj1CyoGXbVb1zYt1TrohJNGLumV+zjmV7GO9I=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=thLbqn6F/11rvo1ByfrUWKbCxykt3UKMvbxFWt++nWhbXCqHwUkjIN/0LnsLHBQcC
         ez0V1GlQbWXbzmWbhKXPceHv9APr1lI57lVjDczrlqm4YOThn8aHFlSPRHLWjmQ8D1
         iQD6MbshCrhjjNMsKPAp2fJCiDxASs6/e12hNedp9cOvbOVgEt4uLBhsh5CXNu94cD
         RjhvBsOxFPzmtZW0TcehIorc3UdSH6AGyML5yQ75vBCafL5MlNv/HYQVJKqyRwhns5
         /rFC2Clv5FhHTEh6Ht9mj/WPEqi3aTSy8P67mZXggY8yRlRHJokwhylh/Hg+eYGLwV
         KhoBirn/8NN+w==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 6CEA535237A1; Wed,  3 Mar 2021 10:15:35 -0800 (PST)
Date:   Wed, 3 Mar 2021 10:15:35 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH drivers/net] #ifdef mdio_bus_phy_suspend() and
 mdio_bus_phy_suspend()
Message-ID: <20210303181535.GF2696@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210303175338.GA15338@paulmck-ThinkPad-P72>
 <20210303180422.GB1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210303180422.GB1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 03, 2021 at 06:04:22PM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Mar 03, 2021 at 09:53:38AM -0800, Paul E. McKenney wrote:
> > drivers/net: #ifdef mdio_bus_phy_suspend() and mdio_bus_phy_suspend()
> > 
> > The following build error is emitted by rcutorture builds of v5.12-rc1:
> > 
> > drivers/net/phy/phy_device.c:293:12: warning: ‘mdio_bus_phy_resume’ defined but not used [-Wunused-function]
> > drivers/net/phy/phy_device.c:273:12: warning: ‘mdio_bus_phy_suspend’ defined but not used [-Wunused-function]
> > 
> > The problem is that these functions are only used by SIMPLE_DEV_PM_OPS(),
> > which creates a dev_pm_ops structure only in CONFIG_PM_SLEEP=y kernels.
> > Therefore, the mdio_bus_phy_suspend() and mdio_bus_phy_suspend() functions
> > will be used only in CONFIG_PM_SLEEP=y kernels.  This commit therefore
> > wraps them in #ifdef CONFIG_PM_SLEEP.
> 
> Arnd submitted a patch that Jakub has applied which fix these warnings
> in a slightly different way. Please see
> 20210225145748.404410-1-arnd@kernel.org

Works for me!  When will this be hitting mainline?

Not a huge deal given that I can suppress the resulting rcutorture
failures by keeping a copy of either patch in -rcu, but I might not
be the only one hitting this.

							Thanx, Paul
