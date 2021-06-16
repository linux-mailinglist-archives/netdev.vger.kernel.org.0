Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8253A9540
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 10:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhFPItQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 04:49:16 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7331 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhFPItP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 04:49:15 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G4dxR5fhgz6yGQ;
        Wed, 16 Jun 2021 16:43:07 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 16:47:06 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 16 Jun
 2021 16:47:06 +0800
Subject: Re: [PATCH net-next 6/7] net: hns3: optimize the rx page reuse
 handling process
To:     Guangbin Huang <huangguangbin2@huawei.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>
References: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
 <1623825377-41948-7-git-send-email-huangguangbin2@huawei.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <8eb826a2-c48d-e277-ba48-cc93acee07fd@huawei.com>
Date:   Wed, 16 Jun 2021 16:47:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1623825377-41948-7-git-send-email-huangguangbin2@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/16 14:36, Guangbin Huang wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> 
> Current rx page offset only reset to zero when all the below
> conditions are satisfied:
> 1. rx page is only owned by driver.
> 2. rx page is reusable.
> 3. the page offset that is above to be given to the stack has
> reached the end of the page.
> 
> If the page offset is over the hns3_buf_size(), it means the
> buffer below the offset of the page is usable when the above
> condition 1 & 2 are satisfied, so page offset can be reset to
> zero instead of increasing the offset. We may be able to always
> reuse the first 4K buffer of a 64K page, which means we can
> limit the hot buffer size as much as possible.
> 
> The above optimization is a side effect when refacting the
> rx page reuse handling in order to support the rx copybreak.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 44 ++++++++++++-------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index f60a344a6a9f..98e8a548edb8 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -3525,7 +3525,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
>  
>  static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
>  {
> -	return (page_count(cb->priv) - cb->pagecnt_bias) == 1;
> +	return page_count(cb->priv) == cb->pagecnt_bias;
>  }
>  
>  static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
> @@ -3533,40 +3533,40 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
>  				struct hns3_desc_cb *desc_cb)
>  {
>  	struct hns3_desc *desc = &ring->desc[ring->next_to_clean];
> +	u32 frag_offset = desc_cb->page_offset + pull_len;
>  	int size = le16_to_cpu(desc->rx.size);
>  	u32 truesize = hns3_buf_size(ring);
> +	u32 frag_size = size - pull_len;
>  
> -	desc_cb->pagecnt_bias--;
> -	skb_add_rx_frag(skb, i, desc_cb->priv, desc_cb->page_offset + pull_len,
> -			size - pull_len, truesize);
> +	/* Avoid re-using remote or pfmem page */
> +	if (unlikely(!dev_page_is_reusable(desc_cb->priv)))
> +		goto out;
>  
> -	/* Avoid re-using remote and pfmemalloc pages, or the stack is still
> -	 * using the page when page_offset rollback to zero, flag default
> -	 * unreuse
> +	/* Stack is not using and current page_offset is non-zero, we can
> +	 * reuse from the zero offset.
>  	 */
> -	if (!dev_page_is_reusable(desc_cb->priv) ||
> -	    (!desc_cb->page_offset && !hns3_can_reuse_page(desc_cb))) {
> -		__page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
> -		return;
> -	}
> -
> -	/* Move offset up to the next cache line */
> -	desc_cb->page_offset += truesize;
> -
> -	if (desc_cb->page_offset + truesize <= hns3_page_size(ring)) {
> +	if (desc_cb->page_offset && hns3_can_reuse_page(desc_cb)) {
> +		desc_cb->page_offset = 0;
>  		desc_cb->reuse_flag = 1;
> -	} else if (hns3_can_reuse_page(desc_cb)) {
> +	} else if (desc_cb->page_offset + truesize * 2 <=
> +		   hns3_page_size(ring)) {

The above assumption is wrong, we need to check the if the page
is only owned by driver at the begin and at the end of a page
to make sure there is no reuse conflict beteween driver and stack
when desc_cb->page_offset is rollback to zero or incremented.

The fix for above problem is pending internally, which was supposed to
merged with this patch when upstreaming.

It seems davem has merged this patch, will send out the fix later, sorry
for the inconvenience.


> +		desc_cb->page_offset += truesize;
>  		desc_cb->reuse_flag = 1;
> -		desc_cb->page_offset = 0;
> -	} else if (desc_cb->pagecnt_bias) {
> -		__page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
> -		return;
>  	}
>  
> +out:
> +	desc_cb->pagecnt_bias--;
> +
>  	if (unlikely(!desc_cb->pagecnt_bias)) {
>  		page_ref_add(desc_cb->priv, USHRT_MAX);
>  		desc_cb->pagecnt_bias = USHRT_MAX;
>  	}
> +
> +	skb_add_rx_frag(skb, i, desc_cb->priv, frag_offset,
> +			frag_size, truesize);
> +
> +	if (unlikely(!desc_cb->reuse_flag))
> +		__page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
>  }
>  
>  static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
> 

