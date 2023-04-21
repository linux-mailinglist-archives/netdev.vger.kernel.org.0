Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C674C6EB210
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 21:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbjDUTGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 15:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjDUTGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 15:06:49 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B477E53;
        Fri, 21 Apr 2023 12:06:45 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ppw5N-0002na-2t;
        Fri, 21 Apr 2023 21:06:22 +0200
Date:   Fri, 21 Apr 2023 20:06:18 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net-next 20/22] net: dsa: mt7530: force link-down on
 MACs before reset on MT7530
Message-ID: <ZELeqnUKQApQPxUR@makrotopia.org>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
 <20230421143648.87889-21-arinc.unal@arinc9.com>
 <ZELZAd4O9SyHLkwn@makrotopia.org>
 <7982894a-029c-585a-9ab5-3a6295c6abaa@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7982894a-029c-585a-9ab5-3a6295c6abaa@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 09:47:16PM +0300, Arınç ÜNAL wrote:
> On 21.04.2023 21:42, Daniel Golle wrote:
> > On Fri, Apr 21, 2023 at 05:36:46PM +0300, arinc9.unal@gmail.com wrote:
> > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > 
> > > Force link-down on all MACs before internal reset. Let's follow suit commit
> > > 728c2af6ad8c ("net: mt7531: ensure all MACs are powered down before
> > > reset").
> > > 
> > > Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > ---
> > >   drivers/net/dsa/mt7530.c | 4 ++++
> > >   1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > > index ac1e3c58aaac..8ece3d0d820c 100644
> > > --- a/drivers/net/dsa/mt7530.c
> > > +++ b/drivers/net/dsa/mt7530.c
> > > @@ -2203,6 +2203,10 @@ mt7530_setup(struct dsa_switch *ds)
> > >   		return -EINVAL;
> > >   	}
> > > +	/* Force link-down on all MACs before internal reset */
> > > +	for (i = 0; i < MT7530_NUM_PORTS; i++)
> > > +		mt7530_write(priv, MT7530_PMCR_P(i), PMCR_FORCE_LNK);
> > > +
> > 
> > Moving this part to mt753x_setup just before calling priv->info->sw_setup(ds);
> > is probably better. Though it isn't documented I assume that the requirement
> > to have the ports in force-link-down may also apply to MT7988, and for sure
> > it doesn't do any harm.
> > 
> > Hence I suggest to squash this change:
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index a2cb7e296165e..998c4e8930cd3 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -2203,10 +2203,6 @@ mt7530_setup(struct dsa_switch *ds)
> >   		return -EINVAL;
> >   	}
> > -	/* Force link-down on all MACs before internal reset */
> > -	for (i = 0; i < MT7530_NUM_PORTS; i++)
> > -		mt7530_write(priv, MT7530_PMCR_P(i), PMCR_FORCE_LNK);
> > -
> >   	/* Reset the switch through internal reset */
> >   	mt7530_write(priv, MT7530_SYS_CTRL,
> >   		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
> > @@ -2423,10 +2419,6 @@ mt7531_setup(struct dsa_switch *ds)
> >   		dev_info(priv->dev, "found MT7531BE\n");
> >   	}
> > -	/* all MACs must be forced link-down before sw reset */
> > -	for (i = 0; i < MT7530_NUM_PORTS; i++)
> > -		mt7530_write(priv, MT7530_PMCR_P(i), MT7531_FORCE_LNK);
> > -
> >   	/* Reset the switch through internal reset */
> >   	mt7530_write(priv, MT7530_SYS_CTRL,
> >   		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
> > @@ -2907,6 +2899,10 @@ mt753x_setup(struct dsa_switch *ds)
> >   		priv->pcs[i].port = i;
> >   	}
> > +	/* Force link-down on all MACs before setup */
> > +	for (i = 0; i < MT7530_NUM_PORTS; i++)
> > +		mt7530_write(priv, MT7530_PMCR_P(i), PMCR_FORCE_LNK);
> 
> MT7531 has got a different bit on the register for this, MT7531_FORCE_LNK.
> Are you sure PMCR_FORCE_LNK would work for MT7531 too?

No, I had overlooked that. As the effects of not doing the
force-link-down before the reset are subtle and depend on the
link-partners I may not have cought them in my tests.


> 
> Arınç
