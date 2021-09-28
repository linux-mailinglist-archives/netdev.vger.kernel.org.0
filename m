Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9D841AAA7
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 10:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbhI1Ifz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 04:35:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13362 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbhI1Ify (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 04:35:54 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HJXjq4wpPz8ynb;
        Tue, 28 Sep 2021 16:29:35 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 16:34:13 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 28 Sep
 2021 16:34:12 +0800
Subject: Re: [PATCH] net: hns3: fix hclge_dbg_dump_tm_pg() stack usage
To:     Arnd Bergmann <arnd@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        "Jian Shen" <shenjian15@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210927095006.868305-1-arnd@kernel.org>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <bd4871e4-62e6-2cb2-26be-34bda8dcb7dd@huawei.com>
Date:   Tue, 28 Sep 2021 16:34:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210927095006.868305-1-arnd@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/27 17:49, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This function copies strings around between multiple buffers
> including a large on-stack array that causes a build warning
> on 32-bit systems:
> 
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c: In function 'hclge_dbg_dump_tm_pg':
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:782:1: error: the frame size of 1424 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]
> 
> The function can probably be cleaned up a lot, to go back to
> printing directly into the output buffer, but dynamically allocating
> the structure is a simpler workaround for now.
> 
> Fixes: 04d96139ddb3 ("net: hns3: refine function hclge_dbg_dump_tm_pri()")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 26 ++++++++++++++++---
>   1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
> index 87d96f82c318..3ed87814100a 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
> @@ -719,9 +719,9 @@ static void hclge_dbg_fill_shaper_content(struct hclge_tm_shaper_para *para,
>   	sprintf(result[(*index)++], "%6u", para->rate);
>   }
>   
> -static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
> +static int __hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *data_str,
> +				  char *buf, int len)
>   {
> -	char data_str[ARRAY_SIZE(tm_pg_items)][HCLGE_DBG_DATA_STR_LEN];
>   	struct hclge_tm_shaper_para c_shaper_para, p_shaper_para;
>   	char *result[ARRAY_SIZE(tm_pg_items)], *sch_mode_str;
>   	u8 pg_id, sch_mode, weight, pri_bit_map, i, j;
> @@ -729,8 +729,10 @@ static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
>   	int pos = 0;
>   	int ret;
>   
> -	for (i = 0; i < ARRAY_SIZE(tm_pg_items); i++)
> -		result[i] = &data_str[i][0];
> +	for (i = 0; i < ARRAY_SIZE(tm_pg_items); i++) {
> +		result[i] = data_str;
> +		data_str += HCLGE_DBG_DATA_STR_LEN;
> +	}
>   
>   	hclge_dbg_fill_content(content, sizeof(content), tm_pg_items,
>   			       NULL, ARRAY_SIZE(tm_pg_items));
> @@ -781,6 +783,22 @@ static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
>   	return 0;
>   }
>   
> +static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
> +{
> +	int ret;
> +	char *data_str = kcalloc(ARRAY_SIZE(tm_pg_items),
> +				 HCLGE_DBG_DATA_STR_LEN, GFP_KERNEL);
> +
Hi Arnd, thanks your modification, according to linux code style, should the code be written as follow?
	char *data_str;
	int ret;

	data_str = kcalloc(ARRAY_SIZE(tm_pg_items),
			   HCLGE_DBG_DATA_STR_LEN, GFP_KERNEL);
> +	if (!data_str)
> +		return -ENOMEM;
> +
> +	ret = __hclge_dbg_dump_tm_pg(hdev, data_str, buf, len);
> +
> +	kfree(data_str);
> +
> +	return ret;
> +}
> +
>   static int hclge_dbg_dump_tm_port(struct hclge_dev *hdev,  char *buf, int len)
>   {
>   	struct hclge_tm_shaper_para shaper_para;
> 
