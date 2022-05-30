Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60A5387BB
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 21:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbiE3T1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 15:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbiE3T1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 15:27:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D83381A0;
        Mon, 30 May 2022 12:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5033CB80EEF;
        Mon, 30 May 2022 19:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B014AC385B8;
        Mon, 30 May 2022 19:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653938827;
        bh=VqyJ6noyoqh1S7m6hSDlQTa4dwHKLepTFOb1kWS4Bn0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SZmYTXA0cg2agATwf3lreIr597+4bg+ZiO5067DPzcrZywy523jz23y0QFzvogU4F
         3b81ndHyZkvqHSLhDOT1qIBJrOSC/spWz55EJ3l/Vx5nJBOZlwja63GvtZGisWz0Wi
         GxMU5o+oRmO29kg9Vuz87bHNYi6w88n0JilKw4iEpKRpWkhP6od9MVHFIMcypzY/VM
         JkhsNNE8xd/8wDKcute9JPRXPxCo7nq78n9ap9+sbWkw/9DbnfbN1JJjlJlgR+9xCW
         TS5YJDszNKCkLugEief/EG4kTFhQsQUMUkjOucvYmQVuXixDfdL/jrpvhIF/YwqaoN
         uVAXh6zQktVQw==
Date:   Mon, 30 May 2022 12:27:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Lin <chen45464546@163.com>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is
 bigger than PAGE_SIZE
Message-ID: <20220530122705.4e74bc1e@kernel.org>
In-Reply-To: <1653917942-5982-1-git-send-email-chen45464546@163.com>
References: <20220529163029.12425c1e5286d7c7e3fe3708@linux-foundation.org>
        <1653917942-5982-1-git-send-email-chen45464546@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 May 2022 21:39:02 +0800 Chen Lin wrote:
> netdev_alloc_frag->page_frag_alloc may cause memory corruption in 
> the following process:
> 
> 1. A netdev_alloc_frag function call need alloc 200 Bytes to build a skb.
> 
> 2. Insufficient memory to alloc PAGE_FRAG_CACHE_MAX_ORDER(32K) in 
> __page_frag_cache_refill to fill frag cache, then one page(eg:4K) 
> is allocated, now current frag cache is 4K, alloc is success, 
> nc->pagecnt_bias--.
> 
> 3. Then this 200 bytes skb in step 1 is freed, page->_refcount--.
> 
> 4. Another netdev_alloc_frag function call need alloc 5k, page->_refcount 
> is equal to nc->pagecnt_bias, reset page count bias and offset to 
> start of new frag. page_frag_alloc will return the 4K memory for a 
> 5K memory request.
> 
> 5. The caller write on the extra 1k memory which is not actual allocated 
> will cause memory corruption.
> 
> page_frag_alloc is for fragmented allocation. We should warn the caller 
> to avoid memory corruption.
> 
> When fragsz is larger than one page, we report the failure and return.
> I don't think it is a good idea to make efforts to support the
> allocation of more than one page in this function because the total
> frag cache size(PAGE_FRAG_CACHE_MAX_SIZE 32768) is relatively small.
> When the request is larger than one page, the caller should switch to
> use other kernel interfaces, such as kmalloc and alloc_Pages.
> 
> This bug is mainly caused by the reuse of the previously allocated
> frag cache memory by the following LARGER allocations. This bug existed
> before page_frag_alloc was ported from __netdev_alloc_frag in 
> net/core/skbuff.c, so most Linux versions have this problem.
> 
> Signed-off-by: Chen Lin <chen45464546@163.com>
> ---
>  mm/page_alloc.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e008a3d..1e9e2c4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5574,6 +5574,16 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
>  	struct page *page;
>  	int offset;
>  
> +	/* frag_alloc is not suitable for memory alloc which fragsz
> +	 * is bigger than PAGE_SIZE, use kmalloc or alloc_pages instead.
> +	 */
> +	if (unlikely(fragsz > PAGE_SIZE)) {
> +		WARN(1, "alloc fragsz(%d) > PAGE_SIZE(%ld) not supported,
> +			alloc fail\n", fragsz, PAGE_SIZE);
> +
> +		return NULL;
> +	}
> +
>  	if (unlikely(!nc->va)) {
>  refill:
>  		page = __page_frag_cache_refill(nc, gfp_mask);

Let's see what Alex says (fixing his email now). It seems a little too
drastic to me. I'd go with something like:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e008a3df0485..360a545ee5e8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5537,6 +5537,7 @@ EXPORT_SYMBOL(free_pages);
  * sk_buff->head, or to be used in the "frags" portion of skb_shared_info.
  */
 static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
+					     unsigned int fragsz,
 					     gfp_t gfp_mask)
 {
 	struct page *page = NULL;
@@ -5549,7 +5550,7 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
 				PAGE_FRAG_CACHE_MAX_ORDER);
 	nc->size = page ? PAGE_FRAG_CACHE_MAX_SIZE : PAGE_SIZE;
 #endif
-	if (unlikely(!page))
+	if (unlikely(!page && fragsz <= PAGE_SIZE))
 		page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
 
 	nc->va = page ? page_address(page) : NULL;
@@ -5576,7 +5577,7 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 
 	if (unlikely(!nc->va)) {
 refill:
-		page = __page_frag_cache_refill(nc, gfp_mask);
+		page = __page_frag_cache_refill(nc, fragsz, gfp_mask);
 		if (!page)
 			return NULL;
 
