Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E435351F1
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 18:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344747AbiEZQXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 12:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiEZQXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 12:23:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0802E39B88;
        Thu, 26 May 2022 09:23:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 586D161CDB;
        Thu, 26 May 2022 16:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEFBC385A9;
        Thu, 26 May 2022 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653582195;
        bh=eMPfmFb/A6OibOFr1LhfCDVaZ7kXNdrZiwPUz7not2U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=stGzfXOitW90ORa89P9NO9gAkafD0u2sPGd08KNMfQh0157WZS3vyCfSzZFcHeECg
         J3M8ZhaJnu8TVzSSsrf9CqNa9QvfA5QsjDZwyfwU3+5qeKeGbTgQcHfcmwkX+T0RYG
         YCQh9yqkYKbF7GQ3ZVPA7/EvnU7emb3l6brVHtG4ZqdYqZ7Poz6nxwwQEGp1Y8wbjD
         0xZ4+2Hpl46XI36m8ml1dBXJ7YOybpdezDYnDwISrOELW7WI+vWXpy1FVBM04c3LVp
         ESAvc7nrHl7Xv0eH2lhtrl8QTwdAHcutb6eQLFK8B9EN0/p5WWPkDkxHwqXEe4Dmkq
         Zg21THhdrtsjw==
Date:   Thu, 26 May 2022 18:23:09 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: Fix refcount leak in
 mv88e6xxx_mdios_register
Message-ID: <20220526182309.2412106d@dellmb>
In-Reply-To: <20220526145208.25673-1-linmq006@gmail.com>
References: <20220526145208.25673-1-linmq006@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 May 2022 18:52:08 +0400
Miaoqian Lin <linmq006@gmail.com> wrote:

> of_get_child_by_name() returns a node pointer with refcount
> incremented, we should use of_node_put() on it when done.
>=20
> mv88e6xxx_mdio_register() pass the device node to of_mdiobus_register().
> We don't need the device node after it.
>=20
> Add missing of_node_put() to avoid refcount leak.
>=20
> Fixes: a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO busses")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
> changes in v2:
> - Add fixes tag.
> changes in v3:
> - Move of_node_put() statement to cover normal path.
> - Update commit message.
>=20
> I do cross-check to determine we should release the node after
> of_mdiobus_register(), refer to functions like lan78xx_mdio_init(),
> ave_init() and ag71xx_mdio_probe().
>=20
> v1 link: https://lore.kernel.org/r/20220526083748.39816-1-linmq006@gmail.=
com/
> v2 link: https://lore.kernel.org/all/20220526112415.13835-1-linmq006@gmai=
l.com/
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
> index 5d2c57a7c708..0b49d243e00b 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3960,6 +3960,7 @@ static int mv88e6xxx_mdios_register(struct mv88e6xx=
x_chip *chip,
>  	 */
>  	child =3D of_get_child_by_name(np, "mdio");
>  	err =3D mv88e6xxx_mdio_register(chip, child, false);
> +	of_node_put(child);
>  	if (err)
>  		return err;
> =20

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
