Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAB66567FB
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiL0HwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiL0HwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:52:08 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A755FC4;
        Mon, 26 Dec 2022 23:52:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VYCu.ol_1672127522;
Received: from 30.120.189.46(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VYCu.ol_1672127522)
          by smtp.aliyun-inc.com;
          Tue, 27 Dec 2022 15:52:03 +0800
Message-ID: <c29d56a0-ada7-9399-201e-87a64e203de1@linux.alibaba.com>
Date:   Tue, 27 Dec 2022 15:51:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [PATCH v2 7/9] virtio_net: build skb from multi-buffer xdp
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
 <20221220141449.115918-8-hengqi@linux.alibaba.com>
 <9d049351-11c8-2178-c88c-6d4496df773e@redhat.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <9d049351-11c8-2178-c88c-6d4496df773e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/12/27 下午3:31, Jason Wang 写道:
>
> 在 2022/12/20 22:14, Heng Qi 写道:
>> This converts the xdp_buff directly to a skb, including
>> multi-buffer and single buffer xdp. We'll isolate the
>> construction of skb based on xdp from page_to_skb().
>>
>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> ---
>>   drivers/net/virtio_net.c | 50 ++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 50 insertions(+)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 9f31bfa7f9a6..4e12196fcfd4 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -948,6 +948,56 @@ static struct sk_buff *receive_big(struct 
>> net_device *dev,
>>       return NULL;
>>   }
>>   +/* Why not use xdp_build_skb_from_frame() ?
>> + * XDP core assumes that xdp frags are PAGE_SIZE in length, while in
>> + * virtio-net there are 2 points that do not match its requirements:
>> + *  1. The size of the prefilled buffer is not fixed before xdp is set.
>> + *  2. When xdp is loaded, virtio-net has a hole mechanism (refer to
>> + *     add_recvbuf_mergeable()), which will make the size of a buffer
>> + *     exceed PAGE_SIZE.
>
>
> Is point 2 still valid after patch 1?

Yes, it is invalid anymore, I'll correct that, and there's a little more 
reason that
xdp_build_skb_from_frame() does more checks that we don't need, like
eth_type_trans() (which virtio-net does in receive_buf()).

>
> Other than this:
>
> Acked-by: Jason Wang <jasowang@redhat.com>

Thanks for your energy.

>
> Thanks
>
>
>> + */
>> +static struct sk_buff *build_skb_from_xdp_buff(struct net_device *dev,
>> +                           struct virtnet_info *vi,
>> +                           struct xdp_buff *xdp,
>> +                           unsigned int xdp_frags_truesz)
>> +{
>> +    struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
>> +    unsigned int headroom, data_len;
>> +    struct sk_buff *skb;
>> +    int metasize;
>> +    u8 nr_frags;
>> +
>> +    if (unlikely(xdp->data_end > xdp_data_hard_end(xdp))) {
>> +        pr_debug("Error building skb as missing reserved tailroom 
>> for xdp");
>> +        return NULL;
>> +    }
>> +
>> +    if (unlikely(xdp_buff_has_frags(xdp)))
>> +        nr_frags = sinfo->nr_frags;
>> +
>> +    skb = build_skb(xdp->data_hard_start, xdp->frame_sz);
>> +    if (unlikely(!skb))
>> +        return NULL;
>> +
>> +    headroom = xdp->data - xdp->data_hard_start;
>> +    data_len = xdp->data_end - xdp->data;
>> +    skb_reserve(skb, headroom);
>> +    __skb_put(skb, data_len);
>> +
>> +    metasize = xdp->data - xdp->data_meta;
>> +    metasize = metasize > 0 ? metasize : 0;
>> +    if (metasize)
>> +        skb_metadata_set(skb, metasize);
>> +
>> +    if (unlikely(xdp_buff_has_frags(xdp)))
>> +        xdp_update_skb_shared_info(skb, nr_frags,
>> +                       sinfo->xdp_frags_size,
>> +                       xdp_frags_truesz,
>> +                       xdp_buff_is_frag_pfmemalloc(xdp));
>> +
>> +    return skb;
>> +}
>> +
>>   /* TODO: build xdp in big mode */
>>   static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>>                         struct virtnet_info *vi,

