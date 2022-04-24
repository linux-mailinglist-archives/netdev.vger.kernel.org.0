Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956A650D3DF
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 19:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbiDXRX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 13:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbiDXRXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 13:23:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510B65675F;
        Sun, 24 Apr 2022 10:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19ECE611DE;
        Sun, 24 Apr 2022 17:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ED0C385A7;
        Sun, 24 Apr 2022 17:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650820852;
        bh=8YAkiDCHNS9PdDSByTQ12GIjlNhj3SzM6u+5fNxbJO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKQ5u6j6e5I5Oog+kDMGmMr9uNIdmteV8T84bSi60THEFgfwCVfnMfukav2R3rMSe
         hb7A6oRKc5XLbqzAbUwGEBkyxg67ytcaGZ7UqP5lHohQARzzzqPLPxGObMli4olfzE
         RjbxRkbwYsykQ8KL3T4VNvJ7XLpdNfaXw/n88bODDbSnK7JyHD/vBqZblaJBXFIT+C
         KiWu1JbznqX2Uwn4wu/2af6sN7rg94QMvEMewiDOXwK9mHZfX5dZwyf7Lj9CdxyQob
         xPCpWPrTYW0z83wyRUypkQ0E1qNnciMAr18tvbTkxUt3HUniIYXLxg8991za+bR3sP
         mcIuUk02voFgw==
Date:   Sun, 24 Apr 2022 19:20:46 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: Fix port_hidden_wait to account
 for port_base_addr
Message-ID: <20220424192046.6f77655a@thinkpad>
In-Reply-To: <20220424153143.323338-1-nathan@nathanrossi.com>
References: <20220424153143.323338-1-nathan@nathanrossi.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022 15:31:43 +0000
Nathan Rossi <nathan@nathanrossi.com> wrote:

> The other port_hidden functions rely on the port_read/port_write
> functions to access the hidden control port. These functions apply the
> offset for port_base_addr where applicable. Update port_hidden_wait to
> use the port_wait_bit so that port_base_addr offsets are accounted for
> when waiting for the busy bit to change.
>=20
> Without the offset the port_hidden_wait function would timeout on
> devices that have a non-zero port_base_addr (e.g. MV88E6141), however
> devices that have a zero port_base_addr would operate correctly (e.g.
> MV88E6390).
>=20
> Fixes: ea89098ef9a5 ("net: dsa: mv88x6xxx: mv88e6390 errata")
> Signed-off-by: Nathan Rossi <nathan@nathanrossi.com>
> ---
> Changes in v2:
> - Add fixes
> ---
>  drivers/net/dsa/mv88e6xxx/port_hidden.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/port_hidden.c b/drivers/net/dsa/mv=
88e6xxx/port_hidden.c
> index b49d05f0e1..7a9f9ff6de 100644
> --- a/drivers/net/dsa/mv88e6xxx/port_hidden.c
> +++ b/drivers/net/dsa/mv88e6xxx/port_hidden.c
> @@ -40,8 +40,9 @@ int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *c=
hip)
>  {
>  	int bit =3D __bf_shf(MV88E6XXX_PORT_RESERVED_1A_BUSY);
> =20
> -	return mv88e6xxx_wait_bit(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
> -				  MV88E6XXX_PORT_RESERVED_1A, bit, 0);
> +	return mv88e6xxx_port_wait_bit(chip,
> +				       MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
> +				       MV88E6XXX_PORT_RESERVED_1A, bit, 0);
>  }
> =20
>  int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int block, i=
nt port,

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
