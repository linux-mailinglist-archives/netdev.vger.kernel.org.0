Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB862238BC
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 11:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgGQJxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 05:53:04 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:54006 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgGQJxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 05:53:01 -0400
X-Greylist: delayed 1582 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jul 2020 05:53:01 EDT
Received: from localhost.localdomain (p200300e9d737160bc31b0c5d63306033.dip0.t-ipconnect.de [IPv6:2003:e9:d737:160b:c31b:c5d:6330:6033])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id A38ADC0486;
        Fri, 17 Jul 2020 11:52:59 +0200 (CEST)
Subject: Re: [PATCH net-next] ieee802154: fix one possible memleak in
 adf7242_probe
To:     Liu Jian <liujian56@huawei.com>, michael.hennerich@analog.com,
        alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kjlu@umn.edu, linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20200717090121.2143-1-liujian56@huawei.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <79b20791-e78b-f2af-5355-7715aa3146b7@datenfreihafen.org>
Date:   Fri, 17 Jul 2020 11:52:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200717090121.2143-1-liujian56@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 17.07.20 11:01, Liu Jian wrote:
> When probe fail, we should destroy the workqueue.
> 
> Fixes: 2795e8c25161 ("net: ieee802154: fix a potential NULL pointer dereference")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>   drivers/net/ieee802154/adf7242.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
> index 5a37514e4234..8dbccec6ac86 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -1262,7 +1262,7 @@ static int adf7242_probe(struct spi_device *spi)
>   					     WQ_MEM_RECLAIM);
>   	if (unlikely(!lp->wqueue)) {
>   		ret = -ENOMEM;
> -		goto err_hw_init;
> +		goto err_alloc_wq;
>   	}
>   
>   	ret = adf7242_hw_init(lp);
> @@ -1294,6 +1294,8 @@ static int adf7242_probe(struct spi_device *spi)
>   	return ret;
>   
>   err_hw_init:
> +	destroy_workqueue(lp->wqueue);
> +err_alloc_wq:
>   	mutex_destroy(&lp->bmux);
>   	ieee802154_free_hw(lp->hw);
>   
> 


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
