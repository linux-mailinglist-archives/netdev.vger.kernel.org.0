Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6867E5B92B4
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 04:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiIOCiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 22:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiIOCix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 22:38:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2471286B7C;
        Wed, 14 Sep 2022 19:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Ne9cM+YswsLwN2sAUxB058oBiWyLOnEeEdaac2OhME0=; b=Lc
        oA3YdAA+Nf2G+MvvFRbZfD9HVBUvaIuUPRfzo1Nhy/7lv5nb7OcEC1StLRYaBAt3+phKAv+q4KB90
        xwXirbuxfyfEOfL/8JBkT+ZlUxjCfcQBatVtR4EiY8jmcg09CfL7w8s3/Zt4yD4lwSn7C/d5Qp2ZK
        4gJU7QZNKkqc2q4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oYelt-00Glyc-QH; Thu, 15 Sep 2022 04:38:33 +0200
Date:   Thu, 15 Sep 2022 04:38:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thibaut <hacks@slashdirt.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: Re: Move MT7530 phy muxing from DSA to PHY driver
Message-ID: <YyKQKRIYDIVeczl1@lunn.ch>
References: <0e3ca573-2190-57b0-0e98-7f5b890d328e@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e3ca573-2190-57b0-0e98-7f5b890d328e@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 01:07:13AM +0300, Arınç ÜNAL wrote:
> Hello folks.
> 
> MediaTek MT7530 switch has got 5 phys and 7 gmacs. gmac5 and gmac6 are
> treated as CPU ports.
> 
> This switch has got a feature which phy0 or phy4 can be muxed to gmac5 of
> the switch. This allows an ethernet mac connected to gmac5 to directly
> connect to the phy.
> 
> PHY muxing works by looking for the compatible string "mediatek,eth-mac"
> then the mac address to find the gmac1 node. Then, it checks the mdio
> address on the node which "phy-handle" on the gmac1 node points to. If the
> mdio address is 0, phy0 is muxed to gmac5 of the switch. If it's 4, phy4 is
> muxed.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c?id=1f9a6abecf538cc73635f6082677a2f4dc9c89a4#n2238
> 
> Because that DSA probes the switch before muxing the phy, this won't work on
> devices which only use a single switch phy because probing will fail.
> 
> I'd like this operation to be done from the MediaTek Gigabit PHY driver
> instead. The motives for this change are that we solve the behaviour above,
> liberate the need to use DSA for this operation and get rid of the DSA
> overhead.
> 
> Would a change like this make sense and be accepted into netdev?

Where in the address range is the mux register? Officially, PHY
drivers only have access to PHY registers, via MDIO. If the mux
register is in the switch address space, it would be better if the
switch did the mux configuration. An alternative might be to represent
the mux in DT somewhere, and have a mux driver.

    Andrew
