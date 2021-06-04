Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF8839B6BD
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 12:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhFDKJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 06:09:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3061 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFDKJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 06:09:06 -0400
Received: from dggeml759-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FxJGd5fkgzWrPT;
        Fri,  4 Jun 2021 18:02:33 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 4 Jun 2021 18:07:18 +0800
Subject: Re: [PATCH net-next] net: mscc: ocelot: check return value after
 calling platform_get_resource()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <20210604093234.3408625-1-yangyingliang@huawei.com>
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
Message-ID: <3592374c-4dd9-c489-bb5f-bd6ee0f942b6@huawei.com>
Date:   Fri, 4 Jun 2021 18:07:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210604093234.3408625-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   drivers/net/dsa/ocelot/seville_vsc9953.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index 84f93a874d50..b514e2d05b6f 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1206,6 +1206,10 @@ static int seville_probe(struct platform_device *pdev)
>   	felix->info = &seville_info_vsc9953;
>   
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		err = -EINVAL;
> +		dev_err(&pdev->dev, "Invalid resource\n");


should 'goto err_alloc_felix;'


> +	}
>   	felix->switch_base = res->start;
>   
>   	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
