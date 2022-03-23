Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD9C4E5BA1
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 00:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345386AbiCWXDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 19:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345421AbiCWXDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 19:03:12 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712A02CC8C;
        Wed, 23 Mar 2022 16:01:42 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 644F5221D4;
        Thu, 24 Mar 2022 00:01:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648076500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mrbZnCx5ImFtI+d/9SJ/+v1bhmyj3qBx9rMgcrWC17Q=;
        b=Rs87I7ubuG5FwsuqBEU0Wbdrk44gkKESedjD6nAYcoxcQ3F8Y8Fcd2DiHKlYL/vVP31iMX
        jWcQPJrtcj6ULwLw6oXsrfaQWByIlQFUy7MJuNSXhF/PcDb0SpDJueH4k9EIX530VU4K8N
        ELSDV6o0AMdR9Gxg/AzbhsbbDyniDRQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Mar 2022 00:01:40 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/5] net: phy: C45-over-C22 access
In-Reply-To: <YjuDbqZom8knPVpm@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <YjuDbqZom8knPVpm@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <a09f9ac88b599f7124270a5063130c9e@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-23 21:30, schrieb Andrew Lunn:
> On Wed, Mar 23, 2022 at 07:34:14PM +0100, Michael Walle wrote:
>> Hi,
>> 
>> This is the result of this discussion:
>> https://lore.kernel.org/netdev/240354b0a54b37e8b5764773711b8aa3@walle.cc/
>> 
>> The goal here is to get the GYP215 and LAN8814 running on the 
>> Microchip
>> LAN9668 SoC. The LAN9668 suppports one external bus and unfortunately, 
>> the
>> LAN8814 has a bug which makes it impossible to use C45 on that bus.
>> Fortunately, it was the intention of the GPY215 driver to be used on a 
>> C22
>> bus. But I think this could have never really worked, because the
>> phy_get_c45_ids() will always do c45 accesses and thus on MDIO bus 
>> drivers
>> which will correctly check for the MII_ADDR_C45 flag and return 
>> -EOPNOTSUPP
>> the function call will fail and thus gpy_probe() will fail. This 
>> series
>> tries to fix that and will lay the foundation to add a workaround for 
>> the
>> LAN8814 bug by forcing an MDIO bus to be c22-only.
>> 
>> At the moment, the probe_capabilities is taken into account to decide 
>> if
>> we have to use C45-over-C22. What is still missing from this series is 
>> the
>> handling of a device tree property to restrict the probe_capabilities 
>> to
>> c22-only.
> 
> We have a problem here with phydev->is_c45.
> 
> In phy-core.c, functions __phy_read_mmd() and __phy_write_mmd() it
> means perform c45 transactions over the bus. We know we want to access
> a register in c45 space because we are using an _mmd() function.
> 
> In phy.c, it means does this PHY have c45 registers and we should
> access that register space, or should we use the c22 register
> space. So far example phy_restart_aneg() decides to either call
> genphy_c45_restart_aneg() or genphy_restart_aneg() depending on
> is_c45.

Yes, that is probably the reason why the gpy215 has explicitly
set .aneg_done to genphy_c45_aneg_done() for example.

> So a PHY with C45 register space but only accessible by C45 over C22
> is probably going to do the wrong thing with the current code.

Oh my, yes. Looks like the whole phy_get_c45_ids() isn't working
at all for the gpy at the moment (or maybe it will work because
it supports AN via the c22 registers, too). I'll have to dig deeper
into that tomorrow. I know that _something_ worked at least ;)

> For this patchset to work, we need to cleanly separate the concepts of
> what sort of transactions to do over the bus, from what register
> spaces the PHY has. We probably want something like phydev->has_c45 to
> indicate the register space is implemented, and phydev->c45_over_c22
> to indicate what sort of transaction should be used in the _mmd()
> functions.
> 
> Your patches start in that direction, but i don't think it goes far
> enough.

Thanks for the review!

-michael
