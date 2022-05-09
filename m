Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A166451FB83
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiEILn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 07:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiEILnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:43:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5491FC7C1;
        Mon,  9 May 2022 04:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9BCFB8119D;
        Mon,  9 May 2022 11:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47441C385AB;
        Mon,  9 May 2022 11:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652096368;
        bh=W32hoCGP3nIdxrrrYu+Ox8K9dj4+urX6psk0ONvi8fw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mM31Rflnzg9ZzjxBTVNWhCTURBuFd4oF66lrAT7cojCRMBPj9FVACwnnqDNAIRYYW
         UdHAipmTU1W+/qcVBRzpGO0xT2ayotMsHaDSMkdXrEb5T24OEudSeQKSyixyN7eoY5
         hxm/jNMnrvbP3RBxr/N755aYMwPexAtMx8vNcYNaTMeS++ux61HrocHxoBPi4C9vQ7
         Csr8IBM7ljFqiONKdjp4eBDOH2Ei5YFZi14fA61ksxWYDpgkLl5MHvY/xlKAPB1wue
         HlVd5fP6L7nvod4xmoVy57xveAYAq0cmtV8wT3ZZ3E9nsUVGIqQjKLwTL4eRfuAel8
         UHMCvaQ0nLmWQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wang Qing <wangqing@vivo.com>
Subject: Re: [PATCH v3] cw1200: fix incorrect check to determine if no element is found in list
References: <20220413091723.17596-1-xiam0nd.tong@gmail.com>
Date:   Mon, 09 May 2022 14:39:23 +0300
In-Reply-To: <20220413091723.17596-1-xiam0nd.tong@gmail.com> (Xiaomeng Tong's
        message of "Wed, 13 Apr 2022 17:17:23 +0800")
Message-ID: <87k0av7x5g.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaomeng Tong <xiam0nd.tong@gmail.com> writes:

> The bug is here: "} else if (item) {".
>
> The list iterator value will *always* be set and non-NULL by
> list_for_each_entry(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element is found in list.
>
> Use a new value 'iter' as the list iterator, while use the old value
> 'item' as a dedicated pointer to point to the found element, which
> 1. can fix this bug, due to now 'item' is NULL only if it's not found.
> 2. do not need to change all the uses of 'item' after the loop.
> 3. can also limit the scope of the list iterator 'iter' *only inside*
>    the traversal loop by simply declaring 'iter' inside the loop in the
>    future, as usage of the iterator outside of the list_for_each_entry
>    is considered harmful. https://lkml.org/lkml/2022/2/17/1032
>
> Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
> changes since v2:
>  - rebase on latest wireless-next (Kalle Valo)
> changes since v1:
>  - fix incorrect check to item (Jakob Koschel)
>
> v2: https://lore.kernel.org/lkml/20220320035436.11293-1-xiam0nd.tong@gmail.com/
> v1: https://lore.kernel.org/all/20220319063800.28791-1-xiam0nd.tong@gmail.com/
> ---
>  drivers/net/wireless/st/cw1200/queue.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/st/cw1200/queue.c b/drivers/net/wireless/st/cw1200/queue.c
> index e06da4b3b0d4..805a3c1bf8fe 100644
> --- a/drivers/net/wireless/st/cw1200/queue.c
> +++ b/drivers/net/wireless/st/cw1200/queue.c
> @@ -91,23 +91,25 @@ static void __cw1200_queue_gc(struct cw1200_queue *queue,
>  			      bool unlock)
>  {
>  	struct cw1200_queue_stats *stats = queue->stats;
> -	struct cw1200_queue_item *item = NULL, *tmp;
> +	struct cw1200_queue_item *item = NULL, *iter, *tmp;
>  	bool wakeup_stats = false;
>  
> -	list_for_each_entry_safe(item, tmp, &queue->queue, head) {
> -		if (time_is_after_jiffies(item->queue_timestamp + queue->ttl))
> +	list_for_each_entry_safe(iter, tmp, &queue->queue, head) {
> +		if (time_is_after_jiffies(iter->queue_timestamp + queue->ttl)) {
> +			item = iter;
>  			break;
> +		}
>  		--queue->num_queued;
> -		--queue->link_map_cache[item->txpriv.link_id];
> +		--queue->link_map_cache[iter->txpriv.link_id];
>  		spin_lock_bh(&stats->lock);
>  		--stats->num_queued;
> -		if (!--stats->link_map_cache[item->txpriv.link_id])
> +		if (!--stats->link_map_cache[iter->txpriv.link_id])
>  			wakeup_stats = true;
>  		spin_unlock_bh(&stats->lock);
>  		cw1200_debug_tx_ttl(stats->priv);
> -		cw1200_queue_register_post_gc(head, item);
> -		item->skb = NULL;
> -		list_move_tail(&item->head, &queue->free_pool);
> +		cw1200_queue_register_post_gc(head, iter);
> +		iter->skb = NULL;
> +		list_move_tail(&iter->head, &queue->free_pool);
>  	}
>  
>  	if (wakeup_stats)

I started to look at this myself. I don't know if I'm missing something,
but is the time_is_after_jiffies() really correct? This was added by
Wang in commit 8cbc3d51b4ae ("cw1200: use time_is_after_jiffies()
instead of open coding it"):

-               if (jiffies - item->queue_timestamp < queue->ttl)
+               if (time_is_after_jiffies(item->queue_timestamp + queue->ttl))

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8cbc3d51b4ae

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
