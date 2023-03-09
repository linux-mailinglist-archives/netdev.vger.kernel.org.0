Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EB66B21E0
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCIKwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjCIKwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:52:35 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C032EE774E;
        Thu,  9 Mar 2023 02:52:33 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PXQtF73snz16NkZ;
        Thu,  9 Mar 2023 18:49:41 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 9 Mar
 2023 18:52:31 +0800
Subject: Re: [PATCH] virtio_net: Use NETDEV_TX_BUSY when has no buf to send
To:     Angus Chen <angus.chen@jaguarmicro.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20230309074952.975-1-angus.chen@jaguarmicro.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <866b9077-1600-4c93-3da8-4006cbf6abe7@huawei.com>
Date:   Thu, 9 Mar 2023 18:52:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230309074952.975-1-angus.chen@jaguarmicro.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/9 15:49, Angus Chen wrote:
> Don't consume skb if virtqueue_add return -ENOSPC.

Is this fixing the same out of space problem caused by
xdp xmit as Xuan Zhuo is fixing, or it is fixing a different
case?

https://lore.kernel.org/netdev/20230308071921-mutt-send-email-mst@kernel.org/T/#mc4c5766a59fb8be988bb6a4dfa48f49e58df3ea6

> 
> Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index fb5e68ed3ec2..4096ea3d2eb6 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1980,7 +1980,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  				 qnum, err);
>  		dev->stats.tx_dropped++;
>  		dev_kfree_skb_any(skb);

Returning NETDEV_TX_BUSY will caused stack to requeue the skb
and send it again when space is available, but you have freed the skb here,
isn't this cause use-after-free problem?

> -		return NETDEV_TX_OK;
> +		return (err == -ENOSPC) ? NETDEV_TX_BUSY : NETDEV_TX_OK;
>  	}
>  
>  	/* Don't wait up for transmitted skbs to be freed. */
> 
