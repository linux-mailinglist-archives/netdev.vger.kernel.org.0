Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F6A627914
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiKNJgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiKNJga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:36:30 -0500
X-Greylist: delayed 65 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Nov 2022 01:36:24 PST
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E85119
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:36:24 -0800 (PST)
X-QQ-mid: Yeas49t1668418490t313t22932
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FK8000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     "'Mengyuan Lou'" <mengyuanlou@net-swift.com>,
        <netdev@vger.kernel.org>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com> <20221108111907.48599-2-mengyuanlou@net-swift.com> <Y2rBo3KI2LmjS55y@lunn.ch> <02a901d8f405$1c21a350$5464e9f0$@trustnetic.com> <Y2uqk9BwVjPcEtPP@lunn.ch>
In-Reply-To: <Y2uqk9BwVjPcEtPP@lunn.ch>
Subject: RE: [PATCH net-next 1/5] net: txgbe: Identify PHY and SFP module
Date:   Mon, 14 Nov 2022 17:34:49 +0800
Message-ID: <005c01d8f80c$574c16d0$05e44470$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEDYkxFLCrX910mDyZZwuk/z1QniAJnx28nAUaCYTcBhYnRrAF2N1Mor7P+DyA=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, November 9, 2022 9:27 PM, Andrew Lunn wrote:
> > > So it looks like you have Linux driving the SFP, not firmware. In
> > > that case, please throw all this
> > code away.
> > > Implement a standard Linux I2C bus master driver, and make use of driver/net/phy/sfp*.[ch].
> > >
> > >     Andrew
> > >
> >
> > I don't quite understand how to use driver/net/phy/sfp* files. In
> > txgbe driver, I2C infos are read from CAB registers, then SFP type identified.
> > Perhaps implement 'struct sfp_upstream_ops' ? And could you please
> > guide me an example driver of some docs?
> 
> The SFP driver is currently device tree only, but it should be easy to add support for a platform
device and
> platform data. That driver needs to be told about a standard Linux i2c master device, and
optionally a
> collection of GPIO which connect to the SFP socket.
> 
> So you need to implement a standard Linux I2C bus master. Which basically means being able to send
> and receive an I2C message. Take a look at for example drivers/net/ethernet/mellanox/mlxsw/i2c.c .
> This driver however does not use it with the SFP driver, since the Mellanox devices have firmware
> controlling the SFP. But it will give you the idea how you can embed an I2C bus driver inside
another
> driver.
> 
> For the GPIOs to the SFP socket, TX Enable, LOS, MODDEF etc, you want a standard Linux GPIO
driver.
> For an example, look at drivers/net/dsa/vitesse-vsc73xx-core.c.
> 
> https://github.com/lunn/linux/blob/v5.0.7-rap/drivers/platform/x86/zii-rap.c
> contains an example of registering a bit-bang MDIO controller. zii_rap_mdio_gpiod_table would
become
> a list of SFP GPIOs. zii_rap_mdio_init() registers a platform devices which instantiaces an MDIO
bus. You
> would register a platform device which instantiates an SFP device.
> 
> Once you have an SFP devices you need to extend phylink with a platform data binding. So you can
pass it
> your SFP device.
> 
> This should all be reasonably simple code.
> 
>      Andrew
> 

When ethernet driver does a reset to the hardware, like 'txgbe_reset_hw', the I2C configuration will
be reset.
It needs to be reconfigured once. So how could I call the I2C function here? Can I treat the I2C
driver as a lib?


