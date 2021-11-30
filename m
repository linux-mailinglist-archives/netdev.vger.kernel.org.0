Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E562463B7B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbhK3QTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236801AbhK3QTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:19:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09817C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q0cuy1stduW0XDk+ywrcsvnG667yAb/iwyBaum0+U1E=; b=kXnGtcM1xDnOmFCSl6Md4teqMe
        fjuneE9LrdJVwQfZVBeKmyzxUrcWPJDw9828eGk9yEFh/Jhb9fYX5LhheZkLyaePknuaK707EHcUQ
        HV7eS8XpJEacRVhJWsYj35dwOS7Q2lLfpbyE/G4rmKCXrqZyrFCFungenncf2zmIpMKAX6fTRmybJ
        NWviQ4o9WXr7XP8w0NdEBW9AR0VijqqMeKLufRRYSTgPr64U7Nj/4XGAwXBGDNDJEg7XDwB1CCADm
        42GYxGNHJyVqVaTvGLDfEs4dfA1xqAZHUFBflAd6bncegGJOTaNyLg3fSau5VBxr18cyR85cXOTaa
        xhbp7KHw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55990)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ms5nM-00078H-2q; Tue, 30 Nov 2021 16:15:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ms5nK-0007BH-5X; Tue, 30 Nov 2021 16:15:50 +0000
Date:   Tue, 30 Nov 2021 16:15:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net 6/6] net: dsa: mv88e6xxx: Link in pcs_get_state() if
 AN is bypassed
Message-ID: <YaZONv7fmRWK+qCb@shell.armlinux.org.uk>
References: <20211129195823.11766-1-kabel@kernel.org>
 <20211129195823.11766-7-kabel@kernel.org>
 <YaVeyWsGd06eRUqv@shell.armlinux.org.uk>
 <20211130011812.08baccdc@thinkpad>
 <20211130170911.6355db44@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211130170911.6355db44@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 05:09:11PM +0100, Marek Behún wrote:
> Seems that BMSR_ANEGCAPABLE is set even if AN is disabled in BMCR.

Hmm, that behaviour goes against 22.2.4.2.10:

A PHY shall return a value of zero in bit 1.5 if Auto-Negotiation is
disabled by clearing bit 0.12. A PHY shall also return a value of zero
in bit 1.5 if it lacks the ability to perform Auto-Negotiation.

> I was under the impression that
>   state->an_complete
> should only be set to true if AN is enabled.

Yes - however as you've stated, the PHY doesn't follow 802.3 behaviour
so I guess we should make the emulation appear compliant by fixing it
like this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
