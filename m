Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04693C2718
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhGIP5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhGIP5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:57:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0355BC0613DD;
        Fri,  9 Jul 2021 08:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Jsw/ngtLTGz+rX9IOc4ToB/qHLSDIH6IoMbYjr26N84=; b=BQWj9lG9sPMHYq+SZocXjF36l
        Kf686SWmfxqe644Vwy0kAPJrFS1O4pNRSDP5COdHLWNQqQHVDp3FYsVLpco1PYV4okgZinEG7jpr9
        79OHDMvu3/WGmycSN58LFuNV8lgyYAfQATMiNNC3mK8YywFFTNZuyZU2hPUoMn3xuL+yZGBANt2xq
        bzTjSEVEkoZOyEX6IoJlgwoUynR7IqpxlpwiEsyJkk8dAKQsHLvQd+IGkizaBJuUWPdUBum3X8x7b
        tc6R3nqnwy28k69fLtvkoJkAoa+5xelUNDK27HNBTcSxJNVkN9b8JU1c8unYxoInf8g2xfbZOdA+u
        bVualvlaQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45920)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m1spw-000200-Sn; Fri, 09 Jul 2021 16:54:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m1spw-00055L-Ao; Fri, 09 Jul 2021 16:54:44 +0100
Date:   Fri, 9 Jul 2021 16:54:44 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: PHY reset may still be asserted during MDIO probe
Message-ID: <20210709155444.GB22278@shell.armlinux.org.uk>
References: <CAMuHMdXno2OUHqsAfO0z43JmGkFehD+FJ2dEjEsr_P53oAAPxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXno2OUHqsAfO0z43JmGkFehD+FJ2dEjEsr_P53oAAPxA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 05:33:36PM +0200, Geert Uytterhoeven wrote:
> Hi all,
> 
> I'm investigating a network failure after kexec on the Renesas Koelsch
> and Salvator-XS development boards, using the sh-eth or ravb driver.

Personally, I've never liked the reset support at PHY device level due
to problems like the one you've identified here. I've tended to use the
bus-level reset in preference to the PHY-level reset, particularly
because when you have multiple PHYs on the bus all sharing a common
reset, it seems to be the most sensible approach - and I see a single
PHY as no different from multiple PHYs on the bus.

However, I can see the argument for using the PHY level, but as you
note, that can create chicken and egg issues. I'm not entirely sure
why we decide to hold a PHY in reset when we've found it but not
started to make use of it - we don't do that with other devices in
the system. Why are PHYs special?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
