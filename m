Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AA94EDBA8
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 16:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbiCaO2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 10:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237498AbiCaO2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 10:28:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8304521D7DB;
        Thu, 31 Mar 2022 07:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WKvQhSKFWoLuajjNgA2S2UoVge0oH0PP/Mwfs4RXClE=; b=jzBurfDBkkToDK1iyryqp7VWYE
        Ob6XrfgyRh4mOaGjCq1TfDZfuQErBgibwFYs/zu03ViVwDFYuysvQBO2Vy9NvFODJjP7XVVsL5I6D
        XbmhJBOq9qBRqOKPaXwZ7kxb68r0ZJE5v7BYywMWA9etAS2FOIO/mRV0GjNF5nYUfkTk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nZvl9-00DTZc-5k; Thu, 31 Mar 2022 16:26:47 +0200
Date:   Thu, 31 Mar 2022 16:26:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, o.rempel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Subject: Re: [PATCH] net: phy: genphy_loopback: fix loopback failed when
 speed is unknown
Message-ID: <YkW6J9rM6O/cb/lv@lunn.ch>
References: <20220331114819.14929-1-huangguangbin2@huawei.com>
 <YkWdTpCsO8JhiSaT@lunn.ch>
 <130bb780-0dc1-3819-8f6d-f2daf4d9ece9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <130bb780-0dc1-3819-8f6d-f2daf4d9ece9@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In this case, as speed and duplex both are unknown, ctl is just set to 0x4000.
> However, the follow code sets mask to ~0 for function phy_modify():
> int genphy_loopback(struct phy_device *phydev, bool enable)
> {
> 	if (enable) {
> 		...
> 		phy_modify(phydev, MII_BMCR, ~0, ctl);
> 		...
> }
> so all other bits of BMCR will be cleared and just set bit 14, I use phy trace to
> prove that:
> 
> $ cat /sys/kernel/debug/tracing/trace
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 923/923   #P:128
> #
> #                                _-----=> irqs-off/BH-disabled
> #                               / _----=> need-resched
> #                              | / _---=> hardirq/softirq
> #                              || / _--=> preempt-depth
> #                              ||| / _-=> migrate-disable
> #                              |||| /     delay
> #           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
> #              | |         |   |||||     |         |
>   kworker/u257:2-694     [015] .....   209.263912: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>   kworker/u257:2-694     [015] .....   209.263951: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
>   kworker/u257:2-694     [015] .....   209.263990: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
>   kworker/u257:2-694     [015] .....   209.264028: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
>   kworker/u257:2-694     [015] .....   209.264067: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0a val:0x0000
>          ethtool-1148    [007] .....   209.665693: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>          ethtool-1148    [007] .....   209.665706: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1840
>          ethtool-1148    [007] .....   210.588139: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1840
>          ethtool-1148    [007] .....   210.588152: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1040
>          ethtool-1148    [007] .....   210.615900: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>          ethtool-1148    [007] .....   210.615912: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x4000 //here just set bit 14
> 
> So phy speed will be set to 10M in this case, if previous speed of
> device before going down is 10M, loopback test is pass. Only
> previous speed is 100M or 1000M, loopback test is failed.

O.K. So it should be set into 10M half duplex. But why does this cause
it not to loopback packets? Does the PHY you are using not actually
support 10 Half? Why does it need to be the same speed as when the
link was up? And why does it actually set LSTATUS indicating there is
link?

Is this a generic problem, all PHYs are like this, or is this specific
to the PHY you are using? Maybe this PHY needs its own loopback
function because it does something odd?

   Andrew

