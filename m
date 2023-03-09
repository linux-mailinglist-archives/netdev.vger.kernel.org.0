Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28A16B17EF
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 01:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCIAeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 19:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCIAeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 19:34:10 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59EB1A973;
        Wed,  8 Mar 2023 16:34:08 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PX99X5hCczKpt6;
        Thu,  9 Mar 2023 08:32:00 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 9 Mar
 2023 08:34:06 +0800
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
To:     Ronak Doshi <doshir@vmware.com>, <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20230308222504.25675-1-doshir@vmware.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
Date:   Thu, 9 Mar 2023 08:34:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230308222504.25675-1-doshir@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/9 6:25, Ronak Doshi wrote:
> Currently, vmxnet3 uses GRO callback only if LRO is disabled. However,
> on smartNic based setups where UPT is supported, LRO can be enabled
> from guest VM but UPT devicve does not support LRO as of now. In such
> cases, there can be performance degradation as GRO is not being done.
> 
> This patch fixes this issue by calling GRO API when UPT is enabled. We
> use updateRxProd to determine if UPT mode is active or not.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6f91f4ba046e ("vmxnet3: add support for capability registers")
> Signed-off-by: Ronak Doshi <doshir@vmware.com>
> Acked-by: Guolin Yang <gyang@vmware.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index 682987040ea8..8f7ac7d85afc 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -1688,7 +1688,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  			if (unlikely(rcd->ts))
>  				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), rcd->tci);
>  
> -			if (adapter->netdev->features & NETIF_F_LRO)
> +			/* Use GRO callback if UPT is enabled */
> +			if ((adapter->netdev->features & NETIF_F_LRO) && !rq->shared->updateRxProd)

If UPT devicve does not support LRO, why not just clear the NETIF_F_LRO from
adapter->netdev->features?

With above change, it seems that LRO is supported for user' POV, but the GRO
is actually being done.

Also, if NETIF_F_LRO is set, do we need to clear the NETIF_F_GRO bit, so that
there is no confusion for user?

>  				netif_receive_skb(skb);
>  			else
>  				napi_gro_receive(&rq->napi, skb);
> 
