Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A75D6A05A9
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbjBWKJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbjBWKJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:09:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1373D42BE4
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 02:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677146951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MwNi2R/qfei2F24G6SnycO92yZ0kjnuQBMoTKw0Q4E8=;
        b=NSy+Ni0BOlxtovhbvELEGor8aNQCa879zUdmplLN+W5WJnQriG6V5GBLMK4+Slgf/zZ9eT
        EENufdRv5r7hkNLni9dLBzlv7VZyV+4tt3Z0fw/ddclyOr1BKnzF5n9nOjVO1Mky+XEaxt
        ZrGUvg7xS0f73KBYaPo4pFlXecHnxKo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-407-tTOlgAlNORqId4s0atEeqw-1; Thu, 23 Feb 2023 05:09:09 -0500
X-MC-Unique: tTOlgAlNORqId4s0atEeqw-1
Received: by mail-qt1-f197.google.com with SMTP id t5-20020ac865c5000000b003abcad051d2so4733521qto.12
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 02:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677146949;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MwNi2R/qfei2F24G6SnycO92yZ0kjnuQBMoTKw0Q4E8=;
        b=QXM0WW+dCzi/IUBfEXpoRuRgHd44oIyD5osjcJ58X+OB4OdtaPimH1+FHEui47yrKf
         fRJl5gTMftuvzNVT/f9dF63HScpWOOM1Rg7I80qq4jBV7/+mkbOUHDhxFCjIdl9HizrD
         0LaFql0xLIWxK3FS1n4OVmFhsNPIzryZVsRJj9H2kXwCK1eHWd8WSdEHnga/NcKCXVla
         yX3pLZ6rffGTLsVrRaI7jLcvRdSEA2abHafxfrDkhqgxfRGTFcTU4Cn5qhq70zC0aqe1
         V3h9k4pOfhZjoty9dKmN3OWNkSqQpXvA1lkHHZPRsitnzlVozZBlNygIdvU7iEsHTeFU
         eyeA==
X-Gm-Message-State: AO0yUKW1FWeichwWAet3tIphdHEAaY2K81W988ezPlcpAq1IWT84RdcE
        8wrjjpWVFL7JqVKORVsfGiG6cZJWsqfTUIuneChx9zulhQJB7wYSHUXBN2xXM0Q7cdY8DJ2HiyO
        vlcKFN8xhUo3yl7nx
X-Received: by 2002:ac8:5cd4:0:b0:3bb:75c7:9326 with SMTP id s20-20020ac85cd4000000b003bb75c79326mr22869244qta.0.1677146949153;
        Thu, 23 Feb 2023 02:09:09 -0800 (PST)
X-Google-Smtp-Source: AK7set/koRPNANUmknQG+7kAuYwa4ay569snO2eNYzEq0HDqUGBTIoDvfkqm5FimiOMJ/yChM2nVyQ==
X-Received: by 2002:ac8:5cd4:0:b0:3bb:75c7:9326 with SMTP id s20-20020ac85cd4000000b003bb75c79326mr22869227qta.0.1677146948834;
        Thu, 23 Feb 2023 02:09:08 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id x191-20020a3763c8000000b007402fdda195sm6650615qkb.123.2023.02.23.02.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 02:09:08 -0800 (PST)
Message-ID: <83a8fb89ac7a69d08c9ea1422dade301dcc87297.camel@redhat.com>
Subject: Re: [PATCH V3 1/2] net: phylink: add a function to resume phy alone
 to fix resume issue with WoL enabled
