Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B205FE4F4
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 00:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiJMWGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 18:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiJMWGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 18:06:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEE3182C7C;
        Thu, 13 Oct 2022 15:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eJABByniC+waYLoXVO+y5XUU6JZxKXZIhKhc7uBYeVM=; b=gjb8rNvdSDfjl3I2cr0Ibx3l4I
        l4uzJ1CEmaZ/wOQ3W4k/vV9ygnMPVWpEk6VedTzLBYlnQfqkVF0dwJJaXH7CaZR4Jl9PB8gz8V8VX
        rvWPmFyYdzwk1TFeT0at2YZ5MYwsIVJbTbG8M2fTDYAnvckknofL4LnaoZKj2eDcypa0jhDGvg2b8
        V2pUu45SDsL9mYyzp4+LSP/fH6XDw8cc7jat2iJDjQWzpSPJCrxRAr4MQCnr5zRwKIt86TtooeBdB
        V/FWEGAkZIbgYT6kqfMXBL6C8M6EuYWmS+dPbL4QMIbTb6nwNnXqUlIV9UxFtobLtufGkftaOYeD4
        10lblJnA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34712)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oj6Lg-0000I2-Qs; Thu, 13 Oct 2022 23:06:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oj6Le-000560-HS; Thu, 13 Oct 2022 23:06:38 +0100
Date:   Thu, 13 Oct 2022 23:06:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 52/77] net: sfp: re-implement soft state
 polling setup
Message-ID: <Y0iL7jwWJMQ870Of@shell.armlinux.org.uk>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-52-sashal@kernel.org>
 <Y0PH5fFyViE2qrrG@shell.armlinux.org.uk>
 <Y0hSivQqzGb3hAl3@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0hSivQqzGb3hAl3@sashalap>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 02:01:46PM -0400, Sasha Levin wrote:
> On Mon, Oct 10, 2022 at 08:21:09AM +0100, Russell King (Oracle) wrote:
> > On Sun, Oct 09, 2022 at 06:07:29PM -0400, Sasha Levin wrote:
> > > From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> > > 
> > > [ Upstream commit 8475c4b70b040f9d8cbc308100f2c4d865f810b3 ]
> > > 
> > > Re-implement the decision making for soft state polling. Instead of
> > > generating the soft state mask in sfp_soft_start_poll() by looking at
> > > which GPIOs are available, record their availability in
> > > sfp_sm_mod_probe() in sfp->state_hw_mask.
> > > 
> > > This will then allow us to clear bits in sfp->state_hw_mask in module
> > > specific quirks when the hardware signals should not be used, thereby
> > > allowing us to switch to using the software state polling.
> > 
> > NAK.
> > 
> > There is absolutely no point in stable picking up this commit. On its
> > own, it doesn't do anything beneficial. It isn't a fix for anything.
> > It isn't stable material.
> > 
> > If you picked up the next two patches in the series, there would be a
> > point to it - introducing support for the HALNy GPON SFP module, but
> > as you didn't these three patches on their own are entirely pointless.
> 
> So why not tag those patches for stable to make it explicit?

Oh, is stable accepting development changes then?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
