Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F454EDC34
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 16:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237891AbiCaPAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiCaPAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:00:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB84BE0;
        Thu, 31 Mar 2022 07:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nBp5eWkwrHl+8YHShnyHosXN6OXlm06woH8IJnDuO9w=; b=LR3tOu62pKypx6dzcjTW5LVJlT
        oCJAftcP0t6++0kUcHvfuxZO1ykO4xQg5bsxryt1UZ63t+BsOyvqPH2YaFk8to9JQ7pvdCuVgEyMH
        3M1nbeYlRCzLjj/P7bFyj2i+3GPr42kAn7BBRSSGqPSyiUE7qFNDwDaPC7P9Zji0lBKjk9nsEcabK
        2qW1rNUCFYgOzwumswv7pxvb5zEloAvzgrQ63wRx5mCBZfzJhZQ5Zlh0lfqpC2wH91njmmWbxltyI
        2nONp06yKg+tfn7UB2l8h8EIh522kS9IGIxrz1NmbxFIfbKZ76Tswyt1nf835kgjoHjp4TKnHEhD6
        fuEPDffQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58066)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZwFW-0004zv-Lq; Thu, 31 Mar 2022 15:58:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZwFV-0007ie-AO; Thu, 31 Mar 2022 15:58:09 +0100
Date:   Thu, 31 Mar 2022 15:58:09 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Guenter Roeck <linux@roeck-us.net>, Xu Yilun <yilun.xu@intel.com>,
        David Laight <David.Laight@aculab.com>,
        Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Message-ID: <YkXBgTXRIFpE+YDL@shell.armlinux.org.uk>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <20220330065047.GA212503@yilunxu-OptiPlex-7050>
 <5029cf18c9df4fab96af13c857d2e0ef@AcuMS.aculab.com>
 <20220330145137.GA214615@yilunxu-OptiPlex-7050>
 <4973276f-ed1e-c4ed-18f9-e8078c13f81a@roeck-us.net>
 <YkW+kWXrkAttCbsm@shell.armlinux.org.uk>
 <7b3edeabb66e50825cc42ca1edf86bb7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b3edeabb66e50825cc42ca1edf86bb7@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 04:51:47PM +0200, Michael Walle wrote:
> Am 2022-03-31 16:45, schrieb Russell King (Oracle):
> > On Wed, Mar 30, 2022 at 08:23:35AM -0700, Guenter Roeck wrote:
> > > Michael, let's just drop the changes outside drivers/hwmon from
> > > the series, and let's keep hwmon_is_bad_char() in the include file.
> > > Let's just document it, explaining its use case.
> > 
> > Why? There hasn't been any objection to the change. All the discussion
> > seems to be around the new function (this patch) rather than the actual
> > conversions in drivers.
> > 
> > I'm entirely in favour of cleaning this up - it irks me that we're doing
> > exactly the same cleanup everywhere we have a hwmon.
> > 
> > At the very least, I would be completely in favour of keeping the
> > changes in the sfp and phy code.
> 
> FWIW, my plan was to send the hwmon patches first, by then my other
> series (the polynomial_calc() one) will also be ready to be picked.
> Then I'd ask Guenter for a stable branch with these two series which
> hopefully get merged into net-next. Then I can repost the missing
> patches on net-next along with the new sensors support for the GPY
> and LAN8814 PHYs.

Okay, that's fine. It just sounded like the conversion of other drivers
outside drivers/hwmon was being dropped.

Note that there's another "sanitisation" of hwmon names in
drivers/net/phy/marvell.c - that converts any non-alnum character to
an underscore. Not sure why the different approach was chosen there.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
