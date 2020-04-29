Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F671BD876
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 11:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgD2JkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 05:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2JkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 05:40:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6AF2073E;
        Wed, 29 Apr 2020 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588153213;
        bh=06QGmCH4KLF/RvPlbpJelFxqLn/a6H5uLKA85uyopzU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YDwJj/XTvderkznDijELLnwL5toOl/x7OxRcP9zQGlcOJzANv2iouBRVBiIPEEEte
         OvPuzNDZlqD4KwmRcwVQUKYn2/NF06OS37tJ21tPHP3sDhorWtny7fK07WmEriYNN+
         hkU5nYqr1o2Ig7i/Zi0J7+cm8afCpV3Uvnf8F89Y=
Date:   Wed, 29 Apr 2020 11:40:10 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "Quette, Arnaud" <ArnaudQuette@eaton.com>
Subject: Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Message-ID: <20200429094010.GA2080576@kroah.com>
References: <CH2PR17MB3542FD48AB01562BF812A948DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CH2PR17MB3542FD48AB01562BF812A948DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 09:03:32AM +0000, Badel, Laurent wrote:
> ﻿Description: This patch reverts commit 1b0a83ac04e3 
> ("net: fec: add phy_reset_after_clk_enable() support")
> which produces undesirable behavior when PHY interrupts are enabled.
> 
> Rationale: the SMSC LAN8720 (and possibly other chips) is known
> to require a reset after the external clock is enabled. Calls to
> phy_reset_after_clk_enable() in fec_main.c have been introduced in 
> commit 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
> to handle the chip reset after enabling the clock.
> However, this breaks when interrupts are enabled because
> the reset reverts the configuration of the PHY interrupt mask to default
> (in addition it also reverts the "energy detect" mode setting).
> As a result the driver does not receive the link status change
> and other notifications resulting in loss of connectivity. 
> 
> Proposed solution: revert commit 1b0a83ac04e3 and bring the reset 
> before the PHY configuration by adding it to phy_init_hw() [phy_device.c].
> 
> Test results: using an iMX28-EVK-based board, these 2 patches successfully
> restore network interface functionality when interrupts are enabled.
> Tested using both linux-5.4.23 and latest mainline (5.6.0) kernels.
> 
> Fixes: 1b0a83ac04e383e3bed21332962b90710fcf2828 ("net: fec: add phy_reset_after_clk_enable() support")

Please read Documentation/process/submitting-patches.rst and the section
"2) Describe your changes" at the end, it says how to do lines like this
"properly".

thanks,

greg k-h
