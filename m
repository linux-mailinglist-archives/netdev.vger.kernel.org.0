Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A763C5244B0
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 07:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349198AbiELFIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 01:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349182AbiELFHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 01:07:49 -0400
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr [80.12.242.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0972BD80A3
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 22:07:45 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id p12wnPdgfuIQVp12wn4AfV; Thu, 12 May 2022 07:07:43 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 12 May 2022 07:07:43 +0200
X-ME-IP: 86.243.180.246
Message-ID: <a7d8fa72-906d-00b8-b1a8-1bbd960eae2a@wanadoo.fr>
Date:   Thu, 12 May 2022 07:07:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] net: ethernet: Use swap() instead of open coding it
Content-Language: fr
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        wellslutw@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, p.zabel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20220512032429.94306-1-jiapeng.chong@linux.alibaba.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220512032429.94306-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/05/2022 à 05:24, Jiapeng Chong a écrit :
> Clean the following coccicheck warning:
> 
> ./drivers/net/ethernet/sunplus/spl2sw_driver.c:217:27-28: WARNING
> opportunity for swap().
> 
> ./drivers/net/ethernet/sunplus/spl2sw_driver.c:222:27-28: WARNING
> opportunity for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   drivers/net/ethernet/sunplus/spl2sw_driver.c | 14 +++-----------
>   1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> index 8320fa833d3e..cccf14325ba8 100644
> --- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
> +++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> @@ -204,8 +204,6 @@ static const struct net_device_ops netdev_ops = {
>   
>   static void spl2sw_check_mac_vendor_id_and_convert(u8 *mac_addr)
>   {
> -	u8 tmp;
> -
>   	/* Byte order of MAC address of some samples are reversed.
>   	 * Check vendor id and convert byte order if it is wrong.
>   	 * OUI of Sunplus: fc:4b:bc
> @@ -213,19 +211,13 @@ static void spl2sw_check_mac_vendor_id_and_convert(u8 *mac_addr)
>   	if (mac_addr[5] == 0xfc && mac_addr[4] == 0x4b && mac_addr[3] == 0xbc &&
>   	    (mac_addr[0] != 0xfc || mac_addr[1] != 0x4b || mac_addr[2] != 0xbc)) {
>   		/* Swap mac_addr[0] and mac_addr[5] */
> -		tmp = mac_addr[0];
> -		mac_addr[0] = mac_addr[5];
> -		mac_addr[5] = tmp;
> +		swap(mac_addr[0], mac_addr[5]);

Hi,

nitpicking: the comment above the swap is now somehow useless, the code 
being clear by itself

CJ

>   
>   		/* Swap mac_addr[1] and mac_addr[4] */
> -		tmp = mac_addr[1];
> -		mac_addr[1] = mac_addr[4];
> -		mac_addr[4] = tmp;
> +		swap(mac_addr[1], mac_addr[4]);
>   
>   		/* Swap mac_addr[2] and mac_addr[3] */
> -		tmp = mac_addr[2];
> -		mac_addr[2] = mac_addr[3];
> -		mac_addr[3] = tmp;
> +		swap(mac_addr[2], mac_addr[3]);
>   	}
>   }
>   

