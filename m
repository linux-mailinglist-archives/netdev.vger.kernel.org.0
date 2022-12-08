Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D634646A4F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiLHIUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLHIUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:20:09 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3185B12A88;
        Thu,  8 Dec 2022 00:20:07 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hengqi@linux.alibaba.com;NM=0;PH=DS;RN=11;SR=0;TI=SMTPD_---0VWpUU8Q_1670487603;
Received: from 30.221.147.145(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VWpUU8Q_1670487603)
          by smtp.aliyun-inc.com;
          Thu, 08 Dec 2022 16:20:04 +0800
Message-ID: <39346e63-81ea-4257-5274-8b6b2ce4f3d3@linux.alibaba.com>
Date:   Thu, 8 Dec 2022 16:20:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [RFC PATCH 1/9] virtio_net: disable the hole mechanism for xdp
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
 <20221122074348.88601-2-hengqi@linux.alibaba.com>
 <CACGkMEvLbpNry+ROQof=tPOoX0W3-qths6493uvjBpb0nNinBQ@mail.gmail.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <CACGkMEvLbpNry+ROQof=tPOoX0W3-qths6493uvjBpb0nNinBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/12/6 下午1:20, Jason Wang 写道:
> On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>> XDP core assumes that the frame_size of xdp_buff and the length of
>> the frag are PAGE_SIZE. But before xdp is set, the length of the prefilled
>> buffer may exceed PAGE_SIZE, which may cause the processing of xdp to fail,
>> so we disable the hole mechanism when xdp is loaded.
>>
>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> ---
>>   drivers/net/virtio_net.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 9cce7dec7366..c5046d21b281 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1419,8 +1419,11 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>>                  /* To avoid internal fragmentation, if there is very likely not
>>                   * enough space for another buffer, add the remaining space to
>>                   * the current buffer.
>> +                * XDP core assumes that frame_size of xdp_buff and the length
>> +                * of the frag are PAGE_SIZE, so we disable the hole mechanism.
>>                   */
>> -               len += hole;
>> +               if (!vi->xdp_enabled)
> How is this synchronized with virtnet_xdp_set()?
>
> I think we need to use headroom here since it did:
>
> static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
> {
>          return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
> }
>
> Otherwise xdp_enabled could be re-read which may lead bugs.

Yes, we should use headroom instead of using vi->xdp_enabled twice in 
the same
position to avoid re-reading.

Thanks for reminding.

>
> Thanks
>
>> +                       len += hole;
>>                  alloc_frag->offset += hole;
>>          }
>>
>> --
>> 2.19.1.6.gb485710b
>>

