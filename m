Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EBA6AE06B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCGN0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCGN0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:26:07 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D0C2D58
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 05:25:53 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZXJn-0000FJ-03;
        Tue, 07 Mar 2023 14:25:27 +0100
Date:   Tue, 7 Mar 2023 13:25:23 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 4/4] net: mtk_eth_soc: note interface modes
 not set in supported_interfaces
Message-ID: <ZAc7Q4VMzLjzQbRC@makrotopia.org>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
 <ZAcnjXxLfeE9UIsO@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAcnjXxLfeE9UIsO@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 12:01:17PM +0000, Russell King (Oracle) wrote:
> To any of those with Mediatek hardware... Any opinions on what we should
> do concerning these modes?
> 
> If I don't get a reply, then I'll delete these. There's no point having
> this code if it's been unreachable for a while and no one's complained.

A quick grep through the device trees of the more than 650 ramips and
mediatek boards we support in OpenWrt has revealed that *none* of them
uses either reduced-MII or reverse-MII PHY modes. I could imaging that
some more specialized ramips boards may use the RMII 100M PHY mode to
connect with exotic PHYs for industrial or automotive applications
(think: for 100BASE-T1 PHY connected via RMII). I have never seen or
touched such boards, but there are hints that they do exist.

For reverse-MII there are cases in which the Ralink SoC (Rt305x, for
example) is used in iNIC mode, ie. connected as a PHY to another SoC,
and running only a minimal firmware rather than running Linux. Due to
the lack of external DRAM for the Ralink SoC on this kind of boards,
the Ralink SoC there will anyway never be able to boot Linux.
I've seen this e.g. in multimedia devices like early WiFi-connected
not-yet-so-smart TVs.

Tl;dr: I'd drop them. If anyone really needs them, it would be easy to
add them again and then also add them to the phylink capability mask.

> 
> Thanks.
> 
> On Fri, Feb 24, 2023 at 12:36:26PM +0000, Russell King (Oracle) wrote:
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > index f78810717f66..280490942fa4 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > @@ -530,9 +530,11 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
> >  		case PHY_INTERFACE_MODE_GMII:
> >  			ge_mode = 1;
> >  			break;
> > +		/* FIXME: RMII is not set in the phylink capabilities */
> >  		case PHY_INTERFACE_MODE_REVMII:
> >  			ge_mode = 2;
> >  			break;
> > +		/* FIXME: RMII is not set in the phylink capabilities */
> >  		case PHY_INTERFACE_MODE_RMII:
> >  			if (mac->id)
> >  				goto err_phy;
> > -- 
> > 2.30.2
> > 
> > 
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
