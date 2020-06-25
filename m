Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57BA20A2E7
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406113AbgFYQ23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406107AbgFYQ23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:28:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAFBC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 09:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=clFks5Fl2vcCYntayrlV14HDqCRxvQuOB8uOCta4ui8=; b=OtNSSmVFj2oMlFr4F1LAJ/HnX
        DRD89Y6L1BUtA3REMVdon2dn1MpKSulkqItQPRFcm8tiKU9DoG6zbnlFkOhvMzTX2Hc+A1jwQwve8
        V9cGOpaU98pna7Pwtq2QTafl0LWngfbk7+OjV9LLl63XuHW08d/L6mlC70ByaD8TSoGDFjdgJV9Nx
        7ZuB1egUi7OqqkcCffsYyxNtZmvcA9HvkHrAm8yiTe3AA+6M5iI7XbAkZoz8mX0iCe4wgV3OQKtD6
        tbkxoQh9KTZceELWsbMfZoIg7rxNSwqHssI30NF9LeqSG1nbSRaQckKFUYUA5v5jHDZiiSx3xazYS
        TkGz5ekqQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59632)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1joUjg-0004a7-DY; Thu, 25 Jun 2020 17:28:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1joUjc-000387-Il; Thu, 25 Jun 2020 17:28:20 +0100
Date:   Thu, 25 Jun 2020 17:28:20 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 1/7] net: dsa: felix: stop writing to read-only
 fields in MII_BMCR
Message-ID: <20200625162820.GF1551@shell.armlinux.org.uk>
References: <20200625152331.3784018-1-olteanv@gmail.com>
 <20200625152331.3784018-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625152331.3784018-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 06:23:25PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It looks like BMCR_SPEED and BMCR_DUPLEX are read-only, since they are
> actually configured through the vendor-specific IF_MODE (0x14) register.
> So, don't perform bogus writes to these fields, giving the impression
> that those writes do something.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Is this patch really worth the churn?

If the bits are read-only, and are ones, writing ones back to them seems
at least to me to be the sane thing to be doing, rather than writing
zeros.  It isn't giving a false impression IMHO.

Also note that these are documented as being used in 1000base-X mode.

"Read only bit always set to '1' to indicate that the Core (when used
as 1000Base-X) only supports Full Duplex mode of operation and does not
support HalfDuplex. Note: the SGMII mode is controlled with register
IF_MODE."

"Read only bits that define that the Core only operates in Gigabit
mode(1000Base-X): Bit 13 set to '0', Bit 6 set to '1'. Note: the SGMII
speed is controlled with register IF_MODE."

So, I think definitely for the 2500BASE-X case (which is merely
1000BASE-X clocked 2.5x faster) we certainly want to keep writing
these settings correctly as if they were writable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
