Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F376CF22B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjC2Sde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjC2Sdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:33:33 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7241FDA;
        Wed, 29 Mar 2023 11:33:30 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phabr-0005LO-05;
        Wed, 29 Mar 2023 20:33:23 +0200
Date:   Wed, 29 Mar 2023 19:33:17 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Andrew Lunn <andrew@lunn.ch>
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
Subject: Re: [RFC PATCH net-next v3 03/15] net: dsa: mt7530: use regmap to
 access switch register space
Message-ID: <ZCSEbUt9kj8Ta6Yc@makrotopia.org>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <754322262cd754aee5916954b8e651989b229a09.1680105013.git.daniel@makrotopia.org>
 <7eb07ed2-2b1c-44fa-b029-0ecad7872fd2@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eb07ed2-2b1c-44fa-b029-0ecad7872fd2@lunn.ch>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 06:24:21PM +0200, Andrew Lunn wrote:
> Thanks for splitting this patchset up. This is much easier to review.
> 
> > +static u32
> > +mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
> > +{
> > +	int ret;
> > +	u32 val;
> > +
> > +	ret = regmap_read(priv->regmap, reg, &val);
> > +	if (ret) {
> > +		dev_err(priv->dev,
> > +			"failed to read mt7530 register\n");
> > +		return ret;
> 
> This is a u32 function. ret should be negative on error, which is
> going to be turned positive in order to return a u32. So you probably
> want to make this an int function.

This is a pre-existing flaw in the code. As we are accessing 32-bit
registers there has just never been any meaningful error handling.
I guess the correct solution would be to not use the return value only
to indicate success or error, and use an additional u32* parameter for
the read value.

However, I was hestitating to convert all the calls (they are many) to
follow that improved paradigm.

Should I?
