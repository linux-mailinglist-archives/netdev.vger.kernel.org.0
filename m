Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE862C5909
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 17:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391132AbgKZQNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 11:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgKZQNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 11:13:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F37DC0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 08:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l3yD3efGeELnERGSubAh9PsKp7csqILlF2BudiqgyvM=; b=wU5wFd0mBFvzH1RNU+w4pvI8J
        FP7KOg9rc76jh5cD/ZRmIYHnYRJy7dyvFyf2CEYuJ8KMF5huHqNlXaQNDM+G211WvHUYGsRMV92uf
        jVal47youM+fgjQUEjTOppN5UeXwyFZ8Qj5WNte9TW09quV2cwbl3iFKS5tZEju6SqvI69d8LqE1E
        5H9RUQo6keQ85Q+I5yMQAhvhlSevZrPHh6acoPJT/zLCBFG4tJ3XMSMNqMeB652VKrgSdwDr4Og3F
        r9HTZxBE8r2KI0sKtTzLH0Y1ZRWS0+XvLsV+pEk3403QxKDscV8mj9Jncwm1bEv2jB9QkqYwrl24c
        SvXo2/1hg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36384)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kiJu1-00022C-Ep; Thu, 26 Nov 2020 16:13:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kiJu0-000159-W1; Thu, 26 Nov 2020 16:13:49 +0000
Date:   Thu, 26 Nov 2020 16:13:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Get MAC supported link modes for SFP port
Message-ID: <20201126161348.GO1551@shell.armlinux.org.uk>
References: <87pn40uo25.fsf@tarshish>
 <20201126154716.GN2073444@lunn.ch>
 <87mtz4umxs.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtz4umxs.fsf@tarshish>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 06:01:35PM +0200, Baruch Siach wrote:
> Hi Andrew,
> 
> On Thu, Nov 26 2020, Andrew Lunn wrote:
> > On Thu, Nov 26, 2020 at 05:37:22PM +0200, Baruch Siach wrote:
> >> I am trying to retrieve all MAC supported link modes
> >> (ETHTOOL_LINK_MODE_*) for network interfaces with SFP port. The
> >> 'supported' bit mask that ETHTOOL_GLINKSETTINGS provides in
> >> link_mode_masks[] changes to match the SFP module that happens to be
> >> plugged in. When no SFP module is plugged, the bit mask looks
> >> meaningless.
> >
> > That sounds like it is doing the correct thing.
> >
> >> I understand that ETHTOOL_LINK_MODE_* bits are meant to describe PHY
> >> level capabilities. So I would settle for a MAC level "supported rates"
> >> list.
> >
> > What is your use cases?
> 
> I would like to report the port supported data rates to the system
> user. I need to tell whether 10Gbps SFP module are supported in that
> port in a generic way. The driver has this information. It is necessary
> to implement the validate callback in phylink_mac_ops. But I see no way
> to read this information from userspace.

If we want to know whether 10Gbps SFPs are supported in a cage, and
that information is important, we really ought to use a different
DT compatible for it. I've debated about using "sff,sfp+" since that's
what they are - but I have no use practical for it, so I've not made
the change.

This is especially important as there are boards out there
(Macchiatobin) where the SFP+ sockets do not support SFP modules
from the electrical point of view, and if you happen to plug in a
SFP module, you may end up with its EEPROM being corrupted merely
as a result of plugging the module in and the ID trying to be read.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
