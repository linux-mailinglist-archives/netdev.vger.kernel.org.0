Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A0C30D23F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhBCDwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:52:05 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12384 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbhBCDwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 22:52:02 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DVnkf0f9wz7fxZ;
        Wed,  3 Feb 2021 11:50:02 +0800 (CST)
Received: from [127.0.0.1] (10.69.30.204) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.498.0; Wed, 3 Feb 2021
 11:51:10 +0800
Subject: Re: [PATCH 4/4] net: hns3: double free 'skb'
To:     Wenjia Zhao <driverfuzzing@gmail.com>
CC:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1612322024-93322-1-git-send-email-driverfuzzing@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5fe6da23-6358-3a94-0023-e0e634f77430@huawei.com>
Date:   Wed, 3 Feb 2021 11:51:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1612322024-93322-1-git-send-email-driverfuzzing@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/2/3 11:13, Wenjia Zhao wrote:
> net: hns3: double free 'skb'
> 
> The false branch of (tx_ret == NETDEV_TX_OK) free the skb. However, the
> kfree_skb(skb) in the out label will be execute when exits the function.
> So the skb has a double-free bugs.
> 
> Remove the kfree_skb(skb) at line 269

The freeing is added by the below patch:

commit: 8f9eed1a8791("net: hns3: fix for skb leak when doing selftest")

which is to fix a skb leak problem.

kfree_skb(skb) in the out label corresponds to alloc_skb(),
and kfree_skb(skb) removed in this patch corresponds to
skb_get(skb) before calling hns3_nic_net_xmit() when
hns3_nic_net_xmit() non-NETDEV_TX_OK.

So I do not think there is double free 'skb' here, unless
I miss something here?

> 
> Signed-off-by: Wenjia Zhao <driverfuzzing@gmail.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> index 2622e04..1b926ff 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> @@ -266,7 +266,6 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
>  		if (tx_ret == NETDEV_TX_OK) {
>  			good_cnt++;
>  		} else {
> -			kfree_skb(skb);
>  			netdev_err(ndev, "hns3_lb_run_test xmit failed: %d\n",
>  				   tx_ret);
>  		}
> 

