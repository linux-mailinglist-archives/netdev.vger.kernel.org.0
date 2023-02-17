Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BE269AD45
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjBQOAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBQOAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:00:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEF06241E
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 06:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GubmRme+v7EfTthXDZIVsuZy9ir0x79diNscNiRKuz8=; b=NkDuSO94jLDHBV/G2HhqSfq8wB
        9yhdygDJ/28pZPF2YMyop78ZZKmF5guXm7idKJ1m8h0R+8hhB8/x8HEdM7kCEKefDbVgQIMClwNyu
        AXSFn1i9T7NBs2I4NlSEFI91vQXo+NGLu7+LxiZQns83s59ec1XDl79yfZMWuoM3VkJo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT1I8-005I05-E3; Fri, 17 Feb 2023 15:00:48 +0100
Date:   Fri, 17 Feb 2023 15:00:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 09/18] net: genet: Fixup EEE
Message-ID: <Y++IkHnx9ORmQ/79@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-10-andrew@lunn.ch>
 <30ec2581-ab5d-2cf8-e5cb-dc7c99f43d3c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30ec2581-ab5d-2cf8-e5cb-dc7c99f43d3c@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This looks similar to a number of patches for GENET that I need to resurrect
> against net-next, or even submit to net. LGTM at first glance, I will give
> you series a test.

Thanks for testing.

> > --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > @@ -1272,12 +1272,17 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
> >   	}
> >   }
> > -static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
> > +void bcmgenet_eee_enable_set(struct net_device *dev, bool eee_active)
> >   {
> >   	struct bcmgenet_priv *priv = netdev_priv(dev);
> > -	u32 off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
> 
> Seems unnecessary, yes it does not quite abide by the RCT style, but no need
> to fix that yet.

Yes, it is unnecassary. I can drop it.

     Andrew
