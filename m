Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F387B69C3BE
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 01:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjBTAyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 19:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBTAyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 19:54:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606F5C662;
        Sun, 19 Feb 2023 16:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5rWrJp0Cn073TtNCs5tPbw4GqVbeTmduP4mZBEZzKKQ=; b=c6zkFLI8NpbBt1B4srVKO+UNBK
        jOMZZ8h+W7MhtkhDFRKz11+vHOqESTlcse3vaZviro0Mi3pNEOvyzcknK7Sp8p4B9e6TBUrjnVmVu
        UKpHZIJVBRW58rPtf4IUS42DoL8w6aJKDL/9XoMS9K220Uu0q5FzyZAhzPpM+SjZ9laU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTuS5-005Sxp-P2; Mon, 20 Feb 2023 01:54:45 +0100
Date:   Mon, 20 Feb 2023 01:54:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH net-next v2] net: phy: micrel: Add support for
 PTP_PF_PEROUT for lan8841
Message-ID: <Y/LE1SzlpKcWHAti@lunn.ch>
References: <20230218123038.2761383-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218123038.2761383-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int lan8841_ptp_set_target(struct kszphy_ptp_priv *ptp_priv, u8 event,
> +				  s64 sec, u32 nsec)
> +{
> +	struct phy_device *phydev = ptp_priv->phydev;
> +	int ret;
> +
> +	ret = phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_TARGET_SEC_HI(event),
> +			    upper_16_bits(sec));
> +	ret |= phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_TARGET_SEC_LO(event),
> +			     lower_16_bits(sec));
> +	ret |= phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_TARGET_NS_HI(event) & 0x3fff,
> +			     upper_16_bits(nsec));
> +	ret |= phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_TARGET_NS_LO(event),
> +			     lower_16_bits(nsec));

ORing together error codes generally does not work. MDIO transactions
can sometimes give ETIMEDOUT, or EINVAL. Combine those and i think you
get ENOKEY, which is going to be interesting to track down.

    Andrew
