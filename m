Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C84F9652
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 15:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiDHNGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 09:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiDHNGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 09:06:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC09344FEA;
        Fri,  8 Apr 2022 06:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v16RxxaOxOZqHPVqyXeuMbn/xFT7DRq6k8ReY5NAjLc=; b=Dxi5elEVble7hCqrLhqht5VQBD
        ZzR3h8pg+jA79dfvgiHHELgWUpgeImkQA1QfjNq1mr7Py5wKydXwWgutJh7hQQOFWTndwISM6+znv
        /Dp28dN/sszBvuZdBe2AasoDOGIwPxC8Kw1JFsoTOjNeCzBigZtrcTkQaNk0U66AohWI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncoHo-00EpXL-8D; Fri, 08 Apr 2022 15:04:24 +0200
Date:   Fri, 8 Apr 2022 15:04:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "huangguangbin (A)" <huangguangbin2@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
Subject: Re: [PATCH] net: phy: genphy_loopback: fix loopback failed when
 speed is unknown
Message-ID: <YlAy2PrmZuOr/bSx@lunn.ch>
References: <20220331114819.14929-1-huangguangbin2@huawei.com>
 <YkWdTpCsO8JhiSaT@lunn.ch>
 <130bb780-0dc1-3819-8f6d-f2daf4d9ece9@huawei.com>
 <YkW6J9rM6O/cb/lv@lunn.ch>
 <20220401064006.GB4449@pengutronix.de>
 <YkbsraBQ5ynYG9wz@lunn.ch>
 <d42ae21a-6136-5340-6851-e3108759937a@huawei.com>
 <Yk7475EJ622D1Ty/@lunn.ch>
 <20220408081824.GF25348@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408081824.GF25348@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 10:18:24AM +0200, Oleksij Rempel wrote:
> On Thu, Apr 07, 2022 at 04:45:03PM +0200, Andrew Lunn wrote:
> > > Hi Andrew,
> > > The PHY we test is RTL8211F, it supports 10 half. This problem actually is,
> > > our board has MAC connected with PHY, when loopback test, packet flow is
> > > MAC->PHY->MAC, it needs speed of MAC and PHY should be same when they work.
> > > 
> > > If PHY speed is unknown when PHY goes down, we will not set MAC speed in
> > > adjust_link interface. In this case, we hope that PHY speed should not be
> > > changed, as the old code of function genphy_loopback() before patch
> > > "net: phy: genphy_loopback: add link speed configuration".
> > > 
> > > If PHY has never link, MAC speed has never be set in adjust_link interface,
> > > yeah, in this case, MAC and PHY may has different speed, and they can not work.
> > > I think we can accept this situation.
> > > 
> > > I think it is general problem if there is MAC connected with PHY.
> > 
> > Thanks for investigating. Looks like we are getting close the real
> > solution. And it is a generic problem, that the MAC and PHY might not
> > be using the same configuration.
> > 
> > So it looks like if the link is down, or speed is UNKNOWN, we need to
> > set phydev->link true, speed 10, duplex half...
> 
> Hm, i was thinking, is it impossible to run loopback test on half duplex link.
> Do I missing something?

Ah, you might be right. I was just thinking of the lowest common
denominator. So 10 Full. Or maybe even look at phydev->supported and
pick one from there.

     Andrew
