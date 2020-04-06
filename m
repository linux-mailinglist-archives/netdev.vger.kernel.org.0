Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B60C19F837
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 16:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgDFOsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 10:48:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbgDFOsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 10:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jndYh7GlwNS3Suqwh3rj4zu5D8kBRWnhUuUbjJc1gaY=; b=uenn7vmk6Yn/aMdzsb5yOlZEQg
        lmUvAB9L8kZcEAW7MJWAVVXcYp1+GBAIwLi8LhwAV/FaBpePG5WM97NOX9y6nSyonXUXC6+NHwot1
        dmw7unMoScx35Irnh5jLDmwtEB9ck2xeUJPQP0Y6+rmARhSanowU7kPspgLzREWlV5oQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jLT2c-001HDo-6R; Mon, 06 Apr 2020 16:47:58 +0200
Date:   Mon, 6 Apr 2020 16:47:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <79537434260@yandex.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org, Mao Wenan <maowenan@huawei.com>
Subject: Re: [PATCH net-next] net: dsa: add GRO support via gro_cells
Message-ID: <20200406144758.GC301483@lunn.ch>
References: <20200406105910.32339-1-79537434260@yandex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406105910.32339-1-79537434260@yandex.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 01:59:10PM +0300, Alexander Lobakin wrote:
> gro_cells lib is used by different encapsulating netdevices, such as
> geneve, macsec, vxlan etc. to speed up decapsulated traffic processing.
> CPU tag is a sort of "encapsulation", and we can use the same mechs to
> greatly improve overall DSA performance.
> skbs are passed to the GRO layer after removing CPU tags, so we don't
> need any new packet offload types as it was firstly proposed by me in
> the first GRO-over-DSA variant [1].
> 
> The size of struct gro_cells is sizeof(void *), so hot struct
> dsa_slave_priv becomes only 4/8 bytes bigger, and all critical fields
> remain in one 32-byte cacheline.
> The other positive side effect is that drivers for network devices
> that can be shipped as CPU ports of DSA-driven switches can now use
> napi_gro_frags() to pass skbs to kernel. Packets built that way are
> completely non-linear and are likely being dropped without GRO.
> 
> This was tested on to-be-mainlined-soon Ethernet driver that uses
> napi_gro_frags(), and the overall performance was on par with the
> variant from [1], sometimes even better due to minimal overhead.
> net.core.gro_normal_batch tuning may help to push it to the limit
> on particular setups and platforms.
> 
> [1] https://lore.kernel.org/netdev/20191230143028.27313-1-alobakin@dlink.ru/

Hi Alexander

net-next is closed at the moment. So you should of posted this with an
RFC prefix.

The implementation looks nice and simple. But it would be nice to have
some performance figures.

     Andrew
