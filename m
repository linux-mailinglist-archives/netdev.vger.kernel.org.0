Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6167865F313
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbjAERrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbjAERq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:46:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E204C70D;
        Thu,  5 Jan 2023 09:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZeEiCANH0cEaK8X/VdU3bSWY7LBzy/lq1guYnW4LA+E=; b=aRP2rfs9NAAw0t1g+08wsuaSPg
        shVsPMKx3DC4onvJCY5qWUtofBXWxYYROR4iG1M/MDNvlhsvpNSmgl2qfTIpg38GK7rPeItZL1yei
        IlN/DG5LKdAh+yJLdWz5CEiCt10/+uU98W/V6o0pig4mdSjTCUI49n5EFFwxH3Jupfc2bbwAUqhPT
        7gbUVrbrRlkEnjxWSjUinja8knqgSXfefVYa4lD+HJRRKb8/3nGPieNVElTXPJiaB/aDnuej9akbl
        j702lSCPAlYxV+VRSWo7u0065g4Gw8un39kGcm7kEN9kFsqJP6XYHlQNvRCEqFST/aqQVqirJ2HT3
        KsVnt/zw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35982)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pDUKI-0007Nn-K0; Thu, 05 Jan 2023 17:46:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pDUKG-0004Al-1h; Thu, 05 Jan 2023 17:46:48 +0000
Date:   Thu, 5 Jan 2023 17:46:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y7cNCK4h0do9pEPo@shell.armlinux.org.uk>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105173445.72rvdt4etvteageq@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 07:34:45PM +0200, Vladimir Oltean wrote:
> So we lose the advertisement of 5G and 2.5G, even if the firmware is
> provisioned for them via 10GBASE-R rate adaptation, right? Because when
> asked "What kind of rate matching is supported for 10GBASE-R?", the
> Aquantia driver will respond "None".

The code doesn't have the ability to do any better right now - since
we don't know what sets of interface modes _could_ be used by the PHY
and whether each interface mode may result in rate adaption.

To achieve that would mean reworking yet again all the phylink
validation from scratch, and probably reworking phylib and most of
the PHY drivers too so that they provide a lot more information
about their host interface behaviour.

I don't think there is an easy way to have a "perfect" solution
immediately - it's going to take a while to evolve - and probably
painfully evolve due to the slowness involved in updating all the
drivers that make use of phylink in some way.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
