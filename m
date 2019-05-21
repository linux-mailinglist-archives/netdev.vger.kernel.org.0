Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E099524DCD
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 13:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfEULTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 07:19:21 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34948 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbfEULTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 07:19:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PewI+qr+FzkZGyMnmOEx8flWAwSCMRgcYSeVi2xaIu0=; b=JmHUemTbsJjHFKH8LAh6uuUcf
        kjfVVKy4nBa+JqUgvV6PFYa4Yisl8K0MmJJskQ7RKQecJ8rn8+dpwwYFb8MFq/c4aEqVANOP3gfsc
        H8IWtN2O42oN4dlFWvq/i+xnj8qV/QX6D97j3Px+BxsC69tHDvTm7vSfz+NBEWzB+gkKU3Add8TeC
        JNJd91u4/5akCxcEPwPxfxu8yhUlCyKksXJspBBlpBEojvwO7MvyNIV3DdoNTM6DUVwD5MfHMwzJ7
        zkoJMuXXCZbNp0VhPUZPSnEUmiW0aW7wDSlXEFmdRMYsIHNMnRtCrbWQMDyaq+BXRqijvP2KfgiAy
        wlbYEj96Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52562)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hT2nc-0000ih-Fb; Tue, 21 May 2019 12:19:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hT2nb-0005mq-KF; Tue, 21 May 2019 12:19:15 +0100
Date:   Tue, 21 May 2019 12:19:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Jo-Philipp Wich <jo@mein.io>,
        Network Development <netdev@vger.kernel.org>,
        John Crispin <john@phrozen.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, Jonas Gorski <jonas.gorski@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: ARM router NAT performance affected by random/unrelated commits
Message-ID: <20190521111915.3hklypo5pwi3fcgh@shell.armlinux.org.uk>
References: <9a9ba4c9-3cb7-eb64-4aac-d43b59224442@gmail.com>
 <20190521104512.2r67fydrgniwqaja@shell.armlinux.org.uk>
 <CACna6ryVxFr8ho3ekY4Q_J=TamVLv9ZMDaHJFUGcEGSRrSVaHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACna6ryVxFr8ho3ekY4Q_J=TamVLv9ZMDaHJFUGcEGSRrSVaHA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 01:16:12PM +0200, Rafał Miłecki wrote:
> On Tue, 21 May 2019 at 12:45, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > On Tue, May 21, 2019 at 12:28:48PM +0200, Rafał Miłecki wrote:
> > > I work on home routers based on Broadcom's Northstar SoCs. Those devices
> > > have ARM Cortex-A9 and most of them are dual-core.
> > >
> > > As for home routers, my main concern is network performance. That CPU
> > > isn't powerful enough to handle gigabit traffic so all kind of
> > > optimizations do matter. I noticed some unexpected changes in NAT
> > > performance when switching between kernels.
> > >
> > > My hardware is BCM47094 SoC (dual core ARM) with integrated network
> > > controller and external BCM53012 switch.
> >
> > Guessing, I'd say it's to do with the placement of code wrt cachelines.
> 
> That was my guess as well, that's why I tried "cachestat" tool.
> 
> 
> > You could try aligning some of the cache flushing code to a cache line
> > and see what effect that has.
> 
> Can you give me some extra hint on how to do that, please? I tried
> searching for it a bit but I didn't find any clear article on that
> matter.

IIRC, the cache line size on Cortex A9 is 32 bytes, so the assembler
directive would be ".align 5".  Place that in arch/arm/mm/cache-v7.S
before v7_dma_clean_range and v7_dma_inv_range.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
