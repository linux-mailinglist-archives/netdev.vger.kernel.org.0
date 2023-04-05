Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B8A6D88A9
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjDEUfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjDEUeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:34:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067455249;
        Wed,  5 Apr 2023 13:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ir96PDQ5DPUpeJhDM1v4BrKeIYiu1Z8SXvc8ylqyxe8=; b=APgRQZvMhXqYui/jKYMbnzPcry
        LwxJoMiLuXafar1R6r/+lEB3JLt42me4gaqh6MGXxrXsQ6JG3htDZ3ri3it2ZFxJD0F8SqAGkxhGt
        bfKq52f5ibdbLODUbWeZf3ogeFu8emiFcDv2gGhCOEdfH2DoKuMoP6K0+I0YvK45vtrU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pk9po-009Yke-Nq; Wed, 05 Apr 2023 22:34:24 +0200
Date:   Wed, 5 Apr 2023 22:34:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 06/12] net: phy: add phy_device_atomic_register helper
Message-ID: <34e22343-fb11-4a85-bade-492fcbcfb436@lunn.ch>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-6-7e5329f08002@pengutronix.de>
 <ad0b0d90-04bf-457c-9bdf-a747d66871b5@lunn.ch>
 <20230405152225.tu3wmbcvchuugs5u@pengutronix.de>
 <a5a4e735-7b24-4933-b431-f36305689a79@lunn.ch>
 <20230405194353.pwuk7e6rxnha3uqi@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405194353.pwuk7e6rxnha3uqi@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Currently we have one API which creates/allocates the 'struct
> phy_device' and intialize the state which is:
>    - phy_device_create()
> 
> This function requests a driver based on the phy_id/c45_ids. The ID have
> to come from somewhere if autodection is used. For autodetection case
>    - get_phy_device()
> 
> is called. This function try to access the phy without taken possible
> hardware dependencies into account. These dependecies can be reset-lines
> (in my case), clocks, supplies, ...
> 
> For taking fwnode (and possible dependencies) into account fwnode_mdio.c
> was written which provides two helpers:
>    - fwnode_mdiobus_register_phy()
>    - fwnode_mdiobus_phy_device_register().
> 
> The of_mdio.c and of_mdiobus_register_phy() is just a wrapper around
> fwnode_mdiobus_register_phy().

It seems to me that the real problem is that mdio_device_reset() takes
an mdio_device. mdiobus_register_gpiod() and mdiobus_register_reset()
also take an mdio_device. These are the functions you want to call
before calling of_mdiobus_register_phy() in __of_mdiobus_register() to
ensure the PHY is out of reset. But you don't have an mdio_device yet.

So i think a better solution is to refactor this code. Move the
resources into a structure of their own, and make that a member of
mdio_device. You can create a stack version of this resource structure
in __of_mdiobus_register(), parse DT to fill it out by calling
mdiobus_register_gpiod() and mdiobus_register_reset() taking this new
structure, take it out of reset by calling mdio_device_reset(), and
then call of_mdiobus_register_phy(). If a PHY is found, copy the
values in the resulting mdio_device. If not, release the resources.

Doing it like this means there is no API change.

      Andrew
