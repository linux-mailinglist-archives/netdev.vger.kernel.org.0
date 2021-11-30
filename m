Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DABD46333C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241430AbhK3Lu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241287AbhK3Lu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:50:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231E7C061763;
        Tue, 30 Nov 2021 03:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZHmEYF4LZeF4drtWTO7d/7EufUy+uE8BPoSmH0E4R64=; b=Jhj9YSp2RJQcU2ECFjWZaMYhua
        JUhlttpK8G8pMJvU0PVvvVKhg/RJwZaqUBg77r+n7xCEgflF91GNrnigEJu2nklPDmHtU+WrhsPPR
        wTHs3GOgl/zjGAZtdODWlPh+wR9W14vDejxNFwedsM6B7Zm2fTtMGROQWRb2idvl+HvV1it/r06sq
        RUi+mt/P4jkCqz05xpQLiMqwYhbMPjsFcuwv32qRNgEmDDmyEu0DcrB9oKZi0MC0phS3046LjgYMZ
        rd6n/8gaEAT8LcwTWDjHnFAkE5JpGaXL9rTDzU3/oPCc2zf6E1qnIN49BMr8ytt9pLXh052h7pQ8E
        UEBXry5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55976)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ms1bA-0006nS-LC; Tue, 30 Nov 2021 11:47:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ms1b6-000719-Mn; Tue, 30 Nov 2021 11:46:56 +0000
Date:   Tue, 30 Nov 2021 11:46:56 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Yinbo Zhu <zhuyinbo@loongson.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk>
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 11:21:03AM +0100, Heiner Kallweit wrote:
> On 26.11.2021 10:45, Yinbo Zhu wrote:
> > After module compilation, module alias mechanism will generate a ugly
> > mdio modules alias configure if ethernet phy was selected, this patch
> > is to fixup mdio alias garbled code.
> > 
> > In addition, that ugly alias configure will cause ethernet phy module
> > doens't match udev, phy module auto-load is fail, but add this patch
> > that it is well mdio driver alias configure match phy device uevent.
> > 
> I think Andrew asked you for an example already.
> For which PHY's the driver isn't auto-loaded?
> 
> In addition your commit descriptions are hard to read, especially the
> one for patch 2. Could you please try to change them to proper English?
> Not being a native speaker myself ..

Let's clear this up. PHY module loading is quite different - it does
_not_ use MODALIAS nor does it use the usual udev approach.

The modalias strings use aliases of the form "mdio:<semi-binary-string>"
with "?" used as a wildcard for each bit not in the mask. This is an
entirely appropriate scheme to use, as it allows matching an ID with
an arbitary mask. There is nothing wrong with this format - it may be
a bit on the long side, but it is an entirely valid solution.

The kernel has never generated a MODALIAS of this form, which is fine,
because we don't use MODALIAS or the uevent/udev approach to loading
the modules.

We instead use phy_request_driver_module() at PHY device creation time
to explicitly request modprobe to load a module of the form
"mdio:<binary-id>" which we know works (I have had the marvell10g and
bcm84881 modules autoloaded as a result of inserting SFPs.)

However, this won't work for PHY devices created _before_ the kernel
has mounted the rootfs, whether or not they end up being used. So,
every PHY mentioned in DT will be created before the rootfs is mounted,
and none of these PHYs will have their modules loaded.

I believe this is the root cause of Yinbo Zhu's issue.

However, changing the modalias format that we use is not a solution -
it _will_ cause DSA module loading to break. We've been here with the
SPI subsystem, where a patch was merged to change the modalias format
allegedly to fix loading of one or two modules, resulting in the
spi-nor driver failing to load (as it had done for years) - and the
resulting change was reverted and the revert backported to all the
stable trees. It created quite a mess. Linus has always been very clear
that if fixing one issue causes regressions, then the fix is wrong and
needs to be reverted. This is exactly what happened in the case of SPI.

This teaches us a lesson: changes to any modalias scheme that has been
in use for years need _extremely_ careful consideration and thorough
testing as they risk causing regressions. Without that, such changes
can result in difficult decisions where no matter what decision is
made, some breakage occurs as a result of sorting out the resulting
mess from not having considered the change carefully enough. It is far
better to avoid boxing oneself into a corner.

We can see that Yinbo Zhu's changes to fix his issue will cause
regressions with DSA, so it is simply an unacceptable fix. Reposting
the same code will _never_ change that fact. So please, Yinbo Zhu, stop
reposting your change. It is provably regression-creating and as such
will never be accepted. You also seem to be resistant to feedback -
I've asked you to separate out the "mdio_bus" change but you still have
not in your version 3 posted today. Therefore, I will assume that you
won't read this email, and in future if I see those patches again, I
will reply with a one-line "NAK" and a reference to this email.

We instead need a different approach to solving this issue. What that
approach is, I'm not sure right now - the tooling is setup to only
permit one MODALIAS published by the kernel, so we can't publish both
a DT based modalias and a mdio: based modalias together. It's one or
the other.

What we _could_ do is review all device trees and PHY drivers to see
whether DT modaliases are ever used for module loading. If they aren't,
then we _could_ make the modalias published by the kernel conditional
on the type of mdio device - continue with the DT approach for non-PHY
devices, and switch to the mdio: scheme for PHY devices. I repeat, this
can only happen if no PHY drivers match using the DT scheme, otherwise
making this change _will_ cause a regression.

The alternative is we simply declare that udev based module auto-loading
of PHY drivers required for PHYs in DT is simply not supported, and is
something we are unable to support. For something like root-NFS or IP
autoconfiguration by the kernel, that is already the case - the PHY
driver modules _must_ be built-in to the kernel in just the same way as
the network driver modules must be.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
