Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB06689D4
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 04:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjAMDAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 22:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbjAMDAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 22:00:09 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD06C5E67A;
        Thu, 12 Jan 2023 19:00:02 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VZSlGyA_1673578791;
Received: from 30.221.147.157(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VZSlGyA_1673578791)
          by smtp.aliyun-inc.com;
          Fri, 13 Jan 2023 10:59:52 +0800
Message-ID: <d1ebd2a7-10e7-354b-1256-02520c7d29cb@linux.alibaba.com>
Date:   Fri, 13 Jan 2023 10:59:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [PATCH v3 2/9] virtio-net: set up xdp for multi buffer packets
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
References: <20230103064012.108029-1-hengqi@linux.alibaba.com>
 <20230103064012.108029-3-hengqi@linux.alibaba.com>
 <b99c54de-550e-fa4c-a26f-428096680f00@redhat.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <b99c54de-550e-fa4c-a26f-428096680f00@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2023/1/13 上午10:49, Jason Wang 写道:
>
> 在 2023/1/3 14:40, Heng Qi 写道:
>> When the xdp program sets xdp.frags, which means it can process
>> multi-buffer packets over larger MTU, so we continue to support xdp.
>> But for single-buffer xdp, we should keep checking for MTU.
>>
>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> ---
>>   drivers/net/virtio_net.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 443aa7b8f0ad..60e199811212 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -3074,7 +3074,9 @@ static int 
>> virtnet_restore_guest_offloads(struct virtnet_info *vi)
>>   static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog 
>> *prog,
>>                  struct netlink_ext_ack *extack)
>>   {
>> -    unsigned long int max_sz = PAGE_SIZE - sizeof(struct 
>> padded_vnet_hdr);
>> +    unsigned int room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
>> +                       sizeof(struct skb_shared_info));
>> +    unsigned int max_sz = PAGE_SIZE - room - ETH_HLEN;
>>       struct virtnet_info *vi = netdev_priv(dev);
>>       struct bpf_prog *old_prog;
>>       u16 xdp_qp = 0, curr_qp;
>> @@ -3095,9 +3097,9 @@ static int virtnet_xdp_set(struct net_device 
>> *dev, struct bpf_prog *prog,
>>           return -EINVAL;
>>       }
>>   -    if (dev->mtu > max_sz) {
>> -        NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
>> -        netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
>> +    if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
>> +        NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP 
>> without frags");
>> +        netdev_warn(dev, "single-buffer XDP requires MTU less than 
>> %u\n", max_sz);
>>           return -EINVAL;
>>       }
>
>
> I think we probably need to backport this to -stable. So I suggest to 
> move/squash the check of !prog->aux->xdp_has_frags to one of the 
> following patch.

Sure, and you are right.

Thanks.

>
> With this,
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks
>
>

