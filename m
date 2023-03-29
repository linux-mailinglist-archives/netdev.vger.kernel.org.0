Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE666CF336
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjC2Tfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC2Tfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:35:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B565C469C;
        Wed, 29 Mar 2023 12:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9Ip60VxQO8vIEjsVQuk6WZlBLCQN328zDAYmxQho2Uk=; b=oNr9cPXYVHQF9aWQrgtHuUbaL4
        rrNePszDIqfOYFfGJC50qIve5P6TNCg56eDFOWxZFl5EU4a6rvy6hSSeNXqQEUrqJjaeXThOcY7sP
        yHibUzHcsx5RDU3sLn98Kg1qzVw5h5E6OXiPoAvByexD169ZM+yrl2MQni+L90RuZtF4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phbZl-008nTP-Sg; Wed, 29 Mar 2023 21:35:17 +0200
Date:   Wed, 29 Mar 2023 21:35:17 +0200
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
Subject: Re: [RFC PATCH net-next v3 03/15] net: dsa: mt7530: use regmap to
 access switch register space
Message-ID: <e8bb79ab-94d2-4e36-9b75-576a47e6c126@lunn.ch>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <754322262cd754aee5916954b8e651989b229a09.1680105013.git.daniel@makrotopia.org>
 <7eb07ed2-2b1c-44fa-b029-0ecad7872fd2@lunn.ch>
 <ZCSEbUt9kj8Ta6Yc@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCSEbUt9kj8Ta6Yc@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 07:33:17PM +0100, Daniel Golle wrote:
> On Wed, Mar 29, 2023 at 06:24:21PM +0200, Andrew Lunn wrote:
> > Thanks for splitting this patchset up. This is much easier to review.
> > 
> > > +static u32
> > > +mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
> > > +{
> > > +	int ret;
> > > +	u32 val;
> > > +
> > > +	ret = regmap_read(priv->regmap, reg, &val);
> > > +	if (ret) {
> > > +		dev_err(priv->dev,
> > > +			"failed to read mt7530 register\n");
> > > +		return ret;
> > 
> > This is a u32 function. ret should be negative on error, which is
> > going to be turned positive in order to return a u32. So you probably
> > want to make this an int function.
> 
> This is a pre-existing flaw in the code. As we are accessing 32-bit
> registers there has just never been any meaningful error handling.

O.K. At least i would not return the negative error code. Return 0, or
0xdeadbeef or something. And consider adding a WARN_ON_ONCE() so it is very loud
when it goes wrong.

> I guess the correct solution would be to not use the return value only
> to indicate success or error, and use an additional u32* parameter for
> the read value.

Yes, that is what mv88e6xxx does.

> However, I was hestitating to convert all the calls (they are many) to
> follow that improved paradigm.

Yes, leave that for another time.

     Andrew
