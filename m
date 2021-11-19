Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D124568B4
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 04:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhKSDkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 22:40:10 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28155 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbhKSDkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 22:40:10 -0500
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HwMkK6dvwz8vFq;
        Fri, 19 Nov 2021 11:35:21 +0800 (CST)
Received: from [10.67.102.221] (10.67.102.221) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 19 Nov 2021 11:37:07 +0800
Message-ID: <cc8714ba-f840-6856-3385-1bffaf6631e7@huawei.com>
Date:   Fri, 19 Nov 2021 11:37:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible
 array overflow in hns_dsaf_ge_srst_by_port()
To:     Teng Qi <starmiku1207184332@gmail.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <huangguangbin2@huawei.com>, <zhengyongjun3@huawei.com>,
        <liuyonglong@huawei.com>, <shenyang39@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <baijiaju1990@gmail.com>, <islituo@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
References: <20211117034453.28963-1-starmiku1207184332@gmail.com>
From:   "lipeng (Y)" <lipeng321@huawei.com>
In-Reply-To: <20211117034453.28963-1-starmiku1207184332@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.221]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the late reply.

Seeing this functions:

static int hns_mac_get_max_port_num(struct dsaf_device *dsaf_dev)
{
     if (HNS_DSAF_IS_DEBUG(dsaf_dev))
         return 1;
     else
         return  DSAF_MAX_PORT_NUM;
}

int hns_mac_init(struct dsaf_device *dsaf_dev)
{
     bool found = false;
     int ret;
     u32 port_id;
     int max_port_num = hns_mac_get_max_port_num(dsaf_dev);
     struct hns_mac_cb *mac_cb;
     struct fwnode_handle *child;

     device_for_each_child_node(dsaf_dev->dev, child) {
         ret = fwnode_property_read_u32(child, "reg", &port_id);
         if (ret) {
             dev_err(dsaf_dev->dev,
                 "get reg fail, ret=%d!\n", ret);
             return ret;
         }
         if (port_id >= max_port_num) {
             dev_err(dsaf_dev->dev,
                 "reg(%u) out of range!\n", port_id);
             return -EINVAL;
         }

The port_id had limit to DSAF_MAX_PORT_NUM, so this patch is 
unnecessary, thanks!


On 2021/11/17 11:44, Teng Qi wrote:
> The if statement:
>    if (port >= DSAF_GE_NUM)
>          return;
> 
> limits the value of port less than DSAF_GE_NUM (i.e., 8).
> However, if the value of port is 6 or 7, an array overflow could occur:
>    port_rst_off = dsaf_dev->mac_cb[port]->port_rst_off;
> 
> because the length of dsaf_dev->mac_cb is DSAF_MAX_PORT_NUM (i.e., 6).
> 
> To fix this possible array overflow, we first check port and if it is
> greater than or equal to DSAF_MAX_PORT_NUM, the function returns.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
> ---
>   drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
> index 23d9cbf262c3..740850b64aff 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
> @@ -400,6 +400,10 @@ static void hns_dsaf_ge_srst_by_port(struct dsaf_device *dsaf_dev, u32 port,
>   		return;
>   
>   	if (!HNS_DSAF_IS_DEBUG(dsaf_dev)) {
> +		/* DSAF_MAX_PORT_NUM is 6, but DSAF_GE_NUM is 8.
> +		   We need check to prevent array overflow */
> +		if (port >= DSAF_MAX_PORT_NUM)
> +			return;
>   		reg_val_1  = 0x1 << port;
>   		port_rst_off = dsaf_dev->mac_cb[port]->port_rst_off;
>   		/* there is difference between V1 and V2 in register.*/
> 
