Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A2449C012
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbiAZAU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:20:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57344 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiAZAU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:20:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAF3BB81B22
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 00:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F76DC340E0;
        Wed, 26 Jan 2022 00:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643156454;
        bh=8ZUakoyefi7oZehh5gog3LyYAQ9GCAe2DgAB4GZ1QEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DzwRfL0xca8Irih1A759OyuQOFqEJ6KBfMSAPDJcahHNGlz6yrD658Rske9idms4J
         iOSpfFWCIcBA6+XtXhHgy/iu3dMheTUeUok9/0LVNhjTMJ/ptOI5MMbY/dEBC3Oquq
         AYjq8emtzv/aMTsuVsu01SBdAyGQMGUOzb+3GaMT6rgJMkGvVOgc4ImGehJAHL1x8M
         Ur5kcMMuY0B4SG3sj2pLXm3MdoE3iefxb2XOzVQT1W0IIfpkatih7EUAondG5N0zwI
         iRBRwH50mjF3SX1DSKbcEgOSTvKGt23oEFXNdTegStlfyw8QDU+CH5Mvzk7r5L1E2S
         qMPMyW1CnU5Ew==
Date:   Tue, 25 Jan 2022 16:20:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, dave@thedillows.org
Subject: Re: [PATCH net 0/3] ethernet: fix some esoteric drivers after
 netdev->dev_addr constification
Message-ID: <20220125162053.6d82aa8f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAK8P3a2NOr2tGLkf-4uBx4t6zqqZsobY-79nqaeQ-pUC2h5Kvg@mail.gmail.com>
References: <20220125222317.1307561-1-kuba@kernel.org>
        <20220125142818.16fe1e11@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAK8P3a2NOr2tGLkf-4uBx4t6zqqZsobY-79nqaeQ-pUC2h5Kvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 00:59:47 +0100 Arnd Bergmann wrote:
> > Hi Arnd, there's another case in drivers/net/ethernet/i825xx/ether1.c
> > which will be broken in 5.17, it looks like only RiscPC includes that.
> > But when I do:
> >
> > make ARCH=arm CROSS_COMPILE=$cross/arm-linux-gnueabi/bin/arm-linux-gnueabi- O=build_tmp/ rpc_defconfig
> >
> > The resulting config is not for ARCH_RPC:
> >
> > $ grep ARM_ETHER1 build_tmp/.config
> > $ grep RPC build_tmp/.config
> > # CONFIG_AF_RXRPC is not set
> > CONFIG_SUNRPC=y
> > # CONFIG_SUNRPC_DEBUG is not set
> > CONFIG_XZ_DEC_POWERPC=y
> > $ grep ACORN build_tmp/.config
> > # CONFIG_ACORN_PARTITION is not set
> > CONFIG_FONT_ACORN_8x8=y
> >
> > Is there an extra smidgen of magic I need to produce a working config
> > here?  Is RPC dead and can we send it off to Valhalla?  
> 
> Support for ARMv3 was removed in gcc-9, so there is a Kconfig
> dependency on the compiler version to prevent broken builds.
> You can use the gcc-8 builds from kernel.org[1].

That worked! Thank you!

> Russell still uses this machine with an older compiler though, and
> I guess he will keep using newer kernels for as long as gcc-8 can
> build them.
> 
> No idea which ethernet card he uses, there are at least three of them.
> 
> [1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/8.5.0/x86_64-gcc-8.5.0-nolibc-arm-linux-gnueabi.tar.gz

If there are 3 I broke the build for all of them, it seems :)
I'll send the fixes shortly.
