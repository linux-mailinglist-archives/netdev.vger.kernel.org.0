Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B146AAAE9
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 16:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCDPn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 10:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCDPnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 10:43:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD27FF34;
        Sat,  4 Mar 2023 07:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=WlHItfDe2+GVbkKB85wB9pJreJVbUkzc7e8si1p2OT8=; b=qW
        fr/uZxICOV4UQXlqV2gON+WQQo6vX/Wo4LeMEYqkLSbrbllTHcA0+EaWnBDmIcTQexi1ybMemJyFz
        WwKQe4z6u0fdA+UDzRCYPJ0DOWeo2MnZqN2xpy3YKnIOfP7zYdjsT/efTT4DV36UAHygulzU9Namf
        fxjk7hWl/kW3268=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pYU31-006SBw-3w; Sat, 04 Mar 2023 16:43:47 +0100
Date:   Sat, 4 Mar 2023 16:43:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v2 3/4] net: Let the active time stamping layer be
 selectable.
Message-ID: <011d63c3-e3ff-4b67-8ab7-d39f541c7b31@lunn.ch>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
 <20230303164248.499286-4-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230303164248.499286-4-kory.maincent@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 05:42:40PM +0100, Köry Maincent wrote:
> From: Richard Cochran <richardcochran@gmail.com>
> 
> Make the sysfs knob writable, and add checks in the ioctl and time
> stamping paths to respect the currently selected time stamping layer.

Although it probably works, i think the ioctl code is ugly.

I think it would be better to pull the IOCTL code into the PTP object
interface. Add an ioctl member to struct ptp_clock_info. The PTP core
can then directly call into the PTP object.

You now have a rather odd semantic that calling the .ndo_eth_ioctl
means operate on the MAC PTP. If you look at net_device_ops, i don't
think any of the other members have this semantic. They all look at
the netdev as a whole, and ask the netdev to do something, without
caring what level it operates at. So a PTP ioctl should operate on
'the' PTP of the netdev, whichever that might be, MAC or PHY.

Clearly, it is a bigger change, you need to touch every MAC driver
with PTP support, but at the end, you have a cleaner architecture.

     Andrew
