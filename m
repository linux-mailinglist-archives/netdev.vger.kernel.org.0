Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684D74568AF
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 04:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhKSDjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 22:39:44 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14955 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhKSDjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 22:39:44 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HwMj31H9szZd8V;
        Fri, 19 Nov 2021 11:34:15 +0800 (CST)
Received: from [10.67.102.221] (10.67.102.221) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 19 Nov 2021 11:36:40 +0800
Message-ID: <788619cc-93f9-0eaf-202c-50d49487ee0c@huawei.com>
Date:   Fri, 19 Nov 2021 11:36:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] net: hns: Prefer struct_size over open coded arithmetic
To:     Yonglong Liu <liuyonglong@huawei.com>,
        Len Baker <len.baker@gmx.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-hardening@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211011090100.5727-1-len.baker@gmx.com>
 <a04c3709-20e6-f816-d535-5db6ef898616@huawei.com>
From:   "lipeng (Y)" <lipeng321@huawei.com>
In-Reply-To: <a04c3709-20e6-f816-d535-5db6ef898616@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.102.221]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



  On 2021/10/11 17:01, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
>
> So, take the opportunity to refactor the hnae_handle structure to switch
> the last member to flexible array, changing the code accordingly. Also,
> fix the comment in the hnae_vf_cb structure to inform that the ae_handle
> member must be the last member.
>
> Then, use the struct_size() helper to do the arithmetic instead of the
> argument "size + count * size" in the kzalloc() function.
>
> This code was detected with the help of Coccinelle and audited and fixed
> manually.
>
> [1] 
> https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments 
>
>
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>   drivers/net/ethernet/hisilicon/hns/hnae.h          | 2 +-
>   drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  | 5 ++---
>   drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h | 2 +-
>   3 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.h 
> b/drivers/net/ethernet/hisilicon/hns/hnae.h
> index 2b7db1c22321..d46e8f999019 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hnae.h
> +++ b/drivers/net/ethernet/hisilicon/hns/hnae.h
> @@ -558,7 +558,7 @@ struct hnae_handle {
>       enum hnae_media_type media_type;
>       struct list_head node;    /* list to hnae_ae_dev->handle_list */
>       struct hnae_buf_ops *bops; /* operation for the buffer */
> -    struct hnae_queue **qs;  /* array base of all queues */
> +    struct hnae_queue *qs[];  /* flexible array of all queues */
>   };
>
>   #define ring_to_dev(ring) ((ring)->q->dev->dev)
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c 
> b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
> index 75e4ec569da8..e81116ad9bdf 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
> @@ -81,8 +81,8 @@ static struct hnae_handle *hns_ae_get_handle(struct 
> hnae_ae_dev *dev,
>       vfnum_per_port = hns_ae_get_vf_num_per_port(dsaf_dev, port_id);
>       qnum_per_vf = hns_ae_get_q_num_per_vf(dsaf_dev, port_id);
>
> -    vf_cb = kzalloc(sizeof(*vf_cb) +
> -            qnum_per_vf * sizeof(struct hnae_queue *), GFP_KERNEL);
> +    vf_cb = kzalloc(struct_size(vf_cb, ae_handle.qs, qnum_per_vf),
> +            GFP_KERNEL);
>       if (unlikely(!vf_cb)) {
>           dev_err(dsaf_dev->dev, "malloc vf_cb fail!\n");
>           ae_handle = ERR_PTR(-ENOMEM);
> @@ -108,7 +108,6 @@ static struct hnae_handle 
> *hns_ae_get_handle(struct hnae_ae_dev *dev,
>           goto vf_id_err;
>       }
>
> -    ae_handle->qs = (struct hnae_queue **)(&ae_handle->qs + 1);
> 


  This line can not delete. ae_handle->qs is for PF.



> 
>       for (i = 0; i < qnum_per_vf; i++) {
> 



  This loop actually start from &ae_handle->qs + 1, which is the queue
  offset for VF.


> 
>           ae_handle->qs[i] = &ring_pair_cb->q;
>           ae_handle->qs[i]->rx_ring.q = ae_handle->qs[i];
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h 
> b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h
> index cba04bfa0b3f..5526a10caac5 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h
> @@ -210,7 +210,7 @@ struct hnae_vf_cb {
>       u8 port_index;
>       struct hns_mac_cb *mac_cb;
>       struct dsaf_device *dsaf_dev;
> -    struct hnae_handle  ae_handle; /* must be the last number */
> +    struct hnae_handle  ae_handle; /* must be the last member */
>   };
>
>   struct dsaf_int_xge_src {
> -- 
> 2.25.1
>
>
> .
>
> 
> .
