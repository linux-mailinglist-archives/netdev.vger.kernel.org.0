Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A27590C55
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 09:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbiHLHOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 03:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbiHLHOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 03:14:44 -0400
Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3EB32D90
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 00:14:39 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id MOsNovEvhsfCIMOsNocAyy; Fri, 12 Aug 2022 09:14:37 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 12 Aug 2022 09:14:37 +0200
X-ME-IP: 90.11.190.129
Message-ID: <7c3dda38-d741-8f5e-a034-b4678ed79fc0@wanadoo.fr>
Date:   Fri, 12 Aug 2022 09:14:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] bonding: return -ENOMEM on rlb_initialize() allocation
 failure
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        j.vosburgh@gmail.com
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20220812032059.64572-1-jiapeng.chong@linux.alibaba.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220812032059.64572-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/08/2022 à 05:20, Jiapeng Chong a écrit :
> drivers/net/bonding/bond_alb.c:861 rlb_initialize() warn: returning -1 instead of -ENOMEM is sloppy.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=1896
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   drivers/net/bonding/bond_alb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 60cb9a0225aa..96cb4404b3c7 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -858,7 +858,7 @@ static int rlb_initialize(struct bonding *bond)
>   
>   	new_hashtbl = kmalloc(size, GFP_KERNEL);
>   	if (!new_hashtbl)
> -		return -1;
> +		return -ENOMEM;
>   
>   	spin_lock_bh(&bond->mode_lock);
>   

Hi,

Nit: if of any use, the only call chain leads to [1]:
bond_open()
--> bond_alb_initialize()
   --> rlb_initialize()

So, the error in bond_open() could be changed to ret instead of a hard 
coded -ENOMEM.

Just my 2c,


Other than that, for what it worth,
Reviewed-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

CJ

[1]: 
https://elixir.bootlin.com/linux/v5.19/source/drivers/net/bonding/bond_main.c#L4163
