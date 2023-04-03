Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8E46D44ED
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjDCMxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjDCMxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:53:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A0146A6
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=soGhwagd935cyGah0qtTowS7hD+vejcz/dj60ZBOrDc=; b=GpZVK2CwgOMt+g5KLoucsGC5Wz
        NbQ9kV90XkuFSE+tSvLJdBLsJ44Ffum2mmtFmc27TbpVLNJtoQNInZPYe2Xf8cBWZad0MHXbcKxsD
        UbTZgDWQSUv16S1/Xvy5Dwym4Jy0TaqXDWnj35c46zRdlh+L9bpBg48uEHsX3u8ywI8Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pjJgB-009HVy-Eq; Mon, 03 Apr 2023 14:52:59 +0200
Date:   Mon, 3 Apr 2023 14:52:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 2/6] net: txgbe: Implement I2C bus master driver
Message-ID: <5071701f-bf69-4fa7-ad43-b780afd057a1@lunn.ch>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-3-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403064528.343866-3-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 02:45:24PM +0800, Jiawen Wu wrote:
> I2C bus is integrated in Wangxun 10Gb ethernet chip. Implement I2C bus
> driver to receive I2C messages.

Please Cc: the i2c mailing list for comments. They know more about I2C
than the netdev people.

Is the I2C bus master your own IP, or have you licensed a core? Or
using the open cores i2C bus master? I just want to make sure there is
not already a linux driver for this.
 
> +static void txgbe_i2c_start(struct wx *wx, u16 dev_addr)
> +{
> +	wr32(wx, TXGBE_I2C_ENABLE, 0);
> +
> +	wr32(wx, TXGBE_I2C_CON,
> +	     (TXGBE_I2C_CON_MASTER_MODE |
> +	      TXGBE_I2C_CON_SPEED(1) |
> +	      TXGBE_I2C_CON_RESTART_EN |
> +	      TXGBE_I2C_CON_SLAVE_DISABLE));
> +	/* Default addr is 0xA0 ,bit 0 is configure for read/write! */

A generic I2C bus master should not care about that address is being
read/write. For the SFP use case, 0xa0 will be used most of the time,
plus 0xa2 for diagnostics. But when the SFP contains a copper PHY,
other addresses will be used as well.

> +static int txgbe_i2c_xfer(struct i2c_adapter *i2c_adap,
> +			  struct i2c_msg *msg, int num_msgs)
> +{
> +	struct wx *wx = i2c_get_adapdata(i2c_adap);
> +	u8 *dev_addr = msg[0].buf;
> +	bool read = false;
> +	int i, ret;
> +	u8 *buf;
> +	u16 len;
> +
> +	txgbe_i2c_start(wx, msg[0].addr);
> +
> +	for (i = 0; i < num_msgs; i++) {
> +		if (msg[i].flags & I2C_M_RD) {
> +			read = true;
> +			len = msg[i].len;
> +			buf = msg[i].buf;
> +		}
> +	}
> +
> +	if (!read) {
> +		wx_err(wx, "I2C write not supported\n");
> +		return num_msgs;
> +	}

Write is not supported at all? Is this a hardware limitation?  I think
-EOPNOTSUPP is required here, and you need to ensure the code using
the I2C bus master has quirks to not try to write.

> +#define TXGBE_I2C_SLAVE_ADDR                    (0xA0 >> 1)
> +#define TXGBE_I2C_EEPROM_DEV_ADDR               0xA0

These two do not appear to be used? I guess you took your hard coded
SFP i2c bus master and generalised it? Please clean up dead code like
this.

	Andrew
