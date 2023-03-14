Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591986B9D44
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjCNRpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCNRpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:45:33 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF08AA25F;
        Tue, 14 Mar 2023 10:45:32 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pc8i8-0005bV-03;
        Tue, 14 Mar 2023 18:45:20 +0100
Date:   Tue, 14 Mar 2023 17:45:13 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v13 11/16] net: dsa: mt7530: use external PCS
 driver
Message-ID: <ZBCyqdfaeF/q8oZr@makrotopia.org>
References: <cover.1678357225.git.daniel@makrotopia.org>
 <2ac2ee40d3b0e705461b50613fda6a7edfdbc4b3.1678357225.git.daniel@makrotopia.org>
 <e99cc7d1-554d-5d4d-e69a-a38ded02bb08@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e99cc7d1-554d-5d4d-e69a-a38ded02bb08@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 08:16:35PM +0300, Arınç ÜNAL wrote:
> On 9.03.2023 13:57, Daniel Golle wrote:
> > [...]
> > +static int mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
> > +{
> > +	struct mt7530_priv *priv = context;
> > +
> > +	*val = mt7530_read(priv, reg);
> > +	return 0;
> > +};
> > +
> > +static int mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
> > +{
> > +	struct mt7530_priv *priv = context;
> > +
> > +	mt7530_write(priv, reg, val);
> > +	return 0;
> > +};
> > +
> > +static int mt7530_regmap_update_bits(void *context, unsigned int reg,
> > +				     unsigned int mask, unsigned int val)
> > +{
> > +	struct mt7530_priv *priv = context;
> > +
> > +	mt7530_rmw(priv, reg, mask, val);
> > +	return 0;
> > +};
> > +
> > +static const struct regmap_bus mt7531_regmap_bus = {
> > +	.reg_write = mt7530_regmap_write,
> > +	.reg_read = mt7530_regmap_read,
> > +	.reg_update_bits = mt7530_regmap_update_bits,
> 
> These new functions can be used for both switches, mt7530 and mt7531,
> correct?

In theory, yes, they could be used on all switch ICs supported by the
mt7530.c driver. In practise they are used on MT7531 only because MT7530
and MT7621 don't have any SGMII/SerDes ports, but only MT7531 does.


> If so, I believe they are supposed to be called mt753x since
> 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a new
> hardware").
> 
> mt753x: functions that can be used for mt7530 and mt7531 switches.
> mt7530: functions specific to mt7530 switch.
> mt7531: functions specific to mt7531 switch.

Good catch, so mt7530_* is for sure not accurate. I used that naming
due to existing function names mt7530_read, mt7530_write and mt7530_rmw.

Given the situation I've explained above I think that mt753x_* would
be the best and I will change that for v14.

Thank you for reviewing!


Daniel
