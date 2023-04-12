Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A786DEBF8
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjDLGks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDLGks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:40:48 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2537C10B;
        Tue, 11 Apr 2023 23:40:44 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id ABF62FF806;
        Wed, 12 Apr 2023 06:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681281643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0inNdIAr829fr5K7PpU7etdJAAGCFNAmGQoieYPHcMs=;
        b=Kf6wrkZVYcGH40qojFViQ1U6OtDYwiD3KoDZyfc7LKCwqKFh0RSWyZFJWaN3XKFpAzd+od
        zMR4e2JrTgwnWyapS3bA6zmXOrZ++EB1+ZJAC8kbQ6a+UCXr0znrcB5ike8QnOTySXMAwi
        Eygdi0gAppNGzFzR+QxdUCrjcHjeGqqWgv3hkfkskEW/KSRN+5ex8E7tdPryUW7G2Zv0lA
        O+tDBtJJjeuzbOcaLPY0/nxanMaRYdF0qthFaLeyl9QQNuu41JoWIPGs6LdAkO10+kty6L
        RsVE1ZseC8SBwX++ZknMgAscxKqszVhUtclZo+5GFgXBSKNB9MELY13MGrpK4w==
Date:   Wed, 12 Apr 2023 10:38:12 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        "alexis.lothore@bootlin.com" <alexis.lothore@bootlin.com>
Subject: Re: [PATCH net v5 1/3] net: phylink: add phylink_expects_phy()
 method
Message-ID: <20230412103812.45e52ab5@pc-288.home>
In-Reply-To: <20230330091404.3293431-2-michael.wei.hong.sit@intel.com>
References: <20230330091404.3293431-1-michael.wei.hong.sit@intel.com>
        <20230330091404.3293431-2-michael.wei.hong.sit@intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

On Thu, 30 Mar 2023 17:14:02 +0800
Michael Sit Wei Hong <michael.wei.hong.sit@intel.com> wrote:

> Provide phylink_expects_phy() to allow MAC drivers to check if it
> is expecting a PHY to attach to. Since fixed-linked setups do not
> need to attach to a PHY.
>=20
> Provides a boolean value as to if the MAC should expect a PHY.
> Returns true if a PHY is expected.

I'm currently working on the TSE rework for dwmac_socfpga, and I
noticed one regression since this patch, when using an SFP, see details
below :

> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---
>  drivers/net/phy/phylink.c | 19 +++++++++++++++++++
>  include/linux/phylink.h   |  1 +
>  2 files changed, 20 insertions(+)
>=20
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 1a2f074685fa..30c166b33468 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1586,6 +1586,25 @@ void phylink_destroy(struct phylink *pl)
>  }
>  EXPORT_SYMBOL_GPL(phylink_destroy);
> =20
> +/**
> + * phylink_expects_phy() - Determine if phylink expects a phy to be
> attached
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * When using fixed-link mode, or in-band mode with 1000base-X or
> 2500base-X,
> + * no PHY is needed.
> + *
> + * Returns true if phylink will be expecting a PHY.
> + */
> +bool phylink_expects_phy(struct phylink *pl)
> +{
> +	if (pl->cfg_link_an_mode =3D=3D MLO_AN_FIXED ||
> +	    (pl->cfg_link_an_mode =3D=3D MLO_AN_INBAND &&
> +	     phy_interface_mode_is_8023z(pl->link_config.interface)))

=46rom the discussion, at one point Russell mentionned [1] :
"If there's a sfp bus, then we don't expect a PHY from the MAC driver
(as there can only be one PHY attached), and as phylink_expects_phy()
is for the MAC driver to use, we should be returning false if
pl->sfp_bus !=3D NULL."

This makes sense and indeed adding the relevant check solves the issue.

Am I correct in assuming this was an unintentional omission from this
patch, or was the pl->sfp_bus check dropped on purpose ?

> +		return false;
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(phylink_expects_phy);

Thanks,

Maxime

[1] :
https://lore.kernel.org/netdev/ZCQJWcdfmualIjvX@shell.armlinux.org.uk/
