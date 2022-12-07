Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD48645C30
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiLGOQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLGOQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:16:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2A754362;
        Wed,  7 Dec 2022 06:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=dbkd/+Vu55XayZFihrFMd5Mqa9NyzPnzJBaNoPUMciM=; b=g+
        MFJIDxkwFf/tcwSjA9g+ny7TT/jpl/J434lPfyhxbZF9BRBaPzwiAgE7H4i2kcf8VVJgwcRH+6V6O
        QHaSy0pUUedHOLQbiGa5jgojoJhUnvgr+UrQ9Hk4gBDVLxSa0OpOERpAOYT203R7jQIQ7nDkrD8w/
        T8FEmV0qpPlE36U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2vDM-004f2G-CB; Wed, 07 Dec 2022 15:16:00 +0100
Date:   Wed, 7 Dec 2022 15:16:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5CgIL+cu4Fv43vy@lunn.ch>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
 <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5CQY0pI+4DobFSD@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > TBH I can't parse the "ETHTOOL_A_PLCA_VERSION is reported as 0Axx
> > where.." sentence. Specifically I'm confused about what the 0A is.
> How about this: "When this standard is supported, the upper byte of
> ``ETHTOOL_A_PLCA_VERSION`` shall be 0x0A (see Table A.1.0 — IDVER 
> bits assignment).

I think the 0x0A is pointless and should not be included here. If the
register does not contain 0x0A, the device does not follow the open
alliance standard, and hence the lower part of the register is
meaningless.

This is why i suggested -ENODEV should actually be returned on invalid
values in this register.

> > >   * struct ethtool_phy_ops - Optional PHY device options
> > >   * @get_sset_count: Get number of strings that @get_strings will write.
> > >   * @get_strings: Return a set of strings that describe the requested objects
> > >   * @get_stats: Return extended statistics about the PHY device.
> > > + * @get_plca_cfg: Return PLCA configuration.
> > > + * @set_plca_cfg: Set PLCA configuration.
> > 
> > missing get status in kdoc
> Fixed. Good catch.

Building with W=1 C=2 will tell you about kerneldoc issues. Ideally we
want all network code to be clean with these two options.

     Andrew
