Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5304241D12
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 17:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgHKPVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 11:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbgHKPVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 11:21:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DEFC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9+N01BrmV7iBN4b2lglG5TPxs60Euc1G6TGbvsrcbNU=; b=xhb7fo1BXWec6+H56YGSavKM/
        JTpma5jnsRyRKErqeu7VIUsMoSAmms/+Qyvp2pPEga8J7m6a+L/Gs3j15ccMEYTj8YqI4A6kdPMsM
        rPr+EQy1YK0Dk1uiPKefbY23Y2IkZNBvye1b3r1yWJtE+BvlbFNtj4cCjV6wFqEJK8KBkFH9ti+2i
        huXZ3c8LJLsUTauvBoUwM7X27a57w1N3mD4ggfQ7pyoh+yWoslDUHGA+Uf/m6O0BQFNZN9jnow8TH
        KLzlrv+DMZTZXavT6R+7YNO/Sh3DlmahCOmfBNkn8BCX6SiGwVNTcXZTPCsZsQJZ4tSWJEU5sKxot
        dooGuzF1g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51190)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k5W5w-0001a5-JI; Tue, 11 Aug 2020 16:21:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k5W5w-0002ui-7m; Tue, 11 Aug 2020 16:21:44 +0100
Date:   Tue, 11 Aug 2020 16:21:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200811152144.GN1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200810220645.19326-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200810220645.19326-4-marek.behun@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 12:06:44AM +0200, Marek Behún wrote:
> RollBall SFPs contain Marvell 88X3310 PHY, but they have configuration
> pins strapped so that MACTYPE is configured in XFI with Rate Matching
> mode.
> 
> When these SFPs are inserted into a device which only supports lower
> speeds on host interface, we need to configure the MACTYPE to a mode
> in which the H unit changes SerDes speed according to speed on the
> copper interface. I chose to use the
> 10GBASE-R/5GBASE-R/2500BASE-X/SGMII with AN mode.

We actually need to have more inteligence in the driver, since we
actually assume that it is in the 10GBASE-R/5GBASE-R/2500BASE-X/SGMII
mode without really checking.

Note that there are differences in the way the mactype field is
interpreted depending on exactly what chip we have.  For example,
3310 and 3340 are different.  That said, I've not heard of anyone
using the 3340 yet.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
