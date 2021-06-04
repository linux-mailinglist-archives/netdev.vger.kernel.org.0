Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E56739B251
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFDGCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:02:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229794AbhFDGCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622786416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iBJhxtrnOYsi+Y8OaVI5OTALm56FJkC4KNF0o6yFuxQ=;
        b=WGHFl8WUZ6YWlIdm2wwVVD2zYPqgABfMoLTMNkDdZDvShoAmaml/uIu2Wo3zj+xGgiM91s
        XEMKJXKCjCsvHb63nxI61uqL96/bVGwNtI09b8Z/FhnUNwXoQP2hkm9v+7ADCkS8HifCzd
        P3mAc2cRyh01ENzk9KFoqvXwLa8F+Uw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-Om9x8gtZM7yee2VUoPn3xA-1; Fri, 04 Jun 2021 02:00:15 -0400
X-MC-Unique: Om9x8gtZM7yee2VUoPn3xA-1
Received: by mail-pf1-f197.google.com with SMTP id l3-20020a056a001403b02902ea25d3c7d4so4183837pfu.15
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 23:00:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iBJhxtrnOYsi+Y8OaVI5OTALm56FJkC4KNF0o6yFuxQ=;
        b=WoDxrgWKFuaQEqyYqNU8BEBBrbbdWaZCISbZv0KeTxgIv7a5/CnUpamF6HqPNjJ56E
         cg1y9elFuWu/oG0y2Boxb0UJd6M+cAI88EXthhZ4cDZBKGtppOXXAc4XKjV0u9h0Xm9P
         8AthXJFSGncHKurYN8nsLVhlVS3KrLusIAH/nUjNaKH6hS2CNVjJloi6r92pTRhvSxxi
         OarBV/WeZmvdkGiQxUqygTbieNipU0POiWUHJmHcM++Etx4ykZmg3Fw27yLF8mTekAdJ
         SmLIkumqJmEAwBYaDJlkuKqps8ofQ9Z4mkPeWqC9k7rzU6qyvFmZCnmeoeOL54kGA8qd
         RTSw==
X-Gm-Message-State: AOAM531zbPSBZdo/uJqemvgbmp3ejcN0JeJBxW6rJOXNVBpHunDTsq78
        05uIq5KgAvqRThhCmeYA3NNrgm2aSXZpZokPhJovRewD3k/d+akRP9reQgwF524w+GB5gy/zGMT
        UiSoZ/26bLiYeH+unO9CgbHVmWg+lXrR/dulIennpAeRp7G6hawHNnH32zs1Pk+eUm0ZQ
X-Received: by 2002:a63:5504:: with SMTP id j4mr3327264pgb.238.1622786414232;
        Thu, 03 Jun 2021 23:00:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxD4rpw/wgVIft/eHf0FtdHuY/ufgrcGmVbrjoybgnSsV4bV+QXRJn9+kFtfgsyckxGF9Adg==
X-Received: by 2002:a63:5504:: with SMTP id j4mr3327226pgb.238.1622786413831;
        Thu, 03 Jun 2021 23:00:13 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m12sm3598393pjq.53.2021.06.03.23.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 23:00:13 -0700 (PDT)
Subject: Re: [PATCH net] virtio-net: fix for skb_over_panic inside big mode
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?Q?Corentin_No=c3=abl?= <corentin.noel@collabora.com>,
        netdev@vger.kernel.org
