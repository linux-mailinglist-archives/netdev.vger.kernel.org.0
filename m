Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0013380A2D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhENNK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 09:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhENNKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 09:10:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F291C06174A;
        Fri, 14 May 2021 06:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BXqAC1pbKs3j4NOO8yWXGrt0LNNTBr4iLV2yAP7ms80=; b=OgwWUSq1igQM+qijDhyiGpZbB
        7pJhTLrdVnAZ5DZ3iS5WTWxGeL+xy8flu9DxXz2OkAC+kU5Vf/DMusm6P3V9sMJSWrz4SqgBJeFTU
        fmI8iThYjOUYoR7z3wz+2xklLyju2B9NLCEQi09WwkXwo4BRs3k3O5BnAnl6/mK0Vak55wjvlKEHR
        O91YCtVgJcoS/7vJOzu4DkGu5iTk/x9u/UNK8QvK47UO1m1TcIuG8Wdmuh97HFjzNCxpxy6RU5EBF
        npNVpKRklFtY0KrDX597FXumGg26Id1krUVYbQ2hrBo4LCA8lkivL1pmswzIKPnNVI30X3enx4uS9
        El6wrBUFA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43972)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhXZ0-0008Bd-5t; Fri, 14 May 2021 14:09:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhXYy-00042P-TJ; Fri, 14 May 2021 14:09:08 +0100
Date:   Fri, 14 May 2021 14:09:08 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v3] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <20210514130908.GD12395@shell.armlinux.org.uk>
References: <20210514115826.3025223-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514115826.3025223-1-pgwipeout@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Fri, May 14, 2021 at 07:58:26AM -0400, Peter Geis wrote:
> +	/* set rgmii delay mode */
> +	val = __phy_read(phydev, YT8511_PAGE);
> +
> +	switch (phydev->interface) {
> +	case PHY_INTERFACE_MODE_RGMII:
> +		val &= ~(YT8511_DELAY_RX | YT8511_DELAY_TX);
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +		val |= YT8511_DELAY_RX | YT8511_DELAY_TX;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		val &= ~(YT8511_DELAY_TX);
> +		val |= YT8511_DELAY_RX;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		val &= ~(YT8511_DELAY_RX);
> +		val |= YT8511_DELAY_TX;
> +		break;
> +	default: /* leave everything alone in other modes */
> +		break;
> +	}
> +
> +	ret = __phy_write(phydev, YT8511_PAGE, val);
> +	if (ret < 0)
> +		goto err_restore_page;

Another way of writing the above is to set "val" to be the value of the
YT8511_DELAY_RX and YT8511_DELAY_TX bits, and then do:

	ret = __phy_modify(phydev, YT8511_PAGE,
			   (YT8511_DELAY_RX | YT8511_DELAY_TX), val);
	if (ret < 0)
		goto err_restore_page;

which moves the read-modify-write out of the driver into core code and
makes the driver code smaller. It also handles your missing error check
on __phy_read() above - would you want the above code to attempt to
write a -ve error number back to this register? I suspect not!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
