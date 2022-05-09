Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1B351FBC7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiEIMAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiEIMAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:00:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803D823AF26
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 04:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6p0B4iriaGCJg0r/xi44uje9TH51cFyn8C3DVTYwsi4=; b=2QyZwCJ1FR8ToW+zwq/kX/jIB2
        WZy0dA76G3DRBYN8665KsV75C80efGBZGHEXKmgiFI1sA2YmqHm03754QhX8uW5QQ8acF2uJISmLw
        mbRYtnCGKd+q61BEHA6Kc7Tc0Tn/tpSj7YS5SQIrpYJFO9aDt/sXhOtxVLYpdN1LDZ8Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no1zV-001w7D-8y; Mon, 09 May 2022 13:55:53 +0200
Date:   Mon, 9 May 2022 13:55:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/4] net: dsa: realtek: rtl8365mb: Add setting MTU
Message-ID: <YnkBSTbn04SYyV+J@lunn.ch>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <20220508224848.2384723-4-hauke@hauke-m.de>
 <CAJq09z75yzP-V=bwnK6QNGQW+eoj-pnx2q0CB-03VYH65dKhgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z75yzP-V=bwnK6QNGQW+eoj-pnx2q0CB-03VYH65dKhgA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int rtl8365mb_port_change_mtu(struct dsa_switch *ds, int port,
> > +                                    int new_mtu)
> > +{
> > +       struct dsa_port *dp = dsa_to_port(ds, port);
> > +       struct realtek_priv *priv = ds->priv;
> > +       int length;
> > +
> > +       /* When a new MTU is set, DSA always set the CPU port's MTU to the
> > +        * largest MTU of the slave ports. Because the switch only has a global
> > +        * RX length register, only allowing CPU port here is enough.
> > +        */
> > +       if (!dsa_is_cpu_port(ds, port))
> > +               return 0;
> > +
> > +       length = new_mtu + ETH_HLEN + ETH_FCS_LEN;
> > +       length += dp->tag_ops->needed_headroom;
> > +       length += dp->tag_ops->needed_tailroom;
> 
> Isn't it better to keep that within the driver? No matter the tag
> position, it will be either 4 (RTL8365MB_CPU_FORMAT_4BYTES) or 8
> (RTL8365MB_CPU_FORMAT_8BYTES) bytes. You can retrieve that from
> priv->chip_data->cpu->format, but the driver will probably never
> support RTL8365MB_CPU_FORMAT_4BYTES. Until someone does implement the
> 4-bytes tag (for some mysterious reason), I believe we could simply
> use a constant here (using a proper new macro).

Another option is to simply always use the bigger header length. I
doubt there are many people actually using jumbo frames, and do they
really care about 0x3FFF-4, vs 0x3FFF-8?
 
> > +
> > +       if (length > RTL8365MB_CFG0_MAX_LEN_MASK)
> > +               return -EINVAL;
> > +
> > +       return regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> > +                                 RTL8365MB_CFG0_MAX_LEN_MASK,
> > +                                 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK,
> > +                                            length));
> > +}
> > +
> > +static int rtl8365mb_port_max_mtu(struct dsa_switch *ds, int port)
> > +{
> > +       return RTL8365MB_CFG0_MAX_LEN_MASK - ETH_HLEN - ETH_FCS_LEN - 8;
> 
> What is this magic 8? RTL8_4_TAG_LEN?

There are some DSA headers in include/linux/dsa, probably a new one
should be added with this RTL8_4_TAG_LEN.
 
	Andrew
