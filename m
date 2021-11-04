Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CAA445335
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 13:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhKDMnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 08:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhKDMng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 08:43:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF1AC061714;
        Thu,  4 Nov 2021 05:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fh++rMYaZW5HfrxGc65JC2BWo1i7rGUc1pnR4+Rq+Fk=; b=qUETNn/cBUrLi0s+F5DtUcYwnv
        RoxoMxYvfqBw3uOm5h//UFmJf2Q8un0j4yLrSe05KFKPpqbQekrREXCpNfmFl9knyTE7UmiK3ff/A
        S2ru+o6R+Lk8WgnMe4OKXzXKf1Jqq5MUPmP69eAh1HiR3+rDfZC+ExmUiGiS9oxNsx93opgCD3Oxk
        1fcLRXu7couVF/e8sHAO+34bpSvZKPkprQEcQcv7r6V9Fk3emvtZzy340fJ/iVgz9yhinWDqg9daq
        BQ3IB7Xtrqt5gC48umsDVaJx6rVXk+ITqgEEzHOzFApdUVOcT3p0jLaVyvGvMGyN4GxJrx8zEYZsy
        xg1hp3AQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55480)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mic35-0005xh-OE; Thu, 04 Nov 2021 12:40:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mic34-0007LK-FD; Thu, 04 Nov 2021 12:40:54 +0000
Date:   Thu, 4 Nov 2021 12:40:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYPU1gOvUPa00JWg@shell.armlinux.org.uk>
References: <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
 <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
 <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com>
 <YYGxvomL/0tiPzvV@lunn.ch>
 <8d24c421-064c-9fee-577a-cbbf089cdf33@ti.com>
 <YYHXcyCOPiUkk8Tz@lunn.ch>
 <01a0ebf9-5d3f-e886-4072-acb9bf418b12@ti.com>
 <YYLk0dEKX2Jlq0Se@lunn.ch>
 <87pmrgjhk4.fsf@waldekranz.com>
 <YYPThd7aX+TBWslz@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYPThd7aX+TBWslz@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 12:35:17PM +0000, Russell King (Oracle) wrote:
> On Thu, Nov 04, 2021 at 12:17:47PM +0100, Tobias Waldekranz wrote:
> > Except that there is a way: https://github.com/wkz/mdio-tools
> 
> I'm guessing that this hasn't had much in the way of review, as it has
> a nice exploitable bug - you really want "pc" to be unsigned in
> mdio_nl_eval(), otherwise one can write a branch instruction that makes
> "pc" negative.
> 
> Also it looks like one can easily exploit this to trigger any of your
> BUG_ON()/BUG() statements, thereby crashing while holding the MDIO bus
> lock causing a denial of service attack.
> 
> I also see nothing that protects against any user on a system being
> able to use this interface, so the exploits above can be triggered by
> any user. Moreover, this lack of protection means any user on the
> system can use this interface to write to a PHY.
> 
> Given that some PHYs today contain firmware, this gives anyone access
> to reprogram the PHY firmware, possibly introducing malicious firmware.
> 
> I hope no one is using this module in a production environment.

It also leaks the reference count on the MDIO bus class device.
mdio_find_bus(), rather class_find_device_by_name() takes a reference
on the struct device that you never drop. See the documentation for
class_find_device() for the statement about this:

 * Note, you will need to drop the reference with put_device() after use.

Of course, mdio_find_bus() documentation should _really_ have mentioned
this fact too.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
