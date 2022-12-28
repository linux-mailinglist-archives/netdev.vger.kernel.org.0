Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF32A65726A
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 04:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiL1DvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 22:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiL1Du7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 22:50:59 -0500
Received: from out30-8.freemail.mail.aliyun.com (out30-8.freemail.mail.aliyun.com [115.124.30.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED5665FF;
        Tue, 27 Dec 2022 19:50:57 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VYFqIth_1672199452;
Received: from 30.15.240.205(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VYFqIth_1672199452)
          by smtp.aliyun-inc.com;
          Wed, 28 Dec 2022 11:50:54 +0800
Message-ID: <d2b1f378-e30a-2b54-b8da-e9eb874badee@linux.alibaba.com>
Date:   Wed, 28 Dec 2022 11:50:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [PATCH v2 2/9] virtio_net: set up xdp for multi buffer packets
From:   Heng Qi <hengqi@linux.alibaba.com>
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
 <20221220141449.115918-3-hengqi@linux.alibaba.com>
 <82eb2ffc-ce97-0c76-f7bc-8a163968cde7@redhat.com>
 <2704f3ad-9477-c9d2-8eca-01a9fa92732a@linux.alibaba.com>
In-Reply-To: <2704f3ad-9477-c9d2-8eca-01a9fa92732a@linux.alibaba.com>
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



在 2022/12/27 下午8:20, Heng Qi 写道:
>
>
> 在 2022/12/27 下午2:32, Jason Wang 写道:
>>
>> 在 2022/12/20 22:14, Heng Qi 写道:
>>> When the xdp program sets xdp.frags, which means it can process
>>> multi-buffer packets over larger MTU, so we continue to support xdp.
>>> But for single-buffer xdp, we should keep checking for MTU.
>>>
>>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>   drivers/net/virtio_net.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 443aa7b8f0ad..c5c4e9db4ed3 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -3095,8 +3095,8 @@ static int virtnet_xdp_set(struct net_device 
>>> *dev, struct bpf_prog *prog,
>>>           return -EINVAL;
>>>       }
>>>   -    if (dev->mtu > max_sz) {
>>> -        NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
>>> +    if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
>>
>>
>> Not related to this patch, but I see:
>>
>>         unsigned long int max_sz = PAGE_SIZE - sizeof(struct 
>> padded_vnet_hdr);
>>
>> Which is suspicious, do we need to count reserved headroom/tailroom 
>> as well?
>
> This seems to be suspicious. After loading xdp, the size of the filled 
> avail buffer
> is (PAGE_SIZE - headroom - tailroom), so the size of the received used 
> buffer, ie MTU,
> should also be (PAGE_SIZE - headroom - tailroom).

Hi Jason, this is indeed a problem. After verification, packet drop will 
indeed occur.  To avoid this,
the size of MTU should be (PAGE_SIZE - headroom - tailroom - ethhdr = 
4096 - 256 -320 - 14 =3506).
Because when there is xdp, each filling is 3520 (PAGE_SIZE - room), if 
the value of (MTU + 14) is
greater than 3520 (because the MTU does not contain the ethernet 
header), then the packet with a
length greater than 3520 will come in, so num_buf will still be greater 
than or equal to 2, and then
xdp_linearize_page() will be performed and the packet will be dropped 
because the total length is
greater than PAGE_SIZE.

I will make a separate bugfix patch to fix this later.

Thanks.

>
> Thanks.
>
>>
>> Thanks
>>
>>
>>> +        NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP 
>>> without frags");
>>>           netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
>>>           return -EINVAL;
>>>       }

