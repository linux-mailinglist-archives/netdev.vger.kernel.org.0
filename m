Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660C49DE5E
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 09:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfH0HE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 03:04:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:35960 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbfH0HE5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 03:04:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34E85B12E;
        Tue, 27 Aug 2019 07:04:55 +0000 (UTC)
Subject: Re: [Xen-devel] Question on xen-netfront code to fix a potential ring
 buffer corruption
To:     Dongli Zhang <dongli.zhang@oracle.com>,
        xen-devel@lists.xenproject.org
Cc:     Joe Jin <joe.jin@oracle.com>, netdev@vger.kernel.org
References: <c45b306e-c67b-49f5-8fe8-3913557a8774@default>
 <130ea0ab-4364-2b77-dc8d-b869e06d1768@suse.com>
 <9284025e-1066-387e-a52f-c46d4c66d2d3@oracle.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <b870640f-b658-4d45-4e22-8f187b7b9f27@suse.com>
Date:   Tue, 27 Aug 2019 09:04:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9284025e-1066-387e-a52f-c46d4c66d2d3@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.19 08:43, Dongli Zhang wrote:
> Hi Juergen,
> 
> On 8/27/19 2:13 PM, Juergen Gross wrote:
>> On 18.08.19 10:31, Dongli Zhang wrote:
>>> Hi,
>>>
>>> Would you please help confirm why the condition at line 908 is ">="?
>>>
>>> In my opinion, we would only hit "skb_shinfo(skb)->nr_frag == MAX_SKB_FRAGS" at
>>> line 908.
>>>
>>> 890 static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
>>> 891                                   struct sk_buff *skb,
>>> 892                                   struct sk_buff_head *list)
>>> 893 {
>>> 894         RING_IDX cons = queue->rx.rsp_cons;
>>> 895         struct sk_buff *nskb;
>>> 896
>>> 897         while ((nskb = __skb_dequeue(list))) {
>>> 898                 struct xen_netif_rx_response *rx =
>>> 899                         RING_GET_RESPONSE(&queue->rx, ++cons);
>>> 900                 skb_frag_t *nfrag = &skb_shinfo(nskb)->frags[0];
>>> 901
>>> 902                 if (skb_shinfo(skb)->nr_frags == MAX_SKB_FRAGS) {
>>> 903                         unsigned int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
>>> 904
>>> 905                         BUG_ON(pull_to < skb_headlen(skb));
>>> 906                         __pskb_pull_tail(skb, pull_to - skb_headlen(skb));
>>> 907                 }
>>> 908                 if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
>>> 909                         queue->rx.rsp_cons = ++cons;
>>> 910                         kfree_skb(nskb);
>>> 911                         return ~0U;
>>> 912                 }
>>> 913
>>> 914                 skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>>> 915                                 skb_frag_page(nfrag),
>>> 916                                 rx->offset, rx->status, PAGE_SIZE);
>>> 917
>>> 918                 skb_shinfo(nskb)->nr_frags = 0;
>>> 919                 kfree_skb(nskb);
>>> 920         }
>>> 921
>>> 922         return cons;
>>> 923 }
>>>
>>>
>>> The reason that I ask about this is because I am considering below patch to
>>> avoid a potential xen-netfront ring buffer corruption.
>>>
>>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>>> index 8d33970..48a2162 100644
>>> --- a/drivers/net/xen-netfront.c
>>> +++ b/drivers/net/xen-netfront.c
>>> @@ -906,7 +906,7 @@ static RING_IDX xennet_fill_frags(struct netfront_queue
>>> *queue,
>>>                           __pskb_pull_tail(skb, pull_to - skb_headlen(skb));
>>>                   }
>>>                   if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
>>> -                       queue->rx.rsp_cons = ++cons;
>>> +                       queue->rx.rsp_cons = cons + skb_queue_len(list) + 1;
>>>                           kfree_skb(nskb);
>>>                           return ~0U;
>>>                   }
>>>
>>>
>>> If there is skb left in list when we return ~0U, queue->rx.rsp_cons may be set
>>> incorrectly.
>>
>> Sa basically you want to consume the responses for all outstanding skbs
>> in the list?
>>
> 
> I think there would be bug if there is skb left in the list.
> 
> This is what is implanted in xennet_poll() when there is error of processing
> extra info like below. As at line 1034, if there is error, all outstanding skb
> are consumed.
> 
>   985 static int xennet_poll(struct napi_struct *napi, int budget)
> ... ...
> 1028                 if (extras[XEN_NETIF_EXTRA_TYPE_GSO - 1].type) {
> 1029                         struct xen_netif_extra_info *gso;
> 1030                         gso = &extras[XEN_NETIF_EXTRA_TYPE_GSO - 1];
> 1031
> 1032                         if (unlikely(xennet_set_skb_gso(skb, gso))) {
> 1033                                 __skb_queue_head(&tmpq, skb);
> 1034                                 queue->rx.rsp_cons += skb_queue_len(&tmpq);
> 1035                                 goto err;
> 1036                         }
> 1037                 }
> 
> The reason we need to consume all outstanding skb is because
> xennet_get_responses() would reset both queue->rx_skbs[i] and
> queue->grant_rx_ref[i] to NULL before enqueue all outstanding skb to the list
> (e.g., &tmpq), by xennet_get_rx_skb() and xennet_get_rx_ref().
> 
> If we do not consume all of them, we would hit NULL in queue->rx_skbs[i] in next
> iteration of while loop in xennet_poll().
> 
> That is, if we do not consume all outstanding skb, the queue->rx.rsp_cons may
> refer to a response whose queue->rx_skbs[i] and queue->grant_rx_ref[i] are
> already reset to NULL.

Thanks for confirming. I just wanted to make sure I understand your
patch correctly. :-)


Juergen
