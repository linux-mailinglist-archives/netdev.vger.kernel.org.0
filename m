Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F90C5A3808
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 16:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiH0OAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 10:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiH0OAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 10:00:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B213CBE1;
        Sat, 27 Aug 2022 07:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sRY9Lvm32oZf9puND7vNB48KjN2OdsZnXnej1QKkQvQ=; b=kE1DG1iKZ91NJkGgSYyipimjRt
        wNfkddl+Sau0+NcVA6+Z3X5PhCOYP7BizDcdAIa1Cd15urqV4xhrVOaUfeH8SAhChlrg8HCFF84Qv
        uCysoqpIpj4p+/zUrNm27MjHq90cU1S0ISlk+JDQrEEoeDph8ulaA4ZfkBxWhMAUtEpg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRwMa-00EmOv-KR; Sat, 27 Aug 2022 16:00:40 +0200
Date:   Sat, 27 Aug 2022 16:00:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [net-next PATCH v2] net: dsa: qca8k: convert to regmap
 read/write API
Message-ID: <YwojiJdIsz/qL1XC@lunn.ch>
References: <20220827114918.8863-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827114918.8863-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static struct regmap_config qca8k_regmap_config = {
> -	.reg_bits = 16,
> +	.reg_bits = 32,

Does this change really allow you to access more registers? 

>  	.val_bits = 32,
>  	.reg_stride = 4,
>  	.max_register = 0x16ac, /* end MIB - Port6 range */
> -	.reg_read = qca8k_regmap_read,
> -	.reg_write = qca8k_regmap_write,
> +	.read = qca8k_bulk_read,
> +	.write = qca8k_bulk_write,
>  	.reg_update_bits = qca8k_regmap_update_bits,
>  	.rd_table = &qca8k_readable_table,
>  	.disable_locking = true, /* Locking is handled by qca8k read/write */
>  	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
> +	.max_raw_read = 16, /* mgmt eth can read/write up to 4 bytes at times */
> +	.max_raw_write = 16,

I think the word 'bytes' in the comment is wrong. I assume you can
access 4 registers, each register is one 32-bit work in size.

>  static int qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
>  {
> -	u32 reg[3];
> +	u32 reg[QCA8K_ATU_TABLE_SIZE];
>  	int ret;
>  
>  	/* load the ARL table into an array */
> -	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
> +	ret = regmap_bulk_read(priv->regmap, QCA8K_REG_ATU_DATA0, reg,
> +			       QCA8K_ATU_TABLE_SIZE);
>  	if (ret)
>  		return ret;

Please split the 3 -> QCA8K_ATU_TABLE_SIZE change out into a patch of
its own.

Ideally you want lots of small, obviously correct patches. A change
which replaces 3 for QCA8K_ATU_TABLE_SIZE should be small and
obviously correct, meaning it is quick and easy to review, and makes
the more complex to review change smaller and also simpler to review.

    Andrew
