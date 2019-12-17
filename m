Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424B2123AC1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLQXZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:25:35 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35502 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfLQXZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+ZRgwQu/8qI//tu+qKKPwWQ1BDjAVgEdedDApeEuiZE=; b=x2msvNHUyof3OiOD7rm/owvx/
        GYhGhesmWA4ThYMegAxSZDkg48O9V23bbMVm8hppJRr3CXP4JJFwRC2ujRLwn4VP9UkZ0OdLmhy2f
        3wN8UA+/mBi7FV4LihERQQw6+jneYC1OXUCvh8pytZ3I7f8YMuAdGQhhSfQ032z7GSEtfZ+Oz22sy
        Glu9m6XDY4tSGiXJagB9iyS2QIUYFSVS8IGLF4TXMolD/McNJc0u5QP+2x07dIvD8VRFnlkp88Qq6
        BccwBYpnOMMqB4bdD8OOuzzAVmGQzHzZvhi7oasYfcgw9Om2FbKqh8A55eeQSJMBUKYmRO2/ETtdy
        uF8a43l5Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50250)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihMDQ-0000PL-UH; Tue, 17 Dec 2019 23:25:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihMDL-0003mN-Q1; Tue, 17 Dec 2019 23:25:15 +0000
Date:   Tue, 17 Dec 2019 23:25:15 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 3/8] net: phylink: call mac_an_restart for
 SGMII/QSGMII inband interfaces too
Message-ID: <20191217232515.GR25745@shell.armlinux.org.uk>
References: <20191217221831.10923-1-olteanv@gmail.com>
 <20191217221831.10923-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217221831.10923-4-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 12:18:26AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It doesn't quite make sense why restarting the AN process should be
> unique to 802.3z (1000Base-X) modes. It is valid to put an SGMII PCS in
> in-band AN mode, therefore also make PHYLINK re-trigger an
> auto-negotiation if needed.

The question I'd ask is how is that actually achieved on the link?

It makes sense for 1000base-X because either end can drop the ACK bit
to cause a renegotiation to occur, but it makes no sense for SGMII.

In SGMII:
1) there is no advertisement from the MAC to the PHY
2) the PHY is merely informing the MAC of the results of negotiation

Attempting to trigger a renegotiation at the MAC end does nothing
useful for SGMII, it doesn't cause the PHY to renegotiate with its
link partner.

The whole point of SGMII over 1000base-X is that the PHY informs the
MAC using in-band signalling what the results of negotiation were on
the media side of the PHY. SGMII provides no way to control the
advertisement.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
