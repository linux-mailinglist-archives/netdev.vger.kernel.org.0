Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85C8641E96
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 19:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiLDSMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 13:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiLDSML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 13:12:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9660A11149;
        Sun,  4 Dec 2022 10:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pNpSIjrPHu2XuHRkXM+DZlFuYn+Q9k1ix/5mVSzNS1M=; b=RQeCL75pnV+jtEYcOLfN1SmQiR
        3MMItYj8BCAIiXI+i2MzPPlKSju/j4QtjiiLboVZnuCguDJL+mF1UKyCHU0SuTaU6n9ymclRcUGz+
        3V7IfM6hUjnr2HwbEg8IJ4/QL7NaoFjuuqshOjmiY5TZQuBB9ySadUwtjBI1J64NRb0k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1tT9-004Kr8-DE; Sun, 04 Dec 2022 19:12:03 +0100
Date:   Sun, 4 Dec 2022 19:12:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 2/4] phylib: Add support for 10BASE-T1S link
 modes and PLCA config
Message-ID: <Y4zi8ySOlmKP0kgg@lunn.ch>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <b2fffe32ffb0f6a6b4547e2e115bfad6c1139f70.1670119328.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2fffe32ffb0f6a6b4547e2e115bfad6c1139f70.1670119328.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 03:30:52AM +0100, Piergiorgio Beruto wrote:
> This patch adds the required connection between netlink ethtool and
> phylib to resolve PLCA get/set config and get status messages.
> Additionally, it adds the link modes for the IEEE 802.3cg Clause 147
> 10BASE-T1S Ethernet PHY.

Please break this patch up.

>  const char *phy_speed_to_str(int speed)
>  {
> -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 99,
> +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 102,
>  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
>  		"If a speed or mode has been added please update phy_speed_to_str "
>  		"and the PHY settings array.\n");

> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1741,6 +1741,9 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_800000baseDR8_2_Full_BIT	 = 96,
>  	ETHTOOL_LINK_MODE_800000baseSR8_Full_BIT	 = 97,
>  	ETHTOOL_LINK_MODE_800000baseVR8_Full_BIT	 = 98,
> +	ETHTOOL_LINK_MODE_10baseT1S_Full_BIT		 = 99,
> +	ETHTOOL_LINK_MODE_10baseT1S_Half_BIT		 = 100,
> +	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT	 = 101,
>  
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 21cfe8557205..c586db0c5e68 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -208,6 +208,9 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
>  	__DEFINE_LINK_MODE_NAME(800000, DR8_2, Full),
>  	__DEFINE_LINK_MODE_NAME(800000, SR8, Full),
>  	__DEFINE_LINK_MODE_NAME(800000, VR8, Full),
> +	__DEFINE_LINK_MODE_NAME(10, T1S, Full),
> +	__DEFINE_LINK_MODE_NAME(10, T1S, Half),
> +	__DEFINE_LINK_MODE_NAME(10, T1S_P2MP, Half),
>  };
>  static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
>  
> @@ -366,6 +371,9 @@ const struct link_mode_info link_mode_params[] = {
>  	__DEFINE_LINK_MODE_PARAMS(800000, DR8_2, Full),
>  	__DEFINE_LINK_MODE_PARAMS(800000, SR8, Full),
>  	__DEFINE_LINK_MODE_PARAMS(800000, VR8, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10, T1S, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10, T1S, Half),
> +	__DEFINE_LINK_MODE_PARAMS(10, T1S_P2MP, Half),
>  };
>  static_assert(ARRAY_SIZE(link_mode_params) == __ETHTOOL_LINK_MODE_MASK_NBITS);

This is one logical change, so makes one patch, for example.

You are aiming for lots of simple, easy to review, well described,
obviously correct patches.

     Andrew
