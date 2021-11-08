Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46B0449786
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbhKHPKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:10:13 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57834 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240688AbhKHPJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 10:09:40 -0500
Date:   Mon, 8 Nov 2021 16:06:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636384015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mmYjYs0vxRDEE03tUyW2SGvMXjLzVD6zu3z0n7ne0e4=;
        b=ZYwFJ0PFXHDzr8j/2kC16IdAQhQPvU43EvAZEBsAC7P7vyKhOBEKSxO6kB5kGUPJ/bgb2m
        BG+d3QzPpT61PdGRMKGJBIhvw9ddBDeuYL3cYrrTVgwS1kiv78tzTgJhzlWDGL2m41lR8L
        iSjkGMA4yGdGnAcpWpMyaYSs8MiwspNOHHnFCTPDjgniAXCIMyL6AuRyzALJ0xjuTaES41
        3r60sy89vskVUowCVVLS6PztV/JIgmMH1bCtBVIkimxZqenwIdrwF35YCEQnJsUK/8zpAb
        MNSJSMTmMfUYorps+Vxx9hAMUu0p+UrqVrxDjnV8PnEF5TR8e7JgkPp/wsgMJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636384015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mmYjYs0vxRDEE03tUyW2SGvMXjLzVD6zu3z0n7ne0e4=;
        b=J/wUZJFNsA0k89NESZ2TQ7U3xplIiYBdyXlKre4T6e9TwwTsIURiBBOVRsMt9IHungBCAk
        PsLr/X2XJZRaZMAQ==
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     bage@linutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't
 discard phy_start_aneg's return
Message-ID: <20211108160653.3d6127df@mitra>
In-Reply-To: <YYkzbE39ERAxzg4k@shell.armlinux.org.uk>
References: <20211105153648.8337-1-bage@linutronix.de>
        <20211108141834.19105-1-bage@linutronix.de>
        <YYkzbE39ERAxzg4k@shell.armlinux.org.uk>
Organization: Linutronix GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 14:25:48 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Mon, Nov 08, 2021 at 03:18:34PM +0100, bage@linutronix.de wrote:
> > From: Bastian Germann <bage@linutronix.de>
> > 
> > Take the return of phy_start_aneg into account so that ethtool will
> > handle negotiation errors and not silently accept invalid input.
> 
> I don't think this description is accurate. If we get to call
> phy_start_aneg() with invalid input, then something has already
> gone wrong.
The MDI/MDIX/auto-MDIX settings are not checked before calling
phy_start_aneg(). If the PHY supports forcing MDI and auto-MDIX, but
not forcing MDIX _phy_start_aneg() returns a failure, which is silently
ignored.

> As Andrew has already explained, an error from this
> function means that something went wrong with PHY communication.
Or for MDI/MDIX setings, the PHY does not support a feature/setting.

> All validation should have happened prior to this function being
> called.
OK.
Just to be clear: The PHY driver should check the settings and return
an error before calling phy_ethtool_ksettings_set() ?

Thanks
    Bene
