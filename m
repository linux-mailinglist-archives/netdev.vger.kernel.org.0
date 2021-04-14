Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B2F35EEC9
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349135AbhDNHwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:52:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347679AbhDNHwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618386717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QpV4QlutdUC0YACURiFDKFycuEucWOSaUyWywoS1lus=;
        b=Pb9qjoENPbXqxRPi/zHu2Hn3kN2oZ1smn/49HAjSZ+VVhCikF4HSP+G/QAwBhPpfNDkwQv
        0+O18eePFqZPL9Kai18GVDpeP9yDpNbZ4aMkgU2awTqV/gWNn2quCdcpRmOEdgXo6Uz16D
        CALHoXCMuH88RSw+L1W14Cn55UwI8FI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-GE-fulZ2NMGWijIvPHz59A-1; Wed, 14 Apr 2021 03:51:55 -0400
X-MC-Unique: GE-fulZ2NMGWijIvPHz59A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C50BBA40C1;
        Wed, 14 Apr 2021 07:51:52 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-33.pek2.redhat.com [10.72.13.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41D1F5D6AC;
        Wed, 14 Apr 2021 07:51:42 +0000 (UTC)
Subject: Re: [PATCH net-next v4 08/10] virtio-net: xsk zero copy xmit setup
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>,
        "dust . li" <dust.li@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
 <20210413031523.73507-9-xuanzhuo@linux.alibaba.com>
 <CAJ8uoz2LzrvZUsDfFuKiFkyRwdWtEk8AF9y7Nb6RKzB7pO3YDw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <93394cbc-ed6a-d07f-7f52-e584b48ca2cd@redhat.com>
Date:   Wed, 14 Apr 2021 15:51:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz2LzrvZUsDfFuKiFkyRwdWtEk8AF9y7Nb6RKzB7pO3YDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/14 下午3:36, Magnus Karlsson 写道:
> On Tue, Apr 13, 2021 at 9:58 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>> xsk is a high-performance packet receiving and sending technology.
>>
>> This patch implements the binding and unbinding operations of xsk and
>> the virtio-net queue for xsk zero copy xmit.
>>
>> The xsk zero copy xmit depends on tx napi. So if tx napi is not true,
>> an error will be reported. And the entire operation is under the
>> protection of rtnl_lock.
>>
>> If xsk is active, it will prevent ethtool from modifying tx napi.
>>
>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
>> ---
>>   drivers/net/virtio_net.c | 78 +++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 77 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index f52a25091322..8242a9e9f17d 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -22,6 +22,7 @@
>>   #include <net/route.h>
>>   #include <net/xdp.h>
>>   #include <net/net_failover.h>
>> +#include <net/xdp_sock_drv.h>
>>
>>   static int napi_weight = NAPI_POLL_WEIGHT;
>>   module_param(napi_weight, int, 0444);
>> @@ -133,6 +134,11 @@ struct send_queue {
>>          struct virtnet_sq_stats stats;
>>
>>          struct napi_struct napi;
>> +
>> +       struct {
>> +               /* xsk pool */
>> +               struct xsk_buff_pool __rcu *pool;
>> +       } xsk;
>>   };
>>
>>   /* Internal representation of a receive virtqueue */
>> @@ -2249,8 +2255,19 @@ static int virtnet_set_coalesce(struct net_device *dev,
>>          if (napi_weight ^ vi->sq[0].napi.weight) {
>>                  if (dev->flags & IFF_UP)
>>                          return -EBUSY;
>> -               for (i = 0; i < vi->max_queue_pairs; i++)
>> +               for (i = 0; i < vi->max_queue_pairs; i++) {
>> +                       /* xsk xmit depend on the tx napi. So if xsk is active,
>> +                        * prevent modifications to tx napi.
>> +                        */
>> +                       rcu_read_lock();
>> +                       if (rcu_dereference(vi->sq[i].xsk.pool)) {
>> +                               rcu_read_unlock();
>> +                               continue;
>> +                       }
>> +                       rcu_read_unlock();
>> +
>>                          vi->sq[i].napi.weight = napi_weight;
>> +               }
>>          }
>>
>>          return 0;
>> @@ -2518,11 +2535,70 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>          return err;
>>   }
>>
>> +static int virtnet_xsk_pool_enable(struct net_device *dev,
>> +                                  struct xsk_buff_pool *pool,
>> +                                  u16 qid)
>> +{
>> +       struct virtnet_info *vi = netdev_priv(dev);
>> +       struct send_queue *sq;
>> +
>> +       if (qid >= vi->curr_queue_pairs)
>> +               return -EINVAL;
> Your implementation is the first implementation that only supports
> zerocopy for one out of Rx and Tx, and this will currently confuse the
> control plane in some situations since it assumes that both Rx and Tx
> are enabled by a call to this NDO. For example: user space creates an
> xsk socket with both an Rx and a Tx ring, then calls bind with the
> XDP_ZEROCOPY flag. In this case, the call should fail if the device is
> virtio-net since it only supports zerocopy for Tx. But it should
> succeed if the user only created a Tx ring since that makes it a
> Tx-only socket which can be supported.
>
> So you need to introduce a new interface in xdp_sock_drv.h that can be
> used to ask if this socket has Rx enabled and if so fail the call (at
> least one of them has to be enabled, otherwise the bind call would
> fail before this ndo is called). Then the logic above will act on that
> and try to fall back to copy mode (if allowed). Such an interface
> (with an added "is_tx_enabled") might in the future be useful for
> physical NIC drivers too if they would like to save on resources for
> Tx-only and Rx-only sockets. Currently, they all just assume every
> socket is Rx and Tx.


So if there's no blocker for implementing the zerocopy RX, I think we'd 
better to implement it in this series without introducing new APIs for 
the upper layer.

Thanks


>
> Thanks: Magnus
>
>> +
>> +       sq = &vi->sq[qid];
>> +
>> +       /* xsk zerocopy depend on the tx napi.
>> +        *
>> +        * xsk zerocopy xmit is driven by the tx interrupt. When the device is
>> +        * not busy, napi will be called continuously to send data. When the
>> +        * device is busy, wait for the notification interrupt after the
>> +        * hardware has finished processing the data, and continue to send data
>> +        * in napi.
>> +        */
>> +       if (!sq->napi.weight)
>> +               return -EPERM;
>> +
>> +       rcu_read_lock();
>> +       /* Here is already protected by rtnl_lock, so rcu_assign_pointer is
>> +        * safe.
>> +        */
>> +       rcu_assign_pointer(sq->xsk.pool, pool);
>> +       rcu_read_unlock();
>> +
>> +       return 0;
>> +}
>> +
>> +static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
>> +{
>> +       struct virtnet_info *vi = netdev_priv(dev);
>> +       struct send_queue *sq;
>> +
>> +       if (qid >= vi->curr_queue_pairs)
>> +               return -EINVAL;
>> +
>> +       sq = &vi->sq[qid];
>> +
>> +       /* Here is already protected by rtnl_lock, so rcu_assign_pointer is
>> +        * safe.
>> +        */
>> +       rcu_assign_pointer(sq->xsk.pool, NULL);
>> +
>> +       synchronize_net(); /* Sync with the XSK wakeup and with NAPI. */
>> +
>> +       return 0;
>> +}
>> +
>>   static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>>   {
>>          switch (xdp->command) {
>>          case XDP_SETUP_PROG:
>>                  return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
>> +       case XDP_SETUP_XSK_POOL:
>> +               if (xdp->xsk.pool)
>> +                       return virtnet_xsk_pool_enable(dev, xdp->xsk.pool,
>> +                                                      xdp->xsk.queue_id);
>> +               else
>> +                       return virtnet_xsk_pool_disable(dev, xdp->xsk.queue_id);
>>          default:
>>                  return -EINVAL;
>>          }
>> --
>> 2.31.0
>>