References: <1622775955.0233824-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <620c6905-d528-1992-a08e-b22b21871f7e@redhat.com>
Date:   Fri, 4 Jun 2021 14:00:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1622775955.0233824-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/4 上午11:05, Xuan Zhuo 写道:
> On Fri, 4 Jun 2021 11:00:25 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2021/6/4 上午10:30, Xuan Zhuo 写道:
>>> On Fri, 4 Jun 2021 10:28:41 +0800, Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/6/4 上午1:09, Xuan Zhuo 写道:
>>>>> In virtio-net's large packet mode, there is a hole in the space behind
>>>>> buf.
>>>> before the buf actually or behind the vnet header?
>>>>
>>>>
>>>>>        hdr_padded_len - hdr_len
>>>>>
>>>>> We must take this into account when calculating tailroom.
>>>>>
>>>>> [   44.544385] skb_put.cold (net/core/skbuff.c:5254 (discriminator 1) net/core/skbuff.c:5252 (discriminator 1))
>>>>> [   44.544864] page_to_skb (drivers/net/virtio_net.c:485) [   44.545361] receive_buf (drivers/net/virtio_net.c:849 drivers/net/virtio_net.c:1131)
>>>>> [   44.545870] ? netif_receive_skb_list_internal (net/core/dev.c:5714)
>>>>> [   44.546628] ? dev_gro_receive (net/core/dev.c:6103)
>>>>> [   44.547135] ? napi_complete_done (./include/linux/list.h:35 net/core/dev.c:5867 net/core/dev.c:5862 net/core/dev.c:6565)
>>>>> [   44.547672] virtnet_poll (drivers/net/virtio_net.c:1427 drivers/net/virtio_net.c:1525)
>>>>> [   44.548251] __napi_poll (net/core/dev.c:6985)
>>>>> [   44.548744] net_rx_action (net/core/dev.c:7054 net/core/dev.c:7139)
>>>>> [   44.549264] __do_softirq (./arch/x86/include/asm/jump_label.h:19 ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142 kernel/softirq.c:560)
>>>>> [   44.549762] irq_exit_rcu (kernel/softirq.c:433 kernel/softirq.c:637 kernel/softirq.c:649)
>>>>> [   44.551384] common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 13))
>>>>> [   44.551991] ? asm_common_interrupt (./arch/x86/include/asm/idtentry.h:638)
>>>>> [   44.552654] asm_common_interrupt (./arch/x86/include/asm/idtentry.h:638)
>>>>>
>>>>> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
>>>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>>>> Reported-by: Corentin Noël <corentin.noel@collabora.com>
>>>>> Tested-by: Corentin Noël <corentin.noel@collabora.com>
>>>>> ---
>>>>>     drivers/net/virtio_net.c | 2 +-
>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>> index fa407eb8b457..78a01c71a17c 100644
>>>>> --- a/drivers/net/virtio_net.c
>>>>> +++ b/drivers/net/virtio_net.c
>>>>> @@ -406,7 +406,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>>>>     	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
>>>>>     	 */
>>>>>     	truesize = headroom ? PAGE_SIZE : truesize;
>>>>> -	tailroom = truesize - len - headroom;
>>>>> +	tailroom = truesize - len - headroom - (hdr_padded_len - hdr_len);
>>>> The patch looks correct and I saw it has been merged.
>>>>
>>>> But I prefer to do that in receive_big() instead of here.
>>>>
>>>> Thanks
>>> How?
>>>
>>> change truesize or headroom?
>>>
>>> I didn't find a good way. Do you have a good way?
>>
>> Something like the following? The API is designed to let the caller to
>> pass a correct headroom instead of figure it out by itself.
>>
>>           struct sk_buff *skb =
>>                   page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0,
>> hdr_padded_len - hdr_len);
>>
>> Thanks
>
> This line may be affected.
>
> 	buf = p - headroom;
>
> In my opinion, this changes the semantics of the original headroom. The meaning
> of headroom in big mode and merge mode has become different. The more confusing
> problem is that the parameters of page_to_skb() are getting more and more
> chaotic.  So I wrote the previous patch. Of course, I understand your concern.
> This patch may bring Here are more questions, although I did a lot of tests.
>
> 	"virtio-net: Refactor the code related to page_to_skb"
>
> But I hope that our code development direction is as close to what this patch
> realizes. I hope that the meaning of the parameters can be more clear.


So I don't object to this method, but as I replied, it's better to do 
some benchmark to see if it introduces any regression


