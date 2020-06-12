Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5931F784C
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 15:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgFLNDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 09:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgFLNC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 09:02:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F763C08C5C4;
        Fri, 12 Jun 2020 06:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vsxp9JNvCK18l+tV3gNRWP2u3sQm4l/mdly+3hiosMI=; b=d/oNgM1p6tV5lxylNorywp80i
        leauM1cRa5Q8CJp9HmmXeZFh9lmVLYOW+1h7ZwyWLyll9ilosGXMjFpEPWq153Lqhta7npu+8ZSaF
        Q7OJUH1SUj5parRabUNSp8TMzsc9ntRv02rX7hxg0ruafXU3rSBy4g/cjF77siiguRQ67Vn0kKawL
        NXMoWTvSTj/nMS/TCw0rWb0gMWL0XRZkzo+oN+TftRrOb5KdaPveBfu7imSVrqzcuN4CqR12aEmEq
        c1G8c8TYnTVJU1WBMewsDbxuofbhMJO5vhBE4ox9dC2UZFpYR4w71DaBg/0M8iNvwWtp7JMZ3ctMe
        vXXfHv63g==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43538)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jjjKe-0002tP-1z; Fri, 12 Jun 2020 14:02:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jjjKc-0006Hb-SO; Fri, 12 Jun 2020 14:02:50 +0100
Date:   Fri, 12 Jun 2020 14:02:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] net: mvneta: Fix Serdes configuration for 2.5Gbps
 modes
Message-ID: <20200612130250.GK1551@shell.armlinux.org.uk>
References: <20200612083847.29942-1-s.hauer@pengutronix.de>
 <20200612084710.GC1551@shell.armlinux.org.uk>
 <20200612100114.GE1551@shell.armlinux.org.uk>
 <20200612101820.GF1551@shell.armlinux.org.uk>
 <20200612104208.GG1551@shell.armlinux.org.uk>
 <20200612112213.GH1551@shell.armlinux.org.uk>
 <20200612113031.GI1551@shell.armlinux.org.uk>
 <20200612115250.GS11869@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612115250.GS11869@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 01:52:50PM +0200, Sascha Hauer wrote:
> On Fri, Jun 12, 2020 at 12:30:31PM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Jun 12, 2020 at 12:22:13PM +0100, Russell King - ARM Linux admin wrote:
> > > On Fri, Jun 12, 2020 at 11:42:08AM +0100, Russell King - ARM Linux admin wrote:
> > > > With the obvious mistakes fixed (extraneous 'i' and lack of default
> > > > case), it seems to still work on Armada 388 Clearfog Pro with 2.5G
> > > > modules.
> > > 
> > > ... and the other bug fixed - mvneta_comphy_init() needs to be passed
> > > the interface mode.
> > 
> > Unrelated to the patch, has anyone noticed that mvneta's performance
> > seems to have reduced?  I've only just noticed it (which makes 2.5Gbps
> > rather pointless).  This is iperf between two clearfogs with a 2.5G
> > fibre link:
> > 
> > root@clearfog21:~# iperf -V -c fe80::250:43ff:fe02:303%eno2
> > ------------------------------------------------------------
> > Client connecting to fe80::250:43ff:fe02:303%eno2, TCP port 5001
> > TCP window size: 43.8 KByte (default)
> > ------------------------------------------------------------
> > [  3] local fe80::250:43ff:fe21:203 port 48928 connected with fe80::250:43ff:fe02:303 port 5001
> > [ ID] Interval       Transfer     Bandwidth
> > [  3]  0.0-10.0 sec   553 MBytes   464 Mbits/sec
> > 
> > I checked with Jon Nettleton, and he confirms my recollection that
> > mvneta on Armada 388 used to be able to fill a 2.5Gbps link.
> > 
> > If Armada 388 can't manage, then I suspect Armada XP will have worse
> > performance being an earlier revision SoC.
> 
> I only have one board with a Armada XP here which has a loopback cable
> between two ports. It gives me:
> 
> [  3] local 172.16.1.4 port 47002 connected with 172.16.1.0 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  1.27 GBytes  1.09 Gbits/sec
> 
> Still not 2.5Gbps, but at least twice the data rate you get, plus my
> board has to handle both ends of the link.

It turns out I still had various locking debugs and DMA API debug
enabled:

[  3] local fe80::250:43ff:fe21:203 port 39326 connected with fe80::250:43ff:fe02:303 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  2.70 GBytes  2.32 Gbits/sec

... which is more like it for this platform!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
