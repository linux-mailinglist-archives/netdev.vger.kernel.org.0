Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A9A6CA04
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 09:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388164AbfGRHjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 03:39:14 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57953 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfGRHjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 03:39:13 -0400
Received: from soja.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:13da])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <o.rempel@pengutronix.de>)
        id 1ho10S-0002WR-Dl; Thu, 18 Jul 2019 09:39:12 +0200
Subject: Re: [PATCH] net: ag71xx: fix return value check in ag71xx_probe()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190717115225.23047-1-weiyongjun1@huawei.com>
From:   Oleksij Rempel <o.rempel@pengutronix.de>
Message-ID: <4b2983b7-7e5a-2796-1205-6039281dcdd0@pengutronix.de>
Date:   Thu, 18 Jul 2019 09:39:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717115225.23047-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:13da
X-SA-Exim-Mail-From: o.rempel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.07.19 13:52, Wei Yongjun wrote:
> In case of error, the function of_get_mac_address() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check should
> be replaced with IS_ERR().
> 
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>   drivers/net/ethernet/atheros/ag71xx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> index 72a57c6cd254..3088a43e6436 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -1732,9 +1732,9 @@ static int ag71xx_probe(struct platform_device *pdev)
>   	ag->stop_desc->next = (u32)ag->stop_desc_dma;
>   
>   	mac_addr = of_get_mac_address(np);
> -	if (mac_addr)
> +	if (!IS_ERR(mac_addr))
>   		memcpy(ndev->dev_addr, mac_addr, ETH_ALEN);
> -	if (!mac_addr || !is_valid_ether_addr(ndev->dev_addr)) {
> +	if (IS_ERR(mac_addr) || !is_valid_ether_addr(ndev->dev_addr)) {
>   		netif_err(ag, probe, ndev, "invalid MAC address, using random address\n");
>   		eth_random_addr(ndev->dev_addr);
>   	}
> 
> 
> 
> 

Kind regards,
Oleksij Rempel

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
