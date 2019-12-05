Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314C41138FC
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfLEAz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:55:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:35976 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728011AbfLEAz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 19:55:29 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ED718BE8DB19AA657577;
        Thu,  5 Dec 2019 08:55:25 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Dec 2019
 08:55:20 +0800
Subject: Re: [PATCH] page_pool: mark unbound node page as reusable pages
To:     Li RongQing <lirongqing@baidu.com>, <netdev@vger.kernel.org>,
        <saeedm@mellanox.com>
References: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
Date:   Thu, 5 Dec 2019 08:55:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/4 18:14, Li RongQing wrote:
> some drivers uses page pool, but not require to allocate
> page from bound node, so pool.p.nid is NUMA_NO_NODE, and
> this fixed patch will block this kind of driver to
> recycle
> 
> Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  net/core/page_pool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index a6aefe989043..4054db683178 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -317,7 +317,9 @@ static bool __page_pool_recycle_direct(struct page *page,
>   */
>  static bool pool_page_reusable(struct page_pool *pool, struct page *page)
>  {
> -	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
> +	return !page_is_pfmemalloc(page) &&
> +		(page_to_nid(page) == pool->p.nid ||
> +		 pool->p.nid == NUMA_NO_NODE);

If I understand it correctly, you are allowing recycling when
pool->p.nid is NUMA_NO_NODE, which does not seems match the commit
log: "this fixed patch will block this kind of driver to recycle".

Maybe you mean "commit d5394610b1ba" by this fixed patch?

Also, maybe it is better to allow recycling if the below condition
is matched:

	pool->p.nid == NUMA_NO_NODE && page_to_nid(page) == numa_mem_id()

>  }
>  
>  void __page_pool_put_page(struct page_pool *pool, struct page *page,
> 

