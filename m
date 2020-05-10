Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180991CCB79
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgEJOIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728238AbgEJOIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 10:08:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E874C061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 07:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gxb3RJ6Fb6nov5qENDEfqMJDfEqAWtU4YvqmDuaesww=; b=vaY1CyerQscYJ0EBrrSVGMDlJ
        pS8S0CIN7Yq0i1zLbVUpaKSlvUqCH/FGaXvLbxpuOPWfj95EfaENLi+WIGptIYnRa7EK0IyNyiuTL
        yoLRr+cobyIWSYETAKBJQ4lnWamaf3uGRSBYnqeZvYOtjb/k7Mq50O1Mq68cZPFTCgakirwixA8EQ
        mM+5Rmg4OG/qkt4MqLNwJPplNg8xuOgxKydyDr2cquKcwduq6uYuHZpYBpGl2T4qDm8Fdp6X450kl
        hFi1IMy4jP5QBCj59NpmmwrzzTwZKHfycMbpIaSALsrnvw2G27AQk4PDbQfWbJ3mdiP4KydQFMpw9
        ASJaqb4uA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:38478)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXmcc-0007G0-De; Sun, 10 May 2020 15:08:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXmcb-0004gi-Dv; Sun, 10 May 2020 15:08:01 +0100
Date:   Sun, 10 May 2020 15:08:01 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] r8169: rely on sanity checks in
 phy_ethtool_set_eee
Message-ID: <20200510140801.GN1551@shell.armlinux.org.uk>
References: <8e7df680-e3c2-24ae-81d3-e24776583966@gmail.com>
 <104d788a-68ee-9669-f920-656dcb1e6d83@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104d788a-68ee-9669-f920-656dcb1e6d83@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 10:12:40AM +0200, Heiner Kallweit wrote:
> These checks are integrated in phy_ethtool_set_eee() now, therefore we
> can remove them from the driver.

Ah, so one NIC driver has a problem with this, so we have to apply that
pain to all NIC drivers?  No thanks.

Have you looked at how the driver decides whether EEE should be enabled?
Does it check that the link negotiated FD prior to enabling EEE?  That
is likely where the problem is.

Throwing big hammers to prevent the user configuring EEE settings on any
driver just because one driver has a problem is really not a sane
approach, and in fact I can tell you now that I will be pointing out a
userspace regression as a result of your patches - I can tell you now,
your patch 1 _will_ regress my userspace.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
