Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E5A535A8D
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347826AbiE0Hf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347935AbiE0Hfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:35:52 -0400
Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117E4FC4FB
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 00:35:42 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.191.102])
        by smtp.orange.fr with ESMTPA
        id uUVRn5MANL5fDuUVRnlyEw; Fri, 27 May 2022 09:35:41 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 27 May 2022 09:35:41 +0200
X-ME-IP: 90.11.191.102
Message-ID: <131a9514-8ca6-eac2-ba4f-9fafca21e5b4@wanadoo.fr>
Date:   Fri, 27 May 2022 09:35:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: phy: Directly use ida_alloc()/free()
Content-Language: fr
To:     keliu <liuke94@huawei.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220527074000.2474792-1-liuke94@huawei.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220527074000.2474792-1-liuke94@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Le 27/05/2022 à 09:40, keliu a écrit :
> Use ida_alloc()/ida_free() instead of deprecated
> ida_simple_get()/ida_simple_remove() .
> 
> Signed-off-by: keliu <liuke94@huawei.com>
> ---
>   drivers/net/phy/fixed_phy.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
> index c65fb5f5d2dc..63e7922bf257 100644
> --- a/drivers/net/phy/fixed_phy.c
> +++ b/drivers/net/phy/fixed_phy.c
> @@ -180,7 +180,7 @@ static void fixed_phy_del(int phy_addr)
>   			if (fp->link_gpiod)
>   				gpiod_put(fp->link_gpiod);
>   			kfree(fp);
> -			ida_simple_remove(&phy_fixed_ida, phy_addr);
> +			ida_free(&phy_fixed_ida, phy_addr);
>   			return;
>   		}
>   	}
> @@ -250,7 +250,7 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
>   
>   	ret = fixed_phy_add_gpiod(irq, phy_addr, status, gpiod);
>   	if (ret < 0) {
> -		ida_simple_remove(&phy_fixed_ida, phy_addr);
> +		ida_free(&phy_fixed_ida, phy_addr);
>   		return ERR_PTR(ret);
>   	}
>   

Hi,

You missed ida_simple_get() that shoud become ida_alloc_max() here.

CJ
