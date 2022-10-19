Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C02603723
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 02:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJSAcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 20:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJSAc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 20:32:29 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75971D73F1;
        Tue, 18 Oct 2022 17:32:28 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MsWnJ3B0FzpVcY;
        Wed, 19 Oct 2022 08:29:08 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 08:32:26 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 08:32:26 +0800
Subject: Re: [Patch v7 10/12] net: mana: Define data structures for allocating
 doorbell page from GDMA
To:     <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, <edumazet@google.com>,
        <shiraz.saleem@intel.com>, "Ajay Sharma" <sharmaajay@microsoft.com>
CC:     <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
 <1666034441-15424-11-git-send-email-longli@linuxonhyperv.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c60518c0-f486-db8e-230c-7d680b0c27e0@huawei.com>
Date:   Wed, 19 Oct 2022 08:32:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1666034441-15424-11-git-send-email-longli@linuxonhyperv.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

On 2022/10/18 3:20, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> The RDMA device needs to allocate doorbell pages for each user context.
> Define the GDMA data structures for use by the RDMA driver.
> 
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>
> Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
> Change log:
> v4: use EXPORT_SYMBOL_NS
> v7: move mana_gd_allocate_doorbell_page() and mana_gd_destroy_doorbell_page() to the RDMA driver
> 
>  include/net/mana/gdma.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index a9b7930dfbf8..bc060b6fa54c 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -24,11 +24,15 @@ enum gdma_request_type {
>  	GDMA_GENERATE_TEST_EQE		= 10,
>  	GDMA_CREATE_QUEUE		= 12,
>  	GDMA_DISABLE_QUEUE		= 13,
> +	GDMA_ALLOCATE_RESOURCE_RANGE	= 22,
> +	GDMA_DESTROY_RESOURCE_RANGE	= 24,
>  	GDMA_CREATE_DMA_REGION		= 25,
>  	GDMA_DMA_REGION_ADD_PAGES	= 26,
>  	GDMA_DESTROY_DMA_REGION		= 27,
>  };
>  
> +#define GDMA_RESOURCE_DOORBELL_PAGE	27
> +
>  enum gdma_queue_type {
>  	GDMA_INVALID_QUEUE,
>  	GDMA_SQ,
> @@ -587,6 +591,26 @@ struct gdma_register_device_resp {
>  	u32 db_id;
>  }; /* HW DATA */
>  
> +struct gdma_allocate_resource_range_req {
> +	struct gdma_req_hdr hdr;
> +	u32 resource_type;
> +	u32 num_resources;
> +	u32 alignment;
> +	u32 allocated_resources;
> +};
> +
> +struct gdma_allocate_resource_range_resp {
> +	struct gdma_resp_hdr hdr;
> +	u32 allocated_resources;
> +};
> +
> +struct gdma_destroy_resource_range_req {
> +	struct gdma_req_hdr hdr;
> +	u32 resource_type;
> +	u32 num_resources;
> +	u32 allocated_resources;
> +};
> +
>  /* GDMA_CREATE_QUEUE */
>  struct gdma_create_queue_req {
>  	struct gdma_req_hdr hdr;
> @@ -695,4 +719,5 @@ void mana_gd_free_memory(struct gdma_mem_info *gmi);
>  
>  int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
>  			 u32 resp_len, void *resp);
> +

Unrelated change.

>  #endif /* _GDMA_H */
> 
