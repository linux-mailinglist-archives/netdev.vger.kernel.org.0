Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985E0656865
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 09:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiL0I0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 03:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiL0I0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 03:26:20 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27752666;
        Tue, 27 Dec 2022 00:26:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VYCwifb_1672129571;
Received: from 30.120.189.46(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VYCwifb_1672129571)
          by smtp.aliyun-inc.com;
          Tue, 27 Dec 2022 16:26:12 +0800
Message-ID: <f8b8e76c-6438-9ea5-18e4-24773fa01cfd@linux.alibaba.com>
Date:   Tue, 27 Dec 2022 16:26:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [PATCH v2 6/9] virtio_net: transmit the multi-buffer xdp
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
 <20221220141449.115918-7-hengqi@linux.alibaba.com>
 <af506b2f-698f-b3d8-8bc4-f48e2c429ce7@redhat.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <af506b2f-698f-b3d8-8bc4-f48e2c429ce7@redhat.com>
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



在 2022/12/27 下午3:12, Jason Wang 写道:
>
> 在 2022/12/20 22:14, Heng Qi 写道:
>> This serves as the basis for XDP_TX and XDP_REDIRECT
>> to send a multi-buffer xdp_frame.
>>
>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> ---
>>   drivers/net/virtio_net.c | 27 ++++++++++++++++++++++-----
>>   1 file changed, 22 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 40bc58fa57f5..9f31bfa7f9a6 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -563,22 +563,39 @@ static int __virtnet_xdp_xmit_one(struct 
>> virtnet_info *vi,
>>                      struct xdp_frame *xdpf)
>>   {
>>       struct virtio_net_hdr_mrg_rxbuf *hdr;
>> -    int err;
>> +    struct skb_shared_info *shinfo;
>> +    u8 nr_frags = 0;
>> +    int err, i;
>>         if (unlikely(xdpf->headroom < vi->hdr_len))
>>           return -EOVERFLOW;
>>   -    /* Make room for virtqueue hdr (also change xdpf->headroom?) */
>> +    if (unlikely(xdp_frame_has_frags(xdpf))) {
>> +        shinfo = xdp_get_shared_info_from_frame(xdpf);
>> +        nr_frags = shinfo->nr_frags;
>> +    }
>> +
>> +    /* Need to adjust this to calculate the correct postion
>> +     * for shinfo of the xdpf.
>> +     */
>> +    xdpf->headroom -= vi->hdr_len;
>
>
> Any reason we need to do this here? (Or if it is, is it only needed 
> for multibuffer XDP?)

Going back to its wrapping function virtnet_xdp_xmit(), we need to free 
up the pending old buffers.
If the "is_xdp_frame(ptr)" condition is met, then we need to calculate 
the position of skb_shared_info
in xdp_get_frame_len() and xdp_return_frame(), which will involve to 
xdpf->data and xdpf->headroom.
Therefore, we need to update the value of headroom synchronously here.

Also, it's not necessary for single-buffer xdp, but we need to keep it 
because it's harmless and as it should be.

Thanks.

>
> Other looks good.
>
> Thanks
>
>
>>       xdpf->data -= vi->hdr_len;
>>       /* Zero header and leave csum up to XDP layers */
>>       hdr = xdpf->data;
>>       memset(hdr, 0, vi->hdr_len);
>>       xdpf->len   += vi->hdr_len;
>>   -    sg_init_one(sq->sg, xdpf->data, xdpf->len);
>> +    sg_init_table(sq->sg, nr_frags + 1);
>> +    sg_set_buf(sq->sg, xdpf->data, xdpf->len);
>> +    for (i = 0; i < nr_frags; i++) {
>> +        skb_frag_t *frag = &shinfo->frags[i];
>> +
>> +        sg_set_page(&sq->sg[i + 1], skb_frag_page(frag),
>> +                skb_frag_size(frag), skb_frag_off(frag));
>> +    }
>>   -    err = virtqueue_add_outbuf(sq->vq, sq->sg, 1, xdp_to_ptr(xdpf),
>> -                   GFP_ATOMIC);
>> +    err = virtqueue_add_outbuf(sq->vq, sq->sg, nr_frags + 1,
>> +                   xdp_to_ptr(xdpf), GFP_ATOMIC);
>>       if (unlikely(err))
>>           return -ENOSPC; /* Caller handle free/refcnt */

