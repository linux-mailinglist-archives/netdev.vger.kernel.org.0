Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2776A4BF41F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiBVIzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiBVIzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:55:12 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F50D114749;
        Tue, 22 Feb 2022 00:54:47 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 269AA24000B;
        Tue, 22 Feb 2022 08:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645520085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tMnxGGx8Xyue819/upl4mUh2mt0zClg3PGdZxVnJUMQ=;
        b=J0qitof8zwmBwJ0Dou4GGwsV8feIxtxRva0b7lzwaSAEmT/M24a+yOAK0b2MdJo2YPT89y
        MHB056ue6l8/dAS1wt6khhQXRNJ83F8a2rEx0FBu0Nbf6125ptY2m7hGDtz3PuERWBOnmM
        rdPkzAbZcUANf50nePU/WEOJ6aTZ0ozIUrzTCQoV/+jwrL3XoquYx9lAUecjjY2SQEgoQw
        S3Me+ogH0B3/E9wzVONdOFO7+QAwW9dFtF7nyhb1DTUCqLY0iesM4esjlNQ2OS6x7c6he0
        0X8hsf8ZCzG/CiVOm85OkuCXdfH1avcHZ4Cpxr4TV7JXI53NCy5AjuwlvZN1aA==
Date:   Tue, 22 Feb 2022 09:53:25 +0100
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
Subject: Re: [RFC 09/10] i2c: mux: add support for fwnode
Message-ID: <20220222095325.52419021@fixe.home>
In-Reply-To: <YhPSDTAPiTvEESnO@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-10-clement.leger@bootlin.com>
        <YhPSDTAPiTvEESnO@smile.fi.intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 21 Feb 2022 19:55:25 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> On Mon, Feb 21, 2022 at 05:26:51PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Modify i2c_mux_add_adapter() to use with fwnode API to allow creating
> > mux adapters with fwnode based devices. This allows to have a node
> > independent support for i2c muxes. =20
>=20
> I^2C muxes have their own description for DT and ACPI platforms, I'm not =
sure
> swnode should be used here at all. Just upload a corresponding SSDT overl=
ay or
> DT overlay depending on the platform. Can it be achieved?
>=20

Problem is that this PCIe card can be plugged either in a X86 platform
using ACPI or on a ARM one with device-tree. So it means I should have
two "identical" descriptions for each platforms.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
