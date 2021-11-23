Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9093445A14C
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbhKWLYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbhKWLYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 06:24:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F56C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 03:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=o88LUWlqxXIuP3ZLpfgoCIEAj6+f9ezyOUeQ202qh5k=; b=F6kk8NQEk4JY7QlKYI39d/jJ2m
        +GhpO7YriaXdpRDmbqhj8s45ANvoDLjTaKFsDDi0HtKarWRkChBg7i7asSGVoGzuIQA9oQa4UqyMU
        96tIChkGppxl5pmAcIz0eAyIxmizaYIkXtUkpzoA6qrGOM/Z36oXw47C9hrM/tGkSgpIXKWU6sEQr
        phKaHUNFEErfi2ifYMkcIVIWyC+AneuZYVckqbkmT4C3L7zgKYXCHBGFtv9dz43dj8ouqJf4G84Ne
        PJxLuGPxVYppslaTVlWt876O++wumQaUyshmD1r81q01m7HaZEWt+kCxuGBtEtRP1Dwc9amn5K7ey
        WZCMHvqQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55812)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpTrl-0007oO-Lj; Tue, 23 Nov 2021 11:21:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpTrl-0000Ai-8C; Tue, 23 Nov 2021 11:21:37 +0000
Date:   Tue, 23 Nov 2021 11:21:37 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net
Subject: Re: [PATCH net 2/2] net: phylink: Force retrigger in case of latched
 link-fail indicator
Message-ID: <YZzOwfkkdDVHr+jc@shell.armlinux.org.uk>
References: <20211122235154.6392-1-kabel@kernel.org>
 <20211122235154.6392-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211122235154.6392-3-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 12:51:54AM +0100, Marek Behún wrote:
> On mv88e6xxx 1G/2.5G PCS, the SerDes register 4.2001.2 has the following
> description:
>   This register bit indicates when link was lost since the last
>   read. For the current link status, read this register
>   back-to-back.
> 
> Thus to get current link state, we need to read the register twice.
> 
> But doing that in the link change interrupt handler would lead to
> potentially ignoring link down events, which we really want to avoid.
> 
> Thus this needs to be solved in phylink's resolve, by retriggering
> another resolve in the event when PCS reports link down and previous
> link was up.
> 
> The wrong value is read when phylink requests change from sgmii to
> 2500base-x mode, and link won't come up. This fixes the bug.
> 
> Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Marek Behún <kabel@kernel.org>

Same issue with this patch wrt authorship vs sign-off.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
