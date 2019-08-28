Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41116A083A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfH1ROn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:14:43 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59414 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfH1ROn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 13:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9Z/2gp4d2tq6OAY4nHknijwxc3d9hIxA1EAywU0WQJE=; b=MF4I47s2GXNHQvzXlUjPYb1e+
        XdEwYrVRX5BSw/YHLKLwclZWOTYKKAp59ogy9RzRkRmQyyeXIw00zDONtUDunnDC/Z4lGbSbR5Nqx
        QsiwWyvN5OsyJ3q5UOe7iAQgbTe+iBlM4IbxWDtkxMkzyypgmlxStSFH/ydWljVK3oAc5WVldnSMS
        U+6E398VfTjsIHpQtLTN7HsJ+mKPJYn/ADeTTnDlH4eLV3LspSWdo+4R0hEtcSPJPGJzKbhMXirfJ
        Ym8JQVWH101UzzROsn0Q7S3wbIREb22H79cb0y/LJaKDG8wYlDiYH9Gm5rEJMpQWjnItxuGti0yUH
        j7Bcu20TA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34966)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i31Wk-0003mm-BN; Wed, 28 Aug 2019 18:14:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i31Wh-0006tj-G0; Wed, 28 Aug 2019 18:14:31 +0100
Date:   Wed, 28 Aug 2019 18:14:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, asolokha@kb.kras.ru,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] phylink: Set speed to SPEED_UNKNOWN when there
 is no PHY connected
Message-ID: <20190828171431.GR13294@shell.armlinux.org.uk>
References: <20190828145802.3609-1-olteanv@gmail.com>
 <20190828145802.3609-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828145802.3609-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 05:58:02PM +0300, Vladimir Oltean wrote:
> phylink_ethtool_ksettings_get can be called while the interface may not
> even be up, which should not be a problem. But there are drivers (e.g.
> gianfar) which connect to the PHY in .ndo_open and disconnect in
> .ndo_close. While odd, to my knowledge this is again not illegal and
> there may be more that do the same. But PHYLINK for example has this
> check in phylink_ethtool_ksettings_get:
> 
> 	if (pl->phydev) {
> 		phy_ethtool_ksettings_get(pl->phydev, kset);
> 	} else {
> 		kset->base.port = pl->link_port;
> 	}
> 
> So it will not populate kset->base.speed if there is no PHY connected.
> The speed will be 0, by way of a previous memset. Not SPEED_UNKNOWN.
> It is arguable whether that is legal or not. include/uapi/linux/ethtool.h
> says:
> 
> 	All values 0 to INT_MAX are legal.
> 
> By that measure it may be. But it sure would make users of the
> __ethtool_get_link_ksettings API need make more complicated checks
> (against -1, against 0, 1, etc). So far the kernel community has been ok
> with just checking for SPEED_UNKNOWN.
> 
> Take net/sched/sch_taprio.c for example. The check in
> taprio_set_picos_per_byte is currently not robust enough and will
> trigger this division by zero, due to PHYLINK not setting SPEED_UNKNOWN:
> 
> 	if (!__ethtool_get_link_ksettings(dev, &ecmd) &&
> 	    ecmd.base.speed != SPEED_UNKNOWN)
> 		picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
> 					   ecmd.base.speed * 1000 * 1000);

The ethtool API says:

 * If it is enabled then they are read-only; if the link
 * is up they represent the negotiated link mode; if the link is down,
 * the speed is 0, %SPEED_UNKNOWN or the highest enabled speed and
 * @duplex is %DUPLEX_UNKNOWN or the best enabled duplex mode.

So, it seems that taprio is not following the API... I'd suggest either
fixing taprio, or getting agreement to change the ethtool API.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
