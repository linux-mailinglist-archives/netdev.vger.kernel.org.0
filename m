Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552BE4C1658
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbiBWPR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241012AbiBWPR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:17:28 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B2B5F86;
        Wed, 23 Feb 2022 07:16:57 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 80AC860011;
        Wed, 23 Feb 2022 15:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645629416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ouy4geTuy2NUlaMn2as08Xj16jCd5lJgErIRFPzPOR8=;
        b=G0f+1fTKoIkEV0MIWAwjJKMxXLz0JduXxjTvhqs1QoQifBU64Y/s07BZnVv0PTbo7GprZX
        KKwtYJTKyXW/Bb3YO3RGK4mf3SRIXA/84Nyu0bJ+pwTXglRSwz+ls79t5X0t+AqmdVgeOC
        PvnHpc9a5b2gX6aWWRFi0QzVCO7YkY14v9dYwuX6EcB55J5ybbo7lbaLbjT1EkCDOqAJjy
        +PSluciPhAMyjAkBcTd9bQ1OoIOL29twiTHqfpUtNtdo3hsDCDHhVnkf9Ul1GsYqFYZlh8
        SwAmW0kvUzEhOlvi8uNREClScyW8JAJQg5Jq4yhfDrnLtgQtnDxn6CIkvQjwWw==
Date:   Wed, 23 Feb 2022 16:15:35 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
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
Subject: Re: [RFC 03/10] base: swnode: use fwnode_get_match_data()
Message-ID: <20220223161535.15f45d0e@fixe.home>
In-Reply-To: <YhZNMkwN3o40jDP5@paasikivi.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-4-clement.leger@bootlin.com>
        <YhPQUPzz5vPvHUAy@smile.fi.intel.com>
        <20220222093921.24878bae@fixe.home>
        <YhZNMkwN3o40jDP5@paasikivi.fi.intel.com>
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

Le Wed, 23 Feb 2022 17:05:22 +0200,
Sakari Ailus <sakari.ailus@linux.intel.com> a =C3=A9crit :

> > const void *device_get_match_data(struct device *dev)
> > {
> > 	if (!fwnode_has_op(fwnode, device_get_match_data)
> > 		return fwnode_get_match_data(dev);
> > 	return fwnode_call_ptr_op(dev_fwnode(dev),device_get_match_data, dev);
> > }
> >=20
> > But I thought it was more convenient to do it by setting the
> > .device_get_match_data field of software_node operations. =20
>=20
> Should this function be called e.g. software_node_get_match_data() instea=
d,
> as it seems to be specific to software nodes?

Hi Sakari,

You are right, since the only user of this function currently is the
software_node operations, then I should rename it and move it to
swnode.c maybe.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
