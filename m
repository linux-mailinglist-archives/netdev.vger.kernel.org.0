Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D093B4F909A
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiDHIUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiDHIUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:20:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860747C7B1
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:18:38 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ncjp5-0001Q8-SX; Fri, 08 Apr 2022 10:18:27 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ncjp2-0002vy-IV; Fri, 08 Apr 2022 10:18:24 +0200
Date:   Fri, 8 Apr 2022 10:18:24 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "huangguangbin (A)" <huangguangbin2@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
Subject: Re: [PATCH] net: phy: genphy_loopback: fix loopback failed when
 speed is unknown
Message-ID: <20220408081824.GF25348@pengutronix.de>
References: <20220331114819.14929-1-huangguangbin2@huawei.com>
 <YkWdTpCsO8JhiSaT@lunn.ch>
 <130bb780-0dc1-3819-8f6d-f2daf4d9ece9@huawei.com>
 <YkW6J9rM6O/cb/lv@lunn.ch>
 <20220401064006.GB4449@pengutronix.de>
 <YkbsraBQ5ynYG9wz@lunn.ch>
 <d42ae21a-6136-5340-6851-e3108759937a@huawei.com>
 <Yk7475EJ622D1Ty/@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yk7475EJ622D1Ty/@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:16:38 up 8 days, 20:46, 67 users,  load average: 0.19, 0.26, 0.25
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 04:45:03PM +0200, Andrew Lunn wrote:
> > Hi Andrew,
> > The PHY we test is RTL8211F, it supports 10 half. This problem actually is,
> > our board has MAC connected with PHY, when loopback test, packet flow is
> > MAC->PHY->MAC, it needs speed of MAC and PHY should be same when they work.
> > 
> > If PHY speed is unknown when PHY goes down, we will not set MAC speed in
> > adjust_link interface. In this case, we hope that PHY speed should not be
> > changed, as the old code of function genphy_loopback() before patch
> > "net: phy: genphy_loopback: add link speed configuration".
> > 
> > If PHY has never link, MAC speed has never be set in adjust_link interface,
> > yeah, in this case, MAC and PHY may has different speed, and they can not work.
> > I think we can accept this situation.
> > 
> > I think it is general problem if there is MAC connected with PHY.
> 
> Thanks for investigating. Looks like we are getting close the real
> solution. And it is a generic problem, that the MAC and PHY might not
> be using the same configuration.
> 
> So it looks like if the link is down, or speed is UNKNOWN, we need to
> set phydev->link true, speed 10, duplex half...

Hm, i was thinking, is it impossible to run loopback test on half duplex link.
Do I missing something?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
