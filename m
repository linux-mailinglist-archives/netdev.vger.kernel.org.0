Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED693ED86E
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbhHPOCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236916AbhHPOBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:01:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AFCC0613C1;
        Mon, 16 Aug 2021 07:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0zetptGRmHqsMNpZRvH8POdLh+Fa//yZlT0HLTpk0mg=; b=oBPgC7geYn6UUvfB5tzxEAVSn
        3Jq+gKvad3lydeLxvKAgrGD3ja6bEfUJxyB5fzUw35gER1sLL5DNqbsIODtXFO+nNTHc+2Cfuvv7E
        fqeX/i3WEqCgqFcjkB374YbVgPp1+gZHDNdI/RLDQ0dKzVSszdgIXB9pVnP+ROfAcRMcotvP2FUCx
        qA6eFgilbCFTsUXY1SontWVGLOAMRkfQvvVK4iF596Bfyr9J8AdRfgC6I++3xBcw3Ht1AxIzLnk5K
        h19vKMcFhB4Vk6/B3Gf0JykyEQeNQ0j4VUthFh1AGELJBNwiEABPBPdA6/MUGKj/TIavtE0mwWtea
        HnZJdz0QQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47378)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mFdAm-0007x7-Ly; Mon, 16 Aug 2021 15:01:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mFdAl-000821-EL; Mon, 16 Aug 2021 15:01:03 +0100
Date:   Mon, 16 Aug 2021 15:01:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
Message-ID: <20210816140103.GK22278@shell.armlinux.org.uk>
References: <20210816113440.22290-1-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816113440.22290-1-luoj@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 07:34:40PM +0800, Luo Jie wrote:
> +/* PMA control */
> +#define QCA808X_PHY_MMD1_PMA_CONTROL			0x0
> +#define QCA808X_PMA_CONTROL_SPEED_MASK			(BIT(13) | BIT(6))
> +#define QCA808X_PMA_CONTROL_2500M			(BIT(13) | BIT(6))
> +#define QCA808X_PMA_CONTROL_1000M			BIT(6)
> +#define QCA808X_PMA_CONTROL_100M			BIT(13)
> +#define QCA808X_PMA_CONTROL_10M				0x0

I don't think this is (a) correct, (b) any different from the IEEE 802.3
standard definitions. Please use the standard definitions in
include/uapi/linux/mdio.h.

> +/* PMA capable */
> +#define QCA808X_PHY_MMD1_PMA_CAP_REG			0x4
> +#define QCA808X_STATUS_2500T_FD_CAPS			BIT(13)

Again, this is IEEE 802.3 standard, nothing special here. As this is
a standard bit, include/uapi/linux/mdio.h should be augmented with
it rather than introducing private definitions. Note that this is
_not_ 2500T but merely indicates that the "PMA/PMD is capable of
operating at 2.5 Gb/s". IEEE 802.3 makes no mention of the underlying
technology used to achieve 2.5Gbps.

> +/* PMA type */
> +#define QCA808X_PHY_MMD1_PMA_TYPE			0x7
> +#define QCA808X_PMA_TYPE_MASK				GENMASK(5, 0)
> +#define QCA808X_PMA_TYPE_2500M				0x30
> +#define QCA808X_PMA_TYPE_1000M				0xc
> +#define QCA808X_PMA_TYPE_100M				0xe
> +#define QCA808X_PMA_TYPE_10M				0xf

This is the PMA type selection register... another IEEE 802.3 standard
register. You omit the underlying technology for these definitions.
From the IEEE 802.3 standard:

0x30 2.5GBASE-T PMA
0x0f 10BASE-T PMA/PMD
0x0e 100BASE-TX PMA/PMD
0x0c 1000BASE-T PMA/PMD

and we have definitions for all these already:

#define MDIO_PMA_CTRL2_1000BT           0x000c  /* 1000BASE-T type */
#define MDIO_PMA_CTRL2_100BTX           0x000e  /* 100BASE-TX type */
#define MDIO_PMA_CTRL2_10BT             0x000f  /* 10BASE-T type */
#define MDIO_PMA_CTRL2_2_5GBT           0x0030  /* 2.5GBaseT type */

Please make use of these.

> +/* AN 2.5G */
> +#define QCA808X_PHY_MMD7_AUTONEGOTIATION_CONTROL	0x20
> +#define QCA808X_ADVERTISE_2500FULL			BIT(7)
> +#define QCA808X_FAST_RETRAIN_2500BT			BIT(5)
> +#define QCA808X_ADV_LOOP_TIMING				BIT(0)
> +
> +/* Fast retrain related registers */
> +#define QCA808X_PHY_MMD1_FAST_RETRAIN_STATUS_CTL	0x93
> +#define QCA808X_FAST_RETRAIN_CTRL			0x1

I suspect I'm going to find that the above are standard registers
as well.

I think I'll also ask that once you've corrected the above, that you
also look to see which of the Clause 45 generic support functions you
can make use of in this driver, and switch it over to those - and then
post a revised version.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
