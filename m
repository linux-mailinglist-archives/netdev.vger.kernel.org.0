Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45D96CEFAE
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjC2Qot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjC2Qop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:44:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F03E46AC;
        Wed, 29 Mar 2023 09:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OhiuGHeCY6mb/VmM9pba3c4hvDQmt4O9Ky61+mVEOwk=; b=eWu+51WoLOq0vVZsd+3V0xa2jK
        oOut7+dM/ujZkhoVXuWyL30qr5aHHQm64/eiEDYiFQ2geOo/BA2VpSLfDgxWR++aYRZxrpcadrevs
        XwY1I+hpueS0a1Fy5BsaHFu7/Tw99gsBi9ZGFsMGRZA348uwtzIXqvytn4hmZkvKuE54=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phYuc-008mg8-7K; Wed, 29 Mar 2023 18:44:38 +0200
Date:   Wed, 29 Mar 2023 18:44:38 +0200
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
Subject: Re: [RFC PATCH net-next v3 12/15] net: dsa: mt7530: add support for
 single-chip reset line
Message-ID: <452c4d28-dc1b-4726-9bec-7065032de119@lunn.ch>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <0f696278bd8d13121a500f80cfe2f806debe4da5.1680105013.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f696278bd8d13121a500f80cfe2f806debe4da5.1680105013.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 05:00:06PM +0100, Daniel Golle wrote:
> Similar to multi-chip-module MT7530 also MT7988 uses an internal
> reset line instead of using an optional reset GPIO like it is the
> case for external MT7530 and MT7531 ICs.
> Add support for internal but non-MCM reset line in preparation for
> adding support for MT7988.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/dsa/mt7530.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index c6fad2d156160..fd55ddc2d1eb3 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -3066,6 +3066,12 @@ mt7530_probe_common(struct mt7530_priv *priv)
>  			dev_err(dev, "Couldn't get our reset line\n");
>  			return PTR_ERR(priv->rstc);
>  		}
> +	} else if (!priv->bus) {

!priv->bus is being used as a proxy here for MT7988. Maybe it would be
better to unconditionally use devm_reset_control_get_optional()? Or
move the reset out of mt7530_probe_common() because it is not
actually common?

	Andrew
