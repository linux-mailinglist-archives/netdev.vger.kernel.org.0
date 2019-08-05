Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA218201D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfHEP2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:28:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbfHEP2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 11:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i1UVO/cNdQzQGNtCSgGelcu02jpY/mg7+r1uSOQCzI8=; b=Ss58XvFHgvOpHFVAAZKk6f7lbz
        gmRUzMNdJG202xX26oPNRAa61YNJB+b7AxhS9/5xcg59UsHZt6Szwy6BR5y1MGitISVxZ4eUiWrwj
        goxLQ0SP1Y70nGM52iqa3JsJlJJR3wy0//WpqNolgGmG+D029Kc72hgvqGkrlsS0N4bI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hueuW-0007vG-UU; Mon, 05 Aug 2019 17:28:32 +0200
Date:   Mon, 5 Aug 2019 17:28:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 15/16] net: phy: adin: add ethtool get_stats support
Message-ID: <20190805152832.GT24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-16-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-16-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct adin_hw_stat {
> +	const char *string;

> +static void adin_get_strings(struct phy_device *phydev, u8 *data)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(adin_hw_stats); i++) {
> +		memcpy(data + i * ETH_GSTRING_LEN,
> +		       adin_hw_stats[i].string, ETH_GSTRING_LEN);

You define string as a char *. So it will be only as long as it should
be. However memcpy always copies ETH_GSTRING_LEN bytes, doing off the
end of the string and into whatever follows.


> +	}
> +}
> +
> +static int adin_read_mmd_stat_regs(struct phy_device *phydev,
> +				   struct adin_hw_stat *stat,
> +				   u32 *val)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, stat->reg1);
> +	if (ret < 0)
> +		return ret;
> +
> +	*val = (ret & 0xffff);
> +
> +	if (stat->reg2 == 0)
> +		return 0;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, stat->reg2);
> +	if (ret < 0)
> +		return ret;
> +
> +	*val <<= 16;
> +	*val |= (ret & 0xffff);

Does the hardware have a snapshot feature? Is there a danger that
between the two reads stat->reg1 rolls over and you end up with too
big a value?

    Andrew
