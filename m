Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C68116ECE
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfLIOPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:15:34 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34486 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfLIOPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:15:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eIUs6GOLonVPaMw5iVtHyY82OoSknfWxyjmhvzYLAEM=; b=XuxR5lZFhYWa+TBzr3+8vOi4i
        iS/GKtZ6Q9nDkzWPHgdNmqm4hWUEHaCiBK8WBmfJtNNeF7TvKZxUPCeRGSy8Ez1lCQLXuaEQ+Zh6f
        lZNNbrxJT/c7GQmtymEKbMSXLsbgRTuTaPEN+g+1u6oBOUn/kAvwYRHjTrqHsuRZES2MFOIU9oG/Y
        LjkwudDhuUdUpm2F5fnvMU0BxUgbfYu79MizZjOdzLYtloHaXXZSauKA9YQrzmRBfGFq55/SNnN70
        zk0VtOaV72iYvgPeAXxeDNM+kb+Pvk6Z5mKgJjstgBQSF0c6VS/+tAI4/lnjUc14tZOu2Nux9sBwt
        ZWXYQfh8A==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:46496)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ieJot-0003Ue-G5; Mon, 09 Dec 2019 14:15:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ieJor-0003iM-OR; Mon, 09 Dec 2019 14:15:25 +0000
Date:   Mon, 9 Dec 2019 14:15:25 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] Add support for slow-to-probe-PHY copper SFP
 modules
Message-ID: <20191209141525.GK25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


This series, following on from the previous adding SFP+ copper support,
adds support for a range of Copper SFP modules, made by a variety of
companies, all of which have a Marvell 88E1111 PHY on them, but take
far longer than the Marvell spec'd 15ms to start communicating on the
I2C bus.

Researching the Champion One 1000SFPT module reveals that TX_DISABLE is
routed through a MAX1971 switching regulator and reset IC which adds a
175ms delay to releasing the 88E1111 reset.

It is not known whether other modules use a similar setup, but there
are a range of modules that are slow for the Marvell PHY to appear.

This patch series adds support for these modules by repeatedly trying
to probe the PHY for up to 600ms.

 drivers/net/phy/sfp.c | 91 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 66 insertions(+), 25 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
