Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E8236DF7
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfFFH73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:59:29 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41030 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfFFH72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 03:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JwIMyrVBhIYWhjRuHJS4Kzfpl9Qg+/jH5ojnMnzX9+A=; b=M79ZKW8HgcdQ6V86A7mjwI9C+
        OVoWdKu82toGfIML7DESIAh0rsy6vY3L+njPj4FMTQfp6nVnQqkK67fffSD4y4f0scY49quGvYuYR
        SpdPE+ieUMttj/laABErW9z+YwFBpthFPhwo4Jtj1+miWCK9RH46vrZrlkagKpuiFi6LsPf8oC/6D
        8cpZeM1dWPDOSeRFMVSUn/WmDtoZiepx6cNv3E+4kdEMYoucC+UpwXkpoy07RqBDnjZvCaoMXZptu
        FI6RXurrJu00y4/tPoF5Sq5rEhX3lW86YbLEyKW4oQ6HwZRUz3JoHk6XYciDt3cirM6bb8yNhkgZc
        3VbL/usaQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52878)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYnIw-0004c7-Hm; Thu, 06 Jun 2019 08:59:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYnIt-000366-Sh; Thu, 06 Jun 2019 08:59:19 +0100
Date:   Thu, 6 Jun 2019 08:59:19 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
Message-ID: <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
 <20190605.184827.1552392791102735448.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190605.184827.1552392791102735448.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 06:48:27PM -0700, David Miller wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> Date: Wed, 05 Jun 2019 11:43:16 +0100
> 
> > +	    (state == PHY_UP || state == PHY_RESUMING)) {
> 
> drivers/net/phy/marvell10g.c: In function ‘mv3310_link_change_notify’:
> drivers/net/phy/marvell10g.c:268:35: error: ‘PHY_RESUMING’ undeclared (first use in this function); did you mean ‘RPM_RESUMING’?
>       (state == PHY_UP || state == PHY_RESUMING)) {
>                                    ^~~~~~~~~~~~
>                                    RPM_RESUMING
> drivers/net/phy/marvell10g.c:268:35: note: each undeclared identifier is reported only once for each function it appears in
> At top level:
> drivers/net/phy/marvell10g.c:262:13: warning: ‘mv3310_link_change_notify’ defined but not used [-Wunused-function]
>  static void mv3310_link_change_notify(struct phy_device *phydev)
>              ^~~~~~~~~~~~~~~~~~~~~~~~~

Hmm. Looks like Heiner's changes in net-next _totally_ screw this
approach - it's not just about PHY_RESUMING being removed, it's
also about the link change notifier being moved. :(

This link notifier change also screws up my long-standing patches
to add support for SFP for the PHYs on Macchiatobin which I was
going to post next.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
