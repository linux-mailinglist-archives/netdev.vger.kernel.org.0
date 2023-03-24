Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FFF6C7DBB
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbjCXMJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjCXMJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:09:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7821799;
        Fri, 24 Mar 2023 05:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qRTDcSPE3HPmUfIxEpIUzqke0zqXoLOS94joWEAwtU4=; b=1UrjijkPTq+KTeI1ypV+Q0PmdO
        LP7H6vFJNTWXagLUXC+JDP0Yqe+clgTSs73SI/pXT2X5UfhDc7kfPBrJrE/nnGdDv+3Yqo8WPc/Jg
        cq8yUmVKH87OIUbb8ov2NU5lXgSZ9pxlkgc7zDpXzvhUungh0j1KEL2gD/bANp5Ddafk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pfgDv-008Hxo-6S; Fri, 24 Mar 2023 13:08:47 +0100
Date:   Fri, 24 Mar 2023 13:08:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 3/7] regmap: allow upshifting register addresses before
 performing operations
Message-ID: <ec1331cc-2393-4ac9-88f6-bae6c31c9641@lunn.ch>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-4-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324093644.464704-4-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> index da8996e7a1f1..2ef53936652b 100644
> --- a/drivers/base/regmap/internal.h
> +++ b/drivers/base/regmap/internal.h
> @@ -31,7 +31,7 @@ struct regmap_format {
>  	size_t buf_size;
>  	size_t reg_bytes;
>  	size_t pad_bytes;
> -	size_t reg_downshift;
> +	int reg_shift;

Maybe ssize_t to keep with the pattern of using size_t. However,
ssize_t is somewhat over sized for a bit shift. So maybe just s8?

>  	size_t val_bytes;
>  	void (*format_write)(struct regmap *map,
>  			     unsigned int reg, unsigned int val);
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 726f59612fd6..c4cde4f45b05 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -814,7 +814,7 @@ struct regmap *__regmap_init(struct device *dev,
>  
>  	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
>  	map->format.pad_bytes = config->pad_bits / 8;
> -	map->format.reg_downshift = config->reg_downshift;
> +	map->format.reg_shift = config->reg_shift;
>  	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
>  	map->format.buf_size = DIV_ROUND_UP(config->reg_bits +
>  			config->val_bits + config->pad_bits, 8);
> @@ -1679,7 +1679,13 @@ static void regmap_set_work_buf_flag_mask(struct regmap *map, int max_bytes,
>  static unsigned int regmap_reg_addr(struct regmap *map, unsigned int reg)
>  {
>  	reg += map->reg_base;
> -	return reg >> map->format.reg_downshift;
> +
> +	if (map->format.reg_shift > 0)
> +		reg >>= map->format.reg_shift;
> +	else if (map->format.reg_shift < 0)
> +		reg <<= -(map->format.reg_shift);

I was wondering about negative shifts. It is apparently undefined
behaviour. So this construct is required.

	   Andrew
