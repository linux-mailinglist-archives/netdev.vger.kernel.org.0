Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7532E2D6D
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 07:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgLZGj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 01:39:28 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2101 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgLZGj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 01:39:27 -0500
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4D2vHr0GpzzVqVD
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 14:37:28 +0800 (CST)
Received: from [127.0.0.1] (10.40.202.127) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Sat, 26
 Dec 2020 14:38:44 +0800
Subject: Re: [PATCH net] net: hns: fix return value check in
 __lb_other_process()
To:     wangyunjian <wangyunjian@huawei.com>, <netdev@vger.kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>
References: <1608892525-21384-1-git-send-email-wangyunjian@huawei.com>
From:   Yonglong Liu <liuyonglong@huawei.com>
Message-ID: <4b056799-b330-cff1-963c-24ca138817a2@huawei.com>
Date:   Sat, 26 Dec 2020 14:38:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1608892525-21384-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.40.202.127]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/25 18:35, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> The function skb_copy() could return NULL, the return value
> need to be checked.
>
> Fixes: b5996f11ea54 ("net: add Hisilicon Network Subsystem basic ethernet support")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>   drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> index 7165da0ee9aa..ad18f0e20a23 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> @@ -415,6 +415,10 @@ static void __lb_other_process(struct hns_nic_ring_data *ring_data,
>   	/* for mutl buffer*/
>   	new_skb = skb_copy(skb, GFP_ATOMIC);
>   	dev_kfree_skb_any(skb);
> +	if (!new_skb) {

> +		ndev->stats.rx_dropped++;
You can add a new drop type to ring->states, and then add it to 
ndev->stats.rx_dropped,

then you can know that the rx_dropped is from skb_copy() failed.

This process is from self-test, maybe you can just add a error message 
rather than increase

the ndev->stats.rx_dropped.


> +		return;
> +	}
>   	skb = new_skb;
>   
>   	check_ok = 0;

