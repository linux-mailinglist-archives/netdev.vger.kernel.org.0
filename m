Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DC555755B
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiFWIZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiFWIZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:25:06 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A66F4888D
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:25:05 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 4I96oKg22NUm14I96oB4mn; Thu, 23 Jun 2022 10:25:02 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 23 Jun 2022 10:25:02 +0200
X-ME-IP: 90.11.190.129
Message-ID: <77bdb152-db01-9ad0-fc9f-a8921107a119@wanadoo.fr>
Date:   Thu, 23 Jun 2022 10:24:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: sfp: fix memory leak in sfp_probe()
Content-Language: fr
To:     Jianglei Nie <niejianglei2021@163.com>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220623070914.1781700-1-niejianglei2021@163.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220623070914.1781700-1-niejianglei2021@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 23/06/2022 à 09:09, Jianglei Nie a écrit :
> sfp_probe() allocates a memory chunk from sfp with sfp_alloc(), when
> devm_add_action() fails, sfp is not freed, which leads to a memory leak.
> 
> We should free the sfp with sfp_cleanup() when devm_add_action() fails.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>   drivers/net/phy/sfp.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 9a5d5a10560f..366a89adabf5 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -2517,8 +2517,10 @@ static int sfp_probe(struct platform_device *pdev)
>   	platform_set_drvdata(pdev, sfp);
>   
>   	err = devm_add_action(sfp->dev, sfp_cleanup, sfp);
> -	if (err < 0)
> +	if (err < 0) {
> +		sfp_cleanup(sfp);
>   		return err;
> +	}

Hi,

or use devm_add_action_or_reset() instead?

Just my 2c,

CJ

>   
>   	sff = sfp->type = &sfp_data;
>   

