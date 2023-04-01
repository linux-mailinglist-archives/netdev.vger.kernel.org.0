Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BFF6D30E4
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 15:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjDANGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 09:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDANGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 09:06:04 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185BBAF3E;
        Sat,  1 Apr 2023 06:06:03 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1piava-0008Q2-1A;
        Sat, 01 Apr 2023 15:05:54 +0200
Date:   Sat, 1 Apr 2023 14:05:48 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
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
Subject: Re: [PATCH net-next 13/15] net: dsa: mt7530: add support for 10G
 link modes for CPU port
Message-ID: <ZCgsLFT6dwhCsAyE@makrotopia.org>
References: <cover.1680180959.git.daniel@makrotopia.org>
 <89ef48606fdbe896705a57a65a85c22cae01936e.1680180959.git.daniel@makrotopia.org>
 <8f213456-af0b-3047-d7ec-865fecec8142@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f213456-af0b-3047-d7ec-865fecec8142@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 11:56:43AM +0300, Arınç ÜNAL wrote:
> On 30.03.2023 18:23, Daniel Golle wrote:
> > The built-in switch of the MT7988 SoC is internally connected using
> > a stateless 10G link. Add support for 10G interface modes to silence
> > a warning otherwise occurring when the switch driver is setup.
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >   drivers/net/dsa/mt7530.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index 3a4682e71e746..ac666da2d10dc 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -2618,6 +2618,9 @@ mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >   	case PHY_INTERFACE_MODE_1000BASEX:
> >   	case PHY_INTERFACE_MODE_2500BASEX:
> >   		/* handled in SGMII PCS driver */
> > +	case PHY_INTERFACE_MODE_USXGMII:
> > +	case PHY_INTERFACE_MODE_10GKR:
> > +		/* internal stateless 10G link */
> >   		return 0;
> >   	default:
> >   		return -EINVAL;
> 
> I think it'd be better to make this explicitly for the switch in the
> MT7988 SoC.

I decided to rather introduce mt7988_mac_config (a noop returning
either 0 or -EINVAL), mt7988_mac_port_get_caps (allowing only USXGMII
and 10000FD) and mt7988_cpu_port_config (setting CPU port bit in
registers but not caring about interface mode and speed other than
USXGMII/10000FD).

The updated commit adding MT7988 is here:
https://github.com/dangowrt/linux/commit/595c940cbee90b5dbdc8173974a007fefe641550

So then I dropped
"net: dsa: mt7530: add support for 10G link modes for CPU port"
because it is no longer needed if all this is done explicitely for MT7988.

> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index e5347dd2521b..f7542c7f60e4 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2666,10 +2665,13 @@ mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  	case PHY_INTERFACE_MODE_1000BASEX:
>  	case PHY_INTERFACE_MODE_2500BASEX:
>  		/* handled in SGMII PCS driver */
> +		return 0;
>  	case PHY_INTERFACE_MODE_USXGMII:
>  	case PHY_INTERFACE_MODE_10GKR:
> -		/* internal stateless 10G link */
> -		return 0;
> +		if (priv->id == ID_MT7988)
> +			/* internal stateless 10G link */
> +			return 0;
> +
>  	default:
>  		return -EINVAL;
>  	}
> 
> Arınç
