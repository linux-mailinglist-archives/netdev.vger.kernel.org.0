Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF24E646A61
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLHIXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiLHIXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:23:19 -0500
Received: from out30-8.freemail.mail.aliyun.com (out30-8.freemail.mail.aliyun.com [115.124.30.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4408E10068;
        Thu,  8 Dec 2022 00:23:18 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hengqi@linux.alibaba.com;NM=0;PH=DS;RN=11;SR=0;TI=SMTPD_---0VWpd4T2_1670487793;
Received: from 30.221.147.145(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VWpd4T2_1670487793)
          by smtp.aliyun-inc.com;
          Thu, 08 Dec 2022 16:23:14 +0800
Message-ID: <3f5b23d8-e008-1586-9c15-a4e29d67e5b3@linux.alibaba.com>
Date:   Thu, 8 Dec 2022 16:23:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [RFC PATCH 4/9] virtio_net: remove xdp related info from
 page_to_skb()
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20221122074348.88601-1-hengqi@linux.alibaba.com>
 <20221122074348.88601-5-hengqi@linux.alibaba.com>
 <CACGkMEsvKFBCfwsv1J5gXW6anQOZGuJfWPm9ku6v8i_BbWjLCw@mail.gmail.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <CACGkMEsvKFBCfwsv1J5gXW6anQOZGuJfWPm9ku6v8i_BbWjLCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/12/6 下午1:36, Jason Wang 写道:
> On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>> For the clear construction of multi-buffer xdp_buff, we now remove the xdp
>> processing interleaved with page_to_skb() before, and the logic of xdp and
>> building skb from xdp will be separate and independent.
>>
>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> So I think the organization of this series needs some tweak.
>
> If I was not not and if we do things like this, XDP support is
> actually broken and it breaks bisection and a lot of other things.
>
> We need make sure each patch does not break anything, it probably requires
>
> 1) squash the following patches or
> 2) having a new helper to do XDP stuffs after/before page_to_skb()

Your comments are informative, I'm going to make this patch more 
independent of
"[PATCH 9/9] virtio_net: support multi-buffer xdp", so that each patch 
doesn't break anything.

Thanks.

>
> Thanks
>
>> ---
>>   drivers/net/virtio_net.c | 41 +++++++++-------------------------------
>>   1 file changed, 9 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index d3e8c63b9c4b..cd65f85d5075 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -439,9 +439,7 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
>>   static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>                                     struct receive_queue *rq,
>>                                     struct page *page, unsigned int offset,
>> -                                  unsigned int len, unsigned int truesize,
>> -                                  bool hdr_valid, unsigned int metasize,
>> -                                  unsigned int headroom)
>> +                                  unsigned int len, unsigned int truesize)
>>   {
>>          struct sk_buff *skb;
>>          struct virtio_net_hdr_mrg_rxbuf *hdr;
>> @@ -459,21 +457,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>          else
>>                  hdr_padded_len = sizeof(struct padded_vnet_hdr);
>>
>> -       /* If headroom is not 0, there is an offset between the beginning of the
>> -        * data and the allocated space, otherwise the data and the allocated
>> -        * space are aligned.
>> -        *
>> -        * Buffers with headroom use PAGE_SIZE as alloc size, see
>> -        * add_recvbuf_mergeable() + get_mergeable_buf_len()
>> -        */
>> -       truesize = headroom ? PAGE_SIZE : truesize;
>> -       tailroom = truesize - headroom;
>> -       buf = p - headroom;
>> -
>> +       buf = p;
>>          len -= hdr_len;
>>          offset += hdr_padded_len;
>>          p += hdr_padded_len;
>> -       tailroom -= hdr_padded_len + len;
>> +       tailroom = truesize - hdr_padded_len - len;
>>
>>          shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>>
>> @@ -503,7 +491,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>          if (len <= skb_tailroom(skb))
>>                  copy = len;
>>          else
>> -               copy = ETH_HLEN + metasize;
>> +               copy = ETH_HLEN;
>>          skb_put_data(skb, p, copy);
>>
>>          len -= copy;
>> @@ -542,19 +530,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>                  give_pages(rq, page);
>>
>>   ok:
>> -       /* hdr_valid means no XDP, so we can copy the vnet header */
>> -       if (hdr_valid) {
>> -               hdr = skb_vnet_hdr(skb);
>> -               memcpy(hdr, hdr_p, hdr_len);
>> -       }
>> +       hdr = skb_vnet_hdr(skb);
>> +       memcpy(hdr, hdr_p, hdr_len);
>>          if (page_to_free)
>>                  put_page(page_to_free);
>>
>> -       if (metasize) {
>> -               __skb_pull(skb, metasize);
>> -               skb_metadata_set(skb, metasize);
>> -       }
>> -
>>          return skb;
>>   }
>>
>> @@ -917,7 +897,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
>>   {
>>          struct page *page = buf;
>>          struct sk_buff *skb =
>> -               page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);
>> +               page_to_skb(vi, rq, page, 0, len, PAGE_SIZE);
>>
>>          stats->bytes += len - vi->hdr_len;
>>          if (unlikely(!skb))
>> @@ -1060,9 +1040,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>                                  rcu_read_unlock();
>>                                  put_page(page);
>>                                  head_skb = page_to_skb(vi, rq, xdp_page, offset,
>> -                                                      len, PAGE_SIZE, false,
>> -                                                      metasize,
>> -                                                      headroom);
>> +                                                      len, PAGE_SIZE);
>>                                  return head_skb;
>>                          }
>>                          break;
>> @@ -1116,8 +1094,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>          rcu_read_unlock();
>>
>>   skip_xdp:
>> -       head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
>> -                              metasize, headroom);
>> +       head_skb = page_to_skb(vi, rq, page, offset, len, truesize);
>>          curr_skb = head_skb;
>>
>>          if (unlikely(!curr_skb))
>> --
>> 2.19.1.6.gb485710b
>>

