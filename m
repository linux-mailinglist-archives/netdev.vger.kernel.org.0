Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352A64BF934
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiBVN1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiBVN1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:27:02 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C56F13DD3;
        Tue, 22 Feb 2022 05:26:35 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2E0F62000C;
        Tue, 22 Feb 2022 13:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645536393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+IeCrIvtHEXj+/TrckXq5Glou6qAet2MevCs2vi9JaY=;
        b=I8E4xgDu9bdg2csxyff9myhmdP9T8H3rRW7JiKdPYxnMHQuPETlACfrGDksH3L4Clzyki6
        OvL3hPaJIH8Mafgst2chAKdQ8DXNoOqfSrZoCotmQST48nAphr1z3mRqbUyp2pflX/p+Fh
        NR3iw/S2RJkcieGSrJvV6KKN1wV8/DdKQe+3WM1A0F6fMZesKf9e+UrHNWRGqmRXXTRZAG
        YSQKEU0RaA20Ys88kbiomOEhwnSOr3v8v+PUykfxCxDRKf42mzpkHGsxiPp3fGXJ5aLVvc
        c0P7IoCsDjQxoBHIjmwXDadzIcgPIxTudOGChfxezymkbnylZoxt4bOF/W6UCQ==
Date:   Tue, 22 Feb 2022 14:25:13 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Message-ID: <20220222142513.026ad98c@fixe.home>
In-Reply-To: <YhPSkz8+BIcdb72R@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-11-clement.leger@bootlin.com>
        <YhPSkz8+BIcdb72R@smile.fi.intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 21 Feb 2022 19:57:39 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> On Mon, Feb 21, 2022 at 05:26:52PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add support to retrieve a i2c bus in sfp with a fwnode. This support
> > is using the fwnode API which also works with device-tree and ACPI.
> > For this purpose, the device-tree and ACPI code handling the i2c
> > adapter retrieval was factorized with the new code. This also allows
> > i2c devices using a software_node description to be used by sfp code. =
=20
>=20
> If I'm not mistaken this patch can even go separately right now, since al=
l used
> APIs are already available.
>=20

This patches uses fwnode_find_i2c_adapter_by_node() which is introduced
by "i2c: fwnode: add fwnode_find_i2c_adapter_by_node()" but they can
probably be contributed both in a separate series.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
