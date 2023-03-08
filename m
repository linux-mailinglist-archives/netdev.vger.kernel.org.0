Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5116B0AB9
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjCHONz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjCHON3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:13:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBF25A1B6;
        Wed,  8 Mar 2023 06:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tRpfWAyAr9NJ0cUH+oJUvt5Zq2cO3qLqUNmAFfG9Mp4=; b=RJ47iD6rJBGBLbFJHKdbU2G1AQ
        rI2unKHGX2cX9JmMhhybBVN7yYSp3+bVvPmrVHddReFLFP2657dahor6uGkgwCM98/ATjbO0XWWji
        rbbfqHv3f0YlF11z7W0oD9sl/MzvnRJlEfBGq90/eEddeZAnaJma2Vzb5KT71sRzPFqoR0BAw5pL0
        3Im1UvMxsEYD8mbcGN4E3I1T99gmyzwxzlkVIDJ1vbW28mwnw4MPPZQIGAwvySCWcrQB2tBkKf7NQ
        t65/rKf+1j90ZC8slM7DRA3MzTSToOyEVqtY8ALLSCz4I0nZG8kXzzxCe23sE7/ISiWglEWbE13yS
        J1K9XwZQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57160)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZuWj-0002iT-7X; Wed, 08 Mar 2023 14:12:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZuWb-0002eN-0y; Wed, 08 Mar 2023 14:12:13 +0000
Date:   Wed, 8 Mar 2023 14:12:12 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
 <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
 <ZAh7hA4JuJm1b2M6@makrotopia.org>
 <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
 <ZAiFOTRQI36nGo+w@makrotopia.org>
 <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 03:46:42PM +0200, Vladimir Oltean wrote:
> On Wed, Mar 08, 2023 at 01:12:10PM +0000, Russell King (Oracle) wrote:
> > So, what I would want to do is to move the decision about whether
> > the PCS should enable in-band into the phylink core code instead
> > of these random decisions being made in each PCS.
> > 
> > At that point, we can then make the decision about whether the
> > ethtool autoneg bit should affect whether the PCS uses inband
> > depending on whether the PCS is effectively the media facing
> > entity, or whether there is a PHY attached - and if there is a PHY
> > attached, ask the PHY whether it will be using in-band or not.
> > 
> > This also would give a way to ensure that all PCS adopt the same
> > behaviour.
> > 
> > Does that sound a reasonable approach?
> > 
> > Strangely, I already have some patches along those lines in my
> > net-queue branch. See:
> > 
> > net: phylink: add helpers for decoding mode
> > net: use phylink_mode_*() helpers
> > net: phylink: split PCS in-band from inband mode
> > 
> > It's nowhere near finished though, it was just an idea back in
> > 2021 when the problem of getting rid of differing PCS behaviours
> > was on my mind.
> 
> Having looked at those patches
> (http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=a632167d226cf95d92cd887b2f1678e1539833b1)
> and seen the way in which they are incomplete, could you sketch here how
> do you see an actual pcs_validate() implementation making use of the new
> "mode" argument?
> 
> I'd expect there to be some logic which changes the "mode", if the PCS
> validation with the existing one fails... or?

You may notice that I explicitly didn't include the patches adding the
mode argument to the validation path, precisely because that's an
unanswered question.

I haven't done much work in this area because I gave up with trying to
convert mv88e6xxx to phylink_pcs because it just became impossible
due to the history of the driver - and that destroyed my motivation
for further work, because that would mean I'd just accumulate more
and more patches. You may have noticed that I'm hardly doing any
development work on phylink over the last few months, instead
concentrating on problem non-DSA network drivers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
