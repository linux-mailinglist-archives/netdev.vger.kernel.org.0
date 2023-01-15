Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C2D66B447
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 22:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjAOV4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 16:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbjAOV4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 16:56:47 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C65918177;
        Sun, 15 Jan 2023 13:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IIANEC2vOrokwtWoEbldipND1bJMaHfk76CpGlzeLAM=; b=tyuBwT0QOLSlcLcuNzFWyCu8kb
        5nKDdf9APVJIA9CGRXrsJ1bFZtYleyktI/SDACMv7S0ggHZyocZGzFrpk8kWpv7swR+GXnsQsp8au
        i2uZ89dH3X4WXpbYWSythY5av9jNcBUIhHMDqjZkXlowOjleSSQcrq5GcwVC74wttj2o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHAzR-0029lB-QA; Sun, 15 Jan 2023 22:56:33 +0100
Date:   Sun, 15 Jan 2023 22:56:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>
Cc:     wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        linux-imx@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eran.m@variscite.com,
        nate.d@variscite.com, francesco.f@variscite.com,
        pierluigi.passaro@gmail.com
Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
Message-ID: <Y8R2kQMwgdgE6Qlp@lunn.ch>
References: <20230115213804.26650-1-pierluigi.p@variscite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230115213804.26650-1-pierluigi.p@variscite.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 10:38:04PM +0100, Pierluigi Passaro wrote:
> For dual fec interfaces, external phys can only be configured by fec0.
> When the function of_mdiobus_register return -EPROBE_DEFER, the driver
> is lately called to manage fec1, which wrongly register its mii_bus as
> fec0_mii_bus.
> When fec0 retry the probe, the previous assignement prevent the MDIO bus
> registration.
> Use a static boolean to trace the orginal MDIO bus deferred probe and
> prevent further registrations until the fec0 registration completed
> succesfully.

The real problem here seems to be that fep->dev_id is not
deterministic. I think a better fix would be to make the mdio bus name
deterministic. Use pdev->id instead of fep->dev_id + 1. That is what
most mdiobus drivers use.

	Andrew