From:   Paolo Abeni <pabeni@redhat.com>
To:     Clark Wang <xiaoning.wang@nxp.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Date:   Thu, 23 Feb 2023 11:09:04 +0100
In-Reply-To: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
References: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-02 at 16:15 +0800, Clark Wang wrote:
> Issue we met:
> On some platforms, mac cannot work after resumed from the suspend with Wo=
L
> enabled.
>=20
> The cause of the issue:
> 1. phylink_resolve() is in a workqueue which will not be executed immedia=
tely.
>    This is the call sequence:
>        phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
>    For stmmac driver, mac_link_up() will set the correct speed/duplex...
>    values which are from link_state.
> 2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
>    phylink_resume(), because mac need phy rx_clk to do the reset.
>    stmmac_core_init() is called in function stmmac_hw_setup(), which will
>    reset the mac and set the speed/duplex... to default value.
> Conclusion: Because phylink_resolve() cannot determine when it is called,=
 it
>             cannot be guaranteed to be called after stmmac_core_init().
> 	    Once stmmac_core_init() is called after phylink_resolve(),
> 	    the mac will be misconfigured and cannot be used.
>=20
> In order to avoid this problem, add a function called phylink_phy_resume(=
)
> to resume phy separately. This eliminates the need to call phylink_resume=
()
> before stmmac_hw_setup().
>=20
> Add another judgement before called phy_start() in phylink_start(). This =
way
> phy_start() will not be called multiple times when resumes. At the same t=
ime,
> it may not affect other drivers that do not use phylink_phy_resume().
>=20
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
> ---
> V2 change:
>  - add mac_resume_phy_separately flag to struct phylink to mark if the ma=
c
>    driver uses the phylink_phy_resume() first.
> V3 change:
>  - add brace to avoid ambiguous 'else'
>    Reported-by: kernel test robot <lkp@intel.com>
> ---
>  drivers/net/phy/phylink.c | 32 ++++++++++++++++++++++++++++++--
>  include/linux/phylink.h   |  1 +
>  2 files changed, 31 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 319790221d7f..c2fe66f0b78f 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -80,6 +80,8 @@ struct phylink {
>  	DECLARE_PHY_INTERFACE_MASK(sfp_interfaces);
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
>  	u8 sfp_port;
> +
> +	bool mac_resume_phy_separately;
>  };
> =20
>  #define phylink_printk(level, pl, fmt, ...) \
> @@ -1509,6 +1511,7 @@ struct phylink *phylink_create(struct phylink_confi=
g *config,
>  		return ERR_PTR(-EINVAL);
>  	}
> =20
> +	pl->mac_resume_phy_separately =3D false;
>  	pl->using_mac_select_pcs =3D using_mac_select_pcs;
>  	pl->phy_state.interface =3D iface;
>  	pl->link_interface =3D iface;
> @@ -1943,8 +1946,12 @@ void phylink_start(struct phylink *pl)
>  	}
>  	if (poll)
>  		mod_timer(&pl->link_poll, jiffies + HZ);
> -	if (pl->phydev)
> -		phy_start(pl->phydev);
> +	if (pl->phydev) {
> +		if (!pl->mac_resume_phy_separately)
> +			phy_start(pl->phydev);
> +		else
> +			pl->mac_resume_phy_separately =3D false;
> +	}
>  	if (pl->sfp_bus)
>  		sfp_upstream_start(pl->sfp_bus);
>  }
> @@ -2024,6 +2031,27 @@ void phylink_suspend(struct phylink *pl, bool mac_=
wol)
>  }
>  EXPORT_SYMBOL_GPL(phylink_suspend);
> =20
> +/**
> + * phylink_phy_resume() - resume phy alone
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * In the MAC driver using phylink, if the MAC needs the clock of the ph=
y
> + * when it resumes, can call this function to resume the phy separately.
> + * Then proceed to MAC resume operations.
> + */
> +void phylink_phy_resume(struct phylink *pl)
> +{
> +	ASSERT_RTNL();
> +
> +	if (!test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)
> +	    && pl->phydev) {
> +		phy_start(pl->phydev);
> +		pl->mac_resume_phy_separately =3D true;
> +	}
> +

Minor nit: the empty line here is not needed.

Cheers,

Paolo

