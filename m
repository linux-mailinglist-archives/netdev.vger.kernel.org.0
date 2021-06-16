Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E243A9BFD
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 15:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhFPNbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 09:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhFPNbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 09:31:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C92C061574;
        Wed, 16 Jun 2021 06:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eV9wlaJRtH6xgA6NpxWOpKQTk5aIanp5IHRWCYIODGA=; b=ItNfW2usIA0QybWdB9nm+9frE
        CYTWyLkj+0HBDYNR/94lmFjpWew8IuY77Iat62zdub4KMpevVKeD2wbFK/nMxZ3b6PBnK6J8eIjKx
        ZKOnZnCVG1PEQLlsZOVog+NkC8L6jiT1tZntlfZqrsrn2zFnKaYM3haM1WThTps/oXXUkX4qD68tG
        e84yXwQsEMzwepnbZnC088WRZc5h1zr6+nQFWdXhtdrGcX+znHP1U/ySzfbRZTdSrJY489ElfblKB
        gfrXzBnxrHNKD1RTs+6+8Y+mrnbEirBdJj3jSSZjbPc6vCey7O69lYRuFxeiyDlva1lY24Qga22/q
        Hmvj1Xb/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45068)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ltVbK-0007Gk-P7; Wed, 16 Jun 2021 14:29:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ltVbH-000645-PM; Wed, 16 Jun 2021 14:28:59 +0100
Date:   Wed, 16 Jun 2021 14:28:59 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH net 1/2] net: fec_ptp: add clock rate zero check
Message-ID: <20210616132859.GE22278@shell.armlinux.org.uk>
References: <20210616091426.13694-1-qiangqing.zhang@nxp.com>
 <20210616091426.13694-2-qiangqing.zhang@nxp.com>
 <20210616102038.GB22278@shell.armlinux.org.uk>
 <VI1PR04MB68004D29895652864B4C1D20E60F9@VI1PR04MB6800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB68004D29895652864B4C1D20E60F9@VI1PR04MB6800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

On Wed, Jun 16, 2021 at 11:40:29AM +0000, Joakim Zhang wrote:
> Do you mean that print an error message then return directly? It seems better.

Nearly - one has to ensure that the cleanup functions don't provoke a
crash though. I notice fec_ptp_stop() makes use of fep->time_keep
and also fep->ptp_clock.

fep->time_keep is initialised after where you need to test for zero
cycle_speed, so the initialisation would need moving earlier.

I would have thought that ftp->ptp_clock should be NULL, so that's
probably okay, but should be checked that this assumption is in fact
true.

> if (!fep->cycle_speed) {
> 	dev_err(&fep->pdev->dev, "PTP clock rate should not be zero!\n");

I'd still say something like "PTP clock rate should not be zero,
disabling PTP" - say what's wrong and what we are doing. Also,
please avoid exclaimation marks in error messages.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
