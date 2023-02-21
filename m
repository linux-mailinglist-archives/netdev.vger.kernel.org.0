Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5151D69E004
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbjBUMNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbjBUMNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:13:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01CA22DD0
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676981469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dGP+PxCwtjOJ0qK4Ana0443j5sPbcO11i6GbUYLwmF4=;
        b=BCm3UqFPcLJ/SZA+AtBVmYJ4pm2EcmT2TC2SwuuECdJhXhrjSSI+H0ISrWBBbnAA1W4KL5
        ADCUBKflNXzFTNmyiLfsXQBZzGr5v9fzvJxIUc6pMEJDMMHXJe/yWya30AexFPff/fTpR4
        ujp20cHfH5iXuG9nW+5RivOj5MjYKMY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-60-10dkx9P4PqKm779NIat2Sg-1; Tue, 21 Feb 2023 06:57:34 -0500
X-MC-Unique: 10dkx9P4PqKm779NIat2Sg-1
Received: by mail-wr1-f69.google.com with SMTP id g6-20020adfa486000000b002c55ef1ec94so776851wrb.0
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dGP+PxCwtjOJ0qK4Ana0443j5sPbcO11i6GbUYLwmF4=;
        b=LXXVA03T4QvN6s1jbaf18EbCDF1nJBfUqRHD78yjajCvizUDMcFGwSqAQfKgTm9iG7
         0VyTeVOSQ/NHT7ZWArZ4TezD7yxj+U1veun0ZyqAdlnizG1ZOE6T6RHwYrdvPWjPLrCc
         9QSSjiYZuIbmqcrJAjzRbAP1JhzIxcDJW2T5wTvbuHiOd21cMNom56oa4mEKIleY+ZPk
         FpDT5hFuOGd6Q1H37THReFYqn6BI8Rpe/ITSy2Dt9tlsqrH3lG8Wlgw0J17CrTzFX173
         XrOQUjRCbAvpCAjvKmqJ2cSye7WENEIfR8snfmnMdobQYTQllysJEUvh0Y9fwVYAWuNK
         OSNg==
X-Gm-Message-State: AO0yUKVATOZKRID2WTgKK0RvRBHOPKcbAas7yBKPWQ+pHP0D5YqIm6zf
        3JpZ9lp3hxUjKGPMm0699VbpciLSbDkRTcwtRWI184AA7oXVvcPFkwHvnkFleDxFZ6EpxpsZ28x
        c3/nXO2yKibPJskeP
X-Received: by 2002:a05:600c:28e:b0:3db:2922:2b99 with SMTP id 14-20020a05600c028e00b003db29222b99mr3390148wmk.4.1676980652179;
        Tue, 21 Feb 2023 03:57:32 -0800 (PST)
X-Google-Smtp-Source: AK7set97fWN/XzfDt3oUXpty2TRFZBFd4Bpf/CMtDozVefsGSqWdVF3pW8IAfnnm7u3U06iwordPpg==
X-Received: by 2002:a05:600c:28e:b0:3db:2922:2b99 with SMTP id 14-20020a05600c028e00b003db29222b99mr3390137wmk.4.1676980651903;
        Tue, 21 Feb 2023 03:57:31 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id c22-20020a7bc856000000b003e01493b136sm4360151wml.43.2023.02.21.03.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 03:57:31 -0800 (PST)
Message-ID: <89c3f9b68d8030270ad58af2d9c94ae43eb5b1e6.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/4] net: phy: c45: add
 genphy_c45_an_config_eee_aneg() function
From:   Paolo Abeni <pabeni@redhat.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Date:   Tue, 21 Feb 2023 12:57:29 +0100
In-Reply-To: <20230221050334.578012-3-o.rempel@pengutronix.de>
References: <20230221050334.578012-1-o.rempel@pengutronix.de>
         <20230221050334.578012-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-21 at 06:03 +0100, Oleksij Rempel wrote:
> Add new genphy_c45_an_config_eee_aneg() function and replace some of
> genphy_c45_write_eee_adv() calls. This will be needed by the next patch.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phy-c45.c    | 12 +++++++++++-
>  drivers/net/phy/phy_device.c |  2 +-
>  include/linux/phy.h          |  1 +
>  3 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index f23cce2c5199..904f64818922 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -262,7 +262,7 @@ int genphy_c45_an_config_aneg(struct phy_device *phyd=
ev)
>  	linkmode_and(phydev->advertising, phydev->advertising,
>  		     phydev->supported);
> =20
> -	ret =3D genphy_c45_write_eee_adv(phydev, phydev->supported_eee);
> +	ret =3D genphy_c45_an_config_eee_aneg(phydev);
>  	if (ret < 0)
>  		return ret;
>  	else if (ret)
> @@ -858,6 +858,16 @@ int genphy_c45_read_eee_abilities(struct phy_device =
*phydev)
>  }
>  EXPORT_SYMBOL_GPL(genphy_c45_read_eee_abilities);
> =20
> +/**
> + * genphy_c45_an_config_eee_aneg - write advertised EEE link modes
> + * @phydev: target phy_device struct
> + * @adv: the linkmode advertisement settings

This function does not have a second argument.

Cheers,

Paolo

