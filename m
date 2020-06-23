Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32162057C0
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733309AbgFWQqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732662AbgFWQqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:46:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95752C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UxFC/RC9fnjTIIetkCCEu+q7HeolRvswHPQutvoIRsw=; b=V/WGd+ZusxzXQKr2e3BQ/dKrR
        /YZwqIiZwXcN0IXY4D4DNjtdEIdTuoBTHW05ZyBTlDX50wLQwOYps49gaae12soYgSSziCQSw9ekR
        WidU+wD3p3IO5hHHuSzCgZbLPa4fzBB97OIwj8rD60io0axCprsypSI6N4ahub+dtIDug8UD8ROPD
        3HQbuqUUgJK8X6NNSyyfGsZDZ9qWH+OHxst2mkocfcnnpmgstqlFI1SHqmcmD6ebZSRQYI0aAdx/R
        WqD3mR6WRjLjdAkpsFklS+wwxo32hPF6Bhj2xCpx4njIdNNWruxyd8KoxFVkVpF34z8FJP5eET9xR
        S72hWeWBA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59020)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnm4L-0001yj-8s; Tue, 23 Jun 2020 17:46:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnm4I-00019X-L8; Tue, 23 Jun 2020 17:46:42 +0100
Date:   Tue, 23 Jun 2020 17:46:42 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net 0/2] Two phylink pause fixes
Message-ID: <20200623164642.GV1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing, I discovered two issues with ethtool -A with phylink.
First, if there is a PHY bound to the network device, we hit a
deadlock when phylib tries to notify us of the link changing as a
result of triggering a renegotiation.

Second, when we are manually forcing the pause settings, and there
is no renegotiation triggered, we do not update the MAC via the new
mac_link_up approach.

These two patches solve both problems, and will need to be backported
to v5.7; they do not apply cleanly there due to the introduction of
PCS in the v5.8 merge window.

 drivers/net/phy/phylink.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
