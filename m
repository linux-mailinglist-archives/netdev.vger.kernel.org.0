Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C7A387E0D
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 18:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351026AbhERQ6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 12:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351023AbhERQ6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 12:58:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47BCC06138D;
        Tue, 18 May 2021 09:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=Uek9W6UDsSluuzmCVIzlQCqVL+k1cBOnDRIUuoXcj4A=; b=Ei1g9cZmY2NJwnl/mfL7fXrMW3
        2P1vLQcLtVUB51GCSNWZJ1GrNPlayjkdKjjLMfVnwH2veCEvNQm92eZPkgqhfEU8nkmEnG7UPi8PF
        U4qeuXGaZ69PqTYGYTkjqzsYo3kHWDJ1sfSnkBngbuG3MX6PdPKAI9SfAJs9PIv+Nr7gDdQ5EEv7v
        S7RuLUUtOJH8pP/AvQmekUoiuJVo/CxMrXcY+W5XFMN52NGOie3QX2sKEAxdTYeuUM5UxfS9wdtdk
        qH3xCCMnslCfOHxbttNomGTR6AO+YP3oxHX3fHy71rjCFNoRcwo8WLOFu1yKwJA09F1agBLnRr6Fz
        vJM+qodA==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lj31v-00Ep2t-05; Tue, 18 May 2021 16:57:15 +0000
Subject: Re: linux-next: Tree for May 18 (drivers/net/dsa/qca8k.c)
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20210518192729.3131eab0@canb.auug.org.au>
 <785e9083-174e-5287-8ad0-1b5b842e2282@infradead.org>
 <20210518164348.vbuxaqg4s3mwzp4e@skbuf>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1e431580-37e5-dc80-8307-eb79125f9b75@infradead.org>
Date:   Tue, 18 May 2021 09:57:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210518164348.vbuxaqg4s3mwzp4e@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/21 9:43 AM, Vladimir Oltean wrote:
> Hi Randy,
> 
> Would something like this work?
> 
> -----------------------------[ cut here ]-----------------------------
> From 36c0b3f04ebfa51e52bd1bc2dc447d12d1c6e119 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Tue, 18 May 2021 19:39:18 +0300
> Subject: [PATCH] net: mdio: provide shim implementation of
>  devm_of_mdiobus_register
> 
> Similar to the way in which of_mdiobus_register() has a fallback to the
> non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
> a shim for the device-managed devm_of_mdiobus_register() which calls
> devm_mdiobus_register() and discards the struct device_node *.
> 
> In particular, this solves a build issue with the qca8k DSA driver which
> uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  include/linux/of_mdio.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
> index 2b05e7f7c238..da633d34ab86 100644
> --- a/include/linux/of_mdio.h
> +++ b/include/linux/of_mdio.h
> @@ -72,6 +72,13 @@ static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *
>  	return mdiobus_register(mdio);
>  }
>  
> +static inline int devm_of_mdiobus_register(struct device *dev,
> +					   struct mii_bus *mdio,
> +					   struct device_node *np)
> +{
> +	return devm_mdiobus_register(dev, mdio);
> +}
> +
>  static inline struct mdio_device *of_mdio_find_device(struct device_node *np)
>  {
>  	return NULL;
> -----------------------------[ cut here ]-----------------------------
> 

Yes, that's all good. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

-- 
~Randy

