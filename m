Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0668E8AF
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbfHOJ7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:59:20 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3532 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730301AbfHOJ7U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 05:59:20 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 18E48AF2437409F19D7B;
        Thu, 15 Aug 2019 17:59:18 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 15 Aug 2019 17:59:17 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 15
 Aug 2019 17:59:17 +0800
Subject: Re: [PATCH] net: hns: hns_enet: Add of_node_put in
 hns_nic_dev_probe()
To:     Nishka Dasgupta <nishkadg.linux@gmail.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <20190815062837.6015-1-nishkadg.linux@gmail.com>
From:   Yonglong Liu <liuyonglong@huawei.com>
Message-ID: <857ab233-b983-bb99-ae0e-107560d67af1@huawei.com>
Date:   Thu, 15 Aug 2019 17:59:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190815062837.6015-1-nishkadg.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/15 14:28, Nishka Dasgupta wrote:
> The local variable ae_node in function hns_nic_dev_probe takes the
> return value of of_parse_phandle, which gets a node but does not put it.
> This may cause a memory leak. Hence put ae_node after the last time it
> is invoked.
> Issue found with Coccinelle.
> 
> Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
> ---
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> index 2235dd55fab2..b26e84929e1e 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> @@ -2309,6 +2309,7 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
>  			goto out_read_prop_fail;
>  		}
>  		priv->fwnode = &ae_node->fwnode;
> +		of_node_put(ae_node);
>  	} else if (is_acpi_node(dev->fwnode)) {
>  		struct fwnode_reference_args args;
>  
> 

Hi, Nishka:
This patch is wrong, we put the node in hns_nic_dev_remove().

The following patch had solved this problem:
263c6d75f9a5 (net: hns: Fix for missing of_node_put() after of_parse_phandle())

