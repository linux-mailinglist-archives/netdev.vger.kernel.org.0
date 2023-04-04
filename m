Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D826D56E3
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjDDCsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDCsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:48:37 -0400
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C7C1FD3
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 19:48:32 -0700 (PDT)
X-QQ-mid: Yeas48t1680576450t621t02954
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 13648886427554094585
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <linux@armlinux.org.uk>,
        <mengyuanlou@net-swift.com>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com> <20230403064528.343866-3-jiawenwu@trustnetic.com> <5071701f-bf69-4fa7-ad43-b780afd057a1@lunn.ch>
In-Reply-To: <5071701f-bf69-4fa7-ad43-b780afd057a1@lunn.ch>
Subject: RE: [PATCH net-next 2/6] net: txgbe: Implement I2C bus master driver
Date:   Tue, 4 Apr 2023 10:47:28 +0800
Message-ID: <03fc01d9669f$cb8cb610$62a62230$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQKwNRf195lW+I6aexcIjeJmW6Wh1gGmqyMsAIahL1ytW1x5AA==
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, April 3, 2023 8:53 PM, Andrew Lunn wrote:
> On Mon, Apr 03, 2023 at 02:45:24PM +0800, Jiawen Wu wrote:
> > I2C bus is integrated in Wangxun 10Gb ethernet chip. Implement I2C bus
> > driver to receive I2C messages.
> 
> Please Cc: the i2c mailing list for comments. They know more about I2C than
the
> netdev people.
> 
> Is the I2C bus master your own IP, or have you licensed a core? Or using the
open
> cores i2C bus master? I just want to make sure there is not already a linux
driver for
> this.
> 

I use the I2C core driver, and implement my own i2c_algorithm. I think it needs
to configure my registers to realize the function.

> > +static void txgbe_i2c_start(struct wx *wx, u16 dev_addr) {
> > +	wr32(wx, TXGBE_I2C_ENABLE, 0);
> > +
> > +	wr32(wx, TXGBE_I2C_CON,
> > +	     (TXGBE_I2C_CON_MASTER_MODE |
> > +	      TXGBE_I2C_CON_SPEED(1) |
> > +	      TXGBE_I2C_CON_RESTART_EN |
> > +	      TXGBE_I2C_CON_SLAVE_DISABLE));
> > +	/* Default addr is 0xA0 ,bit 0 is configure for read/write! */
> 
> A generic I2C bus master should not care about that address is being
read/write.
> For the SFP use case, 0xa0 will be used most of the time, plus 0xa2 for
diagnostics.
> But when the SFP contains a copper PHY, other addresses will be used as well.
> 

Yes, this comment is redundant. The address will be set to 'msg[0].addr'.

> > +static int txgbe_i2c_xfer(struct i2c_adapter *i2c_adap,
> > +			  struct i2c_msg *msg, int num_msgs) {
> > +	struct wx *wx = i2c_get_adapdata(i2c_adap);
> > +	u8 *dev_addr = msg[0].buf;
> > +	bool read = false;
> > +	int i, ret;
> > +	u8 *buf;
> > +	u16 len;
> > +
> > +	txgbe_i2c_start(wx, msg[0].addr);
> > +
> > +	for (i = 0; i < num_msgs; i++) {
> > +		if (msg[i].flags & I2C_M_RD) {
> > +			read = true;
> > +			len = msg[i].len;
> > +			buf = msg[i].buf;
> > +		}
> > +	}
> > +
> > +	if (!read) {
> > +		wx_err(wx, "I2C write not supported\n");
> > +		return num_msgs;
> > +	}
> 
> Write is not supported at all? Is this a hardware limitation?  I think
-EOPNOTSUPP
> is required here, and you need to ensure the code using the I2C bus master has
> quirks to not try to write.

It is supported. False testing leads to false perceptions, I'll fix it.

> 
> > +#define TXGBE_I2C_SLAVE_ADDR                    (0xA0 >> 1)
> > +#define TXGBE_I2C_EEPROM_DEV_ADDR               0xA0
> 
> These two do not appear to be used? I guess you took your hard coded SFP i2c
bus
> master and generalised it? Please clean up dead code like this.
> 
> 	Andrew
> 

