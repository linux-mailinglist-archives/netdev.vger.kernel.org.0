Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4038F125EAF
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfLSKPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:15:07 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60184 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfLSKPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UESy3mIwqghVP1fRUufEFJMVIWQZLgeNc0gbqddcABA=; b=uEZRQJn6nKCZHZ2UKk6m/e41M
        akjypVz4+iNv7+GllBZVGLLGH9vSnT55xidlGx63brixAWWHKy3eQqv1+Q2FPqEeAiqS1aWIyBsO8
        prFgL5Pmv+eMUlk6z1xMoNRzs1IWC5k0YLAhmLGblKqUOR/BCiVxty3hyLX2CRibDtklMuY/Pj3Lb
        db7SwvH6k4SmKKQY6AeI+nxcq9u9vrPGF5tl0VGAh2rsPpFpJW/vqfJWe2+kcfRp8cEXIyC9g62bG
        CzyTLUeh2o/yhqJ2AnZLZ4NyYQbRukh9/1E0VBqcZVenvxQ/e4axU5FENkvboNJ1/+8uxEjjQrtyX
        lbGuuVfgw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43378)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihspg-0001p3-5p; Thu, 19 Dec 2019 10:15:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihspc-0005I7-Ea; Thu, 19 Dec 2019 10:14:56 +0000
Date:   Thu, 19 Dec 2019 10:14:56 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v4 0/5] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191219101456.GZ1344@shell.armlinux.org.uk>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
 <20191117160443.GG1344@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191117160443.GG1344@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 17, 2019 at 04:04:43PM +0000, Russell King - ARM Linux admin wrote:
> The other thing I see is that with dpmac.7 added, I get all the iommu
> group messages, and buried in there is:
> 
> fsl_dpaa2_eth dpni.1: Probed interface eth1
> 
> as expected.  When I issue the dpmac.8 command (which is when all those
> warnings are spat out) I see:
> 
> fsl_dpaa2_eth dpni.2: Probed interface eth1
> 
> So dpni.1 has gone, eth1 has gone to be replaced by dpni.2 bound to eth1.
> 
> Looking in /sys/bus/fsl-mc/devices/dpni.[12]/ it seems that both
> devices still exist, but dpni.1 has been unbound from the dpaa2 eth
> driver.

I'm seeing this again, it's very annoying because it means one of the
interfaces vanishes and can't then be resurected.

[  161.573637] fsl_mc_allocator dpbp.2: Adding to iommu group 0
[  161.579289] fsl_mc_allocator dpmcp.36: Adding to iommu group 0
[  161.668060] fsl_mc_allocator dpcon.32: Adding to iommu group 0
[  161.752477] fsl_mc_allocator dpcon.37: Adding to iommu group 0
[  161.757221] fsl_mc_allocator dpcon.36: Adding to iommu group 0
[  161.761981] fsl_mc_allocator dpcon.35: Adding to iommu group 0
[  161.766704] fsl_mc_allocator dpcon.34: Adding to iommu group 0
[  161.771453] fsl_mc_allocator dpcon.33: Adding to iommu group 0
[  161.932117] fsl-mc dpcon.2: Removing from iommu group 0
[  161.936171] fsl-mc dpcon.1: Removing from iommu group 0
[  161.940239] fsl-mc dpcon.0: Removing from iommu group 0
[  161.945283] fsl_mc_allocator dpcon.44: Adding to iommu group 0
[  161.950074] fsl_mc_allocator dpcon.43: Adding to iommu group 0
[  161.954807] fsl_mc_allocator dpcon.42: Adding to iommu group 0
[  161.959513] fsl_mc_allocator dpcon.41: Adding to iommu group 0
[  161.964236] fsl_mc_allocator dpcon.40: Adding to iommu group 0
[  161.968933] fsl_mc_allocator dpcon.39: Adding to iommu group 0
[  161.973642] fsl_mc_allocator dpcon.38: Adding to iommu group 0
[  162.051949] fsl_dpaa2_eth dpni.1: Adding to iommu group 0
[  162.206770] fsl_dpaa2_eth dpni.1: Probed interface eth1
[  162.211811] fsl_mc_allocator dpcon.47: Adding to iommu group 0
[  162.216544] fsl_mc_allocator dpcon.46: Adding to iommu group 0
[  162.221260] fsl_mc_allocator dpcon.45: Adding to iommu group 0
[  162.227232] fsl_mc_allocator dpcon.2: Adding to iommu group 0
[  162.231864] fsl_mc_allocator dpcon.1: Adding to iommu group 0
[  162.236497] fsl_mc_allocator dpcon.0: Adding to iommu group 0

[  167.581066] fsl_mc_allocator dpbp.3: Adding to iommu group 0
[  167.586802] fsl_mc_allocator dpmcp.37: Adding to iommu group 0
[  167.592368] fsl_mc_allocator dpcon.51: Adding to iommu group 0
[  167.597120] fsl_mc_allocator dpcon.50: Adding to iommu group 0
[  167.601869] fsl_mc_allocator dpcon.49: Adding to iommu group 0
[  167.606604] fsl_mc_allocator dpcon.48: Adding to iommu group 0
[  168.304644] fsl-mc dpcon.4: Removing from iommu group 0
[  168.308710] fsl-mc dpcon.3: Removing from iommu group 0
[  168.312783] fsl-mc dpcon.2: Removing from iommu group 0
[  168.316828] fsl-mc dpcon.1: Removing from iommu group 0
[  168.320874] fsl-mc dpcon.0: Removing from iommu group 0
[  168.325946] fsl_mc_allocator dpcon.59: Adding to iommu group 0
[  168.330682] fsl_mc_allocator dpcon.58: Adding to iommu group 0
[  168.335393] fsl_mc_allocator dpcon.57: Adding to iommu group 0
[  168.340105] fsl_mc_allocator dpcon.56: Adding to iommu group 0
[  168.344816] fsl_mc_allocator dpcon.55: Adding to iommu group 0
[  168.349530] fsl_mc_allocator dpcon.54: Adding to iommu group 0
[  168.354256] fsl_mc_allocator dpcon.53: Adding to iommu group 0
[  168.358981] fsl_mc_allocator dpcon.52: Adding to iommu group 0
[  168.435784] fsl_dpaa2_eth dpni.2: Adding to iommu group 0
[  168.600151] fsl_dpaa2_eth dpni.2: Probed interface eth1
[  168.605298] fsl_mc_allocator dpcon.63: Adding to iommu group 0
[  168.610023] fsl_mc_allocator dpcon.62: Adding to iommu group 0
[  168.614751] fsl_mc_allocator dpcon.61: Adding to iommu group 0
[  168.619470] fsl_mc_allocator dpcon.60: Adding to iommu group 0
[  168.625990] fsl_mc_allocator dpcon.4: Adding to iommu group 0
[  168.630614] fsl_mc_allocator dpcon.3: Adding to iommu group 0
[  168.635251] fsl_mc_allocator dpcon.2: Adding to iommu group 0
[  168.639890] fsl_mc_allocator dpcon.1: Adding to iommu group 0
[  168.644539] fsl_mc_allocator dpcon.0: Adding to iommu group 0

Any ideas?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
