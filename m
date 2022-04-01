Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B804EE898
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 08:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbiDAGov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 02:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343993AbiDAGnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 02:43:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7412195D97
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 23:40:13 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1naAx7-0000ea-3L; Fri, 01 Apr 2022 08:40:09 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1naAx4-0004ye-Vn; Fri, 01 Apr 2022 08:40:06 +0200
Date:   Fri, 1 Apr 2022 08:40:06 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "huangguangbin (A)" <huangguangbin2@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
Subject: Re: [PATCH] net: phy: genphy_loopback: fix loopback failed when
 speed is unknown
Message-ID: <20220401064006.GB4449@pengutronix.de>
References: <20220331114819.14929-1-huangguangbin2@huawei.com>
 <YkWdTpCsO8JhiSaT@lunn.ch>
 <130bb780-0dc1-3819-8f6d-f2daf4d9ece9@huawei.com>
 <YkW6J9rM6O/cb/lv@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YkW6J9rM6O/cb/lv@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:36:47 up 1 day, 19:06, 41 users,  load average: 0.05, 0.08, 0.07
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 04:26:47PM +0200, Andrew Lunn wrote:
> > In this case, as speed and duplex both are unknown, ctl is just set to 0x4000.
> > However, the follow code sets mask to ~0 for function phy_modify():
> > int genphy_loopback(struct phy_device *phydev, bool enable)
> > {
> > 	if (enable) {
> > 		...
> > 		phy_modify(phydev, MII_BMCR, ~0, ctl);
> > 		...
> > }
> > so all other bits of BMCR will be cleared and just set bit 14, I use phy trace to
> > prove that:
> > 
> > $ cat /sys/kernel/debug/tracing/trace
> > # tracer: nop
> > #
> > # entries-in-buffer/entries-written: 923/923   #P:128
> > #
> > #                                _-----=> irqs-off/BH-disabled
> > #                               / _----=> need-resched
> > #                              | / _---=> hardirq/softirq
> > #                              || / _--=> preempt-depth
> > #                              ||| / _-=> migrate-disable
> > #                              |||| /     delay
> > #           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
> > #              | |         |   |||||     |         |
> >   kworker/u257:2-694     [015] .....   209.263912: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
> >   kworker/u257:2-694     [015] .....   209.263951: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
> >   kworker/u257:2-694     [015] .....   209.263990: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
> >   kworker/u257:2-694     [015] .....   209.264028: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
> >   kworker/u257:2-694     [015] .....   209.264067: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0a val:0x0000
> >          ethtool-1148    [007] .....   209.665693: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
> >          ethtool-1148    [007] .....   209.665706: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1840
> >          ethtool-1148    [007] .....   210.588139: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1840
> >          ethtool-1148    [007] .....   210.588152: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1040
> >          ethtool-1148    [007] .....   210.615900: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
> >          ethtool-1148    [007] .....   210.615912: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x4000 //here just set bit 14
> > 
> > So phy speed will be set to 10M in this case, if previous speed of
> > device before going down is 10M, loopback test is pass. Only
> > previous speed is 100M or 1000M, loopback test is failed.
> 
> O.K. So it should be set into 10M half duplex. But why does this cause
> it not to loopback packets? Does the PHY you are using not actually
> support 10 Half? Why does it need to be the same speed as when the
> link was up? And why does it actually set LSTATUS indicating there is
> link?
> 
> Is this a generic problem, all PHYs are like this, or is this specific
> to the PHY you are using? Maybe this PHY needs its own loopback
> function because it does something odd?

It looks for me like attempt to fix loopback test for setup without active
link partner. Correct?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
