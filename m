Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343674779E0
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbhLPRC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239882AbhLPRC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 12:02:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EB2C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 09:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dAv+6941GUlYCn6EN7S3a3W6nxnXx0JOcQPfX4r51CY=; b=ViGN84JwWl8YusSC3roViMSJqI
        d4KBKbOCiWtgMP14eQ1WFuo3TR7pnI+WklNzH1Pc7l+Cd8+u4CZu8sIyUjZI869Z4gccgqM7dEMKA
        dfbOThAhKTctKr3NzbJXVrlU6Ffah4fcP1dYDF1u4s7FUnJ8Qfs9h/TAwrKUvBJ4hHC3O7wrNMMaB
        wxkryS/IFlJrsr86eDAWqwu42fI5J+NQPRH/OStCEPI5fYuwkIV1AdjM7VIyv5CSn33WVv6nGf68F
        ig/WyHfTylJkKMKYvGLezN23t3agHoXBlip2c5Ng7mhpZZNv2pLt4DAGYMCwkgD01c52wO789BNws
        XPGrC8JQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56322)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxu94-000875-DH; Thu, 16 Dec 2021 17:02:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxu92-0005Yx-Fu; Thu, 16 Dec 2021 17:02:16 +0000
Date:   Thu, 16 Dec 2021 17:02:16 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
Message-ID: <YbtxGLrXoR9oHRmM@shell.armlinux.org.uk>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
 <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
 <20211216071513.6d1e0f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216071513.6d1e0f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 07:15:13AM -0800, Jakub Kicinski wrote:
> On Thu, 16 Dec 2021 12:48:45 +0000 Russell King (Oracle) wrote:
> > Convert axienet to use the phylink_pcs layer, resulting in it no longer
> > being a legacy driver.
> > 
> > One oddity in this driver is that lp->switch_x_sgmii controls whether
> > we support switching between SGMII and 1000baseX. However, when clear,
> > this also blocks updating the 1000baseX advertisement, which it
> > probably should not be doing. Nevertheless, this behaviour is preserved
> > but a comment is added.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> drivers/net/ethernet/xilinx/xilinx_axienet.h:479: warning: Function parameter or member 'pcs' not described in 'axienet_local'

Fixed that and the sha1 issue you raised in patch 2. Since both are
"documentation" issues, I won't send out replacement patches until
I've heard they've been tested on hardware though.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
