Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC3D6A04BC
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbjBWJZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbjBWJZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:25:47 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4018C4BE8E;
        Thu, 23 Feb 2023 01:25:46 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PMnZD0h0mzKmNc;
        Thu, 23 Feb 2023 17:20:52 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Thu, 23 Feb
 2023 17:25:13 +0800
Subject: Re: [PATCH] net: tls: fix possible info leak in
 tls_set_device_offload()
To:     Hangyu Hua <hbh25y@gmail.com>, <borisp@nvidia.com>,
        <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230223090508.443157-1-hbh25y@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <60e2ed41-1c88-3780-e4c4-550cef8f7c91@huawei.com>
Date:   Thu, 23 Feb 2023 17:25:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230223090508.443157-1-hbh25y@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/2/23 17:05, Hangyu Hua wrote:
> After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
> tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL if it fails
> before kmalloc cctx->iv. This may cause info leak when we call
> do_tls_getsockopt_conf().

Should we use kfree_sensitive() here if info leaking is what we want to
avoid?

> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/tls/tls_device.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index 6c593788dc25..a63f6f727f58 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -1241,8 +1241,10 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
>  	kfree(start_marker_record);
>  free_rec_seq:
>  	kfree(ctx->tx.rec_seq);
> +	ctx->tx.rec_seq = NULL;
>  free_iv:
>  	kfree(ctx->tx.iv);
> +	ctx->tx.iv = NULL;
>  release_netdev:
>  	dev_put(netdev);
>  	return rc;
> 
