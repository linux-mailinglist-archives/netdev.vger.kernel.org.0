Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB828646A58
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLHIVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLHIVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:21:19 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FA45654D;
        Thu,  8 Dec 2022 00:21:17 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hengqi@linux.alibaba.com;NM=0;PH=DS;RN=11;SR=0;TI=SMTPD_---0VWpUU8v_1670487604;
Received: from 30.221.147.145(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VWpUU8v_1670487604)
          by smtp.aliyun-inc.com;
          Thu, 08 Dec 2022 16:21:14 +0800
Message-ID: <07bcef11-819b-b516-26a1-6e80e74c5970@linux.alibaba.com>
Date:   Thu, 8 Dec 2022 16:21:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [RFC PATCH 2/9] virtio_net: set up xdp for multi buffer packets
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
 <20221122074348.88601-3-hengqi@linux.alibaba.com>
 <CACGkMEsaU1Ogytfmy4rVYx6U2Rkd3HcLMjuULZPvR-JJHeRkgA@mail.gmail.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <CACGkMEsaU1Ogytfmy4rVYx6U2Rkd3HcLMjuULZPvR-JJHeRkgA@mail.gmail.com>
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



在 2022/12/6 下午1:29, Jason Wang 写道:
> On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>> When the xdp program sets xdp.frags, which means it can process
>> multi-buffer packets, so we continue to open xdp support when
>> features such as GRO_HW are negotiated.
>>
>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> ---
>>   drivers/net/virtio_net.c | 30 +++++++++++++++++-------------
>>   1 file changed, 17 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index c5046d21b281..8f7d207d58d6 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -3080,14 +3080,21 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>          u16 xdp_qp = 0, curr_qp;
>>          int i, err;
>>
>> -       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)
>> -           && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>> -               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
>> -               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
>> -               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
>> -               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
>> -               NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
>> -               return -EOPNOTSUPP;
>> +       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
>> +               if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM)) {
>> +                       NL_SET_ERR_MSG_MOD(extack, "Can't set XDP without frags while guest is implementing GUEST_CSUM");
>> +                       return -EOPNOTSUPP;
>> +               }
>> +
>> +               if (prog && !prog->aux->xdp_has_frags) {
>> +                       if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>> +                           virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
>> +                           virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
>> +                           virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO)) {
>> +                               NL_SET_ERR_MSG_MOD(extack, "Can't set XDP without frags while guest is implementing GUEST_GRO_HW");
>> +                               return -EOPNOTSUPP;
>> +                       }
>> +               }
>>          }
>>
>>          if (vi->mergeable_rx_bufs && !vi->any_header_sg) {
>> @@ -3095,8 +3102,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>                  return -EINVAL;
>>          }
>>
>> -       if (dev->mtu > max_sz) {
>> -               NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
>> +       if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
>> +               NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP without frags");
>>                  netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
>>                  return -EINVAL;
>>          }
>> @@ -3218,9 +3225,6 @@ static int virtnet_set_features(struct net_device *dev,
>>          int err;
>>
>>          if ((dev->features ^ features) & NETIF_F_GRO_HW) {
>> -               if (vi->xdp_enabled)
>> -                       return -EBUSY;
> This seems suspicious, GRO_HW could be re-enabled accidentally even if
> it was disabled when attaching an XDP program that is not capable of
> doing multi-buffer XDP?

Yes, we shouldn't drop this check, because GRO_HW is unfriendly to xdp 
programs without xdp.frags.

Thanks.

>
> Thanks
>
>> -
>>                  if (features & NETIF_F_GRO_HW)
>>                          offloads = vi->guest_offloads_capable;
>>                  else
>> --
>> 2.19.1.6.gb485710b
>>

