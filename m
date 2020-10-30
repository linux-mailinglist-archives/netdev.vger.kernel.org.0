Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B962A0991
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgJ3PUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbgJ3PUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:20:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF651C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3uj/nURpyuyuYvE9iruaMmWcw0uhttaSpMsNYCkQq00=; b=M/ZZaa4MaHay0Za0mrL/0785X
        85buFce0jr0Px1avPwtTv279qNAlrazRfQtboTXYdhofzfXWL1SscNi8Kr9odbfPBjzElgvZ+nD7H
        Jo2sknOSbS8fSl2v+9OVses0yBVx0vE4BChS8bYfHnNnlsy/mOepUCuobhUCvpQ7cVl75d5pzlJM9
        kiXTWHpCT0DSX38jnU2Pi0Uj90zK2WDANMtqa/S78s9vQbpblt2aZd7TBIydztGjfQlg26IF/Vf0C
        bGGSffmvxv2zFbt0X0KQ63VZTTZ+bfPqaIffEFGh8SYBig5dK3iQIcOM5r5WV5j4d7xwF9sVRNrub
        Y/Jn/a50g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52928)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kYWCf-0006DY-LK; Fri, 30 Oct 2020 15:20:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kYWCf-0007GX-A1; Fri, 30 Oct 2020 15:20:33 +0000
Date:   Fri, 30 Oct 2020 15:20:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 1/5] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20201030152033.GC1551@shell.armlinux.org.uk>
References: <20201029222509.27201-1-kabel@kernel.org>
 <20201029222509.27201-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201029222509.27201-2-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 11:25:05PM +0100, Marek Behún wrote:
> @@ -91,9 +94,210 @@ static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
>  	return ret < 0 ? ret : 0;
>  }
>  
> -struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
> +/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
> + * instead via address 0x51, when SFP page is set to 0x03 and password to
> + * 0xffffffff:
> + *
> + * address  size  contents  description
> + * -------  ----  --------  -----------
> + * 0x80     1     CMD       0x01/0x02/0x04 for write/read/done
> + * 0x81     1     DEV       Clause 45 device
> + * 0x82     2     REG       Clause 45 register
> + * 0x84     2     VAL       Register value
> + */
...
> +static int i2c_mii_init_rollball(struct i2c_adapter *i2c)
> +{
> +	u8 page_buf[2], pw_buf[5];
> +	struct i2c_msg msgs[2];
> +	int ret;
> +
> +	page_buf[0] = SFP_PAGE;
> +	page_buf[1] = 3;
> +
> +	msgs[0].addr = ROLLBALL_PHY_I2C_ADDR;
> +	msgs[0].flags = 0;
> +	msgs[0].len = sizeof(page_buf);
> +	msgs[0].buf = page_buf;
> +
> +	pw_buf[0] = ROLLBALL_SFP_PASSWORD_ADDR;
> +	pw_buf[1] = 0xff;
> +	pw_buf[2] = 0xff;
> +	pw_buf[3] = 0xff;
> +	pw_buf[4] = 0xff;
> +
> +	msgs[1].addr = ROLLBALL_PHY_I2C_ADDR;
> +	msgs[1].flags = 0;
> +	msgs[1].len = sizeof(pw_buf);
> +	msgs[1].buf = pw_buf;
> +
> +	ret = i2c_transfer(i2c, msgs, ARRAY_SIZE(msgs));
> +	if (ret < 0)
> +		return ret;
> +	else if (ret != ARRAY_SIZE(msgs))
> +		return -EIO;
> +
> +	return 0;
> +}

One of the points I raised in the previous review was: "Also, shouldn't
we ensure that we are on page 1 before attempting any access?" I
actually meant page 3 which I corrected when commenting on patch 5:
"I think this needs to be done in the MDIO driver - if we have userspace
or otherwise expand what we're doing, relying on page 3 remaining
selected will be very fragile."

I feel that point still stands; if the SFP page is changed after
i2c_mii_init_rollball() and before a subsequent access, the subsequent
access is not going to hit the correct page, and we will lose access
to the PHY. Worse, we will end up writing to that other page.

That said, I don't see anything in SFF8472 that would result in a
clash, so I think I would like to see the comment at the beginning
make explicit the expectation that SFP_PAGE will remain set to 3
throughout the lifetime of the module plugged into the system.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
