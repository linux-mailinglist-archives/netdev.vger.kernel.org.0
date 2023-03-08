Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4AB6AFB7C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjCHAsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCHAso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:48:44 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2994590B58
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 16:48:43 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id c184-20020a4a4fc1000000b005250b2dc0easo2328852oob.2
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 16:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1678236522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4z3se1IE/EIHIkhfgNY8EkICQQtBcC8YO4t3fMUOwOE=;
        b=oWDZGOvFRXAphCxl1DgXUC6PW9nI4pCLlcrNqQgded4g1ctLpsv3eO72MXbZs9tuTg
         4SLwdtYmO5yVFoZiceU7J/Qrbd+CX1HE9dAVPLAJ1fKG6zH/A4VcQiX3UOMJdobQJCjw
         3KOuTye6KS4nTDNm4X6dgS3X7/nzzANbfobmNuuFw16zA2U4ITqbHYnFU1SHd21y4miw
         CSw/4KwzVEuWx/VMR4QrI+Cri+NJWslhpE0Ek1iyDRK/cET1uZs93SkFg2WPC5lajyg1
         42/vxJMs1bMknLf6Y+RFnaEPloQsA79rk6z+Ml7UvwUnbx2SSlM/y6B8e8mbnN/EFBNH
         1saA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678236522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4z3se1IE/EIHIkhfgNY8EkICQQtBcC8YO4t3fMUOwOE=;
        b=4rxKQ1rGDBSBF9wReGS9DKEsozsYz+ocUTYheDCZz3os3LcMP1uDV90bgtzSi9QKqF
         eZQJBLewzz17xQBNR5U4vvY0sN945CdlFwuFdW7DMDQrJCMu3wWj72v6Kxw608V5E5yl
         ryo/c0tpgDvG0Yx8e6ZvI30YmSEMkZPgIZCitIZFywjJ3Ssbd8IjjTp/Ws1FjY35p3Vx
         mKqRs01H252X0oPV3eGmjPII9a8NX2ahgvzdXDwwTk7s82hSA8QhU880PqINb5VXaK0x
         uQeZNWPPG/NDVxDZUm6n/yjVBrviU8hkgyXC5F8YQWN6D0JTGCKSs7zjYdVTXnLwMpOv
         p3JA==
X-Gm-Message-State: AO0yUKUB///+uHU7i9nB1TiDtMcXLou/4/CWmV57gauqnU1P2O5BkUAy
        11zxzuIBKSzaBtq/8YTF8r7XP4V729hk78a/RiBZZQ==
X-Google-Smtp-Source: AK7set+ty7uVdpZ31Ug7urVUs43GJRLQ7srCKPacgjICRqJKo0JEZTgWE1J+mZI79ChefT5upbGoLwNqmagc916mLds=
X-Received: by 2002:a4a:d62f:0:b0:525:65a1:acd9 with SMTP id
 n15-20020a4ad62f000000b0052565a1acd9mr7359903oon.0.1678236522386; Tue, 07 Mar
 2023 16:48:42 -0800 (PST)
MIME-Version: 1.0
References: <20230307192927.512757-1-miquel.raynal@bootlin.com>
In-Reply-To: <20230307192927.512757-1-miquel.raynal@bootlin.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 7 Mar 2023 16:48:30 -0800
Message-ID: <CAPv3WKfmxogCggN=9PCWgaa8CXhZnaU_fzoBsF1MoBEguqakHQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mvpp2: Defer probe if MAC address source is
 not yet ready
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


wt., 7 mar 2023 o 11:29 Miquel Raynal <miquel.raynal@bootlin.com> napisa=C5=
=82(a):
>
> NVMEM layouts are no longer registered early, and thus may not yet be
> available when Ethernet drivers (or any other consumer) probe, leading
> to possible probe deferrals errors. Forward the error code if this
> happens. All other errors being discarded, the driver will eventually
> use a random MAC address if no other source was considered valid (no
> functional change on this regard).
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 24 ++++++++++++-------
>  1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 9b4ecbe4f36d..e7c7652ffac5 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6081,18 +6081,19 @@ static bool mvpp2_port_has_irqs(struct mvpp2 *pri=
v,
>         return true;
>  }
>
> -static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp=
2 *priv,
> -                                    struct fwnode_handle *fwnode,
> -                                    char **mac_from)
> +static int mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2=
 *priv,
> +                                   struct fwnode_handle *fwnode,
> +                                   char **mac_from)
>  {
>         struct mvpp2_port *port =3D netdev_priv(dev);
>         char hw_mac_addr[ETH_ALEN] =3D {0};
>         char fw_mac_addr[ETH_ALEN];
> +       int ret;
>
>         if (!fwnode_get_mac_address(fwnode, fw_mac_addr)) {
>                 *mac_from =3D "firmware node";
>                 eth_hw_addr_set(dev, fw_mac_addr);
> -               return;
> +               return 0;
>         }
>
>         if (priv->hw_version =3D=3D MVPP21) {
> @@ -6100,19 +6101,24 @@ static void mvpp2_port_copy_mac_addr(struct net_d=
evice *dev, struct mvpp2 *priv,
>                 if (is_valid_ether_addr(hw_mac_addr)) {
>                         *mac_from =3D "hardware";
>                         eth_hw_addr_set(dev, hw_mac_addr);
> -                       return;
> +                       return 0;
>                 }
>         }
>
>         /* Only valid on OF enabled platforms */
> -       if (!of_get_mac_address_nvmem(to_of_node(fwnode), fw_mac_addr)) {
> +       ret =3D of_get_mac_address_nvmem(to_of_node(fwnode), fw_mac_addr)=
;
> +       if (ret =3D=3D -EPROBE_DEFER)
> +               return ret;
> +       if (!ret) {
>                 *mac_from =3D "nvmem cell";
>                 eth_hw_addr_set(dev, fw_mac_addr);
> -               return;
> +               return 0;
>         }
>
>         *mac_from =3D "random";
>         eth_hw_addr_random(dev);
> +
> +       return 0;
>  }
>
>  static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *c=
onfig)
> @@ -6815,7 +6821,9 @@ static int mvpp2_port_probe(struct platform_device =
*pdev,
>         mutex_init(&port->gather_stats_lock);
>         INIT_DELAYED_WORK(&port->stats_work, mvpp2_gather_hw_statistics);
>
> -       mvpp2_port_copy_mac_addr(dev, priv, port_fwnode, &mac_from);
> +       err =3D mvpp2_port_copy_mac_addr(dev, priv, port_fwnode, &mac_fro=
m);
> +       if (err < 0)
> +               goto err_free_stats;
>
>         port->tx_ring_size =3D MVPP2_MAX_TXD_DFLT;
>         port->rx_ring_size =3D MVPP2_MAX_RXD_DFLT;

LGTM.

Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Thanks,
Marcin
