Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADAD9DD74
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 08:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfH0GNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 02:13:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:53814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726125AbfH0GNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 02:13:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 289BFB647;
        Tue, 27 Aug 2019 06:13:40 +0000 (UTC)
Subject: Re: Question on xen-netfront code to fix a potential ring buffer
 corruption
To:     Dongli Zhang <dongli.zhang@oracle.com>,
        xen-devel@lists.xenproject.org
Cc:     Joe Jin <joe.jin@oracle.com>, netdev@vger.kernel.org
References: <c45b306e-c67b-49f5-8fe8-3913557a8774@default>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <130ea0ab-4364-2b77-dc8d-b869e06d1768@suse.com>
Date:   Tue, 27 Aug 2019 08:13:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c45b306e-c67b-49f5-8fe8-3913557a8774@default>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.08.19 10:31, Dongli Zhang wrote:
> Hi,
> 
> Would you please help confirm why the condition at line 908 is ">="?
> 
> In my opinion, we would only hit "skb_shinfo(skb)->nr_frag == MAX_SKB_FRAGS" at
> line 908.
> 
> 890 static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
> 891                                   struct sk_buff *skb,
> 892                                   struct sk_buff_head *list)
> 893 {
> 894         RING_IDX cons = queue->rx.rsp_cons;
> 895         struct sk_buff *nskb;
> 896
> 897         while ((nskb = __skb_dequeue(list))) {
> 898                 struct xen_netif_rx_response *rx =
> 899                         RING_GET_RESPONSE(&queue->rx, ++cons);
> 900                 skb_frag_t *nfrag = &skb_shinfo(nskb)->frags[0];
> 901
> 902                 if (skb_shinfo(skb)->nr_frags == MAX_SKB_FRAGS) {
> 903                         unsigned int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
> 904
> 905                         BUG_ON(pull_to < skb_headlen(skb));
> 906                         __pskb_pull_tail(skb, pull_to - skb_headlen(skb));
> 907                 }
> 908                 if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
> 909                         queue->rx.rsp_cons = ++cons;
> 910                         kfree_skb(nskb);
> 911                         return ~0U;
> 912                 }
> 913
> 914                 skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> 915                                 skb_frag_page(nfrag),
> 916                                 rx->offset, rx->status, PAGE_SIZE);
> 917
> 918                 skb_shinfo(nskb)->nr_frags = 0;
> 919                 kfree_skb(nskb);
> 920         }
> 921
> 922         return cons;
> 923 }
> 
> 
> The reason that I ask about this is because I am considering below patch to
> avoid a potential xen-netfront ring buffer corruption.
> 
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 8d33970..48a2162 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -906,7 +906,7 @@ static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
>                          __pskb_pull_tail(skb, pull_to - skb_headlen(skb));
>                  }
>                  if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
> -                       queue->rx.rsp_cons = ++cons;
> +                       queue->rx.rsp_cons = cons + skb_queue_len(list) + 1;
>                          kfree_skb(nskb);
>                          return ~0U;
>                  }
> 
> 
> If there is skb left in list when we return ~0U, queue->rx.rsp_cons may be set
> incorrectly.

Sa basically you want to consume the responses for all outstanding skbs
in the list?

> 
> While I am trying to make up a case that would hit the corruption, I could not
> explain why (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)), but not
> just "==". Perhaps __pskb_pull_tail() may fail although pull_to is less than
> skb_headlen(skb).

I don't think nr_frags can be larger than MAX_SKB_FRAGS. OTOH I don't
think it hurts to have a safety net here in order to avoid problems.

Originally this was BUG_ON(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)
so that might explain the ">=".


Juergen
