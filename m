Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0CE57514D
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbiGNPAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 11:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239778AbiGNPAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 11:00:23 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AE25E31B
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 08:00:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y8so2782439eda.3
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 08:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vKrYK58UXktshezn8IbaEdHAOQ3cPVz+ov56iehm62Q=;
        b=pyJdWL74iBGDMqy92j/el1zs7WWxQdDJsGJQnqc9hn4FYVLTrsETrldFhHSz48J6mv
         ugqnRjvrEiOzTof+HI5BoK9bnRVjuDEwBH7KUvjjQPheOsIo0H45lDDuIVdtI1C8+Cia
         joPr3RkKlZ3b7yiYHYAmEEFhmT81pn+JMXg27LuBRoWWzHRoNhaHWvAyPqXX3tDILtmo
         LYqtSVWN4oWQs8MM6/3BgW+gb6/uX5+3RuwfMGO1VgkJd7lQ+OiCkrBORWTQ/IWrRLvL
         cDkUed/Eh5dfs6j/1pbGdgKOHb8G/aG+DcmMSwI2mkUyJ/uRb5Ig32mJgshe+9Msa/Qa
         iinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vKrYK58UXktshezn8IbaEdHAOQ3cPVz+ov56iehm62Q=;
        b=CwU1yuQ9OUxDMUyLCr0ahK5xcxqh05VsSfivF1NHHVbi2z2F4Vcwaccrm8aSGLk+Wt
         z9ClmOtXuAi47FoDqS0wKCd6RkqAmdgQSiJZKMkOCBVuwiNY9TBmWJQJhLayZLbKjlsu
         cyDY3RQpjv2TJiWzc0CA3BDzwmS++2XXxar+UweWkoEM9yieFmp3oJhhqhUnBAW7cePm
         CwmYyr3pakh98n2njhTpCB8b5hVV9W/X/s4m3SdtiisBTYvejl/sGljPU6ELMrMStIC2
         UMbWHWpI/eljgkPpJxSXUrwa/vm/qaeasxwmvoG3HyKOAjSghn5zoizXywg09c3z+gka
         U4ZA==
X-Gm-Message-State: AJIora9xJ29V2ExfSPK/Qee/DOF/U5s4hu9LA5IjLz3dSRoPfuKipuW1
        NzB3PxWGmrzk/IecxbUwfls=
X-Google-Smtp-Source: AGRyM1sVK3ZDh7p+oHOwknshT35SKl2PPlAWAA+9YV5yamvpl4h0l9rjejx4/zvZxt3ticDASx72wA==
X-Received: by 2002:aa7:d155:0:b0:43a:bc8d:8d75 with SMTP id r21-20020aa7d155000000b0043abc8d8d75mr12819955edo.322.1657810820137;
        Thu, 14 Jul 2022 08:00:20 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id d23-20020a170906305700b0072b7d76211dsm782231ejd.107.2022.07.14.08.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 08:00:19 -0700 (PDT)
Date:   Thu, 14 Jul 2022 17:59:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Liang He <windhl@126.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: ksz_common: Fix refcount leak bug
Message-ID: <20220714145956.pnq5yulgete4xc2g@skbuf>
References: <20220713115428.367840-1-windhl@126.com>
 <20220713115428.367840-1-windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713115428.367840-1-windhl@126.com>
 <20220713115428.367840-1-windhl@126.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 07:54:28PM +0800, Liang He wrote:
> In ksz_switch_register(), we should call of_node_put() for the
> reference returned by of_get_child_by_name() which has increased
> the refcount.
> 
> Fixes: 44e53c88828f ("net: dsa: microchip: support for "ethernet-ports" node")

I disagree with the git blame resolution, it should be:

Fixes: 912aae27c6af ("net: dsa: microchip: really look for phy-mode in port nodes")

Please resend with that line changed.

> Signed-off-by: Liang He <windhl@126.com>
> ---
>  
>  drivers/net/dsa/microchip/ksz_common.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 9ca8c8d7740f..92a500e1ccd2 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -1038,18 +1038,21 @@ int ksz_switch_register(struct ksz_device *dev,
>  		ports = of_get_child_by_name(dev->dev->of_node, "ethernet-ports");
>  		if (!ports)
>  			ports = of_get_child_by_name(dev->dev->of_node, "ports");
> -		if (ports)
> +		if (ports) {
>  			for_each_available_child_of_node(ports, port) {
>  				if (of_property_read_u32(port, "reg",
>  							 &port_num))
>  					continue;
>  				if (!(dev->port_mask & BIT(port_num))) {
>  					of_node_put(port);
> +					of_node_put(ports);
>  					return -EINVAL;
>  				}
>  				of_get_phy_mode(port,
>  						&dev->ports[port_num].interface);
>  			}
> +			of_node_put(ports);
> +		}
>  		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
>  							 "microchip,synclko-125");
>  		dev->synclko_disable = of_property_read_bool(dev->dev->of_node,
> -- 
> 2.25.1
> 

