Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6398C67CD55
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 15:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjAZOMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 09:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjAZOMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 09:12:52 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE5B7DBE;
        Thu, 26 Jan 2023 06:12:49 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 600BEE0002;
        Thu, 26 Jan 2023 14:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674742368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=apF64NQiPjd6Pbr1s+6HUnhFlM+3Mq22SH9S9MZDcH8=;
        b=hnH9mwjYFt2M2tI9JelUob400f+76ivnks2/saJ8ZpdQc+zTj4qyrgYZEMPXdRzMzN5qZH
        /vaIMaWI98Xl2wzS8/K8DldzGDCAY2CKRPlaFCfHe222zDuqx0ephF3BvPFVMDDQltfnLX
        dbuDNb3Y1O3ajRXp1wcPDupk7o9J2sGefDkYeXMYwkugkrya+VaLQDr4f5cxJmTVmosF1o
        FCSQMi3mXQd6f3JJ3eIjRHGq/eaVsxAdd+ZefJJfRlcXW+8Ulp5IOsLkChFOZxKgi9frog
        3g+OcFgw+dSqjrnqVAG8cnJ/IcICfZQDmyNoF4/+AOYnZ/aIKNejkycmxVobnw==
Date:   Thu, 26 Jan 2023 15:12:43 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] at86rf230: convert to gpio descriptors
Message-ID: <20230126151243.3acc1fe2@xps-13>
In-Reply-To: <20230126135215.3387820-1-arnd@kernel.org>
References: <20230126135215.3387820-1-arnd@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

arnd@kernel.org wrote on Thu, 26 Jan 2023 14:51:23 +0100:

> From: Arnd Bergmann <arnd@arndb.de>
>=20
> There are no remaining in-tree users of the platform_data,
> so this driver can be converted to using the simpler gpiod
> interfaces.
>=20
> Any out-of-tree users that rely on the platform data can
> provide the data using the device_property and gpio_lookup
> interfaces instead.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ieee802154/at86rf230.c | 82 +++++++++---------------------
>  include/linux/spi/at86rf230.h      | 20 --------
>  2 files changed, 25 insertions(+), 77 deletions(-)
>  delete mode 100644 include/linux/spi/at86rf230.h
>=20

[...]

> @@ -1682,7 +1650,7 @@ MODULE_DEVICE_TABLE(spi, at86rf230_device_id);
>  static struct spi_driver at86rf230_driver =3D {
>  	.id_table =3D at86rf230_device_id,
>  	.driver =3D {
> -		.of_match_table =3D of_match_ptr(at86rf230_of_match),
> +		.of_match_table =3D at86rf230_of_match,linux-gnueabihf embed a C libra=
ry which relies on kernel headers (for example, to provide an open API whic=
h translates to an open syscall), for exam

Looks like an unrelated change? Or is it a consequence of "not having
any in-tree users of platform_data" that plays a role here?

Anyhow, the changes in the driver look good, so:

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>

Thanks,
Miqu=C3=A8l
