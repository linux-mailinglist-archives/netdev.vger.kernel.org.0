Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83D06CC198
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjC1OAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbjC1OAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:00:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986B2CC33;
        Tue, 28 Mar 2023 06:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v+3vKgAYziYUNd1/YtEm0M2tEuJj+3Sc+fTWjNKvGfM=; b=AA0Yc10UggUYifkJN5+9WMeg/m
        NbiCMrPKVFf6g1DW046vTIOwTs44SSQzGVWuxI1tzR7ly2TQhW5HM+jXggnfndYrHltFlTBSEKcKL
        9Xg60iIePWc/Y02BGM6fzgQXzmsW5vJcupJ3NPHBIUAQVko6k3bM+WZB5g+ETK3UtLf4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ph9r3-008eUK-Ek; Tue, 28 Mar 2023 15:59:17 +0200
Date:   Tue, 28 Mar 2023 15:59:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: mt7530: introduce MMIO driver
 for MT7988 SoC
Message-ID: <7e6915bf-f773-4644-b0a7-3cd0730dad8b@lunn.ch>
References: <ZCIML310vc8/uoM4@makrotopia.org>
 <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
 <ZCLmwm01FK7laSqs@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCLmwm01FK7laSqs@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I agree that using regmap would be better and I have evaluated that
> approach as well. As regmap doesn't allow lock-skipping and mt7530.c is
> much more complex than xrs700x in the way indirect access to its MDIO bus
> and interrupts work, using regmap accessors for everything would not be
> trivial.

O.K, so lets go another way.

Study the low level accesors, and put an abstraction over
them. Provide an MDIO set and an MMIO set.

> To illustrate what I'm talking about, let me show some examples in the
> current code for which I don't see a way to use regmap:
> 634) static int
> 635) mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
> 636)                   int regnum)
> 637) {
> 638)   struct mii_bus *bus = priv->bus;
> 639)   struct mt7530_dummy_poll p;
> 640)   u32 reg, val;
> 641)   int ret;
> 642) 
> 643)   INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
> 644) 
> 645)   mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);

So you need an abstract lock() and an unlock(). Maybe the MMIO
implementation is a NOP? And the MDIO implementation does a real lock?

> 646) 
> 647)   ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
> 648)                            !(val & MT7531_PHY_ACS_ST), 20, 100000);

_mt7530_unlocked_read and presumably _mt7530_unlocked_write()?

> 649)   if (ret < 0) {
> 650)           dev_err(priv->dev, "poll timeout\n");
> 651)           goto out;
> 652)   }
> 653) 
> 654)   reg = MT7531_MDIO_CL45_ADDR | MT7531_MDIO_PHY_ADDR(port) |
> 655)         MT7531_MDIO_DEV_ADDR(devad) | regnum;
> 656)   mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);

mt7530_write() and mt7530_read()

Put the MDIO accessors in the _mdio.c file, and the MMIO accessors in
the _mmio.c file. Pass them to the core. If you have the abstraction
correct, the core should not care how the registers are accessed.

	 Andrew
