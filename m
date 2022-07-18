Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8C85786F0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiGRQGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiGRQGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:06:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E7019C2B;
        Mon, 18 Jul 2022 09:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W/h2DA8cfEG16WKUgNpJElu4U35pORu6Lpisgp/aztg=; b=QLN6WX2qBSYbabOQyYw4ip+w6g
        7r+HEHPGop9B4DUJzTW8luJJgMAeQpgv4CYSDE8/MUr03o3lppKVSnGpqO5y7NTAEYI/cm25r4NVg
        3nH3lnbQ+Ptnz/KkOoQw+y6U47QXpESbK34xTHJwOigwLN6/2WK2UATYKkd8b2w38UmmWzhu03NY0
        QLq9TscLbgSVFuEh71JUputnS/98gE1EXF4Uw+eBjIvBXHVv0UvKJZfAffXfOUnQOB0ZVErrkxJC7
        3ZTO32hTTUEPvKWgfhjNA7GwY2Syn6ROYIFeboIDs9p6AXvCBtb/EpbLESPC7Uo6y0dwHC54d9Q5l
        kH0jMfBw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33416)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDTGN-0001nK-7M; Mon, 18 Jul 2022 17:06:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDTGL-000253-Bw; Mon, 18 Jul 2022 17:06:25 +0100
Date:   Mon, 18 Jul 2022 17:06:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 08/47] net: phylink: Support differing link
 speeds and interface speeds
Message-ID: <YtWFAfu1nSE6vCfx@shell.armlinux.org.uk>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-9-sean.anderson@seco.com>
 <YtMaKWZyC/lgAQ0i@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtMaKWZyC/lgAQ0i@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 10:06:01PM +0200, Andrew Lunn wrote:
> This seem error prone when new PHY_INTERFACE_MODES are added. I would
> prefer a WARN_ON_ONCE() in the default: so we get to know about such
> problems.
> 
> I'm also wondering if we need a sanity check here. I've seen quite a
> few boards a Fast Ethernet MAC, but a 1G PHY because they are
> cheap. In such cases, the MAC is supposed to call phy_set_max_speed()
> to indicate it can only do 100Mbs. PHY_INTERFACE_MODE_MII but a
> link_speed of 1G is clearly wrong. Are there other cases where we
> could have a link speed faster than what the interface mode allows?

Currently, phylink will deal with that situation - the MAC will report
that it only supports 10/100, and when the PHY is brought up, the
supported/advertisement masks will be restricted to those speeds.

> Bike shedding a bit, but would it be better to use host_side_speed and
> line_side_speed? When you say link_speed, which link are your
> referring to? Since we are talking about the different sides of the
> PHY doing different speeds, the naming does need to be clear.

Yes, we definitely need that clarification.

I am rather worried that we have drivers using ->speed today in their
mac_config and we're redefining what that means in this patch. Also,
the value that we pass to the *_link_up() calls appears to be the
phy <-> (pcs|mac) speed not the media speed. It's also ->speed and
->duplex that we report to the user in the "Link is Up" message,
which will be confusing if it always says 10G despite the media link
being e.g. 100M.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
