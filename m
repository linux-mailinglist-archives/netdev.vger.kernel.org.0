Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B23A2FEB65
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbhAUNRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729436AbhAUKaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 05:30:03 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162C3C0617A7
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 02:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nN/PFvEtSXeqOf8UVnMBDcx8egfw1RgDQS24sU7HuH0=; b=VEW9D0fFg5bIB9/TcTQJfvn+D
        yyxN+vvx9w3BgnGaMdhiTz7usyKDyyM4XGBfiroQfXkGYYLM5oG7YI3q20x8VOK9Zl6TeQ5eCvxoc
        pzb9iFA6V+VjQa5Tl7APmKEa8rHaLCGX7UQIpQEPKmbE3sm+WdC+YTldpb5M1zFs4lLU+xKeibKKk
        Jy2OlE44iZ4BUSFExgkOn5+r5l38bH6CSY/kL8z438KT47kmOjZcTz85J+xdLEMTdZLCoZ4vj4fnq
        0z/io9xHz8sMl7wk/FeEKgtfZX1rreuOI4YyLzRNT5KzrSWEyUF942RW5oDY+uEIwoxgkmlKUUnLs
        CneJ44T2A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50772)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l2XBj-0001CD-VQ; Thu, 21 Jan 2021 10:27:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l2XBi-0006yj-Lt; Thu, 21 Jan 2021 10:27:38 +0000
Date:   Thu, 21 Jan 2021 10:27:38 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210121102738.GN1551@shell.armlinux.org.uk>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
 <20210114173111.GX1551@shell.armlinux.org.uk>
 <20210114223800.GR1605@shell.armlinux.org.uk>
 <20210121040451.GB14465@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121040451.GB14465@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 08:04:51PM -0800, Richard Cochran wrote:
> On Thu, Jan 14, 2021 at 10:38:00PM +0000, Russell King - ARM Linux admin wrote:
> 
> > So, I think the only way to prevent a regression with the code as
> > it is today is that we _never_ support PTP on Marvell PHYs - because
> > doing so _will_ break the existing MVPP2 driver's implementation and
> > cause a regression.
> 
> The situation isn't as bad as it seems.
> 
> For one thing, mvpp2 incorrectly selects NETWORK_PHY_TIMESTAMPING.
> It really shouldn't.  I'm submitting a fix soon.
> 
> As long as the new PHY driver (or at least the PTP bit) depends on
> NETWORK_PHY_TIMESTAMPING, then that allows users who _really_ want
> that to enable the option at compile time.  This option adds extra
> checks into the networking hot path, and almost everyone should avoid
> enabling it.

As I already explained to you, you can *NOT* use kernel configuration
to make the choice.  ARM is a multi-platform kernel, and we will not
stand for platform choices dictated by kernel configuration options.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
