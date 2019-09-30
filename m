Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D90C1C68
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 09:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbfI3H4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 03:56:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:49234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbfI3H4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 03:56:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99BE0B15C;
        Mon, 30 Sep 2019 07:56:16 +0000 (UTC)
Subject: Re: [PATCH 1/1] xen-netfront: do not use ~0U as error return value
 for xennet_fill_frags()
To:     Dongli Zhang <dongli.zhang@oracle.com>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org
References: <1569829469-16143-1-git-send-email-dongli.zhang@oracle.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <affc5730-bb7a-710b-b75f-27e26cdbf4e7@suse.com>
Date:   Mon, 30 Sep 2019 09:56:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569829469-16143-1-git-send-email-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.19 09:44, Dongli Zhang wrote:
> xennet_fill_frags() uses ~0U as return value when the sk_buff is not able
> to cache extra fragments. This is incorrect because the return type of
> xennet_fill_frags() is RING_IDX and 0xffffffff is an expected value for
> ring buffer index.
> 
> In the situation when the rsp_cons is approaching 0xffffffff, the return
> value of xennet_fill_frags() may become 0xffffffff which xennet_poll() (the
> caller) would regard as error. As a result, queue->rx.rsp_cons is set
> incorrectly because it is updated only when there is error. If there is no
> error, xennet_poll() would be responsible to update queue->rx.rsp_cons.
> Finally, queue->rx.rsp_cons would point to the rx ring buffer entries whose
> queue->rx_skbs[i] and queue->grant_rx_ref[i] are already cleared to NULL.
> This leads to NULL pointer access in the next iteration to process rx ring
> buffer entries.
> 
> The symptom is similar to the one fixed in
> commit 00b368502d18 ("xen-netfront: do not assume sk_buff_head list is
> empty in error handling").
> 
> This patch uses an extra argument to help return if there is error in
> xennet_fill_frags().

Hmm, I wonder if it wouldn't be better to have the ring index returned
via the new pointer and let return xennet_fill_frags() 0 in case of
success and -ENOENT otherwise.

This would avoid having to introduce the local errno variable.


Juergen

> 
> Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>   drivers/net/xen-netfront.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index e14ec75..c2a1e09 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -889,11 +889,14 @@ static int xennet_set_skb_gso(struct sk_buff *skb,
>   
>   static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
>   				  struct sk_buff *skb,
> -				  struct sk_buff_head *list)
> +				  struct sk_buff_head *list,
> +				  int *errno)
>   {
>   	RING_IDX cons = queue->rx.rsp_cons;
>   	struct sk_buff *nskb;
>   
> +	*errno = 0;
> +
>   	while ((nskb = __skb_dequeue(list))) {
>   		struct xen_netif_rx_response *rx =
>   			RING_GET_RESPONSE(&queue->rx, ++cons);
> @@ -908,6 +911,7 @@ static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
>   		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
>   			queue->rx.rsp_cons = ++cons + skb_queue_len(list);
>   			kfree_skb(nskb);
> +			*errno = -ENOENT;
>   			return ~0U;
>   		}
>   
> @@ -1009,6 +1013,8 @@ static int xennet_poll(struct napi_struct *napi, int budget)
>   	i = queue->rx.rsp_cons;
>   	work_done = 0;
>   	while ((i != rp) && (work_done < budget)) {
> +		int errno;
> +
>   		memcpy(rx, RING_GET_RESPONSE(&queue->rx, i), sizeof(*rx));
>   		memset(extras, 0, sizeof(rinfo.extras));
>   
> @@ -1045,8 +1051,8 @@ static int xennet_poll(struct napi_struct *napi, int budget)
>   		skb->data_len = rx->status;
>   		skb->len += rx->status;
>   
> -		i = xennet_fill_frags(queue, skb, &tmpq);
> -		if (unlikely(i == ~0U))
> +		i = xennet_fill_frags(queue, skb, &tmpq, &errno);
> +		if (unlikely(errno == -ENOENT))
>   			goto err;
>   
>   		if (rx->flags & XEN_NETRXF_csum_blank)
> 

