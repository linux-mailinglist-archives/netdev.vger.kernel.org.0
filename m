Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A950496E19
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 22:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiAVVSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 16:18:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49048 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230339AbiAVVSw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jan 2022 16:18:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EILhThOZz6AMIrApvuxhh7LQsxC+OdGSS/Ijnj3VP0U=; b=czU7ZQLFY1/OHBtJ3uZuH0jVhQ
        x96bcmr5U1aRSCAN/9mMvscMKWMSP9bgXSOxU/0h5ho22cVjiX5IKtPW2rUCjFtDFuD2B1ubFvhlJ
        SkJqPcOf2PM4AwW7IcDUeFduxquF4i/Gyrqj4CIR6ABtVJmxny0tmtk3Hgw1KBFsuylA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBNmP-002KKW-Jz; Sat, 22 Jan 2022 22:18:37 +0100
Date:   Sat, 22 Jan 2022 22:18:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <Yex0rZ0wRWQH/L4n@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <YelxMFOiqnfIVmyy@lunn.ch>
 <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
 <Yeqzhx3GbMzaIbj6@lunn.ch>
 <CAAd53p5pF+SRfwGfJaBTPkH7+9Z6vhPHcuk-c=w8aPTzMBxPcg@mail.gmail.com>
 <YerOIXi7afbH/3QJ@lunn.ch>
 <3d7b1ff0-6776-6480-ed20-c9ad61b400f7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d7b1ff0-6776-6480-ed20-c9ad61b400f7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> One more idea:
> The hw reset default for register 16 is 0x101e. If the current value
> is different when entering config_init then we could preserve it
> because intentionally a specific value has been set.
> Only if we find the hw reset default we'd set the values according
> to the current code.

We can split the problem into two.

1) I think saving LED configuration over suspend/resume is not an
issue. It is probably something we will be needed if we ever get PHY
LED configuration via sys/class/leds.

2) Knowing something else has configured the LEDs and the Linux driver
should not touch it. In general, Linux tries not to trust the
bootloader, because experience has shown bad things can happen when
you do. We cannot tell if the LED configuration is different to
defaults because something has deliberately set it, or it is just
messed up, maybe from the previous boot/kexec, maybe by the
bootloader. Even this Dell system BIOS gets it wrong, it configures
the LED on power on, but not resume !?!?!. And what about reboot?

So i really would like the bootloader to explicitly say it has
configured the LEDs and it takes full responsibility for any and all
bad behaviour as a result.

	  Andrew
