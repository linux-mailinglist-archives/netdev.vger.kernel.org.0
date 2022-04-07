Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6BE4F820A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344218AbiDGOrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiDGOrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:47:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0684C40B;
        Thu,  7 Apr 2022 07:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dYlUZ7HEM9Q8UXLO+RramSh0ZaxW+tJRr+1uBmDx/CA=; b=0piKrbmhFW7hUKXrkZkNchk2tg
        eEuOXgL43A35J6T4dB1XfIg5vVxVAYDF8nwD9oSOioIPA1XtTPyzcwSNR8dfXZv/CJT8Sgs9iZ7cf
        UbvI1VufV7xLk3WfTgFqcPuF6WLIJkY0zQckaBtEGiuKaIumSR4CBYTg+/a2BISfxi5Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncTNf-00Ef6h-NE; Thu, 07 Apr 2022 16:45:03 +0200
Date:   Thu, 7 Apr 2022 16:45:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
Subject: Re: [PATCH] net: phy: genphy_loopback: fix loopback failed when
 speed is unknown
Message-ID: <Yk7475EJ622D1Ty/@lunn.ch>
References: <20220331114819.14929-1-huangguangbin2@huawei.com>
 <YkWdTpCsO8JhiSaT@lunn.ch>
 <130bb780-0dc1-3819-8f6d-f2daf4d9ece9@huawei.com>
 <YkW6J9rM6O/cb/lv@lunn.ch>
 <20220401064006.GB4449@pengutronix.de>
 <YkbsraBQ5ynYG9wz@lunn.ch>
 <d42ae21a-6136-5340-6851-e3108759937a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d42ae21a-6136-5340-6851-e3108759937a@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> The PHY we test is RTL8211F, it supports 10 half. This problem actually is,
> our board has MAC connected with PHY, when loopback test, packet flow is
> MAC->PHY->MAC, it needs speed of MAC and PHY should be same when they work.
> 
> If PHY speed is unknown when PHY goes down, we will not set MAC speed in
> adjust_link interface. In this case, we hope that PHY speed should not be
> changed, as the old code of function genphy_loopback() before patch
> "net: phy: genphy_loopback: add link speed configuration".
> 
> If PHY has never link, MAC speed has never be set in adjust_link interface,
> yeah, in this case, MAC and PHY may has different speed, and they can not work.
> I think we can accept this situation.
> 
> I think it is general problem if there is MAC connected with PHY.

Thanks for investigating. Looks like we are getting close the real
solution. And it is a generic problem, that the MAC and PHY might not
be using the same configuration.

So it looks like if the link is down, or speed is UNKNOWN, we need to
set phydev->link true, speed 10, duplex half, the PHY into 10/Half and
call the adjust_link callback. That should get the MAC and PHY to talk
to each other.

The open question is what to do when we disable loopback. Maybe we
need to always set link false, speed unknown and call phy_start_aneg()
to restart the link?

   Andrew
