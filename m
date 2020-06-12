Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5153C1F7784
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 13:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgFLLw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 07:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgFLLw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 07:52:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BF0C03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 04:52:55 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jjiEt-0001TX-HX; Fri, 12 Jun 2020 13:52:51 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jjiEs-0008JZ-6d; Fri, 12 Jun 2020 13:52:50 +0200
Date:   Fri, 12 Jun 2020 13:52:50 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] net: mvneta: Fix Serdes configuration for 2.5Gbps
 modes
Message-ID: <20200612115250.GS11869@pengutronix.de>
References: <20200612083847.29942-1-s.hauer@pengutronix.de>
 <20200612084710.GC1551@shell.armlinux.org.uk>
 <20200612100114.GE1551@shell.armlinux.org.uk>
 <20200612101820.GF1551@shell.armlinux.org.uk>
 <20200612104208.GG1551@shell.armlinux.org.uk>
 <20200612112213.GH1551@shell.armlinux.org.uk>
 <20200612113031.GI1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612113031.GI1551@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:42:38 up 113 days, 19:13, 128 users,  load average: 0.04, 0.14,
 0.15
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 12:30:31PM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Jun 12, 2020 at 12:22:13PM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Jun 12, 2020 at 11:42:08AM +0100, Russell King - ARM Linux admin wrote:
> > > With the obvious mistakes fixed (extraneous 'i' and lack of default
> > > case), it seems to still work on Armada 388 Clearfog Pro with 2.5G
> > > modules.
> > 
> > ... and the other bug fixed - mvneta_comphy_init() needs to be passed
> > the interface mode.
> 
> Unrelated to the patch, has anyone noticed that mvneta's performance
> seems to have reduced?  I've only just noticed it (which makes 2.5Gbps
> rather pointless).  This is iperf between two clearfogs with a 2.5G
> fibre link:
> 
> root@clearfog21:~# iperf -V -c fe80::250:43ff:fe02:303%eno2
> ------------------------------------------------------------
> Client connecting to fe80::250:43ff:fe02:303%eno2, TCP port 5001
> TCP window size: 43.8 KByte (default)
> ------------------------------------------------------------
> [  3] local fe80::250:43ff:fe21:203 port 48928 connected with fe80::250:43ff:fe02:303 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec   553 MBytes   464 Mbits/sec
> 
> I checked with Jon Nettleton, and he confirms my recollection that
> mvneta on Armada 388 used to be able to fill a 2.5Gbps link.
> 
> If Armada 388 can't manage, then I suspect Armada XP will have worse
> performance being an earlier revision SoC.

I only have one board with a Armada XP here which has a loopback cable
between two ports. It gives me:

[  3] local 172.16.1.4 port 47002 connected with 172.16.1.0 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.27 GBytes  1.09 Gbits/sec

Still not 2.5Gbps, but at least twice the data rate you get, plus my
board has to handle both ends of the link.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