>
> Do you think this is ok?


Looks ok, but if we decide to go with your approach, it can be squashed 
into that patch.

Thanks


>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 78a01c71a17c..6d62bb45a188 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -380,34 +380,20 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   				   struct page *page, unsigned int offset,
>   				   unsigned int len, unsigned int truesize,
>   				   bool hdr_valid, unsigned int metasize,
> -				   unsigned int headroom)
> +				   int tailroom, char *buf,
> +				   unsigned int hdr_padded_len)
>   {
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> -	unsigned int copy, hdr_len, hdr_padded_len;
> +	unsigned int copy, hdr_len;
>   	struct page *page_to_free = NULL;
> -	int tailroom, shinfo_size;
> -	char *p, *hdr_p, *buf;
> +	int shinfo_size;
> +	char *p, *hdr_p;
>
>   	p = page_address(page) + offset;
>   	hdr_p = p;
>
>   	hdr_len = vi->hdr_len;
> -	if (vi->mergeable_rx_bufs)
> -		hdr_padded_len = sizeof(*hdr);
> -	else
> -		hdr_padded_len = sizeof(struct padded_vnet_hdr);
> -
> -	/* If headroom is not 0, there is an offset between the beginning of the
> -	 * data and the allocated space, otherwise the data and the allocated
> -	 * space are aligned.
> -	 *
> -	 * Buffers with headroom use PAGE_SIZE as alloc size, see
> -	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
> -	 */
> -	truesize = headroom ? PAGE_SIZE : truesize;
> -	tailroom = truesize - len - headroom - (hdr_padded_len - hdr_len);
> -	buf = p - headroom;
>
>   	len -= hdr_len;
>   	offset += hdr_padded_len;
> @@ -492,6 +478,51 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	return skb;
>   }
>
> +static struct sk_buff *merge_page_to_skb(struct virtnet_info *vi,
> +					 struct receive_queue *rq,
> +					 struct page *page, unsigned int offset,
> +					 unsigned int len, unsigned int truesize,
> +					 bool hdr_valid, unsigned int metasize,
> +					 unsigned int headroom)
> +{
> +	int tailroom;
> +	char *buf;
> +
> +	/* If headroom is not 0, there is an offset between the beginning of the
> +	 * data and the allocated space, otherwise the data and the allocated
> +	 * space are aligned.
> +	 *
> +	 * Buffers with headroom use PAGE_SIZE as alloc size, see
> +	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
> +	 */
> +	truesize = headroom ? PAGE_SIZE : truesize;
> +	tailroom = truesize - len - headroom;
> +	buf = page_address(page) + offset - headroom;
> +
> +	page_to_skb(vi, rq, page, offset, len, truesize, hdr_valid, metasize,
> +		    tailroom, buf, sizeof(struct virtio_net_hdr_mrg_rxbuf))
> +
> +}
> +
> +static struct sk_buff *big_page_to_skb(struct virtnet_info *vi,
> +				       struct receive_queue *rq,
> +				       struct page *page, unsigned int offset,
> +				       unsigned int len, unsigned int truesize,
> +				       bool hdr_valid, unsigned int metasize,
> +				       unsigned int headroom)
> +{
> +	char *p = page_address(page);
> +	int hold;
> +	int tailroom;
> +
> +	hold = sizeof(struct padded_vnet_hdr) - vi->hdr_len;
> +
> +	tailroom = truesize - len - headroom - hold;
> +
> +	page_to_skb(vi, rq, page, offset, len, truesize, hdr_valid, metasize,
> +		    tailroom, p, sizeof(struct padded_vnet_hdr));
> +}
> +
>   static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>   				   struct send_queue *sq,
>   				   struct xdp_frame *xdpf)
>
>
>>
>>> Thanks.
>>>
>>>>
>>>>>     	buf = p - headroom;
>>>>>
>>>>>     	len -= hdr_len;

