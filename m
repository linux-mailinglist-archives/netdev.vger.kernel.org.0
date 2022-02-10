Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960D54B0520
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiBJFcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:32:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiBJFcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:32:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13C610A1;
        Wed,  9 Feb 2022 21:32:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46E48B81CDA;
        Thu, 10 Feb 2022 05:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31E0C004E1;
        Thu, 10 Feb 2022 05:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644471128;
        bh=1Ba895HDYfz+/f/FPSbYCRt0YA+LLmW516azbl8jSg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SjFLUTuELAgYzteTfvY2euv4ccWGq5iYhLOxt7rdq8+N6HO/aZr09QP+ebSHW+j+6
         Q1MV9gxoHVUxeXWZpzJ+PkttUA6Bl4z2P1VJy1YyFzIeQJJjCXOZro4GKujBRcuSt5
         UY7M4aTOQlHnWY2iJ8BJ442WZhFRtRmoPfyhXz2XPuXIOlsrkDCe5p9ErX+19KMkBY
         MFg980Cv6vjdhb/zMwueAfPKBgKLNrJfFL27U2QENHN6uFy+/Mf8AMZS1PrUL18kDD
         XKlxEkOWwoNX9P5uO6VUHjw1G2soGfyUvGBvexg4FLGOO/Akivy4fjs2iXcfh6wi2N
         cSxqji4CkFa3A==
Date:   Wed, 9 Feb 2022 21:32:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Subject: Re: [PATCH net-next v4 2/2] mctp i2c: MCTP I2C binding driver
Message-ID: <20220209213207.6a8c1c2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220209103121.3907832-3-matt@codeconstruct.com.au>
References: <20220209103121.3907832-1-matt@codeconstruct.com.au>
        <20220209103121.3907832-3-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Feb 2022 18:31:21 +0800 Matt Johnston wrote:
> Provides MCTP network transport over an I2C bus, as specified in
> DMTF DSP0237. All messages between nodes are sent as SMBus Block Writes.
>=20
> Each I2C bus to be used for MCTP is flagged in devicetree by a
> 'mctp-controller' property on the bus node. Each flagged bus gets a
> mctpi2cX net device created based on the bus number. A
> 'mctp-i2c-controller' I2C client needs to be added under the adapter. In
> an I2C mux situation the mctp-i2c-controller node must be attached only
> to the root I2C bus. The I2C client will handle incoming I2C slave block
> write data for subordinate busses as well as its own bus.
>=20
> In configurations without devicetree a driver instance can be attached
> to a bus using the I2C slave new_device mechanism.
>=20
> The MCTP core will hold/release the MCTP I2C device while responses
> are pending (a 6 second timeout or once a socket is closed, response
> received etc). While held the MCTP I2C driver will lock the I2C bus so
> that the correct I2C mux remains selected while responses are received.
>=20
> (Ideally we would just lock the mux to keep the current bus selected for
> the response rather than a full I2C bus lock, but that isn't exposed in
> the I2C mux API)
>=20
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

drivers/net/mctp/mctp-i2c.c: In function =E2=80=98mctp_i2c_xmit=E2=80=99:
drivers/net/mctp/mctp-i2c.c:442:38: warning: format =E2=80=98%zu=E2=80=99 e=
xpects argument of type =E2=80=98size_t=E2=80=99, but argument 3 has type =
=E2=80=98int=E2=80=99 [-Wformat=3D]
  442 |                                      "Bad tx length %zu vs skb %u\n=
",
      |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/dev_printk.h:110:30: note: in definition of macro =E2=80=98de=
v_printk_index_wrap=E2=80=99
  110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                  =
     \
      |                              ^~~
include/linux/dev_printk.h:146:61: note: in expansion of macro =E2=80=98dev=
_fmt=E2=80=99
  146 |         dev_printk_index_wrap(_dev_warn, KERN_WARNING, dev, dev_fmt=
(fmt), ##__VA_ARGS__)
      |                                                             ^~~~~~~
include/linux/dev_printk.h:208:17: note: in expansion of macro =E2=80=98dev=
_warn=E2=80=99
  208 |                 dev_level(dev, fmt, ##__VA_ARGS__);                =
     \
      |                 ^~~~~~~~~
include/linux/dev_printk.h:220:9: note: in expansion of macro =E2=80=98dev_=
level_ratelimited=E2=80=99
  220 |         dev_level_ratelimited(dev_warn, dev, fmt, ##__VA_ARGS__)
      |         ^~~~~~~~~~~~~~~~~~~~~
drivers/net/mctp/mctp-i2c.c:441:17: note: in expansion of macro =E2=80=98de=
v_warn_ratelimited=E2=80=99
  441 |                 dev_warn_ratelimited(&midev->adapter->dev,
      |                 ^~~~~~~~~~~~~~~~~~~~
drivers/net/mctp/mctp-i2c.c:442:55: note: format string is defined here
  442 |                                      "Bad tx length %zu vs skb %u\n=
",
      |                                                     ~~^
      |                                                       |
      |                                                       long unsigned=
 int
      |                                                     %u
