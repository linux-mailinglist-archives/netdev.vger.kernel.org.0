Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F415442F6
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 07:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbiFIFLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 01:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236935AbiFIFLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 01:11:20 -0400
Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335271A812
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 22:11:17 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id zARunuQ5DJcJLzARunCJhr; Thu, 09 Jun 2022 07:11:15 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 09 Jun 2022 07:11:15 +0200
X-ME-IP: 90.11.190.129
Message-ID: <0ad7ff2c-a5ad-1e5f-b186-0a43ce55057c@wanadoo.fr>
Date:   Thu, 9 Jun 2022 07:11:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 2/2] nfp: flower: Remove usage of the deprecated
 ida_simple_xxx API
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
References: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
 <721abecd2f40bed319ab9fb3feebbea8431b73ed.1644532467.git.christophe.jaillet@wanadoo.fr>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <721abecd2f40bed319ab9fb3feebbea8431b73ed.1644532467.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 10/02/2022 à 23:35, Christophe JAILLET a écrit :
> Use ida_alloc_xxx()/ida_free() instead to
> ida_simple_get()/ida_simple_remove().
> The latter is deprecated and more verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   .../net/ethernet/netronome/nfp/flower/tunnel_conf.c    | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> index 9244b35e3855..c71bd555f482 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> @@ -942,8 +942,8 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
>   	if (!nfp_mac_idx) {
>   		/* Assign a global index if non-repr or MAC is now shared. */
>   		if (entry || !port) {
> -			ida_idx = ida_simple_get(&priv->tun.mac_off_ids, 0,
> -						 NFP_MAX_MAC_INDEX, GFP_KERNEL);
> +			ida_idx = ida_alloc_max(&priv->tun.mac_off_ids,
> +						NFP_MAX_MAC_INDEX, GFP_KERNEL);
>   			if (ida_idx < 0)
>   				return ida_idx;
>   
> @@ -998,7 +998,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
>   	kfree(entry);
>   err_free_ida:
>   	if (ida_idx != -1)
> -		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
> +		ida_free(&priv->tun.mac_off_ids, ida_idx);
>   
>   	return err;
>   }
> @@ -1061,7 +1061,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
>   		}
>   
>   		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
> -		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
> +		ida_free(&priv->tun.mac_off_ids, ida_idx);
>   		entry->index = nfp_mac_idx;
>   		return 0;
>   	}
> @@ -1081,7 +1081,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
>   	/* If MAC has global ID then extract and free the ida entry. */
>   	if (nfp_tunnel_is_mac_idx_global(nfp_mac_idx)) {
>   		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
> -		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
> +		ida_free(&priv->tun.mac_off_ids, ida_idx);
>   	}
>   
>   	kfree(entry);

Hi,

This has been merged in -next in commit 432509013f66 but for some reason 
I looked at it again.


I just wanted to point out that this patch DOES change the behavior of 
the driver because ida_simple_get() is exclusive of the upper bound, 
while ida_alloc_max() is inclusive.

So, knowing that NFP_MAX_MAC_INDEX = 0xff = 255, with the previous code 
'ida_idx' was 0 ... 254.
Now it is 0 ... 255.

This still looks good to me, because NFP_MAX_MAC_INDEX is still not a 
power of 2.


But if 255 is a reserved value for whatever reason, then this patch has 
introduced a bug (apologies for it).

The change of behavior should have been mentioned in the commit 
description. So I wanted to make sure you was aware in case a follow-up 
fix is needed.

CJ
