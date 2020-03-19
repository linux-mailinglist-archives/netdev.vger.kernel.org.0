Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7478F18BDE7
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgCSRXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:23:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45708 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbgCSRXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 13:23:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jmNegeDrVybNvjntT9gNv3RnNnTFGVKOYNiqoRvDEmw=; b=VQrAMjEBmMnzEflKliNy6sgciX
        56IUdBfmVSkCJKf/F/SoM3XJ1CU7usYQpSx0H/9ZRAo5bSegOi7ItyUtDbwRdmHCCeGkAX/+djtEz
        XR9xIG8W3YrnKLtaJT9gR3NkGln9eLPwHMpYRVtEBsqcDDSKYTlp/rWaxSNkZTY72HNc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEysy-0008Dw-Hh; Thu, 19 Mar 2020 18:23:12 +0100
Date:   Thu, 19 Mar 2020 18:23:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, tglx@linutronix.de, broonie@kernel.org,
        corbet@lwn.net, mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] net: phy: bcm84881: use
 phy_read_mmd_poll_timeout() to simplify the code
Message-ID: <20200319172312.GK27807@lunn.ch>
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
 <20200319163910.14733-5-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319163910.14733-5-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 12:39:07AM +0800, Dejin Zheng wrote:
> use phy_read_mmd_poll_timeout() to replace the poll codes for
> simplify the code in bcm84881_wait_init() function.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
>  drivers/net/phy/bcm84881.c | 24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
> index 14d55a77eb28..c916bd0f6afa 100644
> --- a/drivers/net/phy/bcm84881.c
> +++ b/drivers/net/phy/bcm84881.c
> @@ -22,26 +22,14 @@ enum {
>  
>  static int bcm84881_wait_init(struct phy_device *phydev)
>  {
> -	unsigned int tries = 20;
>  	int ret, val;
>  
> -	do {
> -		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
> -		if (val < 0) {
> -			ret = val;
> -			break;
> -		}
> -		if (!(val & MDIO_CTRL1_RESET)) {
> -			ret = 0;
> -			break;
> -		}
> -		if (!--tries) {
> -			ret = -ETIMEDOUT;
> -			break;
> -		}
> -		msleep(100);
> -	} while (1);
> -
> +	ret = phy_read_mmd_poll_timeout(val, val < 0 ||
> +					!(val & MDIO_CTRL1_RESET), 100000,

It would be good if the "val < 0" was not here. What the user is
really interested in is !(val & MDIO_CTRL1_RESET). "val < 0" is the
error handling for phy_read_mmd(). This would look a lot nicer if that
error handling was inside phy_read_mmd_poll_timeout() and ret would
already contain the error from phy_read_mmd(). Not sure you can do
this and still make use of readx_poll_timeout().

     Andrew


