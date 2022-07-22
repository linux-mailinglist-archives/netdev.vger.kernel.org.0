Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A20457E033
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiGVKqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 06:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiGVKqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 06:46:05 -0400
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 390489D527
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 03:46:04 -0700 (PDT)
Received: from unknown (HELO kinkan2-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 22 Jul 2022 19:46:03 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan2-ex.css.socionext.com (Postfix) with ESMTP id 15A542059027;
        Fri, 22 Jul 2022 19:46:03 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Fri, 22 Jul 2022 19:46:03 +0900
Received: from [10.212.180.8] (unknown [10.212.180.8])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 512D6B62A4;
        Fri, 22 Jul 2022 19:46:02 +0900 (JST)
Subject: Re: [PATCH 1/1] drivers/net/ethernet: fix a memory leak
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>
References: <20220722043327.2259-1-ruc_gongyuanjun@163.com>
Cc:     netdev@vger.kernel.org
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Message-ID: <190b317a-8a32-f1bc-a741-5e7745da962d@socionext.com>
Date:   Fri, 22 Jul 2022 19:46:01 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20220722043327.2259-1-ruc_gongyuanjun@163.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/07/22 13:33, Yuanjun Gong wrote:
> In ave_remove, ndev should be freed with free_netdev before return.
> 
> Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
> ---
>   drivers/net/ethernet/socionext/sni_ave.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/socionext/sni_ave.c
> b/drivers/net/ethernet/socionext/sni_ave.c
> index f0c8de2c6075..9d1c1cdd04af 100644
> --- a/drivers/net/ethernet/socionext/sni_ave.c
> +++ b/drivers/net/ethernet/socionext/sni_ave.c
> @@ -1725,6 +1725,7 @@ static int ave_remove(struct platform_device *pdev)
>   	unregister_netdev(ndev);
>   	netif_napi_del(&priv->napi_rx);
>   	netif_napi_del(&priv->napi_tx);
> +	free_netdev(ndev);

This ave driver uses devm_allocate_etherdev() to allocate "ndev".
It will be released automatically when removing the driver.
Therefore, it is not necessary to release it explicitly.

Please refer to the commit e87fb82ddc3b
("net: ethernet: ave: Replace alloc_etherdev() with devm_alloc_etherdev()").

Thank you,

>   
>   	return 0;
>   }
>
---
Best Regards
Kunihiko Hayashi
