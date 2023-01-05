Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E465465F403
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbjAES6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjAES6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:58:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2665F497;
        Thu,  5 Jan 2023 10:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QrdF2fu5/3Y/xqo4XD4CaE8xCI0Co+92085uN0QaYrM=; b=SYSGv+Zq3DeIgfB6IXKAwdXiGr
        CBrorpbrwtNmJ28nVzmCqVSM6HUNH1XeG7vIux6csC3JBlqYipnI1KVUJyXrIr4E1e8VLoIGhdgJJ
        xGSqIn7yoOS1QNvYFYl3rHI+8WEZtfQSOsVgtzkjwzIDWT/2lTThUuZZLMhZK78NWNdxKFh6wlZVZ
        l8SJrcc3xksaF3fpeANGChMrGrF8mNQ+w8W4i6fZ8Y3bsFmAPs5NMFQ08gv2NToKCjGWAQluLZfLF
        gycW+i14LshrioZTTcV/cCuq5FnlRa7TI6uVK2r3wZXjo+1N5taSITEDWqbpegzlQZKTFWiJwRSPK
        uszpTWzA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35988)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pDVRm-0007SC-Tb; Thu, 05 Jan 2023 18:58:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pDVRk-0004D2-PO; Thu, 05 Jan 2023 18:58:37 +0000
Date:   Thu, 5 Jan 2023 18:58:36 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y7cd3DrnKxNmHVcp@shell.armlinux.org.uk>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
 <20230105175206.h3nmvccnzml2xa5d@skbuf>
 <20230105175542.ozqn67o3qmadnaph@skbuf>
 <39660d10-69b9-fa52-5a49-67d5f7e1acaf@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39660d10-69b9-fa52-5a49-67d5f7e1acaf@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 01:03:49PM -0500, Sean Anderson wrote:
> On 1/5/23 12:55, Vladimir Oltean wrote:
> > On Thu, Jan 05, 2023 at 07:52:06PM +0200, Vladimir Oltean wrote:
> >> On Thu, Jan 05, 2023 at 12:43:47PM -0500, Sean Anderson wrote:
> >> > Again, this is to comply with the existing API assumptions. The current
> >> > code is buggy. Of course, another way around this is to modify the API.
> >> > I have chosen this route because I don't have a situation like you
> >> > described. But if support for that is important to you, I encourage you
> >> > to refactor things.
> >> 
> >> I don't think I'm aware of a practical situation like that either.
> >> I remember seeing some S32G boards with Aquantia PHYs which use 2500BASE-X
> >> for 2.5G and SGMII for <=1G, but that's about it in terms of protocol switching.
> >> As for Layerscape boards, SERDES protocol switching is a very new concept there,
> >> so they're all going to be provisioned for PAUSE all the way down
> >> (or USXGMII, where that is available).
> >> 
> >> I just pointed this out because it jumped out to me. I don't have
> >> something against this patch getting accepted as it is.
> > 
> > A real-life (albeit niche) scenario where someone might have an Aquantia
> > firmware provisioned like this would be a 10G capable port that also
> > wants to support half duplex at 10/100 speeds. Although I'm not quite
> > sure who cares about half duplex all that much these days.
> 
> IMO if we really want to support this, the easier way would be to teach
> the phy driver how to change the rate adaptation mode. That way we could
> always advertise rate adaptation, but if someone came along and
> requested 10HD we could reconfigure the phy to support it. However, this
> was deemed too risky in the discussion for v1, since we don't really
> know how the firmware interacts with the registers.

I'm not sure about "someone came along and requested 10HD". Don't you
mean "if someone plugged the RJ45 into a 10bT hub which only supports
10HD" ? Or are you suggesting that we shouldn't advertise 10HD and
100HD along with everything else, and then switch into this special
mode if someone wants to advertise these and disable all other link
modes?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
