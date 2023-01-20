Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D13A67616E
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 00:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjATXUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 18:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjATXUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 18:20:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E144216;
        Fri, 20 Jan 2023 15:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=u8jiZcqJPAm+/Dg5Mao/7VAzjkBNlmo6cpwAQBGJzPU=; b=MqQeq26jMORty1lHsiQ4AhqarQ
        QEskS9k2dgen1Bk/+/QTp90xWA6iERSjCJ2uZiW4y18chQhIigRCP6Vj8mpgOApfaSqBvbMnQaSrf
        dBNfEFHuFMQAk2wCEWncz/G4SHVBxmyQfPgK3TWiPJ1zR8oNv8e1+KZ7TKROkkEq9gUZ4pTYnOz/0
        /u4ilfJ/feK6L4n2VU5kY36h8q4penuhcvKfYJRPLMhMZHYe9427lEczEzCRS5aRMBkb+v7kjtpGo
        lwvaXcbC9yItTV1TbnJzdP2XSvl/lKe9Uk9v2qA+A/5YmtCcgNNI9Lbu/fyMhJMEpSfqzJDl7ZytI
        3PugkzJQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36238)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pJ0gG-00083t-1v; Fri, 20 Jan 2023 23:20:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pJ0gA-0001qW-Eo; Fri, 20 Jan 2023 23:20:14 +0000
Date:   Fri, 20 Jan 2023 23:20:14 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] phy: net: introduce phy_promote_to_c45()
Message-ID: <Y8shrgmEoznYsol7@shell.armlinux.org.uk>
References: <20230120224011.796097-1-michael@walle.cc>
 <20230120224011.796097-5-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120224011.796097-5-michael@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 11:40:10PM +0100, Michael Walle wrote:
> If not explitly asked to be probed as a C45 PHY, on a bus which is
> capable of doing both C22 and C45 transfers, C45 PHYs are first tried to
> be probed as C22 PHYs. To be able to promote the PHY to be a C45 one,
> the driver can call phy_promote_to_c45() in its probe function.
> 
> This was already done in the mxl-gpy driver by the following snippet:
> 
>    if (!phydev->has_c45) {
>            ret = phy_get_c45_ids(phydev);
>            if (ret < 0)
>                    return ret;
>    }
> 
> Move that code into the core by creating a new function
> phy_promote_to_c45(). If a PHY is promoted, C45-over-C22 access is used,
> regardless if the bus supports C45 or not. That is because there might
> be C22 PHYs on the bus which gets confused by C45 accesses.

It is my understanding that C45 PHYs do not have to respond to C22
accesses. So, wouldn't this lead to some C45 PHYs not being detected?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
