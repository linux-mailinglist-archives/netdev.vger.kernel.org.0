Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC53C54A170
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 23:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbiFMVbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 17:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351597AbiFMVaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 17:30:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F02FEC
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 14:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBFE4613EA
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 21:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DC2C34114;
        Mon, 13 Jun 2022 21:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655155763;
        bh=xpbB3z42Rnk0gOfoiIzo955qZaPiJnfc42F5d0vrE5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hZSehpY5XxRfIktLWs3G6v5y95P5qQwbijPsKSJdYNIb5+YsPdGqZtAP5ihMpm50n
         7x4pIH8gDZQfwqyZNFvdRY4TdxfKqZTxITRv8TYZuiyd1/qnGUG/+ruE5T0K2r0Dgr
         PnMUklpX9qDbcxHmXjsC6he747vUYasc5bUJW8LOGQTlLAfyj7soSCdmR6khGSSePf
         tUYb7joHQnKpX5i7NGF/K0PBU9OkW4AOS1cVjOOvJAaaDs4evE4nDmD/GVrkKK5TIh
         wdFEQF0fl+Z6lNa8gRc84KDL0NI1LADUFYBFtyas/rIC3uggkFO0q//2m/hub/ewM2
         ZA4biuKyWf0RA==
Date:   Mon, 13 Jun 2022 23:29:16 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>, pali@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 00/15] net: dsa: mv88e6xxx: convert to phylink
 pcs
Message-ID: <20220613232916.24888d46@thinkpad>
In-Reply-To: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jun 2022 13:59:03 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> Hi,
>=20
> This series converts mv88e6xxx to use phylink pcs, which I believe is
> the last DSA driver that needs to be converted before we can declare
> the whole of DSA as non-phylink legacy.
>=20
> Briefly:
> Patches 1 and 2 introduce a new phylink_pcs_inband() helper to indicate
> whether inband AN should be used. Note that the first patch fixes a bug
> in the current c22 helper where the SGMII exchange with the PHY would
> be disabled when AN is turned off on the PHY copper side.
>=20
> Patch 3 gets rid of phylink's internal pcs_ops member, preferring
> instead to always use the version in the phylink_pcs structure.
> Changing this pointer is now no longer supported.
>=20
> Patch 4 makes PCS polling slightly cleaner, avoiding the poll being
> triggered while we're making changes to the configuration.
>=20
> Patch 5 and 6 introduce several PCS methods that are fundamentally
> necessary for mv88e6xxx to work around various issues - for example, in
> some devices, the PCS must be powered down when the CMODE field in the
> port control register is changed. In other devices, there are
> workarounds that need to be performed.
>=20
> Patch 7 adds unlocked mdiobus and mdiodev accessors to complement the
> locking versions that are already there - which are needed for some of
> the mv88e6xxx conversions.
>=20
> Patch 8 prepares DSA as a whole, adding support for the phylink
> mac_prepare() and mac_finish() methods. These two methods are used to
> force the link down over a major reconfiguration event, which has been
> found by people to be necessary on mv88e6xxx devices. These haven't
> been required until now as everything has been done via the
> mac_config() callback - which won't be true once we switch to
> phylink_pcs.
>=20
> Patch 9 implements patch 8 on this driver.
>=20
> Patches 10 and 11 prepare mv88e6xxx for the conversion.
>=20
> Patches 12 through to 14 convert each "serdes" to phylink_pcs.
>=20
> Patch 15 cleans up after the conversion.
>=20
>  drivers/net/dsa/mv88e6xxx/Makefile   |    3 +
>  drivers/net/dsa/mv88e6xxx/chip.c     |  480 ++++----------
>  drivers/net/dsa/mv88e6xxx/chip.h     |   25 +-
>  drivers/net/dsa/mv88e6xxx/pcs-6185.c |  158 +++++
>  drivers/net/dsa/mv88e6xxx/pcs-6352.c |  383 +++++++++++
>  drivers/net/dsa/mv88e6xxx/pcs-639x.c |  834 ++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/port.c     |   30 -
>  drivers/net/dsa/mv88e6xxx/serdes.c   | 1164 ++--------------------------=
------
>  drivers/net/dsa/mv88e6xxx/serdes.h   |  110 +---
>  drivers/net/phy/mdio_bus.c           |   24 +-
>  drivers/net/phy/phylink.c            |  141 ++--
>  include/linux/mdio.h                 |   26 +
>  include/linux/phylink.h              |   44 ++
>  include/net/dsa.h                    |    6 +
>  net/dsa/port.c                       |   32 +
>  15 files changed, 1826 insertions(+), 1634 deletions(-)
>=20

Tested on Turris MOX, no regressions discovered so far.

Tested-by: Marek Beh=C3=BAn <kabel@kernel.org>

But patches 06/15 and 14/15 need testing on CN9130-CRB: the SFP cage
needs to be tested in 2500base-x mode, and also switching between
2500base-x, sgmii, 5gbase-r and 10gbase-r.

Pali, could you find some time for this? I can direct you about how to
do this.

Marek
