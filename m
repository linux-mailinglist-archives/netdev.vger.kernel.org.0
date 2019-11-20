Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E431038D7
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 12:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfKTLjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 06:39:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39114 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbfKTLjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 06:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YfqBa5t6/zfbK3PDsPH49E/noO60NMWG9e7AqbzYRkw=; b=eBZvtGXqEXJA+QBzOfsivLA60
        R5NljMQuyrT0/Vl1xOR+L7bRJnwdKAQmO5RgXca3Bp3HZlxPG0IX5HycMHlBeEsWJuscURKPx5jEK
        fvTuUpVUiLzvdPuqF/yj2BsTewGtoqkRbwjL88kHN7z6MRN1MpZJiC7Vihyr/Ofew3Iod4R+DudRo
        iOxPabSgj6dESjYUWkXgnAvK7BG2YBct7s2HAqlvWWxd23UdCF2p6oTWObVq1BJA9IYTRgupL8X6G
        fYQH4Ks8WIBwq4I4fiQgh8ywxpplBTdUVqgR99QlY/z59OW4PcztJWTq6PTbMLVbHr1ncic+Rryre
        MTa3JDWvw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38026)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXOK7-00083B-AJ; Wed, 20 Nov 2019 11:39:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXOK4-0001hU-Dg; Wed, 20 Nov 2019 11:39:00 +0000
Date:   Wed, 20 Nov 2019 11:39:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Add rudimentary SFP module quirk support
Message-ID: <20191120113900.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SFP module EEPROM describes the capabilities of the module, but
doesn't describe the host interface.  We have a certain amount of
guess-work to work out how to configure the host - which works most
of the time.

However, there are some (such as GPON) modules which are able to
support different host interfaces, such as 1000BASE-X and 2500BASE-X.
The module will switch between each mode until it achieves link with
the host.

There is no defined way to describe this in the SFP EEPROM, so we can
only recognise the module and handle it appropriately.  This series
adds the necessary recognition of the modules using a quirk system,
and tweaks the support mask to allow them to link with the host at
2500BASE-X, thereby allowing the user to achieve full line rate.

 drivers/net/phy/sfp-bus.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
