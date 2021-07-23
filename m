Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A95D3D3615
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhGWHZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbhGWHZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:25:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCDBC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 01:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hWzmbDjzDl4wgryV4garyrX1jhNsvuWlbOf+ov5G2vU=; b=zcKTTinjpymFK+nh2TZBAlfzm
        YPQie6+vX0V/IvN6VPtlsGyTqrmvYyviKriZsCXSnbG7Hzk175W1UGMdShOLCGqj4L9W6B5gijVar
        aBrgvz9uo+jjJtBLBfy1fgm8dq5VaRXVNbwa1g2AErX/1XwkvvS3XLjSC/NwfbzjbbMhAS+Egfuuk
        SG8+oulWWUBW7nTrcmNdnJZKPK/k88k/oBvZr2mE0goYZpUvTmT+rwJo02kFXtglgQs70q+pxPi7n
        /l2pD13Ev+kMJt20fdFyBwHrKnymxDysfIMfbu7AtXC3DSwlqjmNjbk33MMPYi7QBR6iBqbnoCj4h
        /RS1IkHzg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46502)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m6qBe-0001fb-WD; Fri, 23 Jul 2021 09:05:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m6qBe-0001di-Mw; Fri, 23 Jul 2021 09:05:38 +0100
Date:   Fri, 23 Jul 2021 09:05:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: mvpp2 switch from gmac to xlg requires ifdown/ifup
Message-ID: <20210723080538.GB22278@shell.armlinux.org.uk>
References: <20210723035202.09a299d6@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210723035202.09a299d6@thinkpad>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 03:52:02AM +0200, Marek Behún wrote:
> Hello Russell (and possibly others),
> 
> I discovered that with mvpp2 when switching from gmac (sgmii or
> 2500base-x mode) to xlg (10gbase-r mode) due to phylink requesting this
> change, the link won't come up unless I do
>   ifconfig ethX down
>   ifconfig ethX up
> 
> Can be reproduced on MacchiatoBIN:
> 1. connect the two 10g RJ-45 ports (88X3310 PHY) with one cable
> 2. bring the interfaces up
> 3. the PHYs should link in 10gbase-t, links on MACs will go up in
>    10gbase-r
> 4. use ethtool on one of the interfaces to advertise modes only up to
>    2500base-t
> 5. the PHYs will unlink and then link at 2.5gbase-t, links on MACs will
>    go up in 2500base-x
> 6. use ethtool on the same interface as in step 4 to advertise all
>    supported modes
> 
> 7. the PHYs will unlink and then link at 10gbase-t, BUT MACs won't link
>    !!!
> 8. execute
>      ifconfig ethX down ; ifconfig ethX up
>    on both interfaces. After this, the MACs will successfully link in
>    10gbase-r with the PHYs
> 
> It seems that the mvpp2 driver code needs to make additional stuff when
> chaning mode from gmac to xlg. I haven't yet been able to find out
> what, though.
> 
> BTW I discovered this because I am working on adding support for
> 5gbase-r mode to mvpp2, so that the PHY can support 5gbase-t on copper
> side.
> The ifdown/ifup cycle is required when switching from gmac to xlg, i.e.:
> 	sgmii		to	5gbase-r
> 	sgmii		to	10gbase-r
> 	2500base-x	to	5gbase-r
> 	2500base-x	to	10gbase-r
> but also when switching from xlg to different xlg:
> 	5gbase-r	to	10gbase-r
> 	10gbase-r	to	5gbase-r
> 
> Did someone notice this bug? I see that Russell made some changes in
> the phylink pcs API that touched mvpp2 (the .mac_config method got
> split into .mac_prepare, .mac_config and .mac_finish, and also some
> other changes). I haven't tried yet if the switch from gmac to xlg
> worked at some time in the past. But if it did, maybe these changes
> could be the cause?

What are the PHY leds doing when you encounter this bug?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
