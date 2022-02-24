Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC14C29DD
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 11:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiBXKtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 05:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiBXKtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 05:49:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD4828F449;
        Thu, 24 Feb 2022 02:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DHfeWxZM5od8+wIqpgu49Fi5h35EJ/VJbFoorSgpe+c=; b=tTNeJSSlDsibFzOAG2sA7Pa90I
        tKvFbL32Dib3iCNdLaMZFKV05OiqgDXQ5njuAUm8hj6QbQUQaZAZTWHeHV/7WvU8vX6+jh0almzeX
        stLNXGXolTYhv33hNZWKhRBdZIeAm/I9Mdf1PmTuH48JgQ0jqgsKrERYgyj6eQCuCMmnj3SJf8Z2F
        OJjGqYmOffCZ1fNaUFkYKg7eQ2LI0TA8sljpPeqrk+KXPbiWErSKH5ivUsFnJnwGvmpXPRMnrkuB3
        rX+fLrk8nx+t785M74dE1ZRC7UbVCyCYgBhkH0X3wZiDGyy5Qo5HOqIT601eRLF/cGMXgHB0xbSJ0
        w9bmD5Ow==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57456)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNBgC-0003rP-6d; Thu, 24 Feb 2022 10:49:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNBg9-0001y3-Uw; Thu, 24 Feb 2022 10:48:57 +0000
Date:   Thu, 24 Feb 2022 10:48:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Raag Jadav <raagjadav@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <YhdimdT1qLdGqPAW@shell.armlinux.org.uk>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the late comment on this patch.

On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> +static int vsc85xx_config_inband_aneg(struct phy_device *phydev, bool enabled)
> +{
> +	int rc;
> +	u16 reg_val = 0;
> +
> +	if (enabled)
> +		reg_val = MSCC_PHY_SERDES_ANEG;
> +
> +	mutex_lock(&phydev->lock);
> +
> +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
> +			      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
> +			      reg_val);
> +
> +	mutex_unlock(&phydev->lock);

What is the reason for the locking here?

phy_modify_paged() itself is safe due to the MDIO bus lock, so you
shouldn't need locking around it.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
