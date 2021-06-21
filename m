Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9843AE93B
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 14:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFUMkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 08:40:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11076 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFUMks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 08:40:48 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G7psH5P88zZh8b;
        Mon, 21 Jun 2021 20:35:31 +0800 (CST)
Received: from [10.67.101.199] (10.67.101.199) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 21 Jun 2021 20:38:30 +0800
Subject: Re: [PATCH] net: hns3: Fix a memory leak in an error handling path in
 'hclge_handle_error_info_log()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <huangguangbin2@huawei.com>, <tanhuazhong@huawei.com>,
        <moyufeng@huawei.com>, <lipeng321@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <bcf0186881d4a735fb1d356546c0cf00da40bb36.1624182453.git.christophe.jaillet@wanadoo.fr>
From:   zhangjiaran <zhangjiaran@huawei.com>
Message-ID: <af5fc070-515b-cca8-bf67-ad69b46f2ce7@huawei.com>
Date:   Mon, 21 Jun 2021 20:41:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bcf0186881d4a735fb1d356546c0cf00da40bb36.1624182453.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.101.199]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2021/6/20 17:49, Christophe JAILLET Ð´µÀ:
> If this 'kzalloc()' fails we must free some resources as in all the other
> error handling paths of this function.
> 
> Fixes: 2e2deee7618b ("net: hns3: add the RAS compatibility adaptation solution")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
> index bad9fda19398..ec9a7f8bc3fe 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
> @@ -2330,8 +2330,10 @@ int hclge_handle_error_info_log(struct hnae3_ae_dev *ae_dev)
>  	buf_size = buf_len / sizeof(u32);
>  
>  	desc_data = kzalloc(buf_len, GFP_KERNEL);
> -	if (!desc_data)
> -		return -ENOMEM;
> +	if (!desc_data) {
> +		ret = -ENOMEM;
> +		goto err_desc;
> +	}
>  
>  	buf = kzalloc(buf_len, GFP_KERNEL);
>  	if (!buf) {
> 

Reviewed-by: Jiaran Zhang <zhangjiaran@huawei.com>
