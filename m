Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0103611046
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJ1L7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJ1L7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:59:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F54E8D
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TtvXxGNhl/ynz7w4S/mtR/RXkGEKT6/S8v5d79NP8eA=; b=OrykJW5c+Vp+KHcM2+XtZWKaSl
        prTW1I7EmK94xazzUCFMisZESebDOMnkOB8LHWNLMI7cvLv69WyZDToO7ADFiVr83TFIJ8wbhhk91
        iRWQtcjV+71hEZ51MkGBURImpZDDfdWHzcgOBqSz5LajJ2x6G784Pxj4RrhI4rmE/5Ks=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooO0n-000o2y-In; Fri, 28 Oct 2022 13:58:57 +0200
Date:   Fri, 28 Oct 2022 13:58:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "tharvey@gateworks.com" <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@denx.de>
Subject: Re: Marvell 88E6320 connected to i.MX8MN
Message-ID: <Y1vEAUJIJf8VBTdv@lunn.ch>
References: <CAOMZO5DJAsj8-m2tEfrHn4xZdK6FE0bZepRZBrSD9=tWSSCNOA@mail.gmail.com>
 <20221027204135.grfsorkt7fdk6ccp@skbuf>
 <CAOMZO5ANFe1AH2PqafbHd97G0L=-LnSyHt5VjBKh0EAskm5JBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5ANFe1AH2PqafbHd97G0L=-LnSyHt5VjBKh0EAskm5JBw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 11:24:40PM -0300, Fabio Estevam wrote:
>  Hi Vladimir,
> 
> On Thu, Oct 27, 2022 at 5:41 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> 
> > Looks like you are missing the Marvell PHY driver; the generic PHY
> > driver gets used. Can you enable CONFIG_MARVELL_PHY?
> 
> CONFIG_MARVELL_PHY is already selected.
> 
> However, there is no support for 88E6320 in the Marvell PHY driver.

In theory, there should not be any support needed. The PHY registers 2
and 3 contain the PHY ID. If Marvell have reused an off the shelf PHY,
it should have an ID which the drivers knows.

However, a few Marvell Switches are broken by design, and registers 2
and 3 are empty. It is documented you should not use them to identify
the PHY. As usual for a datasheet, it gives no explanation why they
decided to break 802.3 Clause 22, but they have. So there is a
workaround for a couple of switches. See family_prod_id_table in
drivers/net/dsa/mv88e6xxx/chip.c

Under /sys/class/mdio_bus/ you should find all the PHYs and there is a
file phy_id. If it is 0, it has the above problem. Otherwise, you
might need to add the ID to drivers/net/phy/marvell.c.

You should be able to use mii-tool to dump the common PHY registers in
both your working and not working state and see if there is any
difference.

	Andrew
