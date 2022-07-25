Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74472580230
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbiGYPtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235526AbiGYPtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:49:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D33BDF06;
        Mon, 25 Jul 2022 08:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xCgUuAK4HBOBGJb9XTFV3FHPAT0JNGbht2Gdr+4FqR8=; b=lVij3fv5zRARwLB8iMZzi89jSD
        Ew7u174CoN3k2dRUvmKyy7b0beziUpZLiSH5Ic+akVmsjcVLZ8fWYqEqOFIfdho0KU/D7gmRHKPEe
        jpCIXRtQe3P957oWqlSZP75e+GPfsOQWss/aPMbUcUGwU9bG6ksu+zHhoMYzDzzl8GJnxy+b5mAua
        6eBPDFL/q0I3/GAfD6pbtHmxtJjBKGEXEhJydarLftwktJ96CfR/K0eH7H5ZEo6rCJ0tYRWSQUnLN
        1R0QQr3cIOzwVGXfBL3yt7bmuCMvG4f3U03szYubQ40JIlGilB93Ir4Vr3sGxlDBt/awN/KM1e424
        ew6ByW8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33556)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oG0KS-00034B-4Z; Mon, 25 Jul 2022 16:49:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oG0KQ-0000Nd-4H; Mon, 25 Jul 2022 16:49:06 +0100
Date:   Mon, 25 Jul 2022 16:49:06 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v3 06/11] net: phylink: Add some helpers for working with
 mac caps
Message-ID: <Yt67ckwhhU4JQ0sL@shell.armlinux.org.uk>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-7-sean.anderson@seco.com>
 <20220725154103.e3l4cde3bhgdl65y@skbuf>
 <2c7b01e3-0236-3fae-7680-05a47b9c266a@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c7b01e3-0236-3fae-7680-05a47b9c266a@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 11:42:25AM -0400, Sean Anderson wrote:
> Hi Vladmir,
> 
> On 7/25/22 11:41 AM, Vladimir Oltean wrote:
> > On Mon, Jul 25, 2022 at 11:37:24AM -0400, Sean Anderson wrote:
> >> This adds a table for converting between speed/duplex and mac
> >> capabilities. It also adds a helper for getting the max speed/duplex
> >> from some caps. It is intended to be used by Russell King's DSA phylink
> >> series. The table will be used directly later in this series.
> >> 
> >> Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >> Co-developed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> >> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> >> [ adapted to live in phylink.c ]
> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> >> ---
> >> This is adapted from [1].
> >> 
> >> [1] https://lore.kernel.org/netdev/E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk/
> > 
> > I did not write even one line of code from this patch, please drop my
> > name from the next revision when there will be one.
> > 
> 
> I merely retained your CDB/SoB from [1].

What Vladimir is trying to say is that the code in this patch copied
from [1] was not written by him (although other bits in [1] were), and
thus this patch should not carry a Co-developed-by or s-o-b for him.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
