Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22584CCC8E
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiCDEbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiCDEbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:31:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713161795D3;
        Thu,  3 Mar 2022 20:30:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E0BE61AFE;
        Fri,  4 Mar 2022 04:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1061C340E9;
        Fri,  4 Mar 2022 04:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646368227;
        bh=GiX2XCDW2aldPmt0J8cV8H59r4s17rfaf5LVl4cWZ8M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p/vY0f1LqIAH4dGnvShvR5X+uZFILLmfx96egbgG5wlIx3T/h+2k7C97IReNVXmJj
         4oglwPky+AMYLQDZvGqcbJIjTpAqeRDFVB8km+l9sFVo3btirkoP3OXb/oFxrsrsWp
         whBF6WejxSh7L80TTlZol4PhgcAZaHBauTAK8dA9TyejmYYfrOzDi8MKNRZptlgyCG
         mV/pxD2ZnZQAoXkrAOY0QgPZ7Y964MHa+99QGVXeZQUjqEcQaRPOPZNUIrEvm5JdYm
         BV/sJD9Ljo3CVGT/JdaINdUO5015ycvPlVrvnpj3ILhxBhqBHzj4EgMA+dycvTn4q5
         MVxKm7qlhxf4w==
Date:   Thu, 3 Mar 2022 20:30:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v3 03/11] net: mac802154: Create a transmit
 error helper
Message-ID: <20220303203025.17df135e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303182508.288136-4-miquel.raynal@bootlin.com>
References: <20220303182508.288136-1-miquel.raynal@bootlin.com>
        <20220303182508.288136-4-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Mar 2022 19:25:00 +0100 Miquel Raynal wrote:
> So far there is only a helper for successful transmission, which led
> device drivers to implement their own handling in case of
> error. Unfortunately, we really need all the drivers to give the hand
> back to the core once they are done in order to be able to build a
> proper synchronous API. So let's create a _xmit_error() helper and take
> this opportunity to fill the new device-global field storing Tx
> statuses.
>=20
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

I'm sure kbuild bot will tell you as well but there's a transient build
failure here which will break bisection:

net/mac802154/util.c: In function =E2=80=98ieee802154_xmit_error=E2=80=99:
net/mac802154/util.c:96:14: error: =E2=80=98struct ieee802154_local=E2=80=
=99 has no member named =E2=80=98tx_result=E2=80=99
   96 |         local->tx_result =3D reason;
      |              ^~
