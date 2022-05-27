Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F321535A79
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbiE0Hci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiE0Hch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:32:37 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F37BED73E
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 00:32:34 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.191.102])
        by smtp.orange.fr with ESMTPA
        id uUSUn7gyWN260uUSUnhRNX; Fri, 27 May 2022 09:32:32 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 27 May 2022 09:32:32 +0200
X-ME-IP: 90.11.191.102
Message-ID: <a3e0df04-fb94-ef38-c2dc-1c41e6c721d9@wanadoo.fr>
Date:   Fri, 27 May 2022 09:32:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] mac80211: Directly use ida_alloc()/free()
Content-Language: en-AU
To:     liuke94@huawei.com
References: <20220527074132.2474867-1-liuke94@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org, kvalo@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220527074132.2474867-1-liuke94@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Le 27/05/2022 à 09:41, keliu a écrit :
> Use ida_alloc()/ida_free() instead of deprecated
> ida_simple_get()/ida_simple_remove() .
> 
> Signed-off-by: keliu <liuke94-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/net/wireless/mac80211_hwsim.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index e9ec63e0e395..6ad884d9e9a4 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -290,8 +290,8 @@ static inline int hwsim_net_set_netgroup(struct net *net)
>   {
>   	struct hwsim_net *hwsim_net = net_generic(net, hwsim_net_id);
>   
> -	hwsim_net->netgroup = ida_simple_get(&hwsim_netgroup_ida,
> -					     0, 0, GFP_KERNEL);
> +	hwsim_net->netgroup = ida_alloc(&hwsim_netgroup_ida,
> +					     GFP_KERNEL);
Nitpick: GFP_KERNEL should be on the same line if there is enough space 
or aligned with &hwsim_netgroup_ida


Out of curiosity, how do you generate these patches?
(coccinelle should be the perfect tool for it, but I thought it would 
already deal with alignment)

CJ

>   	return hwsim_net->netgroup >= 0 ? 0 : -ENOMEM;
>   }
>   
> @@ -4733,7 +4733,7 @@ static void __net_exit hwsim_exit_net(struct net *net)
>   					 NULL);
>   	}
>   
> -	ida_simple_remove(&hwsim_netgroup_ida, hwsim_net_get_netgroup(net));
> +	ida_free(&hwsim_netgroup_ida, hwsim_net_get_netgroup(net));
>   }
>   
>   static struct pernet_operations hwsim_net_ops = {

