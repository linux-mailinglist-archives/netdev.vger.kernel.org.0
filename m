Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769144AC8A5
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243361AbiBGSf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbiBGSdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:33:25 -0500
Received: from mail.baikalelectronics.ru (mail.baikalelectronics.com [87.245.175.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9996C0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 10:33:24 -0800 (PST)
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id B60D68030799;
        Mon,  7 Feb 2022 21:33:22 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru B60D68030799
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1644258803;
        bh=MgYjuciirHTrL0hJS9JIhfcZ6DKQUKNmm0Q3nk5w8Qw=;
        h=Date:From:To:CC:Subject:References:In-Reply-To:From;
        b=DwfhbqZv8gG9yvfcIVDEObThk9fkNS4/n2FWmjoMC0OZsr9eGo/J8AKAZ+nJWcVJr
         gzfFu6F8CJ7u+oXXfxK76EX74MTK9i+tVaDnhoIfE4oL/Iy/Jo+UyLa4bWBgXG367d
         +bbUefe/FXo5cYSd0IjDf+Evdf2GVLtZPCb+pZEo=
Received: from mobilestation (192.168.152.164) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 7 Feb 2022 21:32:59 +0300
Date:   Mon, 7 Feb 2022 21:33:19 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        <stable@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] net: phy: marvell: Fix RGMII Tx/Rx delays setting
 in 88e1121-compatible PHYs
Message-ID: <20220207183319.ls2rz4k6m7tgbqlg@mobilestation>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
 <20220205203932.26899-1-Pavel.Parkhomenko@baikalelectronics.ru>
 <20220207094039.6a2b34df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220207094039.6a2b34df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub

On Mon, Feb 07, 2022 at 09:40:39AM -0800, Jakub Kicinski wrote:
> On Sat, 5 Feb 2022 23:39:32 +0300 Pavel Parkhomenko wrote:
> > It is mandatory for a software to issue a reset upon modifying RGMII
> > Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
> > Specific Control register 2 (page 2, register 21) otherwise the changes
> > won't be perceived by the PHY (the same is applicable for a lot of other
> > registers). Not setting the RGMII delays on the platforms that imply it'
> > being done on the PHY side will consequently cause the traffic loss. We
> > discovered that the denoted soft-reset is missing in the
> > m88e1121_config_aneg() method for the case if the RGMII delays are
> > modified but the MDIx polarity isn't changed or the auto-negotiation is
> > left enabled, thus causing the traffic loss on our platform with Marvell
> > Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
> > delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
> > method.
> > 
> > Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
> > Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
> > Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
> > Cc: stable@vger.kernel.org
> > 
> > ---
> > 
> > Link: https://lore.kernel.org/netdev/96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru/
> > Changelog v2:
> > - Add "net" suffix into the PATCH-clause of the subject.
> > - Cc the patch to the stable tree list.
> > - Rebase onto the latset netdev/net branch with the top commit 59085208e4a2
> > ("net: mscc: ocelot: fix all IP traffic getting trapped to CPU with PTP over IP")
> 

> This patch is valid and waiting to be reviewed & applied, right?

Right.

> I see it's marked as Superseded in patchwork, but can't track down a v3.

We had accidentally sent out a temporal v2 version before submitting this
one. The failed patch is here
Link: https://lore.kernel.org/stable/20220205190814.20282-1-Pavel.Parkhomenko@baikalelectronics.ru/
But the message was sent to Russel and to the stable mailing list only
with no netdev list being in Cc. I thought if the right v2 was sent
out after the failed one, then even if patchwork somehow gets to catch
both of the messages, the former patch would have at least superseded
the later one. It appears I was wrong. Sorry about that. Do you want
us to resend this patch as v3 to have a proper patchwork status?

-Sergey
