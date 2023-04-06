Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA126DA51F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 23:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbjDFV7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 17:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239478AbjDFV63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 17:58:29 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B8CB460;
        Thu,  6 Apr 2023 14:58:22 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pkXc9-0004wy-34;
        Thu, 06 Apr 2023 23:57:54 +0200
Date:   Thu, 6 Apr 2023 22:57:51 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
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
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: fix port specifications
 for MT7988
Message-ID: <ZC9AXyuFqa3bqF3Q@makrotopia.org>
References: <20230406100445.52915-1-arinc.unal@arinc9.com>
 <ZC6n1XAGyZFlxyXx@shell.armlinux.org.uk>
 <e413a182-ce93-5831-09f5-19d34d7f7fcf@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e413a182-ce93-5831-09f5-19d34d7f7fcf@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 12:43:41AM +0300, Arınç ÜNAL wrote:
> On 6.04.2023 14:07, Russell King (Oracle) wrote:
> > On Thu, Apr 06, 2023 at 01:04:45PM +0300, arinc9.unal@gmail.com wrote:
> > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > 
> > > On the switch on the MT7988 SoC, there are only 4 PHYs. There's only port 6
> > > as the CPU port, there's no port 5. Split the switch statement with a check
> > > to enforce these for the switch on the MT7988 SoC. The internal phy-mode is
> > > specific to MT7988 so put it for MT7988 only.
> > > 
> > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > ---
> > > 
> > > Daniel, this is based on the information you provided me about the switch.
> > > I will add this to my current patch series if it looks good to you.
> > > 
> > > Arınç
> > > 
> > > ---
> > >   drivers/net/dsa/mt7530.c | 67 ++++++++++++++++++++++++++--------------
> > >   1 file changed, 43 insertions(+), 24 deletions(-)
> > > 
> > > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > > index 6fbbdcb5987f..f167fa135ef1 100644
> > > --- a/drivers/net/dsa/mt7530.c
> > > +++ b/drivers/net/dsa/mt7530.c
> > > @@ -2548,7 +2548,7 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
> > >   	phy_interface_zero(config->supported_interfaces);
> > >   	switch (port) {
> > > -	case 0 ... 4: /* Internal phy */
> > > +	case 0 ... 3: /* Internal phy */
> > >   		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> > >   			  config->supported_interfaces);
> > >   		break;
> > > @@ -2710,37 +2710,56 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> > >   	struct mt7530_priv *priv = ds->priv;
> > >   	u32 mcr_cur, mcr_new;
> > > -	switch (port) {
> > > -	case 0 ... 4: /* Internal phy */
> > > -		if (state->interface != PHY_INTERFACE_MODE_GMII &&
> > > -		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
> > > -			goto unsupported;
> > > -		break;
> > > -	case 5: /* Port 5, a CPU port. */
> > > -		if (priv->p5_interface == state->interface)
> > > +	if (priv->id == ID_MT7988) {
> > > +		switch (port) {
> > > +		case 0 ... 3: /* Internal phy */
> > > +			if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
> > 
> > How do these end up with PHY_INTERFACE_MODE_INTERNAL ? phylib defaults
> > to GMII mode without something else being specified in DT.
> > 
> > Also note that you should *not* be validating state->interface in the
> > mac_config() method because it's way too late to reject it - if you get
> > an unsupported interface here, then that is down to the get_caps()
> > method being buggy. Only report interfaces in get_caps() that you are
> > prepared to handle in the rest of the system.
> 
> This is already the case for all three get_caps(). The supported interfaces
> for each port are properly defined.
> 
> Though mt7988_mac_port_get_caps() clears the config->supported_interfaces
> bitmap before reporting the supported interfaces. I don't think this is
> needed as all bits in the bitmap should already be initialized to zero when
> the phylink_config structure is allocated.
> 
> I'm not sure if your suggestion is to make sure the supported interfaces are
> properly reported on get_caps(), or validate state->interface somewhere
> else.

I think what Russell meant is just there is no point in being overly
precise about permitted interface modes in mt753x_phylink_mac_config,
as this function is not meant and called too late to validate the
validity of the selected interface mode.

You change to mt7988_mac_port_get_caps looks correct to me and doing
this will already prevent mt753x_phylink_mac_config from ever being
called on MT7988 for port == 4 as well as and port == 5.
