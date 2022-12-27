Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32C365686A
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 09:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiL0I2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 03:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiL0I2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 03:28:08 -0500
Received: from out199-12.us.a.mail.aliyun.com (out199-12.us.a.mail.aliyun.com [47.90.199.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA8D26CE;
        Tue, 27 Dec 2022 00:28:04 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VYChnLe_1672129680;
Received: from 30.120.189.46(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VYChnLe_1672129680)
          by smtp.aliyun-inc.com;
          Tue, 27 Dec 2022 16:28:01 +0800
Message-ID: <e50d4a73-d997-ab2b-db73-448a0f5a8d1c@linux.alibaba.com>
Date:   Tue, 27 Dec 2022 16:27:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [PATCH v2 8/9] virtio_net: remove xdp related info from
 page_to_skb()
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221220141449.115918-9-hengqi@linux.alibaba.com>
 <7ac52b7e-05ea-600b-bb8a-15124c6c007d@redhat.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <7ac52b7e-05ea-600b-bb8a-15124c6c007d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/12/27 下午3:55, Jason Wang 写道:
>
> 在 2022/12/20 22:14, Heng Qi 写道:
>> For the clear construction of xdp_buff, we remove the xdp processing
>> interleaved with page_to_skb(). Now, the logic of xdp and building
>> skb from xdp are separate and independent.
>>
>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
>
> Acked-by: Jason Wang <jasowang@redhat.com>

Thanks for your energy.

>
> Thanks
>
>
>> ---
>>   drivers/net/virtio_net.c | 41 +++++++++-------------------------------
>>   1 file changed, 9 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 4e12196fcfd4..398ffe2a5084 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -439,9 +439,7 @@ static unsigned int 
>> mergeable_ctx_to_truesize(void *mrg_ctx)
>>   static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>                      struct receive_queue *rq,
>>                      struct page *page, unsigned int offset,
>> -                   unsigned int len, unsigned int truesize,
>> -                   bool hdr_valid, unsigned int metasize,
>> -                   unsigned int headroom)
>> +                   unsigned int len, unsigned int truesize)
>>   {
>>       struct sk_buff *skb;
>>       struct virtio_net_hdr_mrg_rxbuf *hdr;
>> @@ -459,21 +457,11 @@ static struct sk_buff *page_to_skb(struct 
>> virtnet_info *vi,
>>       else
>>           hdr_padded_len = sizeof(struct padded_vnet_hdr);
>>   -    /* If headroom is not 0, there is an offset between the 
>> beginning of the
>> -     * data and the allocated space, otherwise the data and the 
>> allocated
>> -     * space are aligned.
>> -     *
>> -     * Buffers with headroom use PAGE_SIZE as alloc size, see
>> -     * add_recvbuf_mergeable() + get_mergeable_buf_len()
>> -     */
>> -    truesize = headroom ? PAGE_SIZE : truesize;
>> -    tailroom = truesize - headroom;
>> -    buf = p - headroom;
>> -
>> +    buf = p;
>>       len -= hdr_len;
>>       offset += hdr_padded_len;
>>       p += hdr_padded_len;
>> -    tailroom -= hdr_padded_len + len;
>> +    tailroom = truesize - hdr_padded_len - len;
>>         shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>>   @@ -503,7 +491,7 @@ static struct sk_buff *page_to_skb(struct 
>> virtnet_info *vi,
>>       if (len <= skb_tailroom(skb))
>>           copy = len;
>>       else
>> -        copy = ETH_HLEN + metasize;
>> +        copy = ETH_HLEN;
>>       skb_put_data(skb, p, copy);
>>         len -= copy;
>> @@ -542,19 +530,11 @@ static struct sk_buff *page_to_skb(struct 
>> virtnet_info *vi,
>>           give_pages(rq, page);
>>     ok:
>> -    /* hdr_valid means no XDP, so we can copy the vnet header */
>> -    if (hdr_valid) {
>> -        hdr = skb_vnet_hdr(skb);
>> -        memcpy(hdr, hdr_p, hdr_len);
>> -    }
>> +    hdr = skb_vnet_hdr(skb);
>> +    memcpy(hdr, hdr_p, hdr_len);
>>       if (page_to_free)
>>           put_page(page_to_free);
>>   -    if (metasize) {
>> -        __skb_pull(skb, metasize);
>> -        skb_metadata_set(skb, metasize);
>> -    }
>> -
>>       return skb;
>>   }
>>   @@ -934,7 +914,7 @@ static struct sk_buff *receive_big(struct 
>> net_device *dev,
>>   {
>>       struct page *page = buf;
>>       struct sk_buff *skb =
>> -        page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);
>> +        page_to_skb(vi, rq, page, 0, len, PAGE_SIZE);
>>         stats->bytes += len - vi->hdr_len;
>>       if (unlikely(!skb))
>> @@ -1222,9 +1202,7 @@ static struct sk_buff *receive_mergeable(struct 
>> net_device *dev,
>>                   rcu_read_unlock();
>>                   put_page(page);
>>                   head_skb = page_to_skb(vi, rq, xdp_page, offset,
>> -                               len, PAGE_SIZE, false,
>> -                               metasize,
>> -                               headroom);
>> +                               len, PAGE_SIZE);
>>                   return head_skb;
>>               }
>>               break;
>> @@ -1289,8 +1267,7 @@ static struct sk_buff *receive_mergeable(struct 
>> net_device *dev,
>>       rcu_read_unlock();
>>     skip_xdp:
>> -    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, 
>> !xdp_prog,
>> -                   metasize, headroom);
>> +    head_skb = page_to_skb(vi, rq, page, offset, len, truesize);
>>       curr_skb = head_skb;
>>         if (unlikely(!curr_skb))

