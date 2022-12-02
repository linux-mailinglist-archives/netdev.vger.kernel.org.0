Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7D86407AA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiLBN2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiLBN2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:28:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FEA70632;
        Fri,  2 Dec 2022 05:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2m3rqVDrzMIruJynQ80IDuec7Tb/70QJs7xEZwcnPmM=; b=0Cq1bV1rqQcLANGpZwaM29Tv9X
        IPf2U5TodouTWDOU/Y3/1IWiIrMbja9QeXrigCCD8w2kdYIxErvdotO6IYWmkATVDXttauFc/xt5k
        L5y2kfJ09PB8af0gSG0WTJqxND+5/a6pMXDpCOwNXFk7lOdHYUj3lxmUORzV/Su+QgAc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p164t-004B2d-IA; Fri, 02 Dec 2022 14:27:43 +0100
Date:   Fri, 2 Dec 2022 14:27:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: Add driver for Motorcomm yt8531
 gigabit ethernet phy
Message-ID: <Y4n9T+KGj/hX3C0e@lunn.ch>
References: <20221202073648.3182-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202073648.3182-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static bool mdio_is_locked(struct phy_device *phydev)
> +{
> +	return mutex_is_locked(&phydev->mdio.bus->mdio_lock);
> +}
> +
> +#define ASSERT_MDIO(phydev) \
> +	WARN_ONCE(!mdio_is_locked(phydev), \
> +		  "MDIO: assertion failed at %s (%d)\n", __FILE__,  __LINE__)
> +

Hi Frank

You are not the only one who gets locking wrong. This could be used in
other drivers. Please add it to include/linux/phy.h,

>  /**
>   * ytphy_read_ext() - read a PHY's extended register
>   * @phydev: a pointer to a &struct phy_device
> @@ -258,6 +271,8 @@ static int ytphy_read_ext(struct phy_device *phydev, u16 regnum)
>  {
>  	int ret;
>  
> +	ASSERT_MDIO(phydev);
> +
>  	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
>  	if (ret < 0)
>  		return ret;
> @@ -297,6 +312,8 @@ static int ytphy_write_ext(struct phy_device *phydev, u16 regnum, u16 val)
>  {
>  	int ret;
>  
> +	ASSERT_MDIO(phydev);
> +
>  	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
>  	if (ret < 0)
>  		return ret;
> @@ -342,6 +359,8 @@ static int ytphy_modify_ext(struct phy_device *phydev, u16 regnum, u16 mask,
>  {
>  	int ret;
>  
> +	ASSERT_MDIO(phydev);
> +
>  	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
>  	if (ret < 0)
>  		return ret;
> @@ -479,6 +498,76 @@ static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
>  	return phy_restore_page(phydev, old_page, ret);
>  }

Please make the above one patch, which adds the macro and its
users. There are a couple more below as well.

Did it find any problems in the current code? Any fixes mixed
in here?

Then add yt8531 is another patch.

> +/**
> + * yt8531_set_wol() - turn wake-on-lan on or off
> + * @phydev: a pointer to a &struct phy_device
> + * @wol: a pointer to a &struct ethtool_wolinfo
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8531_set_wol(struct phy_device *phydev,
> +			  struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *p_attached_dev;
> +	const u16 mac_addr_reg[] = {
> +		YTPHY_WOL_MACADDR2_REG,
> +		YTPHY_WOL_MACADDR1_REG,
> +		YTPHY_WOL_MACADDR0_REG,
> +	};
> +	const u8 *mac_addr;
> +	u16 mask;
> +	u16 val;
> +	int ret;
> +	u8 i;
> +
> +	if (wol->wolopts & WAKE_MAGIC) {
> +		p_attached_dev = phydev->attached_dev;
> +		if (!p_attached_dev)
> +			return -ENODEV;
> +
> +		mac_addr = (const u8 *)p_attached_dev->dev_addr;

Why the cast?

> +		if (!is_valid_ether_addr(mac_addr))
> +			return -EINVAL;

  Andrew
