Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F496D97B1
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbjDFNNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjDFNNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:13:40 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162BB59F9;
        Thu,  6 Apr 2023 06:13:39 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pkPQN-0001Ws-2h;
        Thu, 06 Apr 2023 15:13:12 +0200
Date:   Thu, 6 Apr 2023 14:13:05 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     arinc9.unal@gmail.com, Sean Wang <sean.wang@mediatek.com>,
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
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: fix port specifications
 for MT7988
Message-ID: <ZC7FYQDj4aTvaC9v@makrotopia.org>
References: <20230406100445.52915-1-arinc.unal@arinc9.com>
 <ZC6n1XAGyZFlxyXx@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZC6n1XAGyZFlxyXx@shell.armlinux.org.uk>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 12:07:01PM +0100, Russell King (Oracle) wrote:
> On Thu, Apr 06, 2023 at 01:04:45PM +0300, arinc9.unal@gmail.com wrote:
> > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > 
> > On the switch on the MT7988 SoC, there are only 4 PHYs. There's only port 6
> > as the CPU port, there's no port 5. Split the switch statement with a check
> > to enforce these for the switch on the MT7988 SoC. The internal phy-mode is
> > specific to MT7988 so put it for MT7988 only.
> > 
> > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > ---
> > 
> > Daniel, this is based on the information you provided me about the switch.
> > I will add this to my current patch series if it looks good to you.
> > 
> > Arınç
> > 
> > ---
> >  drivers/net/dsa/mt7530.c | 67 ++++++++++++++++++++++++++--------------
> >  1 file changed, 43 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index 6fbbdcb5987f..f167fa135ef1 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -2548,7 +2548,7 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
> >  	phy_interface_zero(config->supported_interfaces);
> >  
> >  	switch (port) {
> > -	case 0 ... 4: /* Internal phy */
> > +	case 0 ... 3: /* Internal phy */
> >  		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> >  			  config->supported_interfaces);
> >  		break;
> > @@ -2710,37 +2710,56 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  	struct mt7530_priv *priv = ds->priv;
> >  	u32 mcr_cur, mcr_new;
> >  
> > -	switch (port) {
> > -	case 0 ... 4: /* Internal phy */
> > -		if (state->interface != PHY_INTERFACE_MODE_GMII &&
> > -		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
> > -			goto unsupported;
> > -		break;
> > -	case 5: /* Port 5, a CPU port. */
> > -		if (priv->p5_interface == state->interface)
> > +	if (priv->id == ID_MT7988) {
> > +		switch (port) {
> > +		case 0 ... 3: /* Internal phy */
> > +			if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
> 
> How do these end up with PHY_INTERFACE_MODE_INTERNAL ? phylib defaults
> to GMII mode without something else being specified in DT.

As the link between mtk_eth_soc MAC and built-in switch as well as the
links between the built-in switch and the 4 built-in gigE PHYs are
internal, I wanted to describe them as such.

This was a reaction to the justified criticism that it doesn't make
sense to add 10GBase-KR and USXGMII as a proxy to actually indicate the
internal link between mt7530 CPU port and mtk_eth_soc gmac1 on the
MT7988, which Arınç had expressed in a review comment.

The phy-mode in the to-be-submitted DTS for MT7988 will be 'internal'
to describe the GMAC1<->MT7530 link as well as the MT7530<->gigE-PHY
links. I understand that for the built-in gigE PHYs we could just as
well us 'gmii', however, I thought that using 'internal' would be less
confusing as there is no actual GMII hardware interface.
And that's even more true for the link between GMAC1 and the built-in
switch, there are no actual USXGMII or 10GBase-KR hardware interfaces
but rather just a stateless internal link.

Sidenote: The same applies also for the link between GMAC2 and the
built-in 2500Base-T PHY. MediaTek was using 'xgmii' as PHY mode here to
program the internal muxes to connect the internal PHY with GMAC2, and
it took me a while to understand that there is no actual XGMII
interface anywhere, but they were rather just using this otherwise
unused interface mode as a flag for that...
Hence I decided to also use 'internal' PHY mode there, especially as in
this case there are several options: GMAC2 can also be connected to an
actual 1.25Gbaud/3.25Gbaud SGMII interface (pcs-mtk-lynxi again) OR an
actual 10GBase-KR/USXGMII SerDes, both can be muxed to the same pins
used to connect an external PHYs to the SoC.

Hence "phy-mode = 'internal';" will be a common occurance in mt7988.dtsi.

> 
> Also note that you should *not* be validating state->interface in the
> mac_config() method because it's way too late to reject it - if you get
> an unsupported interface here, then that is down to the get_caps()
> method being buggy. Only report interfaces in get_caps() that you are
> prepared to handle in the rest of the system.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
