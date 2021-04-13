Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F0535DB0A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhDMJYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343489AbhDMJYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:24:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BE1C061574;
        Tue, 13 Apr 2021 02:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=R9GQ7/qe2L3QkVEv8Za/HbNqMJ4ZTy0S5naUqEnTVwM=; b=WAckju/LOTKXAc/kphJjfY7DD
        sT68bHNciI2f1uCn3fZSzA36ODiMWgs5I4VrTQ3w3GA2wUrHGKy1d/U+6ZvYI0Kn0uHrlsJbgM+9p
        IFh6+ltCtepzF699CmZZfzzVBmezbYWhd4/MnWWRyPfoGZ3HDfWuSdoMXgj3VPIhdsZBUKV0NRp3j
        JWiyDycmutW4o5RmOs+Npj73u/urCrsxF1OZZ61NwFu5EPzl2uKCyJ3TVGERcMPEkZuyA4yLUeWgA
        sHU8bfiAWy1moA/1ug+ZIeTVCeP8EgR8wyvjrKSN35fzei+r+FmjBltVSKIcNt1tT+vTly7j0NNsc
        JYaYYAVag==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52370)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lWFGw-0005SJ-1a; Tue, 13 Apr 2021 10:23:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lWFGu-00085G-VI; Tue, 13 Apr 2021 10:23:48 +0100
Date:   Tue, 13 Apr 2021 10:23:48 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Andrew Lunn <andrew@lunn.ch>, system@metrotek.ru,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link
 is operational
Message-ID: <20210413092348.GM1463@shell.armlinux.org.uk>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
 <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
 <YHTacMwlsR8Wl5q/@lunn.ch>
 <20210413071930.52vfjkewkufl7hrb@dhcp-179.ddg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413071930.52vfjkewkufl7hrb@dhcp-179.ddg>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 10:19:30AM +0300, Ivan Bornyakov wrote:
> On Tue, Apr 13, 2021 at 01:40:32AM +0200, Andrew Lunn wrote:
> > On Mon, Apr 12, 2021 at 03:16:59PM +0300, Ivan Bornyakov wrote:
> > > Some SFP modules uses RX_LOS for link indication. In such cases link
> > > will be always up, even without cable connected. RX_LOS changes will
> > > trigger link_up()/link_down() upstream operations. Thus, check that SFP
> > > link is operational before actual read link status.
> > 
> > Sorry, but this is not making much sense to me.
> > 
> > LOS just indicates some sort of light is coming into the device. You
> > have no idea what sort of light. The transceiver might be able to
> > decode that light and get sync, it might not. It is important that
> > mv2222_read_status() returns the line side status. Has it been able to
> > achieve sync? That should be independent of LOS. Or are you saying the
> > transceiver is reporting sync, despite no light coming in?
> > 
> > 	Andrew
> 
> Yes, with some SFP modules transceiver is reporting sync despite no
> light coming in. So, the idea is to check that link is somewhat
> operational before determing line-side status. 

Indeed - it should be a logical and operation - there is light present
_and_ the PHY recognises the signal. This is what the commit achieves,
although (iirc) doesn't cater for the case where there is no SFP cage
attached.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
