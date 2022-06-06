Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9371453E886
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbiFFMn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 08:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237569AbiFFMn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 08:43:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7135C2CBD2D;
        Mon,  6 Jun 2022 05:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S17W/Pm9YVh/HqKMgj1KO/HjHX9HcDXOf/ffbUmqK5A=; b=JQGlU/poW50DIvWBX4d2F5pO8Q
        e1ogrNiB9rn2MCX3s6dmk7hshynvkKeM0faugenizIbvxnGl1cG24z9+v+p+aj0Hfgx94Oh6K7kW2
        G4gcHmYRcw11ZAUPDQFGHT28a7mGox27tNRn60+UBZQkwyxn3eOPfb9FvgnAU34anaLg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nyC4O-005mXJ-7M; Mon, 06 Jun 2022 14:42:56 +0200
Date:   Mon, 6 Jun 2022 14:42:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dan Murphy <dmurphy@ti.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net-next v2 1/1] net: phy: dp83867: retrigger SGMII AN
 when link change
Message-ID: <Yp32UDf7JO2pHE8z@lunn.ch>
References: <20220526090347.128742-1-tee.min.tan@linux.intel.com>
 <Yo9zTmMduwel8XeZ@lunn.ch>
 <20220527014709.GA26992@linux.intel.com>
 <YpDHWMe7aEVWtECd@lunn.ch>
 <20220530073356.GA1199@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530073356.GA1199@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Below is the HW structure for Intel mGbE controller with external PHY.
> The SERDES is located in the PHY IF in the diagram below and the EQoS
> MAC uses pcs-xpcs driver for SGMII interface.
> 
>     <-----------------GBE Controller---------->|<---External PHY chip--->
>     +----------+         +----+            +---+           +------------+
>     |   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> |External PHY|
>     |   MAC    |         |xPCS|            |IF |           |(TI DP83867)|
>     +----------+         +----+            +---+           +------------+
>            ^               ^                 ^                ^
>            |               |                 |                |
>            +---------------------MDIO-------------------------+
> 
> There are registers in the DW XPCS to read the SGMII AN status and
> it's showing the SGMII AN has not completed and link status is down.
> But TI PHY is showing SGMII AN is completed and the copper link is
> established.
> 
> FYI, the current pcs-xpcs driver is configuring C37 SGMII as MAC-side
> SGMII, so it's expecting to receive AN Tx Config from PHY about the
> link state change after C28 AN is completed between PHY and Link Partner.
> Here is the pcs-xpcs code for your reference:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/pcs/pcs-xpcs.c#L725
> 
> We faced a similar issue on MaxLinear GPY PHY in the past.
> And, MaxLinear folks admitted the issue and implemented fixes/improvements
> in the GPY PHY Firmware to overcome the SGMII AN issue.
> Besides, they have also implemented this similar SW Workaround in their
> PHY driver code to cater for the old Firmware.
> Feel free to refer GPY driver code here:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/mxl-gpy.c#L222
> 
> Apart from TI and MaxLinear PHY, we've also tested the Marvell 88E2110 and
> 88E1512 PHY with the MAC/SERDES combination above, Marvell PHY is working
> fine without any issue.

Thanks for the additional details.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
