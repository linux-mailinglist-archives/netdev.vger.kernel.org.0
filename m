Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE39C646AA3
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiLHIfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLHIfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:35:44 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37F560EB4;
        Thu,  8 Dec 2022 00:35:42 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hengqi@linux.alibaba.com;NM=0;PH=DS;RN=11;SR=0;TI=SMTPD_---0VWpWRxv_1670488538;
Received: from 30.221.147.145(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VWpWRxv_1670488538)
          by smtp.aliyun-inc.com;
          Thu, 08 Dec 2022 16:35:39 +0800
Message-ID: <e1f2d723-4810-50c9-409f-d6761600beb8@linux.alibaba.com>
Date:   Thu, 8 Dec 2022 16:35:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [RFC PATCH 3/9] virtio_net: update bytes calculation for
 xdp_frame
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
 <20221122074348.88601-4-hengqi@linux.alibaba.com>
 <CACGkMEu_WTLJ4QRJ4_KevGLFAu=L7qgY6zV0McnSsDe2TLRawQ@mail.gmail.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <CACGkMEu_WTLJ4QRJ4_KevGLFAu=L7qgY6zV0McnSsDe2TLRawQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/12/6 下午1:31, Jason Wang 写道:
> On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>> Update relative record value for xdp_frame as basis
>> for multi-buffer xdp transmission.
>>
>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Thanks for your energy, you are awesome.

>
> Thanks
>
>> ---
>>   drivers/net/virtio_net.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 8f7d207d58d6..d3e8c63b9c4b 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -658,7 +658,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>>                  if (likely(is_xdp_frame(ptr))) {
>>                          struct xdp_frame *frame = ptr_to_xdp(ptr);
>>
>> -                       bytes += frame->len;
>> +                       bytes += xdp_get_frame_len(frame);
>>                          xdp_return_frame(frame);
>>                  } else {
>>                          struct sk_buff *skb = ptr;
>> @@ -1604,7 +1604,7 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
>>                  } else {
>>                          struct xdp_frame *frame = ptr_to_xdp(ptr);
>>
>> -                       bytes += frame->len;
>> +                       bytes += xdp_get_frame_len(frame);
>>                          xdp_return_frame(frame);
>>                  }
>>                  packets++;
>> --
>> 2.19.1.6.gb485710b
>>

