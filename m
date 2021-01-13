Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7492F4A01
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 12:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbhAMLWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 06:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbhAMLWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 06:22:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7CAC23382;
        Wed, 13 Jan 2021 11:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610536926;
        bh=mB/yINeywJPn9ACtbZgEFs9/M/2PF5GuvNEYy/ug4L8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DZYj1SWYybiIIye1GOCyDI83CDR/ZMjHYSRt4cRxBiN33xJ+IBIbgEoJFsItZAVkM
         3vnTUqjazgl5qqiSCjRwTyd9D7l7zobZ6jTvule9bSYkRv1+JZ7VsAxeanCVLDTSC9
         5xf16RRjtw4C7Tf8gKie1i18lrLfilYGvccJRU5xumalljDLEYgXfrAVf5vDgtJRkB
         Y+j1ysoWORpQGMCSFsvxWrZk2q6WVebu8QIqg3HYbKtlDJoSTD5w0uJcH5mZVeV15X
         ezkx3hbvDW17UKzSuBAiFsDoeybczY02rAI3H+zp4qJ2kTw2HXhwbrL9lGrO00utXx
         mgI1X/BMYHVUw==
Received: by pali.im (Postfix)
        id 364E976D; Wed, 13 Jan 2021 12:22:04 +0100 (CET)
Date:   Wed, 13 Jan 2021 12:22:04 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20210113112204.h3piuoni7amvx7i2@pali>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111050044.22002-2-kabel@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello! See my comments below.

On Monday 11 January 2021 06:00:41 Marek Behún wrote:
> Some multigig SFPs from RollBall and Hilink do not expose functional
> MDIO access to the internal PHY of the SFP via I2C address 0x56
> (although there seems to be read-only clause 22 access on this address).

Maybe it could be interesting to test if clause 22 access via i2c
address 0x56 can work also in write mode after setting rollball
password...

> Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
> Digital Diagnostic Interface - I2C address 0x51. The SFP_PAGE has to be
> selected to 3 and the password must be filled with 0xff bytes for this
> PHY communication to work.
> 
> This extends the mdio-i2c driver to support this protocol by adding a
> special parameter to mdio_i2c_alloc function via which this RollBall
> protocol can be selected.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/mdio/mdio-i2c.c   | 319 +++++++++++++++++++++++++++++++++-
>  drivers/net/phy/sfp.c         |   2 +-
>  include/linux/mdio/mdio-i2c.h |   8 +-
>  3 files changed, 322 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
> index 09200a70b315..7be582c0891a 100644
> --- a/drivers/net/mdio/mdio-i2c.c
> +++ b/drivers/net/mdio/mdio-i2c.c
...
> @@ -91,9 +94,297 @@ static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
>  	return ret < 0 ? ret : 0;
>  }
>  
> -struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
> +/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
> + * instead via address 0x51, when SFP page is set to 0x03 and password to
> + * 0xffffffff.
> + * Since current SFP code does not modify SFP_PAGE, we set it to 0x03 only at
> + * bus creation time, and expect it to remain set to 0x03 throughout the
> + * lifetime of the module plugged into the system. If the SFP code starts
> + * modifying SFP_PAGE in the future, this code will need to change.
> + *
> + * address  size  contents  description
> + * -------  ----  --------  -----------
> + * 0x80     1     CMD       0x01/0x02/0x04 for write/read/done
> + * 0x81     1     DEV       Clause 45 device
> + * 0x82     2     REG       Clause 45 register
> + * 0x84     2     VAL       Register value
> + */
> +#define ROLLBALL_PHY_I2C_ADDR		0x51
> +#define ROLLBALL_SFP_PASSWORD_ADDR	0x7b

It looks like that this password entry is standard field described in
QSFP+ specifications SFF-8436 and SFF-8636. Should not it be rather
named vendor-neutral (as it is not Rollball specific)? And maybe defined
in include/linux/sfp.h file where also also other standard macros, like
SFP_PAGE macro?

> +
> +#define ROLLBALL_CMD_ADDR		0x80
> +#define ROLLBALL_DATA_ADDR		0x81
> +
> +#define ROLLBALL_CMD_WRITE		0x01
> +#define ROLLBALL_CMD_READ		0x02
> +#define ROLLBALL_CMD_DONE		0x04
> +
> +#define SFP_PAGE_ROLLBALL_MDIO		3
...
> diff --git a/include/linux/mdio/mdio-i2c.h b/include/linux/mdio/mdio-i2c.h
> index b1d27f7cd23f..53eedb0dc1d3 100644
> --- a/include/linux/mdio/mdio-i2c.h
> +++ b/include/linux/mdio/mdio-i2c.h
> @@ -11,6 +11,12 @@ struct device;
>  struct i2c_adapter;
>  struct mii_bus;
>  
> -struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c);
> +enum mdio_i2c_proto {
> +	MDIO_I2C_DEFAULT,

Russel wrote that current mdio i2c (default) access method is also
vendor specific for Marvell chips. Should not we rather call it
MDIO_I2C_MARVELL if both methods are vendor/chip specific?

> +	MDIO_I2C_ROLLBALL,
> +};
> +
> +struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
> +			       enum mdio_i2c_proto protocol);
>  
>  #endif
> -- 
> 2.26.2
> 
