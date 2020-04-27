Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D461BA82E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgD0Pjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:39:49 -0400
Received: from vern.gendns.com ([98.142.107.122]:52338 "EHLO vern.gendns.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgD0Pjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 11:39:49 -0400
X-Greylist: delayed 1376 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2020 11:39:48 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lechnology.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QHcTOnBrhJ/2TSsv8KnCgPSUCn9klev6fyOnjkLTQHA=; b=rGNlRJBO+DFlpwE/cFAxf47YpC
        Crudz6L19IvS2rmXE+NPnZV34i3SJpslbDIeXTiScO+gJERn4bj222hhlo2ZVeX9Xqp/yb+tC0RsD
        KtpRaC036DJlVOpt/oYYGoEF66ZRG8cWD+TmjJOfVDQlhLgDmYgY2vRSJlK685kXl8LKJde/Ha8ov
        LmoAKhxoesIDGNVN/awVBG+NVetaRoML1GwZMKq7Nc5K6HPu4JKaRSFRNf7TPzNr3KWIKMY9Ogk19
        UB7AwK3EzDO6iNGqncyGcgqcicsbKXS+Fe/YzYqkDZQXyDPiz2dMDm2FINNvf8NNb9N3nMH71VZP/
        MWpjIcYQ==;
Received: from 108-198-5-147.lightspeed.okcbok.sbcglobal.net ([108.198.5.147]:52234 helo=[192.168.0.134])
        by vern.gendns.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <david@lechnology.com>)
        id 1jT5V4-0007tU-5Z; Mon, 27 Apr 2020 11:16:50 -0400
Subject: Re: [PATCH net-next] drivers: net: davinci_mdio: fix potential NULL
 dereference in davinci_mdio_probe()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200427094032.181184-1-weiyongjun1@huawei.com>
From:   David Lechner <david@lechnology.com>
Message-ID: <d2c55de2-01f0-b123-dee6-5fc74b8b67da@lechnology.com>
Date:   Mon, 27 Apr 2020 10:16:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427094032.181184-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - vern.gendns.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lechnology.com
X-Get-Message-Sender-Via: vern.gendns.com: authenticated_id: davidmain+lechnology.com/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: vern.gendns.com: davidmain@lechnology.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 4:40 AM, Wei Yongjun wrote:
> platform_get_resource() may fail and return NULL, so we should
> better check it's return value to avoid a NULL pointer dereference
> a bit later in the code.
> 
> This is detected by Coccinelle semantic patch.
> 
> @@
> expression pdev, res, n, t, e, e1, e2;
> @@
> 
> res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t, n);
> + if (!res)
> +   return -EINVAL;
> ... when != res == NULL
> e = devm_ioremap(e1, res->start, e2);
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   drivers/net/ethernet/ti/davinci_mdio.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
> index 38b7f6d35759..702fdc393da0 100644
> --- a/drivers/net/ethernet/ti/davinci_mdio.c
> +++ b/drivers/net/ethernet/ti/davinci_mdio.c
> @@ -397,6 +397,8 @@ static int davinci_mdio_probe(struct platform_device *pdev)
>   	data->dev = dev;
>   
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -EINVAL;
>   	data->regs = devm_ioremap(dev, res->start, resource_size(res));
>   	if (!data->regs)
>   		return -ENOMEM;
> 

Could we use devm_platform_ioremap_resource() instead?
