Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563D41F595B
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 18:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgFJQso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 12:48:44 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45084 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgFJQsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 12:48:43 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2020 12:48:43 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S8iHepBurBEVpEkNzyHelIVvWMvm3PqnFP7CA0HZti4=; b=OUVn2icfPUljLSc1yEHjmuQ2G
        JB5EHckJpeN3XTCGi3Q0hcxd30TqaA5D/iq2lA3jD7j5NvSGgBNIwk7o4KC2ruzoLnOcHyoUCVbFB
        bpKOeLub4k22GA9RlJ7xF4LAYxcNWJrR78U9tKdyjZvBtxV+pNm1PJXI0Tn17Fd+eNeUq8F+2R5hK
        SuA3ckq34LscxexZyuawD2RANs5q35rttF3c80WRcG8FAmT9xmhaKw3Bu9qDOxJQjqRf97r0/hVE8
        Na2lo1c3OFLGoD3Ritiq++EzoySoFA1cjogc8wnt1J094oE+bFgOiZLEUx32KI6VShFY0W50nK0+k
        zCChww9FA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43804)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jj3gB-0006VE-2D; Wed, 10 Jun 2020 17:34:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jj3g9-0004HB-NG; Wed, 10 Jun 2020 17:34:17 +0100
Date:   Wed, 10 Jun 2020 17:34:17 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v2 6/9] net: phy: add support for probing MMDs >= 8
 for devices-in-package
Message-ID: <20200610163417.GR1551@shell.armlinux.org.uk>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtNz-000840-Sk@rmk-PC.armlinux.org.uk>
 <20200610161633.GA22223@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610161633.GA22223@lsv03152.swis.in-blr01.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 09:46:33PM +0530, Calvin Johnson wrote:
> Hi Russell,
> 
> On Wed, May 27, 2020 at 11:34:11AM +0100, Russell King wrote:
> > Add support for probing MMDs above 7 for a valid devices-in-package
> > specifier, but only probe the vendor MMDs for this if they also report
> > that there the device is present in status register 2.  This avoids
> > issues where the MMD is implemented, but does not provide IEEE 802.3
> > compliant registers (such as the MV88X3310 PHY.)
> 
> While this patch looks good to me, commit message doesn't seem to align
> with the code changes as it is dealing with MMD at addresses 30 & 31.
> Can you please clarify?

IEEE 802.3 does not define the "device-is-present" two bits in register
8 for all MMDs - it is only present for MMDs 1, 2, 3, 4, 5, 30 and 31.
None of the other MMDs, even those that have been recently defined (at
least in IEEE 802.3-2018) have these bits.

Hence, we can't use them except on the MMDs where they are defined to
be present.

I considered also checking them in MMDs 1, 2, 3, 4, 5, but decided that
the risk of regression was too high for this patch; that's something
which could be added in a separate patch though, to avoid having to
revert the entire thing if a regression is found at a later date.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 503kbps up
