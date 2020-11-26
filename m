Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1422C5871
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390021AbgKZPp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387523AbgKZPp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 10:45:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E776C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 07:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xKSi5XWTUYcPsFMTa3TLeEJIxccB6nKtggzGUyQrVsE=; b=oagLXsEQGnjPtYAEw3qHRh8uf
        +3bfaw/+KKcA/exk1h6iJLD7J5/FsajF6gOTvWtoRikLyG4Lf5n+ykdRKDsuXbbo/Ymm1RmikhtrJ
        qAiexJaIdGzHCg4ULp+Sl7YT68sSR4fdK2IdaSW3/wrjlIDWAmZAK2myq9du1Qyexp1PWDBjAz40W
        ct/UUOY3OOuwZTAKOT8iIBcKePH1JQDdiLAxq8iufrz8QeIwcv1eOFTvuqVXXGRZzsbbvYh6vnase
        MVN9NRgDN3GDHIBSfJSs8es8oPxmlmvpbvCwzG5rM4OTnfTEcWTbO67oG7zPC0pyaKnHIB3DzpQ8T
        nw01XuuOw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36374)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kiJT0-0001yI-Oq; Thu, 26 Nov 2020 15:45:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kiJSz-00013r-WB; Thu, 26 Nov 2020 15:45:54 +0000
Date:   Thu, 26 Nov 2020 15:45:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Get MAC supported link modes for SFP port
Message-ID: <20201126154553.GN1551@shell.armlinux.org.uk>
References: <87pn40uo25.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn40uo25.fsf@tarshish>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 05:37:22PM +0200, Baruch Siach wrote:
> Hi netdev list,
> 
> I am trying to retrieve all MAC supported link modes
> (ETHTOOL_LINK_MODE_*) for network interfaces with SFP port. The
> 'supported' bit mask that ETHTOOL_GLINKSETTINGS provides in
> link_mode_masks[] changes to match the SFP module that happens to be
> plugged in. When no SFP module is plugged, the bit mask looks
> meaningless.
> 
> I understand that ETHTOOL_LINK_MODE_* bits are meant to describe PHY
> level capabilities. So I would settle for a MAC level "supported rates"
> list.
> 
> Is there anything like that?

No, because there's a problem: the link modes that the MAC supports
is not a particularly certain thing. When there's no module inserted,
we don't know what interface mode may be in operation, and the
interface mode has a big handle in determining which link modes can
be supported.

For example, if it's operating as 1000BASE-X or 10GBASE-R, then we're
pretty limited to a single link mode if there's nothing else present.
If it's in SGMII, then 10/100/1000 speeds are possible but there's
no link mode to describe that - no PHY, therefore there's no copper
and therefore BASE-T is meaningless.

The ethtool link modes are, in reality, _media_ link modes. If there
is no media or socket that defines the media, there are no link modes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
