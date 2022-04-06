Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C884F6DDB
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 00:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiDFWhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 18:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiDFWhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 18:37:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B78C33C
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 15:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A77DFB8259A
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 22:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8E5C385A3;
        Wed,  6 Apr 2022 22:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649284533;
        bh=WtvLwqpqfTA6i1bljoO86kqfUjW/XBPRM3YdjFro7PA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lNvF2AoNmk1xXKVRvbDaaK+p+djtgyQNYLbZJWSuSkk9YSx1S2sklWDIBQh/5bjey
         xJQMHE7148QlIcJ7b5YSGvsFoj93HMeb907dHsO8vYd8je6DBlbTJfyII9O2jGaa9E
         b+bZyn25ClzpIS9klY6OraOKJbbrpy0GwsJNpMNozpO1VlvcmYrs0DdXcXv6IqrKyi
         1dbh1xvRJ4zqYwngRRRQuu5ewhFRBLl+23lb44GYbWCksebVsKCSX0yhOcov9815P6
         Y0FL9zyy2SBYooeG0cdsR+2VyqPsDkQamxclj1C7nrF8G28LGjlMn1JaI5dToVHBTF
         x0v/qH0jkR0Wg==
Date:   Thu, 7 Apr 2022 00:35:26 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 0/9] net: dsa: mt7530: updates for phylink
 changes
Message-ID: <20220407003526.7d4c2ebb@thinkpad>
In-Reply-To: <Yk1iHCy4fqvxsvu0@shell.armlinux.org.uk>
References: <Yk1iHCy4fqvxsvu0@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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

On Wed, 6 Apr 2022 10:49:16 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> Hi,
>=20
> This revised series is a partial conversion of the mt7530 DSA driver to
> the modern phylink infrastructure. This driver has some exceptional
> cases which prevent - at the moment - its full conversion (particularly
> with the Autoneg bit) to using phylink_generic_validate().
>=20
> Patch 1 fixes the incorrect test highlighted in the first RFC series.
>=20
> Patch 2 fixes the incorrect assumption that RGMII is unable to support
> 1000BASE-X.
>=20
> Patch 3 populates the supported_interfaces for each port
>=20
> Patch 4 removes the interface checks that become unnecessary as a result
> of patch 3.
>=20
> Patch 5 removes use of phylink_helper_basex_speed() which is no longer
> required by phylink.
>=20
> Patch 6 becomes possible after patch 5, only indicating the ethtool
> modes that can be supported with a particular interface mode - this
> involves removing some modes and adding others as per phylink
> documentation.
>=20
> Patch 7 switches the driver to use phylink_get_linkmodes(), which moves
> the driver as close as we can to phylink_generic_validate() due to the
> Autoneg bit issue mentioned above.
>=20
> Patch 8 converts the driver to the phylink pcs support, removing a bunch
> of driver private indirected methods. We include TRGMII as a PCS even
> though strictly TRGMII does not have a PCS. This is convenient to allow
> the change in patch 9 to be made.
>=20
> Patch 9 moves the special autoneg handling to the PCS validate method,
> which means we can convert the MAC side to the generic validator.
>=20
> Patch 10 marks the driver as non-legacy.
>=20
> The series was posted on 23 February, and a ping sent on 3 March, but
> no feedback has been received. The previous posting also received no
> feedback on the actual patches either.
>=20
>  drivers/net/dsa/mt7530.c | 330 +++++++++++++++++++++--------------------=
------
>  drivers/net/dsa/mt7530.h |  26 ++--
>  2 files changed, 159 insertions(+), 197 deletions(-)
>=20

Tested-by: Marek Beh=C3=BAn <kabel@kernel.org>
