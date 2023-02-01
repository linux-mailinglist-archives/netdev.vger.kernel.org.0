Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB71686CB5
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjBARUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbjBARUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:20:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405095CFCF;
        Wed,  1 Feb 2023 09:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HmmxRzyOM8pg21rswSew0JvvkISMUe9e3G3lAQoi40I=; b=1K/3bxzuuHR2szabm/YZgNejdk
        S/qzEaggkbukabJz7V/43osvJC7VQlTTussq1p/Ggd6FZwL0UC0svbwI9aSWdu+3HQvFl3DCDXj+A
        CwzGh/QUIYOSIm2b+q7gqRQ5bxKKMKo8s12wxpe6fFEtwzQV1dtKfAO0iJWHxMhgv/UU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNGmU-003osR-Sg; Wed, 01 Feb 2023 18:20:22 +0100
Date:   Wed, 1 Feb 2023 18:20:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 05/23] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
Message-ID: <Y9qfVpfWCc5W60VT@lunn.ch>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201145845.2312060-6-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 03:58:27PM +0100, Oleksij Rempel wrote:
> Add replacement for phy_ethtool_get/set_eee() functions.
> 
> Current phy_ethtool_get/set_eee() implementation is great and it is
> possible to make it even better:
> - this functionality is for devices implementing parts of IEEE 802.3
>   specification beyond Clause 22. The better place for this code is
>   phy-c45.c
> - currently it is able to do read/write operations on PHYs with
>   different abilities to not existing registers. It is better to
>   use stored supported_eee abilities to avoid false read/write
>   operations.
> - the eee_active detection will provide wrong results on not supported
>   link modes. It is better to validate speed/duplex properties against
>   supported EEE link modes.
> - it is able to support only limited amount of link modes. We have more
>   EEE link modes...
> 
> By refactoring this code I address most of this point except of the last
> one. Adding additional EEE link modes will need more work.

phydev->eee_broken_modes in particular is an issue. Anybody with
broken 10baseT1L will not be able to work around it currently.

Not that i'm saying this need fixing now.

    Andrew
