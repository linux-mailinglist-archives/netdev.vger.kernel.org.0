Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AB44DDF7A
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbiCRQ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237562AbiCRQ7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:59:16 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF3A1E0;
        Fri, 18 Mar 2022 09:57:56 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D83D61BF204;
        Fri, 18 Mar 2022 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647622675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=255thDF/aiPYpzBrM90c9D6DpMZZoegXddau3Sj7vXQ=;
        b=PXnPiPPVCHTGqwcDR20xLQ7sfJUOj+rgke5v12jHY+ZJUwby9NAT2QHPjrosClkrXpJU4r
        v01qDEEAyualGDL2SyXVCWfljAS1Dc2/JlDet3Lc8U7UbzK4JQYBDTwf9n03QWus+Fdxrs
        wG68YD9/qLYeV5hEYrBwYf4J496Em4+EpVh3J5TgzmiDcS739x83yP+j8edABhDHCrBrc8
        /XYXOfiZ2FDe4kn4KAfNVEoc3Mz0Sk4qLtqlABv/U16nfGSl2ggjs1EraelaoNZbrmjpve
        gC8YQb8Uz5NnuxLnGKliroWMQOWmbVN2EA3nO4DPhTpnHBDuY7051I4cihWr2A==
Date:   Fri, 18 Mar 2022 17:56:30 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/6] i2c: mux: pinctrl: remove CONFIG_OF dependency and
 use fwnode API
Message-ID: <20220318175630.0e235f41@fixe.home>
In-Reply-To: <YjSzPeWpcR/SSX1a@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
        <20220318160059.328208-5-clement.leger@bootlin.com>
        <YjSzPeWpcR/SSX1a@smile.fi.intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 18 Mar 2022 18:28:45 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> On Fri, Mar 18, 2022 at 05:00:50PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > In order to use i2c muxes with software_node when added with a struct
> > mfd_cell, switch to fwnode API. The fwnode layer will allow to use this
> > with both device_node and software_node. =20
>=20
> > -	struct device_node *np =3D dev->of_node;
> > +	struct fwnode_handle *np =3D dev_fwnode(dev); =20
>=20
> np is now a misleading name. Use fwnode.
>=20

Ok I thought np was meaning "node pointer" and it looked like okay to
avoid avoid a diff that is too huge. But agreed, I'll rename that.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
