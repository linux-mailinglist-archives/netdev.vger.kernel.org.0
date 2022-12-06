Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0915D643B9E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 04:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiLFDEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 22:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLFDEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 22:04:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92288B486;
        Mon,  5 Dec 2022 19:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=knlKMQxu2kigd4KXDxW0Ewl4mzT6NSR6mAtv/z2qQcw=; b=r1DQ7eAPTdvXGxIH2eFI+ItaLM
        NWx9JL+5znG2RQGIkm5g/TY1ivfSzB5HjwvkBa5bFJlfqZsez/ARFtXRyqjyH7wd1qQEKrQB9krcc
        Yx+y84XcercxCnzaHwWewc4lAcsmYpEHkl6Gv0NXeZJcmphmTc9l0qFaQpP2Zt/aZA8s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2OF3-004TRN-Ji; Tue, 06 Dec 2022 04:03:33 +0100
Date:   Tue, 6 Dec 2022 04:03:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v3 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y46xBVuv9iaUdNLs@lunn.ch>
References: <d53ffecdde8d3950a24155228a3439f2c9b10b9b.1670259123.git.piergiorgio.beruto@gmail.com>
 <Y44y05M+6NGod+4x@shell.armlinux.org.uk>
 <Y4455r631my4LNIU@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4455r631my4LNIU@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Also, why do they need to be exported to modules? From what I can see,
> > the only user of these functions is phy_device.c, which is part of
> > the same module as phy.c where the functions live, meaning that they
> > don't need to be exported.
> I did this because similar functions in the same file are all exported
> to modules (e.g. phy_config_aneg, phy_speed_down, phy_start_cable_test).
> Therefore, I assumed the intention was to let modules (maybe out-of-tree
> modules?) make use of these functions. If you think we should not do
> this, would kindly explain why for example the phy_start_cable_test is
> exported?

phy_start_cable_test probably should not be exported. I probably got
this wrong. At one point, it might of been called directly from
net/ethtool/cabletest.c, but not any more. It is now accessed via
phy_ethtool_phy_ops.

Each kernel module is its own name space. You can only reference
something within a kernel module if it is exported. So you will find
all the helper functions in phy_device.c which are used by PHY drivers
are exported, for example.

You need to watch out for circular dependencies between modules, since
they are loaded sequentially. PHYs are generally leaves, they depend
on phylib and nothing else, so that is simple. The phylib module is
loaded first, and then the PHY drivers.

But there are more complex scenarios. A built in driver cannot
reference a module, that would result in undefined symbols. That is
probably what i got wrong with cable tests. I did all my testing with
it built in. But phylib can be built as a module. But that then
implies the core ethtool code cannot be built in, otherwise you get
undefined reference. So it was reworked to reference phylib via
phy_ethtool_phy_ops.

So as Russell says, if a function is only referenced within a module,
there is no need to export it, so keeping the kernel namespace clean.

      Andrew
