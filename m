Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A3E5BF02D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiITW3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiITW3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:29:12 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1F75AA3A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 15:29:11 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1oaljj-0007gY-30;
        Wed, 21 Sep 2022 00:29:04 +0200
Date:   Tue, 20 Sep 2022 23:28:57 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH v2] net: dsa: mt7530: add support for in-band link status
Message-ID: <Yyo+qallmqd2/FG8@makrotopia.org>
References: <Yx4910YC6/Y7ghfm@shell.armlinux.org.uk>
 <Yx5I6nRPxYIiC1ZT@makrotopia.org>
 <20220919183622.205ccabf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919183622.205ccabf@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 06:36:22PM -0700, Jakub Kicinski wrote:
> On Sun, 11 Sep 2022 21:45:30 +0100 Daniel Golle wrote:
> >  static void mt7531_pcs_get_state(struct phylink_pcs *pcs,
> >  				 struct phylink_link_state *state)
> >  {
> >  	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
> >  	int port = pcs_to_mt753x_pcs(pcs)->port;
> > +	unsigned int val;
> >  
> > -	if (state->interface == PHY_INTERFACE_MODE_SGMII)
> > +	if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> >  		mt7531_sgmii_pcs_get_state_an(priv, port, state);
> > -	else
> > -		state->link = false;
> > +		return;
> > +	} else if ((state->interface == PHY_INTERFACE_MODE_1000BASEX) ||
> > +		   (state->interface == PHY_INTERFACE_MODE_2500BASEX)) {
> > +		mt7531_sgmii_pcs_get_state_inband(priv, port, state);
> > +		return;
> > +	}
> > +
> > +	state->link = false;
> 
> drivers/net/dsa/mt7530.c:3040:15: warning: unused variable 'val' [-Wunused-variable]
>         unsigned int val;
>                      ^

Oops, forgot that one there. Just sent out v3 with this fixed and
an_complete handled more decently.

Thank you for the review!
