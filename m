Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42802C2B05
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389012AbgKXPRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388438AbgKXPRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:17:33 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B402C0613D6;
        Tue, 24 Nov 2020 07:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KWfLAcAT1INi74TfOZLY1HvU7v23wTyWejlZ0NL7uwk=; b=w5g4mbPT0BpyAjVykZdZXHzn6
        QmvJI18WaGUcyiQRltuKNgUlTPzHV0v7uzlrCHkF2NXkoQUuJV9JXj2olyS+AWqYoTSr2VMhNUZZJ
        rPgVMStAqj95qDC/EPXE0mmLnWpKR88PK9fmvIbjkBI+3RlG07hqgh3S9q1fbjdvimu5JQRJnjkyZ
        FczBx+28cEHD5eWPgR5lCI0765yLIbaTT8xfxgqEWjhIKfIgBebBrbvyeHI88sOlkvk0+L6xdoqXo
        vQZLi7R/IFmCR3HNdqF1DofGYdPJ/oSd10Xf1nX+W2uOgcbSRu4PtaRASDbSX6Y2plc3ebBKIH9YD
        /cZ2wRB2w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35534)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kha4D-0007s9-UQ; Tue, 24 Nov 2020 15:17:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kha4C-0007Rn-Bj; Tue, 24 Nov 2020 15:17:16 +0000
Date:   Tue, 24 Nov 2020 15:17:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Antonio Borneo <antonio.borneo@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yonglong Liu <liuyonglong@huawei.com>, stable@vger.kernel.org,
        linuxarm@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fix auto-negotiation in case of 'down-shift'
Message-ID: <20201124151716.GG1551@shell.armlinux.org.uk>
References: <20201124143848.874894-1-antonio.borneo@st.com>
 <4684304a-37f5-e0cd-91cf-3f86318979c3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4684304a-37f5-e0cd-91cf-3f86318979c3@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 04:03:40PM +0100, Heiner Kallweit wrote:
> Am 24.11.2020 um 15:38 schrieb Antonio Borneo:
> > If the auto-negotiation fails to establish a gigabit link, the phy
> > can try to 'down-shift': it resets the bits in MII_CTRL1000 to
> > stop advertising 1Gbps and retries the negotiation at 100Mbps.
> > 
> I see that Russell answered already. My 2cts:
> 
> Are you sure all PHY's supporting downshift adjust the
> advertisement bits? IIRC an Aquantia PHY I dealt with does not.
> And if a PHY does so I'd consider this problematic:
> Let's say you have a broken cable and the PHY downshifts to
> 100Mbps. If you change the cable then the PHY would still negotiate
> 100Mbps only.

From what I've seen, that is not how downshift works, at least on
the PHYs I've seen.

When the PHY downshifts, it modifies the advertisement registers,
but it also remembers the original value. When the cable is
unplugged, it restores the setting to what was previously set.

It is _far_ from nice, but the fact is that your patch that Antonio
identified has broken previously working support, something that I
brought up when I patched one of the PHY drivers that was broken by
this very same problem by your patch.

That said, _if_ the PHY has a way to read the resolved state rather
than reading the advertisement registers, that is what should be
used (as I said previously) rather than trying to decode the
advertisement registers ourselves. That is normally more reliable
for speed and duplex.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
